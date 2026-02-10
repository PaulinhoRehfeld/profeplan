import google.generativeai as genai
import os
from dotenv import load_dotenv

load_dotenv()

api_key = os.getenv("VITE_GEMINI_API_KEY") or os.getenv("GOOGLE_API_KEY")
if not api_key:
    print("No API Key found")
    exit(1)

genai.configure(api_key=api_key)

print("Searching for embedding models...")
try:
    for m in genai.list_models():
        if 'embed' in m.name.lower():
            print(f"Found: {m.name} - Supported methods: {m.supported_generation_methods}")
except Exception as e:
    print(f"Error listing models: {e}")
