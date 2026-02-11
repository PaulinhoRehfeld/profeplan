from supabase import create_client

SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def test_exec_sql():
    try:
        # Just a simple select 1
        res = supabase.rpc("exec_sql", {"sql": "SELECT 1"}).execute()
        print("exec_sql EXISTS and works!")
        print(res.data)
    except Exception as e:
        print(f"exec_sql FAILED: {e}")

if __name__ == "__main__":
    test_exec_sql()
