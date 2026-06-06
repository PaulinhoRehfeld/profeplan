/**
 * SEMANTIC SEARCH SERVICE
 * ========================
 * 
 * Busca semântica (opcional) para SimulationFactory.
 * A implementação baseada em Gemini foi desativada para simplificar
 * o build e a dependência de providers externos. Hoje, o serviço
 * funciona como um stub seguro que SEMPRE faz fallback para busca
 * textual, sem tentar gerar embeddings.
 */

import { supabase } from '../../../services/supabaseClient';
import { SimulationQuestion, QuestionDatabaseRow } from '../types/question.types';

class SemanticSearchService {
    /**
     * Busca semântica por similaridade vetorial
     */
    async searchSemantic(
        query: string,
        limit: number = 15,
        threshold: number = 0.5
    ): Promise<SimulationQuestion[]> {
        console.log('[Semantic] ℹ️ Semantic search stubbed out; using text-only results.');
        return [];
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
        console.log('[Semantic] ℹ️ Hybrid semantic search disabled; returning text-only results.');
        return textResults.slice(0, limit);
    }

    /**
     * Verifica se semantic search está disponível
     */
    async checkAvailability(): Promise<boolean> {
        // Semantic search foi desativada; sempre retornar false
        return false;
    }

    /**
     * Força reset do flag de disponibilidade
     */
    resetAvailability(): void {
        // No-op: disponibilidade fixa (desativada)
    }
}

// Singleton export
export const semanticSearch = new SemanticSearchService();
