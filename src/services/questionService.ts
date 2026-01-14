
import { GoogleGenerativeAI } from '@google/generative-ai';
import { supabase } from './supabaseClient';
import { EnemQuestion } from '../types';

// Inicializa o cliente Google AI
const apiKey = import.meta.env.VITE_GEMINI_API_KEY;

if (!apiKey) {
    console.error("❌ VITE_GEMINI_API_KEY não encontrada! Verifique as variáveis de ambiente.");
} else {
    console.log(`🔑 API Key encontrada (termina com ...${apiKey.slice(-4)})`);
}

const googleAI = new GoogleGenerativeAI(apiKey || '');

export const searchQuestions = async (query: string): Promise<EnemQuestion[]> => {
    try {
        if (!query.trim()) return [];

        console.log('🔍 Gerando embedding para:', query);

        // 1. Gera o embedding da query
        const model = googleAI.getGenerativeModel({ model: "text-embedding-004" });
        const result = await model.embedContent(query);
        const embedding = result.embedding.values;

        console.log('📐 Embedding gerado, chamando RPC...');

        // 2. Chama a RPC no Supabase
        const { data, error } = await supabase.rpc('match_questions', {
            query_embedding: embedding,
            match_threshold: 0.3, // Ajuste conforme necessidade
            match_count: 10
        });

        if (error) {
            console.error('❌ Erro na RPC Supabase:', error);
            throw new Error(error.message);
        }

        let finalQuestions = data as EnemQuestion[];

        // SE o RPC não retornar o campo metadata completo, buscamos o JSON completo na tabela
        const needsHydration = finalQuestions.some(q => !q.metadata || !q.metadata.alternatives || q.metadata.alternatives.length === 0);

        if (finalQuestions.length > 0 && needsHydration) {
            console.log('⚠️ Hydrating metadata from enem_questions table...');
            const ids = finalQuestions.map(q => q.id);

            // A tabela real usa 'metadata' (JSONB) que contém tudo (context, alternatives, etc.)
            let { data: details, error: tableError } = await supabase
                .from('enem_questions')
                .select('id, metadata')
                .in('id', ids);

            if (tableError) {
                console.error("Erro ao hidratar metadata:", tableError);
            }

            if (details) {
                finalQuestions = finalQuestions.map(q => {
                    const detail = details.find((d: any) => d.id === q.id);
                    // Se achou detalhe, substitui o metadata incompleto pelo completo do banco
                    return {
                        ...q,
                        metadata: detail ? detail.metadata : q.metadata
                    };
                });
            }
        }

        console.log(`✅ ${finalQuestions?.length || 0} questões encontradas (com metadata).`);
        return finalQuestions;

    } catch (error: any) {
        console.error('❌ Erro no serviço searchQuestions:', error);
        throw error;
    }
};
