// Endpoint server-side de cadastro público.
// Chama a Supabase Admin REST API via fetch nativo — sem dependência de @supabase/supabase-js.
// Envia o link de confirmação via Resend, eliminando o rate limit de e-mail do Supabase.

import type { VercelRequest, VercelResponse } from '@vercel/node';
import { sendEmailConfirmation } from '../_lib/email';

// APP_URL controla o redirectTo do link de confirmação.
// Deve ser https://profeplan.com.br em produção.
const APP_URL = process.env.APP_URL || 'https://profeplan.com.br';
const SUPABASE_URL = process.env.SUPABASE_URL || '';
const SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';

const isAllowedOrigin = (origin: string): boolean => {
  if (!origin) return false;
  return (
    origin === 'http://localhost:3000' ||
    origin === 'http://localhost:5173' ||
    origin.endsWith('.profeplan.com.br') ||
    origin === 'https://profeplan.com.br' ||
    origin.endsWith('.vercel.app')
  );
};

const log = {
  info: (msg: string, meta?: unknown) =>
    console.log(JSON.stringify({ level: 'INFO', message: msg, ...(meta ? { meta } : {}) })),
  error: (msg: string, meta?: unknown) =>
    console.error(JSON.stringify({ level: 'ERROR', message: msg, ...(meta ? { meta } : {}) })),
  audit: (action: string, actor: string, details?: unknown) =>
    console.log(JSON.stringify({ level: 'AUDIT', action, actor, ...(details ? { details } : {}) })),
};

function setCors(req: VercelRequest, res: VercelResponse): void {
  const origin = String(req.headers.origin || '');
  if (isAllowedOrigin(origin)) {
    res.setHeader('Access-Control-Allow-Origin', origin);
  }
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
}

interface SignupInput {
  email: string;
  password: string;
  fullName: string;
}

function parseAndValidate(body: unknown): SignupInput | null {
  if (!body || typeof body !== 'object') return null;
  const b = body as Record<string, unknown>;

  const email = String(b.email ?? '').trim().toLowerCase();
  const password = String(b.password ?? '');
  const fullName = String(b.fullName ?? b.full_name ?? '').trim();

  const emailValid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
  const passwordValid = password.length >= 6 && password.length <= 72;
  const nameValid = fullName.length >= 2 && fullName.length <= 120;

  if (!emailValid || !passwordValid || !nameValid) return null;

  return { email, password, fullName };
}

// Mensagem genérica para evitar enumeração de usuários
const GENERIC_SUCCESS =
  'Se este e-mail não estiver cadastrado, você receberá um link de confirmação em breve. Verifique também o Spam.';

export default async function handler(req: VercelRequest, res: VercelResponse) {
  setCors(req, res);

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Método não permitido.' });

  // Checa env vars críticas antes de qualquer operação
  if (!SUPABASE_URL || !SERVICE_KEY) {
    log.error('[Signup] SUPABASE_URL ou SUPABASE_SERVICE_ROLE_KEY ausentes', {
      hasUrl: !!SUPABASE_URL,
      hasKey: !!SERVICE_KEY,
    });
    return res.status(503).json({ error: 'Serviço temporariamente indisponível. Contate o suporte.' });
  }

  const input = parseAndValidate(req.body);
  if (!input) {
    return res.status(400).json({
      error: 'Dados inválidos. Verifique: e-mail válido, nome completo (mín. 2 caracteres), senha (mín. 6 caracteres).',
    });
  }

  const { email, password, fullName } = input;

  try {
    log.info('[Signup] Iniciando cadastro', { email });

    // Chama Supabase Admin REST API diretamente (sem @supabase/supabase-js)
    // generateLink cria o usuário e retorna o link de confirmação sem enviar e-mail.
    const supabaseResp = await fetch(`${SUPABASE_URL}/auth/v1/admin/generate_link`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${SERVICE_KEY}`,
        apikey: SERVICE_KEY,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        type: 'signup',
        email,
        password,
        data: { full_name: fullName },
        // Sempre aponta para o domínio de produção — APP_URL pode estar com URL antiga
        redirect_to: APP_URL.includes('profeplan.com.br')
          ? `${APP_URL}/login`
          : 'https://profeplan.com.br/login',
      }),
    });

    const linkData = (await supabaseResp.json().catch(() => ({}))) as Record<string, unknown>;

    if (!supabaseResp.ok) {
      const rawMsg = String(linkData?.msg ?? linkData?.message ?? linkData?.error_description ?? '').toLowerCase();
      log.error('[Signup] Supabase Admin API erro', {
        email,
        status: supabaseResp.status,
        body: linkData,
      });

      // E-mail já cadastrado — retorna sucesso genérico (não revelamos se existe)
      if (
        rawMsg.includes('already registered') ||
        rawMsg.includes('user already exists') ||
        rawMsg.includes('email address is already') ||
        rawMsg.includes('duplicate') ||
        supabaseResp.status === 422
      ) {
        log.info('[Signup] E-mail já existe, retornando mensagem genérica', { email });
        return res.status(200).json({ success: true, message: GENERIC_SUCCESS });
      }

      // Temporário: expõe erro do Supabase para diagnóstico
      return res.status(500).json({
        error: 'Não foi possível criar sua conta. Tente novamente mais tarde.',
        _debug: { supabaseStatus: supabaseResp.status, supabaseBody: linkData },
      });
    }

    // A resposta do Supabase Admin generate_link tem { action_link, ... }
    const actionLink = String(linkData?.action_link ?? '');
    if (!actionLink) {
      log.error('[Signup] action_link ausente na resposta do Supabase', { email, body: linkData });
      return res.status(500).json({ error: 'Erro interno ao gerar confirmação. Tente novamente.' });
    }

    // Envia e-mail de confirmação pelo nosso próprio serviço (Resend)
    const emailResult = await sendEmailConfirmation({ to: email, fullName, confirmationUrl: actionLink });

    log.audit('SIGNUP_INITIATED', email, {
      emailSent: emailResult.success,
      emailError: emailResult.error ?? null,
      platform: 'V4-Vite-App',
    });

    if (!emailResult.success) {
      log.error('[Signup] ATENÇÃO: usuário criado mas e-mail de confirmação não foi enviado', {
        email,
        error: emailResult.error,
      });
    }

    return res.status(200).json({ success: true, message: GENERIC_SUCCESS });
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : 'Erro interno';
    log.error('[Signup] Erro inesperado', { email, error: message });
    return res.status(500).json({ error: 'Ocorreu um erro inesperado. Tente novamente mais tarde.' });
  }
}
