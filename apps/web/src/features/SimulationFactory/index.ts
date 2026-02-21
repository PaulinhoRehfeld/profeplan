/**
 * SIMULATION FACTORY - PUBLIC API v2.0
 * ======================================
 * 
 * Módulo completo com todas as features avançadas
 */

// ==================== CORE SERVICES ====================
export { questionBank } from './services/QuestionBankService';
export { simulationDB } from './services/SimulationDatabaseService';

// ==================== ADVANCED SERVICES (v2.0) ====================
export { simulationCache } from './services/SimulationCacheService';
export { simulationAnalytics } from './services/SimulationAnalyticsService';
export { semanticSearch } from './services/SemanticSearchService';
export { queryExpansion } from './services/QueryExpansionService'; // Busca inteligente

// ==================== EXPORT SERVICES ====================
export {
    exportSimulationToDocx,
    generateSimulationTitle,
    generateContentSummary,
    shuffleQuestions
} from './services/SimulationExportService';

// ==================== COMPONENTS ====================
export { AdminPanel } from './components/AdminPanel';
export { OfflineIndicator, OnlineStatusBadge } from './components/OfflineIndicator';

// ==================== UTILITIES ====================
export {
    registerServiceWorker,
    unregisterServiceWorker,
    checkOnlineStatus,
    setupOnlineStatusListeners,
    useOnlineStatus
} from '../../utils/serviceWorkerRegistration';

// ==================== TYPES ====================
export type {
    SimulationQuestion,
    QuestionSearchParams,
    QuestionSearchResult,
    QuestionArea
} from './types/question.types';

export type {
    SearchAnalyticsEvent,
    QuestionViewEvent,
    AnalyticsSummary
} from './services/SimulationAnalyticsService';

export { AREA_DISCIPLINE_MAP } from './types/question.types';

// ==================== HOOKS ====================
export { useSimulationQuestions } from './hooks/useSimulationQuestions';

// ==================== UTILS ====================
export {
    normalizeString,
    filterByArea,
    deduplicateQuestions,
    sortByRelevance,
    hasCompleteMetadata,
    filterCompleteQuestions,
    getQuestionPreview,
    formatYear,
    formatDiscipline,
    countByArea
} from './utils/questionFilters';

// ==================== VERSION ====================
export const SIMULATION_FACTORY_VERSION = '2.0.0';

/**
 * Health check completo do módulo
 */
export const checkSimulationFactoryHealth = async () => {
    const { questionBank } = await import('./services/QuestionBankService');
    const { semanticSearch } = await import('./services/SemanticSearchService');

    const dbHealth = await questionBank.checkHealth();
    const semanticAvailable = await semanticSearch.checkAvailability();
    const cacheStats = await questionBank.getCacheStats();
    const hybridEnabled = questionBank.isHybridEnabled();

    return {
        version: SIMULATION_FACTORY_VERSION,
        database: dbHealth,
        semanticSearch: {
            available: semanticAvailable,
            message: semanticAvailable ? '✅ Semantic search available' : '⚠️ Using text-only search'
        },
        hybridSearch: {
            enabled: hybridEnabled,
            message: hybridEnabled ? '✅ Hybrid search enabled' : '⚠️ Hybrid search disabled'
        },
        cache: cacheStats,
        offlineSupport: {
            serviceWorker: 'serviceWorker' in navigator,
            message: 'serviceWorker' in navigator ? '✅ Offline support available' : '❌ Service Worker not supported'
        }
    };
};
