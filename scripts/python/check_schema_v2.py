from supabase import create_client
import json

SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def check_schema():
    try:
        res = supabase.table("curriculos_mg").select("*").limit(1).execute()
        print(f"DEBUG: Status: {res.status_code if hasattr(res, 'status_code') else 'N/A'}")
        if res.data and len(res.data) > 0:
            print("DATA FOUND:")
            print(json.dumps(res.data[0], indent=2))
        else:
            print("NO DATA FOUND OR DATA IS EMPTY LIST")
            # Try to list all tables? Or just check if table exists
    except Exception as e:
        print(f"EXCEPTION: {e}")

if __name__ == "__main__":
    check_schema()
