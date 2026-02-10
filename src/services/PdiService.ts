import { supabase } from './supabaseClient';
import { ProfileService } from './ProfileService';

export type PdiRecordType = 'EVALUATION' | 'OCCURRENCE' | 'LESSON_PLAN' | 'OBSERVATION' | 'ADAPTATION';

export interface PdiRecord {
    id: string;
    student_id: string;
    school_id: string;
    teacher_id: string;
    type: PdiRecordType;
    pdi_block?: string;
    title: string;
    content: any;
    date: string;
    created_at: string;
}

export const PdiService = {
    /**
     * Log an event to the student's PDI automatically.
     */
    async logEvent(
        studentId: string,
        type: PdiRecordType,
        title: string,
        content: any,
        pdiBlock?: string
    ): Promise<PdiRecord | null> {
        const profile = await ProfileService.getProfile();

        if (!profile || !profile.school_id) {
            console.warn('Cannot log PDI event: User not linked to a school.');
            return null;
        }

        const { data, error } = await supabase
            .from('pdi_records')
            .insert({
                student_id: studentId,
                school_id: profile.school_id,
                teacher_id: profile.id,
                type,
                title,
                content,
                pdi_block: pdiBlock,
                date: new Date().toISOString()
            })
            .select()
            .single();

        if (error) {
            console.error('Error logging PDI event:', error);
            throw error;
        }

        return data;
    },

    /**
     * Fetch the timeline of records for a specific student.
     */
    async getStudentTimeline(studentId: string): Promise<PdiRecord[]> {
        const { data, error } = await supabase
            .from('pdi_records')
            .select('*')
            .eq('student_id', studentId)
            .order('date', { ascending: false });

        if (error) {
            console.error('Error fetching PDI timeline:', error);
            return [];
        }

        return data || [];
    },

    async logEventForClass(classId: string, type: PdiRecordType, title: string, content: any, pdiBlock?: string) {
        // Fetch all students in the class
        const { data: students } = await supabase
            .from('students')
            .select('id')
            .eq('class_id', classId);

        if (!students) return;

        // Log for each student (parallel is faster but might hit limits, using Promise.all)
        return Promise.all(students.map(s => this.logEvent(s.id, type, title, content, pdiBlock)));
    },

    async updateRecordContent(recordId: string, newContent: any) {
        const { error } = await supabase
            .from('pdi_records')
            .update({ content: newContent })
            .eq('id', recordId);

        if (error) throw error;
    }
};

/**
 * Legacy/Compat: Fetch PDI logs with {data, error} signature
 */
export const getPdiLogs = async (studentId: string) => {
    const { data, error } = await supabase
        .from('pdi_records')
        .select('*')
        .eq('student_id', studentId)
        .order('date', { ascending: false });

    return { data, error };
};
