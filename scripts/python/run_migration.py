from supabase import create_client
import os

SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

migration_file = r"c:\Users\Admin\PROFEPLAN\PROFEPLAN\supabase\migrations\20260203_create_pnld_livros_table.sql"

print(f"Executing migration: {migration_file}")

with open(migration_file, 'r', encoding='utf-8') as f:
    sql = f.read()

try:
    # We use rpc 'exec_sql' if it exists, but typically for migrations we might need 
    # to run chunks or use a specific runner. Supabase python client doesn't 
    # have a direct 'query' method for raw SQL for safety.
    # If exec_sql is not available, I'll have to rely on the table being created manually 
    # or find another way.
    res = supabase.post-grest.rpc('exec_sql', {'sql': sql}).execute()
    print("Migration executed successfully (via RPC).")
except Exception as e:
    print(f"Could not execute via RPC: {e}")
    print("Attempting to proceed anyway (table might already exist or need manual creation).")
