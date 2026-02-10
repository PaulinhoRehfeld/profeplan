import React, { useState, useEffect } from 'react';
import { Save, AlertCircle, CheckCircle, Loader, TrendingUp } from 'lucide-react';
import { PdiDocumentService } from '../../../services/pdi/PdiDocumentService';
import { generateBlock10Diagnosis } from '../../../services/geminiService';
import { GrauAutonomia } from '../../../types/pdi';

interface PDIBlock10FormProps {
    pdiId: string;
    studentName: string;
    userId: string;
}

const PDIBlock10Form: React.FC<PDIBlock10FormProps> = ({ pdiId, studentName, userId }) => {
    const [loading, setLoading] = useState(false);
    const [generating, setGenerating] = useState(false);
    const [error, setError] = useState('');
    const [success, setSuccess] = useState(false);

    // Form fields (professor fills)
    const [atividadeTitulo, setAtividadeTitulo] = useState('');
    const [disciplina, setDisciplina] = useState('');
    const [professorValor, setProfessorValor] = useState<number>(10);
    const [professorNota, setProfessorNota] = useState<number>(0);
    const [professorAutonomia, setProfessorAutonomia] = useState<GrauAutonomia>('parcial');

    // AI generated fields (preview)
    const [iaMetodologia, setIaMetodologia] = useState('');
    const [iaDiagnostico, setIaDiagnostico] = useState('');

    const percentual = professorValor > 0 ? ((professorNota / professorValor) * 100).toFixed(1) : '0';

    const handleGenerateAIDiagnosis = async () => {
        if (!atividadeTitulo || !disciplina) {
            setError('Preencha o título da atividade e a disciplina antes de gerar o diagnóstico.');
            return;
        }

        setGenerating(true);
        setError('');

        try {
            // Get full PDI context
            const { data: pdi } = await PdiDocumentService.getPdiDocument(pdiId);
            if (!pdi) {
                throw new Error('PDI não encontrado');
            }

            const fullContext = {
                student_name: studentName,
                content_data: pdi.content_data,
                block_1_8: pdi.block_1_8, // Compatibility
                block_9_history: pdi.block_9_content || [],
                block_10_history: pdi.block_10_entries || [],
            };

            // Generate AI diagnosis
            const result = await generateBlock10Diagnosis(
                {
                    atividade_titulo: atividadeTitulo,
                    disciplina: disciplina,
                    professor_valor: professorValor,
                    professor_nota_alcancada: professorNota,
                    professor_grau_autonomia: professorAutonomia,
                },
                fullContext as any,
                userId
            );

            setIaMetodologia(result.ia_metodologia);
            setIaDiagnostico(result.ia_diagnostico);

        } catch (err: any) {
            console.error('Error generating diagnosis:', err);
            setError(err.message || 'Erro ao gerar diagnóstico. Tente novamente.');
        } finally {
            setGenerating(false);
        }
    };

    const handleSave = async () => {
        if (!atividadeTitulo || !disciplina) {
            setError('Preencha os campos obrigatórios.');
            return;
        }

        if (!iaMetodologia || !iaDiagnostico) {
            setError('Gere o diagnóstico da IA antes de salvar.');
            return;
        }

        setLoading(true);
        setError('');

        try {
            // Add evaluation entry
            const { data: evaluation, error: saveError } = await PdiDocumentService.addBlock10Evaluation(pdiId, {
                data: new Date().toISOString().split('T')[0],
                atividade_titulo: atividadeTitulo,
                disciplina: disciplina,
                professor_valor: professorValor,
                professor_nota_alcancada: professorNota,
                professor_grau_autonomia: professorAutonomia,
                professor_id: userId,
                ia_diagnostico: iaDiagnostico // Pass diagnosis for storage
            });

            if (saveError || !evaluation) {
                throw new Error(saveError?.message || 'Erro ao salvar avaliação');
            }

            // Update with AI-generated content (metodologia)
            await PdiDocumentService.updateBlock10WithAI(
                pdiId,
                evaluation.id,
                iaDiagnostico
            );

            setSuccess(true);

            // Reset form after 2 seconds
            setTimeout(() => {
                setAtividadeTitulo('');
                setDisciplina('');
                setProfessorValor(10);
                setProfessorNota(0);
                setProfessorAutonomia('parcial');
                setIaMetodologia('');
                setIaDiagnostico('');
                setSuccess(false);
            }, 2000);

        } catch (err: any) {
            console.error('Error saving evaluation:', err);
            setError(err.message || 'Erro ao salvar avaliação');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="bg-white rounded-2xl border border-slate-200 p-8 space-y-6">

            {/* Header */}
            <div className="flex items-center gap-3 pb-6 border-b border-slate-200">
                <div className="w-12 h-12 bg-indigo-100 rounded-xl flex items-center justify-center">
                    <TrendingUp size={24} className="text-indigo-600" />
                </div>
                <div>
                    <h3 className="text-2xl font-black text-slate-900">Registrar Avaliação</h3>
                    <p className="text-slate-600">Aluno: <strong>{studentName}</strong></p>
                </div>
            </div>

            {/* Form Fields - Professor */}
            <div className="space-y-6">
                <div>
                    <label className="block text-sm font-bold text-slate-700 mb-2">
                        Título da Atividade/Avaliação <span className="text-red-600">*</span>
                    </label>
                    <input
                        type="text"
                        value={atividadeTitulo}
                        onChange={(e) => setAtividadeTitulo(e.target.value)}
                        className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-indigo-500"
                        placeholder="Ex: Prova Bimestral de Matemática"
                    />
                </div>

                <div>
                    <label className="block text-sm font-bold text-slate-700 mb-2">
                        Disciplina <span className="text-red-600">*</span>
                    </label>
                    <input
                        type="text"
                        value={disciplina}
                        onChange={(e) => setDisciplina(e.target.value)}
                        className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-indigo-500"
                        placeholder="Ex: Matemática"
                    />
                </div>

                <div className="grid md:grid-cols-2 gap-6">
                    <div>
                        <label className="block text-sm font-bold text-slate-700 mb-2">
                            Valor Total da Atividade <span className="text-red-600">*</span>
                        </label>
                        <input
                            type="number"
                            min="0"
                            step="0.5"
                            value={professorValor}
                            onChange={(e) => setProfessorValor(parseFloat(e.target.value) || 0)}
                            className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-indigo-500"
                        />
                    </div>

                    <div>
                        <label className="block text-sm font-bold text-slate-700 mb-2">
                            Nota Alcançada pelo Aluno <span className="text-red-600">*</span>
                        </label>
                        <input
                            type="number"
                            min="0"
                            max={professorValor}
                            step="0.5"
                            value={professorNota}
                            onChange={(e) => setProfessorNota(parseFloat(e.target.value) || 0)}
                            className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:outline-none focus:ring-2 focus:ring-indigo-500"
                        />
                    </div>
                </div>

                {/* Performance Indicator */}
                <div className="bg-slate-50 p-4 rounded-xl">
                    <div className="flex items-center justify-between mb-2">
                        <span className="text-sm font-bold text-slate-700">Percentual de Acerto</span>
                        <span className={`text-2xl font-black ${parseFloat(percentual) >= 70 ? 'text-green-600' :
                            parseFloat(percentual) >= 50 ? 'text-yellow-600' :
                                'text-red-600'
                            }`}>
                            {percentual}%
                        </span>
                    </div>
                    <div className="w-full h-2 bg-slate-200 rounded-full overflow-hidden">
                        <div
                            className={`h-full transition-all duration-500 ${parseFloat(percentual) >= 70 ? 'bg-green-500' :
                                parseFloat(percentual) >= 50 ? 'bg-yellow-500' :
                                    'bg-red-500'
                                }`}
                            style={{ width: `${Math.min(parseFloat(percentual), 100)}%` }}
                        ></div>
                    </div>
                </div>

                <div>
                    <label className="block text-sm font-bold text-slate-700 mb-2">
                        Grau de Autonomia do Aluno <span className="text-red-600">*</span>
                    </label>
                    <div className="grid grid-cols-3 gap-3">
                        {[
                            { value: 'total', label: 'Total', color: 'green' },
                            { value: 'parcial', label: 'Parcial', color: 'yellow' },
                            { value: 'dependente', label: 'Dependente', color: 'red' },
                        ].map((option) => (
                            <button
                                key={option.value}
                                onClick={() => setProfessorAutonomia(option.value as GrauAutonomia)}
                                className={`px-4 py-3 rounded-xl font-bold text-sm transition-all ${professorAutonomia === option.value
                                    ? `bg-${option.color}-600 text-white shadow-lg`
                                    : `bg-${option.color}-100 text-${option.color}-700 hover:bg-${option.color}-200`
                                    }`}
                            >
                                {option.label}
                            </button>
                        ))}
                    </div>
                    <p className="text-xs text-slate-500 mt-2">
                        <strong>Total:</strong> Realizou sozinho | <strong>Parcial:</strong> Precisou de algum apoio | <strong>Dependente:</strong> Precisou de apoio constante
                    </p>
                </div>

                {/* Generate AI Diagnosis Button */}
                <button
                    onClick={handleGenerateAIDiagnosis}
                    disabled={generating || !atividadeTitulo || !disciplina}
                    className="w-full flex items-center justify-center gap-2 px-6 py-4 bg-purple-600 hover:bg-purple-700 text-white font-bold rounded-xl shadow-lg disabled:opacity-50 disabled:cursor-not-allowed transition-all"
                >
                    {generating ? (
                        <>
                            <Loader size={20} className="animate-spin" />
                            Gerando Diagnóstico Pedagógico...
                        </>
                    ) : (
                        <>
                            <TrendingUp size={20} />
                            Gerar Diagnóstico com IA
                        </>
                    )}
                </button>
            </div>

            {/* AI Generated Fields (Preview) */}
            {(iaMetodologia || iaDiagnostico) && (
                <div className="space-y-4 pt-6 border-t border-slate-200">
                    <h4 className="text-lg font-black text-slate-900">Diagnóstico Gerado pela IA</h4>

                    {iaMetodologia && (
                        <div>
                            <label className="block text-sm font-bold text-purple-700 mb-2">
                                Metodologia Utilizada
                            </label>
                            <div className="bg-purple-50 p-4 rounded-xl text-slate-900 whitespace-pre-wrap">
                                {iaMetodologia}
                            </div>
                        </div>
                    )}

                    {iaDiagnostico && (
                        <div>
                            <label className="block text-sm font-bold text-blue-700 mb-2">
                                Diagnóstico Pedagógico
                            </label>
                            <div className="bg-blue-50 p-4 rounded-xl text-slate-900 whitespace-pre-wrap">
                                {iaDiagnostico}
                            </div>
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
                    <span>Avaliação registrada com sucesso!</span>
                </div>
            )}

            {/* Save Button */}
            {(iaMetodologia && iaDiagnostico) && (
                <button
                    onClick={handleSave}
                    disabled={loading}
                    className="w-full flex items-center justify-center gap-2 px-6 py-4 bg-green-600 hover:bg-green-700 text-white font-bold rounded-xl shadow-lg disabled:opacity-50 transition-all"
                >
                    {loading ? (
                        <>
                            <Loader size={20} className="animate-spin" />
                            Salvando...
                        </>
                    ) : (
                        <>
                            <Save size={20} />
                            Salvar Registro de Avaliação
                        </>
                    )}
                </button>
            )}
        </div>
    );
};

export default PDIBlock10Form;
