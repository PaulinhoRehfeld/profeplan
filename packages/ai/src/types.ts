export type TermPlanEnhancement = {
  summary: string;
  objectives: string[];
  suggestedSequence: string[];
  assessmentIdeas: string[];
  differentiationStrategies: string[];
  teacherNotes: string;
};

export type EnhanceTermPlanResult = {
  termPlanId: string;
  model: string;
  enhancedContent: TermPlanEnhancement;
};
