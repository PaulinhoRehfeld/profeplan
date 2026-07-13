/**
 * PlanningOrchestrator - Orquestra o fluxo de planejamento trimestral.
 * Fase 1 da refatoração (ARCHITECTURE-PROFEPLAN).
 *
 * Garante: quota → geração → persistência (opcional) → event → crédito
 */
import { creditManager } from '../credit';
import { eventBus } from './EventBus';
import { generateTermPlan } from '../ai/AiPlanningService';
import type { PlanningIntent } from '../PlanningAuthorityService'; // type-only: no circular

export interface PlanningOrchestratorResult {
  text: string;
  intent: PlanningIntent;
}

export interface PlanningContext extends PlanningIntent {}

/**
 * Gera plano trimestral com créditos e EventBus centralizados.
 */
export async function executeTermPlanning(intent: PlanningIntent): Promise<string> {
  const userId = intent.userId;
  if (!userId) {
    throw new Error('userId é obrigatório para geração de plano.');
  }

  return creditManager.executeWithCreditCheck(
    userId,
    async () => {
      const text = await generateTermPlan(
        {
          subject: intent.subject,
          grade: intent.grade,
          period: intent.period,
          regime: intent.regime,
          stateBase: intent.stateBase,
          educationSphere: intent.educationSphere,
          teacherName: intent.teacherName,
          totalClasses: intent.totalClasses,
          reserves: intent.reserves,
          userId: intent.userId,
          level: intent.level,
          feedback: intent.feedback,
          pnld_book_id: intent.pnld_book_id,
          gradingGrid: intent.gradingGrid,
          userSettings: intent.userSettings,
        },
        { skipCredits: true }
      );

      eventBus.publish('planning:generated', {
        userId,
        text,
        subject: intent.subject,
        grade: intent.grade,
        period: intent.period,
      } as PlanningGeneratedPayload);

      return text;
    },
    'term_plan'
  );
}

export interface PlanningGeneratedPayload {
  userId: string;
  text: string;
  subject: string;
  grade: string;
  period: number;
}

/** Classe alternativa (compatível com docs de arquitetura) */
export class PlanningOrchestrator {
  static async generateTermPlan(intent: PlanningIntent): Promise<string> {
    return executeTermPlanning(intent);
  }
}
