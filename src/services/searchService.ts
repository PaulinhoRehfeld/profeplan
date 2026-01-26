
import { GoogleGenerativeAI } from "@google/generative-ai";
import { supabase } from "./supabaseClient";

interface HybridSearchParams {
    textoBusca: string;
    disciplina?: string | null;
    nivel?: string | null;
    limit?: number;
    matchThreshold?: number;
}

export const hybridSearchProfeplan = async ({
    textoBusca,
    disciplina = null,
    nivel = null,
    limit = 10,
    matchThreshold = 0.5
}: HybridSearchParams) => {
    const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();
    if (!apiKey) {
        throw new Error("API Key missing");
    }

    const genAI = new GoogleGenerativeAI(apiKey);
    const model = genAI.getGenerativeModel({ model: "text-embedding-004" });

    try {
        // 1. Transformar a busca do professor em vetor
        const result = await model.embedContent(textoBusca);
        const embedding = result.embedding;

        // 2. Chamar a função 'mágica' no Supabase
        const { data, error } = await supabase.rpc('buscar_questoes_profeplan', {
            query_embedding: embedding.values,
            match_threshold: matchThreshold,
            match_count: limit,
            filtro_disciplina: disciplina,
            filtro_nivel: nivel
        });

        if (error) {
            console.error("Erro na busca híbrida:", error);
            throw error;
        }

        let finalResults = data || [];

        // SE o RPC não retornar 'metadata' completo, buscamos manualmente
        const needsHydration = finalResults.some((q: any) => !q.metadata || !q.metadata.alternatives || q.metadata.alternatives.length === 0);

        if (finalResults.length > 0 && needsHydration) {
            const ids = finalResults.map((q: any) => q.id);

            // Fetch metadata directly from enem_questions
            let { data: details, error: tableError } = await supabase
                .from('enem_questions')
                .select('id, metadata')
                .in('id', ids);

            if (details) {
                finalResults = finalResults.map((q: any) => {
                    const detail = details.find((d: any) => d.id === q.id);
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
    const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();
    if (!apiKey) throw new Error("API Key missing");

    const genAI = new GoogleGenerativeAI(apiKey);
    const model = genAI.getGenerativeModel({ model: "text-embedding-004" });

    try {
        // 1. Embedding (Fast)
        const result = await model.embedContent(queryText);
        const embedding = result.embedding;

        // 2. RPC Call with Timeout (Prevents "2 minute hang")
        const rpcPromise = supabase.rpc('search_curriculum_rag', {
            query_embedding: embedding.values,
            match_threshold: matchThreshold,
            match_count: limit,
            filter_disciplina: filters?.disciplina || null,
            filter_ano: filters?.ano || null,
            filter_periodo: filters?.periodo || null
        });

        const timeoutPromise = new Promise<{ data: any, error: any }>((_, reject) =>
            setTimeout(() => reject(new Error("RAG Timeout")), 15000) // 15s Timeout
        );

        const { data, error } = await Promise.race([rpcPromise, timeoutPromise]) as any;

        if (error) throw error;
        return data || [];

    } catch (error) {
        console.error("Erro ou Timeout na busca de currículo (RAG):", error);
        // Fail gracefully: proceed without context
        return [];
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
