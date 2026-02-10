import React, { useEffect, useState } from 'react';
import {
    TrendingUp, Calendar, Award, User, BarChart3,
    CheckCircle, AlertCircle, Minus, ChevronDown, ChevronUp
} from 'lucide-react';
import { PdiDocumentService } from '../../../services/pdi/PdiDocumentService';
import { Block10Entry } from '../../../types/pdi';

interface PDIBlock10ViewerProps {
    pdiId: string;
}

const PDIBlock10Viewer: React.FC<PDIBlock10ViewerProps> = ({ pdiId }) => {
    const [entries, setEntries] = useState<Block10Entry[]>([]);
    const [loading, setLoading] = useState(true);
    const [expandedIds, setExpandedIds] = useState<Set<string>>(new Set());

    useEffect(() => {
        loadEntries();
    }, [pdiId]);

    const loadEntries = async () => {
        setLoading(true);
        try {
            const { data: pdi } = await PdiDocumentService.getPdiDocument(pdiId);
            if (pdi && pdi.block_10_entries) {
                // Map database entries to UI-expected Block10Entry structure if different
                const mappedEntries: any[] = pdi.block_10_entries.map(e => ({
                    avaliacao_id: e.id,
                    data: e.created_at || new Date().toISOString(),
                    atividade_titulo: e.subject || 'Avaliação',
                    disciplina: e.subject,
                    professor_valor: 10, // Assuming default or fetch from metadata
                    professor_nota_alcancada: 0, // Fallback
                    professor_grau_autonomia: e.autonomy_level || 'parcial',
                    ia_diagnostico: e.observations,
                    ia_metodologia: (e as any).methodology // If exists
                }));

                // Sort by date desc
                const sorted = [...mappedEntries].sort((a, b) =>
                    new Date(b.data).getTime() - new Date(a.data).getTime()
                );
                setEntries(sorted);
            }
        } catch (error) {
            console.error('Error loading Block 10 entries:', error);
        } finally {
            setLoading(false);
        }
    };

    const toggleExpanded = (id: string) => {
        const newExpanded = new Set(expandedIds);
        if (newExpanded.has(id)) {
            newExpanded.delete(id);
        } else {
            newExpanded.add(id);
        }
        setExpandedIds(newExpanded);
    };

    const getAutonomyIcon = (autonomia: string) => {
        switch (autonomia) {
            case 'total':
                return <CheckCircle size={18} className="text-green-600" />;
            case 'parcial':
                return <Minus size={18} className="text-yellow-600" />;
            case 'dependente':
                return <AlertCircle size={18} className="text-red-600" />;
            default:
                return null;
        }
    };

    const getAutonomyLabel = (autonomia: string) => {
        switch (autonomia) {
            case 'total':
                return 'Total';
            case 'parcial':
                return 'Parcial';
            case 'dependente':
                return 'Dependente';
            default:
                return autonomia;
        }
    };

    const getPerformanceColor = (percentual: number) => {
        if (percentual >= 70) return 'text-green-600';
        if (percentual >= 50) return 'text-yellow-600';
        return 'text-red-600';
    };

    const calculateAverage = () => {
        if (entries.length === 0) return 0;
        const sum = entries.reduce((acc, entry) => {
            const perc = (entry.professor_nota_alcancada / entry.professor_valor) * 100;
            return acc + perc;
        }, 0);
        return (sum / entries.length).toFixed(1);
    };

    if (loading) {
        return (
            <div className="flex items-center justify-center py-12">
                <div className="animate-spin rounded-full h-10 w-10 border-4 border-indigo-600 border-t-transparent"></div>
            </div>
        );
    }

    if (entries.length === 0) {
        return (
            <div className="bg-slate-50 border-2 border-dashed border-slate-300 rounded-2xl p-12 text-center">
                <div className="w-20 h-20 bg-slate-200 rounded-full flex items-center justify-center mx-auto mb-4">
                    <BarChart3 size={32} className="text-slate-400" />
                </div>
                <h3 className="text-xl font-bold text-slate-900 mb-2">
                    Nenhuma Avaliação Registrada
                </h3>
                <p className="text-slate-600 max-w-md mx-auto">
                    Use o formulário acima para registrar a primeira avaliação deste aluno.
                </p>
            </div>
        );
    }

    const mediaGeral = calculateAverage();

    return (
        <div className="space-y-6">

            {/* Stats Header */}
            <div className="bg-gradient-to-r from-indigo-600 to-purple-600 rounded-2xl p-6 text-white">
                <div className="flex items-center gap-3 mb-4">
                    <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center">
                        <TrendingUp size={24} />
                    </div>
                    <div>
                        <h3 className="text-2xl font-black">Bloco 10: Histórico de Avaliações</h3>
                        <p className="text-indigo-100 text-sm">Registros do professor + Diagnósticos da IA</p>
                    </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                    <div className="bg-white/10 rounded-xl p-4">
                        <div className="text-3xl font-black mb-1">{entries.length}</div>
                        <div className="text-sm text-indigo-100">Avaliações Registradas</div>
                    </div>
                    <div className="bg-white/10 rounded-xl p-4">
                        <div className={`text-3xl font-black mb-1 ${getPerformanceColor(Number(mediaGeral))}`}>
                            {mediaGeral}%
                        </div>
                        <div className="text-sm text-indigo-100">Média Geral</div>
                    </div>
                </div>
            </div>

            {/* Entries List */}
            <div className="space-y-4">
                {entries.map((entry) => {
                    const isExpanded = expandedIds.has(entry.avaliacao_id);
                    const percentual = ((entry.professor_nota_alcancada / entry.professor_valor) * 100).toFixed(1);

                    return (
                        <div
                            key={entry.avaliacao_id}
                            className="bg-white rounded-2xl border border-slate-200 overflow-hidden hover:border-indigo-400 transition-colors"
                        >
                            {/* Header */}
                            <button
                                onClick={() => toggleExpanded(entry.avaliacao_id)}
                                className="w-full p-6 flex items-center justify-between hover:bg-slate-50 transition-colors"
                            >
                                <div className="flex items-start gap-4 flex-1 text-left">
                                    <div className={`w-16 h-16 rounded-xl flex flex-col items-center justify-center shrink-0 ${parseFloat(percentual) >= 70 ? 'bg-green-100' :
                                        parseFloat(percentual) >= 50 ? 'bg-yellow-100' :
                                            'bg-red-100'
                                        }`}>
                                        <div className={`text-2xl font-black ${parseFloat(percentual) >= 70 ? 'text-green-600' :
                                            parseFloat(percentual) >= 50 ? 'text-yellow-600' :
                                                'text-red-600'
                                            }`}>
                                            {percentual}%
                                        </div>
                                    </div>
                                    <div className="flex-1">
                                        <h4 className="text-lg font-bold text-slate-900 mb-1">
                                            {entry.atividade_titulo}
                                        </h4>
                                        <div className="flex flex-wrap items-center gap-4 text-sm text-slate-600">
                                            <span className="flex items-center gap-1">
                                                <Award size={14} />
                                                {entry.disciplina}
                                            </span>
                                            <span className="flex items-center gap-1">
                                                {getAutonomyIcon(entry.professor_grau_autonomia)}
                                                {getAutonomyLabel(entry.professor_grau_autonomia)}
                                            </span>
                                            <span className="flex items-center gap-1">
                                                <Calendar size={14} />
                                                {new Date(entry.data).toLocaleDateString('pt-BR')}
                                            </span>
                                            <span className="font-semibold text-slate-700">
                                                {entry.professor_nota_alcancada}/{entry.professor_valor} pontos
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

                                    {/* Metodologia (IA) */}
                                    {entry.ia_metodologia && (
                                        <div className="mt-6">
                                            <div className="flex items-center gap-2 mb-3">
                                                <User size={20} className="text-purple-600" />
                                                <h5 className="text-sm font-bold text-slate-700 uppercase tracking-wider">
                                                    Metodologia Utilizada (IA)
                                                </h5>
                                            </div>
                                            <div className="bg-purple-50 p-4 rounded-xl text-slate-900 whitespace-pre-wrap">
                                                {entry.ia_metodologia}
                                            </div>
                                        </div>
                                    )}

                                    {/* Diagnóstico (IA) */}
                                    {entry.ia_diagnostico && (
                                        <div>
                                            <div className="flex items-center gap-2 mb-3">
                                                <TrendingUp size={20} className="text-blue-600" />
                                                <h5 className="text-sm font-bold text-slate-700 uppercase tracking-wider">
                                                    Diagnóstico Pedagógico (IA)
                                                </h5>
                                            </div>
                                            <div className="bg-blue-50 p-4 rounded-xl text-slate-900 whitespace-pre-wrap">
                                                {entry.ia_diagnostico}
                                            </div>
                                        </div>
                                    )}

                                    {/* Metadata */}
                                    <div className="pt-4 border-t border-slate-100">
                                        <div className="flex items-center gap-4 text-xs text-slate-500">
                                            <span>Registrado em: {new Date(entry.created_at).toLocaleString('pt-BR')}</span>
                                            {entry.ia_generated_at && (
                                                <span>IA gerada em: {new Date(entry.ia_generated_at).toLocaleString('pt-BR')}</span>
                                            )}
                                        </div>
                                    </div>
                                </div>
                            )}
                        </div>
                    );
                })}
            </div>

            {/* Performance Chart Placeholder */}
            {entries.length > 1 && (
                <div className="bg-white rounded-2xl border border-slate-200 p-6">
                    <h4 className="text-lg font-bold text-slate-900 mb-4 flex items-center gap-2">
                        <BarChart3 size={20} className="text-indigo-600" />
                        Evolução do Desempenho
                    </h4>
                    <div className="h-48 bg-slate-50 rounded-xl flex items-center justify-center">
                        <p className="text-slate-500 text-sm">
                            Gráfico de evolução (implementar biblioteca de charts futuramente)
                        </p>
                    </div>
                </div>
            )}
        </div>
    );
};

export default PDIBlock10Viewer;
