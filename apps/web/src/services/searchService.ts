
import { supabase } from "./supabaseClient";
import { getAuthHeaders } from "./sessionService";

interface HybridSearchParams {
    textoBusca: string;
    disciplina?: string | null;
    nivel?: string | null;
    limit?: number;
    matchThreshold?: number;
}

type SearchResultRow = {
    id: number;
    metadata?: {
        alternatives?: unknown[];
    };
};

type SearchDetailRow = {
    id: number;
    metadata: unknown;
};

export const hybridSearchProfeplan = async ({
    textoBusca,
    disciplina = null,
    nivel = null,
    limit = 10,
    matchThreshold = 0.5
}: HybridSearchParams) => {
    // Semantic/hybrid search baseada em Gemini foi desativada.
    // Mantemos apenas a chamada RPC usando texto simples, se disponível,
    // caso contrário retornamos lista vazia para cair em outros fluxos.
    try {
        const { data, error } = await supabase.rpc('buscar_questoes_profeplan', {
            query_text: textoBusca,
            match_threshold: matchThreshold,
            match_count: limit,
            filtro_disciplina: disciplina,
            filtro_nivel: nivel
        });

        if (error) {
            console.error("Erro na busca híbrida:", error);
            throw error;
        }

        let finalResults = (data as SearchResultRow[] | null) || [];

        // SE o RPC não retornar 'metadata' completo, buscamos manualmente
        const needsHydration = finalResults.some((q) => !q.metadata || !(q.metadata.alternatives as unknown[] | undefined)?.length);

        if (finalResults.length > 0 && needsHydration) {
            const ids = finalResults.map((q) => q.id);

            // Fetch metadata directly from enem_questions
            let { data: details, error: tableError } = await supabase
                .from('enem_questions')
                .select('id, metadata')
                .in('id', ids);

            if (details) {
                finalResults = finalResults.map((q) => {
                    const detail = (details as SearchDetailRow[]).find((d) => d.id === q.id);
                    return {
                        ...q,
                        metadata: detail ? detail.metadata : q.metadata
                    };
                });
            }
        }

        return finalResults;

    } catch (error) {
        console.error("Erro ao realizar busca híbrida:", error);
        throw error;
    }
};

export const searchCurriculum = async (
    queryText: string,
    filters?: { disciplina?: string; ano?: string; periodo?: string },
    limit: number = 5,
    matchThreshold: number = 0.5
) => {
    try {
        const authHeaders = await getAuthHeaders();
        const response = await fetch("/api/searchProxy", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                ...authHeaders
            },
            body: JSON.stringify({
                queryText,
                filters,
                limit,
                matchThreshold
            })
        });

        if (!response.ok) {
            console.warn(`[searchService] searchProxy retornou ${response.status} — usando fallback direto.`);
            throw new Error(`HTTP ${response.status}`);
        }

        const data = await response.json();
        return data || [];
    } catch (error) {
        // Fallback: busca textual direta no Supabase (RPC criada pela migration 20260623)
        try {
            const { data, error: rpcError } = await supabase.rpc('search_curriculum_rag', {
                query_text: queryText,
                match_threshold: matchThreshold,
                match_count: limit,
                filter_disciplina: filters?.disciplina || null,
                filter_ano: filters?.ano || null,
                filter_periodo: filters?.periodo || null
            });
            if (rpcError) {
                console.warn('[searchService] Fallback RPC também falhou — sem currículo no contexto.');
                return [];
            }
            return data || [];
        } catch {
            return [];
        }
    }
};

export const getDeterministicCurriculum = async (
    disciplina: string,
    periodo: string,
    ano?: string
) => {
    try {
        const { data, error } = await supabase.rpc('get_curriculo_completo', {
            p_disciplina: disciplina,
            p_periodo: periodo,
            p_ano_escolar: ano || null
        });

        if (error) throw error;
        return data || '';
    } catch (error) {
        console.error("Erro ao buscar currículo completo:", error);
        return null;
    }
};

export const searchPnldBookContent = async (
    queryText: string,
    filters?: { livro_titulo?: string; disciplina?: string },
    limit: number = 5,
    matchThreshold: number = 0.5
) => {
    try {
        const response = await fetch("/api/ai/embeddings", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ text: queryText })
        });
        if (!response.ok) {
            throw new Error(`Embedding API error: ${response.status}`);
        }
        const { embedding } = await response.json();
        if (!embedding) throw new Error("No embedding returned from backend");

        const { data, error } = await supabase.rpc('search_pnld_content', {
            query_embedding: embedding,
            match_threshold: matchThreshold,
            match_count: limit,
            filter_livro_titulo: filters?.livro_titulo || null,
            filter_disciplina: filters?.disciplina || null
        });

        if (error) throw error;
        return data || [];
    } catch (error) {
        console.error("Erro na busca de conteúdo PNLD (Projeto Codex):", error);
        return [];
    }
};

