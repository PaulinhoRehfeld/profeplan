import google.generativeai as genai
from supabase import create_client
import json
import os
import glob
import argparse
import sys
import time

# --- CONFIGURAÇÕES ---
API_KEY_GOOGLE = "AIzaSyBpLzXwQaFFd0TuHIxZYP4X0eYdICYVJP4"
SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

# Inicialização
genai.configure(api_key=API_KEY_GOOGLE)
supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def processar_livro(arquivo_path):
    print(f"[LIVRO] Processando: {arquivo_path}")
    try:
        with open(arquivo_path, 'r', encoding='utf-8') as f:
            dados = json.load(f)
    except Exception as e:
        print(f"[ERRO] Erro ao ler arquivo {arquivo_path}: {e}")
        return 0

    if not isinstance(dados, dict) or "conteudo_vetorial" not in dados:
        print(f"[AVISO] Ignorando {os.path.basename(arquivo_path)}: Formato de livro não detectado.")
        return 0

    registros = dados["conteudo_vetorial"]
    disciplina = dados.get("disciplina", "Geral")
    # Tenta identificar o título do livro pelo nome do arquivo ou metadados
    titulo_livro = os.path.basename(arquivo_path).replace("update_packet_", "").replace(".json", "")
    
    print(f"[INFO] Ingerindo {len(registros)} fragmentos do livro '{titulo_livro}'...")
    
    sucessos = 0
    for i, item in enumerate(registros):
        try:
            conteudo_texto = item.get('texto_limpo', '').strip()
            if not conteudo_texto:
                print(f"[AVISO] Fragmento {i} sem texto. Pulando...")
                continue
            pagina = item.get('pagina', 'N/A')
            capitulo = item.get('capitulo', 'N/A')
            
            # Texto pedagógico rico para busca semântica
            texto_para_embedding = (
                f"Livro: {titulo_livro} | "
                f"Disciplina: {disciplina} | "
                f"Página: {pagina} | "
                f"Capítulo: {capitulo} | "
                f"Conteúdo: {conteudo_texto}"
            )

            # Gera o Embedding
            res = genai.embed_content(
                model="models/embedding-001",
                content=texto_para_embedding,
                task_type="retrieval_document"
            )

            payload = {
                "content": texto_para_embedding,
                "metadata": {
                    "livro_titulo": titulo_livro,
                    "disciplina": disciplina,
                    "pagina": pagina,
                    "capitulo": capitulo,
                    "tags": item.get('tags', []),
                    "tipo_item": "PNLD_LIVRO",
                    "arquivo_origem": os.path.basename(arquivo_path)
                },
                "embedding": res['embedding']
            }

            # Insere na tabela exclusiva de livros
            supabase.table("pnld_livros_conteudo").insert(payload).execute()
            
            if (sucessos + 1) % 10 == 0:
                print(f"[STATUS] Processados {sucessos+1}/{len(registros)}...")
            
            sucessos += 1
            time.sleep(0.5) # Pausa para evitar rate limit

        except Exception as e:
            print(f"[AVISO] Erro no fragmento {i}: {e}")
            time.sleep(2)

    print(f"[OK] Sucesso: {titulo_livro} ({sucessos} registros)")
    return sucessos

def main():
    parser = argparse.ArgumentParser(description="Ingestor de LIVROS PNLD para Supabase")
    parser.add_argument("--folder", type=str, default="ingest_data", help="Pasta com os JSONs")
    parser.add_argument("--file", type=str, help="Arquivo específico para processar")
    args = parser.parse_args()

    if args.file:
        processar_livro(args.file)
    else:
        target_dir = os.path.abspath(args.folder)
        arquivos = glob.glob(os.path.join(target_dir, "update_packet_*.json"))
        
        if not arquivos:
            print(f"[ERRO] Nenhum livro encontrado em {target_dir}")
            return

        total = 0
        for arquivo in arquivos:
            total += processar_livro(arquivo)
        
        print(f"\n[FIM] FINALIZADO! {total} fragmentos de livros no cérebro PNLD.")

if __name__ == "__main__":
    main()
