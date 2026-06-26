import type { VercelRequest, VercelResponse } from '@vercel/node';

// Endpoint de diagnóstico — verifica env vars e saúde da função.
// NÃO expõe valores, apenas presença (✓ / ✗).
export default function handler(_req: VercelRequest, res: VercelResponse) {
  const env = {
    SUPABASE_URL: process.env.SUPABASE_URL ? '✓' : '✗ AUSENTE',
    SUPABASE_SERVICE_ROLE_KEY: process.env.SUPABASE_SERVICE_ROLE_KEY ? '✓' : '✗ AUSENTE',
    RESEND_API_KEY: process.env.RESEND_API_KEY ? '✓' : '✗ AUSENTE',
    APP_URL: process.env.APP_URL || '✗ AUSENTE (default: https://profeplan.com.br)',
    SMTP_FROM_EMAIL: process.env.SMTP_FROM_EMAIL || '✗ AUSENTE',
  };

  const allOk = Object.values(env).every((v) => v.startsWith('✓'));

  console.log(JSON.stringify({ level: 'INFO', message: '[Ping] health check', env }));

  return res.status(200).json({
    ok: allOk,
    ts: new Date().toISOString(),
    region: process.env.VERCEL_REGION || 'local',
    env,
  });
}
