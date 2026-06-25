import { PDIProfileData } from '../../types/pdi-schema';
import { PdiDocument, PdiCompleteness } from '../../types';

/**
 * Funções puras de mapeamento e cálculo de PDI.
 * Extraído de PdiDocumentService (Fase 2 — ver docs/REFACTORING_METHODOLOGY.md).
 * Sem dependências externas (sem supabase, sem rede).
 */

export function mapToCompatibility(
    pdi: Record<string, unknown> & {
        content_data?: Record<string, unknown>;
        school_students?: { name?: string };
        student_name?: string;
        updated_at?: string;
    }
): PdiDocument {
    const content = (pdi.content_data as Partial<PDIProfileData>) || {};
    return {
        ...pdi,
        student_name: pdi.school_students?.name || pdi.student_name,
        last_updated: pdi.updated_at,
        blocks_completed: {
            block_1_8: !!content.student_data?.name,
            block_9: Array.isArray(pdi.block_9_content) ? (pdi.block_9_content as unknown[]).length > 0 : false,
            block_10: Array.isArray(pdi.block_10_entries) ? (pdi.block_10_entries as unknown[]).length > 0 : false,
            block_11: !!pdi.final_report,
        },
    } as PdiDocument;
}

export function calculateCompleteness(pdi: PdiDocument): PdiCompleteness {
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
        blocks_status: [],
    };
}
