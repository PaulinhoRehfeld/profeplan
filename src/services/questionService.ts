
import { GoogleGenerativeAI } from '@google/generative-ai';
import { supabase } from './supabaseClient';
import { EnemQuestion } from '../types';

// Inicializa o cliente Google AI
const googleAI = new GoogleGenerativeAI(import.meta.env.VITE_GEMINI_API_KEY || '');

// Mapeamento de Áreas para Disciplinas (Normalização)
const AREA_MAP: Record<string, string[]> = {
    'Humanas': ['História', 'Geografia', 'Filosofia', 'Sociologia', 'Ciências Humanas'],
    'Natureza': ['Física', 'Química', 'Biologia', 'Ciências da Natureza'],
    'Linguagens': ['Português', 'Literatura', 'Inglês', 'Espanhol', 'Artes', 'Educação Física', 'Linguagens'],
    'Matemática': ['Matemática']
};

export const searchQuestions = async (query: string, area?: string): Promise<EnemQuestion[]> => {
    try {
        if (!query.trim()) return [];

        console.log(`🔍 Gerando embedding para: "${query}" [Área: ${area || 'Todas'}]`);

        // 1. Gera o embedding da query
        const model = googleAI.getGenerativeModel({ model: "text-embedding-004" });
        const result = await model.embedContent(query);
        const embedding = result.embedding.values;

        console.log('📐 Embedding gerado, chamando RPC...');

        // 2. Chama a RPC no Supabase (Busca mais ampla para filtrar depois)
        const { data, error } = await supabase.rpc('match_questions', {
            query_embedding: embedding,
            match_threshold: 0.35, // Ligeiramente mais estrito
            match_count: 30 // Busca mais para ter margem de filtro
        });

        if (error) {
            console.error('❌ Erro na RPC Supabase:', error);
            throw new Error(error.message);
        }

        let finalQuestions = data as EnemQuestion[];

        // 3. Hidratação de Metadata (se necessário)
        const needsHydration = finalQuestions.some(q => !q.metadata || !q.metadata.alternatives || q.metadata.alternatives.length === 0);

        if (finalQuestions.length > 0 && needsHydration) {
            console.log('⚠️ Hydrating metadata from enem_questions table...');
            const ids = finalQuestions.map(q => q.id);
            const { data: details, error: tableError } = await supabase
                .from('enem_questions')
                .select('id, metadata')
                .in('id', ids);

            if (tableError) console.error("Erro ao hidratar metadata:", tableError);

            if (details) {
                finalQuestions = finalQuestions.map(q => {
                    const detail = details.find((d: any) => d.id === q.id);
                    return { ...q, metadata: detail ? detail.metadata : q.metadata };
                });
            }
        }

        // 4. Filtragem Client-Side por Área
        if (area && finalQuestions.length > 0) {
            const targetDisciplines = AREA_MAP[area] || [];
            if (targetDisciplines.length > 0) {
                console.log(`🎯 Filtrando por Área: ${area} (Disciplinas: ${targetDisciplines.join(', ')})`);

                finalQuestions = finalQuestions.filter(q => {
                    const qDisc = q.metadata?.discipline || '';
                    const qTags = q.metadata?.tags || [];

                    // Verifica se a disciplina da questão está na lista da área alvo
                    // Normaliza para lowercase e remove acentos para comparação segura
                    const normalize = (s: string) => s.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");

                    const isMatch = targetDisciplines.some(td => normalize(qDisc).includes(normalize(td)) || qDisc === td);
                    return isMatch;
                });
            }
        }

        console.log(`✅ ${finalQuestions?.length || 0} questões encontradas (após filtro).`);
        return finalQuestions.slice(0, 10); // Retorna top 10 filtradas

    } catch (error: any) {
        console.error('❌ Erro no serviço searchQuestions:', error);
        throw error;
    }
};
