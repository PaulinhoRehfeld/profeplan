-- Phase 6 AI foundation: persist enriched TermPlan content returned by OpenAI.

ALTER TABLE "TermPlan"
  ADD COLUMN "aiEnhancedContent" JSONB,
  ADD COLUMN "aiEnhancedAt" TIMESTAMP(3),
  ADD COLUMN "aiModel" TEXT;
