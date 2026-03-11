import { supabase } from './supabaseClient'; // Unified client import
export { supabase }; // Re-export for backward compatibility


// Removed local createClient to ensure shared state with Auth
// const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
// const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;
// export const supabase = createClient(supabaseUrl, supabaseAnonKey);

/**
 * Salva uma nova aula na "Memória"
 */
export const saveLessonToMemory = async (
    userId: string,
    topic: string,
    content: string,
    canvaData: unknown,
    classId?: string
) => {
    const { data, error } = await supabase
        .from('lessons')
        .insert([{
            user_id: userId,
            topic,
            content,
            canva_json: canvaData,
            class_id: classId
        }]);
    return { data, error };
};

/**
 * Recupera o contexto das últimas aulas e preferências para "treinar" o Gemini
 */
export const getTeacherContext = async (userId: string, limit: number = 3) => {
    // Pega as últimas 'limit' aulas
    const { data: lessons } = await supabase
        .from('lessons')
        .select('content, topic')
        .eq('user_id', userId)
        .order('created_at', { ascending: false })
        .limit(limit);

    const { data: profile } = await supabase
        .from('profiles')
        .select('*')
        .eq('id', userId)
        .single();

    return {
        recentLessons: lessons || [],
        preferences: profile || {}
    };
};

/**
 * Busca aulas do usuário (Supabase)
 */
export const getLessons = async (userId: string) => {
    const { data, error } = await supabase
        .from('lessons')
        .select('*')
        .eq('user_id', userId)
        .order('created_at', { ascending: false });
    return { data, error };
};

/**
 * Busca aulas filtradas por turma (Supabase)
 */
export const getLessonsByClassSupabase = async (classId: string) => {
    const { data, error } = await supabase
        .from('lessons')
        .select('*')
        .eq('class_id', classId)
        .order('created_at', { ascending: false });
    return { data, error };
};

/**
 * Salva a estrutura da turma e seus alunos no Supabase.
 */
export const saveClassStructure = async (userId: string, classData: { className: string, subject: string, students: string[], schoolId?: string }) => {
    // 1. Criar a Turma
    const { data: classObj, error: classError } = await supabase
        .from('classes')
        .insert([{
            user_id: userId,
            school_id: classData.schoolId,
            name: classData.className,
            subject: classData.subject
        }])
        .select()
        .single();

    if (classError) throw classError;

    // 2. Criar os Alunos
    const studentRows = classData.students.map(name => ({
        class_id: classObj.id,
        name: name
    }));

    const { error: studentError } = await supabase
        .from('students')
        .insert(studentRows);

    if (studentError) throw studentError;

    return classObj;
    return classObj;
};

/**
 * Adiciona um aluno individualmente a uma turma
 */
export const addStudentToClass = async (classId: string, name: string, studentCode?: string, schoolId?: string) => {
    const { data, error } = await supabase
        .from('students')
        .insert([{
            class_id: classId,
            name: name,
            student_code: studentCode,
            current_school_id: schoolId // CRITICAL: Must be set for dashboard filtering
        }])
        .select()
        .single();

    return { data, error };
};

/**
 * Busca todas as turmas cadastradas do usuário.
 * @param userId - ID do usuário
 * @param schoolId - (Opcional) ID da escola para filtrar turmas
 */
export const getClasses = async (userId: string, schoolId?: string) => {
    let query = supabase
        .from('classes')
        .select(`
        *,
        students:students(count)
      `)
        .eq('user_id', userId);

    // Se school_id for fornecido, filtrar por escola
    if (schoolId) {
        query = query.eq('school_id', schoolId);
    }

    const { data, error } = await query.order('created_at', { ascending: false });

    return { data, error };
};

/**
 * Busca detalhes de uma turma (incluindo lista de alunos).
 */
export const getClassDetails = async (classId: string) => {
    const { data, error } = await supabase
        .from('classes')
        .select(`
        *,
        students:students(*)
      `)
        .eq('id', classId)
        .single();

    return { data, error };
};

/**
 * Remove uma turma e seus alunos (cascade delete configurado no banco).
 */
export const deleteClass = async (classId: string) => {
    const { error } = await supabase
        .from('classes')
        .delete()
        .eq('id', classId);
    return { error };
};

/**
 * Atualiza o perfil do professor
 */
export const updateTeacherProfile = async (userId: string, updates: Record<string, unknown>) => {
    const { data, error } = await supabase
        .from('profiles')
        .upsert({
            id: userId,
            ...updates,
            updated_at: new Date().toISOString()
        });
    return { data, error };
};

/**
 * Atualiza o perfil pedagógico do aluno (PDI/DUA)
 */
export const updateStudent = async (studentId: string, updates: {
    needs_adaptation?: boolean,
    deficiencies?: string[],
    pedagogical_observations?: string
}) => {
    const { data, error } = await supabase
        .from('students')
        .update(updates)
        .eq('id', studentId)
        .select()
        .single();

    return { data, error };
};

/**
 * Salva um log de adaptação PDI (para relatórios)
 */
export const savePdiLog = async (logData: {
    student_id: string,
    class_id: string,
    lesson_id?: string,
    teacher_id: string,
    content: string
}) => {
    // Uses RPC Strategy as requested by user to bypass schema cache
    const { data, error } = await supabase.rpc('save_pdi_log_direct', {
        p_student_id: logData.student_id,
        p_lesson_id: logData.lesson_id,
        p_class_id: logData.class_id, // Ensure this parameter is passed if the RPC expects it
        p_teacher_id: logData.teacher_id,
        p_content: logData.content
    });

    return { data, error };
};

/**
 * Busca logs de PDI para um aluno (para gerar relatório)
 */
export const getPdiLogs = async (studentId: string) => {
    // Uses View 'v_pdi_logs' to bypass potential table cache issues
    const { data, error } = await supabase
        .from('v_pdi_logs')
        .select('*')
        .eq('student_id', studentId)
        .order('created_at', { ascending: false });
    return { data, error };
};

/**
 * [TRACKING]
 * Busca o status de preparo das aulas de um planejamento
 */
export const getLessonTracking = async (termPlanId: string) => {
    const { data, error } = await supabase
        .from('lesson_tracking')
        .select('*')
        .eq('term_plan_id', termPlanId);
    return { data, error };
};

/**
 * [TRACKING]
 * Atualiza o status de uma aula (Ex: 'prepared')
 */
export const updateLessonTracking = async (userId: string, termPlanId: string, lessonIndex: number, status: 'pending' | 'prepared' | 'taught' = 'prepared') => {
    const { data, error } = await supabase
        .from('lesson_tracking')
        .upsert({
            user_id: userId,
            term_plan_id: termPlanId,
            lesson_index: lessonIndex,
            status: status,
            updated_at: new Date().toISOString()
        }, { onConflict: 'term_plan_id, lesson_index' });

    return { data, error };
};
