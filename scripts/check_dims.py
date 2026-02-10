import os
import google.generativeai as genai
from dotenv import load_dotenv

load_dotenv()

api_key = os.getenv("VITE_GEMINI_API_KEY") or os.getenv("GOOGLE_API_KEY")
genai.configure(api_key=api_key)

try:
    result = genai.embed_content(
        model="models/gemini-embedding-001",
        content="Hello world",
        task_type="retrieval_query"
    )
    # Support both list and dict return
    if isinstance(result, dict) and 'embedding' in result:
        emb = result['embedding']
    else:
        emb = result
        
    print(f"Model: models/gemini-embedding-001")
    print(f"Dimension: {len(emb)}")
    
except Exception as e:
    print(f"Error: {e}")
