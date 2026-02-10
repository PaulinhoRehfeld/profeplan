import os
import google.generativeai as genai
from dotenv import load_dotenv

load_dotenv()

api_key = os.getenv("VITE_GEMINI_API_KEY") or os.getenv("GOOGLE_API_KEY")
genai.configure(api_key=api_key)

try:
    # Try forcing dimensionality
    result = genai.embed_content(
        model="models/gemini-embedding-001",
        content="Hello world",
        task_type="retrieval_query",
        output_dimensionality=768
    )
    
    if isinstance(result, dict) and 'embedding' in result:
        emb = result['embedding']
    else:
        emb = result
        
    print(f"Model: models/gemini-embedding-001")
    print(f"Requested Dimension: 768")
    print(f"Actual Dimension: {len(emb)}")
    
except Exception as e:
    print(f"Error: {e}")
