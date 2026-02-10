from supabase import create_client

SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def debug_books():
    print("--- Tabela: pnld_livros ---")
    res_l = supabase.table("pnld_livros").select("*").execute()
    for l in res_l.data:
        print(f"Livro: {l.get('title')} | Disciplina: {l.get('discipline')}")

    print("\n--- Amostra: pnld_livros_conteudo ---")
    res_c = supabase.table("pnld_livros_conteudo").select("metadata").limit(10).execute()
    for c in res_c.data:
        print(f"Meta: {c.get('metadata')}")

if __name__ == "__main__":
    debug_books()
