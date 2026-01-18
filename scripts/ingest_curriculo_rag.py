import os
import glob
import argparse
from langchain_text_splitters import MarkdownHeaderTextSplitter
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from supabase import create_client
from langchain_community.vectorstores import SupabaseVectorStore
from dotenv import load_dotenv

# Carrega variáveis de ambiente do arquivo .env na raiz do projeto
load_dotenv()

# CONFIGURAÇÃO DE AMBIENTE
# Caminho para os arquivos Markdown (Hardcoded conforme solicitado pelo usuário, mas seguro)
MD_PATH = r"C:\Users\Admin\PROFEPLANPDFS\PlanosMG\MD" 

# Resgate de variáveis com Fallback
SUPABASE_URL = os.getenv("VITE_SUPABASE_URL") or os.getenv("SUPABASE_URL")
# PRIORIDADE: Service Role (Escrita irrestrita) > Anon Key (Pode falhar por RLS)
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY") or os.getenv("VITE_SUPABASE_ANON_KEY")
GOOGLE_API_KEY = os.getenv("VITE_GEMINI_API_KEY") or os.getenv("GOOGLE_API_KEY")

def setup_client():
    if not SUPABASE_URL or not SUPABASE_KEY or not GOOGLE_API_KEY:
        print("❌ ERRO CRÍTICO: Variáveis de ambiente faltando.")
        print(f"   SUPABASE_URL: {'OK' if SUPABASE_URL else 'FALTANDO'}")
        print(f"   SUPABASE_KEY: {'OK' if SUPABASE_KEY else 'FALTANDO (Recomendado: SUPABASE_SERVICE_ROLE_KEY)'}")
        print(f"   GOOGLE_API_KEY: {'OK' if GOOGLE_API_KEY else 'FALTANDO'}")
        print("   Verifique seu arquivo .env")
        exit(1)
    
    return create_client(SUPABASE_URL, SUPABASE_KEY)

def processar_arquivos(should_truncate=False):
    supabase = setup_client()
    embeddings = GoogleGenerativeAIEmbeddings(model="models/text-embedding-004", google_api_key=GOOGLE_API_KEY)

    if not os.path.exists(MD_PATH):
        print(f"❌ Diretório não encontrado: {MD_PATH}")
        print("   Verifique se a pasta existe ou edite a variável MD_PATH no script.")
        return

    if should_truncate:
        print("🧹 Tentando limpar registros antigos (Flag --truncate)...")
        try:
             # Tenta deletar registros onde 'estado' é 'MG'. 
             # Nota: Se RLS estiver ativo e usar Anon Key, isso pode falhar.
             supabase.table("curriculos_mg").delete().eq("metadata->>estado", "MG").execute()
             print("✅ Limpeza concluída (registros filtrados por estado='MG').")
        except Exception as e:
            print(f"⚠️  Não foi possível limpar automaticamente: {e}")
            print("   Recomendação: Execute 'TRUNCATE TABLE curriculos_mg;' no SQL Editor do Supabase.")

    arquivos_md = glob.glob(os.path.join(MD_PATH, "*.md"))
    print(f"\n📂 Diretório: {MD_PATH}")
    print(f"📄 Arquivos encontrados: {len(arquivos_md)}")

    # Headers para split inteligente
    headers_to_split_on = [
        ("#", "disciplina"),
        ("##", "ano_escolar"),
        ("###", "periodo"), 
        ("####", "unidade_tematica"),
        ("#####", "objeto_conhecimento")
    ]
    
    splitter = MarkdownHeaderTextSplitter(headers_to_split_on=headers_to_split_on)

    total_chunks = 0
    total_files = 0

    for i, arquivo in enumerate(arquivos_md):
        nome_arquivo = os.path.basename(arquivo)
        print(f"\n[{i+1}/{len(arquivos_md)}] Processando: {nome_arquivo}...")

        try:
            with open(arquivo, 'r', encoding='utf-8') as f:
                conteudo = f.read()

            # 1. Chunking
            chunks = splitter.split_text(conteudo)
            
            if not chunks:
                print(f"   ⚠️  Nenhum chunk gerado para {nome_arquivo}. Verifique formatação (#).")
                continue

            # 2. Enriquecimento
            for doc in chunks:
                doc.metadata["source"] = nome_arquivo
                doc.metadata["estado"] = "MG"
                
                # Resgate seguro de metadados
                disc = doc.metadata.get('disciplina', 'Geral')
                ano = doc.metadata.get('ano_escolar', 'N/A')
                per = doc.metadata.get('periodo', 'Geral')
                unid = doc.metadata.get('unidade_tematica', '')
                obj = doc.metadata.get('objeto_conhecimento', '')

                # Limpeza básica do conteúdo
                conteudo_limpo = doc.page_content.replace('\n', ' ').strip()

                # Texto Rico para Embedding
                texto_rico = (
                    f"Disciplina: {disc}. Ano: {ano}. Período: {per}. "
                    f"Unidade: {unid}. Objeto: {obj}. "
                    f"Conteúdo: {conteudo_limpo}"
                )
                
                doc.page_content = texto_rico

            # 3. Upload (SupabaseVectorStore)
            if chunks:
                SupabaseVectorStore.from_documents(
                    documents=chunks,
                    embedding=embeddings,
                    client=supabase,
                    table_name="curriculos_mg",
                    query_name="match_curriculo_enem"
                )
                
                count = len(chunks)
                total_chunks += count
                total_files += 1
                print(f"   ✅ {count} vetores inseridos com sucesso.")

        except Exception as e:
            print(f"   ❌ Erro em {nome_arquivo}: {e}")

    print(f"\n🚀 PROCESSO CONCLUÍDO!")
    print(f"📊 Resumo: {total_files} arquivos processados, {total_chunks} vetores criados na base.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Ingestão de Currículos MG para Supabase RAG")
    parser.add_argument("--truncate", action="store_true", help="Tenta limpar a tabela antes de inserir")
    args = parser.parse_args()
    
    processar_arquivos(should_truncate=args.truncate)
