import os
import google.generativeai as genai
from supabase import create_client
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("VITE_SUPABASE_URL") or os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("VITE_SUPABASE_ANON_KEY") or os.getenv("SUPABASE_KEY")
GOOGLE_API_KEY = os.getenv("VITE_GEMINI_API_KEY") or os.getenv("GOOGLE_API_KEY")

if not SUPABASE_URL or not SUPABASE_KEY:
    print("Skipping test: Missing Supabase credentials")
    exit(0)

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
if GOOGLE_API_KEY:
    genai.configure(api_key=GOOGLE_API_KEY)

def test_history():
    print("--- Testing History (História) ---")
    query_text = "Planejamento História 1º Ano EM"
    
    try:
        # Embed
        result = genai.embed_content(
            model="models/gemini-embedding-001",
            content=query_text,
            task_type="retrieval_query",
            output_dimensionality=768
        )
        if isinstance(result, dict) and 'embedding' in result:
            embedding = result['embedding']
        else:
            embedding = result
        
        # Search
        res = supabase.rpc("search_curriculum_rag", {
            "query_embedding": embedding,
            "match_threshold": 0.3, 
            "match_count": 3,
            "filter_disciplina": "História",
            "filter_ano": "1º Ano EM",
            "filter_periodo": "1º Trimestre"
        }).execute()
        
        if res.data and len(res.data) > 0:
            print(f"✅ PASS: Found {len(res.data)} results for História.")
            for item in res.data:
                print(f"   - {item.get('content')[:50]}...")
        else:
            print(f"❌ FAIL: No data for História.")
            
    except Exception as e:
        print(f"ERROR: {e}")

if __name__ == "__main__":
    test_history()
