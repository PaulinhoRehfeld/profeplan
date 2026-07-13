/**
 * AI PREFERENCES ANALYTICS SERVICE
 * ==================================
 *
 * Rastreia o uso de preferências de IA e métricas de satisfação para
 * gerar insights sobre qual metodologia/estilo gera melhores resultados.
 *
 * FUNCIONALIDADES:
 * 1. Rastreamento de uso de preferências por geração
 * 2. Métricas de satisfação (feedback positivo/negativo)
 * 3. Analytics por ferramenta (Planning, PDI, Chat, Assessment)
 * 4. Dashboard de insights agregados
 */

import { supabase } from '../supabaseClient';
import { UserSettings } from '../../types';

export interface PreferenceUsageLog {
  id?: string;
  user_id: string;
  tool: 'planning' | 'pdi' | 'chat' | 'assessment';
  methodology: string;
  pedagogical_style: string;
  assessment_focus: string;
  writing_tone: string;
  generated_at: string;
  feedback_score?: number; // 1-5 stars
  feedback_text?: string;
  regeneration_requested?: boolean;
}

export interface PreferenceAnalytics {
  methodology: {
    [key: string]: {
      usage_count: number;
      avg_satisfaction: number;
      regeneration_rate: number;
    };
  };
  pedagogical_style: {
    [key: string]: {
      usage_count: number;
      avg_satisfaction: number;
    };
  };
  assessment_focus: {
    [key: string]: {
      usage_count: number;
      avg_satisfaction: number;
    };
  };
  writing_tone: {
    [key: string]: {
      usage_count: number;
      avg_satisfaction: number;
    };
  };
  total_generations: number;
  overall_satisfaction: number;
}

/**
 * Registra uma geração de IA com as preferências aplicadas
 */
export async function logPreferenceUsage(
  log: Omit<PreferenceUsageLog, 'id' | 'generated_at'>
): Promise<string | null> {
  try {
    const { data, error } = await supabase
      .from('ai_preference_logs')
      .insert({
        user_id: log.user_id,
        tool: log.tool,
        methodology: log.methodology,
        pedagogical_style: log.pedagogical_style,
        assessment_focus: log.assessment_focus,
        writing_tone: log.writing_tone,
        generated_at: new Date().toISOString(),
        feedback_score: log.feedback_score,
        feedback_text: log.feedback_text,
        regeneration_requested: log.regeneration_requested || false,
      })
      .select('id')
      .single();

    if (error) {
      console.error('Erro ao registrar uso de preferências:', error);
      return null;
    }

    return data?.id || null;
  } catch (error) {
    console.error('Erro ao registrar preferência:', error);
    return null;
  }
}

/**
 * Atualiza feedback de satisfação para uma geração existente
 */
export async function updateFeedback(
  logId: string,
  feedbackScore: number,
  feedbackText?: string
): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('ai_preference_logs')
      .update({
        feedback_score: feedbackScore,
        feedback_text: feedbackText,
        updated_at: new Date().toISOString(),
      })
      .eq('id', logId);

    if (error) {
      console.error('Erro ao atualizar feedback:', error);
      return false;
    }

    return true;
  } catch (error) {
    console.error('Erro ao atualizar feedback:', error);
    return false;
  }
}

/**
 * Marca que uma regeneração foi solicitada (indicador de insatisfação)
 */
export async function markRegenerationRequested(logId: string): Promise<boolean> {
  try {
    const { error } = await supabase
      .from('ai_preference_logs')
      .update({
        regeneration_requested: true,
        updated_at: new Date().toISOString(),
      })
      .eq('id', logId);

    if (error) {
      console.error('Erro ao marcar regeneração:', error);
      return false;
    }

    return true;
  } catch (error) {
    console.error('Erro ao marcar regeneração:', error);
    return false;
  }
}

/**
 * Obtém analytics agregados das preferências de um usuário
 */
