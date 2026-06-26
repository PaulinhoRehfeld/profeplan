// Criação de usuário por administradores do sistema.
// Usa service_role — usuário é criado já confirmado (sem e-mail de confirmação).
// Envia opcionalmente um e-mail de boas-vindas via Resend.

import type { VercelRequest, VercelResponse } from '@vercel/node';
import { supabaseAdmin } from '../_lib/supabaseAdmin';
import { sendWelcomeEmail } from '../_lib/email';

const APP_URL = process.env.APP_URL || 'https://profeplan.vercel.app';
const ALLOWED_ORIGINS = [APP_URL, 'http://localhost:3000', 'http://localhost:5173'];

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
  if (ALLOWED_ORIGINS.includes(origin)) {
    res.setHeader('Access-Control-Allow-Origin', origin);
  }
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
}

interface AdminCreateUserBody {
  email: string;
  password: string;
  fullName?: string;
  role: 'teacher' | 'manager' | 'admin';
  schoolId?: string;
  tier?: 'SILVER' | 'GOLD';
  credits?: number;
  sendWelcome?: boolean;
}

function validate(body: unknown): AdminCreateUserBody | null {
  if (!body || typeof body !== 'object') return null;
  const b = body as Record<string, unknown>;

  const email = String(b.email ?? '').trim().toLowerCase();
  const password = String(b.password ?? '');
  const role = String(b.role ?? 'teacher') as AdminCreateUserBody['role'];

  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) return null;
  if (password.length < 6) return null;
  if (!['teacher', 'manager', 'admin'].includes(role)) return null;

  return {
    email,
    password,
    fullName: String(b.fullName ?? b.full_name ?? '').trim() || undefined,
    role,
    schoolId: String(b.schoolId ?? b.school_id ?? '').trim() || undefined,
    tier: (b.tier === 'GOLD' ? 'GOLD' : 'SILVER') as AdminCreateUserBody['tier'],
    credits: typeof b.credits === 'number' ? b.credits : 10,
    sendWelcome: b.sendWelcome !== false,
  };
}

async function verifyAdminToken(req: VercelRequest): Promise<{ id: string; email: string } | null> {
  const authHeader = String(req.headers.authorization || '');
  const token = authHeader.replace('Bearer ', '').trim();
  if (!token) return null;

  const { data: { user }, error } = await supabaseAdmin.auth.getUser(token);
  if (error || !user) return null;

  // Verifica se o usuário é admin no perfil
  const { data: profile } = await supabaseAdmin
    .from('profiles')
    .select('role, is_admin')
    .eq('id', user.id)
    .single();

  if (!profile || (profile.role !== 'admin' && !profile.is_admin)) return null;

  return { id: user.id, email: user.email ?? '' };
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  setCors(req, res);

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Método não permitido.' });

  // Verifica autenticação do admin
  const adminUser = await verifyAdminToken(req);
  if (!adminUser) {
    return res.status(403).json({ error: 'Acesso negado. Apenas administradores podem criar usuários.' });
  }

  const body = validate(req.body);
  if (!body) {
    return res.status(400).json({ error: 'Dados inválidos. Verifique e-mail, senha (mín. 6 caracteres) e função.' });
  }

  const { email, password, fullName = '', role, schoolId, tier = 'SILVER', credits = 10, sendWelcome } = body;

  try {
    log.info('[AdminCreateUser] Criando usuário', { email, role, createdBy: adminUser.email });

    // Cria usuário já confirmado — sem e-mail de confirmação
    const { data: authData, error: authError } = await supabaseAdmin.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      user_metadata: { full_name: fullName, role },
    });

    if (authError) {
      const msg = (authError.message ?? '').toLowerCase();
      if (msg.includes('already registered') || msg.includes('already exists')) {
        return res.status(409).json({ error: 'Este e-mail já está cadastrado.' });
      }
      log.error('[AdminCreateUser] Falha ao criar usuário no Auth', { email, error: authError.message });
      return res.status(500).json({ error: 'Erro ao criar usuário. Tente novamente.' });
    }

    const userId = authData.user?.id;
    if (!userId) {
      return res.status(500).json({ error: 'Erro inesperado: usuário não retornou ID.' });
    }

    // Upsert do perfil
    const { error: profileError } = await supabaseAdmin.from('profiles').upsert(
      {
        id: userId,
        email,
        role,
        tier,
        credits,
        is_unlimited: tier === 'GOLD',
        is_admin: role === 'admin',
        school_id: schoolId || null,
        allowed_features: ['all'],
      },
      { onConflict: 'id' }
    );

    if (profileError) {
      log.error('[AdminCreateUser] Falha no perfil', { userId, error: profileError.message });
      // Usuário criado no Auth mas perfil falhou — logar para correção manual
    }

    // authorized_users para compatibilidade
    await supabaseAdmin.from('authorized_users').upsert(
      { id: userId, email, access_key: password, role },
      { onConflict: 'id' }
    );

    // E-mail de boas-vindas opcional
    if (sendWelcome && fullName) {
      await sendWelcomeEmail({ to: email, fullName });
    }

    log.audit('ADMIN_USER_CREATED', adminUser.email, { targetEmail: email, role, tier });

    return res.status(201).json({
      success: true,
      userId,
      message: `Usuário ${email} criado com sucesso.`,
    });
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : 'Erro interno';
    log.error('[AdminCreateUser] Erro inesperado', { email, error: message });
    return res.status(500).json({ error: 'Erro inesperado. Verifique os logs.' });
  }
}
