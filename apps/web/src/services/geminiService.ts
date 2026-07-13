/**
 * @deprecated This file is deprecated. Please import from the appropriate module in src/services/ai/
 */

export {
  decode,
  decodeAudioData,
  executeWithFallback,
  getGenAIClient,
  GENERATION_MODELS,
  safetySettings,
} from './ai/AiCore';
export { generateProfePlanStream } from './ai/AiChatService';
export { generateAssessmentWithContext, gradeWrittenAnswer } from './ai/AiAssessmentService';
export { generatePresentationJSON } from './ai/AiPresentationService';
export { generateTermPlan, generateGeminiContent } from './ai/AiPlanningService';
export {
  generateBlock9Adaptation,
  generateBlock10Diagnosis,
  generateBlock11Report,
} from './pdi/PdiDocumentService';
export {
  extractHighSchoolContext,
  parseClassListFromText,
  generateCanvaData,
  speakPedagogicalText,
} from './ai/AiUtilityService';
export { generateStudentAdaptation } from './ai/AiPdiService';
