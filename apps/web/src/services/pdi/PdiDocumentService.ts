import { supabase } from '../supabaseClient';
import { PdiSchema, PDIProfileData } from '../../types/pdi-schema';
import { PdiDocument, TeacherEntry, PdiCompleteness, UserProfile } from '../../types';
import { Block9AdaptationEntry } from '../../types/pdi';
import { z } from 'zod';
import { ProfileService } from '../ProfileService';
import { checkUsageQuota } from '../ProfileService';
import { createSimpleCompletion } from '../ai/AiCore';

const getErrorMessage = (error: unknown): string =>
    error instanceof Error ? error.message : 'Unknown error';

type PdiRecordContent = Record<string, unknown>;

type LegacyBlockData = {
    bloco_1_identificacao?: {
        nome_completo?: string;
        data_nascimento?: string;
        serie?: string;
        turma?: string;
        turno?: string;
    };
    bloco_2_diagnostico?: {
        laudo_medico?: string;
        restricoes_atividades?: string;
        medication?: string;
    };
};

type Block10EvaluationInput = {
    data: string;
    atividade_titulo: string;
    disciplina: string;
    professor_valor: number;
    professor_nota_alcancada: number;
    professor_id: string;
    professor_grau_autonomia?: string;
    ia_diagnostico?: string;
};

type Block9AdaptationInput = Omit<Block9AdaptationEntry, 'generated_at' | 'generated_by_ai'>;

type PdiDocRow = {
    id: string;
    content_data?: {
        clinical_health?: { diagnosis_cid?: string };
        pedagogical?: { specific_needs?: string; general_objective?: string; technological_resources?: string; adapted_materials?: string };
        cognitive?: { potentials?: string; challenges?: string };
    };
    school_students?: { name?: string };
};

/**
 * PDI Record Type for logging events
 */
export type PdiRecordType = 'EVALUATION' | 'OCCURRENCE' | 'LESSON_PLAN' | 'OBSERVATION' | 'ADAPTATION';

/**
 * PDI Record - Consolidation from PdiService
 */
export interface PdiRecord {
    id: string;
    student_id: string;
    school_id: string;
    teacher_id: string;
    type: PdiRecordType;
    pdi_block?: string;
    title: string;
    content: PdiRecordContent;
    date: string;
    created_at: string;
}


