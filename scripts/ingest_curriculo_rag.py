import os
import glob
from langchain_text_splitters import MarkdownHeaderTextSplitter
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from supabase import create_client
from langchain_community.vectorstores import SupabaseVectorStore
from dotenv import load_dotenv

# Carrega variáveis de ambiente do arquivo .env na raiz do projeto, se existir
load_dotenv()

# CONFIGURAÇÃO
MD_PATH = r"C:\Users\Admin\PROFEPLANPDFS\PlanosMG\MD"
SUPABASE_URL = os.getenv("VITE_SUPABASE_URL") # Adaptando para as vars do projeto Profeplan (Vite costuma ter prefixo VITE_)
if not SUPABASE_URL:
    SUPABASE_URL = os.getenv("SUPABASE_URL") # Fallback

# Tenta pegar a Key de Service Role (para escrita - ideal) ou Anon (pode falhar se RLS bloquear escrita)
# No ambiente do usuário, ele deve ter definido VITE_SUPABASE_ANON_KEY ou similar. 
# Para ingestão, o ideal é SERVICE_ROLE.
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY") 
if not SUPABASE_KEY:
    SUPABASE_KEY = os.getenv("VITE_SUPABASE_ANON_KEY")
    print("⚠️  AVISO: Usando VITE_SUPABASE_ANON_KEY. Se houver erro de permissão, configure SUPABASE_SERVICE_ROLE_KEY.")

GOOGLE_API_KEY = os.getenv("VITE_GEMINI_API_KEY")
if not GOOGLE_API_KEY:
    GOOGLE_API_KEY = os.getenv("GOOGLE_API_KEY")

if not SUPABASE_URL or not SUPABASE_KEY or not GOOGLE_API_KEY:
    print("❌ ERRO: Variáveis de ambiente (SUPABASE_URL, KEY, GOOGLE_API_KEY) não encontradas.")
    exit(1)

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
embeddings = GoogleGenerativeAIEmbeddings(model="models/text-embedding-004", google_api_key=GOOGLE_API_KEY)

def processar_arquivos():
    # Verifica se o diretório existe
    if not os.path.exists(MD_PATH):
        print(f"❌ Diretório não encontrado: {MD_PATH}")
        return

    arquivos_md = glob.glob(os.path.join(MD_PATH, "*.md"))
    
    # Configura o Splitter para entender a hierarquia do Markdown
    # Garante que a 'Habilidade' nunca se separe do 'Trimestre' e 'Ano'
    headers_to_split_on = [
        ("#", "disciplina"),
        ("##", "ano_escolar"),
        ("###", "periodo"), # Ex: 1º Trimestre
        ("####", "unidade_tematica"),
    ]
    
    markdown_splitter = MarkdownHeaderTextSplitter(headers_to_split_on=headers_to_split_on)

    print(f"📂 Encontrados {len(arquivos_md)} arquivos Markdown em {MD_PATH}")

    for arquivo in arquivos_md:
        try:
            with open(arquivo, 'r', encoding='utf-8') as f:
                conteudo = f.read()

            print(f"🔄 Processando: {os.path.basename(arquivo)}...")
            
            # 1. Cria os Chunks baseados na estrutura
            md_header_splits = markdown_splitter.split_text(conteudo)

            # 2. Refinamento dos Metadados e Conteúdo
            docs_para_inserir = []
            for doc in md_header_splits:
                # Adiciona metadados extras
                doc.metadata["source"] = os.path.basename(arquivo)
                doc.metadata["estado"] = "MG"
                
                # Normaliza chaves de metadados para garantir integridade
                disciplina = doc.metadata.get('disciplina', 'Geral')
                ano = doc.metadata.get('ano_escolar', 'Geral')
                periodo = doc.metadata.get('periodo', 'Geral')
                unidade = doc.metadata.get('unidade_tematica', '')

                # TRUQUE ANTI-ALUCINAÇÃO: Contexto explícito no corpo do texto vetorizado check
                conteudo_rico = f"Contexto: {disciplina}, {ano}, {periodo}. " \
                                f"Unidade: {unidade}. " \
                                f"Habilidade/Conteúdo: {doc.page_content}"
                
                # Atualiza o conteúdo do documento para o embedding ser mais preciso
                doc.page_content = conteudo_rico
                docs_para_inserir.append(doc)

            # 3. Inserção no Supabase
            if docs_para_inserir:
                SupabaseVectorStore.from_documents(
                    docs_para_inserir,
                    embeddings,
                    client=supabase,
                    table_name="curriculos_mg", # Tabela alvo
                    query_name="match_curriculo_enem" # Nome da função de busca associada (opcional na inserção, mas boa prática)
                )
                print(f"✅ Inseridos {len(docs_para_inserir)} chunks de {os.path.basename(arquivo)}")
                
        except Exception as e:
            print(f"❌ Erro ao processar {os.path.basename(arquivo)}: {e}")

if __name__ == "__main__":
    processar_arquivos()
