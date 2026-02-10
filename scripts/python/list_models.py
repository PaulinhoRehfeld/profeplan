import google.generativeai as genai

API_KEY_GOOGLE = "AIzaSyBpLzXwQaFFd0TuHIxZYP4X0eYdICYVJP4"
genai.configure(api_key=API_KEY_GOOGLE)

print("Listing available models...")
for m in genai.list_models():
    if 'generateContent' in m.supported_generation_methods:
        print(f"- {m.name}")
