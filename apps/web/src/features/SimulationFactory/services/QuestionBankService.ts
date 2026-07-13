/**
 * HYBRID SEARCH INTEGRATION
 * ===========================
 *
 * Integra semantic + text search para melhor relevância
 * Ativa por padrão quando embedding API disponível
 */

import { simulationDB } from './SimulationDatabaseService';
import { simulationCache } from './SimulationCacheService';
import { simulationAnalytics } from './SimulationAnalyticsService';
import { semanticSearch } from './SemanticSearchService';
import { queryExpansion } from './QueryExpansionService'; // Busca inteligente
import {
  QuestionSearchParams,
  QuestionSearchResult,
  SimulationQuestion,
  QuestionDatabaseRow,
} from '../types/question.types';
import {
  filterByArea,
  deduplicateQuestions,
  sortByRelevance,
  filterCompleteQuestions,
} from '../utils/questionFilters';

class QuestionBankService {
  private useHybridSearch: boolean = true; // ✅ Hybrid por padrão

  /**
   * Busca principal de questões (com cache E hybrid search automático)
   */
  async search(params: QuestionSearchParams): Promise<QuestionSearchResult> {
    const { query, areas = [], limit = 15 } = params;

    // Validação
    if (!query.trim()) {
      console.log('[QuestionBank] ⚠️ Empty query');
      return { questions: [], total: 0, source: 'text' };
    }

    console.log(
      `[QuestionBank] 🔍 Search: "${query}" [Areas: ${areas.join(', ') || 'All'}] [Limit: ${limit}]`
    );

    try {
      // 1. Tentar buscar do cache primeiro
      const cachedResult = await simulationCache.get(query, areas);
      if (cachedResult) {
        console.log('[QuestionBank] 💨 Cache hit - returning cached result');

        // Track analytics (cache hit)
        this.trackSearch(query, areas, true, cachedResult.questions.length);

        return cachedResult;
      }

      // 2. Cache miss - buscar com QUERY EXPANSION (inteligente!)
      console.log(`[QuestionBank] 🧠 Using intelligent query expansion for: "${query}"`);
      const rawResults: QuestionDatabaseRow[] = await queryExpansion.searchExpanded(query, 50);

      if (rawResults.length === 0) {
        console.log('[QuestionBank] ℹ️ No results found');
        return { questions: [], total: 0, source: 'text' };
      }

      // 3. Mapear para formato tipado
      let textQuestions: SimulationQuestion[] = rawResults.map((row) => ({
        id: row.id,
        metadata: row.metadata,
      }));

      console.log(`[QuestionBank] 📊 Text results: ${textQuestions.length}`);

      // 4. Filtrar questões com metadados completos
      textQuestions = filterCompleteQuestions(textQuestions);

      // 5. Filtra por áreas (se especificado)
      if (areas.length > 0) {
        textQuestions = filterByArea(textQuestions, areas);
        console.log(`[QuestionBank] 🎯 After area filter: ${textQuestions.length}`);
      }

      // 6. 🔥 HYBRID SEARCH (se habilitado)
      let finalQuestions: SimulationQuestion[];
      let searchSource: 'text' | 'semantic';

      if (this.useHybridSearch) {
        console.log('[QuestionBank] 🧠 Attempting hybrid search...');
        const hybridResults = await semanticSearch.searchHybrid(query, textQuestions, limit);

        if (hybridResults.length > textQuestions.length * 0.5) {
          // Se hybrid retornou resultados significativos, usar hybrid
          finalQuestions = hybridResults;
          searchSource = 'semantic';
          console.log('[QuestionBank] ✅ Using hybrid results');
        } else {
          // Fallback para text-only
          finalQuestions = textQuestions;
          searchSource = 'text';
          console.log('[QuestionBank] ⚠️ Hybrid insufficient, using text-only');
        }
      } else {
        // Text-only (hybrid desabilitado)
        finalQuestions = textQuestions;
        searchSource = 'text';
      }

      // 7. Deduplica e ordena
      finalQuestions = deduplicateQuestions(finalQuestions);
      finalQuestions = sortByRelevance(finalQuestions);
      finalQuestions = finalQuestions.slice(0, limit);

      const finalResult: QuestionSearchResult = {
        questions: finalQuestions,
        total: rawResults.length,
        source: searchSource,
      };

      console.log(
        `[QuestionBank] ✅ Final result: ${finalQuestions.length} questions (${searchSource})`
      );

      // 8. Armazenar no cache
      simulationCache.set(query, finalResult, areas).catch((err) => {
        console.warn('[QuestionBank] ⚠️ Failed to cache result:', err);
      });

      // 9. Track analytics (cache miss)
      this.trackSearch(query, areas, false, finalQuestions.length);

      return finalResult;
    } catch (error) {
      console.error('[QuestionBank] ❌ Search error:', error);

      // Retornar array vazio em vez de propagar erro
      return {
        questions: [],
        total: 0,
        source: 'text',
      };
    }
  }

