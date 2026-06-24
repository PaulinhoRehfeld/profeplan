import { app, HttpRequest, HttpResponseInit, InvocationContext } from '@azure/functions';
import { createClient } from '@supabase/supabase-js';
import { GoogleGenerativeAI } from '@google/generative-ai';
import { verifyUserToken } from '../lib/auth.js';
import { getSecret } from '../lib/secrets.js';
import { logger } from '@profeplan/logger';

/**
 * Endpoint searchProxy
 * Faz a busca híbrida/semântica de currículo com canário baseado no perfil do usuário
 * e registra a latência e erros via @profeplan/logger.
 */
export async function searchProxy(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
  context.log(`[searchProxy] Processando busca para a rota: "${request.url}"`);
  const startTime = Date.now();

  // 1. Validar JWT do Usuário
  let userPayload;
  try {
    userPayload = await verifyUserToken(request);
  } catch (error: any) {
    context.warn('[searchProxy] Falha na validação de token:', error?.message || error);
    return {
      status: 401,
      jsonBody: { error: `Unauthorized: ${error?.message || 'Authentication token is invalid or missing'}` },
    };
  }

  const userId = userPayload.sub;
  const userEmail = userPayload.email || '';

  // 2. Extrair parâmetros da busca
  let queryText = '';
  let filters: { disciplina?: string; ano?: string; periodo?: string } = {};
  let limit = 5;
  let matchThreshold = 0.3;

  try {
    const body = (await request.json()) as any;
    queryText = body?.queryText || '';
    filters = body?.filters || {};
    limit = body?.limit ?? 5;
    matchThreshold = body?.matchThreshold ?? 0.3;
  } catch (err) {
    return {
      status: 400,
      jsonBody: { error: 'Invalid json body' },
    };
  }

  if (!queryText.trim()) {
    return {
      status: 400,
      jsonBody: { error: 'Parameter "queryText" is required' },
    };
  }

  let isSemantic = false;

  try {
    // 3. Obter chaves do Supabase
    const supabaseUrl = await getSecret('SUPABASE_URL');
    const supabaseServiceKey = await getSecret('SUPABASE_SERVICE_ROLE_KEY');
    const resolvedKey = supabaseServiceKey ?? await getSecret('SUPABASE_ANON_KEY');

    if (!supabaseServiceKey) {
      context.warn('[searchProxy] SUPABASE_SERVICE_ROLE_KEY não encontrada — usando ANON_KEY como fallback. RPCs de busca podem falhar por falta de privilégios.');
    }

    if (!supabaseUrl || !resolvedKey) {
      throw new Error('Supabase configuration is missing on server');
    }

    const supabaseAdmin = createClient(supabaseUrl, resolvedKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });

    // 4. Verificar Perfil do Usuário para Canário
    const { data: profile, error: profileError } = await supabaseAdmin
      .from('profiles')
      .select('allowed_features')
      .eq('id', userId)
      .single();

    if (profileError) {
      context.warn(`[searchProxy] Falha ao ler perfil do usuário ${userId}: ${profileError.message}`);
    }

    const allowedFeatures = profile?.allowed_features || [];
    isSemantic = allowedFeatures.includes('semantic_curriculum') || allowedFeatures.includes('all');

    let searchResults: any[] = [];

    // 5. Executar Busca
    if (isSemantic) {
      context.log(`[searchProxy] Usuário ${userEmail} elegível para Busca Semântica (Canário)`);
      
      const geminiKey = await getSecret('GEMINI_API_KEY');
      if (!geminiKey) {
        throw new Error('GEMINI_API_KEY is not configured on the server');
      }

      // 5.1 Gerar Embedding usando Gemini
      const genAI = new GoogleGenerativeAI(geminiKey);
      const embeddingModel = genAI.getGenerativeModel({ model: 'text-embedding-04' });
      
      const embeddingResponse = await embeddingModel.embedContent(queryText);
      const embedding = embeddingResponse.embedding?.values;

      if (!embedding || embedding.length === 0) {
        throw new Error('Failed to generate embedding from Gemini API');
      }

      // 5.2 Executar RPC Semântica (pgvector)
      const { data, error: searchError } = await supabaseAdmin.rpc('search_curriculum_semantico', {
        query_embedding: embedding,
        match_threshold: matchThreshold,
        match_count: limit,
        filter_disciplina: filters?.disciplina || null,
        filter_ano: filters?.ano || null,
        filter_periodo: filters?.periodo || null,
      });

      if (searchError) throw searchError;
      searchResults = data || [];
    } else {
      context.log(`[searchProxy] Usuário ${userEmail} usando Busca Textual Padrão`);
      
      // 5.3 Executar RPC de busca textual legada
      const { data, error: searchError } = await supabaseAdmin.rpc('search_curriculum_rag', {
        query_text: queryText,
        match_threshold: matchThreshold,
        match_count: limit,
        filter_disciplina: filters?.disciplina || null,
        filter_ano: filters?.ano || null,
        filter_periodo: filters?.periodo || null,
      });

      if (searchError) throw searchError;
      searchResults = data || [];
    }

    // 6. Registrar Telemetria de Sucesso
    const latencyMs = Date.now() - startTime;
    logger.info(`[RAG Search] Busca de currículo realizada com sucesso`, {
      userId,
      userEmail,
      queryText,
      isSemantic,
      filters,
      resultsCount: searchResults.length,
      latencyMs,
    });

    return {
      status: 200,
      jsonBody: searchResults,
    };
  } catch (error: any) {
    const latencyMs = Date.now() - startTime;
    // 7. Registrar Telemetria de Erro
    logger.error(`[RAG Search] Erro ao realizar busca de currículo: ${error?.message || error}`, {
      userId,
      userEmail,
      queryText,
      isSemantic,
      filters,
      latencyMs,
    });

    return {
      status: 500,
      jsonBody: { error: `Search proxy error: ${error?.message || error}` },
    };
  }
}

app.http('searchProxy', {
  methods: ['POST'],
  authLevel: 'anonymous',
  handler: searchProxy,
});
