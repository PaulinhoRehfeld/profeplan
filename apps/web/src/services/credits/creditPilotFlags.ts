const GOVERNED_TERM_PLAN_SAVE_FLAG = 'VITE_GOVERNED_TERM_PLAN_SAVE';

/**
 * Lote 1.3B.3 pilot gate.
 *
 * Deliberately defaults to OFF. The governed term-plan path may only become
 * active after its database migrations are deployed through a separate,
 * explicitly governed cutover.
 */
export const isGovernedTermPlanSavePilotEnabled = (): boolean =>
  import.meta.env[GOVERNED_TERM_PLAN_SAVE_FLAG] === 'true';
