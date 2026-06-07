import React from 'react';
import { Shield, Gamepad2, GraduationCap, Target, FileText, Settings } from 'lucide-react';
import { UserProfile, UserSettings } from '../types';

interface AiPreferencesDashboardProps {
    settings: UserSettings;
    compact?: boolean;
    onOpenSettings?: () => void;
}

/**
 * DASHBOARD DE PREFERÊNCIAS DE IA (RLM-004: TRANSPARÊNCIA)
 * 
 * Mostra visualmente as preferências pedagógicas ativas que estão sendo
 * aplicadas em TODAS as gerações de IA do sistema.
 * 
 * PROPÓSITO:
 * - Transparência: Professor vê o que está configurado
 * - Conscientização: Entende como suas escolhas afetam os resultados
 * - Acesso rápido: Link para configurações para ajustar preferências
 */
const AiPreferencesDashboard: React.FC<AiPreferencesDashboardProps> = ({
    settings,
    compact = false,
    onOpenSettings
}) => {
    const preferences = {
        methodology: settings.favoriteMethodology || 'Gamification',
        pedagogicalStyle: settings.teachingStyle || 'Construtivista',
        assessmentFocus: settings.assessmentFocus || 'Formativa',
        writingTone: settings.toneOfVoice || 'Prático e Inspiracional'
    };

    const getMethodologyIcon = (method: string) => {
        if (method.includes('Gamif')) return Gamepad2;
        if (method.includes('Problem') || method.includes('ABP')) return Target;
        return FileText;
    };

    const getMethodologyColor = (method: string) => {
        if (method.includes('Gamif')) return 'bg-purple-500';
        if (method.includes('Problem') || method.includes('ABP')) return 'bg-blue-500';
        return 'bg-slate-500';
    };

    const getStyleColor = (style: string) => {
        if (style === 'Construtivista') return 'bg-green-500';
        if (style === 'Sociointeracionista') return 'bg-teal-500';
        return 'bg-slate-500';
    };

    const getFocusColor = (focus: string) => {
        if (focus === 'Formativa') return 'bg-amber-500';
        if (focus === 'Diagnóstica') return 'bg-cyan-500';
        return 'bg-orange-500';
    };

    const getToneColor = (tone: string) => {
        if (tone.includes('Prático')) return 'bg-pink-500';
        return 'bg-indigo-500';
    };

    if (compact) {
        return (
            <div className="bg-gradient-to-br from-slate-50 to-slate-100 border-2 border-slate-200 rounded-xl p-4 shadow-sm">
                <div className="flex items-center gap-2 mb-3">
                    <Shield className="w-5 h-5 text-slate-600" />
                    <h3 className="text-sm font-bold text-slate-700">Preferências de IA Ativas</h3>
                    {onOpenSettings && (
                        <button
                            onClick={onOpenSettings}
                            className="ml-auto text-xs text-slate-500 hover:text-slate-700 underline"
                        >
                            Ajustar
                        </button>
                    )}
                </div>
                <div className="grid grid-cols-2 gap-2">
                    <div className="flex items-center gap-2">
                        {React.createElement(getMethodologyIcon(preferences.methodology), { className: 'w-4 h-4 text-slate-600' })}
                        <span className="text-xs text-slate-600">{preferences.methodology}</span>
                    </div>
                    <div className="flex items-center gap-2">
                        <GraduationCap className="w-4 h-4 text-slate-600" />
                        <span className="text-xs text-slate-600">{preferences.pedagogicalStyle}</span>
                    </div>
                    <div className="flex items-center gap-2">
                        <Target className="w-4 h-4 text-slate-600" />
                        <span className="text-xs text-slate-600">{preferences.assessmentFocus}</span>
                    </div>
                    <div className="flex items-center gap-2">
                        <FileText className="w-4 h-4 text-slate-600" />
                        <span className="text-xs text-slate-600 truncate">{preferences.writingTone}</span>
                    </div>
                </div>
            </div>
        );
    }

    const MethodologyIcon = getMethodologyIcon(preferences.methodology);

    return (
        <div className="bg-gradient-to-br from-white to-slate-50 border-2 border-slate-200 rounded-2xl p-6 shadow-lg">
            {/* Header */}
            <div className="flex items-center justify-between mb-6">
                <div className="flex items-center gap-3">
                    <div className="bg-gradient-to-br from-blue-500 to-purple-600 p-3 rounded-xl shadow-md">
                        <Shield className="w-6 h-6 text-white" />
                    </div>
                    <div>
                        <h2 className="text-lg font-bold text-slate-800">Preferências de IA</h2>
                        <p className="text-xs text-slate-500">Aplicadas em todas as gerações</p>
                    </div>
                </div>
                {onOpenSettings && (
                    <button
                        onClick={onOpenSettings}
                        className="flex items-center gap-2 px-4 py-2 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-lg text-sm font-medium transition-colors"
                    >
                        <Settings className="w-4 h-4" />
                        Configurar
                    </button>
                )}
            </div>

            {/* Preference Cards */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                {/* Metodologia */}
                <div className="bg-white border border-slate-200 rounded-xl p-4 hover:shadow-md transition-shadow">
                    <div className="flex items-center gap-3 mb-2">
                        <div className={`${getMethodologyColor(preferences.methodology)} p-2 rounded-lg`}>
                            <MethodologyIcon className="w-5 h-5 text-white" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-slate-400 uppercase">Metodologia</p>
                            <p className="text-sm font-bold text-slate-800">{preferences.methodology}</p>
                        </div>
                    </div>
                    <p className="text-xs text-slate-600 leading-relaxed">
                        {preferences.methodology.includes('Gamif') && 'Elementos de jogos, desafios e narrativas envolventes'}
                        {preferences.methodology.includes('Problem') && 'Problemas reais, investigação e descoberta autônoma'}
                        {preferences.methodology === 'Traditional' && 'Estrutura clara, exposição e exercícios de fixação'}
                    </p>
                </div>

                {/* Estilo Pedagógico */}
                <div className="bg-white border border-slate-200 rounded-xl p-4 hover:shadow-md transition-shadow">
                    <div className="flex items-center gap-3 mb-2">
                        <div className={`${getStyleColor(preferences.pedagogicalStyle)} p-2 rounded-lg`}>
                            <GraduationCap className="w-5 h-5 text-white" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-slate-400 uppercase">Estilo Pedagógico</p>
                            <p className="text-sm font-bold text-slate-800">{preferences.pedagogicalStyle}</p>
                        </div>
                    </div>
                    <p className="text-xs text-slate-600 leading-relaxed">
                        {preferences.pedagogicalStyle === 'Construtivista' && 'Aluno constrói conhecimento, experimentação e mediação'}
                        {preferences.pedagogicalStyle === 'Sociointeracionista' && 'Aprendizagem via interação social e colaboração'}
                        {preferences.pedagogicalStyle === 'Tradicional' && 'Professor transmite, disciplina e sequência rigorosa'}
                    </p>
                </div>

                {/* Foco Avaliativo */}
                <div className="bg-white border border-slate-200 rounded-xl p-4 hover:shadow-md transition-shadow">
                    <div className="flex items-center gap-3 mb-2">
                        <div className={`${getFocusColor(preferences.assessmentFocus)} p-2 rounded-lg`}>
                            <Target className="w-5 h-5 text-white" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-slate-400 uppercase">Foco Avaliativo</p>
                            <p className="text-sm font-bold text-slate-800">{preferences.assessmentFocus}</p>
                        </div>
                    </div>
                    <p className="text-xs text-slate-600 leading-relaxed">
                        {preferences.assessmentFocus === 'Formativa' && 'Avaliação durante o processo, feedback contínuo'}
                        {preferences.assessmentFocus === 'Somativa' && 'Avaliação ao final, mensuração e classificação'}
                        {preferences.assessmentFocus === 'Diagnóstica' && 'Avaliação antes do início, mapeamento de conhecimentos'}
                    </p>
                </div>

                {/* Tom de Escrita */}
                <div className="bg-white border border-slate-200 rounded-xl p-4 hover:shadow-md transition-shadow">
                    <div className="flex items-center gap-3 mb-2">
                        <div className={`${getToneColor(preferences.writingTone)} p-2 rounded-lg`}>
                            <FileText className="w-5 h-5 text-white" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-slate-400 uppercase">Tom de Escrita</p>
                            <p className="text-sm font-bold text-slate-800">{preferences.writingTone}</p>
                        </div>
                    </div>
                    <p className="text-xs text-slate-600 leading-relaxed">
                        {preferences.writingTone.includes('Prático') && 'Linguagem acessível, exemplos reais e tom motivador'}
                        {preferences.writingTone.includes('Técnico') && 'Terminologia pedagógica, formal e referenciado'}
                    </p>
                </div>
            </div>

            {/* Footer Info */}
            <div className="mt-6 p-4 bg-blue-50 border border-blue-100 rounded-xl">
                <p className="text-xs text-blue-800 leading-relaxed">
                    <strong>🛡️ Guardrails Ativos:</strong> Estas preferências são aplicadas automaticamente em
                    Planejamentos, PDIs, Avaliações e Chat IA. Seu feedback sempre pode sobrescrever estas configurações.
                </p>
            </div>
        </div>
    );
};

export default AiPreferencesDashboard;
