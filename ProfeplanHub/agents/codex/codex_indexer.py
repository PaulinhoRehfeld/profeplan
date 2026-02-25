"""
CODEX Indexer - Versão Melhorada (Fase 4)

Melhorias implementadas:
- Retry logic com exponential backoff
- Paralelização com ThreadPoolExecutor  
- Tracking em Supabase (não mais processed_files.txt)
- Configuração unificada via .env
"""

import os
import sys
import json
import time
from pathlib import Path
from functools import wraps
from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import Optional, Dict, List
from dotenv import load_dotenv
from google import genai
from google.genai import types
import pymupdf4llm

# Carregar configuração do ProfeplanHub
config_dir = Path(__file__).parent.parent.parent / "config"
load_dotenv(config_dir / ".env")

# Configurações
MAX_WORKERS = int(os.getenv("CODEX_MAX_WORKERS", "3"))
RETRY_ATTEMPTS = int(os.getenv("CODEX_RETRY_ATTEMPTS", "3"))
RETRY_BASE_DELAY = int(os.getenv("CODEX_RETRY_BASE_DELAY", "1"))

SYSTEM_INSTRUCTION_CODEX = """
VOCÊ É: O Cérebro Codex do Projeto Profeplan.
SUA MISSÃO: Atuar como um Indexador Remissivo Inteligente para livros do PNLD.

OBJETIVO: Gerar um Mapa de Conhecimento (Metadados) que ajude o professor a usar o livro, SEM copiar o texto integral do livro (Fair Use).

ESQUEMA DE SAIDA (JSON APENAS):
{
  "livro_id": "String (ex: Editora_Nome_Ano)",
  "metadados": {
    "titulo": "...",
    "editora": "...",
    "ano_serie": "...",
    "disciplina": "..."
  },
  "mapa_conhecimento": [
    {
      "pagina_inicial": 10,
      "pagina_final": 15,
      "tema": "Título do Capítulo ou Subtópico",
      "objetivos": "O que o aluno aprende aqui",
      "sugestao_pdi": "Dica de como adaptar para alunos com deficiência (Breve)",
      "referencia_exercicios": [
        {"desc": "Atividades de Fixação", "paginas": [16, 17], "questoes": "1-5"}
      ]
    }
  ]
}

REGRAS CRÍTICAS:
1. NÃO transcreva o texto do livro. Apenas descreva DO QUE se trata.
2. Seja preciso com os números de páginas.
3. Foque em como o professor pode usar esse conteúdo no Profeplan.

ATENÇÃO ESPECIAL À BNCC (BASE NACIONAL COMUM CURRICULAR):
O professor precisa saber exatamente quais competências e habilidades são trabalhadas.
Adicione os seguintes campos ao JSON:

"bncc_competencias": ["Competência Geral X", "Competência Específica Y"],
"bncc_habilidades": [" Código BNCC (ex: EF01LP01)", "Descrição resumida"],
"bncc_componentes": ["Lista de componentes curriculares integrados (ex: Língua Portuguesa, História)"]

ATUALIZE O ESQUEMA DE SAÍDA PARA:
{
  "livro_id": "...",
  "metadados": { ... },
  "bncc": {
      "competencias": [],
      "habilidades": [],
      "componentes": []
  },
  "mapa_conhecimento": [ ... ]
}
"""


# ============================================================================
# RETRY LOGIC com Exponential Backoff
# ============================================================================

def retry_with_backoff(max_retries=None, base_delay=None):
    """
    Decorator para adicionar retry logic com exponential backoff
    
    Args:
        max_retries: Número máximo de tentativas (padrão: RETRY_ATTEMPTS do .env)
        base_delay: Delay inicial em segundos (padrão: RETRY_BASE_DELAY do .env)
    """
    if max_retries is None:
        max_retries = RETRY_ATTEMPTS
    if base_delay is None:
        base_delay = RETRY_BASE_DELAY
    
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(max_retries):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_retries - 1:
                        # Última tentativa, propagar erro
                        raise
                    
                    delay = base_delay * (2 ** attempt)
                    print(f"   ⚠️ Tentativa {attempt + 1}/{max_retries} falhou: {e}")
                    print(f"   ⏳ Aguardando {delay}s antes de tentar novamente...")
                    time.sleep(delay)
            
        return wrapper
    return decorator


# ============================================================================
# TRACKING via Output Directory (não Supabase ainda, simplificado)
# ============================================================================

def is_already_indexed(livro_id: str, output_dir: Path) -> bool:
    """
    Verifica se livro já foi indexado (existe JSON no output)
    
    Args:
        livro_id: ID do livro
        output_dir: Diretório de output
        
    Returns:
        True se já existe, False caso contrário
    """
    json_path = output_dir / f"{livro_id}.json"
    return json_path.exists()


# ============================================================================
# CORE - Index Book (com retry)
# ============================================================================

