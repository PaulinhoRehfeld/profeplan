/**
 * PDI (Plano de Desenvolvimento Individual) Types
 * Comprehensive type definitions for the 11-block PDI system
 */

// ============================================================================
// BLOCK 1-8: Base Form (Supervisor)
// ============================================================================

export interface Block1Identificacao {
    nome_completo: string;
    data_nascimento: string;
    codigo_inep?: string;
    serie?: string;
    turma?: string;
    turno?: string;
    diagnostico_clinico?: string;
    laudo_medico?: string;
    data_laudo?: string;
}

export interface Block2Diagnostico {
    necessidades_especificas?: string[];
    areas_comprometidas?: string[];
    potencialidades?: string[];
    desafios?: string[];
    medicamentos_uso?: string;
    restricoes_atividades?: string;
}

export interface Block3Objetivos {
    objetivo_geral?: string;
    objetivos_especificos?: string[];
    metas_curto_prazo?: string[];
    metas_longo_prazo?: string[];
}

export interface Block4Recursos {
    recursos_tecnologicos?: string[];
    materiais_adaptados?: string[];
    mobiliario_especifico?: string;
    equipamentos?: string[];
}

export interface Block5Equipe {
    professores?: string[];
    equipe_multidisciplinar?: Array<{
        nome: string;
        funcao: string;
        contato?: string;
    }>;
    apoio_escolar?: string;
}

export interface Block6Atendimento {
    frequencia_atendimento?: string;
    horarios?: string;
    local?: string;
    responsaveis?: string[];
    tipo_atendimento?: string[];
}

export interface Block7Familia {
    participacao_familia?: string;
    responsavel_principal?: string;
    contato_responsavel?: string;
    orientacoes_familia?: string;
}

export interface Block8Observacoes {
    observacoes_gerais?: string;
    historico_escolar?: string;
    transferencias?: string;
    outras_informacoes?: string;
}

export interface Block1to8Data {
    bloco_1_identificacao: Block1Identificacao;
    bloco_2_diagnostico: Block2Diagnostico;
    bloco_3_objetivos: Block3Objetivos;
    bloco_4_recursos: Block4Recursos;
    bloco_5_equipe: Block5Equipe;
    bloco_6_atendimento: Block6Atendimento;
    bloco_7_familia: Block7Familia;
    bloco_8_observacoes: Block8Observacoes;
}

// ============================================================================
// BLOCK 9: Pedagogical Planning (AI Generated)
// ============================================================================

export interface Block9AdaptationEntry {
    lesson_id: string;
    lesson_title: string;
    lesson_date?: string;
    subject: string;
    habilidades_bncc?: string[];

    // AI Generated Content
    adaptacao_metodologica: string;
    recursos_adaptados: string[];
    objetivos_adaptados: string[];
    estrategias_ensino: string[];
    tempo_estimado?: string;

    // Metadata
    generated_at: string;
    generated_by_ai: boolean;
}

export type Block9Content = Block9AdaptationEntry[];

// ============================================================================
// BLOCK 10: Evaluation (Professor + AI)
// ============================================================================

export type GrauAutonomia = 'total' | 'parcial' | 'dependente';

export interface Block10Entry {
    avaliacao_id: string;
    id?: string; // DB compatibility
    data: string;
    atividade_titulo: string;
    disciplina: string;
    subject?: string; // DB compatibility

    // Preenchido pelo Professor
    professor_valor: number; // Valor total da atividade
    professor_nota_alcancada: number; // Nota que o aluno alcançou
    professor_grau_autonomia: GrauAutonomia;
    autonomy_level?: string; // DB compatibility

    // Gerado pela IA
    ia_metodologia: string; // Como foi realizada a avaliação
    ia_diagnostico: string; // Potenciais e desafios identificados
    observations?: string; // DB compatibility

    // Metadata
    professor_id: string;
    created_at: string;
    ia_generated_at?: string;
}

export type Block10Entries = Block10Entry[];

// ============================================================================
// BLOCK 11: Final Report (AI + Supervisor)
// ============================================================================

export interface Block11Report {
    ai_generated: string; // Relatório gerado pela IA
    supervisor_edit?: string; // Versão editada pelo supervisor
    approved: boolean;
    approved_by?: string;
    approved_at?: string;
}

import { PDIProfileData } from './pdi-schema';

// ============================================================================
// PDI Document (Complete - Matches Database Schema)
// ============================================================================

export type PdiStatus = 'em_andamento' | 'finalizado' | 'arquivado' | 'draft' | 'active';

export interface PdiDocument {
    id: string;
    student_id: string;
    school_id?: string;
    year: number;
    period?: string;
    status: PdiStatus;
    content_data: Partial<PDIProfileData>;
    final_report?: string;
    created_at: string;
    updated_at: string;

    // Join data (optional)
    school_students?: {
        name: string;
        school_id?: string;
    };

    // Compatibility fields (to be deprecated in favor of content_data)
    block_1_8?: Block1to8Data;
    block_9_content?: Block9Content;
    block_10_entries?: Block10Entries;

    // Legacy support for older components
    blocks_completed?: {
        block_1_8: boolean;
        block_9: boolean;
        block_10: boolean;
        block_11: boolean;
    };
    student_name?: string; // Virtual property
    last_updated?: string; // Alias for updated_at
}


// ============================================================================
// Helper Types for Forms and API
// ============================================================================

export interface CreatePdiDocumentInput {
    student_id: string;
    school_id: string;
    period: string;
    block_1_8?: Partial<Block1to8Data>;
}

export interface UpdateBlock1to8Input {
    pdi_id: string;
    block_1_8: Partial<Block1to8Data>;
}

export interface AddBlock9AdaptationInput {
    pdi_id: string;
    adaptation: Omit<Block9AdaptationEntry, 'generated_at' | 'generated_by_ai'>;
}

export interface AddBlock10EvaluationInput {
    pdi_id: string;
    evaluation: Omit<Block10Entry, 'avaliacao_id' | 'created_at' | 'ia_metodologia' | 'ia_diagnostico' | 'ia_generated_at'>;
}

export interface ApproveBlock11Input {
    pdi_id: string;
    supervisor_edit?: string;
}

// ============================================================================
// View Models for UI
// ============================================================================

export interface PdiDocumentSummary {
    id: string;
    student_id: string;
    student_name: string;
    period: string; // Map to year in summarize
    status: PdiStatus;
    blocks_completed: {
        block_1_8: boolean;
        block_9: boolean;
        block_10: boolean;
        block_11: boolean;
    };
    last_updated: string;
}

export interface PdiCompletenessIndicator {
    total_blocks: number;
    completed_blocks: number;
    percentage: number;
    missing_blocks: string[];
}

export interface PdiCompleteness {
    overall_percentage: number;
    missing_sections: string[];
    blocks_status: Array<{
        block_name: string;
        is_complete: boolean;
        completion_percentage: number;
    }>;
}

export interface TeacherEntry {
    id?: string;
    pdi_document_id: string;
    teacher_id: string;
    bimester: number;
    subject: string;
    autonomy_level: string;
    observations?: string;
}
