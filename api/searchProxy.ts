export const maxDuration = 60;
import type { VercelRequest, VercelResponse } from '@vercel/node';
import { createClient } from '@supabase/supabase-js';
import OpenAI from 'openai';

const logger = {
  info: (msg: string, meta?: unknown) => console.log(JSON.stringify({ level: 'INFO', message: msg, ...(meta ? { meta } : {}) })),
  error: (msg: string, meta?: unknown) => console.error(JSON.stringify({ level: 'ERROR', message: msg, ...(meta ? { meta } : {}) })),
};

const getSupabaseClient = () => {
  const url = process.env.SUPABASE_URL?.trim() || process.env.VITE_SUPABASE_URL?.trim();
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY?.trim()
    || process.env.SUPABASE_ANON_KEY?.trim()
    || process.env.VITE_SUPABASE_ANON_KEY?.trim();
  if (!url || !key) return null;
  return createClient(url, key, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
};

const getDeepSeekClient = (): { client: OpenAI; model: string } | null => {
  const apiKey = process.env.DEEPSEEK_API_KEY?.trim() || process.env.OPENAI_API_KEY?.trim();
  if (!apiKey) return null;
  const isDeepSeek = apiKey.startsWith('sk-f2a4') || !!process.env.DEEPSEEK_API_KEY;
  const model = isDeepSeek ? 'deepseek-chat' : (process.env.OPENAI_MODEL || 'gpt-4o-mini');
  return {
    client: new OpenAI({
      apiKey,
      baseURL: isDeepSeek ? (process.env.DEEPSEEK_API_BASE?.trim() || 'https://api.deepseek.com') : undefined,
    }),
    model,
  };
};

/**
 * Busca de currículo standalone — usa Supabase diretamente + DeepSeek para rerank.
 * Sem dependência do Azure BFF ou Gemini.
 */
export default async function handler(req: VercelRequest, res: VercelResponse) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method Not Allowed' });
  }

  // 1. Parse request body
  let queryText = '';
  let filters: { disciplina?: string; ano?: string; periodo?: string } = {};
  let limit = 5;
  let matchThreshold = 0.3;

  try {
    const body = req.body as any;
    queryText = body?.queryText || '';
    filters = body?.filters || {};
    limit = body?.limit ?? 5;
    matchThreshold = body?.matchThreshold ?? 0.3;
  } catch {
    return res.status(400).json({ error: 'Invalid JSON body' });
  }

  if (!queryText.trim()) {
    return res.status(400).json({ error: 'Parameter "queryText" is required' });
  }

  // 2. Connect to Supabase
  const supabase = getSupabaseClient();
  if (!supabase) {
    logger.error('[searchProxy] SUPABASE_URL ou SUPABASE_SERVICE_ROLE_KEY não configurados.');
    return res.status(500).json({ error: 'Search service not configured. Missing Supabase credentials.' });
  }

  try {
    // 3. Execute RPC de busca textual (não requer embeddings)
    const { data, error: rpcError } = await supabase.rpc('search_curriculum_rag', {
      query_text: queryText,
      match_threshold: matchThreshold,
      match_count: Math.min(limit * 3, 30), // busca mais candidatos para rerank
      filter_disciplina: filters.disciplina || null,
      filter_ano: filters.ano || null,
      filter_periodo: filters.periodo || null,
    });

    if (rpcError) {
      logger.error('[searchProxy] Erro na RPC search_curriculum_rag:', rpcError);
      // Return empty results — curriculum search is non-blocking; generation proceeds without it
      return res.status(200).json([]);
    }

    let results = (data || []) as any[];

    // 4. Rerank com DeepSeek (se disponível e houver resultados)
    const deepseek = getDeepSeekClient();
    if (deepseek && results.length > limit) {
      try {
        const candidates = results.map((r: any, i: number) =>
          `[${i}] ${r.disciplina || ''} - ${r.ano_escolar || ''} - ${r.periodo || ''}: ${(r.content || '').slice(0, 500)}`
        ).join('\n\n');

        const response = await deepseek.client.chat.completions.create({
          model: deepseek.model,
          messages: [
            {
              role: 'system',
              content: `You are a curriculum search ranker. Given a teacher's query and candidate curriculum items, return the indices of the ${limit} most relevant items as a JSON array of integers, ordered by relevance (most relevant first). Output ONLY the JSON array, nothing else. Example: [3, 0, 7, 1, 5]`,
            },
            {
              role: 'user',
              content: `Query: "${queryText}"\n\nCandidates:\n${candidates}`,
            },
          ],
          temperature: 0,
          max_tokens: 200,
        });

        const raw = response.choices[0]?.message?.content?.trim() || '';
        const jsonMatch = raw.match(/\[[\d,\s]*\]/);
        if (jsonMatch) {
          const rankedIndices = JSON.parse(jsonMatch[0]) as number[];
          const ranked = rankedIndices
            .map((i: number) => results[i])
            .filter(Boolean)
            .slice(0, limit);
          if (ranked.length > 0) {
            results = ranked;
            logger.info('[searchProxy] Resultados rerankeado via DeepSeek.', { before: data.length, after: results.length });
          }
        }
      } catch (rerankErr) {
        logger.error('[searchProxy] DeepSeek rerank failed, usando resultados originais:', rerankErr);
        results = results.slice(0, limit);
      }
    } else {
      results = results.slice(0, limit);
    }

    return res.status(200).json(results);
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Search error';
    logger.error(`[searchProxy] Erro na busca: ${message}`, error);
    return res.status(500).json({ error: `Search error: ${message}` });
  }
}