  /**
   * Ativa/desativa hybrid search
   */
  setHybridSearch(enabled: boolean): void {
    this.useHybridSearch = enabled;
    console.log(`[QuestionBank] Hybrid search: ${enabled ? 'ENABLED' : 'DISABLED'}`);
  }

  /**
   * Verifica se hybrid está habilitado
   */
  isHybridEnabled(): boolean {
    return this.useHybridSearch;
  }

  /**
   * Busca por IDs específicos
   */
  async getByIds(ids: number[]): Promise<SimulationQuestion[]> {
    try {
      if (ids.length === 0) return [];

      console.log(`[QuestionBank] 🔍 Fetching ${ids.length} questions by ID`);

      const rows = await simulationDB.getByIds(ids);

      const questions: SimulationQuestion[] = rows.map((row) => ({
        id: row.id,
        metadata: row.metadata,
      }));

      return filterCompleteQuestions(questions);
    } catch (error) {
      console.error('[QuestionBank] ❌ getByIds error:', error);
      return [];
    }
  }

  /**
   * Health check do banco
   */
  async checkHealth(): Promise<{ healthy: boolean; message: string; count?: number }> {
    try {
      const healthStatus = await simulationDB.healthCheck();

      if (healthStatus.healthy) {
        const count = await simulationDB.getTotalCount();
        return {
          healthy: true,
          message: `✅ Question bank online`,
          count,
        };
      }

      return {
        healthy: false,
        message: `❌ ${healthStatus.message}`,
      };
    } catch (error) {
      return {
        healthy: false,
        message: `❌ Health check failed: ${error}`,
      };
    }
  }

  /**
   * Busca rápida
   */
  async quickSearch(
    query: string,
    limit: number = 5
  ): Promise<Array<{ id: number; preview: string }>> {
    try {
      const result = await this.search({ query, limit });

      return result.questions.map((q) => ({
        id: q.id,
        preview:
          q.metadata?.alternativesIntroduction?.substring(0, 100) ||
          q.metadata?.context?.substring(0, 100) ||
          'Questão sem preview',
      }));
    } catch (error) {
      console.error('[QuestionBank] ❌ quickSearch error:', error);
      return [];
    }
  }

  /**
   * Limpa cache
   */
  async clearCache(): Promise<void> {
    await simulationCache.clear();
  }

  /**
   * Obtém estatísticas do cache
   */
  async getCacheStats() {
    return simulationCache.getStats();
  }

  /**
   * Remove entradas expiradas do cache
   */
  async pruneCache(): Promise<number> {
    return simulationCache.pruneExpired();
  }

  /**
   * Track analytics
   */
  private trackSearch(
    query: string,
    areas: string[],
    cacheHit: boolean,
    resultCount: number
  ): void {
    const timestamp = new Date().toISOString();
    const analyticsEvent = {
      timestamp,
      query,
      areas: areas.join(','),
      cacheHit,
      resultCount,
    };

    console.log('[QuestionBank] 📊 Analytics:', analyticsEvent);

    // TODO: Integrar com SimulationAnalyticsService
    // simulationAnalytics.trackSearch(analyticsEvent);
  }
}

// Singleton export
export const questionBank = new QuestionBankService();
