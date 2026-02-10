"""
FASE 1 - Migração de Dados: generated_contents → term_plans
Move planejamentos trimestrais para tabela estruturada
"""

from supabase import create_client
from datetime import datetime
import re

SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def parse_title_metadata(title: str) -> dict:
    """
    Extrai metadados do título
    Formato: "Planejamento [PERIODO] - [DISCIPLINA] ([ANO])"
    """
    metadata = {
        'subject': 'Geral',
        'period': 1,
        'regime': 'Trimestre',
        'grade': '1º Ano',
        'level': 'Ensino Médio'
    }
    
    # Extrair período
    period_match = re.search(r'(\d+)º\s+(Trimestre|Bimestre)', title, re.IGNORECASE)
    if period_match:
        metadata['period'] = int(period_match.group(1))
        metadata['regime'] = period_match.group(2).title()
    
    # Extrair disciplina (entre - e ()
    subject_match = re.search(r'-\s*([^(]+)\s*\(', title)
    if subject_match:
        metadata['subject'] = subject_match.group(1).strip()
    
    # Extrair ano (dentro dos parênteses)
    grade_match = re.search(r'\(([^)]+)\)', title)
    if grade_match:
        grade_str = grade_match.group(1).strip()
        # Detectar se é número puro ou já formatado
        if re.match(r'^\d+$', grade_str):
            metadata['grade'] = f"{grade_str}º Ano"
        else:
            metadata['grade'] = grade_str
    
    return metadata

def migrate_planning_data(dry_run: bool = True):
    """
    Migra dados de generated_contents → term_plans
    """
    print("🚀 MIGRAÇÃO DE DADOS - generated_contents → term_plans\n")
    print(f"🔍 Modo: {'DRY RUN (simulação)' if dry_run else 'PRODUÇÃO (vai migrar)'}\n")
    
    # 1. Buscar dados de generated_contents
    print("📊 Buscando dados em generated_contents...")
    result = supabase.table('generated_contents').select('*').eq('type', 'trimestral').order('created_at', desc=True).execute()
    
    gen_plans = result.data
    print(f"✅ Encontrados {len(gen_plans)} planejamentos\n")
    
    if len(gen_plans) == 0:
        print("⚠️ Nenhum dado para migrar.")
        return
    
    # 2. Buscar dados já existentes em term_plans para detectar duplicatas
    print("🔍 Verificando duplicatas em term_plans...")
    existing = supabase.table('term_plans').select('user_id, subject, period, grade').execute()
    existing_keys = set()
    for row in existing.data:
        key = f"{row['user_id']}_{row['subject']}_{row['period']}_{row['grade']}"
        existing_keys.add(key)
    
    print(f"✅ {len(existing_keys)} registros já existem em term_plans\n")
    
    # 3. Processar cada plano
    migrated = 0
    skipped_duplicates = 0
    skipped_errors = 0
    
    for gen_plan in gen_plans:
        try:
            # Parse metadados do título
            metadata = parse_title_metadata(gen_plan.get('title', ''))
            
            # Criar chave de duplicata
            dup_key = f"{gen_plan['user_id']}_{metadata['subject']}_{metadata['period']}_{metadata['grade']}"
            
            if dup_key in existing_keys:
                skipped_duplicates += 1
                if dry_run:
                    print(f"⏭️  DUPLICATA: {gen_plan['title']}")
                continue
            
            # Preparar payload
            payload = {
                'user_id': gen_plan['user_id'],
                'title': gen_plan['title'],
                'content': gen_plan['content'],
                'subject': metadata['subject'],
                'grade': metadata['grade'],
                'period': metadata['period'],
                'regime': metadata['regime'],
                'level': metadata['level'],
                'created_at': gen_plan['created_at'],
                'updated_at': gen_plan['updated_at'] or gen_plan['created_at']
            }
            
            if dry_run:
                print(f"✓ {payload['subject']} | {payload['grade']} | {payload['period']}º {payload['regime']}")
                migrated += 1
            else:
                supabase.table('term_plans').insert(payload).execute()
                print(f"✅ {payload['subject']} | {payload['grade']} | {payload['period']}º {payload['regime']}")
                migrated += 1
        
        except Exception as e:
            skipped_errors += 1
            print(f"❌ Erro: {gen_plan.get('title', 'Sem título')} - {e}")
    
    # Resumo
    print(f"\n{'='*60}")
    print(f"📊 RESUMO")
    print(f"{'='*60}")
    print(f"✅ Migrados: {migrated}")
    print(f"⏭️  Duplicatas ignoradas: {skipped_duplicates}")
    print(f"❌ Erros: {skipped_errors}")
    
    if dry_run:
        print(f"\n💡 Para executar de verdade, rode com: --no-dry-run")
    else:
        print(f"\n✅ MIGRAÇÃO COMPLETA!")

if __name__ == '__main__':
    import argparse
    
    parser = argparse.ArgumentParser(description='Migra planejamentos trimestrais')
    parser.add_argument('--no-dry-run', action='store_true', help='Executar de verdade')
    
    args = parser.parse_args()
    
    migrate_planning_data(dry_run=not args.no_dry_run)
