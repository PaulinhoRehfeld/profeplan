from supabase import create_client

SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

rpc_sql = """
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
"""

def restore_rpc():
    # Use a dummy RPC to run raw SQL if available, or just use migrations
    # Since I don't have a raw SQL execution tool, I'll assume the user needs to run this
    # OR I can check if there's a way via postgrest. Usually not for DDL.
    print("Please run the following SQL in Supabase Dashboard to restore the search function:")
    print(rpc_sql)

if __name__ == "__main__":
    restore_rpc()
