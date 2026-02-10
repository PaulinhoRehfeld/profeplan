import os
from supabase import create_client
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("VITE_SUPABASE_URL") or os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("VITE_SUPABASE_ANON_KEY") or os.getenv("SUPABASE_KEY")

if not SUPABASE_URL or not SUPABASE_KEY:
    print("Missing Supabase credentials")
    exit(0)

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

try:
    # count exact is slow, but usually fine for small table.
    res = supabase.table("curriculos_mg").select("*", count="exact").eq("metadata->>estado", "MG").execute()
    # Or just select count
    print(f"Total rows in curriculos_mg (MG): {res.count}")
except Exception as e:
    print(f"Error: {e}")
