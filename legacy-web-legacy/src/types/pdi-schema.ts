import { z } from 'zod';

// Enumeração padrão para os checklists de habilidades
export const SkillStatus = z.enum(["APRESENTA", "COM_AJUDA", "NAO_APRESENTA", "NAO_OBSERVADO"]);

export const PdiSchema = z.object({
    // Seções I a V: Dados Cadastrais e Clínicos
    institutional: z.object({
        school_name: z.string().optional(),
        school_inep: z.string().optional(),
        sre: z.string().optional(),
        city: z.string().optional()
    }).optional(),

    student_data: z.object({
        name: z.string().min(1, "Nome é obrigatório"),
        dob: z.string().optional(), // 'YYYY-MM-DD'
        age: z.number().optional(),
        school_year: z.string().optional(),
        class_name: z.string().optional(),
        shift: z.string().optional(),
        teacher_name: z.string().optional()
    }),

    clinical_health: z.object({
        diagnosis_cid: z.string().optional(),
        medical_updates: z.string().optional(),
        medication: z.string().optional(),
        therapies: z.string().optional(), // Fono, Psico, etc.
        functional_limitations: z.string().optional()
    }).optional(),

    // Seção VI - Aspectos Psicomotores
    psychomotor: z.object({
        body_schema: SkillStatus.optional(),             // Esquema corporal
        body_awareness: SkillStatus.optional(),          // Consciência corporal
        body_expression: SkillStatus.optional(),         // Expressão corporal
        body_image: SkillStatus.optional(),              // Imagem corporal
        hypertonic_tone: SkillStatus.optional(),         // Tônus Hipertônico
        hypotonic_tone: SkillStatus.optional(),          // Tônus Hipotônico
        gross_motor_coordination: SkillStatus.optional(),// Coordenação motora ampla
        fine_motor_coordination: SkillStatus.optional(), // Coordenação motora fina
        dynamic_balance: SkillStatus.optional(),         // Equilíbrio dinâmico
        static_balance: SkillStatus.optional(),          // Equilíbrio estático
        laterality: SkillStatus.optional(),              // Lateralidade
        gustatory_perception: SkillStatus.optional(),    // Percepção gustativa
        olfactory_perception: SkillStatus.optional(),    // Percepção olfativa
        tactile_perception: SkillStatus.optional(),      // Percepção tátil
        visual_perception: SkillStatus.optional(),       // Percepção visual
        posture: SkillStatus.optional()                  // Postura
    }).optional(),

    // Seção VII - Aspectos Pedagógicos/Cognitivos
    cognitive: z.object({
        // Memória
        memory_short_term: SkillStatus.optional(),       // Curto Prazo
        memory_long_term: SkillStatus.optional(),        // Longo Prazo
        memory_auditory: SkillStatus.optional(),         // Auditiva
        memory_visual: SkillStatus.optional(),           // Visual

        // Percepção
        perception_auditory: SkillStatus.optional(),     // Auditiva
        perception_body: SkillStatus.optional(),         // Corporal
        perception_spatial: SkillStatus.optional(),      // Espacial
        perception_tactile: SkillStatus.optional(),      // Tátil
        perception_temporal: SkillStatus.optional(),     // Temporal
        perception_visual_cognitive: SkillStatus.optional(), // Visual (Cognitiva)

        // Atenção
        attention_alert: SkillStatus.optional(),         // Alerta
        attention_alternating: SkillStatus.optional(),   // Alternada
        attention_selective: SkillStatus.optional(),     // Seletiva
        attention_sustained: SkillStatus.optional(),     // Sustentada

        // Raciocínio Lógico
        logic_abductive: SkillStatus.optional(),         // Abdutivo
        logic_deductive: SkillStatus.optional(),         // Dedutivo
        logic_intuitive: SkillStatus.optional(),         // Intuitivo

        // Pensamento
        thought_analytical: SkillStatus.optional(),      // Analítico
        thought_creative: SkillStatus.optional(),        // Criativo
        thought_critical: SkillStatus.optional(),        // Crítico
        thought_synthesis: SkillStatus.optional(),       // Síntese
        thought_questioning: SkillStatus.optional(),     // Questionador
        thought_systemic: SkillStatus.optional(),        // Sistêmico

        // Compreensão de Ordens
        orders_simple: SkillStatus.optional(),           // Simples
        orders_complex: SkillStatus.optional()           // Complexas
    }).optional(),

    // Seção VIII - Comunicação
    communication: z.object({
        verbal_expression: SkillStatus.optional(),
        non_verbal_expression: SkillStatus.optional(),
        understanding_verbal: SkillStatus.optional(),
        interaction_intent: SkillStatus.optional()
    }).optional(),

    // Seção X - Avaliação do Professor
    teacher_evaluations: z.array(z.object({
        bimester: z.enum(["1", "2", "3", "4"]),
        subject: z.string(), // Língua Portuguesa, Matemática, etc.
        autonomy_level: z.enum([
            "MUITO_SUPORTE",
            "POUCO_SUPORTE",
            "ALTA_COMPREENSAO",
            "POUCA_COMPREENSAO"
        ]),
        diagnosis: z.string() // Parecer descritivo
    })).optional() // Optional at start
});

