-- Add 'lessons' column to 'term_plans' table to store structured lesson data
ALTER TABLE term_plans 
ADD COLUMN IF NOT EXISTS lessons JSONB DEFAULT '[]'::JSONB;

-- Comment on column
COMMENT ON COLUMN term_plans.lessons IS 'Structured array of lessons generated for the term plan.';
