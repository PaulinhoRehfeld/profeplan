import argparse
import json
import os
import time
from pathlib import Path

try:
    from google import genai as genai
    GENAI_SDK = "google.genai"
except ImportError:  # Fallback for environments without google-genai installed
    import google.generativeai as genai
    GENAI_SDK = "google.generativeai"
from dotenv import load_dotenv
from supabase import create_client

from curriculum_utils import extrair_codigo

DEFAULT_EMBEDDING_MODEL = "models/text-embedding-004"
FALLBACK_EMBEDDING_MODEL = "models/embedding-001"


def load_env() -> None:
    env_path = Path(__file__).resolve().parents[2] / '.env'
    load_dotenv(dotenv_path=env_path)


def get_settings() -> dict:
    return {
        "api_key": os.getenv("GEMINI_API_KEY") or os.getenv("VITE_GEMINI_API_KEY") or "",
        "supabase_url": os.getenv("SUPABASE_URL") or os.getenv("VITE_SUPABASE_URL") or "",
        "supabase_key": os.getenv("SUPABASE_KEY") or os.getenv("VITE_SUPABASE_ANON_KEY") or "",
        "embedding_model": os.getenv("EMBEDDING_MODEL") or DEFAULT_EMBEDDING_MODEL,
    }


def init_clients(settings: dict):
    if not settings["supabase_url"]:
        raise ValueError("Missing SUPABASE_URL (check .env at project root)")

    if not settings["supabase_key"]:
        raise ValueError("Missing SUPABASE_KEY (check .env at project root)")

    if GENAI_SDK == "google.genai":
        client = genai.Client(api_key=settings["api_key"])
    else:
        genai.configure(api_key=settings["api_key"])
        client = None

    supabase = create_client(settings["supabase_url"], settings["supabase_key"])
    return supabase, client


def embed_text(text: str, model_name: str, client) -> dict:
    if GENAI_SDK == "google.genai":
        response = client.models.embed_content(
            model=model_name,
            contents=text,
            config={"task_type": "retrieval_document"}
        )

        embedding = None
        if hasattr(response, "embeddings") and response.embeddings:
            first = response.embeddings[0]
            if hasattr(first, "values"):
                embedding = first.values
            elif hasattr(first, "embedding"):
                embedding = first.embedding

        if embedding is None:
            raise ValueError("Embedding response missing values")

        return {"embedding": embedding}

    response = genai.embed_content(
        model=model_name,
        content=text,
        task_type="retrieval_document"
    )
    return response

def subir_curriculo(file_path: str, embedding_model: str, client):
    print("📖 Lendo JSON estruturado do Plano de MG...")
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            plano = json.load(f)
    except FileNotFoundError:
        print(f"❌ Erro: O arquivo '{file_path}' não foi encontrado.")
        return

    print(f"🚀 Processando {len(plano)} itens curriculares...")

    for item in plano:
        codigo = extrair_codigo(item['habilidade'])
        
        # Texto base para busca semântica (Casamento)
        texto_para_vetor = f"Disciplina: {item['disciplina']} | Habilidade: {item['habilidade']} | Conteúdo: {item['objeto_conhecimento']}"

        try:
            # Gerar vetor (Embedding)
            try:
                res = embed_text(texto_para_vetor, embedding_model, client)
            except Exception as embed_error:
                error_text = str(embed_error)
                if embedding_model == DEFAULT_EMBEDDING_MODEL and "not found" in error_text:
                    res = embed_text(texto_para_vetor, FALLBACK_EMBEDDING_MODEL, client)
                else:
                    raise embed_error

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


def main() -> None:
    parser = argparse.ArgumentParser(description="Integrador de curriculo MG")
    parser.add_argument(
        "--file",
        type=str,
        default="plano_curso_mg_estruturado.json",
        help="Arquivo JSON com o curriculo estruturado"
    )
    args = parser.parse_args()

    load_env()
    settings = get_settings()
    global supabase
    supabase, client = init_clients(settings)

    subir_curriculo(args.file, settings["embedding_model"], client)


if __name__ == "__main__":
    main()