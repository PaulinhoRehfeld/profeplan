import { z } from 'zod';

/**
 * Schema de validação para Planejamento Trimestral
 * Substitui validação manual e parsing de títulos
 */

export const RegimeEnum = z.enum(['Bimestre', 'Trimestre']);
export const PeriodEnum = z.number().int().min(1).max(4);
export const LevelEnum = z.enum(['Ensino Fundamental', 'Ensino Médio', 'EJA']);

export const GradingGridSchema = z.object({
    vistos: z.number().min(0).max(100).default(0),
    trabalhos: z.number().min(0).max(100).default(0),
    monthlyExam: z.number().min(0).max(100).default(0),
    termExam: z.number().min(0).max(100).default(0),
    others: z.number().min(0).max(100).default(0),
});

export const ReservesSchema = z.object({
    monthlyExam: z.boolean().default(false),
    termExam: z.boolean().default(false),
    recovery: z.boolean().default(false),
});

export const LessonSchema = z.object({
    title: z.string().min(1, 'Título da aula é obrigatório'),
    description: z.string().optional(),
    objectives: z.array(z.string()).optional(),
    bncc_codes: z.array(z.string()).optional(),
    duration: z.number().int().positive().default(1), // Número de aulas
});

/**
 * Schema completo do Planejamento Trimestral
 */
export const TermPlanSchema = z.object({
    // IDs e Metadados
    id: z.string().optional(), // UUID gerado no backend
    user_id: z.string().uuid('ID de usuário inválido').optional(),

    // Campos Obrigatórios
    subject: z.string().min(1, 'Disciplina é obrigatória'),
    grade: z.string().min(1, 'Ano/Série é obrigatório'),
    period: PeriodEnum,
    regime: RegimeEnum,
    level: LevelEnum,

    // Contexto Educacional
    stateBase: z.string().default('Geral'),
    educationSphere: z.string().default('Geral'),

    // Carga Horária
    workloadWeekly: z.number().int().min(1).max(20),
    totalClasses: z.number().int().min(1).max(200),
    reserves: ReservesSchema,

    // Avaliação
    gradingGrid: GradingGridSchema,

    // Conteúdo Gerado
    generatedText: z.string().min(100, 'Plano de aula deve ter conteúdo substancial'),
    lessons: z.array(LessonSchema).optional(),

    // PNLD (Opcional)
    pnld_book_id: z.string().optional(),

    // Timestamps
    created_at: z.string().datetime().optional(),
    updated_at: z.string().datetime().optional(),
});

export type TermPlan = z.infer<typeof TermPlanSchema>;
export type GradingGrid = z.infer<typeof GradingGridSchema>;
export type Reserves = z.infer<typeof ReservesSchema>;
export type Lesson = z.infer<typeof LessonSchema>;

/**
 * Schema para criação (campos mínimos necessários)
 */
export const CreateTermPlanSchema = TermPlanSchema.pick({
    subject: true,
    grade: true,
    period: true,
    regime: true,
    level: true,
    workloadWeekly: true,
    totalClasses: true,
}).extend({
    user_id: z.string().uuid(),
});

/**
 * Schema para atualização (todos campos opcionais)
 */
export const UpdateTermPlanSchema = TermPlanSchema.partial().required({
    id: true,
});

/**
 * Resultado de validação
 */
export interface ValidationResult {
    success: boolean;
    data?: TermPlan;
    errors?: z.ZodError;
}

/**
 * Valida metadados do plano ANTES de salvar
 * Evita parsing de título e garante integridade
 */
export const validatePlanMetadata = (plan: unknown): ValidationResult => {
    try {
        const validated = TermPlanSchema.parse(plan);
        return { success: true, data: validated };
    } catch (error) {
        if (error instanceof z.ZodError) {
            return { success: false, errors: error };
        }
        throw error;
    }
};

/**
 * Valida apenas campos de criação
 */
export const validateCreatePlan = (plan: unknown): ValidationResult => {
    try {
        const validated = CreateTermPlanSchema.parse(plan);
        return { success: true, data: validated as TermPlan };
    } catch (error) {
        if (error instanceof z.ZodError) {
            return { success: false, errors: error };
        }
        throw error;
    }
};
