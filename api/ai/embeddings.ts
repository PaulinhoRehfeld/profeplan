export const maxDuration = 30;
import type { VercelRequest, VercelResponse } from '@vercel/node';

const GEMINI_EMBED_URL =
  'https://generativelanguage.googleapis.com/v1beta/models/text-embedding-004:embedContent';

async function generateGeminiEmbedding(text: string): Promise<number[]> {
  const apiKey = process.env.GEMINI_API_KEY?.trim();
  if (!apiKey) throw new Error('GEMINI_API_KEY não configurada no servidor.');

  const response = await fetch(`${GEMINI_EMBED_URL}?key=${apiKey}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      model: 'models/text-embedding-004',
      content: { parts: [{ text }] },
    }),
  });

  if (!response.ok) {
    const body = await response.text().catch(() => response.statusText);
    throw new Error(`Gemini API ${response.status}: ${body}`);
  }

  const data = (await response.json()) as { embedding?: { values?: number[] } };
  const values = data?.embedding?.values;
  if (!values || values.length === 0) {
    throw new Error('Gemini retornou embedding vazio');
  }
  return values;
}

export default async function handler(req: VercelRequest, res: VercelResponse) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method Not Allowed' });

  const { text } = (req.body || {}) as { text?: string };
  if (!text || typeof text !== 'string' || !text.trim()) {
    return res.status(400).json({ error: 'O parâmetro "text" é obrigatório.' });
  }

  try {
    const embedding = await generateGeminiEmbedding(text.slice(0, 10_000));
    return res.status(200).json({ embedding });
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Erro interno';
    console.error('[API/Embeddings]', message);
    return res.status(500).json({ error: message });
  }
}
