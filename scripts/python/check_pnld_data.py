from supabase import create_client

SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def check_pnld():
    res = supabase.table("pnld_livros_conteudo").select("metadata").limit(200).execute()
    disciplines = set()
    books = set()
    for item in res.data:
        meta = item.get('metadata') or {}
        disciplines.add(meta.get('disciplina'))
        books.add(meta.get('livro_titulo'))
    
    print(f"Disciplinas no PNLD: {disciplines}")
    print(f"Livros no PNLD: {books}")

if __name__ == "__main__":
    check_pnld()
