import React, { useEffect, useState } from 'react';
import {
  TrendingUp,
  TrendingDown,
  Sparkles,
  AlertTriangle,
  CheckCircle2,
  BarChart3,
} from 'lucide-react';
import {
  getPreferenceAnalytics,
  getPreferenceSuggestions,
  PreferenceAnalytics,
} from '../services/ai/AiPreferenceAnalyticsService';

interface AiPreferenceAnalyticsDashboardProps {
  userId: string;
  daysLookback?: number;
}

/**
 * ANALYTICS DASHBOARD (RLM-004 Extensão)
 *
 * Mostra insights e métricas sobre as preferências de IA:
 * - Qual metodologia gera mais satisfação
 * - Taxa de regeneração por preferência
 * - Sugestões personalizadas
 * - Tendências de uso
 */
const AiPreferenceAnalyticsDashboard: React.FC<AiPreferenceAnalyticsDashboardProps> = ({
  userId,
  daysLookback = 30,
}) => {
  const [analytics, setAnalytics] = useState<PreferenceAnalytics | null>(null);
  const [suggestions, setSuggestions] = useState<string[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadAnalytics();
  }, [userId, daysLookback]);

  const loadAnalytics = async () => {
    setLoading(true);
    try {
      const data = await getPreferenceAnalytics(userId, daysLookback);
      if (data) {
        setAnalytics(data);
        setSuggestions(getPreferenceSuggestions(data));
      }
    } catch (error) {
      console.error('Erro ao carregar analytics:', error);
    } finally {
      setLoading(false);
    }
  };

  if (loading) {
    return (
      <div className="bg-white border border-slate-200 rounded-2xl p-6">
        <div className="flex items-center justify-center py-8">
          <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
          <span className="ml-3 text-slate-600">Carregando analytics...</span>
        </div>
      </div>
    );
  }

  if (!analytics || analytics.total_generations === 0) {
    return (
      <div className="bg-gradient-to-br from-slate-50 to-slate-100 border border-slate-200 rounded-2xl p-6">
        <div className="text-center py-8">
          <BarChart3 className="w-12 h-12 text-slate-400 mx-auto mb-3" />
          <h3 className="text-lg font-bold text-slate-700 mb-2">Sem Dados de Analytics</h3>
          <p className="text-sm text-slate-600">
            Continue usando as ferramentas de IA para gerar insights sobre suas preferências.
          </p>
        </div>
      </div>
    );
  }

  const renderStars = (score: number) => {
    const stars = [];
    for (let i = 1; i <= 5; i++) {
      stars.push(
        <span key={i} className={i <= score ? 'text-yellow-400' : 'text-slate-300'}>
          ★
        </span>
      );
    }
    return stars;
  };

  return (
    <div className="space-y-6">
      {/* Header com estatísticas gerais */}
      <div className="bg-gradient-to-br from-blue-500 to-purple-600 text-white rounded-2xl p-6 shadow-lg">
        <div className="flex items-center gap-3 mb-4">
          <Sparkles className="w-6 h-6" />
          <h2 className="text-xl font-bold">Analytics de Preferências</h2>
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <p className="text-white/80 text-sm">Total de Gerações</p>
            <p className="text-3xl font-bold">{analytics.total_generations}</p>
          </div>
          <div>
            <p className="text-white/80 text-sm">Satisfação Geral</p>
            <div className="flex items-center gap-2">
              <p className="text-3xl font-bold">{analytics.overall_satisfaction.toFixed(1)}</p>
              <div className="text-lg">
                {renderStars(Math.round(analytics.overall_satisfaction))}
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Sugestões */}
      {suggestions.length > 0 && (
        <div className="space-y-2">
          <h3 className="text-sm font-bold text-slate-700 uppercase mb-3">
            💡 Sugestões Personalizadas
          </h3>
          {suggestions.map((suggestion, idx) => {
            const isPositive = suggestion.includes('✨') || suggestion.includes('🎉');
            const isWarning = suggestion.includes('⚠️');
            const bgColor = isPositive
              ? 'bg-green-50 border-green-200'
              : isWarning
                ? 'bg-amber-50 border-amber-200'
                : 'bg-blue-50 border-blue-200';
            const textColor = isPositive
              ? 'text-green-800'
              : isWarning
                ? 'text-amber-800'
                : 'text-blue-800';

            return (
              <div key={idx} className={`${bgColor} border rounded-xl p-4`}>
                <p className={`text-sm ${textColor} leading-relaxed`}>{suggestion}</p>
              </div>
            );
          })}
        </div>
      )}

      {/* Metodologias */}
      <div>
        <h3 className="text-sm font-bold text-slate-700 uppercase mb-3">📚 Metodologias</h3>
        <div className="space-y-3">
          {Object.entries(analytics.methodology)
            .sort((a, b) => b[1].avg_satisfaction - a[1].avg_satisfaction)
            .map(([name, stats]) => (
              <div key={name} className="bg-white border border-slate-200 rounded-xl p-4">
                <div className="flex items-center justify-between mb-2">
                  <div>
                    <p className="font-bold text-slate-800">{name}</p>
                    <p className="text-xs text-slate-500">{stats.usage_count} usos</p>
                  </div>
                  <div className="text-right">
                    <div className="flex items-center gap-1 mb-1">
                      {stats.avg_satisfaction >= 4.0 ? (
                        <TrendingUp className="w-4 h-4 text-green-500" />
                      ) : stats.avg_satisfaction < 3.0 ? (
                        <TrendingDown className="w-4 h-4 text-red-500" />
                      ) : null}
                      <span className="text-sm font-bold">
                        {stats.avg_satisfaction.toFixed(1)}⭐
                      </span>
                    </div>
                    <p className="text-xs text-slate-500">
                      {stats.regeneration_rate.toFixed(0)}% regen.
                    </p>
                  </div>
                </div>
                <div className="w-full bg-slate-100 rounded-full h-2">
                  <div
                    className={`h-2 rounded-full ${
                      stats.avg_satisfaction >= 4.0
                        ? 'bg-green-500'
                        : stats.avg_satisfaction >= 3.0
                          ? 'bg-yellow-500'
                          : 'bg-red-500'
                    }`}
                    style={{ width: `${(stats.avg_satisfaction / 5) * 100}%` }}
                  ></div>
                </div>
              </div>
            ))}
        </div>
      </div>

      {/* Estilos Pedagógicos, Foco e Tom em grid compacto */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {/* Estilos */}
        <div>
          <h4 className="text-xs font-bold text-slate-500 uppercase mb-2">Estilos</h4>
          {Object.entries(analytics.pedagogical_style).map(([name, stats]) => (
            <div key={name} className="mb-2">
              <div className="flex justify-between items-center">
                <span className="text-xs text-slate-700">{name}</span>
                <span className="text-xs font-bold">{stats.avg_satisfaction.toFixed(1)}⭐</span>
              </div>
            </div>
          ))}
        </div>

        {/* Foco */}
        <div>
          <h4 className="text-xs font-bold text-slate-500 uppercase mb-2">Foco Avaliativo</h4>
          {Object.entries(analytics.assessment_focus).map(([name, stats]) => (
            <div key={name} className="mb-2">
              <div className="flex justify-between items-center">
                <span className="text-xs text-slate-700">{name}</span>
                <span className="text-xs font-bold">{stats.avg_satisfaction.toFixed(1)}⭐</span>
              </div>
            </div>
          ))}
        </div>

        {/* Tom */}
        <div>
          <h4 className="text-xs font-bold text-slate-500 uppercase mb-2">Tom de Escrita</h4>
          {Object.entries(analytics.writing_tone).map(([name, stats]) => (
            <div key={name} className="mb-2">
              <div className="flex justify-between items-center">
                <span className="text-xs text-slate-700 truncate">{name}</span>
                <span className="text-xs font-bold">{stats.avg_satisfaction.toFixed(1)}⭐</span>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Footer */}
      <div className="bg-slate-50 border border-slate-200 rounded-xl p-4">
        <p className="text-xs text-slate-600 leading-relaxed">
          📊 <strong>Analytics baseados em {daysLookback} dias.</strong> Continue avaliando as
          gerações de IA com estrelas para insights mais precisos.
        </p>
      </div>
    </div>
  );
};

export default AiPreferenceAnalyticsDashboard;
