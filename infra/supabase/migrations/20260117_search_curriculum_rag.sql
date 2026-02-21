create or replace function search_curriculum_rag (
  query_embedding vector(768),
  match_threshold float default 0.5,
  match_count int default 5,
  filter_disciplina text default null,
  filter_ano text default null
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
    c.id,
    c.content,
    c.metadata,
    1 - (c.embedding <=> query_embedding) as similarity
  from
    curriculos_mg c
  where 1 - (c.embedding <=> query_embedding) > match_threshold
  and (filter_disciplina is null or c.metadata->>'disciplina' ilike '%' || filter_disciplina || '%')
  and (filter_ano is null or c.metadata->>'ano_escolar' ilike '%' || filter_ano || '%')
  order by
    c.embedding <=> query_embedding
  limit match_count;
end;
$$;
