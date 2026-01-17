
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
        const result = await model.embedContent(queryText);
        const embedding = result.embedding;

        const { data, error } = await supabase.rpc('search_curriculum_rag', {
            query_embedding: embedding.values,
            match_threshold: matchThreshold,
            match_count: limit,
            filter_disciplina: filters?.disciplina || null,
            filter_ano: filters?.ano || null,
            filter_periodo: filters?.periodo || null
        });

        if (error) throw error;
        return data || [];

    } catch (error) {
        console.error("Erro na busca de currículo:", error);
        return [];
    }
};
