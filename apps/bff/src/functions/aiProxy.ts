import { app, HttpRequest, HttpResponseInit, InvocationContext } from '@azure/functions';
import { OpenAI } from 'openai';
import { verifyUserToken } from '../lib/auth.js';
import { getSecret } from '../lib/secrets.js';

/**
 * Endpoint aiProxy
 * Autentica o usuário localmente usando JWT e atua como proxy seguro para OpenAI e Google Gemini.
 */
export async function aiProxy(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
  context.log(`[aiProxy] Processando requisição de IA para a rota: "${request.url}"`);

  // 1. Validação de Autorização (Supabase JWT verificado localmente para performance)
  let userPayload;
  try {
    userPayload = await verifyUserToken(request);
    context.log(`[aiProxy] Usuário autenticado com sucesso: ${userPayload.sub} (Email: ${userPayload.email})`);
  } catch (error: any) {
    context.warn('[aiProxy] Falha na validação de token:', error?.message || error);
    return {
      status: 401,
      jsonBody: { error: `Unauthorized: ${error?.message || 'Authentication token is invalid or missing'}` },
    };
  }

  // 2. Extração dos parâmetros da requisição
  try {
    const body = (await request.json()) as any;
    if (!body || !body.provider) {
      return {
        status: 400,
        jsonBody: { error: 'Missing parameter: provider ("openai" or "gemini")' },
      };
    }

    const { provider, model, messages, options } = body;

    // 3. Roteamento do provedor de IA (DeepSeek padrão, OpenAI como fallback)
    if (provider === 'deepseek' || provider === 'openai' || !provider) {
      const isDeepSeek = provider !== 'openai';
      const apiKey = isDeepSeek
        ? await getSecret('DEEPSEEK_API_KEY')
        : await getSecret('OPENAI_API_KEY');

      if (!apiKey) {
        return {
          status: 500,
          jsonBody: { error: `${isDeepSeek ? 'DEEPSEEK' : 'OPENAI'}_API_KEY não configurada no servidor.` },
        };
      }

      const client = new OpenAI({
        apiKey,
        ...(isDeepSeek ? { baseURL: 'https://api.deepseek.com' } : {}),
      });

      const targetModel = model || (isDeepSeek ? 'deepseek-chat' : 'gpt-4o-mini');

      if (!messages || !Array.isArray(messages)) {
        return {
          status: 400,
          jsonBody: { error: 'Parâmetro "messages" é obrigatório e deve ser um array.' },
        };
      }

      const isReasoner = targetModel === 'deepseek-reasoner';
      const requestOptions: any = { model: targetModel, messages };
      if (!isReasoner) {
        requestOptions.temperature = options?.temperature ?? 0.7;
        if (options?.max_tokens) requestOptions.max_tokens = options.max_tokens;
        if (options?.response_format) requestOptions.response_format = options.response_format;
      }

      const response = await client.chat.completions.create(requestOptions);

      return {
        status: 200,
        jsonBody: response,
      };
    }

    return {
      status: 400,
      jsonBody: { error: `Provider não suportado: "${provider}". Use "deepseek" ou "openai".` },
    };
  } catch (error: any) {
    context.error('[aiProxy] Erro ao processar requisição de IA:', error);
    return {
      status: 500,
      jsonBody: { error: `AI Integration Error: ${error?.message || error}` },
    };
  }
}

app.http('aiProxy', {
  methods: ['POST'],
  authLevel: 'anonymous',
  handler: aiProxy,
});
