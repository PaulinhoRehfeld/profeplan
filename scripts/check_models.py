import os
import sys
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Try standard key first, then VITE specific key
api_key = os.getenv("GEMINI_API_KEY") or os.getenv("VITE_GEMINI_API_KEY")
if not api_key:
    # Try looking in .env directly if load_dotenv didn't work (absolute path)
    env_path = os.path.join(os.getcwd(), '.env')
    if os.path.exists(env_path):
        load_dotenv(env_path)
        api_key = os.getenv("GEMINI_API_KEY") or os.getenv("VITE_GEMINI_API_KEY")

if not api_key:
    print("Error: GEMINI_API_KEY or VITE_GEMINI_API_KEY not found in environment or .env file.")
    sys.exit(1)

print(f"Checking models with API key: {api_key[:4]}...{api_key[-4:]}")

try:
    # Try the newer google-genai SDK first (used by RLM)
    from google import genai
    print("Using google-genai SDK...")
    client = genai.Client(api_key=api_key)
    # The list_models method might be different in V2, usually it's client.models.list()
    # But let's check the documentation pattern or try common ones.
    # Ref: https://github.com/googleapis/python-genai
    models = list(client.models.list())
    print("\nAvailable Models (google-genai):")
    for m in models:
        # Assuming m has 'name' and 'display_name'
        if "generateContent" in m.supported_generation_methods:
             print(f"- {m.name} ({m.display_name})")
             
except ImportError:
    print("\ngoogle-genai SDK not found. Trying google-generativeai...")
    try:
        import google.generativeai as genai
        genai.configure(api_key=api_key)
        print("\nAvailable Models (google-generativeai):")
        for m in genai.list_models():
            if 'generateContent' in m.supported_generation_methods:
                print(f"- {m.name}: {m.description}")
    except ImportError:
        print("Error: Neither google-genai nor google-generativeai packages found.")
    except Exception as e:
        print(f"Error listing models with google-generativeai: {e}")

except Exception as e:
    print(f"Error with google-genai SDK: {e}")
    # Fallback just in case
    try:
        import google.generativeai as genai
        genai.configure(api_key=api_key)
        print("\nFallback: Available Models (google-generativeai):")
        for m in genai.list_models():
            if 'generateContent' in m.supported_generation_methods:
                print(f"- {m.name}")
    except Exception as inner_e:
        print(f"Fallback failed: {inner_e}")
