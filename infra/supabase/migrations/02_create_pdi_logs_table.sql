-- Migration: Create PDI Logs table for reporting
-- FKs adicionadas condicionalmente para permitir execução do zero

CREATE TABLE IF NOT EXISTS pdi_logs (
  id uuid default uuid_generate_v4() primary key,
  student_id uuid NOT NULL,
  class_id   uuid NOT NULL,
  lesson_id  uuid,
  teacher_id uuid NOT NULL,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  content    text,
  status     text default 'validated'
);

-- Índices para queries de relatório
CREATE INDEX IF NOT EXISTS idx_pdi_logs_student_created ON pdi_logs(student_id, created_at);
CREATE INDEX IF NOT EXISTS idx_pdi_logs_teacher_created ON pdi_logs(teacher_id, created_at);

-- Adiciona FKs apenas se as tabelas referenciadas existirem
DO $$ BEGIN
  -- FK: students
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'students')
     AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'pdi_logs_student_id_fkey') THEN
    ALTER TABLE pdi_logs
    ADD CONSTRAINT pdi_logs_student_id_fkey
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE;
  END IF;

  -- FK: classes
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'classes')
     AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'pdi_logs_class_id_fkey') THEN
    ALTER TABLE pdi_logs
    ADD CONSTRAINT pdi_logs_class_id_fkey
    FOREIGN KEY (class_id) REFERENCES classes(id) ON DELETE CASCADE;
  END IF;

  -- FK: lessons
  IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = 'public' AND table_name = 'lessons')
     AND NOT EXISTS (SELECT 1 FROM information_schema.table_constraints WHERE constraint_name = 'pdi_logs_lesson_id_fkey') THEN
    ALTER TABLE pdi_logs
    ADD CONSTRAINT pdi_logs_lesson_id_fkey
    FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE SET NULL;
  END IF;
END $$;
