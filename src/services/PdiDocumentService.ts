/**
 * PDI Document Service
 * Handles all CRUD operations for PDI documents
 */

import { supabase } from './supabaseClient';
import { ProfileService } from './ProfileService';
import {
    PdiDocument,
    PdiDocumentSummary,
    CreatePdiDocumentInput,
    UpdateBlock1to8Input,
    AddBlock9AdaptationInput,
    AddBlock10EvaluationInput,
    ApproveBlock11Input,
    Block9AdaptationEntry,
    Block10Entry,
    PdiCompletenessIndicator,
} from '../types/pdi';

export const PdiDocumentService = {
    /**
     * Create a new PDI document
     */
    async createPdiDocument(input: CreatePdiDocumentInput): Promise<PdiDocument | null> {
        const profile = await ProfileService.getProfile();

        if (!profile || !['school_manager', 'school_admin', 'admin'].includes(profile.role)) {
            console.error('Only supervisors can create PDI documents');
            return null;
        }

        const { data, error } = await supabase
            .from('pdi_documents')
            .insert({
                student_id: input.student_id,
                school_id: input.school_id,
                period: input.period,
                block_1_8: input.block_1_8 || {
                    bloco_1_identificacao: {},
                    bloco_2_diagnostico: {},
                    bloco_3_objetivos: {},
                    bloco_4_recursos: {},
                    bloco_5_equipe: {},
                    bloco_6_atendimento: {},
                    bloco_7_familia: {},
                    bloco_8_observacoes: {},
                },
            })
            .select()
            .single();

        if (error) {
            console.error('Error creating PDI document:', error);
            throw error;
        }

        return data as PdiDocument;
    },

    /**
     * Get PDI document by ID
     */
    async getPdiDocument(pdi_id: string): Promise<PdiDocument | null> {
        const { data, error } = await supabase
            .from('pdi_documents')
            .select('*')
            .eq('id', pdi_id)
            .single();

        if (error) {
            console.error('Error fetching PDI document:', error);
            return null;
        }

        return data as PdiDocument;
    },

    /**
     * Get all PDI documents for a student
     */
    async getStudentPdis(student_id: string): Promise<PdiDocument[]> {
        const { data, error } = await supabase
            .from('pdi_documents')
            .select('*')
            .eq('student_id', student_id)
            .order('created_at', { ascending: false });

        if (error) {
            console.error('Error fetching student PDIs:', error);
            return [];
        }

        return (data || []) as PdiDocument[];
    },

    /**
     * Get current PDI for a student in a specific period
     */
    async getCurrentPdi(student_id: string, period: string): Promise<PdiDocument | null> {
        const { data, error } = await supabase
            .from('pdi_documents')
            .select('*')
            .eq('student_id', student_id)
            .eq('period', period)
            .single();

        if (error) {
            if (error.code === 'PGRST116') {
                // No PDI found for this period
                return null;
            }
            console.error('Error fetching current PDI:', error);
            return null;
        }

        return data as PdiDocument;
    },

    /**
     * Get all PDIs for a school (for supervisors)
     */
    async getSchoolPdis(school_id: string): Promise<PdiDocumentSummary[]> {
        const { data, error } = await supabase
            .from('pdi_documents')
            .select(`
                *,
                school_students (
                    name
                )
            `)
            .eq('school_id', school_id)
            .order('updated_at', { ascending: false });

        if (error) {
            console.error('Error fetching school PDIs:', error);
            return [];
        }

        // Transform to summary
        return (data || []).map((pdi: any) => ({
            id: pdi.id,
            student_id: pdi.student_id,
            student_name: pdi.school_students?.name || 'Desconhecido',
            period: pdi.period,
            status: pdi.status,
            blocks_completed: {
                block_1_8: this._isBlock1to8Complete(pdi.block_1_8),
                block_9: (pdi.block_9_content || []).length > 0,
                block_10: (pdi.block_10_entries || []).length > 0,
                block_11: pdi.block_11_approved,
            },
            last_updated: pdi.updated_at,
        }));
    },

    /**
     * Update Blocks 1-8 (Supervisor only)
     */
    async updateBlock1to8(input: UpdateBlock1to8Input): Promise<boolean> {
        const profile = await ProfileService.getProfile();

        if (!profile || !['school_manager', 'school_admin', 'admin'].includes(profile.role)) {
            console.error('Only supervisors can update Blocks 1-8');
            return false;
        }

        const { error } = await supabase
            .from('pdi_documents')
            .update({
                block_1_8: input.block_1_8,
                block_1_8_filled_by: profile.id,
                block_1_8_filled_at: new Date().toISOString(),
            })
            .eq('id', input.pdi_id);

        if (error) {
            console.error('Error updating Block 1-8:', error);
            return false;
        }

        return true;
    },

    /**
     * Add Block 9 adaptation (AI generated)
     */
    async addBlock9Adaptation(input: AddBlock9AdaptationInput): Promise<boolean> {
        // Get current PDI
        const pdi = await this.getPdiDocument(input.pdi_id);
        if (!pdi) {
            console.error('PDI not found');
            return false;
        }

        // Create new adaptation entry
        const newAdaptation: Block9AdaptationEntry = {
            ...input.adaptation,
            generated_at: new Date().toISOString(),
            generated_by_ai: true,
        };

        // Append to existing adaptations
        const updatedContent = [...(pdi.block_9_content || []), newAdaptation];

        const { error } = await supabase
            .from('pdi_documents')
            .update({
                block_9_content: updatedContent,
                block_9_last_generated: new Date().toISOString(),
            })
            .eq('id', input.pdi_id);

        if (error) {
            console.error('Error adding Block 9 adaptation:', error);
            return false;
        }

        return true;
    },

    /**
     * Add Block 10 evaluation entry (Professor fills, AI completes)
     */
    async addBlock10Evaluation(input: AddBlock10EvaluationInput): Promise<string | null> {
        const profile = await ProfileService.getProfile();
        if (!profile) {
            console.error('User not authenticated');
            return null;
        }

        // Get current PDI
        const pdi = await this.getPdiDocument(input.pdi_id);
        if (!pdi) {
            console.error('PDI not found');
            return null;
        }

        // Create new evaluation entry (without AI fields initially)
        const evaluationId = crypto.randomUUID();
        const newEntry: Block10Entry = {
            ...input.evaluation,
            avaliacao_id: evaluationId,
            professor_id: profile.id,
            created_at: new Date().toISOString(),
            ia_metodologia: '', // Will be filled by AI
            ia_diagnostico: '', // Will be filled by AI
        };

        // Append to existing entries
        const updatedEntries = [...(pdi.block_10_entries || []), newEntry];

        const { error } = await supabase
            .from('pdi_documents')
            .update({
                block_10_entries: updatedEntries,
            })
            .eq('id', input.pdi_id);

        if (error) {
            console.error('Error adding Block 10 evaluation:', error);
            return null;
        }

        return evaluationId;
    },

    /**
     * Update Block 10 entry with AI-generated content
     */
    async updateBlock10WithAI(
        pdi_id: string,
        avaliacao_id: string,
        ia_metodologia: string,
        ia_diagnostico: string
    ): Promise<boolean> {
        // Get current PDI
        const pdi = await this.getPdiDocument(pdi_id);
        if (!pdi) return false;

        // Update the specific entry
        const updatedEntries = (pdi.block_10_entries || []).map((entry) =>
            entry.avaliacao_id === avaliacao_id
                ? {
                    ...entry,
                    ia_metodologia,
                    ia_diagnostico,
                    ia_generated_at: new Date().toISOString(),
                }
                : entry
        );

        const { error } = await supabase
            .from('pdi_documents')
            .update({
                block_10_entries: updatedEntries,
            })
            .eq('id', pdi_id);

        if (error) {
            console.error('Error updating Block 10 with AI:', error);
            return false;
        }

        return true;
    },

    /**
     * Generate Block 11 report (AI)
     */
    async generateBlock11Report(pdi_id: string, ai_report: string): Promise<boolean> {
        const { error } = await supabase
            .from('pdi_documents')
            .update({
                block_11_ai_generated: ai_report,
            })
            .eq('id', pdi_id);

        if (error) {
            console.error('Error generating Block 11 report:', error);
            return false;
        }

        return true;
    },

    /**
     * Approve Block 11 report (Supervisor)
     */
    async approveBlock11(input: ApproveBlock11Input): Promise<boolean> {
        const profile = await ProfileService.getProfile();

        if (!profile || !['school_manager', 'school_admin', 'admin'].includes(profile.role)) {
            console.error('Only supervisors can approve Block 11');
            return false;
        }

        const { error } = await supabase
            .from('pdi_documents')
            .update({
                block_11_supervisor_edit: input.supervisor_edit || null,
                block_11_approved: true,
                block_11_approved_by: profile.id,
                block_11_approved_at: new Date().toISOString(),
                status: 'finalizado',
            })
            .eq('id', input.pdi_id);

        if (error) {
            console.error('Error approving Block 11:', error);
            return false;
        }

        return true;
    },

    /**
     * Calculate PDI completeness
     */
    calculateCompleteness(pdi: PdiDocument): PdiCompletenessIndicator {
        const completed: string[] = [];
        const missing: string[] = [];

        // Block 1-8
        if (this._isBlock1to8Complete(pdi.block_1_8)) {
            completed.push('Blocos 1-8: Formulário Base');
        } else {
            missing.push('Blocos 1-8: Formulário Base');
        }

        // Block 9
        if ((pdi.block_9_content || []).length > 0) {
            completed.push('Bloco 9: Planejamento Pedagógico');
        } else {
            missing.push('Bloco 9: Planejamento Pedagógico');
        }

        // Block 10
        if ((pdi.block_10_entries || []).length > 0) {
            completed.push('Bloco 10: Avaliações');
        } else {
            missing.push('Bloco 10: Avaliações');
        }

        // Block 11
        if (pdi.block_11_approved) {
            completed.push('Bloco 11: Relatório Final');
        } else {
            missing.push('Bloco 11: Relatório Final');
        }

        return {
            total_blocks: 4,
            completed_blocks: completed.length,
            percentage: Math.round((completed.length / 4) * 100),
            missing_blocks: missing,
        };
    },

    /**
     * Helper: Check if Block 1-8 is minimally complete
     */
    _isBlock1to8Complete(block_1_8: any): boolean {
        if (!block_1_8) return false;

        // Check if at least Block 1 (Identificação) has data
        const block1 = block_1_8.bloco_1_identificacao || {};
        return !!block1.nome_completo;
    },
};
