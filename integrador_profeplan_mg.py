import google.generativeai as genai
from supabase import create_client
import json
import re
import time
import os

# --- CONFIGURAÇÕES REAIS CONFIGURADAS ---
API_KEY_GOOGLE = "AIzaSyBpLzXwQaFFd0TuHIxZYP4X0eYdICYVJP4"
SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

# Inicialização das APIs
genai.configure(api_key=API_KEY_GOOGLE)
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def extrair_codigo(texto):
    """Extrai códigos de habilidades como (EM13CHS101) ou (EF01HI01)"""
    match = re.search(r'\(([A-Z]{2}\d+[A-Z\d]+)\)', texto)
    return match.group(1) if match else "CURRICULO_BASE"

def subir_plano_curriculo():
    arquivo_json = 'plano_curso_mg_estruturado.json'
    
    if not os.path.exists(arquivo_json):
        print(f"❌ Erro: O arquivo {arquivo_json} não foi encontrado na pasta.")
        return

    print(f"📖 Lendo planejamento estruturado de MG...")
    with open(arquivo_json, 'r', encoding='utf-8') as f:
        plano = json.load(f)

    print(f"🚀 Iniciando integração de {len(plano)} registros curriculares...")

    for i, item in enumerate(plano):
        codigo = extrair_codigo(item['habilidade'])
        
        # Criamos uma 'âncora semântica' para o casamento de dados
        # Isso permite que a IA cruze este plano com as questões do ENEM depois
        texto_pedagogico = (
            f"Disciplina: {item['disciplina']} | "
            f"Bimestre: {item['bimestre']} | "
            f"Habilidade: {item['habilidade']} | "
            f"Conteúdo: {item['objeto_conhecimento']}"
        )

        try:
            # Gera o Embedding (Vetor) da Habilidade
            res = genai.embed_content(
                model="models/text-embedding-004",
                content=texto_pedagogico,
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

            # Insere na tabela curriculos_mg
            supabase.table("curriculos_mg").insert(payload).execute()
            
            print(f"✅ [{i+1}/{len(plano)}] Integrado: {codigo} ({item['disciplina']})")
            
            # Pequena pausa para respeitar os limites da API gratuita
            time.sleep(1) 

        except Exception as e:
            print(f"⚠️ Erro ao processar item {i}: {e}")
            time.sleep(5) # Pausa maior em caso de erro

    print("\n🏆 FINALIZADO! O Plano de MG está no cérebro do PROFEPLAN.")

if __name__ == "__main__":
    subir_plano_curriculo()