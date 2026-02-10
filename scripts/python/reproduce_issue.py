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

def test_rag_real():
    print("--- Starting RAG Reproduction Test for Sociology 2nd Year ---")
    
    query_text = "Planejamento e Habilidades de Sociologia para 2º Ano EM no 1º Trimestre"
    
    # 1. Generate Embedding
    if GOOGLE_API_KEY:
        genai.configure(api_key=GOOGLE_API_KEY)
        # Correct usage for embedding
        result = genai.embed_content(
            model="models/gemini-embedding-001",
            content=query_text,
            task_type="retrieval_query",
            output_dimensionality=768
        )
        embedding = result['embedding']
    else:
        print("No Google API Key, cannot embed.")
        return

    # 2. Search
    try:
        res = supabase.rpc("search_curriculum_rag", {
            "query_embedding": embedding,
            "match_threshold": 0.3, 
            "match_count": 5,
            "filter_disciplina": "Sociologia",
            "filter_ano": "2º Ano EM",
            "filter_periodo": "1º Trimestre"
        }).execute()
        
        results = res.data
        
        print(f"Query: {query_text}")
        print(f"Results Found: {len(results)}")
        
        for i, doc in enumerate(results):
            print(f"\n[Result {i+1}]")
            print(f"Source: {doc.get('metadata', {}).get('source', 'N/A')}")
            # Snippet of content
            content = doc.get('content', '') or ''
            print(f"Content Preview: {content[:200]}...")
            
    except Exception as e:
        print(f"RPC FAILED: {e}")

if __name__ == "__main__":
    test_rag_real()
