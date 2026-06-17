export const maxDuration = 60;
import type { VercelRequest, VercelResponse } from '@vercel/node';
import OpenAI from 'openai';
import { logger } from '@profeplan/logger';

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
  const apiKey = process.env.DEEPSEEK_API_KEY?.trim() || process.env.OPENAI_API_KEY?.trim() || process.env.VITE_OPENAI_API_KEY?.trim();
  if (!apiKey) return null;

  const isDeepSeek = apiKey.startsWith('sk-f2a4') || !!process.env.DEEPSEEK_API_KEY;
  const baseURL = isDeepSeek ? (process.env.DEEPSEEK_API_BASE?.trim() || 'https://api.deepseek.com') : undefined;

  return new OpenAI({ apiKey, baseURL });
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
      const errMsg = 'Configuração de IA ausente no backend. Defina DEEPSEEK_API_KEY ou OPENAI_API_KEY nas variáveis de ambiente.';
      logger.error(`[API/AI] ${errMsg}`);
      return res.status(500).json({ error: errMsg });
    }

    const modelName = body.model && body.model !== 'backend-ai-proxy' ? body.model : (process.env.OPENAI_MODEL || 'gpt-4o-mini');

    logger.info(`[API/AI] Iniciando geração de completion. Modelo: ${modelName}`);

    const requestOptions: any = {
      model: modelName,
      messages: messages as any,
    };

    const isReasoner = modelName === 'deepseek-reasoner';
    if (!isReasoner) {
      requestOptions.temperature = typeof body.temperature === 'number' ? body.temperature : 0.7;
      if (typeof body.max_tokens === 'number') {
        requestOptions.max_tokens = body.max_tokens;
      }
    }

    const completion = await openai.chat.completions.create(requestOptions);


    const text = completion.choices?.[0]?.message?.content?.toString() || '';

    logger.audit('AI_COMPLETION', 'system', {
      model: modelName,
      success: true,
      promptLength: JSON.stringify(messages).length,
      responseLength: text.length
    });

    return res.status(200).json({ text });
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Internal error';
    logger.error(`[API/AI] Falha na geração de completion: ${message}`, error);
    return res.status(500).json({ error: message });
  }
}