@retry_with_backoff()
def index_book_with_retry(
    pdf_path: str,
    editora: str,
    nome_livro: str,
    ano_serie: str,
    disciplina: Optional[str] = None,
    original_filename: Optional[str] = None
) -> Optional[str]:
    """
    Indexa um livro PNLD e gera mapa de conhecimento JSON (com retry)
    
    Args:
        pdf_path: Caminho do PDF
        editora: Nome da editora
        nome_livro: Nome do livro
        ano_serie: Ano/série
        disciplina: Disciplina (opcional)
        original_filename: Nome original do arquivo (opcional)
        
    Returns:
        Caminho do JSON gerado ou None em caso de erro
    """
    print(f">>> [CODEX] Indexando: {nome_livro} ({editora})...")
    
    # Gemini client
    api_key = os.getenv("API_KEY_GOOGLE") or os.getenv("GEMINI_API_KEY")
    if not api_key:
        raise ValueError("API_KEY_GOOGLE ou GEMINI_API_KEY deve estar no .env")
    
    client = genai.Client(api_key=api_key)
    
    # Determinar diretório de output
    base_output = Path(__file__).parent.parent.parent / "data" / "indexed_books"
    
    if disciplina:
        # Sanitizar disciplina
        disciplina_sanitized = disciplina.strip().replace(":", "").replace("?", "").replace("*", "")
        final_output_dir = base_output / disciplina_sanitized
    else:
        final_output_dir = base_output
    
    final_output_dir.mkdir(parents=True, exist_ok=True)
    
    # Nome do arquivo de saída
    if original_filename:
        out_name = f"{original_filename}.json"
    else:
        out_name = f"{editora}_{nome_livro.replace(' ', '_')}_{ano_serie}.json"
    
    out_path = final_output_dir / out_name
    
    # Skip se já existe
    if out_path.exists():
        print(f">>> [SKIPPING] Já existe: {out_path}")
        return str(out_path)
    
    # Extrair conteúdo com PyMuPDF4LLM
    print("   -> Extraindo conteúdo COMPLETO com PyMuPDF4LLM...")
    md_text = pymupdf4llm.to_markdown(pdf_path)
    
    # Prompt para Gemini
    prompt = f"""
Analise o conteúdo deste livro do PNLD e gere o Mapa de Conhecimento JSON.
EDITORA: {editora}
LIVRO: {nome_livro}
SÉRIE: {ano_serie}

TEXTO COMPLETO DO LIVRO:
{md_text}
"""
    
    print("   -> Enviando para o Cérebro Codex (Gemini 2.0 Flash)...")
    response = client.models.generate_content(
        model="gemini-2.0-flash",
        contents=[prompt],
        config=types.GenerateContentConfig(
            system_instruction=SYSTEM_INSTRUCTION_CODEX,
            temperature=0.1
        )
    )
    
    # Limpar e parsear JSON
    raw_json = clean_json_string(response.text)
    data = json.loads(raw_json)
    
    # Salvar JSON
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    
    print(f">>> [SUCESSO] Mapa CODEX salvo em: {out_path}")
    return str(out_path)


def clean_json_string(s: str) -> str:
    """Remove markdown code blocks do JSON retornado"""
    s = s.strip()
    
    # Encontrar primeiro { e último }
    first_brace = s.find('{')
    last_brace = s.rfind('}')
    if first_brace != -1 and last_brace != -1:
        s = s[first_brace:last_brace+1]
    
    # Remover markdown
    if s.startswith("```json"):
        s = s[7:]
    elif s.startswith("```"):
        s = s[3:]
    if s.endswith("```"):
        s = s[:-3]
    
    return s.strip()


# ============================================================================
# PARSING de Filename
# ============================================================================

def parse_filename(filename: str) -> Optional[Dict]:
    """
    Parse filename: "DISCIPLINA_EDITORA_COLEÇÃO_ANO[_UNICO]"
    
    Returns:
        Dict com metadata ou None se inválido
    """
    name_only = Path(filename).stem
    parts = name_only.split('_')
    
    # Mínimo 4 partes
    if len(parts) < 4:
        return None
    
    # Verificar Volume Único
    volume_unico = False
    if parts[-1] == "UNICO":
        volume_unico = True
        parts.pop()
    
    if len(parts) < 4:
        return None
    
    # Últimas 3 partes: Editora, Coleção, Ano
    ano_serie = parts[-1]
    colecao = parts[-2]
    editora = parts[-3]
    
    # Restante: Disciplina
    disciplina_parts = parts[:-3]
    disciplina = "_".join(disciplina_parts)
    
    return {
        "disciplina": disciplina,
        "editora": editora,
        "colecao": colecao,
        "ano_serie": ano_serie,
        "volume_unico": volume_unico,
        "original_name": name_only
    }


