import google.generativeai as genai
from supabase import create_client
import json
import re
import time

# --- CONFIGURAÇÕES ---
API_KEY_GOOGLE = "SUA_CHAVE_GOOGLE_AQUI"
SUPABASE_URL = "SUA_URL_DO_SUPABASE_AQUI"
SUPABASE_KEY = "SUA_SERVICE_ROLE_KEY_AQUI"

genai.configure(api_key=API_KEY_GOOGLE)
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def extrair_codigo(texto):
    # Procura códigos como (EM13CHS101)
    match = re.search(r'\((E[MF]\d+[\w\d]+)\)', texto)
    return match.group(1) if match else "SEM_CODIGO"

def subir_curriculo():
    print("📖 Lendo JSON estruturado do Plano de MG...")
    try:
        with open('plano_curso_mg_estruturado.json', 'r', encoding='utf-8') as f:
            plano = json.load(f)
    except FileNotFoundError:
        print("❌ Erro: O arquivo 'plano_curso_mg_estruturado.json' não foi encontrado.")
        return

    print(f"🚀 Processando {len(plano)} itens curriculares...")

    for item in plano:
        codigo = extrair_codigo(item['habilidade'])
        
        # Texto base para busca semântica (Casamento)
        texto_para_vetor = f"Disciplina: {item['disciplina']} | Habilidade: {item['habilidade']} | Conteúdo: {item['objeto_conhecimento']}"

        try:
            # Gerar vetor (Embedding)
            res = genai.embed_content(
                model="models/text-embedding-004",
                content=texto_para_vetor,
                task_type="retrieval_document"
            )

            payload = {
                "disciplina": item['disciplina'],
                "bimestre": item['bimestre'],
                "unidade_tematica": item['unidade_tematica'],
                "habilidade": item['habilidade'],
                "codigo_habilidade": codigo,
                "objeto_conhecimento": item['objeto_conhecimento'],
                "conteudos_relacionados": item['conteudos_relacionados'],
                "embedding": res['embedding']
            }

            supabase.table("curriculos_mg").insert(payload).execute()
            print(f"✅ Habilidade {codigo} integrada ao Supabase.")
            time.sleep(1) # Pausa para evitar limite de cota

        except Exception as e:
            print(f"⚠️ Erro no item {codigo}: {e}")
            time.sleep(2)

    print("\n🏆 Sucesso! O currículo de MG está pronto para ser casado com as questões.")

if __name__ == "__main__":
    subir_curriculo()