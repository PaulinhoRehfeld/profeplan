import type { VercelRequest, VercelResponse } from '@vercel/node';
import { AzureOpenAI } from 'openai';

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

const getAzureClient = () => {
  const endpoint = process.env.AZURE_OPENAI_ENDPOINT || process.env.VITE_AZURE_OPENAI_ENDPOINT;
  const apiKey = process.env.AZURE_OPENAI_API_KEY || process.env.VITE_AZURE_OPENAI_API_KEY;
  const deployment =
    process.env.AZURE_OPENAI_DEPLOYMENT ||
    process.env.AZURE_OPENAI_DEPLOYMENT_NAME ||
    process.env.VITE_AZURE_OPENAI_DEPLOYMENT ||
    'gpt-4o';

  if (!endpoint || !apiKey) return null;

  const client = new AzureOpenAI({
    endpoint,
    apiKey,
    deployment,
    apiVersion: '2024-02-15-preview',
  });

  return { client, deployment };
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

    const azure = getAzureClient();
    if (!azure) {
      return res.status(500).json({
        error:
          'Configuração de IA ausente no backend. Defina AZURE_OPENAI_ENDPOINT, AZURE_OPENAI_API_KEY e AZURE_OPENAI_DEPLOYMENT.',
      });
    }

    const completion = await azure.client.chat.completions.create({
      model: body.model || azure.deployment,
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

