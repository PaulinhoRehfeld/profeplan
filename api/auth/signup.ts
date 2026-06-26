// Endpoint server-side de cadastro público.
// Usa supabase.auth.admin.generateLink() para criar o usuário e gerar o link de confirmação,
// depois envia o link via Resend — eliminando completamente o rate limit de e-mail do Supabase.

import type { VercelRequest, VercelResponse } from '@vercel/node';
import { supabaseAdmin } from '../_lib/supabaseAdmin';
import { sendEmailConfirmation } from '../_lib/email';

const APP_URL = process.env.APP_URL || 'https://profeplan.com.br';

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
const GENERIC_SUCCESS = 'Se este e-mail não estiver cadastrado, você receberá um link de confirmação em breve. Verifique também o Spam.';

export default async function handler(req: VercelRequest, res: VercelResponse) {
  setCors(req, res);

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Método não permitido.' });

  const input = parseAndValidate(req.body);
  if (!input) {
    return res.status(400).json({
      error: 'Dados inválidos. Verifique: e-mail válido, nome completo (mín. 2 caracteres), senha (mín. 6 caracteres).',
    });
  }

  const { email, password, fullName } = input;

  try {
    log.info('[Signup] Iniciando cadastro', { email });

    // generateLink cria o usuário e retorna o link de confirmação.
    // O Supabase NÃO envia nenhum e-mail — nós enviamos via Resend.
    const { data: linkData, error: linkError } = await supabaseAdmin.auth.admin.generateLink({
      type: 'signup',
      email,
      password,
      options: {
        redirectTo: `${APP_URL}/login`,
        data: { full_name: fullName },
      },
    });

    if (linkError) {
      const msg = (linkError.message ?? '').toLowerCase();

      // E-mail já cadastrado — retornamos sucesso genérico (não revelamos se existe)
      if (
        msg.includes('already registered') ||
        msg.includes('user already exists') ||
        msg.includes('email address is already') ||
        msg.includes('duplicate')
      ) {
        log.info('[Signup] E-mail já existe, retornando mensagem genérica', { email });
        return res.status(200).json({ success: true, message: GENERIC_SUCCESS });
      }

      log.error('[Signup] Falha ao gerar link de confirmação', { email, error: linkError.message });
      return res.status(500).json({ error: 'Não foi possível criar sua conta. Tente novamente mais tarde.' });
    }

    const actionLink = linkData?.properties?.action_link;
    if (!actionLink) {
      log.error('[Signup] action_link ausente na resposta do Supabase', { email });
      return res.status(500).json({ error: 'Erro interno ao gerar confirmação. Tente novamente.' });
    }

    // Envia e-mail de confirmação pelo nosso próprio serviço (Resend)
    const emailResult = await sendEmailConfirmation({ to: email, fullName, confirmationUrl: actionLink });

    log.audit('SIGNUP_INITIATED', email, {
      emailSent: emailResult.success,
      emailError: emailResult.error,
      platform: 'V4-Vite-App',
    });

    if (!emailResult.success) {
      // Usuário foi criado mas o e-mail falhou — logar para ação manual
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
