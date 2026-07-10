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
import { createSchoolStudent, findSchoolStudentBySchoolAndName, getSchoolStudentById } from '../../services/schoolStudentService';
import { ProfileService } from '../../services/ProfileService';

const BNCC_CODE_REGEX = /\b[A-Z]{2}\d{2}[A-Z]{2}\d{2}\b/g;

/**
 * Extrai códigos BNCC diretamente do texto já existente (não inventa códigos).
 * Ex: EF09HI01
 */
const extractBnccCodes = (raw: string): string[] => {
    const text = (raw || '').toUpperCase();
    const matches = text.match(BNCC_CODE_REGEX) || [];
    return [...new Set(matches)].slice(0, 10);
};

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
            const loadedClasses = await loadInitialData();
            try {
                const url = new URL(window.location.href);
                const source = url.searchParams.get('source');
                const lessonTitle = url.searchParams.get('lessonTitle');
                const lessonNumber = url.searchParams.get('lessonNumber');
                const subject = url.searchParams.get('subject');
                const grade = url.searchParams.get('grade');

                if (source === 'planning' && (lessonTitle || lessonNumber)) {
                    const targetClass =
                        loadedClasses.find((cls: any) => {
                            const subj = (cls.subject || '').toLowerCase();
                            const grd = (cls.grade || '').toLowerCase();
                            return (!subject || subj.includes(subject.toLowerCase())) &&
                                (!grade || grd.includes(grade.toLowerCase()));
                        }) || loadedClasses[0];

                    if (targetClass) {
                        await handleClassSelect(targetClass.id, loadedClasses);
                    }
                }
            } catch {
                // fail-silent se URL/contexto não estiver disponível
            }
        };

        bootstrap();
    }, [userId, userProfile]);

    const loadInitialData = async (): Promise<Class[]> => {
        setLoading(true);
        try {
            // Resolve real auth uid — evita ghost UUID vindo do prop userId (sessão local desatualizada)
            const { data: { user } } = await supabase.auth.getUser();
            const realUserId = user?.id || userId;

            // Fetch Lessons
            const genContents = await getGeneratedContents(realUserId);
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
                const { data, error: classesError } = await getUserClasses(realUserId, schoolId);
                if (classesError) console.error('[PDI] getUserClasses(schoolId) falhou:', classesError);
                sbClasses = data || [];
            }

            // 2) Se não achou nada (ou não há schoolId), carrega todas as turmas do usuário
            if (!sbClasses.length) {
                const { data, error: classesError } = await getUserClasses(realUserId);
                if (classesError) console.error('[PDI] getUserClasses(fallback) falhou:', classesError);
                sbClasses = data || [];
            }

            // 3) Se ainda não há turmas remotas, usa fallback local como backup.
            // Isso garante que classes importadas/localmente criadas continuem disponíveis
            // no menu de PDI mesmo quando não houver sincronização completa com o Supabase.
            if (!sbClasses.length) {
                // ClassManager sempre grava o backup local sob `userId` (session.id), mesmo
                // quando esse é um Ghost ID desatualizado em relação ao auth.uid() atual. Se
                // buscarmos só por `realUserId` aqui, turmas presas no fallback local (ex:
                // salvas durante uma sessão expirada) ficam invisíveis no PDI/DUA mesmo
                // aparecendo em "Minhas Turmas". Tenta os dois IDs.
                let localClasses = getLocalClasses(realUserId);
                if (!localClasses.length && userId !== realUserId) {
                    localClasses = getLocalClasses(userId);
                }
                if (localClasses.length) {
                    sbClasses = localClasses.map((localClass) => ({
                        id: localClass.id,
                        name: localClass.name,
                        subject: localClass.subject,
                        grade: undefined,
                        shift: undefined,
                        year: undefined,
                        school_id: userProfile?.active_school_id || userProfile?.school_id || null,
                        created_at: localClass.createdAt,
                        students: localClass.students.map((s) => ({
                            id: s.id,
                            name: s.name,
                            class_id: localClass.id,
                            current_school_id: userProfile?.active_school_id || userProfile?.school_id || null,
                            school_id: userProfile?.active_school_id || userProfile?.school_id || null,
                            school_student_id: null,
                            needs_adaptation: s.needs_adaptation || false,
                            deficiencies: s.deficiencies || [],
                            pdi_needs: [],
                            pedagogical_observations: s.pedagogical_observations || ''
                        }))
                    }));
                }
            }

            // Mapeia para o tipo Class com alunos (quando já vierem agregados)
            // IMPORTANTE: carregamos `school_id`/`current_school_id` para garantir que o log do PDI
            // consiga preencher o NOT NULL de `pdi_records.school_id`.
            sbClasses = sbClasses.map((c: any) => {
                const classSchoolId =
                    c.school_id ??
                    c.current_school_id ??
                    (userProfile as any)?.active_school_id ??
                    (userProfile as any)?.school_id ??
                    null;

                return {
                    id: c.id,
                    name: c.name,
                    subject: c.subject || '-',
                    grade: c.grade,
                    shift: c.shift,
                    year: c.year,
                    school_id: classSchoolId,
                    created_at: c.created_at || new Date().toISOString(),
                    students: Array.isArray(c.students)
                        ? c.students.map((s: any) => ({
                            id: s.id,
                            name: typeof s.name === 'object' ? (s.name?.name || 'Sem Nome') : (s.name || 'Sem Nome'),
                            class_id: c.id,
                            // Alguns fluxos usam `current_school_id` como alias de escola atual
                            current_school_id: s.current_school_id ?? s.school_id ?? classSchoolId ?? null,
                            school_id: s.school_id ?? s.current_school_id ?? classSchoolId ?? null,
                            school_student_id: s.school_student_id ?? null,
                            needs_adaptation: s.needs_adaptation || false,
                            deficiencies: s.deficiencies || [],
                            pdi_needs: s.pdi_needs || [],
                            pedagogical_observations: s.pedagogical_observations || s.observations || ''
                        }))
                        : []
                };
            });

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
            return dedupedClasses;

        } catch (e) {
            console.error("Error loading initial data", e);
            setError("Erro ao carregar dados iniciais.");
            return [];
        } finally {
            setLoading(false);
        }
    };

    const handleClassSelect = async (classId: string, classSource: Class[] = classes) => {
        // Local first check
        const localData = getLocalClassDetails(classId);
        if (localData) {
            const mappedClass: Class = {
                id: localData.id,
                name: localData.name,
                subject: localData.subject,
                created_at: localData.createdAt,
                school_id: (userProfile as any)?.active_school_id ?? userProfile?.school_id ?? (userProfile as any)?.school?.id ?? null,
                students: localData.students.map((s: any) => ({
                    id: s.id,
                    name: s.name,
                    class_id: localData.id,
                    current_school_id: (userProfile as any)?.active_school_id ?? userProfile?.school_id ?? null,
                    school_id: (userProfile as any)?.active_school_id ?? userProfile?.school_id ?? null,
                    school_student_id: s.school_student_id ?? null,
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
            const cls = classSource.find(c => c.id === classId);
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
                            current_school_id: s.current_school_id ?? s.school_id ?? data.school_id ?? null,
                            school_id: s.school_id ?? s.current_school_id ?? data.school_id ?? null,
                            school_student_id: s.school_student_id ?? null,
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
                        school_id: data.school_id ?? data.current_school_id ?? (userProfile as any)?.active_school_id ?? userProfile?.school_id ?? null,
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
            const schoolStudentId = (student as any).school_student_id ?? student.id;
            const gradeLevel =
                selectedClass?.grade ??
                (selectedClass?.year !== undefined && selectedClass?.year !== null ? String(selectedClass.year) : 'Geral');

            const rawLessonText = `${selectedLesson.content || ''}\n${selectedLesson.topic || ''}`;
            const habilidadesBncc = extractBnccCodes(rawLessonText);
            // 1. Fetch detailed PDI Data
            const { data: studentData, error: studentError } = await supabase
                .from('school_students')
                .select('pdi_data')
                .eq('id', schoolStudentId)
                .maybeSingle();

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
                gradeLevel,
                habilidadesBncc,
                studentContext,
                userId
            );

            // 3. Format JSON to Markdown
            const evaluationMatch = resultJSON.adaptacao_metodologica?.match(/Avalia[cç][aã]o[^:]*:\s*([\s\S]+)/i);
            const evaluationDifferentiated = evaluationMatch?.[1]?.trim()?.slice(0, 1200) || 'Não especificado na geração atual.';

            const markdownResult = `## 🎯 Objetivos Adaptados\n${resultJSON.objetivos_adaptados.map((o: string) => `- ${o}`).join('\n')}\n\n## 🛠️ Estratégias de Acesso\n${resultJSON.estrategias_ensino.map((e: string) => `- ${e}`).join('\n')}\n\n## 🧠 Adaptação Metodológica\n${resultJSON.adaptacao_metodologica}\n\n## 📌 Avaliação Diferenciada\n${evaluationDifferentiated}\n\n## 🛠️ Recursos Adaptados\n${resultJSON.recursos_adaptados.map((r: string) => `- ${r}`).join('\n')}\n\n**Tempo Estimado:** ${resultJSON.tempo_estimado || 'N/A'}`;

            const block9Payload = {
                lesson_id: selectedLesson.id,
                lesson_title: selectedLesson.topic || selectedLesson.title || 'Aula',
                subject: selectedClass?.subject || 'Geral',
                habilidades_bncc: habilidadesBncc,
                adaptacao_metodologica: resultJSON.adaptacao_metodologica,
                recursos_adaptados: resultJSON.recursos_adaptados,
                objetivos_adaptados: resultJSON.objetivos_adaptados,
                estrategias_ensino: resultJSON.estrategias_ensino,
                tempo_estimado: resultJSON.tempo_estimado
            };

            setAdaptations(prev => ({
                ...prev,
                [student.id]: {
                    studentId: student.id,
                    studentName: student.name,
                    originalContent: selectedLesson.content,
                    adaptedContent: markdownResult,
                    status: 'completed',
                    block9Payload
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
            let schoolIdForSchoolStudent =
                selectedClass?.school_id ??
                (student ? (student as any).current_school_id ?? (student as any).school_id ?? null : null) ??
                (userProfile as any)?.active_school_id ??
                userProfile?.school_id ??
                (userProfile as any)?.school?.id ??
                null;

            // Fallback robust: resolve school_id from the selected class.
            if (!schoolIdForSchoolStudent && selectedClass?.id) {
                const { data: clsRow, error: clsErr } = await supabase
                    .from('classes')
                    .select('school_id')
                    .eq('id', selectedClass.id)
                    .maybeSingle();

                if (!clsErr && clsRow?.school_id) {
                    schoolIdForSchoolStudent = clsRow.school_id;
                } else {
                    console.warn('[PDI] Could not resolve school_id from classes for validation.', {
                        classId: selectedClass.id,
                        error: clsErr
                    });
                }
            }

            // Last-resort fallback: recuperar escola ativa via ProfileService/RPC
            if (!schoolIdForSchoolStudent) {
                try {
                    // 0) Primeiro: resolver via `teacher_schools` (evita depender de `profiles.school_id`)
                    try {
                        const { data: tsRow, error: tsErr } = await supabase
                            .from('teacher_schools')
                            .select('school_id')
                            .eq('teacher_id', userId)
                            .is('ended_at', null)
                            .order('started_at', { ascending: false })
                            .limit(1)
                            .maybeSingle();

                        if (!tsErr && (tsRow as any)?.school_id) {
                            schoolIdForSchoolStudent = (tsRow as any).school_id;
                            console.log('[PDI] Resolved schoolIdForSchoolStudent via teacher_schools:', schoolIdForSchoolStudent);
                        } else if (tsErr) {
                            console.warn('[PDI] teacher_schools lookup failed:', tsErr);
                        } else {
                            // Sem erro, mas sem linha ativa encontrada.
                            console.warn('[PDI] teacher_schools lookup returned no active row:', {
                                teacherId: userId,
                                endedAtIsNull: true
                            });

                            // Segundo fallback: pega a última linha (ignora ended_at)
                            try {
                                const { data: tsLatest, error: tsLatestErr } = await supabase
                                    .from('teacher_schools')
                                    .select('school_id, ended_at, started_at')
                                    .eq('teacher_id', userId)
                                    .order('started_at', { ascending: false })
                                    .limit(1)
                                    .maybeSingle();

                                if (!tsLatestErr && (tsLatest as any)?.school_id) {
                                    schoolIdForSchoolStudent = (tsLatest as any).school_id;
                                    console.log('[PDI] Resolved schoolIdForSchoolStudent via teacher_schools (latest row):', schoolIdForSchoolStudent);
                                } else if (tsLatestErr) {
                                    console.warn('[PDI] teacher_schools latest lookup failed:', tsLatestErr);
                                } else {
                                    console.warn('[PDI] teacher_schools latest lookup returned empty.', {
                                        teacherId: userId
                                    });
                                }
                            } catch (e) {
                                // no-op
                            }
                        }
                    } catch (e) {
                        // no-op: segue para os outros fallbacks
                    }

                    // Se conseguimos via teacher_schools, sincroniza profiles.school_id para destravar RLS.
                    if (schoolIdForSchoolStudent) {
                        try {
                            await supabase
                                .from('profiles')
                                .update({
                                    active_school_id: schoolIdForSchoolStudent,
                                    school_id: schoolIdForSchoolStudent
                                })
                                .eq('id', userId);
                        } catch (e) {
                            console.warn('[PDI] Failed to sync profiles.school_id after teacher_schools:', e);
                        }
                    }

                    // 1) Próximo fallback: ProfileService
                    const freshProfile = await ProfileService.getProfile();
                    const candidate =
                        (freshProfile as any)?.active_school_id ??
                        freshProfile?.school_id ??
                        (freshProfile as any)?.school?.id ??
                        null;
                    if (candidate) schoolIdForSchoolStudent = candidate;
                } catch (e) {
                    // no-op: seguimos para RPC
                }

                // Se existir, usar RPC que já é parte do schema/guardrails do backend.
                try {
                    const { data: rpcData, error: rpcErr } = await supabase.rpc('get_my_school_id_safe');
                    if (!rpcErr && rpcData) {
                        // Possíveis formatos: { school_id: '...' } | { id: '...' } | '...'
                        const candidate = (rpcData as any)?.school_id ?? (rpcData as any)?.id ?? (rpcData as any);
                        if (candidate && typeof candidate === 'string') schoolIdForSchoolStudent = candidate;
                    }
                    if (rpcErr) {
                        console.warn('[PDI] RPC get_my_school_id_safe failed:', rpcErr);
                    }
                    if (!rpcErr && !rpcData) {
                        console.warn('[PDI] RPC get_my_school_id_safe returned empty payload.');
                    }
                } catch (e) {
                    // no-op: se não existir no schema, ignoramos.
                }
            }

            // Se o `school_students` estiver bloqueado por RLS (muito comum quando `profiles.school_id` é vazio),
            // sincronizamos `profiles.school_id` com a escola resolvida no front.
            // Isso destrava leitura/inserção de `school_students` sem depender apenas de `active_school_id`.
            if (schoolIdForSchoolStudent && !(userProfile as any)?.school_id) {
                try {
                    await supabase
                        .from('profiles')
                        .update({
                            active_school_id: schoolIdForSchoolStudent,
                            school_id: schoolIdForSchoolStudent
                        })
                        .eq('id', userId);
                } catch (e) {
                    console.warn('[PDI] Failed to sync profiles.school_id for RLS:', e);
                }
            }

            let schoolStudentId = (student as any)?.school_student_id ?? null;

            // Fallback 0: se `student.id` já for o ID de `school_students`, aproveita.
            if (!schoolStudentId && student?.id) {
                const ssById = await getSchoolStudentById(student.id);
                if (ssById?.id) schoolStudentId = ssById.id;
            }

            // Fallback 1: resolve por nome + escola, ou cria se permitido.
            if (!schoolStudentId) {
                schoolStudentId = await (async () => {
                    if (!student) return null;
                    if (!schoolIdForSchoolStudent) return null;

                    const normalizedName = (student.name || '').trim();
                    if (!normalizedName) return null;

                    // 1) Try match por case-insensitive eq (trim aplicado)
                    try {
                        const { data: ssExact } = await supabase
                            .from('school_students')
                            .select('id')
                            .eq('school_id', schoolIdForSchoolStudent)
                            .ilike('name', normalizedName)
                            .maybeSingle();
                        if (ssExact?.id) return ssExact.id;
                    } catch (e) {
                        // ignore
                    }

                    // 2) Fallback: match parcial (reduz variação mínima de normalização)
                    try {
                        const { data: ssPartial } = await supabase
                            .from('school_students')
                            .select('id')
                            .eq('school_id', schoolIdForSchoolStudent)
                            .ilike('name', `%${normalizedName}%`)
                            .maybeSingle();
                        if (ssPartial?.id) return ssPartial.id;
                    } catch (e) {
                        // ignore
                    }

                    // 3) Usar helper já robusto por ilike/partial
                    const found = await findSchoolStudentBySchoolAndName(schoolIdForSchoolStudent, student.name);
                    if (found?.id) return found.id;

                    // 4) Se não existir ainda, tenta criar (somente se políticas permitirem)
                    const created = await createSchoolStudent(schoolIdForSchoolStudent, student.name);
                    if (created?.id) return created.id;

                    return null;
                })();
            }

            let loggedEvent = null;
            if (schoolStudentId) {
                loggedEvent = await PdiDocumentService.logEvent(
                    schoolStudentId,
                    'ADAPTATION',
                    `Adaptação: ${selectedLesson.topic}`,
                    {
                        lessonId: selectedLesson.id,
                        originalContent: selectedLesson.content,
                        adaptedContent: finalContent,
                        classId: selectedClass.id
                    },
                    'block9',
                    schoolIdForSchoolStudent,
                    selectedClass?.id ?? null
                );
            } else {
                console.warn('[PDI] Skipping database logging/sync: school_student_id is not resolved.');
            }

            // Ações comuns pós-validação (seja gravado no DB ou operado apenas localmente no front)
            if (loggedEvent) {
                setLastAdaptationDetails({
                    id: loggedEvent.id,
                    studentName: studentName,
                    lessonTopic: selectedLesson.topic
                });
            } else {
                setLastAdaptationDetails(null);
            }

            setFeedbackModalOpen(true);

            // Persistência no pdi_documents (apenas se tiver schoolStudentId)
            if (schoolStudentId) {
                try {
                    const payload = adaptations[studentId]?.block9Payload;
                    if (payload) {
                        const year =
                            typeof selectedClass?.year === 'number' ? selectedClass.year : new Date().getFullYear();
                        const { data: pdiDoc } = await PdiDocumentService.getOrCreatePdi(
                            schoolStudentId,
                            year,
                            { studentName: studentName }
                        );
                        if (pdiDoc?.id) {
                            await PdiDocumentService.addBlock9Adaptation(pdiDoc.id, payload);
                        }
                    } else {
                        console.warn('[PDI] Missing block9Payload in local state; skipping block_9_content persist.');
                    }
                } catch (e) {
                    console.error('[PDI] Failed to persist Block 9 on validate:', e);
                }
            }

            // Sempre atualiza o estado local para validado para não travar a experiência do usuário
            setAdaptations(prev => ({
                ...prev,
                [studentId]: {
                    ...prev[studentId],
                    status: 'validated'
                }
            }));
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
            const schoolStudentId = (student as any)?.school_student_id ?? student.id;
            // Quick fetch for latest record
            const { data } = await supabase
                .from('pdi_records')
                .select('id, title')
                .eq('student_id', schoolStudentId)
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
            const schoolStudentId = (student as any)?.school_student_id ?? student.id;
            const timeline = await PdiDocumentService.getStudentTimeline(schoolStudentId);
            const adaptationRecords = timeline.filter((r) => r.type === 'ADAPTATION');

            if (!adaptationRecords || adaptationRecords.length === 0) {
                setError(`Sem histórico de adaptações para o aluno ${student.name}. Valide pelo menos uma adaptação.`);
                return;
            }

            setLoading(true);
            const logsContent = adaptationRecords
                .map((r) => {
                    const adapted = (r.content as any)?.adaptedContent;
                    const short = typeof adapted === 'string'
                        ? adapted.replace(/\n+/g, ' ').trim().slice(0, 220)
                        : JSON.stringify(adapted ?? '').slice(0, 220);
                    const dateLabel = r.date || r.created_at || '';
                    return `- ${dateLabel}: ${r.title} - ${short}${short.length >= 220 ? '...' : ''}`;
                })
                .join('\n');

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

// (legacy) getPdiLogs removido do fluxo de geração de relatório.
