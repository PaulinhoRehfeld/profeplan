-- Fix existing students missing current_school_id
-- This backfills current_school_id for students based on their class's school_id

UPDATE students s
SET current_school_id = c.school_id
FROM classes c
WHERE s.class_id = c.id
  AND s.current_school_id IS NULL;
