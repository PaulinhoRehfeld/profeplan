from supabase import create_client

SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def analyze_db():
    res = supabase.table("curriculos_mg").select("disciplina, metadata").limit(100).execute()
    disciplines = set()
    for item in res.data:
        d = item.get('disciplina')
        if not d and item.get('metadata'):
            d = item['metadata'].get('disciplina')
        if d:
            disciplines.add(d)
    
    print(f"Total rows sampled: {len(res.data)}")
    print(f"Disciplines found: {disciplines}")

if __name__ == "__main__":
    analyze_db()
