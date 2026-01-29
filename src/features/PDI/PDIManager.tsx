import React, { useState, useEffect } from 'react';
import {
    BookOpen, BrainCircuit, AlertCircle, Sparkles, Globe, FileText, ClipboardList
} from 'lucide-react';
import { supabase } from '../../services/supabaseClient';
import { getClassesBySchool as getClasses, getStudentsByClass as getClassDetails } from '../../services/classService';
import { getPdiLogs } from '../../services/PdiService';
import { getGeneratedContents } from '../../services/databaseService';

import { generateStudentAdaptation, generatePdiReport } from '../../services/geminiService';
import { generatePdiReportDoc, exportToDocx } from '../../services/exportService';
import { saveGeneratedContent } from '../../services/databaseService';
import { Class, Student, StudentAdaptation } from '../../types';
import {
    getLocalClasses,
    getLocalClassDetails,
    savePdiLogToLocal,
} from '../../services/localStorageService';

// New Architecture
import { useGlobalPlanning } from '../../contexts/GlobalPlanningContext';
import { savePdiLog } from './PDIService';
import PDISidebar from './components/PDISidebar';
import StudentAdaptationCard from './components/StudentAdaptationCard';

// PDI Module Components
import { StudentPDIProfile } from '../../components/School/PDI/StudentPDIProfile';
import { PDIConsolidator } from '../../components/School/PDI/PDIConsolidator';

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

    // PDI Modal States
    const [pdiProfileStudent, setPdiProfileStudent] = useState<Student | null>(null);
    const [consolidatorStudent, setConsolidatorStudent] = useState<Student | null>(null);

    // Global Context (Coordinator Agent)
    const { currentPlan } = useGlobalPlanning();
    const [contextBadge, setContextBadge] = useState<boolean>(false);

    useEffect(() => {
        // Auto-fill from Coordinator Agent
        if (currentPlan) {
            console.log("Receiving Context from Coordinator:", currentPlan);
            setContextBadge(true);
        }
    }, [currentPlan]);

    useEffect(() => {
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
            const sbClasses = await getClasses(userId);
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
                const students = await getClassDetails(classId);
                if (students) {
                    const fullClass = { ...cls, students };
                    setSelectedClass(fullClass);
                    const needs = students?.filter((s: any) => s.needs_adaptation || (s.deficiencies && s.deficiencies.length > 0)) || [];
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
        const dateStr = new Date().toLocaleDateString('pt-BR').replace(/\//g, '-');

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

        await savePdiLog(logPayload);

        try {
            const fileName = `${studentName}_${dateStr}.md`;
            await saveGeneratedContent(
                userId,
                'documento',
                'adaptacao_curricular',
                fileName,
                `# Adaptação: ${studentName}\nData: ${dateStr}\nAula: ${selectedLesson.topic}\n\n${finalContent}`
            );
            console.log(`Auto-saved adaptation file: ${fileName}`);
        } catch (e) {
            console.error("Auto-save failed", e);
        }

        setAdaptations(prev => ({
            ...prev,
            [studentId]: {
                ...prev[studentId],
                status: 'validated'
            }
        }));
    };

    const handleDownloadStudentDoc = async (student: Student, content: string) => {
        if (!selectedLesson) return;

        try {
            const markdownContent = `# Aula Base: ${selectedLesson.topic}\n\n${selectedLesson.content}\n\n---\n\n# Adaptação para ${student.name}\n\n${content}`;

            await exportToDocx(
                markdownContent,
                `ADAPTACAO_${student.name.replace(/[^a-z0-9]/gi, '_')}`,
                {
                    userName: 'Professor(a)',
                    schoolName: selectedClass?.name || 'Escola'
                }
            );
        } catch (e: any) {
            console.error(e);
            setError(`Erro ao exportar doc do aluno: ${e.message}`);
        }
    };

    const handleExportDoc = async () => {
        if (!selectedLesson) return;
        const validAdaptations = (Object.values(adaptations) as StudentAdaptation[]).filter(a => a.status === 'completed' || a.status === 'validated');

        if (validAdaptations.length === 0) {
            setError('Nenhuma adaptação gerada para exportar.');
            return;
        }

        let markdownContent = `# Aula Base: ${selectedLesson.topic}\n\n`;
        markdownContent += `${selectedLesson.content}\n\n`;
        markdownContent += `---\n\n`;
        markdownContent += `# Adaptações Curriculares\n\n`;

        validAdaptations.forEach(adapt => {
            markdownContent += `## Aluno: ${adapt.studentName}\n\n`;
            markdownContent += `${adapt.adaptedContent}\n\n`;
            markdownContent += `---\n\n`;
        });

        try {
            await exportToDocx(
                markdownContent,
                `KIT_INCLUSAO_${selectedLesson.topic.substring(0, 20).replace(/[^a-z0-9]/gi, '_')}`,
                {
                    userName: 'Professor(a)',
                    schoolName: 'Instituição de Ensino'
                }
            );
        } catch (e: any) {
            console.error(e);
            setError(`Erro ao exportar: ${e.message}`);
        }
    };

    const handleGenerateReport = async () => {
        if (studentsWithNeeds.length === 0) return;
        const student = studentsWithNeeds[0];
        try {
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
                    'PDI',
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
        <div className="flex flex-col h-full bg-slate-50 relative animate-in fade-in duration-500">
            {/* PDI MODULE INTEGRATION: Modals */}
            {pdiProfileStudent && (
                <div className="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
                    <div className="bg-white rounded-2xl shadow-2xl w-full max-w-5xl max-h-[90vh] overflow-hidden flex flex-col animate-in fade-in zoom-in duration-200">
                        <StudentPDIProfile
                            studentId={pdiProfileStudent.id}
                            onClose={() => setPdiProfileStudent(null)}
                        />
                    </div>
                </div>
            )}

            {consolidatorStudent && (
                <div className="fixed inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
                    <div className="bg-white rounded-2xl shadow-2xl w-full max-w-6xl max-h-[95vh] overflow-hidden flex flex-col animate-in fade-in zoom-in duration-200">
                        <PDIConsolidator
                            studentId={consolidatorStudent.id}
                            studentName={consolidatorStudent.name}
                            onClose={() => setConsolidatorStudent(null)}
                        />
                    </div>
                </div>
            )}

            {/* HEADER / TOOLBAR */}
            <div className="bg-white border-b border-slate-200 px-6 py-4 flex justify-between items-center sticky top-0 z-10">
                <div>
                    <h1 className="text-xl font-black text-slate-800 flex items-center gap-2">
                        <BrainCircuit className="text-indigo-600" />
                        Gestão de Inclusão & PDI
                    </h1>
                    <p className="text-xs text-slate-500 font-bold uppercase tracking-wider">
                        {selectedClass ? `Turma: ${selectedClass.name}` : 'Selecione uma turma para gerenciar'}
                    </p>
                </div>
            </div>

            <div className="flex-1 flex overflow-hidden">
                {/* SIDEBAR - Class List */}
                <div className="w-80 bg-white border-r border-slate-200 flex flex-col overflow-y-auto hidden md:flex">
                    <div className="p-4 bg-slate-50 border-b border-slate-100">
                        <h3 className="text-xs font-black uppercase text-slate-400">Minhas Turmas</h3>
                    </div>
                    <div className="p-2 space-y-1">
                        {classes.map(cls => (
                            <button
                                key={cls.id}
                                onClick={() => handleClassSelect(cls.id)}
                                className={`w-full text-left px-4 py-3 rounded-xl text-sm font-bold transition-all ${selectedClass?.id === cls.id ? 'bg-indigo-50 text-indigo-700 ring-1 ring-indigo-200' : 'text-slate-600 hover:bg-slate-50'}`}
                            >
                                {cls.name}
                                <span className="block text-[10px] font-normal opacity-60 mt-0.5">{cls.subject}</span>
                            </button>
                        ))}
                    </div>
                </div>

                {/* MAIN CONTENT AREA */}
                <div className="flex-1 overflow-y-auto p-6 md:p-10">
                    {!selectedClass ? (
                        <div className="flex flex-col items-center justify-center h-full text-slate-400 opacity-60">
                            <BookOpen size={64} className="mb-4 text-slate-300" />
                            <p className="font-bold text-lg">Selecione uma turma para iniciar</p>
                        </div>
                    ) : (
                        <div className="max-w-5xl mx-auto">
                            {/* STUDENTS LIST */}
                            {studentsWithNeeds.length === 0 ? (
                                <div className="p-10 bg-white rounded-2xl border border-slate-200 text-center">
                                    <AlertCircle className="w-12 h-12 text-slate-300 mx-auto mb-3" />
                                    <h3 className="text-slate-600 font-bold">Nenhum aluno com PDI nesta turma</h3>
                                    <button className="mt-4 text-indigo-600 font-bold text-sm hover:underline">
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
                                                        <h3 className="text-lg font-black text-slate-800 leading-tight">{student.name}</h3>
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

                                            {/* Actions Bar */}
                                            <div className="flex flex-row md:flex-col gap-2 shrink-0 border-t md:border-t-0 md:border-l border-slate-100 pt-4 md:pt-0 md:pl-6 justify-center">
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
        </div>
    );
};

export default PDIManager;
