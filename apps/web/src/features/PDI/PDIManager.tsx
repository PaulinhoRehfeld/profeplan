import React, { useEffect } from 'react';
import {
    BookOpen, BrainCircuit, AlertCircle, ClipboardList, FileText,
    ChevronDown, CheckCircle, Sparkles
} from 'lucide-react';

import { usePDIManager } from './usePDIManager';
import PDISidebar from './components/PDISidebar';

// PDI Module Components
import { StudentPDIProfile } from '../../components/School/PDI/StudentPDIProfile';
import { PDIConsolidator } from '../../components/School/PDI/PDIConsolidator';
import { UserProfile } from '../../types';

import { AdaptationFeedbackModal } from './components/AdaptationFeedbackModal';

import { AdaptationDetailsModal } from './components/AdaptationDetailsModal';
import { useFreedayContext } from '../../contexts/FreedayContext';

interface WorkbenchProps {
    userId: string;
    userProfile: UserProfile; // Enforce typing based on types.ts
    setSidebarContent?: (content: React.ReactNode) => void;
}

const PDIManager: React.FC<WorkbenchProps> = ({ userId, userProfile, setSidebarContent }) => {
    // Logic extracted to Custom Hook
    const {
        loading,
        classes,
        lessons,
        selectedClass,
        selectedLesson,
        studentsWithNeeds,
        adaptations,
        error,
        generatingId,
        pdiProfileStudent,
        consolidatorStudent,
        // Setters
        setSelectedLesson,
        setPdiProfileStudent,
        setConsolidatorStudent,
        // Handlers
        handleClassSelect,
        handleGenerateAdaptation,
        handleValidate,
        handleExportDoc,
        handleGenerateReport,
        // Feedback
        feedbackModalOpen,
        lastAdaptationDetails,
        handleSaveFeedback,
        setFeedbackModalOpen,
        viewingAdaptation,
        setViewingAdaptation,
        handleViewAdaptation,
        handleEvaluate
    } = usePDIManager(userId, userProfile);
    const { openWithPrompt } = useFreedayContext();

    // Update Sidebar Content (evita loops de renderização controlando dependências)
    useEffect(() => {
        if (!setSidebarContent) return;

        const studentsCount = studentsWithNeeds.length;
        const adaptationsCount = Object.keys(adaptations).length;
        const pendingCount = studentsWithNeeds.filter(s => !adaptations[s.id]).length;
        const completedCount = studentsWithNeeds.filter(
            s => adaptations[s.id]?.status === 'completed'
        ).length;
        const validatedCount = studentsWithNeeds.filter(
            s => adaptations[s.id]?.status === 'validated'
        ).length;

        setSidebarContent(
            <PDISidebar
                studentsCount={studentsCount}
                adaptationsCount={adaptationsCount}
                pendingCount={pendingCount}
                completedCount={completedCount}
                validatedCount={validatedCount}
                onExportDoc={handleExportDoc}
                onGenerateReport={handleGenerateReport}
                hasAdaptations={adaptationsCount > 0}
                error={error}
            />
        );
        // Dependências reduzidas: contamos apenas números estáveis para evitar gatilhos
        // contínuos por re-renderizações internas do React.
        // IMPORTANTE:
        // Não incluímos handlers (handleExportDoc / handleGenerateReport) nas dependências
        // para evitar loops de renderização causados por novas referências a cada render.
        // Eles continuam acessíveis via closure mais recente.
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [studentsWithNeeds.length, Object.keys(adaptations).length, error]);

    if (loading) {
        return (
            <div className="flex items-center justify-center h-full">
                <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-indigo-600"></div>
                <span className="ml-3 text-slate-600 font-bold">Carregando PDI Manager...</span>
            </div>
        )
    }

    return (
        <div className="flex flex-col h-full bg-slate-50 relative animate-in fade-in duration-500">
            {/* PDI MODULE INTEGRATION: Modals */}
            {pdiProfileStudent && (
                <div
                    className="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4 motion-safe:animate-in motion-safe:fade-in duration-200"
                    role="dialog"
                    aria-modal="true"
                    aria-label="Prontuário PDI do estudante"
                >
                    <div className="bg-white rounded-2xl shadow-2xl w-full max-w-5xl max-h-[90vh] overflow-hidden flex flex-col motion-safe:animate-in motion-safe:zoom-in duration-200">
                        <StudentPDIProfile
                            studentId={pdiProfileStudent.id}
                            onClose={() => setPdiProfileStudent(null)}
                        />
                    </div>
                </div>
            )}

            {consolidatorStudent && (
                <div
                    className="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4 motion-safe:animate-in motion-safe:fade-in duration-200"
                    role="dialog"
                    aria-modal="true"
                    aria-label="Relatório consolidado de PDI do estudante"
                >
                    <div className="bg-white rounded-2xl shadow-2xl w-full max-w-6xl max-h-[95vh] overflow-hidden flex flex-col motion-safe:animate-in motion-safe:zoom-in duration-200">
                        <PDIConsolidator
                            studentId={consolidatorStudent.id}
                            studentName={consolidatorStudent.name}
                            onClose={() => setConsolidatorStudent(null)}
                        />
                    </div>
                </div>
            )}

            {/* FEEDBACK MODAL */}
            <AdaptationFeedbackModal
                isOpen={feedbackModalOpen}
                onClose={() => setFeedbackModalOpen(false)}
                onSave={handleSaveFeedback}
                studentName={lastAdaptationDetails?.studentName || ''}
                lessonTopic={lastAdaptationDetails?.lessonTopic || ''}
            />

            {/* DETAILS MODAL */}
            <AdaptationDetailsModal
                isOpen={!!viewingAdaptation}
                onClose={() => setViewingAdaptation(null)}
                studentName={viewingAdaptation?.studentName || ''}
                content={viewingAdaptation?.content || ''}
            />

            {/* HEADER / TOOLBAR */}
            <div className="bg-white border-b border-slate-200 px-6 py-4 flex justify-between items-center sticky top-0 z-10">
                <div>
                    <h1 className="text-xl font-black text-slate-800 flex items-center gap-2">
                        <BrainCircuit className="text-indigo-600" />
                        Gestão de Inclusão & PDI
                    </h1>
                    <div className="flex items-center gap-4 mt-2">
                        <p className="text-xs text-slate-500 font-bold uppercase tracking-wider">
                            {selectedClass ? `Turma: ${selectedClass.name}` : 'Selecione uma turma'}
                        </p>

                        {selectedClass && (
                            <div className="relative">
                                <select
                                    className="appearance-none bg-indigo-50 border border-indigo-200 text-indigo-700 text-xs font-bold py-2 pl-3 pr-8 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 cursor-pointer hover:bg-indigo-100 transition-colors"
                                    value={selectedLesson?.id || ''}
                                    onChange={(e) => {
                                        const lesson = lessons.find(l => l.id === e.target.value);
                                        setSelectedLesson(lesson || null);
                                    }}
                                >
                                    <option value="">Selecione uma Aula para Adaptar...</option>
                                    {lessons.map(l => (
                                        <option key={l.id} value={l.id}>
                                            {l.topic.substring(0, 40)}{l.topic.length > 40 ? '...' : ''}
                                        </option>
                                    ))}
                                </select>
                                <ChevronDown size={14} className="absolute right-2 top-1/2 -translate-y-1/2 text-indigo-500 pointer-events-none" />
                            </div>
                        )}
                    </div>
                </div>
                <div className="flex items-center gap-3">
                    {error && (
                        <div className="flex items-center gap-2 px-4 py-2 bg-red-50 text-red-600 rounded-lg border border-red-100 animate-pulse">
                            <AlertCircle size={16} />
                            <span className="text-xs font-bold">{error}</span>
                        </div>
                    )}
                    <button
                        type="button"
                        onClick={() => {
                            const className = selectedClass?.name || 'sua turma';
                            const prompt = selectedLesson
                                ? `Estou na tela de Gestão de Inclusão & PDI, trabalhando a aula "${selectedLesson.topic}" da turma ${className}. Me ajude com ideias de adaptação e inclusão para este contexto.`
                                : `Estou na tela de Gestão de Inclusão & PDI para a turma ${className}. Me ajude a organizar por onde começar as adaptações e PDIs.`;
                            openWithPrompt(prompt);
                        }}
                        className="hidden md:inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-slate-100 hover:bg-slate-200 text-[10px] font-black uppercase tracking-[0.2em] text-slate-600 transition-colors"
                    >
                        <Sparkles size={12} />
                        Perguntar à FREEDAY
                    </button>
                </div>
            </div>

            <div className="flex-1 flex overflow-hidden">
                {/* SIDEBAR - Class List */}
                <div className="w-80 bg-white border-r border-slate-200 flex flex-col overflow-y-auto hidden md:flex">
                    <div className="p-4 bg-slate-50 border-b border-slate-100">
                        <h3 className="text-xs font-black uppercase text-slate-400">Minhas Turmas</h3>
                        <p className="mt-1 text-[10px] text-slate-400">
                            Com dúvida sobre PDI ou inclusão? Clique no botão da FREEDAY no canto da tela e peça ajuda.
                        </p>
                    </div>
                    <div className="p-2 space-y-1">
                        {classes.length === 0 ? (
                            <div className="p-4 text-center text-slate-400 text-sm">Nenhuma turma encontrada.</div>
                        ) : (
                            classes.map(cls => (
                                <button
                                    key={cls.id}
                                    onClick={() => handleClassSelect(cls.id)}
                                    className={`w-full text-left px-4 py-3 rounded-xl text-sm font-bold transition-all ${selectedClass?.id === cls.id ? 'bg-indigo-50 text-indigo-700 ring-1 ring-indigo-200' : 'text-slate-600 hover:bg-slate-50'}`}
                                >
                                    {cls.name}
                                    <span className="block text-[10px] font-normal opacity-60 mt-0.5">{cls.subject}</span>
                                </button>
                            ))
                        )}
                    </div>
                </div>

                {/* MAIN CONTENT AREA */}
                <div className="flex-1 overflow-y-auto p-6 md:p-10">
                    {!selectedClass ? (
                        <div className="flex flex-col items-center justify-center h-full text-slate-400 opacity-60 text-center">
                            <BookOpen size={64} className="mb-4 text-slate-300" />
                            <p className="font-bold text-lg mb-1">Selecione uma turma para iniciar</p>
                            <p className="text-xs text-slate-400 max-w-xs">
                                Se tiver dúvidas sobre por onde começar, fale com a FREEDAY: peça ajuda para organizar os PDIs da sua turma.
                            </p>
                        </div>
                    ) : (
                        <div className="max-w-5xl mx-auto">
                            {/* STUDENTS LIST */}
                            {studentsWithNeeds.length === 0 ? (
                                <div className="p-10 bg-white rounded-2xl border border-slate-200 text-center">
                                    <AlertCircle className="w-12 h-12 text-slate-300 mx-auto mb-3" />
                                    <h3 className="text-slate-600 font-bold">Nenhum aluno com PDI nesta turma</h3>
                                    <p className="mt-2 text-xs text-slate-400 max-w-md mx-auto">
                                        Para que os alunos apareçam aqui, marque-os em <strong>Minhas Turmas</strong> com
                                        necessidade de adaptação (campo de observações e/or switch de inclusão).
                                    </p>
                                    <button
                                        className="mt-4 text-indigo-600 font-bold text-sm hover:underline"
                                        onClick={() => {
                                            const className = selectedClass?.name || 'sua turma';
                                            const prompt = `Quero cadastrar um aluno de inclusão para a turma "${className}". Me guie passo a passo para abrir "Minhas Turmas", editar o aluno e marcar que ele necessita adaptação (observações/inclusão) para que apareça no módulo de PDI.`;
                                            try {
                                                openWithPrompt(prompt);
                                            } catch {
                                                // fallback silencioso: não quebra a UI se o contexto da FREEDAY não estiver disponível
                                            }
                                        }}
                                    >
                                        + Cadastrar Aluno de Inclusão
                                    </button>
                                </div>
                            ) : (
                                <div className="space-y-6">
                                    {studentsWithNeeds.map(student => (
                                        <div key={student.id} className="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 flex flex-col md:flex-row gap-6 transition-all hover:shadow-md">
                                            {/* Student Info */}
                                            <div className="flex-1">
                                                <div className="flex items-center gap-3 mb-2">
                                                    <div className="w-10 h-10 rounded-full bg-indigo-100 flex items-center justify-center text-indigo-700 font-black text-sm">
                                                        {student.name.substring(0, 2).toUpperCase()}
                                                    </div>
                                                    <div>
                                                        <div className="flex items-center gap-2">
                                                            <h3 className="text-lg font-black text-slate-800 leading-tight">{student.name}</h3>
                                                            {(() => {
                                                                const status = adaptations[student.id]?.status || 'pending';
                                                                if (status === 'validated') {
                                                                    return (
                                                                        <span className="px-2 py-0.5 rounded-full bg-emerald-50 text-emerald-700 border border-emerald-100 text-[9px] font-black uppercase tracking-widest">
                                                                            Adaptação concluída
                                                                        </span>
                                                                    );
                                                                }
                                                                if (status === 'completed') {
                                                                    return (
                                                                        <span className="px-2 py-0.5 rounded-full bg-amber-50 text-amber-700 border border-amber-100 text-[9px] font-black uppercase tracking-widest">
                                                                            Aguardando validação
                                                                        </span>
                                                                    );
                                                                }
                                                                return (
                                                                    <span className="px-2 py-0.5 rounded-full bg-slate-50 text-slate-500 border border-slate-200 text-[9px] font-black uppercase tracking-widest">
                                                                        Sem adaptação gerada
                                                                    </span>
                                                                );
                                                            })()}
                                                        </div>
                                                        <div className="flex gap-2 mt-1">
                                                            {student.deficiencies?.map((def, i) => (
                                                                <span key={i} className="px-2 py-0.5 bg-rose-50 text-rose-600 text-[10px] font-bold uppercase rounded-md border border-rose-100">
                                                                    {def}
                                                                </span>
                                                            ))}
                                                        </div>
                                                    </div>
                                                </div>

                                                <p className="text-sm text-slate-600 mt-3 line-clamp-2 bg-slate-50 p-3 rounded-lg border border-slate-100 italic">
                                                    "{student.pedagogical_observations || 'Sem observações registradas.'}"
                                                </p>
                                            </div>

                                            {/* Adaptations Status / Result */}
                                            {adaptations[student.id] && (
                                                <div className="mx-6 mb-4 p-4 bg-emerald-50 border border-emerald-100 rounded-xl relative overflow-hidden">
                                                    <div className="flex justify-between items-start mb-2">
                                                        <span className="text-[10px] font-black uppercase tracking-widest text-emerald-600 flex items-center gap-1">
                                                            <CheckCircle size={12} /> Adaptação Gerada
                                                        </span>
                                                        <button
                                                            onClick={() => handleViewAdaptation(student)}
                                                            className="text-[10px] font-bold text-emerald-700 underline"
                                                        >
                                                            Ver Detalhes
                                                        </button>
                                                    </div>
                                                    <p className="text-xs text-emerald-800 italic line-clamp-2">
                                                        "{adaptations[student.id].adaptedContent.substring(0, 100)}..."
                                                    </p>
                                                </div>
                                            )}

                                            {/* Actions Bar */}
                                            <div className="flex flex-row md:flex-col gap-2 shrink-0 border-t md:border-t-0 md:border-l border-slate-100 pt-4 md:pt-0 md:pl-4 justify-center min-w-[180px]">
                                                {selectedLesson && (
                                                    <button
                                                        onClick={() => {
                                                            if (adaptations[student.id]?.status === 'completed') {
                                                                handleValidate(student.id, adaptations[student.id].adaptedContent);
                                                            } else if (adaptations[student.id]?.status === 'validated') {
                                                                handleEvaluate(student);
                                                            } else {
                                                                handleGenerateAdaptation(student);
                                                            }
                                                        }}
                                                        disabled={generatingId === student.id}
                                                        className={`flex items-center gap-2 px-4 py-3 rounded-lg text-xs font-black uppercase tracking-wide transition-all shadow-md text-left
                                                            ${adaptations[student.id]?.status === 'validated'
                                                                ? 'bg-purple-600 hover:bg-purple-700 text-white shadow-purple-200'
                                                                : 'bg-indigo-600 hover:bg-indigo-700 text-white shadow-indigo-200 active:scale-95'
                                                            }
                                                            ${adaptations[student.id]?.status === 'completed'
                                                                ? '!bg-emerald-600 !text-white !hover:bg-emerald-700 !shadow-emerald-200'
                                                                : ''
                                                            }
                                                        `}
                                                    >
                                                        {generatingId === student.id ? (
                                                            <>
                                                                <span className="animate-spin h-3 w-3 border-2 border-white border-t-transparent rounded-full" />
                                                                Gerando...
                                                            </>
                                                        ) : adaptations[student.id]?.status === 'validated' ? (
                                                            <>
                                                                <CheckCircle size={16} />
                                                                Avaliar Adaptação
                                                            </>
                                                        ) : adaptations[student.id]?.status === 'completed' ? (
                                                            <>
                                                                <CheckCircle size={16} />
                                                                Validar & Avaliar
                                                            </>
                                                        ) : (
                                                            <>
                                                                <Sparkles size={16} />
                                                                Gerar Adaptação
                                                            </>
                                                        )}
                                                    </button>
                                                )}
                                                <button
                                                    onClick={() => setPdiProfileStudent(student)}
                                                    className="flex items-center gap-2 px-4 py-2 bg-white border border-slate-200 hover:border-indigo-300 hover:text-indigo-600 rounded-lg text-xs font-bold uppercase text-slate-500 transition-all text-left"
                                                >
                                                    <ClipboardList size={16} /> Ver Prontuário
                                                </button>

                                                <button
                                                    onClick={() => setConsolidatorStudent(student)}
                                                    className="flex items-center gap-2 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-lg text-xs font-bold uppercase transition-all shadow-lg shadow-indigo-100 text-left"
                                                >
                                                    <FileText size={16} /> Relatório PDI
                                                </button>
                                            </div>
                                        </div>
                                    ))}
                                </div>
                            )}
                        </div>
                    )}
                </div>
            </div>
        </div >
    );
};

export default PDIManager;