export interface HierarchicalRagResult {
    content: string;
    source: string;
    category: string;
    similarity: number;
    weight: number;
    weightedScore: number;
}

/**
 * Busca RAG Hierárquico: Realiza busca semântica em múltiplos níveis e pondera os scores pelos pesos do PRD.
 */
export const searchHierarchicalRag = async (
    queryText: string,
    userId: string,
    filters?: { disciplina?: string; ano?: string; periodo?: string },
    limit: number = 6
): Promise<HierarchicalRagResult[]> => {
    const results: HierarchicalRagResult[] = [];
    let embedding: number[] | null = null;

    // 1. Tenta gerar embedding do Gemini através do backend
    try {
        const response = await fetch("/api/ai/embeddings", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ text: queryText })
        });
        if (response.ok) {
            const data = await response.json();
            embedding = data.embedding || null;
        }
    } catch (e) {
        console.error("[searchHierarchicalRag] Erro ao obter embedding do backend:", e);
    }

    // 2. Níveis 1, 2 e 3: Busca nos documentos do próprio professor no Supabase
    if (embedding && userId) {
        try {
            const { data: teacherChunks, error } = await supabase.rpc('search_teacher_chunks', {
                p_user_id: userId,
                p_embedding: embedding,
                p_match_threshold: 0.2,
                p_match_count: limit
            });

            if (!error && teacherChunks) {
                for (const chunk of teacherChunks) {
                    let weight = 10;
                    if (chunk.category === 'course_plan') weight = 100;
                    else if (chunk.category === 'book') weight = 50;
                    else if (chunk.category === 'didactic_material') weight = 30;

                    results.push({
                        content: chunk.content,
                        source: chunk.document_title || chunk.category,
                        category: chunk.category,
                        similarity: chunk.similarity || 0.5,
                        weight,
                        weightedScore: (chunk.similarity || 0.5) * weight
                    });
                }
            }
        } catch (e) {
            console.error("[searchHierarchicalRag] Erro ao pesquisar chunks do professor:", e);
        }
    } else if (userId) {
        // Fallback básico de busca textual simples em caso de falha de embeddings
        try {
            const { data: docs } = await supabase
                .from('teacher_documents')
                .select('id, title, category, teacher_document_chunks(content)')
                .eq('user_id', userId)
                .eq('status', 'approved');

            if (docs) {
                for (const doc of docs) {
                    let weight = 10;
                    if (doc.category === 'course_plan') weight = 100;
                    else if (doc.category === 'book') weight = 50;
                    else if (doc.category === 'didactic_material') weight = 30;

                    const chunks = (doc as any).teacher_document_chunks || [];
                    for (const chunk of chunks) {
                        if (chunk.content.toLowerCase().includes(queryText.toLowerCase())) {
                            results.push({
                                content: chunk.content,
                                source: doc.title,
                                category: doc.category,
                                similarity: 0.7,
                                weight,
                                weightedScore: 0.7 * weight
                            });
                        }
                    }
                }
            }
        } catch (e) {
            console.error("[searchHierarchicalRag] Erro no fallback textual:", e);
        }
    }

    // 3. Nível 4: Busca no currículo oficial SEE/MG / BNCC geral (Base Geral do PROFEPLAN)
    try {
        const generalResults = await searchCurriculum(queryText, filters, limit, 0.3);
        if (generalResults && Array.isArray(generalResults)) {
            for (const item of generalResults) {
                const similarity = item.similarity || 0.5;
                results.push({
                    content: item.content,
                    source: item.fonte || 'SEE/MG',
                    category: 'general_curriculum',
                    similarity,
                    weight: 10,
                    weightedScore: similarity * 10
                });
            }
        }
    } catch (e) {
        console.error("[searchHierarchicalRag] Erro ao buscar currículo geral:", e);
    }

    // 4. Ordena os resultados agregados pela pontuação ponderada final (decrescente)
    results.sort((a, b) => b.weightedScore - a.weightedScore);

    // Retorna os top chunks
    return results.slice(0, limit);
};

