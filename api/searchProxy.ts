export const maxDuration = 60;
import type { VercelRequest, VercelResponse } from '@vercel/node';

/**
 * Proxy de busca de currículo: encaminha a requisição para o Azure BFF (searchProxy).
 * Requer a variável de ambiente BFF_BASE_URL apontando para o Azure Function App,
 * ex: https://profeplan-bff.azurewebsites.net/api
 */
export default async function handler(req: VercelRequest, res: VercelResponse) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method Not Allowed' });
  }

  const bffBaseUrl = process.env.BFF_BASE_URL?.trim();

  if (!bffBaseUrl) {
    console.error('[searchProxy] BFF_BASE_URL não configurado nas variáveis de ambiente do Vercel.');
    return res.status(500).json({ error: 'Search service not configured. BFF_BASE_URL is missing.' });
  }

  const targetUrl = `${bffBaseUrl}/searchProxy`;

  try {
    const upstreamRes = await fetch(targetUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...(req.headers['authorization'] ? { Authorization: req.headers['authorization'] as string } : {}),
      },
      body: JSON.stringify(req.body),
    });

    const contentType = upstreamRes.headers.get('content-type') || '';
    const data = contentType.includes('application/json') ? await upstreamRes.json() : await upstreamRes.text();

    return res.status(upstreamRes.status).json(data);
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Upstream fetch error';
    console.error(`[searchProxy] Erro ao encaminhar para o BFF: ${message}`, error);
    return res.status(502).json({ error: `Search proxy upstream error: ${message}` });
  }
}
