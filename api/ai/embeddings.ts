export const maxDuration = 60;
import type { VercelRequest, VercelResponse } from '@vercel/node';
import { GoogleGenerativeAI } from '@google/generative-ai';

// Inline logger — @profeplan/logger não é disponível no ambiente Vercel serverless
const logger = {
  info: (msg: string, meta?: unknown) => console.log(JSON.stringify({ level: 'INFO', message: msg, ...(meta ? { meta } : {}) })),
  error: (msg: string, meta?: unknown) => console.error(JSON.stringify({ level: 'ERROR', message: msg, ...(meta ? { meta } : {}) })),
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

    const apiKey = process.env.GEMINI_API_KEY || process.env.VITE_GEMINI_API_KEY;
    if (!apiKey) {
      const errMsg = 'GEMINI_API_KEY não configurada no servidor.';
      logger.error(`[API/Embeddings] ${errMsg}`);
      return res.status(500).json({ error: errMsg });
    }

    const genAI = new GoogleGenerativeAI(apiKey);
    const model = genAI.getGenerativeModel({ model: 'models/gemini-embedding-001' });
    const result = await model.embedContent(text);
    
    if (!result?.embedding?.values) {
      throw new Error('Retorno vazio do serviço de embedding do Gemini.');
    }

    const embedding = result.embedding.values.slice(0, 768);

    logger.info('[API/Embeddings] Embedding gerado com sucesso.', { length: text.length });
    return res.status(200).json({ embedding });
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Erro interno';
    logger.error(`[API/Embeddings] Falha na geração de embedding: ${message}`, error);
    return res.status(500).json({ error: message });
  }
}