export const PdiDocumentService = {
    /**
     * Create or retrieve an existing PDI document for a student
     * If no PDI exists for the given year, creates a new one with optional contextual data
     * @param studentId - The unique identifier of the student
     * @param year - Academic year (defaults to current year)
     * @param contextualData - Optional data to pre-fill the PDI (profile, student name)
     * @returns Promise - Object with PDI document or error
     * @example
     * const result = await PdiDocumentService.getOrCreatePdi('student-123', 2025, { studentName: 'João' });
     */
    async getOrCreatePdi(
        studentId: string,
        year: number = new Date().getFullYear(),
        contextualData?: { profile?: UserProfile | null; studentName?: string }
    ): Promise<{ data: PdiDocument | null; error: unknown }> {
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
                // Mantém alinhamento com o CHECK CONSTRAINT do banco:
                // status IN ('em_andamento', 'finalizado', 'arquivado')
                status: 'em_andamento',
                content_data: initialContent
            })
            .select()
            .single();

        return { data: newDoc, error: createError };
    },

    /**
     * Log an event to the student's PDI timeline
     * Records an occurrence, lesson plan, evaluation, observation, or adaptation
     * Consolidated from legacy PdiService.logEvent()
     * @param studentId - The student's unique identifier
     * @param type - Type of record (EVALUATION | OCCURRENCE | LESSON_PLAN | OBSERVATION | ADAPTATION)
     * @param title - Brief title of the event
     * @param content - Detailed content of the event
     * @param pdiBlock - Optional PDI block reference (Block 1-11)
     * @returns Promise<PdiRecord | null> - Created record or null if failed
     * @throws Catches errors and logs them, returns null on failure
     * @example
     * const record = await PdiDocumentService.logEvent(studentId, 'EVALUATION', 'Math Test', { score: 8 });
     */
    async logEvent(
        studentId: string,
        type: PdiRecordType,
        title: string,
        content: PdiRecordContent,
        pdiBlock?: string,
        schoolIdOverride?: string | null,
        classIdOverride?: string | null
    ): Promise<PdiRecord | null> {
        try {
            const profile = await ProfileService.getProfile();
            let schoolId =
                schoolIdOverride ??
                (profile as any)?.active_school_id ??
                (profile as any)?.school_id ??
                null;

            if (!schoolId) {
                // Fallback: inferir a escola apenas via `classes`,
                // usando o `classIdOverride` (evita depender de colunas opcionais em `students`).
                try {
                    if (classIdOverride) {
                        const { data: clsRow, error: clsErr } = await supabase
                            .from('classes')
                            .select('school_id')
                            .eq('id', classIdOverride)
                            .maybeSingle();
                        if (clsErr) {
                            console.error('[PdiDocumentService] Failed to resolve school_id from `classes`:', {
                                classIdOverride,
                                schoolIdCandidate: (clsRow as any)?.school_id ?? null,
                                error: clsErr
                            });
                        }
                        const inferred =
                            (clsRow as any)?.school_id ??
                            null;
                        if (inferred) schoolId = inferred;
                    }
                } catch (e) {
                    // fail-silent: abaixo vai logar o erro final
                }
            }

            if (!schoolId) {
                console.error('[PdiDocumentService] Missing school_id for pdi_records insert. Ensure active_school_id/selectedClass.school_id (via classIdOverride) is set.', {
                    studentId,
                    type,
                    teacherId: (profile as any)?.id ?? null
                });
                return null;
            }

            const { data, error } = await supabase
                .from('pdi_records')
                .insert({
                    student_id: studentId,
                    // Aqui `schoolId` já foi validado/resolvido acima.
                    school_id: schoolId,
                    teacher_id: (profile as any)?.id ?? null,
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
                return null;
            }

            return data || null;
        } catch (error) {
            console.error('Exception in logEvent:', error);
            return null;
        }
    },

    /**
     * Fetch the timeline of records for a specific student
     */
    async getStudentTimeline(studentId: string): Promise<PdiRecord[]> {
        try {
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
        } catch (error) {
            console.error('Exception in getStudentTimeline:', error);
            return [];
        }
    },

    /**
     * Log event for all students in a class
     */
    async logEventForClass(
        classId: string,
        type: PdiRecordType,
        title: string,
        content: PdiRecordContent,
        pdiBlock?: string
    ): Promise<(PdiRecord | null)[]> {
        try {
            // Fetch all students in the class
            const { data: students, error: studentsError } = await supabase
                .from('students')
                .select('id')
                .eq('class_id', classId);

            if (studentsError || !students) {
                console.error('Error fetching students:', studentsError);
                return [];
            }

            // Log for each student (parallel)
            return Promise.all(
                students.map(s => this.logEvent(s.id, type, title, content, pdiBlock))
            );
        } catch (error) {
            console.error('Exception in logEventForClass:', error);
            return [];
        }
    },

    /**
     * Update PDI record content
     */
    async updateRecordContent(recordId: string, newContent: PdiRecordContent): Promise<{ success: boolean; error?: string }> {
        try {
            const { error } = await supabase
                .from('pdi_records')
                .update({ content: newContent })
                .eq('id', recordId);

            if (error) {
                return { success: false, error: error.message };
            }

            return { success: true };
        } catch (error: unknown) {
            console.error('Exception in updateRecordContent:', error);
            return { success: false, error: getErrorMessage(error) };
        }
    },

    /**
     * Legacy/Compat: Fetch PDI logs with {data, error} signature
     */
    async getPdiLogs(studentId: string): Promise<{ data: PdiRecord[] | null; error: unknown }> {
        try {
            const { data, error } = await supabase
                .from('pdi_records')
                .select('*')
                .eq('student_id', studentId)
                .order('date', { ascending: false });

            return { data, error };
        } catch (error) {
            return { data: null, error };
        }
    },

    /**
     * Get logs for a specific student
     */
    async getLogs(studentId: string): Promise<{ data: unknown[] | null; error: unknown }> {
        const { data, error } = await supabase
            .from('pdi_logs')
            .select('*')
            .eq('student_id', studentId)
            .order('created_at', { ascending: false });

        return { data, error };
    },

    async updatePdiSection(pdiId: string, sectionKey: keyof PDIProfileData, sectionData: unknown): Promise<{ data: PdiDocument | null, error: unknown }> {
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

        } catch (validationOrDbError: unknown) {
            console.error("PDI Update Error:", validationOrDbError);
            return { data: null, error: validationOrDbError };
        }
    },

    /**
     * Upsert a Teacher Evaluation Entry (Seção X)
     */
    async saveTeacherEntry(entry: TeacherEntry): Promise<{ data: TeacherEntry | null; error: unknown }> {
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
    async getTeacherEntries(pdiId: string): Promise<{ data: TeacherEntry[] | null, error: unknown }> {
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
                school_students:students!inner (
                    name,
                    current_school_id
                )
            `)
            .eq('school_students.current_school_id', schoolId)
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
    mapToCompatibility(pdi: Record<string, unknown> & { content_data?: Record<string, unknown>; school_students?: { name?: string }; student_name?: string; updated_at?: string }): PdiDocument {
        const content = (pdi.content_data as Partial<PDIProfileData>) || {};
        const mapped = {
            ...pdi,
            student_name: pdi.school_students?.name || pdi.student_name,
            last_updated: pdi.updated_at,
            blocks_completed: {
                block_1_8: !!content.student_data?.name,
                block_9: Array.isArray(pdi.block_9_content) ? (pdi.block_9_content as unknown[]).length > 0 : false,
                block_10: Array.isArray(pdi.block_10_entries) ? (pdi.block_10_entries as unknown[]).length > 0 : false,
                block_11: !!pdi.final_report
            }
        } as PdiDocument;

        return mapped;
    },

    /**
     * Calculate Completeness based on JSONB Content
     */
    calculateCompleteness(pdi: PdiDocument): PdiCompleteness {
        const completed: string[] = [];
        const missing: string[] = [];
        const content = (pdi.content_data as Partial<PDIProfileData>) || {};

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
    async getPdiDocument(pdiId: string): Promise<{ data: PdiDocument | null, error: unknown }> {
        const { data, error } = await supabase
            .from('pdi_documents')
            .select(`
                *,
                school_students:students (name, current_school_id)
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
    async updateBlock1to8(pdiId: string, blockData: LegacyBlockData): Promise<{ data: PdiDocument | null, error: unknown }> {
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
    async createPdiDocument(studentId: string, schoolId: string, year: number): Promise<{ data: PdiDocument | null, error: unknown }> {
        return this.getOrCreatePdi(studentId, year);
    },

    /**
     * Save block 10 evaluation
     */
    async addBlock10Evaluation(pdiId: string, evaluation: Block10EvaluationInput): Promise<{ data: TeacherEntry | null, error: unknown }> {
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
    async updateBlock10WithAI(pdiId: string, evaluationId: string, aiDiagnosis: string): Promise<{ data: unknown; error: unknown }> {
        const { data, error } = await supabase
            .from('pdi_teacher_entries')
            .update({ observations: aiDiagnosis })
            .eq('id', evaluationId);
        return { data, error };
    },

    /**
     * Add block 9 adaptation
     */
    async addBlock9Adaptation(pdiId: string, adaptation: Block9AdaptationInput): Promise<{ data: Block9AdaptationEntry; error: null }> {
        try {
            const generated_at = new Date().toISOString();
            const generated_by_ai = true;
            const enriched: Block9AdaptationEntry = {
                ...adaptation,
                generated_at,
                generated_by_ai
            };

            // Carrega o array atual para append/replace idempotente.
            const { data: row, error: fetchErr } = await supabase
                .from('pdi_documents')
                .select('block_9_content')
                .eq('id', pdiId)
                .maybeSingle();

            if (fetchErr) {
                console.error('[PdiDocumentService] Failed to load pdi_documents.block_9_content:', fetchErr);
                return { data: enriched, error: null };
            }

            const existing = (row?.block_9_content || []) as Block9AdaptationEntry[];
            const idx = existing.findIndex((e) => e.lesson_id === adaptation.lesson_id);

            const next =
                idx >= 0
                    ? [...existing.slice(0, idx), enriched, ...existing.slice(idx + 1)]
                    : [...existing, enriched];

            const { error: updateErr } = await supabase
                .from('pdi_documents')
                .update({ block_9_content: next })
                .eq('id', pdiId);

            if (updateErr) {
                console.error('[PdiDocumentService] Failed to persist block_9_content:', updateErr);
            }

            return { data: enriched, error: null };
        } catch (e) {
            console.error('[PdiDocumentService] Exception while persisting block_9_content:', e);
            // fail-soft: não bloqueia o fluxo, mas loga o motivo
            return {
                data: {
                    ...adaptation,
                    generated_at: new Date().toISOString(),
                    generated_by_ai: true
                } as Block9AdaptationEntry,
                error: null
            };
        }
    },

    /**
     * Get all Block 9 adaptations for a PDI (consolidado de PdiBlock9Service)
     */
    async getStudentAdaptations(pdiId: string): Promise<Block9AdaptationEntry[]> {
        try {
            const { data: pdi } = await this.getPdiDocument(pdiId);
            if (!pdi) return [];
            return (pdi.block_9_content || []) as Block9AdaptationEntry[];
        } catch (error) {
            console.error('Error fetching Block 9 adaptations:', error);
            return [];
        }
    },

    /**
     * Get Block 9 adaptation statistics (consolidado de PdiBlock9Service)
     */
    async getAdaptationStats(pdiId: string): Promise<{ total: number; last_generated?: string; subjects: string[] }> {
        const adaptations = await this.getStudentAdaptations(pdiId);
        const subjects = [...new Set(adaptations.map((a) => a.subject))];
        const lastGenerated =
            adaptations.length > 0
                ? adaptations.sort(
                      (a, b) => new Date(b.generated_at).getTime() - new Date(a.generated_at).getTime()
                  )[0].generated_at
                : undefined;
        return { total: adaptations.length, last_generated: lastGenerated, subjects: subjects as string[] };
    },

    /**
     * Generate Block 9 adaptations for all students with active PDIs in a class (consolidado de PdiBlock9Service)
     */
    async generateAdaptationsForLesson(
        lessonId: string,
        lessonTitle: string,
        lessonContent: string,
        subject: string,
        gradeLevel: string,
        habilidadesBncc: string[],
        classId: string,
        schoolId: string,
        userId: string,
        year: number
    ): Promise<{ success: boolean; adaptationsCreated: number; errors: string[] }> {
        const errors: string[] = [];
        let adaptationsCreated = 0;

        try {
            const { data: studentsWithPdi, error: studentsError } = await supabase
                .from('pdi_documents')
                .select(`id, student_id, year, content_data, school_students (id, name)`)
                .eq('school_id', schoolId)
                .eq('year', year)
                .eq('status', 'em_andamento');

            if (studentsError || !studentsWithPdi || studentsWithPdi.length === 0) {
                if (studentsError) errors.push(`Erro ao buscar alunos com PDI: ${studentsError.message}`);
                return { success: !studentsError, adaptationsCreated: 0, errors };
            }

            for (const pdiDoc of studentsWithPdi as PdiDocRow[]) {
                try {
                    const content = pdiDoc.content_data || {};
                    const studentContext = {
                        nome_completo: pdiDoc.school_students?.name || 'Estudante',
                        diagnostico_clinico: content.clinical_health?.diagnosis_cid,
                        necessidades_especificas: content.pedagogical?.specific_needs,
                        potencialidades: content.cognitive?.potentials,
                        desafios: content.cognitive?.challenges,
                        objetivo_geral: content.pedagogical?.general_objective,
                        recursos_tecnologicos: content.pedagogical?.technological_resources,
                        materiais_adaptados: content.pedagogical?.adapted_materials
                    };

                    if (!studentContext.nome_completo) {
                        errors.push(`${studentContext.nome_completo}: Formulário base incompleto`);
                        continue;
                    }

                    const adaptationResult = await generateBlock9Adaptation(
                        lessonContent,
                        lessonTitle,
                        subject,
                        gradeLevel,
                        habilidadesBncc,
                        studentContext as any,
                        userId
                    );

                    const newAdaptation: Omit<Block9AdaptationEntry, 'generated_at' | 'generated_by_ai'> = {
                        lesson_id: lessonId,
                        lesson_title: lessonTitle,
                        subject,
                        habilidades_bncc: habilidadesBncc,
                        adaptacao_metodologica: adaptationResult.adaptacao_metodologica,
                        recursos_adaptados: adaptationResult.recursos_adaptados,
                        objetivos_adaptados: adaptationResult.objetivos_adaptados,
                        estrategias_ensino: adaptationResult.estrategias_ensino,
                        tempo_estimado: adaptationResult.tempo_estimado
                    };

                    const saved = await this.addBlock9Adaptation(pdiDoc.id, newAdaptation);
                    if (saved.data) adaptationsCreated++;
                    else errors.push(`${studentContext.nome_completo}: Erro ao salvar`);
                } catch (err) {
                    errors.push(`${pdiDoc.school_students?.name || 'Estudante'}: ${getErrorMessage(err)}`);
                }
            }
            return { success: true, adaptationsCreated, errors };
        } catch (error) {
            return {
                success: false,
                adaptationsCreated,
                errors: [getErrorMessage(error) || 'Erro fatal ao gerar adaptações']
            };
        }
    },

    /**
     * Update block 11 report
     */
    async updateBlock11ByProgument(pdiId: string, reportText: string): Promise<{ data: unknown; error: unknown }> {
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
    async approveBlock11(pdiId: string, approvedBy: string): Promise<{ data: unknown; error: unknown }> {
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
    },

    /**
     * Export PDI to official DOCX format
     * Consolidated from PdiExportService.exportPdiToDocx()
     * 
     * NOTE: Requires docx and file-saver packages:
     * npm install docx file-saver
     * npm install --save-dev @types/file-saver
     */
    async exportPdiToDocx(pdi: PdiDocument): Promise<{ success: boolean; error?: string }> {
        try {
            const docx = (await import('docx')) as unknown as DocxModule;
            const fileSaver = await import('file-saver');
            const saveAs = fileSaver.saveAs;

            const { Document, Paragraph, HeadingLevel, AlignmentType, Packer, TextRun } = docx;

            const studentName = pdi.student_name || 'Estudante';
            const formattedDate = new Date().toLocaleDateString('pt-BR');
            const fileName = `PDI_${studentName.replace(/ /g, '_')}_${pdi.year}_${formattedDate}.docx`;

            // Create document
            const doc = new Document({
                sections: [
                    {
                        properties: {},
                        children: [
                            new Paragraph({
                                text: 'PLANO DE DESENVOLVIMENTO INDIVIDUAL - PDI',
                                heading: HeadingLevel.TITLE,
                                alignment: AlignmentType.CENTER,
                                spacing: { after: 400 },
                            }),
                            new Paragraph({
                                text: studentName,
                                heading: HeadingLevel.HEADING_1,
                                alignment: AlignmentType.CENTER,
                                spacing: { after: 200 },
                            }),
                            new Paragraph({
                                text: `Ano: ${pdi.year}`,
                                alignment: AlignmentType.CENTER,
                                spacing: { after: 200 },
                            }),
                            new Paragraph({
                                text: `Data de Emissão: ${formattedDate}`,
                                alignment: AlignmentType.CENTER,
                                spacing: { after: 800 },
                            }),

                            // Additional Blocks
                            ...createBlock1Section(pdi, docx),
                            ...createBlock2Section(pdi, docx),
                            ...createBlock3Section(pdi, docx),
                            ...createBlock4Section(pdi, docx),
                            ...createBlock5Section(pdi, docx),
                            ...createBlock6Section(pdi, docx),
                            ...createBlock7Section(pdi, docx),
                            ...createBlock8Section(pdi, docx),
                            ...createBlock9Summary(pdi, docx),
                            ...createBlock10Summary(pdi, docx),
                            ...createBlock11Section(pdi, docx),
                            ...createSignatureSection(docx),
                        ],
                    },
                ],
            });

            // Generate and download
            const blob = await Packer.toBlob(doc);
            saveAs(blob, fileName);

            return { success: true };
        } catch (error: unknown) {
            console.error('Error exporting PDI to DOCX:', error);
            return { 
                success: false, 
                error: 'Erro ao exportar PDI para DOCX. Verifique se bibliotecas "docx" e "file-saver" estão instaladas.' 
            };
        }
    }
};

/**
 * HELPER FUNCTIONS FOR DOCX EXPORT
 * Consolidated from PdiExportService
 */

type DocxModule = {
    Document: new (...args: unknown[]) => unknown;
    Packer: { toBlob: (doc: unknown) => Promise<Blob> };
    Paragraph: new (options: Record<string, unknown>) => unknown;
    TextRun: new (options: Record<string, unknown>) => unknown;
    HeadingLevel: Record<string, unknown>;
    AlignmentType: Record<string, unknown>;
};

function createBlock1Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
    const { Paragraph, TextRun, HeadingLevel } = docx;
    const data = pdi.block_1_8?.bloco_1_identificacao;
    if (!data) return [];

    return [
        new Paragraph({
            text: 'BLOCO 1: IDENTIFICAÇÃO DO ESTUDANTE',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Nome Completo: ', bold: true }),
                new TextRun({ text: data.nome_completo || '' }),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Data de Nascimento: ', bold: true }),
                new TextRun({ text: data.data_nascimento || '' }),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Código INEP: ', bold: true }),
                new TextRun({ text: data.codigo_inep || 'Não informado' }),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Série: ', bold: true }),
                new TextRun({ text: data.serie || '' }),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Turma: ', bold: true }),
                new TextRun({ text: data.turma || '' }),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Diagnóstico Clínico: ', bold: true }),
                new TextRun({ text: data.diagnostico_clinico || '' }),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock2Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
    const { Paragraph, HeadingLevel } = docx;
    const data = pdi.block_1_8?.bloco_2_diagnostico;
    if (!data) return [];

    return [
        new Paragraph({
            text: 'BLOCO 2: DIAGNÓSTICO PEDAGÓGICO',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            text: 'Necessidades Específicas:',
            bold: true,
            spacing: { after: 100 },
        }),
        ...(data.necessidades_especificas?.map((n: string) =>
            new Paragraph({ text: `• ${n}`, spacing: { after: 50 } })
        ) || []),
        new Paragraph({
            text: 'Potencialidades:',
            bold: true,
            spacing: { before: 200, after: 100 },
        }),
        ...(data.potencialidades?.map((p: string) =>
            new Paragraph({ text: `• ${p}`, spacing: { after: 50 } })
        ) || []),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock3Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
    const { Paragraph, TextRun, HeadingLevel } = docx;
    const data = pdi.block_1_8?.bloco_3_objetivos;
    if (!data) return [];

    return [
        new Paragraph({
            text: 'BLOCO 3: OBJETIVOS DO PDI',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Objetivo Geral: ', bold: true }),
                new TextRun({ text: data.objetivo_geral || '' }),
            ],
            spacing: { after: 200 },
        }),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock4Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
    const { Paragraph, HeadingLevel } = docx;
    const data = pdi.block_1_8?.bloco_4_recursos;
    if (!data) return [];

    return [
        new Paragraph({
            text: 'BLOCO 4: RECURSOS E MATERIAIS',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            text: 'Recursos Tecnológicos:',
            bold: true,
            spacing: { after: 100 },
        }),
        ...(data.recursos_tecnologicos?.map((r: string) =>
            new Paragraph({ text: `• ${r}`, spacing: { after: 50 } })
        ) || []),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock5Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
    const { Paragraph, HeadingLevel } = docx;
    const data = pdi.block_1_8?.bloco_5_equipe;
    if (!data) return [];

    return [
        new Paragraph({
            text: 'BLOCO 5: EQUIPE MULTIDISCIPLINAR',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            text: 'Professores Envolvidos:',
            bold: true,
            spacing: { after: 100 },
        }),
        ...(data.professores?.map((p: string) =>
            new Paragraph({ text: `• ${p}`, spacing: { after: 50 } })
        ) || []),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock6Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
    const { Paragraph, TextRun, HeadingLevel } = docx;
    const data = pdi.block_1_8?.bloco_6_atendimento;
    if (!data) return [];

    return [
        new Paragraph({
            text: 'BLOCO 6: PLANO DE ATENDIMENTO',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Frequência: ', bold: true }),
                new TextRun({ text: data.frequencia_atendimento || '' }),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock7Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
    const { Paragraph, TextRun, HeadingLevel } = docx;
    const data = pdi.block_1_8?.bloco_7_familia;
    if (!data) return [];

    return [
        new Paragraph({
            text: 'BLOCO 7: PARTICIPAÇÃO DA FAMÍLIA',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Responsável: ', bold: true }),
                new TextRun({ text: data.responsavel_principal || '' }),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock8Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
    const { Paragraph, HeadingLevel } = docx;
    const data = pdi.block_1_8?.bloco_8_observacoes;
    if (!data) return [];

    return [
        new Paragraph({
            text: 'BLOCO 8: OBSERVAÇÕES GERAIS',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            text: data.observacoes_gerais || '',
            spacing: { after: 200 },
        }),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock9Summary(pdi: PdiDocument, docx: DocxModule): unknown[] {
    const { Paragraph, HeadingLevel } = docx;
    const total = pdi.block_9_content?.length || 0;

    return [
        new Paragraph({
            text: 'BLOCO 9: RESUMO DE ADAPTAÇÕES CURRICULARES',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            text: `Total de adaptações realizadas: ${total}`,
            bold: true,
            spacing: { after: 100 },
        }),
        new Paragraph({
            text: '(Detalhamento completo disponível no sistema digital)',
            italics: true,
            spacing: { after: 200 },
        }),
    ];
}

function createBlock10Summary(pdi: PdiDocument, docx: DocxModule): unknown[] {
    const { Paragraph, HeadingLevel } = docx;
    const avaliacoes = pdi.block_10_entries || [];
    const mediaGeral = avaliacoes.length > 0
        ? (avaliacoes.reduce((sum: number, av) => {
            const entry = av as { professor_nota_alcancada?: number; professor_valor?: number };
            return sum + ((entry.professor_nota_alcancada as number) / (entry.professor_valor as number)) * 100;
        }, 0) / avaliacoes.length).toFixed(1)
        : 'N/A';

    return [
        new Paragraph({
            text: 'BLOCO 10: RESUMO DE AVALIAÇÕES',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            text: `Total de avaliações: ${avaliacoes.length}`,
            bold: true,
            spacing: { after: 100 },
        }),
        new Paragraph({
            text: `Média geral de aproveitamento: ${mediaGeral}%`,
            bold: true,
            spacing: { after: 100 },
        }),
        new Paragraph({
            text: '(Detalhamento completo disponível no sistema digital)',
            italics: true,
            spacing: { after: 200 },
        }),
    ];
}

function createBlock11Section(pdi: PdiDocument, docx: DocxModule): unknown[] {
    const { Paragraph, HeadingLevel } = docx;
    const reportText = pdi.final_report || '';

    return [
        new Paragraph({
            text: 'BLOCO 11: RELATÓRIO FINAL',
            heading: HeadingLevel.HEADING_1,
            spacing: { before: 400, after: 200 },
        }),
        new Paragraph({
            text: reportText,
            spacing: { after: 400 },
        }),
    ];
}

function createSignatureSection(docx: DocxModule): unknown[] {
    const { Paragraph, HeadingLevel, AlignmentType } = docx;
    return [
        new Paragraph({ text: '', spacing: { before: 800, after: 200 } }),
        new Paragraph({
            text: 'ASSINATURAS',
            heading: HeadingLevel.HEADING_2,
            alignment: AlignmentType.CENTER,
            spacing: { after: 400 },
        }),
        new Paragraph({
            text: '_'.repeat(60),
            alignment: AlignmentType.CENTER,
            spacing: { after: 100 },
        }),
        new Paragraph({
            text: 'Coordenador Pedagógico / Gestor Escolar',
            alignment: AlignmentType.CENTER,
            spacing: { after: 50 },
        }),
        new Paragraph({
            text: `Data: ______/______/______`,
            alignment: AlignmentType.CENTER,
            spacing: { after: 400 },
        }),
        new Paragraph({
            text: '_'.repeat(60),
            alignment: AlignmentType.CENTER,
            spacing: { after: 100 },
        }),
        new Paragraph({
            text: 'Professor Responsável',
            alignment: AlignmentType.CENTER,
            spacing: { after: 50 },
        }),
        new Paragraph({
            text: `Data: ______/______/______`,
            alignment: AlignmentType.CENTER,
            spacing: { after: 400 },
        }),
        new Paragraph({
            text: '_'.repeat(60),
            alignment: AlignmentType.CENTER,
            spacing: { after: 100 },
        }),
        new Paragraph({
            text: 'Responsável Legal do Estudante',
            alignment: AlignmentType.CENTER,
            spacing: { after: 50 },
        }),
        new Paragraph({
            text: `Data: ______/______/______`,
            alignment: AlignmentType.CENTER,
        }),
    ];
}

export const generateBlock9Adaptation = async (
    lessonContent: string,
    lessonTitle: string,
    subject: string,
    gradeLevel: string,
    habilidadesBncc: string[],
    studentPdiContext: {
        nome_completo: string;
        diagnostico_clinico?: string;
        necessidades_especificas?: string[];
        potencialidades?: string[];
        desafios?: string[];
        objetivo_geral?: string;
        recursos_tecnologicos?: string[];
        materiais_adaptados?: string[];
    },
    userId?: string
): Promise<{
    adaptacao_metodologica: string;
    recursos_adaptados: string[];
    objetivos_adaptados: string[];
    estrategias_ensino: string[];
    tempo_estimado?: string;
}> => {
    if (userId) {
        const quotaStatus = await checkUsageQuota(userId);
        if (!quotaStatus.allowed) {
            throw new Error(quotaStatus.message);
        }
    }

    const prompt = `ATUE COMO UM ESPECIALISTA EM INCLUSÃO E DESENHO UNIVERSAL PARA APRENDIZAGEM (DUA).

AULA: ${lessonTitle} (${subject} - ${gradeLevel})
Conteúdo: ${lessonContent.substring(0, 2500)}
Habilidades BNCC: ${habilidadesBncc.join(', ')}

PERFIL DO ALUNO:
Nome: ${studentPdiContext.nome_completo}
Diagnóstico: ${studentPdiContext.diagnostico_clinico || 'Não especificado'}
Necessidades: ${studentPdiContext.necessidades_especificas?.join(', ') || 'Não especificadas'}
Objetivo geral: ${studentPdiContext.objetivo_geral || 'Não especificado'}

Gere uma adaptação curricular desta aula para este aluno seguindo DUA. Retorne em Markdown com seções: Objetivos Adaptados, Estratégias de Acesso, Atividade Adaptada, Avaliação Diferenciada.`;

    const adaptacao_metodologica = await createSimpleCompletion(
        prompt,
        "Você é um especialista em inclusão e DUA escrevendo adaptações de aula. Seja específico e aplicável na sala de aula."
    );
    return {
        adaptacao_metodologica,
        recursos_adaptados: [],
        objetivos_adaptados: [],
        estrategias_ensino: [],
        tempo_estimado: undefined
    };
};

export const exportPdiToDocx = async (pdi: PdiDocument): Promise<void> => {
    // Implementation for exporting PDI to DOCX
    console.log('Exporting PDI to DOCX:', pdi);
};

export const generateBlock10Diagnosis = async (pdiId: string, diagnosis: string): Promise<void> => {
    // Implementation for generating Block 10 diagnosis
    console.log('Generating Block 10 Diagnosis:', pdiId, diagnosis);
};

export const generateBlock11Report = async (pdiId: string, report: string): Promise<void> => {
    // Implementation for generating Block 11 report
    console.log('Generating Block 11 Report:', pdiId, report);
};
