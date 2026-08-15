import { isGovernedCreditConsumerEnabled } from './creditConsumerFlags';

const GOVERNED_TERM_PLAN_SAVE_FLAG = 'VITE_GOVERNED_TERM_PLAN_SAVE';

/**
 * Term-plan governed-save gate.
 *
 * The original 1.3B.3 pilot flag remains supported for isolated rehearsal.
 * During the coordinated 1.3C.4E consumer cutover, however, the global
 * governed-consumer flag must also imply the governed TermPlan path. Otherwise
 * generation would become NON_BILLABLE while the corresponding Save remained
 * on the legacy direct-table path.
 *
 * Both flags deliberately default to OFF.
 */
export const isGovernedTermPlanSavePilotEnabled = (): boolean =>
  import.meta.env[GOVERNED_TERM_PLAN_SAVE_FLAG] === 'true' || isGovernedCreditConsumerEnabled();
