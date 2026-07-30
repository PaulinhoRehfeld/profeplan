export const maxDuration = 60;
import type { VercelRequest, VercelResponse } from '@vercel/node';
import OpenAI from 'openai';
import Anthropic from '@anthropic-ai/sdk';

// ── Logger ──
const logger = {
  info: (msg: string, meta?: unknown) =>
    console.log(JSON.stringify({ level: 'INFO', message: msg, ...(meta ? { meta } : {}) })),
  error: (msg: string, meta?: unknown) =>
    console.error(JSON.stringify({ level: 'ERROR', message: msg, ...(meta ? { meta } : {}) })),
  audit: (action: string, actor: string, details?: unknown) =>
    console.log(JSON.stringify({ level: 'AUDIT', action, actor, ...(details ? { details } : {}) })),
};

// ── Types ──
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

type AIProvider = {
  type: 'claude' | 'openai' | 'deepseek';
  client: OpenAI | Anthropic;
  defaultModel: string;
};

// ── Provider Detection ──
const getAIProvider = (): AIProvider | null => {
  // O ProfePlan usa DeepSeek como provedor oficial. Não faça fallback silencioso
  // para outro provedor: uma variável ausente deve gerar erro de configuração,
  // não consumir outra conta ou enviar dados ao destino errado.
  const deepseekKey = process.env.DEEPSEEK_API_KEY?.trim();
  if (deepseekKey) {
    return {
      type: 'deepseek',
      client: new OpenAI({
        apiKey: deepseekKey,
        baseURL: process.env.DEEPSEEK_API_BASE?.trim() || 'https://api.deepseek.com',
      }),
      defaultModel: process.env.DEEPSEEK_MODEL?.trim() || 'deepseek-chat',
    };
  }

  return null;
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
      const errMsg = 'DeepSeek não está configurado no servidor. Contate o suporte.';
      logger.error(`[API/AI] ${errMsg}`);
      return res.status(500).json({ error: errMsg });
    }

    // Aceita somente modelos DeepSeek conhecidos. "backend-ai-proxy" é apenas
    // um marcador interno do frontend e nunca deve ser enviado ao provedor.
    const requestedModel =
      body.model === 'deepseek-chat' || body.model === 'deepseek-reasoner'
        ? body.model
        : undefined;
    const modelName = requestedModel || provider.defaultModel;

    logger.info(`[API/AI] Provider: ${provider.type} | Model: ${modelName}`);

    let text: string = '';

    // ═══════════════════════════════════════════
    // CLAUDE (Anthropic SDK)
    // ═══════════════════════════════════════════
    if (provider.type === 'claude') {
      const anthropic = provider.client as Anthropic;

      // Separa system prompt das mensagens (Anthropic exige system no top-level)
      const systemMessages = messages.filter((m) => m.role === 'system').map((m) => m.content);
      const conversationMessages = messages
        .filter((m) => m.role !== 'system')
        .map((m) => ({
          role: m.role as 'user' | 'assistant',
          content: m.content,
        }));

      const anthropicParams: any = {
        model: modelName,
        max_tokens: body.max_tokens || 4096,
        messages: conversationMessages,
      };

      if (systemMessages.length > 0) {
        anthropicParams.system = systemMessages.join('\n\n');
      }

      if (typeof body.temperature === 'number') {
        anthropicParams.temperature = body.temperature;
      }

      const MAX_ATTEMPTS = 3;
      let completion: Anthropic.Messages.Message | undefined;

      for (let attempt = 0; attempt < MAX_ATTEMPTS; attempt++) {
        try {
          completion = await anthropic.messages.create(anthropicParams);
          break;
        } catch (err: any) {
          const is429 =
            err?.status === 429 ||
            String(err?.message).includes('429') ||
            String(err?.message).includes('rate_limit');
          if (is429 && attempt < MAX_ATTEMPTS - 1) {
            const delay = 5000 * Math.pow(2, attempt);
            logger.info(
              `[API/AI] Claude rate limit — retrying in ${delay}ms (attempt ${attempt + 1}/${MAX_ATTEMPTS})`
            );
            await new Promise((r) => setTimeout(r, delay));
            continue;
          }
          throw err;
        }
      }

      if (!completion) {
        throw new Error('Claude retornou resposta vazia após todas as tentativas.');
      }

      // Extrai texto da resposta do Claude
      const textBlocks = completion.content.filter(
        (block): block is Anthropic.Messages.TextBlock => block.type === 'text'
      );
      text = textBlocks.map((b) => b.text).join('\n') || '';
    } else {
      // ═══════════════════════════════════════════
      // OPENAI / DEEPSEEK (OpenAI-compatible SDK)
      // ═══════════════════════════════════════════
      const openai = provider.client as OpenAI;

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

      const MAX_ATTEMPTS = 3;
      for (let attempt = 0; attempt < MAX_ATTEMPTS; attempt++) {
        try {
          const completion = await openai.chat.completions.create(requestOptions);
          text = completion?.choices?.[0]?.message?.content?.toString() || '';
          break;
        } catch (err: any) {
          const is429 = err?.status === 429 || String(err?.message).includes('429');
          if (is429 && attempt < MAX_ATTEMPTS - 1) {
            const delay = 3000 * Math.pow(2, attempt);
            logger.info(
              `[API/AI] ${provider.type} rate limit — retrying in ${delay}ms (attempt ${attempt + 1}/${MAX_ATTEMPTS})`
            );
            await new Promise((r) => setTimeout(r, delay));
            continue;
          }
          throw err;
        }
      }
    }

    logger.audit('AI_COMPLETION', 'system', {
      provider: provider.type,
      model: modelName,
      success: true,
      promptLength: JSON.stringify(messages).length,
      responseLength: text.length,
    });

    return res.status(200).json({ text });
  } catch (error: unknown) {
    const status =
      typeof error === 'object' && error !== null && 'status' in error
        ? Number((error as { status?: unknown }).status)
        : 500;
    const internalMessage = error instanceof Error ? error.message : 'Internal error';
    logger.error(`[API/AI] Falha na geração via DeepSeek: ${internalMessage}`, {
      status,
      provider: 'deepseek',
    });

    const publicMessage =
      status === 401
        ? 'A autenticação do DeepSeek falhou. A configuração do servidor precisa ser atualizada.'
        : status === 429
          ? 'O DeepSeek está temporariamente sobrecarregado. Tente novamente em instantes.'
          : 'Não foi possível gerar o conteúdo com o DeepSeek. Tente novamente.';

    return res.status(status >= 400 && status < 600 ? status : 500).json({
      error: publicMessage,
    });
  }
}