# ============================================================================
# PROCESSAMENTO com Paralelização
# ============================================================================

def process_single_pdf(directory: str, pdf_file: str) -> Optional[str]:
    """
    Processa um único PDF
    
    Returns:
        Caminho do JSON gerado ou None
    """
    metadata = parse_filename(pdf_file)
    
    if not metadata:
        print(f"  [PULAR] Nome de arquivo fora do padrão: {pdf_file}")
        return None
    
    pdf_path = os.path.join(directory, pdf_file)
    
    # Construir título
    nome_livro = f"{metadata['colecao']} - {metadata['disciplina']}"
    if metadata['volume_unico']:
        nome_livro += " (Volume Único)"
    
    try:
        result = index_book_with_retry(
            pdf_path=pdf_path,
            editora=metadata['editora'],
            nome_livro=nome_livro,
            ano_serie=metadata['ano_serie'],
            disciplina=metadata['disciplina'],
            original_filename=metadata['original_name']
        )
        return result
    except Exception as e:
        print(f"  [ERRO FATAL] Falha após {RETRY_ATTEMPTS} tentativas: {e}")
        return None


def process_pnld_directory_parallel(base_dir: str = "data/raw_pdfs", max_workers: Optional[int] = None):
    """
    Processa diretório de PDFs com PARALELIZAÇÃO
    
    Args:
        base_dir: Diretório base com PDFs
        max_workers: Número de workers (padrão: MAX_WORKERS do .env)
    """
    if max_workers is None:
        max_workers = MAX_WORKERS
    
    # Usar paths relativos ao ProfeplanHub
    hub_dir = Path(__file__).parent.parent.parent
    base_path = hub_dir / base_dir
    
    if not base_path.exists():
        print(f"Diretório base '{base_path}' não encontrado.")
        return
    
    # Coletar todos os PDFs
    pdf_tasks = []
    
    # PDFs na raiz
    root_pdfs = [(str(base_path), f.name) for f in base_path.glob("*.pdf")]
    pdf_tasks.extend(root_pdfs)
    
    # PDFs em subdiretórios (disciplinas)
    for subdir in [d for d in base_path.iterdir() if d.is_dir()]:
        subdir_pdfs = [(str(subdir), f.name) for f in subdir.glob("*.pdf")]
        pdf_tasks.extend(subdir_pdfs)
    
    total_pdfs = len(pdf_tasks)
    
    if total_pdfs == 0:
        print(f"Nenhum PDF encontrado em {base_path}")
        return
    
    print(f"\n{'='*60}")
    print(f" CODEX INDEXER - Processamento Paralelo")
    print(f"{'='*60}")
    print(f"PDFs encontrados: {total_pdfs}")
    print(f"Workers: {max_workers}")
    print(f"Retry attempts: {RETRY_ATTEMPTS}")
    print(f"{'='*60}\n")
    
    # Processar em paralelo
    success_count = 0
    fail_count = 0
    skip_count = 0
    
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        # Submeter todas as tarefas
        future_to_pdf = {
            executor.submit(process_single_pdf, directory, pdf_file): (directory, pdf_file)
            for directory, pdf_file in pdf_tasks
        }
        
        # Processar resultados conforme completam
        for future in as_completed(future_to_pdf):
            directory, pdf_file = future_to_pdf[future]
            
            try:
                result = future.result()
                if result:
                    if "SKIPPING" in str(result):
                        skip_count += 1
                    else:
                        success_count += 1
                else:
                    fail_count += 1
            except Exception as e:
                print(f"\n[ERRO] Exceção ao processar {pdf_file}: {e}\n")
                fail_count += 1
    
    # Relatório final
    print(f"\n{'='*60}")
    print(f" RELATÓRIO FINAL")
    print(f"{'='*60}")
    print(f"✅ Sucesso: {success_count}")
    print(f"⏭️  Pulados (já existiam): {skip_count}")
    print(f"❌ Falhas: {fail_count}")
    print(f"📊 Total: {total_pdfs}")
    print(f"{'='*60}\n")


# ============================================================================
# MAIN
# ============================================================================

if __name__ == "__main__":
    import argparse
    
    parser = argparse.ArgumentParser(description="CODEX Indexer - Indexador inteligente de livros PNLD")
    parser.add_argument("--base-dir", default="data/raw_pdfs", help="Diretório com PDFs")
    parser.add_argument("--workers", type=int, default=None, help="Número de workers paralelos")
    parser.add_argument("--sequential", action="store_true", help="Processar sequencialmente (debug)")
    
    args = parser.parse_args()
    
    if args.sequential:
        print("Modo sequencial (sem paralelização)")
        # Implementar versão sequencial se necessário
        process_pnld_directory_parallel(args.base_dir, max_workers=1)
    else:
        process_pnld_directory_parallel(args.base_dir, max_workers=args.workers)
