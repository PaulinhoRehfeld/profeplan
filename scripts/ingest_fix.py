import os
import glob
from langchain_text_splitters import MarkdownHeaderTextSplitter
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from supabase import create_client
from langchain_community.vectorstores import SupabaseVectorStore
from dotenv import load_dotenv

load_dotenv()

# Manually point to the specific files we want to ingest
TARGET_FILES = [
    r"C:\Users\Admin\PROFEPLANPDFS\PlanosMG\MD\2ANO_EM_SOCIOLOGIA.md",
    r"C:\Users\Admin\PROFEPLANPDFS\PlanosMG\MD\1ANO_EM_SOCIOLOGIA.md"
]

SUPABASE_URL = os.getenv("VITE_SUPABASE_URL") or os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY") or os.getenv("VITE_SUPABASE_ANON_KEY")
GOOGLE_API_KEY = os.getenv("VITE_GEMINI_API_KEY") or os.getenv("GOOGLE_API_KEY")

def ingest_fix():
    print("--- Starting Targeted Ingestion Fix ---")
    supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
    embeddings = GoogleGenerativeAIEmbeddings(model="models/gemini-embedding-001", google_api_key=GOOGLE_API_KEY)

    headers_to_split_on = [
        ("#", "disciplina"),
        ("##", "ano_escolar"),
        ("###", "periodo"), 
    ]
    splitter = MarkdownHeaderTextSplitter(headers_to_split_on=headers_to_split_on)

    for arquivo in TARGET_FILES:
        if not os.path.exists(arquivo):
            print(f"❌ File not found: {arquivo}")
            continue

        nome_arquivo = os.path.basename(arquivo)
        print(f"Processing: {nome_arquivo}...")
        
        try:
            with open(arquivo, 'r', encoding='utf-8') as f:
                conteudo = f.read()

            chunks = splitter.split_text(conteudo)
            
            if not chunks:
                print(f"   ⚠️  No chunks generated for {nome_arquivo}.")
                continue

            for doc in chunks:
                doc.metadata["source"] = nome_arquivo
                doc.metadata["estado"] = "MG"
                
                # Manual metadata fix since we know exactly what these files are
                if "2ANO" in nome_arquivo:
                    doc.metadata["ano_escolar"] = "2º Ano EM"
                elif "1ANO" in nome_arquivo:
                    doc.metadata["ano_escolar"] = "1º Ano EM"
                
                doc.metadata["disciplina"] = "Sociologia"
                doc.metadata["periodo"] = "1º Trimestre" # Since we hardcoded the content for 1st tri

                # Rich content
                disciplina = doc.metadata["disciplina"]
                ano = doc.metadata["ano_escolar"]
                per = doc.metadata["periodo"]
                conteudo_limpo = doc.page_content.strip()

                texto_rico = (
                    f"Disciplina: {disciplina}. Ano: {ano}. Período: {per}.\n"
                    f"---\n"
                    f"{conteudo_limpo}"
                )
                doc.page_content = texto_rico

            # Upload
            if chunks:
                SupabaseVectorStore.from_documents(
                    documents=chunks,
                    embedding=embeddings,
                    client=supabase,
                    table_name="curriculos_mg",
                    query_name="match_curriculo_enem"
                )
                print(f"   ✅ {len(chunks)} vectors inserted for {nome_arquivo}.")

        except Exception as e:
            print(f"   ❌ Error: {e}")

if __name__ == "__main__":
    ingest_fix()
