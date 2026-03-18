import { useState, useEffect } from 'react';
import { supabase } from '../../services/supabaseClient';
import { getClasses as getUserClasses, getClassDetails as getSupabaseClassDetails } from '../../services/supabaseService';
import { getGeneratedContents, saveGeneratedContent } from '../../services/databaseService';
import { PdiDocumentService } from '../../services/pdi/PdiDocumentService';
import { generateBlock9Adaptation } from '../../services/ai/AiPdiService';
import { generatePdiReportDoc, exportToDocx } from '../../services/exportService';
import { Class, Student, StudentAdaptation, Lesson, UserProfile } from '../../types';
import {
    getLocalClasses,
    getLocalClassDetails,
} from '../../services/localStorageService';
import { useGlobalPlanning } from '../../contexts/GlobalPlanningContext';

export const usePDIManager = (userId: string, userProfile: UserProfile) => {
    // State
    const [loading, setLoading] = useState(false);
    const [classes, setClasses] = useState<Class[]>([]);
    const [lessons, setLessons] = useState<any[]>([]); // Adjust type if needed
    const [selectedClass, setSelectedClass] = useState<Class | null>(null);
    const [selectedLesson, setSelectedLesson] = useState<any | null>(null); // Lesson generic
    const [studentsWithNeeds, setStudentsWithNeeds] = useState<Student[]>([]);
    const [adaptations, setAdaptations] = useState<Record<string, StudentAdaptation>>({});
    const [error, setError] = useState('');
    const [generatingId, setGeneratingId] = useState<string | null>(null);
    const [pdiProfileStudent, setPdiProfileStudent] = useState<Student | null>(null);
    const [consolidatorStudent, setConsolidatorStudent] = useState<Student | null>(null);

    // Feedback Modal State
    const [feedbackModalOpen, setFeedbackModalOpen] = useState(false);
    const [lastAdaptationDetails, setLastAdaptationDetails] = useState<{ id: string, studentName: string, lessonTopic: string } | null>(null);

    const { currentPlan } = useGlobalPlanning();

    // Initial Load + possível auto-seleção vinda do Planejamento
    useEffect(() => {
        const bootstrap = async () => {
            await loadInitialData();
            try {
                const url = new URL(window.location.href);
                const source = url.searchParams.get('source');
                const lessonTitle = url.searchParams.get('lessonTitle');
                const lessonNumber = url.searchParams.get('lessonNumber');
                const subject = url.searchParams.get('subject');
                const grade = url.searchParams.get('grade');

                if (source === 'planning' && (lessonTitle || lessonNumber)) {
                    const targetClass =
                        classes.find((cls: any) => {
                            const subj = (cls.subject || '').toLowerCase();
                            const grd = (cls.grade || '').toLowerCase();
                            return (!subject || subj.includes(subject.toLowerCase())) &&
                                (!grade || grd.includes(grade.toLowerCase()));
                        }) || classes[0];

                    if (targetClass) {
                        await handleClassSelect(targetClass.id);
                    }
                }
            } catch {
                // fail-silent se URL/contexto não estiver disponível
            }
        };

        bootstrap();
    }, [userId, userProfile]);

    const loadInitialData = async () => {
        setLoading(true);
        try {
            // Fetch Lessons
            const genContents = await getGeneratedContents(userId);
            const mappedLessons = genContents ? genContents.map((item: any) => ({
                id: item.id,
                topic: item.title,
                content: item.content,
                type: item.type
            })) : [];
            setLessons(mappedLessons);

            // Fetch Classes (mesma fonte de "Minhas Turmas": classes do usuário na escola ativa)
            const schoolId = userProfile?.active_school_id || userProfile?.school_id;
            let sbClasses: Class[] = [];

            // 1) Tenta carregar as mesmas turmas usadas em "Minhas Turmas"
            if (schoolId) {
                const { data } = await getUserClasses(userId, schoolId);
                sbClasses = data || [];
            }

            // 2) Se não achou nada (ou não há schoolId), carrega todas as turmas do usuário
            if (!sbClasses.length) {
                const { data } = await getUserClasses(userId);
                sbClasses = data || [];
            }

            // Mapeia para o tipo Class com alunos (quando já vierem agregados)
            sbClasses = sbClasses.map((c: any) => ({
                id: c.id,
                name: c.name,
                subject: c.subject || '-',
                grade: c.grade,
                shift: c.shift,
                year: c.year,
                created_at: c.created_at || new Date().toISOString(),
                students: Array.isArray(c.students)
                    ? c.students.map((s: any) => ({
                        id: s.id,
                        name: typeof s.name === 'object' ? (s.name?.name || 'Sem Nome') : (s.name || 'Sem Nome'),
                        class_id: c.id,
                        needs_adaptation: s.needs_adaptation || false,
                        deficiencies: s.deficiencies || [],
                        pdi_needs: s.pdi_needs || [],
                        pedagogical_observations: s.pedagogical_observations || s.observations || ''
                    }))
                    : []
            }));

            // Para o módulo de PDI, usamos apenas as turmas do Supabase
            // (fonte de verdade) para evitar estados divergentes com o
            // fallback em localStorage.
            const allClasses = sbClasses || [];
            const seenKeys = new Set<string>();
            const dedupedClasses = allClasses.filter((cls) => {
                const key = `${cls.name}::${cls.year ?? ''}::${cls.shift ?? ''}`;
                if (seenKeys.has(key)) return false;
                seenKeys.add(key);
                return true;
            });

            setClasses(dedupedClasses);

        } catch (e) {
            console.error("Error loading initial data", e);
            setError("Erro ao carregar dados iniciais.");
        } finally {
            setLoading(false);
        }
    };

    const handleClassSelect = async (classId: string) => {
        // Local first check
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
            const needs = mappedClass.students?.filter((s: Student) => {
                const hasDeficiencies = Array.isArray(s.deficiencies) && s.deficiencies.length > 0;
                const hasPdiNeeds = Array.isArray(s.pdi_needs) && s.pdi_needs.length > 0;
                const hasObs = typeof s.pedagogical_observations === 'string' && s.pedagogical_observations.trim().length > 0;
                const hasLegacyObs = typeof s.observations === 'string' && s.observations.trim().length > 0;
                return s.needs_adaptation || hasDeficiencies || hasPdiNeeds || hasObs || hasLegacyObs;
            }) || [];
            setStudentsWithNeeds(needs);
            setAdaptations({});
        } else {
            // Supabase fallback
            const cls = classes.find(c => c.id === classId);
            if (cls) {
                // Buscar turma + alunos diretamente do Supabase,
                // usando o mesmo shape de dados de "Minhas Turmas"
                const { data, error } = await getSupabaseClassDetails(classId);
                if (!error && data) {
                    const mappedStudents = Array.isArray(data.students)
                        ? data.students.map((s: any) => ({
                            id: s.id,
                            name: typeof s.name === 'object' ? (s.name?.name || 'Sem Nome') : (s.name || 'Sem Nome'),
                            class_id: data.id,
                            needs_adaptation: s.needs_adaptation || false,
                            deficiencies: s.deficiencies || [],
                            pdi_needs: s.pdi_needs || [],
                            pedagogical_observations: s.pedagogical_observations || s.observations || ''
                        }))
                        : [];

                    const fullClass: Class = {
                        id: data.id,
                        name: data.name,
                        subject: data.subject,
                        grade: data.grade,
                        shift: data.shift,
                        year: data.year,
                        created_at: data.created_at,
                        students: mappedStudents
                    };

                    setSelectedClass(fullClass);
                    const needs = mappedStudents.filter((s: Student) => {
                        const hasDeficiencies = Array.isArray(s.deficiencies) && s.deficiencies.length > 0;
                        const hasPdiNeeds = Array.isArray(s.pdi_needs) && s.pdi_needs.length > 0;
                        const hasObs = typeof s.pedagogical_observations === 'string' && s.pedagogical_observations.trim().length > 0;
                        const hasLegacyObs = typeof s.observations === 'string' && s.observations.trim().length > 0;
                        return s.needs_adaptation || hasDeficiencies || hasPdiNeeds || hasObs || hasLegacyObs;
                    });
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
            // 1. Fetch detailed PDI Data
            const { data: studentData, error: studentError } = await supabase
                .from('school_students')
                .select('pdi_data')
                .eq('id', student.id)
                .single();

            if (studentError) console.warn("Could not fetch detailed PDI data, using basics.", studentError);

            const pdiData = studentData?.pdi_data || {};
            // Extract context from PDI Data
            const studentContext = {
                nome_completo: student.name,
                diagnostico_clinico: pdiData.clinical_health?.diagnosis_cid || student.deficiencies?.join(', ') || 'Não informado',
                necessidades_especificas: student.deficiencies || [],
                potencialidades: [], // Could be extracted from cognitive/psychomotor checkmarks
                desafios: [],
                objetivo_geral: 'Promover acesso ao currículo com autonomia de acordo com o PDI.',
                recursos_tecnologicos: [],
                materiais_adaptados: []
            };

            // 2. Generate with Advanced AI (Block 9)
            const resultJSON = await generateBlock9Adaptation(
                selectedLesson.content || 'Conteúdo não textual',
                selectedLesson.topic || 'Aula sem título',
                selectedClass?.subject || 'Geral',
                selectedClass?.name || 'Série não informada',
                [], // BNCC skills - generic if missing
                studentContext,
                userId
            );

            // 3. Format JSON to Markdown
            const markdownResult = `## 🎯 Objetivos Adaptados\n${resultJSON.objetivos_adaptados.map((o: string) => `- ${o}`).join('\n')}\n\n## 🧠 Adaptação Metodológica\n${resultJSON.adaptacao_metodologica}\n\n## 🛠️ Recursos & Estratégias\n**Recursos:** ${resultJSON.recursos_adaptados.join(', ')}\n\n**Estratégias:**\n${resultJSON.estrategias_ensino.map((e: string) => `- ${e}`).join('\n')}\n\n**Tempo Estimado:** ${resultJSON.tempo_estimado || 'N/A'}`;

            setAdaptations(prev => ({
                ...prev,
                [student.id]: {
                    studentId: student.id,
                    studentName: student.name,
                    originalContent: selectedLesson.content,
                    adaptedContent: markdownResult,
                    status: 'completed'
                }
            }));
        } catch (e: any) {
            console.error(e);
            setError(`Erro ao gerar para ${student.name}: ${e.message}`);
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

        // Save PDI Log to Supabase using the correct service
        try {
            const data = await PdiDocumentService.logEvent(
                studentId,
                'ADAPTATION',
                `Adaptação: ${selectedLesson.topic}`,
                {
                    lessonId: selectedLesson.id,
                    originalContent: selectedLesson.content,
                    adaptedContent: finalContent,
                    classId: selectedClass.id
                },
                'block9'
            );

            if (data) {
                setLastAdaptationDetails({
                    id: data.id,
                    studentName: studentName,
                    lessonTopic: selectedLesson.topic
                });
                setFeedbackModalOpen(true);

                // Update local state ONLY if saved successfully
                setAdaptations(prev => ({
                    ...prev,
                    [studentId]: {
                        ...prev[studentId],
                        status: 'validated'
                    }
                }));
            }
        } catch (err) {
            console.error("Failed to save PDI log:", err);
            setError("Erro ao salvar o histórico do aluno. Tente novamente.");
            // Do NOT generate document if log fails? Or allow it? 
            // Better to fail safe here to prevent data inconsistency.
            return;
        }

        // Auto Save Document (Only if log saved)
        try {
            const fileName = `${studentName}_${dateStr}.md`;
            await saveGeneratedContent(
                userId,
                'documento',
                'adaptacao_curricular',
                fileName,
                `# Adaptação: ${studentName}\nData: ${dateStr}\nAula: ${selectedLesson.topic}\n\n${finalContent}`
            );
        } catch (e) {
            console.warn("Auto-save failed", e);
        }
    };

    // Re-evaluate function
    const handleEvaluate = async (student: Student) => {
        // Find the last adaptation log for this lesson?
        // Ideally we should store the adaptation ID in the local state or fetch it.
        // For now, if we don't have the ID in `lastAdaptationDetails`, we might need to fetch it.
        // Or we rely on the user having just validated it.

        // If the user refreshed, `lastAdaptationDetails` is gone.
        // We'll try to find the PDI record for this student/lesson.

        if (lastAdaptationDetails?.id) {
            setFeedbackModalOpen(true);
            return;
        }

        // Fetch latest 'ADAPTATION' record for this student
        try {
            // Quick fetch for latest record
            const { data } = await supabase
                .from('pdi_records')
                .select('id, title')
                .eq('student_id', student.id)
                .eq('type', 'ADAPTATION')
                .order('date', { ascending: false })
                .limit(1)
                .single();

            if (data) {
                setLastAdaptationDetails({
                    id: data.id,
                    studentName: student.name,
                    lessonTopic: data.title // approximate
                });
                setFeedbackModalOpen(true);
            } else {
                setError("Não foi possível encontrar o registro da adaptação para avaliar.");
            }

        } catch (e) {
            console.error(e);
            setError("Erro ao buscar adaptação.");
        }
    };

    const handleDownloadStudentDoc = async (student: Student, content: string) => {
        if (!selectedLesson) return;

        try {
            const markdownContent = `# Aula Base: ${selectedLesson.topic}\n\n${selectedLesson.content || ''}\n\n---\n\n# Adaptação para ${student.name}\n\n${content}`;

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
            const logsContent = logs.map(log => `- ${log}`).join('\n');
            const reportHtml = generatePdiReportDoc(student.name, 'Trimestre Atual', logsContent);

            try {
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
        } catch (e: any) {
            console.error(e);
            setError(`Erro: ${e.message || 'Falha ao gerar relatório'}`);
        } finally {
            setLoading(false);
        }
    };

    const handleSaveFeedback = async (feedbackData: any) => {
        if (!lastAdaptationDetails) return;

        try {
            // Fetch current content first? Or just merge. We assume we are appending `feedback` key
            // To do this safely, we might need to fetch, but here we know the structure we just saved.
            // But to be safe, we'll assume logEvent saved { lessonId, ... }
            // We can just update content by "jsonb_set" or fetching.
            // But we don't have jsonb_set exposed easily.
            // Let's use getStudentTimeline or calculate what the content was.
            // Actually, we can fetch the specific record by ID.

            // Note: supabase update replaces content if we pass the whole object.
            // Ideally PdiService.updateRecordContent should handle merge if possible or we fetch first.
            // For now, let's just append feedback to the object we have in memory?
            // Wait, we lost the `content` object scope.
            // Let's fetch the record using supabase directly or rely on a new service method that merges.
            // Simplest: Fetch, Merge, Update.

            const { data: record } = await supabase.from('pdi_records').select('content').eq('id', lastAdaptationDetails.id).single();
            if (record) {
                const newContent = {
                    ...record.content,
                    feedback: feedbackData
                };
                await PdiDocumentService.updateRecordContent(lastAdaptationDetails.id, newContent);
                // alert("Avaliação registrada com sucesso!"); // Optional feedback
            }
        } catch (e) {
            console.error("Error saving feedback", e);
            // setError("Erro ao salvar avaliação."); // Silent fail is better than blocking flow
        } finally {
            setFeedbackModalOpen(false);
            setLastAdaptationDetails(null);
        }
    };

    // Viewing State
    const [viewingAdaptation, setViewingAdaptation] = useState<{ studentName: string, content: string } | null>(null);

    const handleViewAdaptation = (student: Student) => {
        const adaptation = adaptations[student.id];
        if (adaptation) {
            setViewingAdaptation({
                studentName: student.name,
                content: adaptation.adaptedContent
            });
        }
    };

    return {
        // State
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
        feedbackModalOpen,
        lastAdaptationDetails,
        viewingAdaptation,

        // Setters
        setLoading,
        setSelectedClass,
        setSelectedLesson,
        setPdiProfileStudent,
        setConsolidatorStudent,
        setError,
        setViewingAdaptation,

        // Handlers
        handleClassSelect,
        handleGenerateAdaptation,
        handleValidate,
        handleDownloadStudentDoc,
        handleExportDoc,

        handleGenerateReport,
        handleSaveFeedback,
        handleViewAdaptation,
        handleEvaluate,
        setFeedbackModalOpen
    };
};

const getPdiLogs = async (studentId: string) => {
    return PdiDocumentService.getLogs(studentId);
};
