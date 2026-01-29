import { z } from 'zod';

// --- ENUMS ---
export enum PDIAnswer {
    APRESENTA = "APRESENTA",
    COM_AJUDA = "COM_AJUDA",
    NAO_APRESENTA = "NAO_APRESENTA",
    NAO_OBSERVADO = "NAO_OBSERVADO"
}

// Zod Enum for Validation
const AnswerEnum = z.nativeEnum(PDIAnswer);

// --- SCHEMAS ---

// SEÇÃO VI - ASPECTOS PSICOMOTORES
const PsychomotorSchema = z.object({
    esquema_corporal: AnswerEnum,
    consciencia_corporal: AnswerEnum,
    expressao_corporal: AnswerEnum,
    imagem_corporal: AnswerEnum,
    tonus_hipertonico: AnswerEnum,
    tonus_hipotonico: AnswerEnum,
    coordenacao_motora_ampla: AnswerEnum,
    coordenacao_motora_fina: AnswerEnum,
    equilibrio_dinamico: AnswerEnum,
    equilibrio_estatico: AnswerEnum,
    lateralidade: AnswerEnum,
    percepcao_gustativa: AnswerEnum,
    percepcao_olfativa: AnswerEnum,
    percepcao_tatil: AnswerEnum,
    percepcao_visual: AnswerEnum,
    postura: AnswerEnum
});

// SEÇÃO VII - ASPECTOS PEDAGÓGICOS/COGNITIVOS
const CognitiveSchema = z.object({
    memoria_curto_prazo: AnswerEnum,
    memoria_longo_prazo: AnswerEnum,
    memoria_auditiva: AnswerEnum,
    memoria_visual: AnswerEnum,
    percepcao_auditiva: AnswerEnum,
    percepcao_corporal: AnswerEnum,
    percepcao_espacial: AnswerEnum,
    percepcao_tatil_cognitiva: AnswerEnum, // Renamed to avoid collision if flattened, though safe in object
    percepcao_temporal: AnswerEnum,
    percepcao_visual_cognitiva: AnswerEnum,
    atencao_alerta: AnswerEnum,
    atencao_alternada: AnswerEnum,
    atencao_seletiva: AnswerEnum,
    atencao_sustentada: AnswerEnum,
    raciocinio_logico_abdutivo: AnswerEnum,
    raciocinio_logico_dedutivo: AnswerEnum,
    raciocinio_logico_intuitivo: AnswerEnum,
    pensamento_analitico: AnswerEnum,
    pensamento_criativo: AnswerEnum,
    pensamento_critico: AnswerEnum,
    pensamento_sintese: AnswerEnum,
    pensamento_questionador: AnswerEnum,
    pensamento_sistemico: AnswerEnum,
    compreende_ordens_simples: AnswerEnum,
    compreende_ordens_complexas: AnswerEnum,
    relata_situacoes: AnswerEnum
});

// SECTION X - TEACHER EVALUATION (AVALIAÇÃO BIMESTRAL/TRIMESTRAL)
export enum AutonomyLevel {
    MUITO_SUPORTE = "MUITO_SUPORTE", // "Necessita de muito suporte"
    POUCO_SUPORTE = "POUCO_SUPORTE", // "Necessita de pouco suporte"
    AUTONOMO = "AUTONOMO",           // "Autônomo"
    NAO_OBSERVADO = "NAO_OBSERVADO"
}

export enum ComprehensionLevel {
    ALTA = "ALTA",
    MEDIA = "MEDIA",
    BAIXA = "BAIXA",
    NENHUMA = "NENHUMA"
}

export const TeacherEvaluationSchema = z.object({
    subject: z.string().min(1, "Matéria obrigatória"),
    period: z.number().min(1).max(3), // 1, 2, 3 (Trimesters)
    autonomy_level: z.nativeEnum(AutonomyLevel),
    comprehension_level: z.nativeEnum(ComprehensionLevel),
    pedagogical_diagnosis: z.string().min(10, "Descreva o diagnóstico com pelo menos 10 caracteres")
});

export type pdiTeacherEvaluationForm = z.infer<typeof TeacherEvaluationSchema>;


// ROOT SCHEMA
export const PDI_SCHEMA = z.object({
    psychomotor: PsychomotorSchema.optional(),
    cognitive: CognitiveSchema.optional()
    // Other sections to be added later
});

export type PDIProfileData = z.infer<typeof PDI_SCHEMA>;


