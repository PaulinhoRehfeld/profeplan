import { supabase } from '../supabaseClient';
import { PdiSchema, PDIProfileData } from '../../types/pdi-schema';
import { PdiDocument, TeacherEntry, PdiCompleteness, UserProfile } from '../../types';
import { z } from 'zod';


export const PdiDocumentService = {
    /**
     * Create or Get existing PDI for a student/year
     */
    async getOrCreatePdi(studentId: string, year: number = new Date().getFullYear(), contextualData?: { profile?: UserProfile | null, studentName?: string }): Promise<{ data: PdiDocument | null, error: any }> {
        const { data: existing, error: fetchError } = await supabase
            .from('pdi_documents')
            .select('*')
            .eq('student_id', studentId)
            .eq('year', year)
            .maybeSingle();

        if (fetchError) return { data: null, error: fetchError };
        if (existing) return { data: existing, error: null };

        // Create new PDI with auto-filled data if available
        const initialContent: Partial<PDIProfileData> = {};

        if (contextualData?.profile) {
            initialContent.institutional = {
                school_name: contextualData.profile.school_name || contextualData.profile.school?.name,
                city: contextualData.profile.city || contextualData.profile.school?.city,
                sre: contextualData.profile.school?.sre
            };
        }

        if (contextualData?.studentName) {
            initialContent.student_data = {
                name: contextualData.studentName
            };
        }

        const { data: newDoc, error: createError } = await supabase
            .from('pdi_documents')
            .insert({
                student_id: studentId,
                year,
                status: 'draft',
                content_data: initialContent
            })
            .select()
            .single();

        return { data: newDoc, error: createError };
    },

    /**
     * Update a specific section of the PDI Content Data (JSONB)
     */
    async updatePdiSection(pdiId: string, sectionKey: keyof PDIProfileData, sectionData: any): Promise<{ data: PdiDocument | null, error: any }> {
        try {
            const SectionSchema = PdiSchema.shape[sectionKey];
            const validatedData = SectionSchema.parse(sectionData);

            const { data: currentPdi, error: fetchError } = await supabase
                .from('pdi_documents')
                .select('content_data')
                .eq('id', pdiId)
                .single();

            if (fetchError) throw fetchError;

            const currentContent = currentPdi?.content_data || {};
            const updatedContent = {
                ...currentContent,
                [sectionKey]: validatedData
            };

            const { data: updatedPdi, error: updateError } = await supabase
                .from('pdi_documents')
                .update({
                    content_data: updatedContent,
                    updated_at: new Date().toISOString()
                })
                .eq('id', pdiId)
                .select()
                .single();

            return { data: updatedPdi, error: updateError };

        } catch (validationOrDbError: any) {
            console.error("PDI Update Error:", validationOrDbError);
            return { data: null, error: validationOrDbError };
        }
    },

    /**
     * Upsert a Teacher Evaluation Entry (Seção X)
     */
    async saveTeacherEntry(entry: TeacherEntry): Promise<{ data: any, error: any }> {
        const { data, error } = await supabase
            .from('pdi_teacher_entries')
            .upsert(entry, { onConflict: 'pdi_document_id, teacher_id, subject, bimester' })
            .select()
            .single();

        return { data, error };
    },

    /**
     * Get all teacher entries for a PDI
     */
    async getTeacherEntries(pdiId: string): Promise<{ data: any[] | null, error: any }> {
        const { data, error } = await supabase
            .from('pdi_teacher_entries')
            .select('*')
            .eq('pdi_document_id', pdiId);

        return { data, error };
    },

    /**
     * Get PDIs for a school
     */
    async getSchoolPdis(schoolId: string): Promise<PdiDocument[]> {
        const { data, error } = await supabase
            .from('pdi_documents')
            .select(`
                *,
                school_students:school_students!inner (
                    name,
                    school_id
                )
            `)
            .eq('school_students.school_id', schoolId)
            .order('updated_at', { ascending: false });

        if (error) {
            console.error('Error fetching School PDIs:', error);
            return [];
        }

        return (data || []) as unknown as PdiDocument[];
    },

    /**
     * Map database PdiDocument to Frontend Compatibility PdiDocument
     */
    mapToCompatibility(pdi: any): PdiDocument {
        const content = pdi.content_data || {};
        return {
            ...pdi,
            student_name: pdi.school_students?.name || pdi.student_name,
            last_updated: pdi.updated_at,
            blocks_completed: {
                block_1_8: !!content.student_data?.name,
                block_9: Array.isArray(pdi.block_9_content) ? pdi.block_9_content.length > 0 : false,
                block_10: Array.isArray(pdi.block_10_entries) ? pdi.block_10_entries.length > 0 : false,
                block_11: !!pdi.final_report
            }
        };
    },

    /**
     * Calculate Completeness based on JSONB Content
     */
    calculateCompleteness(pdi: PdiDocument): PdiCompleteness {
        const completed: string[] = [];
        const missing: string[] = [];
        const content = pdi.content_data || {};

        if (content.institutional?.school_name) completed.push('Dados Institucionais');
        else missing.push('Dados Institucionais');

        if (content.student_data?.name) completed.push('Dados do Estudante');
        else missing.push('Dados do Estudante');

        if (content.clinical_health && Object.keys(content.clinical_health).length > 0) completed.push('Dados Clínicos');
        else missing.push('Dados Clínicos');

        if (content.psychomotor && Object.keys(content.psychomotor).length > 5) completed.push('Psicomotor');
        else missing.push('Psicomotor');

        if (content.cognitive && Object.keys(content.cognitive).length > 5) completed.push('Cognitivo');
        else missing.push('Cognitivo');

        if (content.communication && Object.keys(content.communication).length > 0) completed.push('Comunicação');
        else missing.push('Comunicação');

        const totalSections = 6;
        const percentage = Math.round((completed.length / totalSections) * 100);

        return {
            overall_percentage: percentage,
            missing_sections: missing,
            blocks_status: [] // Stub for now or implement properly
        };
    },

    /**
     * Fetch PDI by ID
     */
    async getPdiDocument(pdiId: string): Promise<{ data: PdiDocument | null, error: any }> {
        const { data, error } = await supabase
            .from('pdi_documents')
            .select(`
                *,
                school_students:school_students (name)
            `)
            .eq('id', pdiId)
            .maybeSingle();

        return {
            data: data ? this.mapToCompatibility(data) : null,
            error
        };
    },

    /**
     * Legacy method - update blocks 1-8
     */
    async updateBlock1to8(pdiId: string, blockData: any): Promise<{ data: PdiDocument | null, error: any }> {
        const updates: Partial<PDIProfileData> = {};

        if (blockData.bloco_1_identificacao) {
            const b1 = blockData.bloco_1_identificacao;
            updates.student_data = {
                name: b1.nome_completo,
                dob: b1.data_nascimento,
                school_year: b1.serie,
                class_name: b1.turma,
                shift: b1.turno
            };
        }

        if (blockData.bloco_2_diagnostico) {
            const b2 = blockData.bloco_2_diagnostico;
            updates.clinical_health = {
                diagnosis_cid: b2.laudo_medico,
                medical_updates: b2.restricoes_atividades,
                medication: b2.medication
            };
        }

        const { data, error } = await supabase
            .from('pdi_documents')
            .update({
                content_data: updates,
                updated_at: new Date().toISOString()
            })
            .eq('id', pdiId)
            .select()
            .single();

        return { data: data ? this.mapToCompatibility(data) : null, error };
    },

    /**
     * Create PDI alias
     */
    async createPdiDocument(studentId: string, schoolId: string, year: number): Promise<{ data: PdiDocument | null, error: any }> {
        return this.getOrCreatePdi(studentId, year);
    },

    /**
     * Save block 10 evaluation
     */
    async addBlock10Evaluation(pdiId: string, evaluation: any): Promise<{ data: any, error: any }> {
        return this.saveTeacherEntry({
            pdi_document_id: pdiId,
            teacher_id: evaluation.professor_id,
            bimester: 1,
            subject: evaluation.disciplina,
            autonomy_level: evaluation.professor_grau_autonomia,
            observations: evaluation.ia_diagnostico
        });
    },

    /**
     * Update block 10 entry
     */
    async updateBlock10WithAI(pdiId: string, evaluationId: string, aiDiagnosis: string): Promise<{ data: any, error: any }> {
        const { data, error } = await supabase
            .from('pdi_teacher_entries')
            .update({ observations: aiDiagnosis })
            .eq('id', evaluationId);
        return { data, error };
    },

    /**
     * Add block 9 adaptation
     */
    async addBlock9Adaptation(pdiId: string, adaptation: any): Promise<{ data: any, error: any }> {
        return { data: adaptation, error: null };
    },

    /**
     * Update block 11 report
     */
    async updateBlock11ByProgument(pdiId: string, reportText: string): Promise<{ data: any, error: any }> {
        const { data, error } = await supabase
            .from('pdi_documents')
            .update({ final_report: reportText, updated_at: new Date().toISOString() })
            .eq('id', pdiId)
            .select()
            .single();
        return { data, error };
    },

    /**
     * Approve block 11 report
     */
    async approveBlock11(pdiId: string, approvedBy: string): Promise<{ data: any, error: any }> {
        const { data, error } = await supabase
            .from('pdi_documents')
            .update({
                status: 'finalizado',
                updated_at: new Date().toISOString()
            })
            .eq('id', pdiId)
            .select()
            .single();
        return { data, error };
    }
};
