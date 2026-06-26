// Endpoint de diagnóstico — testa se fetch e Supabase Admin API funcionam.
// REMOVER após resolver o problema de signup.
import type { VercelRequest, VercelResponse } from '@vercel/node';

export default async function handler(_req: VercelRequest, res: VercelResponse) {
  const url = process.env.SUPABASE_URL || '';
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY || '';

  const diagnostics: Record<string, unknown> = {
    hasFetch: typeof fetch,
    nodeVersion: process.version,
    supabaseUrl: url ? url.replace(/https:\/\/([^.]+)\..*/, 'https://$1.***') : 'MISSING',
    hasKey: !!key,
  };

  // Testa conectividade com Supabase Admin API (lista 1 usuário)
  try {
    const resp = await fetch(`${url}/auth/v1/admin/users?page=1&per_page=1`, {
      headers: {
        Authorization: `Bearer ${key}`,
        apikey: key,
        'Content-Type': 'application/json',
      },
    });
    const body = await resp.json().catch(() => ({})) as Record<string, unknown>;
    diagnostics.adminApiStatus = resp.status;
    diagnostics.adminApiOk = resp.ok;
    diagnostics.adminApiBodyKeys = Object.keys(body);
  } catch (e) {
    diagnostics.adminApiFetchError = e instanceof Error ? e.message : String(e);
  }

  // Testa o endpoint generate_link com dados fictícios (vai falhar mas mostra o erro)
  try {
    const resp = await fetch(`${url}/auth/v1/admin/generate_link`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${key}`,
        apikey: key,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        type: 'signup',
        email: 'debug-test@profeplan.com.br',
        password: 'Debug123!',
        data: { full_name: 'Debug Test' },
        redirect_to: 'https://profeplan.com.br/login',
      }),
    });
    const body = await resp.json().catch(() => ({})) as Record<string, unknown>;
    diagnostics.generateLinkStatus = resp.status;
    diagnostics.generateLinkOk = resp.ok;
    diagnostics.generateLinkBody = body;
  } catch (e) {
    diagnostics.generateLinkFetchError = e instanceof Error ? e.message : String(e);
  }

  return res.status(200).json(diagnostics);
}
