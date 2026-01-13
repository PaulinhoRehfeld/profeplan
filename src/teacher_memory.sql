-- Tabela para preferências do professor
create table if not exists public.profiles (
  id uuid references auth.users not null primary key,
  full_name text,
  preferred_tone text default 'formal', -- formal, lúdico, acadêmico
  subjects text[], -- disciplinas que leciona
  updated_at timestamp with time zone
);

-- Habilitar RLS (Row Level Security)
alter table public.profiles enable row level security;

-- Políticas de acesso para profiles
create policy "Usuários podem ver o próprio perfil"
on public.profiles for select
using (auth.uid() = id);

create policy "Usuários podem atualizar o próprio perfil"
on public.profiles for update
using (auth.uid() = id);

create policy "Usuários podem inserir o próprio perfil"
on public.profiles for insert
with check (auth.uid() = id);

-- Tabela para as aulas e apresentações (A Memória)
create table if not exists public.lessons (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users not null,
  topic text not null,
  content text, -- O plano de aula completo
  canva_json jsonb, -- A tabela de dados para o Canva
  created_at timestamp with time zone default now()
);

-- Habilitar RLS para lessons
alter table public.lessons enable row level security;

-- Políticas de acesso para lessons
create policy "Usuários podem ver as próprias aulas"
on public.lessons for select
using (auth.uid() = user_id);

create policy "Usuários podem inserir as próprias aulas"
on public.lessons for insert
with check (auth.uid() = user_id);

create policy "Usuários podem deletar as próprias aulas"
on public.lessons for delete
using (auth.uid() = user_id);
