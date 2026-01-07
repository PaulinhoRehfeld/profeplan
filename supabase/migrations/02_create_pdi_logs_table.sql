-- Migration: Create PDI Logs table for reporting

create table if not exists pdi_logs (
  id uuid default uuid_generate_v4() primary key,
  student_id uuid references students(id) on delete cascade not null,
  class_id uuid references classes(id) on delete cascade not null,
  lesson_id uuid references lessons(id) on delete set null,
  teacher_id uuid not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  content text, 
  status text default 'validated'
);

-- Index for faster reporting queries
create index if not exists idx_pdi_logs_student_created on pdi_logs(student_id, created_at);
create index if not exists idx_pdi_logs_teacher_created on pdi_logs(teacher_id, created_at);
