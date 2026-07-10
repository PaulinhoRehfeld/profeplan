export const maxDuration = 60;
import type { VercelRequest, VercelResponse } from '@vercel/node';
import { callLLM, getAIProvider, type ChatMessage } from '@profeplan/agents';

// ── Logger ──
const logger = {
  info: (msg: string, meta?: unknown) => console.log(JSON.stringify({ level: 'INFO', message: msg, ...(meta ? { meta } : {}) })),
  error: (msg: string, meta?: unknown) => console.error(JSON.stringify({ level: 'ERROR', message: msg, ...(meta ? { meta } : {}) })),
  audit: (action: string, actor: string, details?: unknown) => console.log(JSON.stringify({ level: 'AUDIT', action, actor, ...(details ? { details } : {}) })),
};

// ── Types ──
type Body = {
  messages?: ChatMessage[];
  temperature?: number;
  max_tokens?: number;
  model?: string;
};

// ── Main Handler ──
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

    const provider = getAIProvider();
    if (!provider) {
      const errMsg = 'Nenhum provedor de IA configurado. Defina ANTHROPIC_API_KEY, DEEPSEEK_API_KEY ou OPENAI_API_KEY nas variáveis de ambiente do Vercel.';
      logger.error(`[API/AI] ${errMsg}`);
      return res.status(500).json({ error: errMsg });
    }

    // Resolve model: usa o do body se for válido, senão o default do provider
    const requestedModel = body.model && body.model !== 'backend-ai-proxy' ? body.model : undefined;
    const modelName = requestedModel || provider.defaultModel;

    logger.info(`[API/AI] Provider: ${provider.type} | Model: ${modelName}`);

    const text = await callLLM(messages, {
      model: modelName,
      temperature: body.temperature,
      max_tokens: body.max_tokens,
    });

    logger.audit('AI_COMPLETION', 'system', {
      provider: provider.type,
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
