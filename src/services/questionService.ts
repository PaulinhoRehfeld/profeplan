
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

const getErrorMessage = (error: unknown): string =>
    error instanceof Error ? error.message : 'Unknown error';

type EnemQuestionRow = {
    id: number;
    metadata: EnemQuestion['metadata'];
    content?: string;
    embedding?: any;
};

export const searchQuestions = async (query: string, areas?: string[]): Promise<EnemQuestion[]> => {
    try {
        if (!query.trim()) return [];

        console.log(`🔍 [Text Search] Iniciando busca para: "${query}" [Áreas: ${areas?.join(', ') || 'Todas'}]`);

        // TEMPORARY FIX: Using text-only search (embeddings API unavailable)
        // Database schema: enem_questions has 'metadata' JSONB column, not individual fields
        // Primary search: 'content' field contains full question text (most effective)
        // Secondary: metadata->>context and metadata->>alternativesIntroduction
        
        // Build search query for multiple fields
        const searchPattern = `%${query}%`;
        
        const textResponse = await supabase
            .from('enem_questions')
            .select('*')
            .ilike('content', searchPattern)
            .limit(50); // Increased limit for text-only search
        
        // Dummy vector response for compatibility
        const vectorResponse = { data: [], error: null };

        if (vectorResponse.error) {
            console.error('❌ Erro na RPC Supabase:', vectorResponse.error);
            // Não lança erro fatal, tenta usar só o texto se houver
        }

        if (textResponse.error) {
            console.error('❌ Erro na Busca Textual:', textResponse.error);
        }

        const vectorQuestions = (vectorResponse.data as EnemQuestion[]) || [];
        const textQuestions = ((textResponse.data as EnemQuestionRow[] | null) || []).map(row => ({
            id: row.id,
            metadata: row.metadata,
            _source: 'text'
        })) as EnemQuestion[];

        console.log(`📊 Stats: Vetorial=${vectorQuestions.length}, Textual=${textQuestions.length}`);

        // 3. Merge e Deduplicação
        const combinedMap = new Map<number, EnemQuestion>();

        // Prioridade para Vetorial (pontuação de similaridade implícita na ordem)
        vectorQuestions.forEach(q => combinedMap.set(q.id, q));
        // Adiciona Textual (se não existir, é um ganho de recall)
        textQuestions.forEach(q => {
            if (!combinedMap.has(q.id)) {
                combinedMap.set(q.id, q);
            }
        });

        let finalQuestions = Array.from(combinedMap.values());

        // 4. Hidratação de Metadata 
        // Nota: Se a busca vetorial retornar partial objects (dependendo da RPC), hidratamos.
        // Se a busca textual selecionou 'metadata', já temos.
        const needsHydration = finalQuestions.some(q => !q.metadata || !q.metadata.alternatives);


        if (needsHydration && finalQuestions.length > 0) {
            console.log('⚠️ Hydrating metadata...');
            const ids = finalQuestions.filter(q => !q.metadata || !q.metadata.alternatives).map(q => q.id);

            if (ids.length > 0) {
                const { data: details } = await supabase
                    .from('enem_questions')
                    .select('id, metadata')
                    .in('id', ids);

                if (details) {
                    finalQuestions = finalQuestions.map(q => {
                        const detail = details.find((d: EnemQuestionRow) => d.id === q.id);
                        return detail ? { ...q, metadata: detail.metadata } : q;
                    });
                }
            }
        }

        // 5. Filtragem Client-Side por Área(s)
        if (areas && areas.length > 0 && finalQuestions.length > 0) {
            const targetDisciplines = areas.flatMap(area => AREA_MAP[area] || []);

            if (targetDisciplines.length > 0) {
                console.log(`🎯 Filtrando por Disciplinas: ${targetDisciplines.join(', ')}`);

                finalQuestions = finalQuestions.filter(q => {
                    // Check both possible keys
                    const qDisc = q.metadata?.discipline || q.metadata?.disciplina || '';

                    // Improved normalization: remove accents, lowercase, AND remove non-alphanumeric chars (like hyphens)
                    const normalize = (s: string) => s.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "").replace(/[^a-z0-9]/g, "");

                    const normalizedDisc = normalize(qDisc);

                    const isMatch = targetDisciplines.some(td => {
                        const normalizedTd = normalize(td);
                        return normalizedDisc.includes(normalizedTd) || normalizedTd.includes(normalizedDisc);
                    });

                    return isMatch;
                });
            }
        }

        console.log(`✅ ${finalQuestions.length} questões retornadas após merge e filtros.`);
        return finalQuestions.slice(0, 15); // Retorna top 15 combinadas

    } catch (error: unknown) {
        console.error('❌ Erro no serviço searchQuestions:', error);
        throw new Error(getErrorMessage(error));
    }
};
