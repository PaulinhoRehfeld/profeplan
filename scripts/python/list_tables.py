import os
from supabase import create_client
import json

# Setup Supabase client
SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def inspect_table():

    table = "term_plans"
    print(f"--------------------------------------------------")
    print(f"🔍 Inspecting Table: {table}")
    print(f"--------------------------------------------------")
    
    try:
        # Fetch 1 row to see keys
        res = supabase.table(table).select("*").limit(1).execute()
        if res.data:
            print("Columns found:")
            for key in res.data[0].keys():
                print(f"  - {key}")
            print(f"\nSample Data: {json.dumps(res.data[0], indent=2, default=str)}")
        else:
            print(f"Table '{table}' is empty, cannot infer columns. Trying generated_contents...")
            
            # Try generated_contents as fallback check
            res2 = supabase.table("generated_contents").select("*").limit(1).execute()
            if res2.data:
               print(f"\nGenerates_contents Columns:")
               for key in res2.data[0].keys():
                   print(f"  - {key}")
            else:
               print("generated_contents is also empty.")

    except Exception as e:
        print(f"❌ Error: {e}")


if __name__ == "__main__":
    inspect_table()
