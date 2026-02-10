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
    # Tenta encontrar códigos como (EM13CHS101) ou (EF06HI01)
    match = re.search(r'\((E[MF]\d+[\w\d]+)\)', texto)
    return match.group(1) if match else "SEM_CODIGO"

def subir_curriculo():
    print("📖 Lendo JSON estruturado do Plano de MG...")
    with open('plano_curso_mg_estruturado.json', 'r', encoding='utf-8') as f:
        plano = json.load(f)

    print(f"🚀 Processando {len(plano)} itens curriculares...")

    for item in plano:
        codigo = extrair_codigo(item['habilidade'])
        
        # Texto para o "Cérebro" da busca entender o contexto
        texto_para_vetor = f"{item['disciplina']} | {item['bimestre']} | {item['unidade_tematica']} | {item['habilidade']}"

        try:
            # Gerar vetor para busca semântica
            res = genai.embed_content(
                model="models/text-embedding-004",
                content=texto_para_vetor,
                task_type="retrieval_document"
            )

            payload = {
                "ano": item['ano'],
                "serie": item['serie'],
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
            print(f"✅ Item {codigo} integrado.")
            time.sleep(0.5)

        except Exception as e:
            print(f"⚠️ Erro no item {codigo}: {e}")

    print("\n🏆 Casamento Preparado! Plano de MG disponível no Supabase.")

if __name__ == "__main__":
    subir_curriculo()