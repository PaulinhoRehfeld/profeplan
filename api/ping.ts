import type { VercelRequest, VercelResponse } from '@vercel/node';

// Endpoint de diagnóstico — verifica env vars e testa a Supabase Admin API.
export default async function handler(_req: VercelRequest, res: VercelResponse) {
  const SUPABASE_URL = process.env.SUPABASE_URL || '';
  const SERVICE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';

  const env = {
    SUPABASE_URL_starts: SUPABASE_URL.substring(0, 35),
    SUPABASE_URL_isHttps: SUPABASE_URL.startsWith('https://'),
    SERVICE_KEY_isJwt: SERVICE_KEY.startsWith('eyJ'),
    SERVICE_KEY_starts: SERVICE_KEY.substring(0, 15) + '...',
    RESEND_API_KEY: process.env.RESEND_API_KEY ? '✓' : '✗ AUSENTE',
    APP_URL: process.env.APP_URL || '✗ AUSENTE',
  };

  // Testa a Supabase Admin API (listar 1 usuário)
  let adminTest: Record<string, unknown> = {};
  try {
    const resp = await fetch(`${SUPABASE_URL}/auth/v1/admin/users?page=1&per_page=1`, {
      headers: {
        Authorization: `Bearer ${SERVICE_KEY}`,
        apikey: SERVICE_KEY,
      },
    });
    const body = await resp.json().catch(() => null);
    adminTest = { status: resp.status, ok: resp.ok, body };
  } catch (e) {
    adminTest = { fetchError: String(e) };
  }

  console.log(JSON.stringify({ level: 'INFO', message: '[Ping] health check', env, adminTest }));

  return res.status(200).json({ env, adminTest });
}