export const PDI_SCHEMA = PdiSchema; // Alias for backward compatibility

export type PDIProfileData = z.infer<typeof PdiSchema>;
// Export as Value (for PDIAnswer.APRESENTA usage)
export const PDIAnswer = SkillStatus.enum;

// Export as Type (for variable typing)
export type PDIAnswer = z.infer<typeof SkillStatus>;

export const PDI_QUESTIONS = {
    psychomotor: {
        body_schema: "Esquema Corporal",
        body_awareness: "Consciência Corporal",
        body_expression: "Expressão Corporal",
        body_image: "Imagem Corporal",
        hypertonic_tone: "Tônus Hipertônico",
        hypotonic_tone: "Tônus Hipotônico",
        gross_motor_coordination: "Coordenação Motora Ampla",
        fine_motor_coordination: "Coordenação Motora Fina",
        dynamic_balance: "Equilíbrio Dinâmico",
        static_balance: "Equilíbrio Estático",
        laterality: "Lateralidade",
        gustatory_perception: "Percepção Gustativa",
        olfactory_perception: "Percepção Olfativa",
        tactile_perception: "Percepção Tátil",
        visual_perception: "Percepção Visual",
        posture: "Postura"
    },
    cognitive: {
        memory_short_term: "Memória de Curto Prazo",
        memory_long_term: "Memória de Longo Prazo",
        memory_auditory: "Memória Auditiva",
        memory_visual: "Memória Visual",
        perception_auditory: "Percepção Auditiva",
        perception_body: "Percepção Corporal",
        perception_spatial: "Percepção Espacial",
        perception_tactile: "Percepção Tátil",
        perception_temporal: "Percepção Temporal",
        perception_visual_cognitive: "Percepção Visual (Cognitiva)",
        attention_alert: "Atenção (Estado de Alerta)",
        attention_alternating: "Atenção Alternada",
        attention_selective: "Atenção Seletiva",
        attention_sustained: "Atenção Sustentada",
        logic_abductive: "Raciocínio Abdutivo",
        logic_deductive: "Raciocínio Dedutivo",
        logic_intuitive: "Raciocínio Intuitivo",
        thought_analytical: "Pensamento Analítico",
        thought_creative: "Pensamento Criativo",
        thought_critical: "Pensamento Crítico",
        thought_synthesis: "Capacidade de Síntese",
        thought_questioning: "Postura Questionadora",
        thought_systemic: "Pensamento Sistêmico",
        orders_simple: "Compreensão de Ordens Simples",
        orders_complex: "Compreensão de Ordens Complexas"
    }
};
