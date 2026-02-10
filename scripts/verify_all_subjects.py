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

TEST_CASES = [
    {"disciplina": "Sociologia", "ano": "1º Ano EM", "periodo": "1º Trimestre"},
    {"disciplina": "Sociologia", "ano": "2º Ano EM", "periodo": "1º Trimestre"},
    {"disciplina": "História", "ano": "1º Ano EM", "periodo": "1º Trimestre"},
    {"disciplina": "Física", "ano": "3º Ano EM", "periodo": "1º Trimestre"},
    {"disciplina": "Matemática", "ano": "2º Ano EM", "periodo": "1º Trimestre"},
    {"disciplina": "Língua Portuguesa", "ano": "1º Ano EM", "periodo": "1º Trimestre"},
    {"disciplina": "Química", "ano": "3º Ano EM", "periodo": "1º Trimestre"},
    {"disciplina": "Biologia", "ano": "2º Ano EM", "periodo": "1º Trimestre"},
    # Add EF if restored? The restore script mostly saw EM files in JSONs.
]

def verify_all():
    print("--- Starting Comprehensive Data Verification ---")
    
    passed = 0
    failed = 0
    
    for case in TEST_CASES:
        disc = case['disciplina']
        ano = case['ano']
        per = case['periodo']
        
        query_text = f"Planejamento {disc} {ano} {per}"
        print(f"\n[TEST] Testing: {disc} - {ano}...")
        
        try:
            # Embed
            result = genai.embed_content(
                model="models/gemini-embedding-001",
                content=query_text,
                task_type="retrieval_query",
                output_dimensionality=768
            )
            embedding = result['embedding']
            
            # Search
            res = supabase.rpc("search_curriculum_rag", {
                "query_embedding": embedding,
                "match_threshold": 0.3, 
                "match_count": 3,
                "filter_disciplina": disc,
                "filter_ano": ano,
                "filter_periodo": per
            }).execute()
            
            if res.data and len(res.data) > 0:
                print(f"   [PASS] Found {len(res.data)} fragments.")
                passed += 1
            else:
                print(f"   [FAIL] No data found.")
                failed += 1
                
        except Exception as e:
            print(f"   [ERROR] {e}")
            failed += 1

    print(f"\n--- Verification Summary ---")
    print(f"Passed: {passed}")
    print(f"Failed: {failed}")
    
    if failed == 0:
        print("SUCCESS: All audited subjects are searchable!")
    else:
        print("WARNING: Some subjects are still missing or not searchable.")

if __name__ == "__main__":
    verify_all()
