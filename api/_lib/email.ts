// Serviço centralizado de envio de e-mails via Resend.
// Toda chamada de e-mail no projeto deve passar por este módulo.
// Usa fetch nativo — sem dependências extras.

import {
  confirmationEmailTemplate,
  welcomeEmailTemplate,
  passwordResetTemplate,
  invitationTemplate,
} from './emailTemplates';

const RESEND_API_KEY = process.env.RESEND_API_KEY || '';
const FROM_EMAIL = process.env.SMTP_FROM_EMAIL || 'noreply@profeplan.com.br';
const FROM_NAME = process.env.SMTP_FROM_NAME || 'PROFEPLAN';
const APP_URL = process.env.APP_URL || 'https://profeplan.vercel.app';

const log = {
  info: (msg: string, meta?: unknown) =>
    console.log(JSON.stringify({ level: 'INFO', message: msg, ...(meta ? { meta } : {}) })),
  error: (msg: string, meta?: unknown) =>
    console.error(JSON.stringify({ level: 'ERROR', message: msg, ...(meta ? { meta } : {}) })),
};

interface SendEmailOptions {
  to: string;
  subject: string;
  html: string;
  replyTo?: string;
}

interface EmailResult {
  success: boolean;
  error?: string;
  id?: string;
}

async function sendEmail(opts: SendEmailOptions): Promise<EmailResult> {
  if (!RESEND_API_KEY) {
    log.error('[Email] RESEND_API_KEY não configurada — e-mail não enviado', { to: opts.to });
    return { success: false, error: 'Serviço de e-mail não configurado (RESEND_API_KEY ausente)' };
  }

  try {
    const resp = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${RESEND_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        from: `${FROM_NAME} <${FROM_EMAIL}>`,
        to: [opts.to],
        subject: opts.subject,
        html: opts.html,
        ...(opts.replyTo ? { reply_to: opts.replyTo } : {}),
      }),
    });

    const data = await resp.json().catch(() => ({})) as Record<string, unknown>;

    if (!resp.ok) {
      const errMsg = String(data?.message || `HTTP ${resp.status}`);
      log.error('[Email] Resend retornou erro', { to: opts.to, subject: opts.subject, status: resp.status, error: errMsg });
      return { success: false, error: errMsg };
    }

    log.info('[Email] Enviado com sucesso', { to: opts.to, subject: opts.subject, id: data?.id });
    return { success: true, id: String(data?.id || '') };
  } catch (err) {
    const msg = err instanceof Error ? err.message : 'Erro desconhecido';
    log.error('[Email] Falha ao conectar com Resend', { to: opts.to, error: msg });
    return { success: false, error: msg };
  }
}

// ── Funções públicas ──────────────────────────────────────────────────────────

export async function sendEmailConfirmation(opts: {
  to: string;
  fullName: string;
  confirmationUrl: string;
}): Promise<EmailResult> {
  return sendEmail({
    to: opts.to,
    subject: 'Confirme seu e-mail — PROFEPLAN',
    html: confirmationEmailTemplate({ ...opts, appUrl: APP_URL }),
  });
}

export async function sendWelcomeEmail(opts: {
  to: string;
  fullName: string;
}): Promise<EmailResult> {
  return sendEmail({
    to: opts.to,
    subject: 'Bem-vindo ao PROFEPLAN!',
    html: welcomeEmailTemplate({ ...opts, appUrl: APP_URL }),
  });
}

export async function sendPasswordReset(opts: {
  to: string;
  fullName: string;
  resetUrl: string;
}): Promise<EmailResult> {
  return sendEmail({
    to: opts.to,
    subject: 'Redefinição de senha — PROFEPLAN',
    html: passwordResetTemplate({ ...opts, appUrl: APP_URL }),
  });
}

export async function sendInvitation(opts: {
  to: string;
  inviterName: string;
  inviteUrl: string;
  role: string;
}): Promise<EmailResult> {
  return sendEmail({
    to: opts.to,
    subject: 'Você foi convidado para o PROFEPLAN',
    html: invitationTemplate({ ...opts, appUrl: APP_URL }),
  });
}

export async function sendNotification(opts: {
  to: string;
  subject: string;
  message: string;
}): Promise<EmailResult> {
  return sendEmail({
    to: opts.to,
    subject: opts.subject,
    html: `<div style="font-family:sans-serif;color:#0f172a;padding:24px">${opts.message}</div>`,
  });
}
