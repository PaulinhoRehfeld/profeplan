/**
 * ADMIN PANEL - SIMULATION FACTORY
 * ==================================
 *
 * Painel administrativo para gerenciamento do banco de questões
 *
 * Features:
 * - Lista paginada de questões
 * - CRUD completo (Create, Read, Update, Delete)
 * - Upload em massa (CSV/JSON)
 * - Estatísticas do banco
 * - Gestão de cache
 * - Dashboard de analytics
 */

import React, { useState, useEffect } from 'react';
import {
  Settings,
  Database,
  BarChart3,
  Upload,
  Trash2,
  Eye,
  Edit,
  Plus,
  RefreshCw,
  Download,
} from 'lucide-react';
import {
  questionBank,
  simulationCache,
  simulationAnalytics,
  SimulationQuestion,
  AnalyticsSummary,
} from '../../SimulationFactory';
import { useToast } from '../../../contexts/ToastContext';

interface AdminPanelProps {
  userId: string;
  isAdmin: boolean;
}

type TabType = 'questions' | 'analytics' | 'cache' | 'upload';

export const AdminPanel: React.FC<AdminPanelProps> = ({ userId, isAdmin }) => {
  const [activeTab, setActiveTab] = useState<TabType>('questions');
  const [questions, setQuestions] = useState<SimulationQuestion[]>([]);
  const [analytics, setAnalytics] = useState<AnalyticsSummary | null>(null);
  const [cacheStats, setCacheStats] = useState<any>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [searchQuery, setSearchQuery] = useState('');
  const { showToast } = useToast();

  // Verificar permissão
  if (!isAdmin) {
    return (
      <div className="flex items-center justify-center h-screen bg-gradient-to-br from-slate-900 to-slate-800">
        <div className="text-center text-white">
          <h1 className="text-3xl font-bold mb-4">🔒 Acesso Negado</h1>
          <p className="text-slate-400">Você precisa de permissões de administrador.</p>
        </div>
      </div>
    );
  }

  // Load data baseado na tab ativa
  useEffect(() => {
    loadTabData();
  }, [activeTab]);

  const loadTabData = async () => {
    setIsLoading(true);
    try {
      switch (activeTab) {
        case 'questions':
          if (searchQuery) {
            const result = await questionBank.search({ query: searchQuery, limit: 50 });
            setQuestions(result.questions);
          }
          break;
        case 'analytics':
          const analyticsData = await simulationAnalytics.getSummary(undefined, 30);
          setAnalytics(analyticsData);
          break;
        case 'cache':
          const stats = await questionBank.getCacheStats();
          setCacheStats(stats);
          break;
      }
    } catch (error) {
      console.error('Error loading tab data:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleSearch = async () => {
    if (!searchQuery.trim()) return;
    setIsLoading(true);
    try {
      const result = await questionBank.search({ query: searchQuery, limit: 50 });
      setQuestions(result.questions);
    } catch (error) {
      console.error('Search error:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const handleClearCache = async () => {
    if (!confirm('Limpar todo o cache? Esta ação não pode ser desfeita.')) return;
    try {
      await questionBank.clearCache();
      showToast('success', 'Cache limpo com sucesso!');
      loadTabData();
    } catch (error) {
      console.error('Error clearing cache:', error);
      showToast('error', 'Falha ao limpar o cache. Tente novamente.');
    }
  };

  const handlePruneCache = async () => {
    try {
      const deleted = await questionBank.pruneCache();
      showToast('success', `${deleted} entradas expiradas removidas do cache.`);
      loadTabData();
    } catch (error) {
      console.error('Error pruning cache:', error);
      showToast('error', 'Falha ao limpar entradas expiradas. Tente novamente.');
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 p-6">
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-4xl font-black text-white mb-2">🏭 SimulationFactory Admin</h1>
        <p className="text-slate-400">Gerenciamento do banco de questões ENEM/SAEB</p>
      </div>

      {/* Tabs */}
      <div className="flex gap-2 mb-6 overflow-x-auto">
        <TabButton
          icon={<Database size={18} />}
          label="Questões"
          active={activeTab === 'questions'}
          onClick={() => setActiveTab('questions')}
        />
        <TabButton
          icon={<BarChart3 size={18} />}
          label="Analytics"
          active={activeTab === 'analytics'}
          onClick={() => setActiveTab('analytics')}
        />
        <TabButton
          icon={<Settings size={18} />}
          label="Cache"
          active={activeTab === 'cache'}
          onClick={() => setActiveTab('cache')}
        />
        <TabButton
          icon={<Upload size={18} />}
          label="Upload"
          active={activeTab === 'upload'}
          onClick={() => setActiveTab('upload')}
        />
      </div>

      {/* Content */}
      <div className="bg-white/5 backdrop-blur-lg rounded-2xl border border-white/10 p-6">
        {isLoading && (
          <div className="flex items-center justify-center py-12">
            <RefreshCw className="animate-spin text-indigo-400" size={32} />
          </div>
        )}

        {!isLoading && activeTab === 'questions' && (
          <QuestionsTab
            questions={questions}
            searchQuery={searchQuery}
            onSearchChange={setSearchQuery}
            onSearch={handleSearch}
          />
        )}

        {!isLoading && activeTab === 'analytics' && analytics && (
          <AnalyticsTab analytics={analytics} />
        )}

        {!isLoading && activeTab === 'cache' && cacheStats && (
          <CacheTab stats={cacheStats} onClear={handleClearCache} onPrune={handlePruneCache} />
        )}

        {!isLoading && activeTab === 'upload' && <UploadTab />}
      </div>
    </div>
  );
};

// ==================== SUB-COMPONENTS ====================

const TabButton: React.FC<{
  icon: React.ReactNode;
  label: string;
  active: boolean;
  onClick: () => void;
}> = ({ icon, label, active, onClick }) => (
  <button
    onClick={onClick}
    className={`
      flex items-center gap-2 px-4 py-2 rounded-lg font-semibold transition-all
      ${
        active
          ? 'bg-indigo-600 text-white shadow-lg shadow-indigo-500/50'
          : 'bg-white/5 text-slate-400 hover:bg-white/10 hover:text-white'
      }
    `}
  >
    {icon}
    {label}
  </button>
);

const QuestionsTab: React.FC<{
  questions: SimulationQuestion[];
  searchQuery: string;
  onSearchChange: (query: string) => void;
  onSearch: () => void;
}> = ({ questions, searchQuery, onSearchChange, onSearch }) => (
  <div>
    {/* Search Bar */}
    <div className="flex gap-2 mb-6">
      <input
        type="text"
        value={searchQuery}
        onChange={(e) => onSearchChange(e.target.value)}
        onKeyPress={(e) => e.key === 'Enter' && onSearch()}
        placeholder="Buscar questões..."
        className="flex-1 px-4 py-3 bg-white/5 border border-white/10 rounded-lg text-white placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-indigo-500"
      />
      <button
        onClick={onSearch}
        className="px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold rounded-lg transition-colors"
      >
        Buscar
      </button>
    </div>

    {/* Results */}
    {questions.length === 0 ? (
      <div className="text-center py-12 text-slate-400">Digite uma query para buscar questões</div>
    ) : (
      <div className="space-y-4">
        <h3 className="text-lg font-bold text-white mb-4">
          {questions.length} questões encontradas
        </h3>
        {questions.map((q) => (
          <QuestionCard key={q.id} question={q} />
        ))}
      </div>
    )}
  </div>
);

const QuestionCard: React.FC<{ question: SimulationQuestion }> = ({ question }) => (
  <div className="bg-white/5 border border-white/10 rounded-lg p-4 hover:bg-white/10 transition-colors">
    <div className="flex items-start justify-between mb-2">
      <div className="flex-1">
        <div className="flex items-center gap-2 mb-2">
          <span className="text-xs font-bold text-indigo-400">ID: {question.id}</span>
          <span className="text-xs text-slate-400">
            {question.metadata.discipline} • {question.metadata.year}
          </span>
        </div>
        <p className="text-sm text-white line-clamp-2">
          {question.metadata.alternativesIntroduction || question.metadata.context}
        </p>
      </div>
      <div className="flex gap-2 ml-4">
        <button className="p-2 hover:bg-white/10 rounded-lg transition-colors text-slate-400 hover:text-white">
          <Eye size={16} />
        </button>
        <button className="p-2 hover:bg-white/10 rounded-lg transition-colors text-slate-400 hover:text-white">
          <Edit size={16} />
        </button>
      </div>
    </div>
  </div>
);

const AnalyticsTab: React.FC<{ analytics: AnalyticsSummary }> = ({ analytics }) => (
  <div className="space-y-6">
    {/* Métricas principais */}
    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
      <MetricCard
        title="Total de Buscas"
        value={analytics.totalSearches.toString()}
        subtitle="Últimos 30 dias"
      />
      <MetricCard
        title="Cache Hit Rate"
        value={`${Math.round(analytics.cacheHitRate)}%`}
        subtitle="Performance do cache"
      />
      <MetricCard
        title="Questões Únicas"
        value={analytics.mostViewedQuestions.length.toString()}
        subtitle="Visualizadas"
      />
    </div>

    {/* Top Queries */}
    <div className="bg-white/5 rounded-lg p-4">
      <h3 className="text-lg font-bold text-white mb-4">🔥 Buscas Mais Populares</h3>
      <div className="space-y-2">
        {analytics.topQueries.slice(0, 10).map((item, idx) => (
          <div key={idx} className="flex items-center justify-between text-sm">
            <span className="text-white">
              {idx + 1}. {item.query}
            </span>
            <span className="text-slate-400">{item.count}x</span>
          </div>
        ))}
      </div>
    </div>

    {/* Top Areas */}
    <div className="bg-white/5 rounded-lg p-4">
      <h3 className="text-lg font-bold text-white mb-4">📚 Áreas Mais Buscadas</h3>
      <div className="space-y-2">
        {analytics.topAreas.map((item, idx) => (
          <div key={idx} className="flex items-center justify-between text-sm">
            <span className="text-white">{item.area || 'Todas'}</span>
            <span className="text-slate-400">{item.count}x</span>
          </div>
        ))}
      </div>
    </div>
  </div>
);

const CacheTab: React.FC<{
  stats: any;
  onClear: () => void;
  onPrune: () => void;
}> = ({ stats, onClear, onPrune }) => (
  <div className="space-y-6">
    {/* Stats */}
    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
      <MetricCard
        title="Entradas"
        value={stats.totalEntries.toString()}
        subtitle="Total em cache"
      />
      <MetricCard
        title="Tamanho"
        value={`${Math.round(stats.totalSize / 1024)}KB`}
        subtitle="Espaço usado"
      />
      <MetricCard
        title="Idade"
        value={stats.totalEntries > 0 ? formatAge(Date.now() - stats.oldestEntry) : 'N/A'}
        subtitle="Entrada mais antiga"
      />
    </div>

    {/* Actions */}
    <div className="flex gap-4">
      <button
        onClick={onPrune}
        className="flex items-center gap-2 px-6 py-3 bg-yellow-600 hover:bg-yellow-700 text-white font-semibold rounded-lg transition-colors"
      >
        <RefreshCw size={18} />
        Limpar Expirados
      </button>
      <button
        onClick={onClear}
        className="flex items-center gap-2 px-6 py-3 bg-red-600 hover:bg-red-700 text-white font-semibold rounded-lg transition-colors"
      >
        <Trash2 size={18} />
        Limpar Tudo
      </button>
    </div>
  </div>
);

const UploadTab: React.FC = () => (
  <div className="text-center py-12">
    <Upload size={64} className="mx-auto text-slate-600 mb-4" />
    <h3 className="text-xl font-bold text-white mb-2">Upload em Massa</h3>
    <p className="text-slate-400 mb-6">
      Funcionalidade em desenvolvimento.
      <br />
      Em breve: importação de questões via CSV/JSON
    </p>
  </div>
);

const MetricCard: React.FC<{
  title: string;
  value: string;
  subtitle: string;
}> = ({ title, value, subtitle }) => (
  <div className="bg-white/5 rounded-lg p-4">
    <h4 className="text-sm text-slate-400 mb-1">{title}</h4>
    <p className="text-3xl font-black text-white mb-1">{value}</p>
    <p className="text-xs text-slate-500">{subtitle}</p>
  </div>
);

// Helpers
const formatAge = (ms: number): string => {
  const hours = Math.floor(ms / (1000 * 60 * 60));
  if (hours < 24) return `${hours}h`;
  const days = Math.floor(hours / 24);
  return `${days}d`;
};
