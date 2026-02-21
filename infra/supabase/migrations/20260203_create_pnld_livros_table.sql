-- Create the table to store PNLD book content (distinct from general curriculum)
create table if not exists pnld_livros_conteudo (
  id uuid primary key default gen_random_uuid(),
  content text,
  metadata jsonb,
  embedding vector(768), -- Gemini text-embedding-004
  created_at timestamp with time zone default now()
);

-- Index for similarity search
create index if not exists pnld_livros_embedding_idx 
on pnld_livros_conteudo 
using ivfflat (embedding vector_cosine_ops)
with (lists = 100);

-- Enable RLS
alter table pnld_livros_conteudo enable row level security;

-- Open read access for authenticated users
create policy "Allow read for all authenticated users"
on pnld_livros_conteudo
for select
to authenticated
using (true);

-- Restrict write access to service role
create policy "Allow write for service role only"
on pnld_livros_conteudo
for all
using (auth.role() = 'service_role');
