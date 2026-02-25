#!/usr/bin/env python3
"""
Normalizer Pipeline - PNLD Book Processing
===========================================
Transforma PDFs de diferentes editoras em JSON padronizado Profeplan.
"""

import os
import sys
import json
import re
from pathlib import Path
from typing import Dict, List, Any
from dotenv import load_dotenv

# Carregar variáveis de ambiente
load_dotenv()

try:
    import google.generativeai as genai
    from supabase import create_client, Client
except ImportError:
    print("❌ Erro: Instale as dependências com: pip install -r requirements.txt")
    sys.exit(1)

# Configurações
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")

if not all([GEMINI_API_KEY, SUPABASE_URL, SUPABASE_KEY]):
    print("❌ Erro: Configure as variáveis de ambiente no .env")
    sys.exit(1)

# Inicializar clientes
genai.configure(api_key=GEMINI_API_KEY)
model = genai.GenerativeModel('gemini-2.0-flash-exp')
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)


class ISBNValidator:
    """Validador de números ISBN."""
    
    ISBN_PATTERN = re.compile(r'^\d{3}-?\d{2}-?\d{2}-?\d{5}-?\d{1}$|^\d{10}$')
    
    @classmethod
    def validate(cls, isbn: str) -> bool:
        """Valida formato de ISBN (10 ou 13 dígitos)."""
        if not isbn:
            return False
        clean_isbn = isbn.replace("-", "").replace(" ", "")
        return bool(cls.ISBN_PATTERN.match(clean_isbn))


def extract_metadata_from_pdf(pdf_path: str) -> Dict[str, Any]:
    """
    Extrai metadados estruturados do PDF usando Gemini.
    
    Args:
        pdf_path: Caminho para o PDF do livro
    
    Returns:
        Metadados estruturados do livro
    """
    print(f"📄 Processando PDF: {Path(pdf_path).name}")
    
    # Upload do arquivo para Gemini
    uploaded_file = genai.upload_file(pdf_path)
    
    # Prompt estruturado para extração
    prompt = """
Você é um bibliotecário especialista em livros didáticos brasileiros.

Analise esta CAPA e PRIMEIRAS PÁGINAS do livro didático e extraia os metadados em formato JSON:

{
  "titulo": "Título completo do livro",
  "isbn": "978-85-XX-XXXXX-X",
  "editora": "Nome da editora (FTD, Moderna, Ática, etc.)",
  "colecao": "Nome da coleção (se houver)",
  "disciplina": "Matemática, História, etc.",
  "ano_serie": "1º Ano EM, 6º Ano EF, etc.",
  "nivel_ensino": "Ensino Médio ou Ensino Fundamental",
  "volume": "Único, Volume 1, Volume 2, etc.",
  "tipo": "Professor ou Aluno",
  "autores": ["Nome do Autor 1", "Nome do Autor 2"]
}

REGRAS CRÍTICAS:
1. Se não encontrar o ISBN, deixe como null
2. Para ano_serie, use EXATAMENTE este padrão: "Xº Ano EM" ou "Xª Série EF"
3. Para nivel_ensino, use APENAS: "Ensino Médio" ou "Ensino Fundamental"
4. Para disciplina, normalize (ex: "Mat." → "Matemática")
5. NÃO invente informações. Se não encontrar, use null.

Retorne APENAS o JSON, sem explicações.
"""
    
    # Gerar resposta
    response = model.generate_content([uploaded_file, prompt])
    
    # Limpar resposta
    json_text = response.text.strip()
    if json_text.startswith("```json"):
        json_text = json_text.split("```json")[1].split("```")[0].strip()
    elif json_text.startswith("```"):
        json_text = json_text.split("```")[1].split("```")[0].strip()
    
    # Parse JSON
    try:
        data = json.loads(json_text)
    except json.JSONDecodeError as e:
        print(f"❌ Erro ao parsear JSON: {e}")
        print(f"Resposta bruta: {json_text[:500]}")
        return None
    
    return data


