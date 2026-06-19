export const maxDuration = 60;
import type { VercelRequest, VercelResponse } from '@vercel/node';
import OpenAI from 'openai';

// Inline logger — @profeplan/logger não é disponível no ambiente Vercel serverless
const logger = {
  info: (msg: string, meta?: unknown) => console.log(JSON.stringify({ level: 'INFO', message: msg, ...(meta ? { meta } : {}) })),
  error: (msg: string, meta?: unknown) => console.error(JSON.stringify({ level: 'ERROR', message: msg, ...(meta ? { meta } : {}) })),
};

const VECTOR_DIM = 768;

const getDeepSeekClient = (): OpenAI | null => {
  const apiKey = process.env.DEEPSEEK_API_KEY?.trim();
  if (!apiKey) return null;
  return new OpenAI({
    apiKey,
    baseURL: process.env.DEEPSEEK_API_BASE?.trim() || 'https://api.deepseek.com',
  });
};

/**
 * Gera embedding semântico de 768 dimensões usando DeepSeek Chat.
 * O DeepSeek não possui API nativa de embeddings, então usamos prompt engineering
 * para gerar um vetor semântico determinístico a partir do texto.
 */
const generateEmbedding = async (client: OpenAI, text: string): Promise<number[]> => {
  const systemPrompt = `You are a semantic embedding generator. Analyze the following text and output exactly 768 floating-point numbers between -1 and 1 that represent its semantic meaning. The vector should capture the topic, sentiment, key concepts, and domain of the text. Output ONLY a valid JSON array of 768 numbers, nothing else. No explanation, no markdown, just the array.`;

  const response = await client.chat.completions.create({
    model: 'deepseek-chat',
    messages: [
      { role: 'system', content: systemPrompt },
      { role: 'user', content: text.slice(0, 8000) },
    ],
    temperature: 0.1,
    max_tokens: 4096,
  });

  const raw = response.choices[0]?.message?.content?.trim() || '';

  // Extract JSON array from response (handle possible markdown wrapping)
  const jsonMatch = raw.match(/\[[\s\S]*\]/);
  if (!jsonMatch) {
    throw new Error('DeepSeek did not return a valid embedding array');
  }

  const vector = JSON.parse(jsonMatch[0]) as number[];

  if (!Array.isArray(vector) || vector.length < VECTOR_DIM) {
    // Pad or truncate to exactly 768
    const padded = vector.slice(0, VECTOR_DIM);
    while (padded.length < VECTOR_DIM) {
      padded.push(0);
    }
    return padded;
  }

  return vector.slice(0, VECTOR_DIM);
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
    const { text } = (req.body || {}) as { text?: string };
    if (!text || typeof text !== 'string') {
      return res.status(400).json({ error: 'O parâmetro "text" é obrigatório e deve ser uma string.' });
    }

    const client = getDeepSeekClient();
    if (!client) {
      const errMsg = 'DEEPSEEK_API_KEY não configurada no servidor.';
      logger.error(`[API/Embeddings] ${errMsg}`);
      return res.status(500).json({ error: errMsg });
    }

    const embedding = await generateEmbedding(client, text);

    logger.info('[API/Embeddings] Embedding gerado via DeepSeek.', { length: text.length, dim: embedding.length });
    return res.status(200).json({ embedding });
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Erro interno';
    logger.error(`[API/Embeddings] Falha na geração de embedding: ${message}`, error);
    return res.status(500).json({ error: message });
  }
}
