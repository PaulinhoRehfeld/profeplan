import os
from supabase import create_client
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("VITE_SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY") or os.getenv("VITE_SUPABASE_ANON_KEY")

if not SUPABASE_URL or not SUPABASE_KEY:
    print("Error: Supabase credentials missing.")
    exit(1)

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

sql = """
CREATE OR REPLACE FUNCTION get_ingested_files_manifest()
RETURNS TABLE (
  source_file text,
  disciplina text,
  ano_escolar text,
  total_chunks bigint
) 
LANGUAGE plpgsql
AS $$
BEGIN
  RETURN QUERY
  SELECT 
    (metadata->>'source')::text as source_file,
    (metadata->>'disciplina')::text as disciplina,
    (metadata->>'ano_escolar')::text as ano_escolar,
    COUNT(*) as total_chunks
  FROM curriculos_mg
  GROUP BY 
    metadata->>'source',
    metadata->>'disciplina',
    metadata->>'ano_escolar'
  ORDER BY 
    metadata->>'ano_escolar',
    metadata->>'disciplina';
END;
$$;
"""

try:
    # Supabase-py doesn't have a direct 'query' or 'rpc' for DDL easily exposed usually, 
    # but we can try rpc if we had a function to run sql. 
    # Actually, the python client is often limited for DDL.
    # However, if we have the postgres connection string we can use psycopg2, but we might not have it installed?
    # Let's check imports in the validation script.
    # Actually, the user has 'supabase' package.
    
    # HACK: If we can't run DDL via client, we might need to rely on the CLI 'db push' properly.
    # But let's try to use the CLI in a simpler way: `npx supabase migration new` then apply?
    # No, that's too complex.
    
    # Alternative: The user wanted "Action 2: Show files". 
    # Maybe I can just query the table directly in the frontend without the RPC?
    # "SELECT DISTINCT metadata->>source FROM curriculos_mg"
    # Yes, I can do that from the frontend if RLS allows.
    # But an RPC is cleaner.
    
    # Let's try to execute via an existing "exec_sql" function if it exists? No.
    
    # Let's try to use the CLI correctly this time: `npx supabase db push`.
    # But that requires a strict migration history.
    
    # Let's use the Python script to just INSPECT if we can.
    # Wait, I cannot execute DDL via supabase-js/py client directly unless I use a pre-existing `exec_sql` RPC or similar.
    # So I will fallback to implementing the Manifest logic CLIENT-SIDE first (Querying the table) 
    # OR assume I can just use `supabase db push` if the project is linked.
    
    print("Skipping DDL via Python as it is not standard. Will assume user can run migration or I use client-side query.")
    
except Exception as e:
    print(f"Error: {e}")
