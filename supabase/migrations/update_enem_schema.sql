-- 1. Enable Vector Extension
create extension if not exists vector;

-- 2. Add embedding column to enem_questions if it doesn't exist
alter table enem_questions 
add column if not exists embedding vector(768); -- 768 dimensions for Gemini text-embedding-004

-- 3. Create Index for faster search (Optional but recommended)
create index if not exists enem_questions_embedding_idx 
on enem_questions 
using ivfflat (embedding vector_cosine_ops)
with (lists = 100);

-- 4. Create the Hybrid Search Function
create or replace function buscar_questoes_profeplan(
  query_embedding vector(768),
  match_threshold float,
  match_count int,
  filtro_disciplina text default null,
  filtro_nivel text default null
)
returns setof enem_questions
language plpgsql
as $$
begin
  return query
  select *
  from enem_questions
  where 1 - (enem_questions.embedding <=> query_embedding) > match_threshold
  and (filtro_disciplina is null or enem_questions.component ilike '%' || filtro_disciplina || '%')
  -- Note: filtro_nivel logic can be added if your table has a specific column for it, usually 'area' acts as a high level filter
  order by enem_questions.embedding <=> query_embedding
  limit match_count;
end;
$$;
