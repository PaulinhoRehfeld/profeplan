
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

export const searchQuestions = async (query: string, areas?: string[]): Promise<EnemQuestion[]> => {
    try {
        if (!query.trim()) return [];

        console.log(`🔍 [Hybrid] Iniciando busca para: "${query}" [Áreas: ${areas?.join(', ') || 'Todas'}]`);

        // 1. Gera o embedding da query (Busca Semântica)
        const model = googleAI.getGenerativeModel({ model: "text-embedding-004" });
        const result = await model.embedContent(query);
        const embedding = result.embedding.values;

        // 2. Executa buscas em paralelo: Vetorial (RPC) + Palavra-Chave (Text)
        const [vectorResponse, textResponse] = await Promise.all([
            supabase.rpc('match_questions', {
                query_embedding: embedding,
                match_threshold: 0.35,
                match_count: 100 // Aumentado para 100 para melhorar recall antes do filtro
            }),
            supabase
                .from('enem_questions')
                .select('id, metadata')
                .or(`metadata->>context.ilike.%${query}%, metadata->>alternativesIntroduction.ilike.%${query}%`)
                .limit(20) // Limite de segurança para busca textual
        ]);

        if (vectorResponse.error) {
            console.error('❌ Erro na RPC Supabase:', vectorResponse.error);
            // Não lança erro fatal, tenta usar só o texto se houver
        }

        if (textResponse.error) {
            console.error('❌ Erro na Busca Textual:', textResponse.error);
        }

        const vectorQuestions = (vectorResponse.data as EnemQuestion[]) || [];
        const textQuestions = (textResponse.data as any[] || []).map(row => ({
            id: row.id,
            //  Questões via Select direto já tem o metadata conforme o banco, mas precisamos garantir compatibilidade
            metadata: row.metadata,
            // Adiciona flag para debug se necessário
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
        // A RPC 'match_questions' geralmente retorna colunas completas se configurado assim.
        // Se houver necessidade, mantemos a hidratação apenas para quem falta.
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
                        const detail = details.find((d: any) => d.id === q.id);
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

    } catch (error: any) {
        console.error('❌ Erro no serviço searchQuestions:', error);
        throw error;
    }
};
