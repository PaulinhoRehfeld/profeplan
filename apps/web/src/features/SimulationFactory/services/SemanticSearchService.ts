/**
 * SEMANTIC SEARCH SERVICE
 * ========================
 * 
 * Busca vetorial usando embeddings do Gemini
 * Fallback automático para busca textual se embedding API falhar
 * 
 * Features:
 * - Geração de embeddings via Gemini
 * - Busca por similaridade vetorial
 * - Busca híbrida (text + semantic)
 * - Fallback robusto
 */

import { GoogleGenerativeAI } from '@google/generative-ai';
import { supabase } from '../../../services/supabaseClient';
import { SimulationQuestion, QuestionDatabaseRow } from '../types/question.types';

const googleAI = new GoogleGenerativeAI(import.meta.env.VITE_GEMINI_API_KEY || '');

class SemanticSearchService {
    private embeddingModel = 'text-embedding-004';
    private isAvailable: boolean = true; // Flag para controlar disponibilidade

    /**
     * Gera embedding para uma query
     */
    async generateEmbedding(text: string): Promise<number[] | null> {
        // Se API já falhou anteriormente, não tentar novamente
        if (!this.isAvailable) {
            console.log('[Semantic] ⚠️ Embedding API unavailable, skipping');
            return null;
        }

        try {
            const model = googleAI.getGenerativeModel({ model: this.embeddingModel });
            const result = await model.embedContent(text);

            if (result.embedding && result.embedding.values) {
                console.log(`[Semantic] ✅ Generated ${result.embedding.values.length}D embedding`);
                return result.embedding.values;
            }

            return null;
        } catch (error) {
            console.warn('[Semantic] ⚠️ Embedding generation failed:', error);
            this.isAvailable = false; // Marcar como indisponível
            return null;
        }
    }

    /**
     * Busca semântica por similaridade vetorial
     */
    async searchSemantic(
        query: string,
        limit: number = 15,
        threshold: number = 0.5
    ): Promise<SimulationQuestion[]> {
        try {
            // 1. Gerar embedding da query
            const queryEmbedding = await this.generateEmbedding(query);

            if (!queryEmbedding) {
                console.log('[Semantic] ⚠️ No embedding - falling back to text search');
                return [];
            }

            // 2. Buscar questões similares via RPC
            const { data, error } = await supabase.rpc('match_questions_semantic', {
                query_embedding: queryEmbedding,
                match_threshold: threshold,
                match_count: limit
            });

            if (error) {
                console.error('[Semantic] ❌ RPC error:', error.message);
                return [];
            }

            if (!data || data.length === 0) {
                console.log('[Semantic] ℹ️ No semantic results found');
                return [];
            }

            // 3. Mapear para SimulationQuestion
            const questions: SimulationQuestion[] = data.map((row: any) => ({
                id: row.id,
                similarity: row.similarity,
                metadata: row.metadata
            }));

            console.log(`[Semantic] ✅ Found ${questions.length} semantic matches`);

            return questions;

        } catch (error) {
            console.error('[Semantic] ❌ Search error:', error);
            return [];
        }
    }

    /**
     * Busca híbrida (combina text + semantic)
     * Usa os melhores resultados de ambas as estratégias
     */
    async searchHybrid(
        query: string,
        textResults: SimulationQuestion[],
        limit: number = 15
    ): Promise<SimulationQuestion[]> {
        try {
            // 1. Busca semântica
            const semanticResults = await this.searchSemantic(query, limit);

            if (semanticResults.length === 0) {
                console.log('[Semantic] ℹ️ No semantic results, using text-only');
                return textResults.slice(0, limit);
            }

            // 2. Combinar resultados (text + semantic)
            const combined = [...textResults, ...semanticResults];

            // 3. Deduplica por ID
            const seen = new Set<number>();
            const unique = combined.filter(q => {
                if (seen.has(q.id)) return false;
                seen.add(q.id);
                return true;
            });

            // 4. Ordenar por relevância (priorizar semantic similarity se disponível)
            const sorted = unique.sort((a, b) => {
                const simA = a.similarity || 0;
                const simB = b.similarity || 0;
                return simB - simA;
            });

            console.log(`[Semantic] ✅ Hybrid: ${sorted.length} unique results`);

            return sorted.slice(0, limit);

        } catch (error) {
            console.error('[Semantic] ❌ Hybrid search error:', error);
            return textResults.slice(0, limit);
        }
    }

    /**
     * Verifica se semantic search está disponível
     */
    async checkAvailability(): Promise<boolean> {
        const testEmbedding = await this.generateEmbedding('test');
        return testEmbedding !== null;
    }

    /**
     * Força reset do flag de disponibilidade
     */
    resetAvailability(): void {
        this.isAvailable = true;
    }
}

// Singleton export
export const semanticSearch = new SemanticSearchService();
