import React, { useEffect, useState } from 'react';
import {
    BookOpen, Calendar, Target, Wrench, Clock,
    Sparkles, ChevronDown, ChevronUp, RefreshCw
} from 'lucide-react';
import { PdiDocumentService } from '../../../services/pdi/PdiDocumentService';
import { Block9AdaptationEntry } from '../../../types/pdi';

interface PDIBlock9ViewerProps {
    pdiId: string;
}

const PDIBlock9Viewer: React.FC<PDIBlock9ViewerProps> = ({ pdiId }) => {
    const [adaptations, setAdaptations] = useState<Block9AdaptationEntry[]>([]);
    const [stats, setStats] = useState<any>(null);
    const [loading, setLoading] = useState(true);
    const [expandedIds, setExpandedIds] = useState<Set<string>>(new Set());

    useEffect(() => {
        loadAdaptations();
    }, [pdiId]);

    const loadAdaptations = async () => {
        setLoading(true);
        try {
            const [adaptationsData, statsData] = await Promise.all([
                PdiDocumentService.getStudentAdaptations(pdiId),
                PdiDocumentService.getAdaptationStats(pdiId),
            ]);
            setAdaptations(adaptationsData);
            setStats(statsData);
        } catch (error) {
            console.error('Error loading Block 9 adaptations:', error);
        } finally {
            setLoading(false);
        }
    };

    const toggleExpanded = (lessonId: string) => {
        const newExpanded = new Set(expandedIds);
        if (newExpanded.has(lessonId)) {
            newExpanded.delete(lessonId);
        } else {
            newExpanded.add(lessonId);
        }
        setExpandedIds(newExpanded);
    };

    if (loading) {
        return (
            <div className="flex items-center justify-center py-12">
                <div className="animate-spin rounded-full h-10 w-10 border-4 border-blue-600 border-t-transparent"></div>
            </div>
        );
    }

    if (adaptations.length === 0) {
        return (
            <div className="bg-slate-50 border-2 border-dashed border-slate-300 rounded-2xl p-12 text-center">
                <div className="w-20 h-20 bg-slate-200 rounded-full flex items-center justify-center mx-auto mb-4">
                    <Sparkles size={32} className="text-slate-400" />
                </div>
                <h3 className="text-xl font-bold text-slate-900 mb-2">
                    Nenhuma Adaptação Gerada Ainda
                </h3>
                <p className="text-slate-600 max-w-md mx-auto">
                    As adaptações curriculares serão geradas automaticamente quando o professor salvar
                    novos planejamentos de aula.
                </p>
            </div>
        );
    }

    return (
        <div className="space-y-6">

            {/* Stats Header */}
            <div className="bg-gradient-to-r from-purple-600 to-blue-600 rounded-2xl p-6 text-white">
                <div className="flex items-center justify-between mb-4">
                    <div className="flex items-center gap-3">
                        <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center">
                            <Sparkles size={24} />
                        </div>
                        <div>
                            <h3 className="text-2xl font-black">Bloco 9: Adaptações Pedagógicas</h3>
                            <p className="text-purple-100 text-sm">Gerado automaticamente pela IA</p>
                        </div>
                    </div>
                    <button
                        onClick={loadAdaptations}
                        className="flex items-center gap-2 px-4 py-2 bg-white/20 hover:bg-white/30 rounded-xl transition-colors"
                    >
                        <RefreshCw size={18} />
                        <span className="font-semibold">Atualizar</span>
                    </button>
                </div>

                <div className="grid grid-cols-3 gap-4">
                    <div className="bg-white/10 rounded-xl p-4">
                        <div className="text-3xl font-black mb-1">{stats.total}</div>
                        <div className="text-sm text-purple-100">Adaptações Criadas</div>
                    </div>
                    <div className="bg-white/10 rounded-xl p-4">
                        <div className="text-3xl font-black mb-1">{stats.subjects.length}</div>
                        <div className="text-sm text-purple-100">Disciplinas</div>
                    </div>
                    <div className="bg-white/10 rounded-xl p-4">
                        <div className="text-sm font-bold text-purple-100 mb-1">Última Atualização</div>
                        <div className="text-sm">
                            {stats.last_generated
                                ? new Date(stats.last_generated).toLocaleDateString('pt-BR')
                                : 'N/A'}
                        </div>
                    </div>
                </div>
            </div>

            {/* Adaptations List */}
            <div className="space-y-4">
                {adaptations.map((adaptation, index) => {
                    const isExpanded = expandedIds.has(adaptation.lesson_id);

                    return (
                        <div
                            key={`${adaptation.lesson_id}-${index}`}
                            className="bg-white rounded-2xl border border-slate-200 overflow-hidden hover:border-blue-400 transition-colors"
                        >
                            {/* Header */}
                            <button
                                onClick={() => toggleExpanded(adaptation.lesson_id)}
                                className="w-full p-6 flex items-center justify-between hover:bg-slate-50 transition-colors"
                            >
                                <div className="flex items-start gap-4 flex-1 text-left">
                                    <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center shrink-0">
                                        <BookOpen size={24} className="text-blue-600" />
                                    </div>
                                    <div className="flex-1">
                                        <h4 className="text-lg font-bold text-slate-900 mb-1">
                                            {adaptation.lesson_title}
                                        </h4>
                                        <div className="flex flex-wrap items-center gap-3 text-sm text-slate-600">
                                            <span className="flex items-center gap-1">
                                                <BookOpen size={14} />
                                                {adaptation.subject}
                                            </span>
                                            {adaptation.tempo_estimado && (
                                                <span className="flex items-center gap-1">
                                                    <Clock size={14} />
                                                    {adaptation.tempo_estimado}
                                                </span>
                                            )}
                                            <span className="flex items-center gap-1">
                                                <Calendar size={14} />
                                                {new Date(adaptation.generated_at).toLocaleDateString('pt-BR')}
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                <div className="shrink-0 ml-4">
                                    {isExpanded ? (
                                        <ChevronUp size={24} className="text-slate-400" />
                                    ) : (
                                        <ChevronDown size={24} className="text-slate-400" />
                                    )}
                                </div>
                            </button>

                            {/* Expanded Content */}
                            {isExpanded && (
                                <div className="px-6 pb-6 space-y-6 border-t border-slate-100">

                                    {/* Adaptação Metodológica */}
                                    <div>
                                        <div className="flex items-center gap-2 mb-3 mt-6">
                                            <Sparkles size={20} className="text-purple-600" />
                                            <h5 className="text-sm font-bold text-slate-700 uppercase tracking-wider">
                                                Adaptação Metodológica
                                            </h5>
                                        </div>
                                        <div className="bg-purple-50 p-4 rounded-xl text-slate-900 whitespace-pre-wrap">
                                            {adaptation.adaptacao_metodologica}
                                        </div>
                                    </div>

                                    {/* Objetivos Adaptados */}
                                    <div>
                                        <div className="flex items-center gap-2 mb-3">
                                            <Target size={20} className="text-green-600" />
                                            <h5 className="text-sm font-bold text-slate-700 uppercase tracking-wider">
                                                Objetivos Adaptados
                                            </h5>
                                        </div>
                                        <ul className="space-y-2">
                                            {adaptation.objetivos_adaptados.map((obj, i) => (
                                                <li key={i} className="flex items-start gap-2">
                                                    <span className="w-6 h-6 bg-green-100 text-green-700 rounded-full flex items-center justify-center text-xs font-bold shrink-0 mt-0.5">
                                                        {i + 1}
                                                    </span>
                                                    <span className="text-slate-900">{obj}</span>
                                                </li>
                                            ))}
                                        </ul>
                                    </div>

                                    {/* Recursos Adaptados */}
                                    <div>
                                        <div className="flex items-center gap-2 mb-3">
                                            <Wrench size={20} className="text-orange-600" />
                                            <h5 className="text-sm font-bold text-slate-700 uppercase tracking-wider">
                                                Recursos Adaptados
                                            </h5>
                                        </div>
                                        <div className="flex flex-wrap gap-2">
                                            {adaptation.recursos_adaptados.map((recurso, i) => (
                                                <span
                                                    key={i}
                                                    className="px-3 py-1.5 bg-orange-100 text-orange-700 rounded-lg text-sm font-semibold"
                                                >
                                                    {recurso}
                                                </span>
                                            ))}
                                        </div>
                                    </div>

                                    {/* Estratégias de Ensino */}
                                    <div>
                                        <div className="flex items-center gap-2 mb-3">
                                            <BookOpen size={20} className="text-blue-600" />
                                            <h5 className="text-sm font-bold text-slate-700 uppercase tracking-wider">
                                                Estratégias de Ensino
                                            </h5>
                                        </div>
                                        <ul className="space-y-2">
                                            {adaptation.estrategias_ensino.map((estrategia, i) => (
                                                <li key={i} className="flex items-start gap-2">
                                                    <span className="w-1.5 h-1.5 bg-blue-500 rounded-full mt-2 shrink-0"></span>
                                                    <span className="text-slate-900">{estrategia}</span>
                                                </li>
                                            ))}
                                        </ul>
                                    </div>

                                    {/* Habilidades BNCC */}
                                    {adaptation.habilidades_bncc && adaptation.habilidades_bncc.length > 0 && (
                                        <div>
                                            <h5 className="text-sm font-bold text-slate-700 uppercase tracking-wider mb-2">
                                                Habilidades BNCC
                                            </h5>
                                            <div className="flex flex-wrap gap-2">
                                                {adaptation.habilidades_bncc.map((bncc, i) => (
                                                    <span
                                                        key={i}
                                                        className="px-2 py-1 bg-slate-100 text-slate-700 rounded text-xs font-mono"
                                                    >
                                                        {bncc}
                                                    </span>
                                                ))}
                                            </div>
                                        </div>
                                    )}
                                </div>
                            )}
                        </div>
                    );
                })}
            </div>
        </div>
    );
};

export default PDIBlock9Viewer;
