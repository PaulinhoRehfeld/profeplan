from supabase import create_client

SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def check_schema():
    # Fetch one row to see all columns
    res = supabase.table("curriculos_mg").select("*").limit(1).execute()
    if res.data:
        print("Column names and first row sample:")
        for key in res.data[0].keys():
            print(f"- {key}")
        print(f"\nSample data: {res.data[0]}")
    else:
        print("No data found in curriculos_mg.")

if __name__ == "__main__":
    check_schema()
