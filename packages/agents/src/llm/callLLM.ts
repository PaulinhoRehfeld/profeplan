// ============================================================================
// PROFEPLAN — callLLM: chamada de provider real, extraída de api/ai.ts
// Lógica idêntica à do endpoint /api/ai (o único caminho comprovadamente real
// em produção) — sem depender de VercelRequest/VercelResponse, para poder
// ser chamada tanto pela function HTTP quanto diretamente pelos agentes.
// ============================================================================

import OpenAI from 'openai';
import Anthropic from '@anthropic-ai/sdk';

export type ChatMessage = {
  role: 'system' | 'user' | 'assistant';
  content: string;
};

export type CallLLMOptions = {
  model?: string;
  temperature?: number;
  max_tokens?: number;
};

type AIProvider = {
  type: 'claude' | 'openai' | 'deepseek';
  client: OpenAI | Anthropic;
  defaultModel: string;
};

/** Detecta o provider configurado via env vars — mesma prioridade de api/ai.ts. */
export const getAIProvider = (): AIProvider | null => {
  const anthropicKey = process.env.ANTHROPIC_API_KEY?.trim();
  if (anthropicKey) {
    return {
      type: 'claude',
      client: new Anthropic({ apiKey: anthropicKey }),
      defaultModel: process.env.CLAUDE_MODEL || 'claude-sonnet-4-20250514',
    };
  }

  const deepseekKey = process.env.DEEPSEEK_API_KEY?.trim();
  if (deepseekKey) {
    return {
      type: 'deepseek',
      client: new OpenAI({
        apiKey: deepseekKey,
        baseURL: process.env.DEEPSEEK_API_BASE?.trim() || 'https://api.deepseek.com',
      }),
      defaultModel: process.env.OPENAI_MODEL || 'deepseek-chat',
    };
  }

  const openaiKey = process.env.OPENAI_API_KEY?.trim() || process.env.VITE_OPENAI_API_KEY?.trim();
  if (openaiKey) {
    return {
      type: 'openai',
      client: new OpenAI({ apiKey: openaiKey }),
      defaultModel: process.env.OPENAI_MODEL || 'gpt-4o-mini',
    };
  }

  return null;
};

const callClaude = async (
  anthropic: Anthropic,
  modelName: string,
  messages: ChatMessage[],
  opts: CallLLMOptions,
): Promise<string> => {
  const systemMessages = messages.filter((m) => m.role === 'system').map((m) => m.content);
  const conversationMessages = messages
    .filter((m) => m.role !== 'system')
    .map((m) => ({ role: m.role as 'user' | 'assistant', content: m.content }));

  const params: Anthropic.Messages.MessageCreateParamsNonStreaming = {
    model: modelName,
    max_tokens: opts.max_tokens || 4096,
    messages: conversationMessages,
  };
  if (systemMessages.length > 0) params.system = systemMessages.join('\n\n');
  if (typeof opts.temperature === 'number') params.temperature = opts.temperature;

  const MAX_ATTEMPTS = 3;
  let completion: Anthropic.Messages.Message | undefined;
  for (let attempt = 0; attempt < MAX_ATTEMPTS; attempt++) {
    try {
      completion = await anthropic.messages.create(params);
      break;
    } catch (err: any) {
      const is429 = err?.status === 429 || String(err?.message).includes('429') || String(err?.message).includes('rate_limit');
      if (is429 && attempt < MAX_ATTEMPTS - 1) {
        await new Promise((r) => setTimeout(r, 5000 * Math.pow(2, attempt)));
        continue;
      }
      throw err;
    }
  }
  if (!completion) throw new Error('Claude retornou resposta vazia após todas as tentativas.');

  const textBlocks = completion.content.filter(
    (block): block is Anthropic.Messages.TextBlock => block.type === 'text',
  );
  return textBlocks.map((b) => b.text).join('\n') || '';
};

const callOpenAICompatible = async (
  client: OpenAI,
  providerType: 'openai' | 'deepseek',
  modelName: string,
  messages: ChatMessage[],
  opts: CallLLMOptions,
): Promise<string> => {
  const requestOptions: any = { model: modelName, messages };
  const isReasoner = modelName === 'deepseek-reasoner';
  if (!isReasoner) {
    requestOptions.temperature = typeof opts.temperature === 'number' ? opts.temperature : 0.7;
    if (typeof opts.max_tokens === 'number') requestOptions.max_tokens = opts.max_tokens;
  }

  const MAX_ATTEMPTS = 3;
  for (let attempt = 0; attempt < MAX_ATTEMPTS; attempt++) {
    try {
      const completion = await client.chat.completions.create(requestOptions);
      return completion?.choices?.[0]?.message?.content?.toString() || '';
    } catch (err: any) {
      const is429 = err?.status === 429 || String(err?.message).includes('429');
      if (is429 && attempt < MAX_ATTEMPTS - 1) {
        await new Promise((r) => setTimeout(r, 3000 * Math.pow(2, attempt)));
        continue;
      }
      throw err;
    }
  }
  return '';
};

/**
 * Chama o provider de IA configurado (Claude → DeepSeek → OpenAI, por env var
 * presente). Lança erro se nenhum provider estiver configurado.
 */
export const callLLM = async (
  messages: ChatMessage[],
  opts: CallLLMOptions = {},
): Promise<string> => {
  const provider = getAIProvider();
  if (!provider) {
    throw new Error(
      'Nenhum provedor de IA configurado. Defina ANTHROPIC_API_KEY, DEEPSEEK_API_KEY ou OPENAI_API_KEY.',
    );
  }

  const modelName = (opts.model && opts.model !== 'backend-ai-proxy' ? opts.model : undefined) || provider.defaultModel;

  if (provider.type === 'claude') {
    return callClaude(provider.client as Anthropic, modelName, messages, opts);
  }
  return callOpenAICompatible(provider.client as OpenAI, provider.type, modelName, messages, opts);
};