// --- DICTIONARY (Label Definitions) ---
export const PDI_QUESTIONS = {
    psychomotor: {
        esquema_corporal: "Esquema corporal - Conhece as partes e funções do corpo? Nomeia as partes do corpo?",
        consciencia_corporal: "Consciência corporal - Sabe do uso específico de cada membro do corpo para a realização de atividades...",
        expressao_corporal: "Expressão corporal - Realizar gestos expressivos (susto, grito, tristeza, raiva)?",
        imagem_corporal: "Imagem corporal - Relação do próprio corpo com o espaço e as pessoas.",
        tonus_hipertonico: "Tônus Hipertônico - Apresenta rigidez muscular elevada?",
        tonus_hipotonico: "Tônus Hipotônico - Apresenta flacidez muscular elevada?",
        coordenacao_motora_ampla: "Coordenação motora ampla - Controla os movimentos amplos do corpo?",
        coordenacao_motora_fina: "Coordenação motora fina - Controla os pequenos músculos para exercícios refinados?",
        equilibrio_dinamico: "Equilíbrio dinâmico - Ex.: andar na ponta dos pés, correr com copo cheio...",
        equilibrio_estatico: "Equilíbrio estático - Sustenta-se em diferentes situações?",
        lateralidade: "Lateralidade - Tem capacidade motora de percepção integrada dos dois lados...",
        percepcao_gustativa: "Percepção gustativa - Tem a capacidade de distinguir sabores?",
        percepcao_olfativa: "Percepção olfativa - Tem a capacidade de distinguir odores?",
        percepcao_tatil: "Percepção tátil - Sente as variações de pressão, temperatura...",
        percepcao_visual: "Percepção visual - Identifica formas geométricas, junta objetos iguais...",
        postura: "Postura - Posição ou atitude do corpo ligada ao movimento."
    },
    cognitive: {
        memoria_curto_prazo: "Memória de Curto Prazo - lembra-se de acontecimentos cotidianos...",
        memoria_longo_prazo: "Memória de Longo Prazo - lembra-se de fatos ocorridos ao longo da vida...",
        memoria_auditiva: "Memória Auditiva - memoriza o que escuta?",
        memoria_visual: "Memória Visual - memoriza o que vê?",
        percepcao_auditiva: "Percepção Auditiva - escuta e interpreta os estímulos sonoros?",
        percepcao_corporal: "Percepção Corporal - tem consciência do próprio corpo?",
        percepcao_espacial: "Percepção Espacial - compreende as dimensões do entorno e dos objetos?",
        percepcao_tatil_cognitiva: "Percepção Tátil - reconhece formas, texturas, tamanhos pelo tato?",
        percepcao_temporal: "Percepção Temporal - Tem a capacidade de situar-se em função da sucessão...",
        percepcao_visual_cognitiva: "Percepção Visual - enxerga e interpreta os estímulos visuais...",
        atencao_alerta: "Atenção Alerta - responde imediatamente a um estímulo apresentado?",
        atencao_alternada: "Atenção Alternada - realiza atividade proposta e conversa ao mesmo tempo?",
        atencao_seletiva: "Atenção Seletiva - concentra-se em uma atividade ignorando os demais...",
        atencao_sustentada: "Atenção Sustentada - concentra-se por um longo período de tempo...",
        raciocinio_logico_abdutivo: "Raciocínio Lógico Abdutivo - busca novas ideias e conhecimentos...",
        raciocinio_logico_dedutivo: "Raciocínio Lógico Dedutivo - parte de um fato geral para um particular...",
        raciocinio_logico_intuitivo: "Raciocínio Lógico Intuitivo - parte de um fato específico para o geral...",
        pensamento_analitico: "Pensamento Analítico - separa o todo em partes com as mesmas características?",
        pensamento_criativo: "Pensamento Criativo - baseado em seus conhecimentos cria ou modifica algo...",
        pensamento_critico: "Pensamento Crítico - examina, analisa ou avalia?",
        pensamento_sintese: "Pensamento de Síntese - sintetiza, resume histórias ou fatos...",
        pensamento_questionador: "Pensamento Questionador - propõe perguntas e busca respondê-las?",
        pensamento_sistemico: "Pensamento Sistêmico - considera vários elementos e os relaciona?",
        compreende_ordens_simples: "Compreende Ordens Simples? Ex.: Sentar, levantar, sair, entrar.",
        compreende_ordens_complexas: "Compreende Ordens Complexas? Ex.: Transmitir um recado à alguém.",
        relata_situacoes: "Relata situações vividas por ele?"
    }
};
