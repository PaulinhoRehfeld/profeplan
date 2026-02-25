"""
Export PNLD Content to JSON Files
Exporta dados da tabela pnld_livros_conteudo para arquivos JSON
organizados por livro
"""

from supabase import create_client
from pathlib import Path
import json
from collections import defaultdict
from typing import Dict, List

SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)


def export_pnld_to_json(output_dir: str, limit: int = None):
    """
    Exporta conteúdo PNLD do Supabase para JSONs organizados por livro
    
    Args:
        output_dir: Diretório de saída
        limit: Limite de registros (None = todos)
    """
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)
    
    print("🚀 EXPORTAÇÃO PNLD → JSON\n")
    print(f"📂 Diretório: {output_dir}\n")
    
    # Buscar dados do Supabase
    print("📊 Buscando dados de pnld_livros_conteudo...")
    
    query = supabase.table('pnld_livros_conteudo').select('*')
    
    if limit:
        query = query.limit(limit)
        print(f"⚠️  LIMITE: {limit} registros")
    
    result = query.execute()
    fragmentos = result.data
    
    print(f"✅ {len(fragmentos)} fragmentos carregados\n")
    
    if len(fragmentos) == 0:
        print("⚠️ Nenhum dado encontrado.")
        return
    
    # Agrupar por livro
    print("📚 Agrupando por livro...")
    livros: Dict[str, List] = defaultdict(list)
    
    for frag in fragmentos:
        metadata = frag.get('metadata', {})
        livro_titulo = metadata.get('livro_titulo', 'Desconhecido')
        arquivo_origem = metadata.get('arquivo_origem', 'unknown.pdf')
        
        # Usar arquivo_origem como chave única
        livros[arquivo_origem].append(frag)
    
    print(f"✅ {len(livros)} livros distintos identificados\n")
    
    # Exportar cada livro
    print("💾 Exportando arquivos JSON...\n")
    exported = 0
    
    for arquivo_origem, fragmentos_livro in livros.items():
        try:
            # Pegar metadados do primeiro fragmento
            primeiro = fragmentos_livro[0]
            metadata_base = primeiro.get('metadata', {})
            
            # Criar estrutura JSON
            livro_json = {
                'metadata': {
                    'livro_titulo': metadata_base.get('livro_titulo', 'Título não especificado'),
                    'disciplina': metadata_base.get('disciplina', 'N/A'),
                    'editora': metadata_base.get('editora', 'N/A'),
                    'colecao': metadata_base.get('colecao', 'N/A'),
                    'arquivo_origem': arquivo_origem,
                    'total_fragmentos': len(fragmentos_livro)
                },
                'conteudo_vetorial': []
            }
            
            # Adicionar fragmentos
            for frag in fragmentos_livro:
                conteudo = frag.get('conteudo', '')
                metadata_frag = frag.get('metadata', {})
                
                livro_json['conteudo_vetorial'].append({
                    'pagina': metadata_frag.get('pagina', 'N/A'),
                    'capitulo': metadata_frag.get('capitulo', 'Sem capítulo'),
                    'texto_limpo': conteudo,
                    'embedding_id': frag.get('id')
                })
            
            # Salvar JSON
            # Normalizar nome do arquivo
            filename_safe = arquivo_origem.replace('.pdf', '').replace('.PDF', '')
            filename_safe = filename_safe.replace(' ', '_').replace('/', '_')
            json_path = output_path / f"{filename_safe}.json"
            
            with open(json_path, 'w', encoding='utf-8') as f:
                json.dump(livro_json, f, ensure_ascii=False, indent=2)
            
            print(f"✅ {livro_json['metadata']['livro_titulo'][:50]}... ({len(fragmentos_livro)} fragmentos)")
            exported += 1
            
        except Exception as e:
            print(f"❌ Erro ao exportar {arquivo_origem}: {e}")
    
    # Resumo
    print(f"\n{'='*60}")
    print(f"📊 RESUMO")
    print(f"{'='*60}")
    print(f"✅ JSONs criados: {exported}")
    print(f"📂 Localização: {output_path.absolute()}")
    
    print(f"\n💡 Próximo passo:")
    print(f"   python scripts/pnld/json_to_markdown.py --input {output_dir} --output {output_dir}/../markdown")


if __name__ == '__main__':
    import argparse
    
    parser = argparse.ArgumentParser(description='Exporta PNLD para JSON')
    parser.add_argument('--output', type=str, default='outputs/pnld_json',
                        help='Diretório de saída')
    parser.add_argument('--limit', type=int, default=None,
                        help='Limitar número de registros (para teste)')
    
    args = parser.parse_args()
    
    export_pnld_to_json(args.output, args.limit)
