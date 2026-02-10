from supabase import create_client

SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def test_rag():
    try:
        # Mocking an embedding (list of 768 zeros)
        embedding = [0.0] * 768
        res = supabase.rpc("search_curriculum_rag", {
            "query_embedding": embedding,
            "match_threshold": 0.1,
            "match_count": 1,
            "filter_disciplina": "Arte",
            "filter_ano": "1º Ano",
            "filter_periodo": "1º Trimestre"
        }).execute()
        print("search_curriculum_rag WORKS!")
    except Exception as e:
        print(f"search_curriculum_rag FAILED: {e}")

if __name__ == "__main__":
    test_rag()
