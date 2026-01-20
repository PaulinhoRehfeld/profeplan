import React, { useState, useEffect } from 'react';
import {
    BookOpen, BrainCircuit, AlertCircle
} from 'lucide-react';
import { getClasses, getClassDetails, getPdiLogs, supabase } from '../../services/supabaseService';
import { getGeneratedContents } from '../../services/databaseService';

import { generateStudentAdaptation, generatePdiReport } from '../../services/geminiService';
import { generateInclusionDoc, generatePdiReportDoc, buildInclusionDocHtml } from '../../services/exportService';
import { saveGeneratedContent } from '../../services/databaseService';
import { Class, Student, StudentAdaptation } from '../../types';
import {
    getLocalClasses,
    getLocalClassDetails,
    savePdiLogToLocal,
    getLocalPdiLogs
} from '../../services/localStorageService';

// New Architecture
import { useGlobalPlanning } from '../../contexts/GlobalPlanningContext';
import { savePdiLog } from './PDIService';
import { Sparkles, Globe } from 'lucide-react';
import PDISidebar from './components/PDISidebar';
import StudentAdaptationCard from './components/StudentAdaptationCard';

interface WorkbenchProps {
    userId: string;
    setSidebarContent?: (content: React.ReactNode) => void;
}

const PDIManager: React.FC<WorkbenchProps> = ({ userId, setSidebarContent }) => {
    const [lessons, setLessons] = useState<any[]>([]);
    const [classes, setClasses] = useState<Class[]>([]);
    const [selectedLesson, setSelectedLesson] = useState<any | null>(null);
    const [selectedClass, setSelectedClass] = useState<Class | null>(null);
    const [studentsWithNeeds, setStudentsWithNeeds] = useState<Student[]>([]);

    // Adaptations State: Map studentId -> Adaptation Data
    const [adaptations, setAdaptations] = useState<Record<string, StudentAdaptation>>({});
    const [loading, setLoading] = useState(false);
    const [generatingId, setGeneratingId] = useState<string | null>(null);
    const [error, setError] = useState('');

    // Global Context (Coordinator Agent)
    const { currentPlan } = useGlobalPlanning();
    const [contextBadge, setContextBadge] = useState<boolean>(false);

    // Mobile Tabs State
    const [mobileTab, setMobileTab] = useState<'source' | 'workbench'>('workbench');

    useEffect(() => {
        // Auto-fill from Coordinator Agent
        if (currentPlan) {
            console.log("Receiving Context from Coordinator:", currentPlan);
            setContextBadge(true);
            // Here we could filter classes or lessons based on the plan
            // For now, we just indicate the connection exists
        }
    }, [currentPlan]);

    useEffect(() => {
        // Connectivity Test (Migration Check)
        const checkConnection = async () => {
            console.log("Testing connection to NEW Supabase Project...");
            try {
                const { count, error } = await supabase.from('students').select('*', { count: 'exact', head: true });
                if (error) console.error("Connection Check Failed:", error);
                else console.log("Connection Check SUCCESS! Student count:", count);
            } catch (err) {
                console.error("Connection Check Exception:", err);
            }
        };
        checkConnection();

        loadInitialData();
    }, [userId]);

    const loadInitialData = async () => {
        setLoading(true);
        // Fetch Lessons
        try {
            const genContents = await getGeneratedContents(userId);
            const mappedLessons = genContents ? genContents.map((item: any) => ({
                id: item.id,
                topic: item.title,
                content: item.content,
                type: item.type
            })) : [];
            setLessons(mappedLessons);
        } catch (e) {
            console.error("Error loading lessons", e);
        }

        // Fetch Classes (Mixed Source)
        try {
            const { data: sbClasses } = await getClasses(userId);
            const localClassesRaw = getLocalClasses(userId);
            const localClassesMapped: Class[] = localClassesRaw.map(c => ({
                id: c.id,
                name: c.name,
                subject: c.subject,
                created_at: c.createdAt,
                students: c.students.map((s: any) => ({
                    id: s.id,
                    name: s.name,
                    class_id: c.id,
                    needs_adaptation: s.needs_adaptation || false,
                    deficiencies: s.deficiencies || [],
                    pedagogical_observations: s.pedagogical_observations || ''
                }))
            }));

            const localIds = new Set(localClassesMapped.map(c => c.id));
            const uniqueSbClasses = (sbClasses || []).filter(c => !localIds.has(c.id));
            const mergedClasses = [...uniqueSbClasses, ...localClassesMapped];
            setClasses(mergedClasses);
        } catch (e) {
            console.error("Error loading classes", e);
        }
        setLoading(false);
    };

    const handleClassSelect = async (classId: string) => {
        // Local first
        const localData = getLocalClassDetails(classId);
        if (localData) {
            const mappedClass: Class = {
                id: localData.id,
                name: localData.name,
                subject: localData.subject,
                created_at: localData.createdAt,
                students: localData.students.map((s: any) => ({
                    id: s.id,
                    name: s.name,
                    class_id: localData.id,
                    needs_adaptation: s.needs_adaptation || false,
                    deficiencies: s.deficiencies || [],
                    pedagogical_observations: s.pedagogical_observations || ''
                }))
            };
            setSelectedClass(mappedClass);
            const needs = mappedClass.students?.filter((s: Student) => s.needs_adaptation || (s.deficiencies && s.deficiencies.length > 0)) || [];
            setStudentsWithNeeds(needs);
            setAdaptations({});
        } else {
            // Supabase fallback
            const cls = classes.find(c => c.id === classId);
            if (cls) {
                const { data } = await getClassDetails(classId);
                if (data) {
                    setSelectedClass(data);
                    const needs = data.students?.filter((s: Student) => s.needs_adaptation || (s.deficiencies && s.deficiencies.length > 0)) || [];
                    setStudentsWithNeeds(needs);
                    setAdaptations({});
                }
            }
        }
    };

    const handleGenerateAdaptation = async (student: Student) => {
        if (!selectedLesson) {
            setError('Selecione uma aula de referência primeiro.');
            return;
        }
        setGeneratingId(student.id);
        setError('');
        try {
            const result = await generateStudentAdaptation(
                selectedLesson.content,
                student.name,
                student.deficiencies,
                student.pedagogical_observations,
                selectedClass?.name || 'Série não informada',
                {
                    stateBase: currentPlan?.stateBase,
                    educationSphere: currentPlan?.educationSphere,
                    userId
                }
            );
            setAdaptations(prev => ({
                ...prev,
                [student.id]: {
                    studentId: student.id,
                    studentName: student.name,
                    originalContent: selectedLesson.content,
                    adaptedContent: result,
                    status: 'completed'
                }
            }));
        } catch (e) {
            console.error(e);
            setError(`Erro ao gerar para ${student.name}`);
        } finally {
            setGeneratingId(null);
        }
    };

    const handleValidate = async (studentId: string, content: string) => {
        if (!selectedClass || !selectedLesson) return;

        const student = studentsWithNeeds.find(s => s.id === studentId);
        const studentName = student ? student.name : 'Aluno Desconhecido';

        // PILAR C: Sanitization (Remove Word/Office XML garbage)
        const sanitizedContent = content
            .replace(/<html[\s\S]*?>[\s\S]*?<\/head>/gi, "")
            .replace(/<[^>]+>/g, "")
            .trim();

        const finalContent = sanitizedContent.length > 0 ? sanitizedContent : content.substring(0, 5000);

        const logPayload = {
            student_id: studentId,
            student_name: studentName,
            class_id: selectedClass.id,
            lesson_id: selectedLesson.id,
            teacher_id: userId,
            content: finalContent,
            original_content: selectedLesson.content
        };

        // LOCAL FIRST STRATEGY (Unified Service)
        // Service handles LocalStorage + Background Sync
        await savePdiLog(logPayload);

        // Optimistic Update UI
        setAdaptations(prev => ({
            ...prev,
            [studentId]: {
                ...prev[studentId],
                status: 'validated'
            }
        }));
    };

    const handleExportDoc = async () => {
        if (!selectedLesson) return;
        const validAdaptations = (Object.values(adaptations) as StudentAdaptation[]).filter(a => a.status === 'completed' || a.status === 'validated').map(a => ({
            studentName: a.studentName,
            content: a.adaptedContent
        }));

        if (validAdaptations.length === 0) {
            setError('Nenhuma adaptação gerada para exportar.');
            return;
        }

        try {
            const htmlContent = buildInclusionDocHtml(
                { title: selectedLesson.topic, content: selectedLesson.content },
                validAdaptations
            );
            await saveGeneratedContent(
                userId,
                'documento',
                `PDI - ${selectedLesson.topic.substring(0, 40)}`,
                htmlContent
            );
        } catch (e) {
            console.warn("Falha no autosave", e);
        }
        generateInclusionDoc(
            { title: selectedLesson.topic, content: selectedLesson.content },
            validAdaptations
        );
    };

    const handleGenerateReport = async () => {
        if (studentsWithNeeds.length === 0) return;
        const student = studentsWithNeeds[0];
        try {
            // DEBUG: Ensure we can read
            console.log(`Checking logs for student ${student.id} (${student.name})`);
            const { data: logs, error: logsError } = await getPdiLogs(student.id);

            if (logsError) throw logsError;

            if (!logs || logs.length === 0) {
                setError(`Sem histórico para o aluno ${student.name}. Valide pelo menos uma adaptação.`);
                return;
            }

            setLoading(true);
            const report = await generatePdiReport(logs, student.name, 'Bimestre Atual');

            try {
                const reportHtml = `
                    <html><body>
                    <h1>Relatório de Desenvolvimento Individual</h1>
                    <p><strong>Estudante:</strong> ${student.name}</p>
                    <div>${report.replace(/\n/g, '<br/>')}</div>
                    </body></html>
                `;
                await saveGeneratedContent(
                    userId,
                    'documento',
                    `RELATORIO PDI - ${student.name}`,
                    reportHtml
                );
            } catch (e) {
                console.warn("Falha no autosave", e);
            }
            generatePdiReportDoc(student.name, 'Bimestre Atual', report);
        } catch (e: any) {
            console.error(e);
            setError(`Erro: ${e.message || 'Falha ao gerar relatório'}`);
        } finally {
            setLoading(false);
        }
    };

    // Update Sidebar Content
    useEffect(() => {
        if (!setSidebarContent) return;
        setSidebarContent(
            <PDISidebar
                studentsCount={studentsWithNeeds.length}
                adaptationsCount={Object.keys(adaptations).length}
                onExportDoc={handleExportDoc}
                onGenerateReport={handleGenerateReport}
                hasAdaptations={Object.keys(adaptations).length > 0}
                error={error}
            />
        );
    }, [adaptations, studentsWithNeeds, error, selectedLesson, selectedClass]);

    return (
        <div className="flex flex-col lg:flex-row h-full bg-slate-50 animate-in fade-in duration-500 overflow-hidden">

            {/* LEFT CONTROL PANEL (Sidebar on Desktop, Top Stack on Mobile) */}
            <div className="w-full lg:w-80 bg-white border-b lg:border-b-0 lg:border-r border-slate-200 p-6 flex flex-col gap-6 shrink-0 overflow-y-auto z-20 shadow-sm">

                {/* Header Title */}
                <div>
                    <h2 className="text-lg font-black text-slate-900 uppercase italic tracking-tight flex items-center gap-2">
                        <BrainCircuit className="text-teal-600" size={24} />
                        <span className="leading-tight">Workbench<br />de Inclusão</span>
                    </h2>
                    <p className="text-[9px] font-bold text-slate-400 uppercase tracking-widest mt-2">Adaptação PDI e DUA Inteligente</p>
                </div>

                {/* Context Badge */}
                {contextBadge && (
                    <div className="bg-blue-50 border border-blue-100 p-3 rounded-xl flex items-center gap-3">
                        <div className="bg-blue-600 text-white p-1.5 rounded-lg shadow-sm">
                            <Globe size={14} />
                        </div>
                        <div>
                            <p className="text-[9px] font-bold text-blue-400 uppercase tracking-wider">Contexto Ativo</p>
                            <p className="text-xs font-black text-blue-700 leading-tight">
                                {currentPlan?.subject || 'Disciplina'} - {currentPlan?.grade || 'Série'}
                            </p>
                        </div>
                    </div>
                )}

                {/* Controls */}
                <div className="space-y-4">
                    <div>
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 block">1. Aula Base</label>
                        <select
                            className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm font-bold text-slate-700 outline-none focus:ring-2 focus:ring-teal-500 transition-all cursor-pointer hover:bg-slate-100"
                            onChange={(e) => {
                                const l = lessons.find(l => l.id === e.target.value);
                                setSelectedLesson(l || null);
                            }}
                            value={selectedLesson?.id || ''}
                        >
                            <option value="">Selecione a Aula...</option>
                            {lessons.map(l => (
                                <option key={l.id} value={l.id}>{l.topic ? l.topic.substring(0, 35) + (l.topic.length > 35 ? '...' : '') : 'Sem tópico'}</option>
                            ))}
                        </select>
                    </div>

                    <div>
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1.5 block">2. Turma Alvo</label>
                        <select
                            className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-sm font-bold text-slate-700 outline-none focus:ring-2 focus:ring-teal-500 transition-all cursor-pointer hover:bg-slate-100"
                            onChange={(e) => handleClassSelect(e.target.value)}
                            value={selectedClass?.id || ''}
                        >
                            <option value="">Selecione a Turma...</option>
                            {classes.map(c => (
                                <option key={c.id} value={c.id}>{c.name}</option>
                            ))}
                        </select>
                    </div>
                </div>

                <div className="mt-auto pt-6 border-t border-slate-100 hidden lg:block">
                    <p className="text-xs text-slate-400 text-center font-medium italic">
                        "A inclusão acontece quando se aprende com as diferenças e não com as igualdades."
                    </p>
                </div>
            </div>

            {/* MAIN CONTENT AREA */}
            <div className="flex-1 bg-slate-50 p-4 md:p-8 overflow-y-auto custom-scrollbar relative">
                <div className="max-w-4xl mx-auto space-y-6 pb-20">

                    {/* Empty State / Welcome */}
                    {!selectedClass && !selectedLesson && (
                        <div className="flex flex-col items-center justify-center py-20 opacity-50 space-y-4">
                            <div className="w-24 h-24 bg-slate-200 rounded-full flex items-center justify-center text-slate-400">
                                <BrainCircuit size={40} />
                            </div>
                            <p className="text-sm font-black uppercase text-slate-400 tracking-widest">Selecione Aula e Turma para iniciar</p>
                        </div>
                    )}

                    {/* No Students Alert */}
                    {selectedClass && studentsWithNeeds.length === 0 && (
                        <div className="bg-white p-8 rounded-[2.5rem] border border-slate-200 shadow-sm text-center">
                            <div className="w-16 h-16 bg-orange-50 text-orange-500 rounded-2xl flex items-center justify-center mx-auto mb-4">
                                <Sparkles size={24} />
                            </div>
                            <h2 className="text-lg font-black text-slate-800 tracking-tight mb-2">Turma sem PDI Identificado</h2>
                            <p className="text-sm text-slate-500 max-w-md mx-auto">
                                Não encontramos alunos marcados com "Necessita Adaptação" nesta turma. Você pode adicionar essa marcação no menu "Minhas Turmas".
                            </p>
                        </div>
                    )}

                    {/* Student Cards List */}
                    {studentsWithNeeds.map(student => (
                        <StudentAdaptationCard
                            key={student.id}
                            student={student}
                            adaptation={adaptations[student.id]}
                            isGenerating={generatingId === student.id}
                            hasLessonSelected={!!selectedLesson}
                            onGenerate={handleGenerateAdaptation}
                            onValidate={handleValidate}
                        />
                    ))}

                    {/* ACTIONS FOOTER (Export Button) */}
                    {studentsWithNeeds.length > 0 && selectedLesson && (
                        <div className="pt-8 border-t border-slate-200/60 mt-8 flex flex-col items-center gap-4 animate-in slide-in-from-bottom-4">
                            <p className="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Ações Finais</p>

                            <button
                                onClick={handleExportDoc}
                                className="group relative px-8 py-4 bg-teal-600 hover:bg-teal-500 text-white rounded-2xl shadow-xl shadow-teal-600/20 transition-all hover:scale-[1.02] active:scale-95 w-full md:w-auto"
                            >
                                <div className="flex items-center gap-3 font-black uppercase tracking-widest text-xs">
                                    <span>Gerar Documento Unificado (.DOC)</span>
                                    <div className="bg-white/20 p-1 rounded-lg">
                                        <BookOpen size={14} className="text-white" />
                                    </div>
                                </div>
                            </button>

                            <p className="text-xs text-slate-400 text-center max-w-sm">
                                Gera um arquivo Word contendo o plano original e todas as adaptações validadas acima.
                            </p>
                        </div>
                    )}

                    {selectedClass && studentsWithNeeds.length > 0 && (
                        <div className="text-center py-10 opacity-30 mt-10">
                            <div className="w-1.5 h-1.5 bg-slate-400 rounded-full mx-auto mb-2"></div>
                            <p className="text-[9px] font-black uppercase tracking-[0.3em] text-slate-400">Fim da lista</p>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
};

export default PDIManager;
