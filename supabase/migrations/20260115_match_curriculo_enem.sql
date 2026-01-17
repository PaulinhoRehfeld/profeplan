-- Create a function to match Curriculum items to ENEM questions using vector similarity
create or replace function match_curriculo_enem (
  curriculo_id uuid,
  match_threshold float default 0.7,
  match_count int default 5
)
returns table (
  id bigint,
  content text,
  metadata jsonb,
  similarity float
)
language plpgsql
as $$
declare
  query_embedding vector(768);
begin
  -- 1. Get the embedding for the selected curriculum item
  select embedding into query_embedding
  from curriculos_mg
  where id = curriculo_id;

  -- 2. Search for similar questions
  return query
  select
    qe.id,
    qe.content,
    qe.metadata,
    1 - (qe.embedding <=> query_embedding) as similarity
  from
    questoes_enem qe
  where 1 - (qe.embedding <=> query_embedding) > match_threshold
  order by
    qe.embedding <=> query_embedding
  limit match_count;
end;
$$;
