export const maxDuration = 60;
import type { VercelRequest, VercelResponse } from '@vercel/node';
import OpenAI from 'openai';

type ChatMessage = {
  role: 'system' | 'user' | 'assistant';
  content: string;
};

type Body = {
  messages?: ChatMessage[];
  temperature?: number;
  max_tokens?: number;
  model?: string;
};

const getOpenAIClient = () => {
  const apiKey = process.env.OPENAI_API_KEY || process.env.VITE_OPENAI_API_KEY;
  if (!apiKey) return null;

  return new OpenAI({ apiKey });
};

export default async function handler(req: VercelRequest, res: VercelResponse) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method Not Allowed' });
  }

  try {
    const body = (req.body || {}) as Body;
    const messages = Array.isArray(body.messages) ? body.messages : [];

    if (!messages.length) {
      return res.status(400).json({ error: 'messages é obrigatório' });
    }

    const openai = getOpenAIClient();
    if (!openai) {
      return res.status(500).json({
        error:
          'Configuração de IA ausente no backend. Defina OPENAI_API_KEY nas variáveis de ambiente.',
      });
    }

    const completion = await openai.chat.completions.create({
      model: body.model && body.model !== 'backend-ai-proxy' ? body.model : (process.env.OPENAI_MODEL || 'gpt-4o-mini'),
      messages: messages as any,
      temperature: typeof body.temperature === 'number' ? body.temperature : 0.7,
      max_tokens: typeof body.max_tokens === 'number' ? body.max_tokens : undefined,
    });

    const text = completion.choices?.[0]?.message?.content?.toString() || '';
    return res.status(200).json({ text });
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Internal error';
    console.error('[API/AI]', message);
    return res.status(500).json({ error: message });
  }
}
