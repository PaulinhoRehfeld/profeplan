export const maxDuration = 60;
import type { VercelRequest, VercelResponse } from '@vercel/node';
import OpenAI from 'openai';

// Inline logger — @profeplan/logger não é disponível no ambiente Vercel serverless
const logger = {
  info: (msg: string, meta?: unknown) => console.log(JSON.stringify({ level: 'INFO', message: msg, ...(meta ? { meta } : {}) })),
  error: (msg: string, meta?: unknown) => console.error(JSON.stringify({ level: 'ERROR', message: msg, ...(meta ? { meta } : {}) })),
  audit: (action: string, actor: string, details?: unknown) => console.log(JSON.stringify({ level: 'AUDIT', action, actor, ...(details ? { details } : {}) })),
};

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

const getAIClient = (): { client: OpenAI; defaultModel: string } | null => {
  const deepseekKey = process.env.DEEPSEEK_API_KEY?.trim();
  const openaiKey = process.env.OPENAI_API_KEY?.trim() || process.env.VITE_OPENAI_API_KEY?.trim();

  if (deepseekKey) {
    return {
      client: new OpenAI({
        apiKey: deepseekKey,
        baseURL: process.env.DEEPSEEK_API_BASE?.trim() || 'https://api.deepseek.com',
      }),
      defaultModel: process.env.OPENAI_MODEL || 'deepseek-chat',
    };
  }

  if (openaiKey) {
    return {
      client: new OpenAI({ apiKey: openaiKey }),
      defaultModel: process.env.OPENAI_MODEL || 'gpt-4o-mini',
    };
  }

  return null;
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

    const ai = getAIClient();
    if (!ai) {
      const errMsg = 'Configuração de IA ausente no backend. Defina DEEPSEEK_API_KEY nas variáveis de ambiente do Vercel.';
      logger.error(`[API/AI] ${errMsg}`);
      return res.status(500).json({ error: errMsg });
    }

    const { client: openai, defaultModel } = ai;
    const modelName = body.model && body.model !== 'backend-ai-proxy' ? body.model : defaultModel;

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

    const completion = await (async () => {
      const MAX_ATTEMPTS = 3;
      for (let attempt = 0; attempt < MAX_ATTEMPTS; attempt++) {
        try {
          return await openai.chat.completions.create(requestOptions);
        } catch (err: any) {
          const is429 = err?.status === 429 || String(err?.message).includes('429');
          if (is429 && attempt < MAX_ATTEMPTS - 1) {
            const delay = 3000 * Math.pow(2, attempt);
            logger.info(`[API/AI] Rate limit — retrying in ${delay}ms (attempt ${attempt + 1}/${MAX_ATTEMPTS})`);
            await new Promise(r => setTimeout(r, delay));
            continue;
          }
          throw err;
        }
      }
    })();

    const text = completion!.choices?.[0]?.message?.content?.toString() || '';

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
