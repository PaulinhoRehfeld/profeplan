/**
 * Serviço de Armazenamento Local para Turmas e Aulas
 * Usa LocalStorage como banco de dados principal
 */

// ===== CLASS STORAGE =====

export interface LocalStudent {
    id: string;
    classId: string;
    name: string;
    student_code?: string;
    call_number?: number;
    needs_adaptation?: boolean;
    deficiencies?: string[];
    pedagogical_observations?: string;
}

export interface LocalClass {
    id: string;
    userId: string;
    name: string;
    subject: string;
    createdAt: string;
    students: LocalStudent[];
}

const STORAGE_KEY = 'profeplan_classes';

/**
 * Busca todas as turmas do usuário
 */
export const getLocalClasses = (userId: string): LocalClass[] => {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (!stored) return [];

    const allClasses: LocalClass[] = JSON.parse(stored);
    return allClasses.filter(c => c.userId === userId);
};

/**
 * Salva uma turma no localStorage
 */
export const saveClassToLocal = (userId: string, classData: { className: string, subject: string, students: string[] }): LocalClass => {
    const classes = getLocalClasses(userId); // Now this works because function is defined above or hoisted (but better to define before use in const-style)

    const newClass: LocalClass = {
        id: `class_${Date.now()}`,
        userId,
        name: classData.className,
        subject: classData.subject,
        createdAt: new Date().toISOString(),
        students: classData.students.map((name, index) => ({
            id: `student_${Date.now()}_${index}`,
            classId: `class_${Date.now()}`,
            name
        }))
    };

    // Need to read raw storage to allow pushing
    const stored = localStorage.getItem(STORAGE_KEY);
    const allClasses = stored ? JSON.parse(stored) : [];
    allClasses.push(newClass);

    localStorage.setItem(STORAGE_KEY, JSON.stringify(allClasses));

    return newClass;
};


/**
 * Atualiza uma turma inteira no localStorage (usado para salvar edições de alunos)
 */
export const updateLocalClass = (userId: string, updatedClass: LocalClass): void => {
    // We need to read all classes to update the specific one, regardless of user filtering (though typically unique IDs)
    const stored = localStorage.getItem(STORAGE_KEY);
    if (!stored) return;

    const allClasses: LocalClass[] = JSON.parse(stored);
    const index = allClasses.findIndex(c => c.id === updatedClass.id);

    if (index !== -1) {
        allClasses[index] = updatedClass;
        localStorage.setItem(STORAGE_KEY, JSON.stringify(allClasses));
    }
};

/**
 * Busca detalhes de uma turma específica
 */
export const getLocalClassDetails = (classId: string): LocalClass | null => {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (!stored) return null;

    const allClasses: LocalClass[] = JSON.parse(stored);
    return allClasses.find(c => c.id === classId) || null;
};

/**
 * Remove uma turma
 */
export const deleteLocalClass = (classId: string): boolean => {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (!stored) return false;

    const allClasses: LocalClass[] = JSON.parse(stored);
    const filtered = allClasses.filter(c => c.id !== classId);

    localStorage.setItem(STORAGE_KEY, JSON.stringify(filtered));
    return true;
};

/**
 * Exporta todas as turmas para formato JSON (para backup)
 */
export const exportClassesToJSON = (userId: string): string => {
    const classes = getLocalClasses(userId);
    return JSON.stringify(classes, null, 2);
};

/**
 * Importa turmas de um JSON
 */
export const importClassesFromJSON = (userId: string, jsonData: string): void => {
    const imported: LocalClass[] = JSON.parse(jsonData);

    // Read all existing
    const stored = localStorage.getItem(STORAGE_KEY);
    const existingAll = stored ? JSON.parse(stored) : [];

    // Merge imported with correct userId
    const mergedImported = imported.map(c => ({ ...c, userId }));

    const finalClasses = [...existingAll, ...mergedImported];

    localStorage.setItem(STORAGE_KEY, JSON.stringify(finalClasses));
};