export async function getPreferenceAnalytics(
  userId: string,
  daysLookback: number = 30
): Promise<PreferenceAnalytics | null> {
  try {
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - daysLookback);

    const { data: logs, error } = await supabase
      .from('ai_preference_logs')
      .select('*')
      .eq('user_id', userId)
      .gte('generated_at', startDate.toISOString())
      .order('generated_at', { ascending: false });

    if (error || !logs) {
      console.error('Erro ao buscar logs:', error);
      return null;
    }

    // Agregação de dados
    const analytics: PreferenceAnalytics = {
      methodology: {},
      pedagogical_style: {},
      assessment_focus: {},
      writing_tone: {},
      total_generations: logs.length,
      overall_satisfaction: 0,
    };

    let totalSatisfaction = 0;
    let satisfactionCount = 0;

    logs.forEach((log: any) => {
      // Metodologia
      if (!analytics.methodology[log.methodology]) {
        analytics.methodology[log.methodology] = {
          usage_count: 0,
          avg_satisfaction: 0,
          regeneration_rate: 0,
        };
      }
      analytics.methodology[log.methodology].usage_count++;
      if (log.feedback_score) {
        analytics.methodology[log.methodology].avg_satisfaction += log.feedback_score;
        totalSatisfaction += log.feedback_score;
        satisfactionCount++;
      }
      if (log.regeneration_requested) {
        analytics.methodology[log.methodology].regeneration_rate++;
      }

      // Estilo Pedagógico
      if (!analytics.pedagogical_style[log.pedagogical_style]) {
        analytics.pedagogical_style[log.pedagogical_style] = {
          usage_count: 0,
          avg_satisfaction: 0,
        };
      }
      analytics.pedagogical_style[log.pedagogical_style].usage_count++;
      if (log.feedback_score) {
        analytics.pedagogical_style[log.pedagogical_style].avg_satisfaction += log.feedback_score;
      }

      // Foco Avaliativo
      if (!analytics.assessment_focus[log.assessment_focus]) {
        analytics.assessment_focus[log.assessment_focus] = {
          usage_count: 0,
          avg_satisfaction: 0,
        };
      }
      analytics.assessment_focus[log.assessment_focus].usage_count++;
      if (log.feedback_score) {
        analytics.assessment_focus[log.assessment_focus].avg_satisfaction += log.feedback_score;
      }

      // Tom de Escrita
      if (!analytics.writing_tone[log.writing_tone]) {
        analytics.writing_tone[log.writing_tone] = {
          usage_count: 0,
          avg_satisfaction: 0,
        };
      }
      analytics.writing_tone[log.writing_tone].usage_count++;
      if (log.feedback_score) {
        analytics.writing_tone[log.writing_tone].avg_satisfaction += log.feedback_score;
      }
    });

    // Calcular médias
    Object.keys(analytics.methodology).forEach((key) => {
      const count = analytics.methodology[key].usage_count;
      analytics.methodology[key].avg_satisfaction =
        analytics.methodology[key].avg_satisfaction / count;
      analytics.methodology[key].regeneration_rate =
        (analytics.methodology[key].regeneration_rate / count) * 100;
    });

    Object.keys(analytics.pedagogical_style).forEach((key) => {
      const count = analytics.pedagogical_style[key].usage_count;
      analytics.pedagogical_style[key].avg_satisfaction =
        analytics.pedagogical_style[key].avg_satisfaction / count;
    });

    Object.keys(analytics.assessment_focus).forEach((key) => {
      const count = analytics.assessment_focus[key].usage_count;
      analytics.assessment_focus[key].avg_satisfaction =
        analytics.assessment_focus[key].avg_satisfaction / count;
    });

    Object.keys(analytics.writing_tone).forEach((key) => {
      const count = analytics.writing_tone[key].usage_count;
      analytics.writing_tone[key].avg_satisfaction =
        analytics.writing_tone[key].avg_satisfaction / count;
    });

    analytics.overall_satisfaction =
      satisfactionCount > 0 ? totalSatisfaction / satisfactionCount : 0;

    return analytics;
  } catch (error) {
    console.error('Erro ao calcular analytics:', error);
    return null;
  }
}

/**
 * Obtém sugestões baseadas em analytics
 */
export function getPreferenceSuggestions(analytics: PreferenceAnalytics): string[] {
  const suggestions: string[] = [];

  // Analisa metodologia com maior satisfação
  const methodologies = Object.entries(analytics.methodology);
  if (methodologies.length > 1) {
    const sorted = methodologies.sort((a, b) => b[1].avg_satisfaction - a[1].avg_satisfaction);
    const best = sorted[0];
    if (best[1].avg_satisfaction > 4.0 && best[1].usage_count >= 3) {
      suggestions.push(
        `✨ Sua metodologia "${best[0]}" tem ${best[1].avg_satisfaction.toFixed(1)}⭐ de satisfação média. Continue usando!`
      );
    }
  }

  // Detecta alta taxa de regeneração
  methodologies.forEach(([name, stats]) => {
    if (stats.regeneration_rate > 40 && stats.usage_count >= 5) {
      suggestions.push(
        `⚠️ "${name}" tem ${stats.regeneration_rate.toFixed(0)}% de taxa de regeneração. Considere mudar de metodologia.`
      );
    }
  });

  // Satisfação geral baixa
  if (analytics.overall_satisfaction < 3.0 && analytics.total_generations >= 10) {
    suggestions.push(
      `💡 Sua satisfação média está em ${analytics.overall_satisfaction.toFixed(1)}⭐. Experimente ajustar suas preferências em Configurações.`
    );
  }

  // Satisfação geral alta
  if (analytics.overall_satisfaction >= 4.5 && analytics.total_generations >= 10) {
    suggestions.push(
      `🎉 Excelente! Suas preferências atuais geram ${analytics.overall_satisfaction.toFixed(1)}⭐ de satisfação média.`
    );
  }

  return suggestions;
}

/**
 * Integração com serviços de IA - Helper para registrar uso automaticamente
 */
export async function logAiGeneration(
  userId: string,
  tool: 'planning' | 'pdi' | 'chat' | 'assessment',
  settings: UserSettings
): Promise<string | null> {
  return await logPreferenceUsage({
    user_id: userId,
    tool,
    methodology: settings.favoriteMethodology || 'Gamification',
    pedagogical_style: settings.teachingStyle || 'Construtivista',
    assessment_focus: settings.assessmentFocus || 'Formativa',
    writing_tone: settings.toneOfVoice || 'Prático e Inspiracional',
  });
}
