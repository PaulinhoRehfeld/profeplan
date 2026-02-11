from supabase import create_client

SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def debug_curriculo():
    # Search for anything related to Educação Digital
    res = supabase.table("curriculos_mg").select("*").ilike("unidade_tematica", "%Educação Digital%").limit(10).execute()
    if not res.data:
        res = supabase.table("curriculos_mg").select("*").ilike("metadata->>disciplina", "%Educação Digital%").limit(10).execute()
        
    print(f"Encontrados {len(res.data)} registros.")
    for i, item in enumerate(res.data):
        meta = item.get('metadata') or {}
        print(f"--- Item {i+1} ---")
        print(f"Disciplina: {item.get('disciplina')} | Meta-Disc: {meta.get('disciplina')}")
        print(f"Ano: {meta.get('ano_escolar')} | Trimestre: {meta.get('periodo')} / {meta.get('trimestre')}")
        print(f"Unidade: {item.get('unidade_tematica')}")

if __name__ == "__main__":
    debug_curriculo()
