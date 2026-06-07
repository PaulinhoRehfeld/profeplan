import React, { useState, useEffect } from 'react';
import {
    FileText, Sparkles, Save, CheckCircle, AlertCircle,
    Loader, Edit3, Eye, Lock
} from 'lucide-react';
import { PdiDocumentService } from '../../../services/pdi/PdiDocumentService';
import { generateBlock11Report } from '../../../services/ai/AiPdiService';

interface PDIBlock11EditorProps {
    pdiId: string;
    studentName: string;
    userId: string;
    userRole: string; // 'supervisor' can edit, others can only view
}

const PDIBlock11Editor: React.FC<PDIBlock11EditorProps> = ({
    pdiId,
    studentName,
    userId,
    userRole
}) => {
    const [loading, setLoading] = useState(true);
    const [generating, setGenerating] = useState(false);
    const [saving, setSaving] = useState(false);
    const [error, setError] = useState('');
    const [success, setSuccess] = useState('');

    const [aiGeneratedReport, setAiGeneratedReport] = useState('');
    const [supervisorEdit, setSupervisorEdit] = useState('');
    const [isApproved, setIsApproved] = useState(false);
    const [editMode, setEditMode] = useState(false);

    const canEdit = userRole === 'supervisor' || userRole === 'school_manager' || userRole === 'school_admin' || userRole === 'admin';

    useEffect(() => {
        loadBlock11();
    }, [pdiId]);

    const loadBlock11 = async () => {
        setLoading(true);
        try {
            const { data: pdi } = await PdiDocumentService.getPdiDocument(pdiId);
            if (pdi) {
                setAiGeneratedReport(pdi.final_report || '');
                setSupervisorEdit(pdi.final_report || '');
                setIsApproved(pdi.status === 'finalizado');
            }
        } catch (err) {
            console.error('Error loading Block 11:', err);
        } finally {
            setLoading(false);
        }
    };

    const handleGenerateReport = async () => {
        setGenerating(true);
        setError('');

        try {
            // Get full PDI document
            const { data: pdi } = await PdiDocumentService.getPdiDocument(pdiId);
            if (!pdi) {
                throw new Error('PDI não encontrado');
            }

            // Generate report
            const report = await generateBlock11Report(
                {
                    student_name: studentName,
                    period: pdi.year.toString(),
                    school_name: '',
                    content_data: pdi.content_data,
                    block_1_8: pdi.block_1_8, // Compatibility
                    block_9_content: pdi.block_9_content || [],
                    block_10_entries: pdi.block_10_entries || [],
                } as any,
                userId
            );

            setAiGeneratedReport(report);
            setSupervisorEdit(report);
            setEditMode(true);
            setSuccess('Relatório gerado com sucesso! Revise e edite se necessário.');

        } catch (err: any) {
            console.error('Error generating report:', err);
            setError(err.message || 'Erro ao gerar relatório');
        } finally {
            setGenerating(false);
        }
    };

    const handleSaveEdit = async () => {
        if (!supervisorEdit.trim()) {
            setError('O relatório não pode estar vazio');
            return;
        }

        setSaving(true);
        setError('');

        try {
            await PdiDocumentService.updateBlock11ByProgument(pdiId, supervisorEdit);
            setSuccess('Relatório salvo com sucesso!');
            setEditMode(false);
            await loadBlock11();
        } catch (err: any) {
            console.error('Error saving Block 11:', err);
            setError(err.message || 'Erro ao salvar relatório');
        } finally {
            setSaving(false);
        }
    };

    const handleApprove = async () => {
        setSaving(true);
        setError('');

        try {
            const { data, error: approveError } = await PdiDocumentService.approveBlock11(pdiId, userId);
            if (approveError) throw approveError;

            setIsApproved(true);
            setSuccess('PDI aprovado e finalizado com sucesso!');
            await loadBlock11();
        } catch (err: any) {
            console.error('Error approving Block 11:', err);
            setError(err.message || 'Erro ao aprovar PDI');
        } finally {
            setSaving(false);
        }
    };

    if (loading) {
        return (
            <div className="flex items-center justify-center py-12">
                <div className="animate-spin rounded-full h-10 w-10 border-4 border-emerald-600 border-t-transparent"></div>
            </div>
        );
    }

    const displayText = supervisorEdit || aiGeneratedReport;
    const hasReport = aiGeneratedReport || supervisorEdit;

    return (
        <div className="space-y-6">

            {/* Header */}
            <div className="bg-gradient-to-r from-emerald-600 to-teal-600 rounded-2xl p-6 text-white">
                <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                        <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center">
                            <FileText size={24} />
                        </div>
                        <div>
                            <h3 className="text-2xl font-black">Bloco 11: Relatório Final</h3>
                            <p className="text-emerald-100 text-sm">
                                Documento oficial de encerramento do PDI
                            </p>
                        </div>
                    </div>
                    {isApproved && (
                        <div className="flex items-center gap-2 bg-white/20 px-4 py-2 rounded-xl">
                            <CheckCircle size={20} />
                            <span className="font-bold">Aprovado e Finalizado</span>
                        </div>
                    )}
                </div>
            </div>

            {/* Permission Notice */}
            {!canEdit && (
                <div className="bg-yellow-50 border border-yellow-200 rounded-xl p-4 flex items-start gap-3">
                    <Lock size={20} className="text-yellow-700 shrink-0 mt-0.5" />
                    <div className="text-sm text-yellow-900">
                        <strong>Modo Visualização:</strong> Apenas gestores escolares podem gerar e editar o relatório final.
                    </div>
                </div>
            )}

            {/* No Report Yet */}
            {!hasReport && canEdit && !isApproved && (
                <div className="bg-white rounded-2xl border-2 border-dashed border-slate-300 p-12 text-center">
                    <div className="w-20 h-20 bg-emerald-100 rounded-full flex items-center justify-center mx-auto mb-4">
                        <Sparkles size={32} className="text-emerald-600" />
                    </div>
                    <h4 className="text-xl font-bold text-slate-900 mb-2">
                        Relatório Final Não Gerado
                    </h4>
                    <p className="text-slate-600 max-w-md mx-auto mb-6">
                        Clique no botão abaixo para que a IA gere o relatório final consolidando
                        todos os blocos anteriores do PDI.
                    </p>
                    <button
                        onClick={handleGenerateReport}
                        disabled={generating}
                        className="flex items-center gap-2 px-8 py-4 bg-emerald-600 hover:bg-emerald-700 text-white font-bold rounded-xl shadow-lg mx-auto disabled:opacity-50 transition-all"
                    >
                        {generating ? (
                            <>
                                <Loader size={20} className="animate-spin" />
                                Gerando Relatório...
                            </>
                        ) : (
                            <>
                                <Sparkles size={20} />
                                Gerar Relatório com IA
                            </>
                        )}
                    </button>
                </div>
            )}

            {/* Display/Edit Report */}
            {hasReport && (
                <div className="bg-white rounded-2xl border border-slate-200 p-8 space-y-6">

                    {/* Toolbar */}
                    {canEdit && !isApproved && (
                        <div className="flex items-center justify-between pb-4 border-b border-slate-200">
                            <div className="flex items-center gap-2">
                                {editMode ? (
                                    <Edit3 size={20} className="text-blue-600" />
                                ) : (
                                    <Eye size={20} className="text-slate-600" />
                                )}
                                <span className="font-bold text-slate-700">
                                    {editMode ? 'Modo Edição' : 'Modo Visualização'}
                                </span>
                            </div>
                            <div className="flex items-center gap-2">
                                {!editMode && (
                                    <button
                                        onClick={() => setEditMode(true)}
                                        className="flex items-center gap-2 px-4 py-2 bg-blue-100 hover:bg-blue-200 text-blue-700 font-semibold rounded-xl transition-colors"
                                    >
                                        <Edit3 size={16} />
                                        Editar
                                    </button>
                                )}
                                {hasReport && !isApproved && (
                                    <button
                                        onClick={handleGenerateReport}
                                        disabled={generating}
                                        className="flex items-center gap-2 px-4 py-2 bg-emerald-100 hover:bg-emerald-200 text-emerald-700 font-semibold rounded-xl transition-colors disabled:opacity-50"
                                    >
                                        {generating ? (
                                            <>
                                                <Loader size={16} className="animate-spin" />
                                                Gerando...
                                            </>
                                        ) : (
                                            <>
                                                <Sparkles size={16} />
                                                Regerar
                                            </>
                                        )}
                                    </button>
                                )}
                            </div>
                        </div>
                    )}

                    {/* Report Content */}
                    {editMode && canEdit && !isApproved ? (
                        <div>
                            <label className="block text-sm font-bold text-slate-700 mb-2">
                                Editar Relatório Final
                            </label>
                            <textarea
                                value={supervisorEdit}
                                onChange={(e) => setSupervisorEdit(e.target.value)}
                                className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-emerald-500 font-mono text-sm resize-none"
                                rows={30}
                                placeholder="Relatório final do PDI..."
                            />
                        </div>
                    ) : (
                        <div className="prose max-w-none">
                            <div className="whitespace-pre-wrap text-slate-900 leading-relaxed">
                                {displayText}
                            </div>
                        </div>
                    )}

                    {/* Action Buttons */}
                    {canEdit && !isApproved && (
                        <div className="flex items-center gap-4 pt-6 border-t border-slate-200">
                            {editMode && (
                                <>
                                    <button
                                        onClick={() => {
                                            setEditMode(false);
                                            setSupervisorEdit(aiGeneratedReport || supervisorEdit);
                                        }}
                                        className="px-6 py-3 bg-slate-200 hover:bg-slate-300 text-slate-700 font-bold rounded-xl transition-colors"
                                    >
                                        Cancelar
                                    </button>
                                    <button
                                        onClick={handleSaveEdit}
                                        disabled={saving}
                                        className="flex items-center gap-2 px-6 py-3 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl shadow-lg disabled:opacity-50 transition-all"
                                    >
                                        {saving ? (
                                            <>
                                                <Loader size={20} className="animate-spin" />
                                                Salvando...
                                            </>
                                        ) : (
                                            <>
                                                <Save size={20} />
                                                Salvar Edição
                                            </>
                                        )}
                                    </button>
                                </>
                            )}
                            {!editMode && hasReport && (
                                <button
                                    onClick={handleApprove}
                                    disabled={saving}
                                    className="flex items-center gap-2 px-8 py-4 bg-green-600 hover:bg-green-700 text-white font-bold rounded-xl shadow-lg disabled:opacity-50 transition-all"
                                >
                                    {saving ? (
                                        <>
                                            <Loader size={20} className="animate-spin" />
                                            Finalizando...
                                        </>
                                    ) : (
                                        <>
                                            <CheckCircle size={20} />
                                            Aprovar e Finalizar PDI
                                        </>
                                    )}
                                </button>
                            )}
                        </div>
                    )}
                </div>
            )}

            {/* Messages */}
            {error && (
                <div className="p-4 bg-red-50 border border-red-200 rounded-xl flex items-center gap-3 text-red-700">
                    <AlertCircle size={20} />
                    <span>{error}</span>
                </div>
            )}

            {success && (
                <div className="p-4 bg-green-50 border border-green-200 rounded-xl flex items-center gap-3 text-green-700">
                    <CheckCircle size={20} />
                    <span>{success}</span>
                </div>
            )}
        </div>
    );
};

export default PDIBlock11Editor;
