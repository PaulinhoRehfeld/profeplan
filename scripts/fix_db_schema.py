import os
from supabase import create_client
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("VITE_SUPABASE_URL") or os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY") or os.getenv("VITE_SUPABASE_ANON_KEY")

if not SUPABASE_URL or not SUPABASE_KEY:
    print("❌ Erro: Credenciais do Supabase não encontradas.")
    exit(1)

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

# SQL commands to fix schema
sql_commands = [
    "alter table curriculos_mg add column if not exists content text;",
    "alter table curriculos_mg alter column metadata type jsonb using metadata::jsonb;"
]

print("🔧 Aplicando correções no Schema do Banco de Dados...")

for cmd in sql_commands:
    try:
        # Using rpc if available, or just implicit execution via client (Supabase-py client usually needs rpc for raw sql unless using postgrest which is structured)
        # But `supabase-py` doesn't support raw SQL directly easily without a function or being user postgres.
        # Actually, best way is to use the `rpc` if we had a `exec_sql` function. 
        # If not, we might fail if we can't run raw sql.
        # Let's try to check if we can simply skip this if the user runs the migration manually.
        # Wait, the user has `python` and I can try to use `psycopg2` if available OR if they have `postgres` connection string.
        # But I only have REST API keys likely.
        
        # PLAN B: Create a valid RPC to execute SQL if it doesn't exist? No, chicken and egg.
        # PLAN C: Just inform the user to run the SQL?
        # PLAN D: Check if there is a helper in the project.
        pass 
    except Exception as e:
        print(f"Erro: {e}")

# Actually, I can't run DDL (ALTER TABLE) via Supabase Client (REST) without a specific RPC.
# I will output the instructions clearly.
print("⚠️  ATENÇÃO: O cliente Python do Supabase (REST) não permite executar 'ALTER TABLE' diretamente.")
print("Por favor, execute o seguinte SQL no 'SQL Editor' do seu painel Supabase:")
print("-" * 30)
for cmd in sql_commands:
    print(cmd)
print("-" * 30)
