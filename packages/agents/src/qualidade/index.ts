// ============================================================================
// PROFEPLAN — Quality Module (barrel export)
// ============================================================================

export { QualityGatePipeline, BaseQualityGate } from './quality-gate-pipeline';
export type { GateResult, PipelineResult, GateSeverity } from './quality-gate-pipeline';
export { FormatValidatorAgent } from './format-validator';
export { BNCCValidatorAgent } from './bncc-validator';
export { PrivacyGuardAgent } from './privacy-guard';
export { HallucinationDetectorAgent } from './hallucination-detector';
export { ContentScorerAgent } from './content-scorer';
export { PDIGuardianAgent } from './pdi-guardian';
export { AntiPlagiarismScorerAgent } from './anti-plagiarism-scorer';
