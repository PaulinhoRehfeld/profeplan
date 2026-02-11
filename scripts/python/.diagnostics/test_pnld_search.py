import google.generativeai as genai
from supabase import create_client

API_KEY_GOOGLE = "AIzaSyBpLzXwQaFFd0TuHIxZYP4X0eYdICYVJP4"
SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

genai.configure(api_key=API_KEY_GOOGLE)
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def test_pnld_search():
    tema = "Segurança Digital e Privacidade"
    print(f"Buscando no Codex para: {tema}...")
    
    res = genai.embed_content(model="models/text-embedding-004", content=tema, task_type="retrieval_query")
    
    # RPC call
    livro_res = supabase.rpc('search_pnld_content', {
        'query_embedding': res['embedding'],
        'match_threshold': 0.1, 
        'match_count': 5,
        'filter_disciplina': 'Educação Digital',
        'filter_livro_titulo': None
    }).execute()
    
    if livro_res.data:
        print(f"Encontrados {len(livro_res.data)} fragmentos:")
        for f in livro_res.data:
            print(f"- {f.get('metadata').get('livro_titulo')} (Pág: {f.get('metadata').get('pagina')})")
    else:
        print("Nenhum fragmento encontrado.")

if __name__ == "__main__":
    test_pnld_search()
