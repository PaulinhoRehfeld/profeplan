-- Tabela para Turmas
create table if not exists public.classes (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users not null,
  name text not null, -- Ex: 1º Ano A
  subject text, -- Ex: Geografia
  grade_level text, -- Ex: Ensino Médio
  created_at timestamp with time zone default now()
);

-- Habilitar RLS para classes
alter table public.classes enable row level security;

create policy "Usuários podem ver as próprias turmas"
on public.classes for select
using (auth.uid() = user_id);

create policy "Usuários podem inserir as próprias turmas"
on public.classes for insert
with check (auth.uid() = user_id);

create policy "Usuários podem deletar as próprias turmas"
on public.classes for delete
using (auth.uid() = user_id);

-- Tabela para Alunos
create table if not exists public.students (
  id uuid default gen_random_uuid() primary key,
  class_id uuid references public.classes on delete cascade not null,
  name text not null,
  created_at timestamp with time zone default now()
);

-- Habilitar RLS para students
alter table public.students enable row level security;

-- Política para ver estudantes: baseada no dono da turma
create policy "Usuários podem ver alunos de suas turmas"
on public.students for select
using (
  exists (
    select 1 from public.classes
    where public.classes.id = public.students.class_id
    and public.classes.user_id = auth.uid()
  )
);

create policy "Usuários podem inserir alunos em suas turmas"
on public.students for insert
with check (
  exists (
    select 1 from public.classes
    where public.classes.id = class_id
    and public.classes.user_id = auth.uid()
  )
);

create policy "Usuários podem deletar alunos de suas turmas"
on public.students for delete
using (
  exists (
    select 1 from public.classes
    where public.classes.id = class_id
    and public.classes.user_id = auth.uid()
  )
);
