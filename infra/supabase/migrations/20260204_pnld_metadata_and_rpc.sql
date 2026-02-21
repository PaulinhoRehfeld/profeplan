-- Create table for book metadata (for selection UI)
create table if not exists pnld_livros (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  author text,
  discipline text,
  grade text,
  cover_url text,
  created_at timestamp with time zone default now()
);

-- Enable RLS
alter table pnld_livros enable row level security;

-- Open read access for authenticated users
create policy "Allow read for all authenticated users"
on pnld_livros
for select
to authenticated
using (true);

-- RPC for Semantic Search in PNLD Content
create or replace function search_pnld_content(
  query_embedding vector(768),
  match_threshold float,
  match_count int,
  filter_livro_titulo text default null,
  filter_disciplina text default null
)
returns table (
  id uuid,
  content text,
  metadata jsonb,
  similarity float
)
language plpgsql
as $$
begin
  return query
  select
    p.id,
    p.content,
    p.metadata,
    1 - (p.embedding <=> query_embedding) as similarity
  from pnld_livros_conteudo p
  where (1 - (p.embedding <=> query_embedding)) > match_threshold
    and (filter_livro_titulo is null or p.metadata->>'livro_titulo' = filter_livro_titulo)
    and (filter_disciplina is null or p.metadata->>'disciplina' = filter_disciplina)
  order by p.embedding <=> query_embedding
  limit match_count;
end;
$$;
