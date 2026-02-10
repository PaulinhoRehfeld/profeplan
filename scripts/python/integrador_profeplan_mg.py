import google.generativeai as genai
from supabase import create_client
import json
import re
import time
import os
import glob
import argparse
import sys

# --- CONFIGURAÇÕES REAIS CONFIGURADAS ---
API_KEY_GOOGLE = "AIzaSyBpLzXwQaFFd0TuHIxZYP4X0eYdICYVJP4"
SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

# Inicialização das APIs
genai.configure(api_key=API_KEY_GOOGLE)
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def extrair_codigo(texto):
    """Extrai códigos de habilidades como (EM13CHS101) ou (EF01HI01)"""
    if not texto:
        return "CURRICULO_BASE"
    match = re.search(r'\(([A-Z]{2}\d+[A-Z\d]+)\)', texto)
    return match.group(1) if match else "CURRICULO_BASE"

def processar_arquivo(arquivo_path):
    print(f"📖 Lendo arquivo: {arquivo_path}")
    try:
        with open(arquivo_path, 'r', encoding='utf-8') as f:
            dados = json.load(f)
    except Exception as e:
        print(f"❌ Erro ao ler arquivo {arquivo_path}: {e}")
        return 0

    # Detecta o formato: lista simples ou pacote estruturado (conteudo_vetorial)
    registros = []
    disciplina_global = "Desconhecida"
    
    if isinstance(dados, list):
        registros = dados
    elif isinstance(dados, dict) and "conteudo_vetorial" in dados:
        registros = dados["conteudo_vetorial"]
        disciplina_global = dados.get("disciplina", "Desconhecida")
        print(f"📦 Formato estruturado detectado. Disciplina: {disciplina_global}")
    else:
        print(f"⚠️ Aviso: O arquivo {arquivo_path} não está em um formato reconhecido. Ignorando.")
        return 0

    if not registros:
        print(f"⚠️ Aviso: Nenhum registro encontrado em {arquivo_path}.")
        return 0

    print(f"🚀 Iniciando integração de {len(registros)} registros de {os.path.basename(arquivo_path)}...")
    
    sucessos = 0
    for i, item in enumerate(registros):
        try:
            # Extração de campos baseada no formato
            habilidade_raw = item.get('habilidade', item.get('texto_limpo', ''))
            disciplina = item.get('disciplina', disciplina_global)
            trimestre = item.get('trimestre', item.get('bimestre', item.get('capitulo', '')))
            
            codigo = extrair_codigo(habilidade_raw)
            
            # Texto pedagógico para embedding
            texto_pedagogico = (
                f"Disciplina: {disciplina} | "
                f"Trimestre: {trimestre} | "
                f"Contexto: {habilidade_raw} | "
                f"Objeto: {item.get('objeto_conhecimento', '')}"
            )

            # Gera o Embedding (Vetor)
            res = genai.embed_content(
                model="models/text-embedding-004",
                content=texto_pedagogico,
                task_type="retrieval_document"
            )

            payload = {
                "content": texto_pedagogico,
                "metadata": {
                    "disciplina": disciplina,
                    "trimestre": trimestre,
                    "unidade_tematica": item.get('unidade_tematica'),
                    "habilidade": habilidade_raw[:500], # Limita tamanho para metadata
                    "codigo_habilidade": codigo,
                    "objeto_conhecimento": item.get('objeto_conhecimento'),
                    "conteudos_relacionados": item.get('conteudos_relacionados'),
                    "arquivo_origem": os.path.basename(arquivo_path),
                    "pagina": item.get('pagina'),
                    "tags": item.get('tags'),
                    "ano_base": 2026
                },
                "embedding": res['embedding']
            }

            # Insere na tabela curriculo_mg (ou curriculos_mg dependendo do env)
            supabase.table("curriculos_mg").insert(payload).execute()
            
            print(f"✅ [{sucessos+1}/{len(registros)}] Integrado: {codigo} ({disciplina})")
            sucessos += 1
            
            # Pequena pausa para API
            time.sleep(1) 

        except Exception as e:
            print(f"⚠️ Erro ao processar item {i} do arquivo {arquivo_path}: {e}")
            time.sleep(5)

    return sucessos

def main():
    parser = argparse.ArgumentParser(description="Ingestor de Currículos para Supabase")
    parser.add_argument("--folder", type=str, default="CON_PDF_MD", help="Pasta contendo os arquivos JSON")
    args = parser.parse_args()

    target_dir = os.path.abspath(args.folder)
    
    if not os.path.exists(target_dir):
        print(f"❌ Diretório não encontrado: {target_dir}")
        current_dir_files = glob.glob("*.json")
        if current_dir_files:
             print(f"ℹ️ Encontrei arquivos JSON na pasta atual ({os.getcwd()}), usando-os como fallback.")
             arquivos = current_dir_files
        else:
             print("❌ Nenhum arquivo encontrado.")
             sys.exit(1)
    else:
        print(f"📂 Buscando arquivos JSON em: {target_dir}")
        arquivos = glob.glob(os.path.join(target_dir, "*.json"))

    if not arquivos:
        print("❌ Nenhum arquivo .json encontrado no diretório alvo.")
        return

    print(f"🎯 Encontrados {len(arquivos)} arquivos para processamento.")
    
    total_sucessos = 0
    for arquivo in arquivos:
        total_sucessos += processar_arquivo(arquivo)
        
    print(f"\n🏆 FINALIZADO! Total de {total_sucessos} registros integrados ao cérebro do PROFEPLAN.")

if __name__ == "__main__":
    main()