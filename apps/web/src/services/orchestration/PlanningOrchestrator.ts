/**
 * PlanningOrchestrator - Orquestra o fluxo de planejamento trimestral.
 * Fase 1 da refatoração (ARCHITECTURE-PROFEPLAN).
 *
 * Legacy path: quota → geração → event → crédito em profiles.credits.
 * Governed 1.3B.3 pilot: geração/regeneração é gratuita; a decisão econômica
 * ocorre somente no save canônico transacional do planejamento.
 */
import { creditManager } from '../credit';
import { eventBus } from './EventBus';
import { generateTermPlan } from '../ai/AiPlanningService';
import { isGovernedTermPlanSavePilotEnabled } from '../credits/creditPilotFlags';
import type { PlanningIntent } from '../PlanningAuthorityService'; // type-only: no circular

export interface PlanningOrchestratorResult {
  text: string;
  intent: PlanningIntent;
}

export interface PlanningContext extends PlanningIntent {}

const generateAndPublishTermPlan = async (intent: PlanningIntent): Promise<string> => {
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
    userId: intent.userId,
    text,
    subject: intent.subject,
    grade: intent.grade,
    period: intent.period,
  } as PlanningGeneratedPayload);

  return text;
};

/**
 * Gera plano trimestral.
 *
 * O piloto governado fica desligado por padrão. Quando ativado depois de um
 * cutover separado, geração e regeneração não debitam créditos; somente o save
 * canônico governado pode produzir decisão econômica.
 */
export async function executeTermPlanning(intent: PlanningIntent): Promise<string> {
  const userId = intent.userId;
  if (!userId) {
    throw new Error('userId é obrigatório para geração de plano.');
  }

  if (isGovernedTermPlanSavePilotEnabled()) {
    return generateAndPublishTermPlan(intent);
  }

  return creditManager.executeWithCreditCheck(
    userId,
    () => generateAndPublishTermPlan(intent),
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
