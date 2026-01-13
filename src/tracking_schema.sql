-- Tabela para rastrear o progresso das aulas dentro de um planejamento macro
create table if not exists public.lesson_tracking (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users not null,
  term_plan_id text references public.term_plans(id) on delete cascade not null, -- Alterado para TEXT para compatibilidade
  lesson_index int not null, -- Número da aula (1, 2, 3...)
  status text check (status in ('pending', 'prepared', 'taught')) default 'prepared',
  saved_content_id uuid, -- Opcional: Link para o conteúdo gerado na tabela generated_contents
  updated_at timestamp with time zone default now(),
  
  unique(term_plan_id, lesson_index)
);

-- Política de Segurança (RLS)
alter table public.lesson_tracking enable row level security;

create policy "Users can view their own tracking"
  on public.lesson_tracking for select
  using (auth.uid() = user_id);

create policy "Users can insert/update their own tracking"
  on public.lesson_tracking for all
  using (auth.uid() = user_id);
