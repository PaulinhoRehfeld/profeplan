/**
 * Fachada de PdiDocumentService — Fase 2 refatoração.
 * Todos os métodos delegam para sub-módulos coesos.
 * Ver docs/REFACTORING_METHODOLOGY.md.
 */
import { PdiDocument, TeacherEntry, PdiCompleteness, UserProfile } from '../../types';
import { PDIProfileData } from '../../types/pdi-schema';
import { Block9AdaptationEntry } from '../../types/pdi';
import type { DocxModule } from './pdiDocxSections';
import {
    createBlock1Section, createBlock2Section, createBlock3Section, createBlock4Section,
    createBlock5Section, createBlock6Section, createBlock7Section, createBlock8Section,
    createBlock9Summary, createBlock10Summary, createBlock11Section, createSignatureSection,
} from './pdiDocxSections';

// Sub-módulos extraídos
import {
    logEvent as _logEvent,
    getStudentTimeline as _getStudentTimeline,
    logEventForClass as _logEventForClass,
    updateRecordContent as _updateRecordContent,
    getPdiLogs as _getPdiLogs,
    getLogs as _getLogs,
} from './pdiRecordRepository';
import {
    saveTeacherEntry as _saveTeacherEntry,
    getTeacherEntries as _getTeacherEntries,
    addBlock10Evaluation as _addBlock10Evaluation,
    updateBlock10WithAI as _updateBlock10WithAI,
} from './pdiTeacherEntryRepository';
import {
    getOrCreatePdi as _getOrCreatePdi,
    createPdiDocument as _createPdiDocument,
    getPdiDocument as _getPdiDocument,
    updatePdiSection as _updatePdiSection,
    updateBlock1to8 as _updateBlock1to8,
    getSchoolPdis as _getSchoolPdis,
    updateBlock11ByProgument as _updateBlock11ByProgument,
    approveBlock11 as _approveBlock11,
} from './pdiDocumentRepository';
import {
    addBlock9Adaptation as _addBlock9Adaptation,
    getStudentAdaptations as _getStudentAdaptations,
    getAdaptationStats as _getAdaptationStats,
    generateAdaptationsForLesson as _generateAdaptationsForLesson,
    generateBlock9Adaptation as _generateBlock9Adaptation,
} from './pdiBlock9Service';
import { mapToCompatibility as _mapToCompatibility, calculateCompleteness as _calculateCompleteness } from './pdiUtils';

// Re-exports de tipos para backward-compatibility
export type { PdiRecordType, PdiRecord } from './pdiRecordRepository';

type PdiRecordContent = Record<string, unknown>;

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

export const PdiDocumentService = {
    // ── pdiRecordRepository ──────────────────────────────────────────
    logEvent: _logEvent,
    getStudentTimeline: _getStudentTimeline,
    logEventForClass: _logEventForClass,
    updateRecordContent: _updateRecordContent,
    getPdiLogs: _getPdiLogs,
    getLogs: _getLogs,

    // ── pdiTeacherEntryRepository ────────────────────────────────────
    saveTeacherEntry: _saveTeacherEntry,
    getTeacherEntries: _getTeacherEntries,
    addBlock10Evaluation: _addBlock10Evaluation,
    updateBlock10WithAI: _updateBlock10WithAI,

    // ── pdiDocumentRepository ────────────────────────────────────────
    getOrCreatePdi: _getOrCreatePdi,
    createPdiDocument: _createPdiDocument,
    getPdiDocument: _getPdiDocument,
    updatePdiSection: _updatePdiSection,
    updateBlock1to8: _updateBlock1to8,
    getSchoolPdis: _getSchoolPdis,
    updateBlock11ByProgument: _updateBlock11ByProgument,
    approveBlock11: _approveBlock11,

    // ── pdiBlock9Service ─────────────────────────────────────────────
    addBlock9Adaptation: _addBlock9Adaptation,
    getStudentAdaptations: _getStudentAdaptations,
    getAdaptationStats: _getAdaptationStats,
    generateAdaptationsForLesson: _generateAdaptationsForLesson,

    // ── pdiUtils ─────────────────────────────────────────────────────
    mapToCompatibility: _mapToCompatibility,
    calculateCompleteness: _calculateCompleteness,

    // ── exportPdiToDocx (permanece aqui — único método com lógica docx) ──
    async exportPdiToDocx(pdi: PdiDocument): Promise<{ success: boolean; error?: string }> {
        try {
            const docx = (await import('docx')) as unknown as DocxModule;
            const fileSaver = await import('file-saver');
            const saveAs = fileSaver.saveAs;

            const { Document, Paragraph, HeadingLevel, AlignmentType, Packer } = docx;

            const studentName = pdi.student_name || 'Estudante';
            const formattedDate = new Date().toLocaleDateString('pt-BR');
            const fileName = `PDI_${studentName.replace(/ /g, '_')}_${pdi.year}_${formattedDate}.docx`;

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

// Standalone exports para backward-compatibility
export const generateBlock9Adaptation = _generateBlock9Adaptation;

export const exportPdiToDocx = async (pdi: PdiDocument): Promise<void> => {
    console.log('Exporting PDI to DOCX:', pdi);
};

export const generateBlock10Diagnosis = async (pdiId: string, diagnosis: string): Promise<void> => {
    console.log('Generating Block 10 Diagnosis:', pdiId, diagnosis);
};

export const generateBlock11Report = async (pdiId: string, context: unknown): Promise<string> => {
    console.log('Generating Block 11 Report:', pdiId, context);
    return '';
};
