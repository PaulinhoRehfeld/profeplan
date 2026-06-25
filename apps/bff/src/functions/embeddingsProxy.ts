import { app, HttpRequest, HttpResponseInit, InvocationContext } from '@azure/functions';
import { GoogleGenerativeAI } from '@google/generative-ai';
import { getSecret } from '../lib/secrets.js';

/**
 * POST /api/ai/embeddings
 * Body: { text: string }
 * Response: { embedding: number[] }   (768 dimensões, modelo text-embedding-004)
 *
 * Sem exigência de JWT — chamado pelo diagnosticService, searchService e AiIngestionService
 * sem cabeçalho Authorization.
 */
export async function embeddingsProxy(
  request: HttpRequest,
  context: InvocationContext
): Promise<HttpResponseInit> {
  context.log('[embeddingsProxy] POST /api/ai/embeddings');

  let text: string;
  try {
    const body = (await request.json()) as { text?: unknown };
    if (!body?.text || typeof body.text !== 'string' || body.text.trim() === '') {
      return {
        status: 400,
        jsonBody: { error: 'Parâmetro "text" é obrigatório e deve ser uma string não-vazia.' },
      };
    }
    text = body.text.trim();
  } catch {
    return {
      status: 400,
      jsonBody: { error: 'Body inválido. Esperado JSON com campo "text".' },
    };
  }

  const apiKey = await getSecret('GEMINI_API_KEY');
  if (!apiKey) {
    context.error('[embeddingsProxy] GEMINI_API_KEY não configurada.');
    return {
      status: 500,
      jsonBody: { error: 'GEMINI_API_KEY não configurada no servidor.' },
    };
  }

  try {
    const genAI = new GoogleGenerativeAI(apiKey);
    const model = genAI.getGenerativeModel({ model: 'text-embedding-004' });
    const result = await model.embedContent(text);
    const embedding = result.embedding.values;

    context.log(`[embeddingsProxy] Embedding gerado: ${embedding.length} dimensões`);

    return {
      status: 200,
      jsonBody: { embedding },
    };
  } catch (error: any) {
    context.error('[embeddingsProxy] Erro ao gerar embedding:', error?.message || error);
    return {
      status: 500,
      jsonBody: { error: `Gemini embedding error: ${error?.message || 'Unknown error'}` },
    };
  }
}

app.http('embeddingsProxy', {
  methods: ['POST'],
  authLevel: 'anonymous',
  handler: embeddingsProxy,
});
