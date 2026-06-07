-- Phase 5 API foundation: align TermPlan with the tenant-scoped API contract.

-- Preserve the existing ownership relation while adopting the API naming.
ALTER TABLE "TermPlan" DROP CONSTRAINT IF EXISTS "TermPlan_teacherId_fkey";
DROP INDEX IF EXISTS "TermPlan_teacherId_idx";
ALTER TABLE "TermPlan" RENAME COLUMN "teacherId" TO "ownerId";

-- Move from the previous planning-specific shape to the official first resource.
ALTER TABLE "TermPlan" ADD COLUMN "year" INTEGER NOT NULL DEFAULT 2026;
ALTER TABLE "TermPlan" ADD COLUMN "termInt" INTEGER;
UPDATE "TermPlan"
SET "termInt" = CASE
  WHEN "term" ~ '^[0-9]+$' THEN "term"::INTEGER
  ELSE 1
END;
ALTER TABLE "TermPlan" DROP COLUMN "term";
ALTER TABLE "TermPlan" RENAME COLUMN "termInt" TO "term";
ALTER TABLE "TermPlan" ALTER COLUMN "term" SET NOT NULL;
ALTER TABLE "TermPlan" ALTER COLUMN "year" DROP DEFAULT;
ALTER TABLE "TermPlan" DROP COLUMN IF EXISTS "subject";
ALTER TABLE "TermPlan" DROP COLUMN IF EXISTS "gradeLevel";

CREATE INDEX "TermPlan_ownerId_idx" ON "TermPlan"("ownerId");
ALTER TABLE "TermPlan" ADD CONSTRAINT "TermPlan_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