// ===== LESSON STORAGE =====

const LESSONS_KEY = 'profeplan_lessons';

export interface LocalLesson {
    id: string;
    user_id: string;
    topic: string;
    content: string;
    canva_json: unknown;
    created_at: string;
}

/**
 * Salva uma aula no localStorage
 */
export const saveLessonToLocal = (userId: string, topic: string, content: string, canvaData: unknown): LocalLesson => {
    const stored = localStorage.getItem(LESSONS_KEY);
    const allLessons: LocalLesson[] = stored ? JSON.parse(stored) : [];

    const newLesson: LocalLesson = {
        id: `lesson_${Date.now()}`,
        user_id: userId,
        topic,
        content,
        canva_json: canvaData,
        created_at: new Date().toISOString()
    };

    allLessons.unshift(newLesson); // Adiciona no início
    localStorage.setItem(LESSONS_KEY, JSON.stringify(allLessons));

    return newLesson;
};

/**
 * Busca todas as aulas do usuário
 */
export const getLocalLessons = (userId: string): LocalLesson[] => {
    const stored = localStorage.getItem(LESSONS_KEY);
    if (!stored) return [];

    const allLessons: LocalLesson[] = JSON.parse(stored);
    return allLessons.filter(l => l.user_id === userId);
};

/**
 * Remove uma aula
 */
export const deleteLocalLesson = (lessonId: string): boolean => {
    const stored = localStorage.getItem(LESSONS_KEY);
    if (!stored) return false;

    const allLessons: LocalLesson[] = JSON.parse(stored);
    const filtered = allLessons.filter(l => l.id !== lessonId);

    localStorage.setItem(LESSONS_KEY, JSON.stringify(filtered));
    return true;
};

/**
 * Busca lições/aulas de uma turma específica (para geração contextualizada de avaliações)
 */
export const getLessonsByClass = (classId: string): LocalLesson[] => {
    const stored = localStorage.getItem(LESSONS_KEY);
    if (!stored) return [];

    try {
        const allLessons: LocalLesson[] = JSON.parse(stored);
        // Filtrar aulas que contêm referência à turma
        return allLessons.filter((lesson) =>
            lesson.topic?.includes(classId) ||
            lesson.content?.includes(classId)
        ).slice(0, 10); // Limitar a 10 aulas mais recentes
    } catch (e) {
        console.error('Erro ao buscar aulas:', e);
        return [];
    }
};

// ===== PDI LOGS STORAGE (FALLBACK) =====

const PDI_LOGS_KEY = 'profeplan_pdi_logs';

export interface LocalPdiLog {
    id: string;
    student_id: string;
    class_id: string;
    lesson_id: string;
    teacher_id: string;
    content: string;
    created_at: string;
    status: string;
}

export const savePdiLogToLocal = (log: {
    student_id: string,
    class_id: string,
    lesson_id: string,
    teacher_id: string,
    content: string
}): LocalPdiLog => {
    const stored = localStorage.getItem(PDI_LOGS_KEY);
    const allLogs: LocalPdiLog[] = stored ? JSON.parse(stored) : [];

    const newLog: LocalPdiLog = {
        id: `log_${Date.now()}`,
        student_id: log.student_id,
        class_id: log.class_id,
        lesson_id: log.lesson_id,
        teacher_id: log.teacher_id,
        content: log.content,
        created_at: new Date().toISOString(),
        status: 'validated'
    };

    allLogs.push(newLog);
    localStorage.setItem(PDI_LOGS_KEY, JSON.stringify(allLogs));
    return newLog;
};

export const getLocalPdiLogs = (studentId: string): LocalPdiLog[] => {
    const stored = localStorage.getItem(PDI_LOGS_KEY);
    if (!stored) return [];

    const allLogs: LocalPdiLog[] = JSON.parse(stored);
    return allLogs.filter(l => l.student_id === studentId).sort((a, b) =>
        new Date(b.created_at).getTime() - new Date(a.created_at).getTime()
    );
};
