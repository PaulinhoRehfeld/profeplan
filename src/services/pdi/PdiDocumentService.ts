import { supabase } from '../supabaseClient';
import { PdiSchema, PDIProfileData } from '../../types/pdi-schema';
import { PdiDocument, TeacherEntry, PdiCompleteness, UserProfile } from '../../types';
import { z } from 'zod';
import { ProfileService } from '../ProfileService';
import { checkUsageQuota } from '../userService';
import { getGenAIClient } from '../ai/AiCore';

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
    content: any;
    date: string;
    created_at: string;
}


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
     * Log an event to the student's PDI timeline
     * Consolidated from PdiService.logEvent()
     */
    async logEvent(
        studentId: string,
        type: PdiRecordType,
        title: string,
        content: any,
        pdiBlock?: string
    ): Promise<PdiRecord | null> {
        try {
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
        content: any,
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
    async updateRecordContent(recordId: string, newContent: any): Promise<{ success: boolean; error?: string }> {
        try {
            const { error } = await supabase
                .from('pdi_records')
                .update({ content: newContent })
                .eq('id', recordId);

            if (error) {
                return { success: false, error: error.message };
            }

            return { success: true };
        } catch (error: any) {
            console.error('Exception in updateRecordContent:', error);
            return { success: false, error: error.message };
        }
    },

    /**
     * Legacy/Compat: Fetch PDI logs with {data, error} signature
     */
    async getPdiLogs(studentId: string): Promise<{ data: PdiRecord[] | null; error: any }> {
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
    async getLogs(studentId: string): Promise<{ data: any[] | null; error: any }> {
        const { data, error } = await supabase
            .from('pdi_logs')
            .select('*')
            .eq('student_id', studentId)
            .order('created_at', { ascending: false });

        return { data, error };
    },

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
            const docx = await import('docx');
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
        } catch (error: any) {
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

function createBlock1Section(pdi: PdiDocument, docx: any): any[] {
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
                new TextRun(data.nome_completo || ''),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Data de Nascimento: ', bold: true }),
                new TextRun(data.data_nascimento || ''),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Código INEP: ', bold: true }),
                new TextRun(data.codigo_inep || 'Não informado'),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Série: ', bold: true }),
                new TextRun(data.serie || ''),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Turma: ', bold: true }),
                new TextRun(data.turma || ''),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({
            children: [
                new TextRun({ text: 'Diagnóstico Clínico: ', bold: true }),
                new TextRun(data.diagnostico_clinico || ''),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock2Section(pdi: PdiDocument, docx: any): any[] {
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

function createBlock3Section(pdi: PdiDocument, docx: any): any[] {
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
                new TextRun(data.objetivo_geral || ''),
            ],
            spacing: { after: 200 },
        }),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock4Section(pdi: PdiDocument, docx: any): any[] {
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

function createBlock5Section(pdi: PdiDocument, docx: any): any[] {
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

function createBlock6Section(pdi: PdiDocument, docx: any): any[] {
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
                new TextRun(data.frequencia_atendimento || ''),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock7Section(pdi: PdiDocument, docx: any): any[] {
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
                new TextRun(data.responsavel_principal || ''),
            ],
            spacing: { after: 100 },
        }),
        new Paragraph({ text: '', spacing: { after: 200 } }),
    ];
}

function createBlock8Section(pdi: PdiDocument, docx: any): any[] {
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

function createBlock9Summary(pdi: PdiDocument, docx: any): any[] {
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

function createBlock10Summary(pdi: PdiDocument, docx: any): any[] {
    const { Paragraph, HeadingLevel } = docx;
    const avaliacoes = pdi.block_10_entries || [];
    const mediaGeral = avaliacoes.length > 0
        ? (avaliacoes.reduce((sum: number, av: any) =>
            sum + ((av.professor_nota_alcancada / av.professor_valor) * 100), 0
        ) / avaliacoes.length).toFixed(1)
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

function createBlock11Section(pdi: PdiDocument, docx: any): any[] {
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

function createSignatureSection(docx: any): any[] {
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
    const genAI = getGenAIClient();

    if (userId) {
        const quotaStatus = await checkUsageQuota(userId);
        if (!quotaStatus.allowed) {
            throw new Error(quotaStatus.message);
        }
    }

    const prompt = `
    ATUE COMO UM ESPECIALISTA EM INCLUSÃO E DESENHO UNIVERSAL PARA APRENDIZAGEM (DUA).
    ...
    `;

    const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });
    const result = await model.generateContent(prompt);
    return {
        adaptacao_metodologica: result.response.text(),
        recursos_adaptados: [],
        objetivos_adaptados: [],
        estrategias_ensino: [],
        tempo_estimado: undefined
    };
};

export const exportPdiToDocx = async (pdi: any): Promise<void> => {
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