def normalize_metadata(raw_data: Dict[str, Any], filename: str) -> Dict[str, Any]:
    """
    Normaliza e valida os metadados extraídos.
    
    Args:
        raw_data: Dados brutos extraídos do PDF
        filename: Nome do arquivo original
    
    Returns:
        Metadados normalizados
    """
    print("🔧 Normalizando metadados...")
    
    # Validações
    isbn = raw_data.get("isbn")
    if isbn and not ISBNValidator.validate(isbn):
        print(f"⚠️ ISBN inválido detectado: {isbn} - Será marcado como null")
        isbn = None
    
    # Valores padrão
    normalized = {
        "titulo": raw_data.get("titulo", "Título Desconhecido"),
        "isbn": isbn,
        "editora": raw_data.get("editora"),
        "colecao": raw_data.get("colecao"),
        "disciplina": raw_data.get("disciplina", "Desconhecida"),
        "ano_serie": raw_data.get("ano_serie"),
        "nivel_ensino": raw_data.get("nivel_ensino"),
        "volume": raw_data.get("volume", "Único"),
        "tipo": raw_data.get("tipo", "Professor"),
        "autores": raw_data.get("autores", []),
        "arquivo_origem": filename,
        "status_processamento": "normalizado"
    }
    
    return normalized


def populate_supabase(metadata: Dict[str, Any]) -> bool:
    """
    Popula a tabela pnld_livros no Supabase.
    
    Args:
        metadata: Metadados normalizados
    
    Returns:
        True se inserção foi bem-sucedida
    """
    print("📤 Inserindo no Supabase...")
    
    try:
        # Verificar se já existe (baseado em ISBN ou título+editora)
        if metadata["isbn"]:
            existing = supabase.table("pnld_livros").select("id").eq("isbn", metadata["isbn"]).execute()
            if existing.data:
                print(f"⚠️ Livro já existe no banco (ISBN: {metadata['isbn']})")
                return False
        
        # Inserir
        supabase.table("pnld_livros").insert({
            "titulo": metadata["titulo"],
            "isbn": metadata["isbn"],
            "editora": metadata["editora"],
            "colecao": metadata["colecao"],
            "disciplina": metadata["disciplina"],
            "ano_serie": metadata["ano_serie"],
            "nivel_ensino": metadata["nivel_ensino"],
            "volume": metadata["volume"],
            "tipo": metadata["tipo"],
            "arquivo_origem": metadata["arquivo_origem"]
        }).execute()
        
        print(f"✅ Livro inserido: {metadata['titulo']}")
        return True
    
    except Exception as e:
        print(f"❌ Erro ao inserir: {e}")
        return False


def main():
    """Função principal do pipeline."""
    print("🛢️ INDÚSTRIA PNLD - Normalizer Pipeline")
    print("=" * 50)
    
    # Diretórios
    data_dir = Path(__file__).parent.parent / "data"
    raw_pdfs_dir = data_dir / "raw_pdfs"
    output_dir = data_dir / "normalized_json"
    
    # Criar diretórios se não existirem
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Buscar PDFs
    pdf_files = list(raw_pdfs_dir.glob("*.pdf"))
    
    if not pdf_files:
        print(f"❌ Nenhum PDF encontrado em {raw_pdfs_dir}")
        print("   Coloque os PDFs dos livros PNLD na pasta 'data/raw_pdfs/'")
        return
    
    print(f"📚 Encontrados {len(pdf_files)} PDFs para processar\n")
    
    processed = 0
    errors = 0
    
    for pdf_path in pdf_files:
        print(f"\n📌 Processando: {pdf_path.name}")
        print("-" * 50)
        
        # Passo 1: Extração
        raw_metadata = extract_metadata_from_pdf(str(pdf_path))
        
        if not raw_metadata:
            print(f"❌ Falha na extração de metadados")
            errors += 1
            continue
        
        # Passo 2: Normalização
        normalized_metadata = normalize_metadata(raw_metadata, pdf_path.name)
        
        # Passo 3: Salvar JSON
        output_file = output_dir / f"{pdf_path.stem}_metadata.json"
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(normalized_metadata, f, ensure_ascii=False, indent=2)
        
        print(f"💾 Metadados salvos em: {output_file.name}")
        
        # Passo 4: Ingestão no Supabase
        if populate_supabase(normalized_metadata):
            processed += 1
        else:
            errors += 1
    
    print("\n" + "=" * 50)
    print(f"✅ Pipeline concluído!")
    print(f"   Processados: {processed}")
    print(f"   Erros/Duplicados: {errors}")


if __name__ == "__main__":
    main()
