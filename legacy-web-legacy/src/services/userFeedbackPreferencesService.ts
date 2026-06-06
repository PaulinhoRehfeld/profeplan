/**
 * USER FEEDBACK PREFERENCES SERVICE
 * ==================================
 * 
 * Gerencia preferências pedagógicas derivadas do feedback iterativo do usuário.
 * Quando o professor aprova um ajuste e escolhe "usar como padrão", este serviço
 * atualiza as configurações do usuário para futuros planejamentos.
 */

import { supabase } from './supabaseClient';
import { UserSettings } from '../types';

export interface FeedbackPreference {
    id?: string;
    user_id: string;
    feedback_text: string;
    preference_type: 'methodology' | 'style' | 'tone' | 'focus' | 'general';
    applied_to_settings: boolean;
    created_at: string;
}

/**
 * Analisa o feedback do usuário e identifica qual preferência pedagógica ele está mudando
 */
export function analyzeFeedbackIntent(feedback: string): {
    preferenceType: FeedbackPreference['preference_type'];
    suggestedValue: string | null;
} {
    const lower = feedback.toLowerCase();

    // Metodologia
    if (lower.match(/gamifica|game|jogo|narrativa|missão/)) {
        return { preferenceType: 'methodology', suggestedValue: 'Gamification' };
    }
    if (lower.match(/problema|abp|project|investigação|descoberta/)) {
        return { preferenceType: 'methodology', suggestedValue: 'Problem-Based Learning (ABP)' };
    }
    if (lower.match(/tradicional|expositiv|aula teórica|explicação direta/)) {
        return { preferenceType: 'methodology', suggestedValue: 'Traditional' };
    }

    // Estilo Pedagógico
    if (lower.match(/construtiv|aluno constr|experimenta|mediação/)) {
        return { preferenceType: 'style', suggestedValue: 'Construtivista' };
    }
    if (lower.match(/sociointeracion|vygotsky|colabor|interação social/)) {
        return { preferenceType: 'style', suggestedValue: 'Sociointeracionista' };
    }

    // Tom
    if (lower.match(/prático|acessível|simples|direto|motivador|inspiracion/)) {
        return { preferenceType: 'tone', suggestedValue: 'Prático e Inspiracional' };
    }
    if (lower.match(/técnico|formal|acadêmico|referenci/)) {
        return { preferenceType: 'tone', suggestedValue: 'Técnico e Referenciado' };
    }

    // Foco Avaliativo
    if (lower.match(/formativ|durante.*processo|feedback contínu|acompanhamento/)) {
        return { preferenceType: 'focus', suggestedValue: 'Formativa' };
    }
    if (lower.match(/somativ|final|prova|mensuração|classificação/)) {
        return { preferenceType: 'focus', suggestedValue: 'Somativa' };
    }
    if (lower.match(/diagnóstic|antes.*início|mapeamento|conheciment.*prévio/)) {
        return { preferenceType: 'focus', suggestedValue: 'Diagnóstica' };
    }

    // Default: geral (não identificado)
    return { preferenceType: 'general', suggestedValue: null };
}

/**
 * Salva o feedback do usuário como preferência no banco de dados
 */
export async function saveFeedbackPreference(
    userId: string,
    feedbackText: string
): Promise<boolean> {
    try {
        const { preferenceType, suggestedValue } = analyzeFeedbackIntent(feedbackText);

        const { error } = await supabase
            .from('user_feedback_preferences')
            .insert({
                user_id: userId,
                feedback_text: feedbackText,
                preference_type: preferenceType,
                applied_to_settings: false, // Será aplicado após aprovação
                created_at: new Date().toISOString()
            });

        if (error) {
            console.error('Erro ao salvar preferência de feedback:', error);
            return false;
        }

        // Se identificou um valor específico, atualizar UserSettings imediatamente
        if (suggestedValue) {
            await applyFeedbackToSettings(userId, preferenceType, suggestedValue);
        }

        return true;
    } catch (error) {
        console.error('Erro ao processar feedback:', error);
        return false;
    }
}

/**
 * Aplica o feedback às configurações do usuário (UserSettings)
 */
async function applyFeedbackToSettings(
    userId: string,
    preferenceType: FeedbackPreference['preference_type'],
    value: string
): Promise<boolean> {
    try {
        // Buscar settings atuais
        const { data: currentSettings, error: fetchError } = await supabase
            .from('user_settings')
            .select('*')
            .eq('user_id', userId)
            .single();

        if (fetchError) {
            console.error('Erro ao buscar settings:', fetchError);
            return false;
        }

        // Mapear tipo de preferência para campo do UserSettings
        const fieldMap: Record<string, keyof UserSettings> = {
            methodology: 'favoriteMethodology',
            style: 'teachingStyle',
            tone: 'toneOfVoice',
            focus: 'assessmentFocus'
        };

        const field = fieldMap[preferenceType];
        if (!field) return false; // 'general' não tem campo específico

        // Atualizar settings
        const updates = {
            [field]: value,
            updated_at: new Date().toISOString()
        };

        const { error: updateError } = await supabase
            .from('user_settings')
            .update(updates)
            .eq('user_id', userId);

        if (updateError) {
            console.error('Erro ao atualizar settings:', updateError);
            return false;
        }

        // Marcar preferência como aplicada
        await supabase
            .from('user_feedback_preferences')
            .update({ applied_to_settings: true })
            .eq('user_id', userId)
            .eq('feedback_text', value);

        console.log(`✅ Preferência "${value}" aplicada a UserSettings.${field}`);
        return true;
    } catch (error) {
        console.error('Erro ao aplicar feedback:', error);
        return false;
    }
}

/**
 * Busca os últimos feedbacks salvos do usuário
 */
export async function getUserFeedbackHistory(
    userId: string,
    limit: number = 10
): Promise<FeedbackPreference[]> {
    try {
        const { data, error } = await supabase
            .from('user_feedback_preferences')
            .select('*')
            .eq('user_id', userId)
            .order('created_at', { ascending: false })
            .limit(limit);

        if (error) {
            console.error('Erro ao buscar histórico:', error);
            return [];
        }

        return data || [];
    } catch (error) {
        console.error('Erro ao buscar feedback:', error);
        return [];
    }
}
