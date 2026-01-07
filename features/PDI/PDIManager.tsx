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
        <div className="flex h-full bg-slate-50 animate-in fade-in duration-500">
            {/* Main Content Area */}
            <div className="flex-1 flex flex-col h-full overflow-hidden">
                {/* Header / Selectors */}
                <div className="bg-white border-b border-slate-100 p-6 shadow-sm z-10 flex flex-col md:flex-row gap-4 justify-between items-center">
                    <div>
                        <h2 className="text-xl font-black text-slate-900 uppercase italic tracking-tight flex items-center gap-2">
                            <BrainCircuit className="text-teal-600" /> Workbench de Inclusão
                        </h2>
                        <p className="text-[10px] font-bold text-slate-400 uppercase tracking-widest mt-1">Adaptação PDI e DUA Inteligente</p>
                    </div>

                    <div className="flex gap-4 w-full md:w-auto">
                        <select
                            className="bg-slate-50 border border-slate-200 rounded-xl px-4 py-2 text-sm font-bold text-slate-700 outline-none focus:ring-2 focus:ring-teal-500"
                            onChange={(e) => {
                                const l = lessons.find(l => l.id === e.target.value);
                                setSelectedLesson(l || null);
                            }}
                        >
                            <option value="">Selecione a Aula Base...</option>
                            {lessons.map(l => (
                                <option key={l.id} value={l.id}>{l.topic ? l.topic.substring(0, 40) : 'Sem tópico'}</option>
                            ))}
                        </select>

                        <select
                            className="bg-slate-50 border border-slate-200 rounded-xl px-4 py-2 text-sm font-bold text-slate-700 outline-none focus:ring-2 focus:ring-teal-500"
                            onChange={(e) => handleClassSelect(e.target.value)}
                        >
                            <option value="">Selecione a Turma...</option>
                            {classes.map(c => (
                                <option key={c.id} value={c.id}>{c.name}</option>
                            ))}
                        </select>
                    </div>
                </div>

                {/* Split View */}
                <div className="flex-1 flex overflow-hidden">
                    {/* Left: Original Content */}
                    <div className="w-1/3 border-r border-slate-100 bg-white p-8 overflow-y-auto hidden md:block">
                        <div className="sticky top-0 bg-white pb-4 border-b border-slate-50 mb-4 z-10">
                            <h3 className="text-xs font-black text-slate-400 uppercase tracking-widest flex items-center gap-2">
                                <BookOpen size={14} /> Aula Original
                            </h3>
                            {selectedLesson && <p className="font-bold text-slate-900 mt-1">{selectedLesson.topic}</p>}
                        </div>
                        <div className="prose prose-sm prose-slate max-w-none">
                            {selectedLesson ? (
                                <div className="whitespace-pre-wrap font-serif text-slate-600 leading-relaxed">
                                    {selectedLesson.content}
                                </div>
                            ) : (
                                <div className="text-center py-20 text-slate-300 italic">
                                    Selecione uma aula para visualizar o conteúdo base.
                                </div>
                            )}
                        </div>
                    </div>

                    {/* Right: Adaptation Workbench */}
                    <div className="flex-1 bg-slate-50/50 p-8 overflow-y-auto">
                        <div className="max-w-3xl mx-auto space-y-6">
                            {selectedClass && studentsWithNeeds.length === 0 && (
                                <div className="bg-orange-50 text-orange-600 p-6 rounded-2xl border border-orange-100 text-center">
                                    <div className="flex items-center gap-2">
                                        <h2 className="text-xl font-black text-slate-800 tracking-tight">Adaptação PDI/DUA</h2>
                                        {contextBadge && (
                                            <div className="flex items-center gap-1 bg-gradient-to-r from-blue-100 to-indigo-100 px-3 py-1 rounded-full border border-blue-200" title={`Contexto Ativo: ${currentPlan?.subject} - ${currentPlan?.grade}`}>
                                                <Globe size={12} className="text-blue-600" />
                                                <span className="text-[10px] font-bold text-blue-700 uppercase tracking-wider">
                                                    Agente Coordenador Ativo
                                                </span>
                                            </div>
                                        )}
                                    </div>
                                    <p className="text-xs mt-1">Esta turma não possui alunos marcados com "Necessita Adaptação" no gerenciador.</p>
                                </div>
                            )}

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

                            {selectedClass && studentsWithNeeds.length > 0 && (
                                <div className="text-center py-10 opacity-50">
                                    <div className="w-2 h-2 bg-slate-200 rounded-full mx-auto mb-2"></div>
                                    <p className="text-[10px] font-black uppercase tracking-widest text-slate-300">Fim da lista de prioridade</p>
                                </div>
                            )}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default PDIManager;
