"""
Script de População da Tabela pnld_livros
Escaneia diretório de PDFs e popula metadados no Supabase
"""

from supabase import create_client
from pathlib import Path
import sys
import os

# Importa o parser
sys.path.append(os.path.dirname(os.path.abspath(__file__)))
from parse_book_metadata import PnldBookMetadataParser

# Configurações
SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
metadata_parser = PnldBookMetadataParser()  # ✅ Renomeado para evitar conflito

def scan_pdf_directory(directory: str):
    """Escaneia diretório recursivamente por PDFs"""
    pdf_files = []
    path = Path(directory)
    
    if not path.exists():
        print(f"❌ Diretório não existe: {directory}")
        return []
    
    # Busca recursiva
    for pdf_path in path.rglob('*.pdf'):
        pdf_files.append(pdf_path)
    
    for pdf_path in path.rglob('*.PDF'):
        pdf_files.append(pdf_path)
    
    return pdf_files

def populate_pnld_livros(pdf_directory: str, dry_run: bool = True):
    """
    Popula tabela pnld_livros com metadados dos PDFs
    
    Args:
        pdf_directory: Caminho para diretório com PDFs
        dry_run: If True, apenas simula (não insere no banco)
    """
    print("🚀 POPULAÇÃO DA TABELA pnld_livros\n")
    print(f"📂 Diretório: {pdf_directory}")
    print(f"🔍 Modo: {'DRY RUN (simulação)' if dry_run else 'PRODUÇÃO (vai inserir)'}\n")
    
    # Escanear PDFs
    pdf_files = scan_pdf_directory(pdf_directory)
    print(f"✅ Encontrados {len(pdf_files)} arquivos PDF\n")
    
    if len(pdf_files) == 0:
        print("⚠️ Nenhum PDF encontrado. Verifique o caminho.")
        return
    
    # Processar cada PDF
    inserted = 0
    skipped = 0
    errors = []
    
    for pdf_path in pdf_files:
        filename = pdf_path.name
        
        # Parse metadados do nome
        metadata = metadata_parser.parse_filename(filename)  # ✅ Usando metadata_parser
        
        if not metadata:
            skipped += 1
            errors.append(f"Parse falhou: {filename}")
            continue
        
        # Preparar payload
        payload = {
            'titulo': metadata['titulo'],
            'disciplina': metadata['disciplina'],
            'editora': metadata['editora'],
            'colecao': metadata['colecao'],
            'ano_serie': metadata['ano_serie'],
            'nivel_ensino': metadata['nivel_ensino'],
            'volume': metadata['volume'],
            'arquivo_origem': filename,
        }
        
        if dry_run:
            print(f"✓ {payload['titulo']}")
            inserted += 1
        else:
            try:
                supabase.table('pnld_livros').insert(payload).execute()
                print(f"✅ {payload['titulo']}")
                inserted += 1
            except Exception as e:
                skipped += 1
                errors.append(f"{filename}: {str(e)}")
                print(f"❌ {filename} - {e}")
    
    # Resumo
    print(f"\n{'='*60}")
    print(f"📊 RESUMO")
    print(f"{'='*60}")
    print(f"✅ Inseridos: {inserted}")
    print(f"⚠️  Ignorados: {skipped}")
    
    if errors:
        print(f"\n❌ ERROS ({len(errors)}):")
        for err in errors[:10]:  # Mostra apenas primeiros 10
            print(f"  - {err}")
    
    if dry_run:
        print(f"\n💡 Para executar de verdade, rode com: --no-dry-run")

if __name__ == '__main__':
    import argparse
    
    parser = argparse.ArgumentParser(description='Popula tabela pnld_livros')
    parser.add_argument('--dir', type=str, default=r'C:\Users\Admin\PROFEPLANPDFS', 
                        help='Diretório com PDFs PNLD')
    parser.add_argument('--no-dry-run', action='store_true', 
                        help='Executar de verdade (inserir no banco)')
    
    args = parser.parse_args()
    
    populate_pnld_livros(args.dir, dry_run=not args.no_dry_run)
