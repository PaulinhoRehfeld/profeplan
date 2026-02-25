"""
Módulo helper para embeddings usando API REST do Gemini

Workaround temporário para issue do SDK google-generativeai v0.8.6
que não suporta text-embedding-004 na API v1beta.
"""

import os
import requests
from typing import List


def generate_embedding_rest(text: str, api_key: str = None) -> List[float]:
    """
    Gera embedding usando API REST direta do Gemini
    
    Args:
        text: Texto para gerar embedding
        api_key: Chave da API (usa .env se não fornecido)
    
    Returns:
        Lista de 768 floats (embedding)
    """
    if not api_key:
        api_key = os.getenv("API_KEY_GOOGLE") or os.getenv("GEMINI_API_KEY")
    
    if not api_key:
        raise ValueError("API key não encontrada")
    
    # API REST v1 (não v1beta!)
    url = "https://generativelanguage.googleapis.com/v1/models/text-embedding-004:embedContent"
    
    headers = {
        "Content-Type": "application/json",
    }
    
    payload = {
        "content": {
            "parts": [
                {"text": text}
            ]
        }
    }
    
    # Adicionar chave na URL (alternativa aos headers)
    url_with_key = f"{url}?key={api_key}"
    
    response = requests.post(url_with_key, json=payload, headers=headers)
    
    if response.status_code != 200:
        raise Exception(f"Erro na API: {response.status_code} - {response.text}")
    
    data = response.json()
    
    # Extrair embedding
    embedding = data.get("embedding", {}).get("values", [])
    
    if not embedding:
        raise Exception(f"Embedding vazio retornado: {data}")
    
    return embedding



if __name__ == "__main__":
    # Teste rápido
    from pathlib import Path
    from dotenv import load_dotenv
    
    # Carregar .env
    config_path = Path(__file__).parent.parent.parent / "config" / ".env"
    load_dotenv(config_path)
    
    print("Testando API REST de embeddings...")
    
    try:
        embedding = generate_embedding_rest("História do Brasil")
        print(f"✅ Embedding gerado: {len(embedding)} dimensões")
        print(f"   Primeiros 5 valores: {embedding[:5]}")
    except Exception as e:
        print(f"❌ Erro: {e}")

