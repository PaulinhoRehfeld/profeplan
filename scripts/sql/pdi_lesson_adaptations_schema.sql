-- PDI LESSON ADAPTATIONS SCHEMA (Seção IX & Feedback Loop)

-- 1. Create table for Adaptations linked to Lessons
CREATE TABLE IF NOT EXISTS pdi_lesson_adaptations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  pdi_document_id UUID NOT NULL REFERENCES pdi_documents(id) ON DELETE CASCADE,
  
  -- Link to Lesson Context
  -- We store metadata because specific lesson concept is loose in text plans
  lesson_title TEXT,
  lesson_topic TEXT, 
  
  -- Teacher Context
  teacher_id UUID NOT NULL, 
  
  -- The Plan (Seção IX: Adequação Curricular)
  adaptation_goal TEXT,         -- O que adaptar? (Objetivo)
  adaptation_strategy TEXT,     -- Como adaptar? (Estratégia/Recurso)
  
  -- The Outcome (Feedback Loop)
  status TEXT CHECK (status IN ('PENDING', 'COMPLETED')) DEFAULT 'PENDING',
  achieved_status TEXT CHECK (achieved_status IN ('ALCANCADO', 'PARCIAL', 'NAO_ALCANCADO')),
  autonomy_level TEXT CHECK (autonomy_level IN ('TOTAL', 'PARCIAL', 'NENHUMA')),
  teacher_observation TEXT,
  
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Index for fast lookup by PDI or Teacher
CREATE INDEX IF NOT EXISTS idx_pdi_adaptations_doc ON pdi_lesson_adaptations(pdi_document_id);
CREATE INDEX IF NOT EXISTS idx_pdi_adaptations_teacher ON pdi_lesson_adaptations(teacher_id);

-- 3. RLS Policies
ALTER TABLE pdi_lesson_adaptations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Enable ALL access for authenticated users" ON pdi_lesson_adaptations;
CREATE POLICY "Enable ALL access for authenticated users" ON pdi_lesson_adaptations 
    FOR ALL 
    TO authenticated 
    USING (true) 
    WITH CHECK (true);
