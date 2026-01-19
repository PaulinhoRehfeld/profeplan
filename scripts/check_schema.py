
import os
from supabase import create_client
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("VITE_SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

if not SUPABASE_URL or not SUPABASE_KEY:
    print("Error: Supabase credentials missing.")
    exit(1)

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

# SQL to add column if not exists
# Note: Supabase-py doesn't run raw DDL easily, but we can try via rpc if we had one 
# OR just rely on the fact that if this fails, we need to instruct user to run SQL.
# BUT, wait. 'term_plans' is likely a table created before. 
# Attempting to fetch one row to see columns is a safe check.

try:
    print("Checking 'term_plans' schema...")
    res = supabase.table('term_plans').select('*').limit(1).execute()
    # Note: select('*') usually returns all columns. 
    # If successful, we can inspect keys.
    if res.data and len(res.data) > 0:
        keys = res.data[0].keys()
        if 'level' not in keys:
            print("MISSING COLUMN: 'level'. Requesting migration...")
            # We can't auto-migrate easily without SQL access. 
            # I will generate the migration SQL file for the user (or myself) to apply via UI or other means.
            # But wait, I can try to simply use the 'generated_contents' as the main persistence 
            # if 'term_plans' fails. 
            # However, logic tries both.
            
            # Let's create a SQL file that acts as the fix.
        else:
            print("Column 'level' exists.")
    else:
        print("Table empty or not found. Assuming we need migration.")

except Exception as e:
    print(f"Error checking DB: {e}")
