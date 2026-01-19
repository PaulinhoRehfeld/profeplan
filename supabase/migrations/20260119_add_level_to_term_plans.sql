-- Add 'level' column to term_plans if it doesn't exist
ALTER TABLE term_plans 
ADD COLUMN IF NOT EXISTS level text DEFAULT 'Ensino Médio';

-- Ensure generated_contents has 'type' column that supports 'trimestral'
-- (It is text usually, so it supports it, but good to verify policies if needed)
