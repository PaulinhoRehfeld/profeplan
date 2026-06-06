/**
 * SIMULATION ANALYTICS SERVICE
 * ==============================
 * 
 * Rastreamento de uso e analytics do módulo de simulados
 * 
 * Features:
 * - Track de buscas realizadas
 * - Questões mais acessadas
 * - Filtros mais usados
 * - Métricas de performance (cache hit rate)
 * - Persistência em Supabase
 */

import { supabase } from '../../../services/supabaseClient';

interface SearchAnalyticsEvent {
    user_id?: string;
    query: string;
    areas: string;
    cache_hit: boolean;
    result_count: number;
    timestamp: string;
}

interface QuestionViewEvent {
    user_id?: string;
    question_id: number;
    timestamp: string;
}

interface AnalyticsSummary {
    totalSearches: number;
    cacheHitRate: number;
    topQueries: Array<{ query: string; count: number }>;
    topAreas: Array<{ area: string; count: number }>;
    mostViewedQuestions: Array<{ question_id: number; count: number }>;
}

class SimulationAnalyticsService {
    private readonly SEARCH_EVENTS_TABLE = 'simulation_search_events';
    private readonly VIEW_EVENTS_TABLE = 'simulation_question_views';

    /**
     * Rastreia busca realizada
     */
    async trackSearch(event: SearchAnalyticsEvent): Promise<void> {
        try {
            const { error } = await supabase
                .from(this.SEARCH_EVENTS_TABLE)
                .insert([event]);

            if (error) {
                console.warn('[Analytics] ⚠️ Failed to track search:', error.message);
            } else {
                console.log('[Analytics] ✅ Search tracked');
            }
        } catch (error) {
            console.warn('[Analytics] ⚠️ Exception tracking search:', error);
        }
    }

    /**
     * Rastreia visualização de questão
     */
    async trackQuestionView(event: QuestionViewEvent): Promise<void> {
        try {
            const { error } = await supabase
                .from(this.VIEW_EVENTS_TABLE)
                .insert([event]);

            if (error) {
                console.warn('[Analytics] ⚠️ Failed to track view:', error.message);
            } else {
                console.log('[Analytics] ✅ View tracked');
            }
        } catch (error) {
            console.warn('[Analytics] ⚠️ Exception tracking view:', error);
        }
    }

    /**
     * Obtém resumo de analytics
     */
    async getSummary(userId?: string, days: number = 30): Promise<AnalyticsSummary> {
        try {
            const since = new Date();
            since.setDate(since.getDate() - days);
            const sinceISO = since.toISOString();

            // Query de buscas
            let searchQuery = supabase
                .from(this.SEARCH_EVENTS_TABLE)
                .select('*')
                .gte('timestamp', sinceISO);

            if (userId) {
                searchQuery = searchQuery.eq('user_id', userId);
            }

            const { data: searches, error: searchError } = await searchQuery;

            if (searchError) {
                console.error('[Analytics] ❌ Failed to get searches:', searchError);
                return this.getEmptySummary();
            }

            // Calcular métricas
            const totalSearches = searches?.length || 0;
            const cacheHits = searches?.filter(s => s.cache_hit).length || 0;
            const cacheHitRate = totalSearches > 0 ? (cacheHits / totalSearches) * 100 : 0;

            // Top queries
            const queryCount = new Map<string, number>();
            searches?.forEach(s => {
                const count = queryCount.get(s.query) || 0;
                queryCount.set(s.query, count + 1);
            });
            const topQueries = Array.from(queryCount.entries())
                .map(([query, count]) => ({ query, count }))
                .sort((a, b) => b.count - a.count)
                .slice(0, 10);

            // Top areas
            const areaCount = new Map<string, number>();
            searches?.forEach(s => {
                if (s.areas) {
                    const count = areaCount.get(s.areas) || 0;
                    areaCount.set(s.areas, count + 1);
                }
            });
            const topAreas = Array.from(areaCount.entries())
                .map(([area, count]) => ({ area, count }))
                .sort((a, b) => b.count - a.count)
                .slice(0, 5);

            // Query de visualizações
            let viewQuery = supabase
                .from(this.VIEW_EVENTS_TABLE)
                .select('*')
                .gte('timestamp', sinceISO);

            if (userId) {
                viewQuery = viewQuery.eq('user_id', userId);
            }

            const { data: views } = await viewQuery;

            // Questões mais vistas
            const questionViewCount = new Map<number, number>();
            views?.forEach(v => {
                const count = questionViewCount.get(v.question_id) || 0;
                questionViewCount.set(v.question_id, count + 1);
            });
            const mostViewedQuestions = Array.from(questionViewCount.entries())
                .map(([question_id, count]) => ({ question_id, count }))
                .sort((a, b) => b.count - a.count)
                .slice(0, 10);

            return {
                totalSearches,
                cacheHitRate,
                topQueries,
                topAreas,
                mostViewedQuestions
            };

        } catch (error) {
            console.error('[Analytics] ❌ Exception getting summary:', error);
            return this.getEmptySummary();
        }
    }

    /**
     * Retorna summary vazio
     */
    private getEmptySummary(): AnalyticsSummary {
        return {
            totalSearches: 0,
            cacheHitRate: 0,
            topQueries: [],
            topAreas: [],
            mostViewedQuestions: []
        };
    }
}

// Singleton export
export const simulationAnalytics = new SimulationAnalyticsService();

// Export types
export type { SearchAnalyticsEvent, QuestionViewEvent, AnalyticsSummary };
