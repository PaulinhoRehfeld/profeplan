"""
Análise de Dados - Comparação entre term_plans e generated_contents
Objetivo: Identificar duplicatas e dados a migrar
"""

from supabase import create_client
from datetime import datetime

SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def analyze_data():
    print("🔍 ANÁLISE DE DADOS - PLANEJAMENTOS TRIMESTRAIS\n")
    
    # 1. Contar term_plans
    print("📊 Contando registros em term_plans...")
    term_result = supabase.table('term_plans').select('*', count='exact').execute()
    term_count = term_result.count
    print(f"✅ term_plans: {term_count} registros")
    
    # 2. Contar generated_contents (type='trimestral')
    print("\n📊 Contando registros em generated_contents (type='trimestral')...")
    gen_result = supabase.table('generated_contents').select('*', count='exact').eq('type', 'trimestral').execute()
    gen_count = gen_result.count
    print(f"✅ generated_contents (trimestral): {gen_count} registros")
    
    # 3. Amostrar dados de cada fonte
    print("\n📝 Amostrando 5 registros de cada fonte...")
    
    print("\n--- TERM_PLANS (Estruturados) ---")
    term_sample = supabase.table('term_plans').select('id, subject, grade, period, regime, created_at').limit(5).order('created_at', desc=True).execute()
    
    if term_sample.data:
        for i, row in enumerate(term_sample.data, 1):
            print(f"{i}. {row.get('subject', 'N/A')} | {row.get('grade', 'N/A')} | {row.get('period', 'N/A')}º {row.get('regime', 'N/A')}")
    
    print("\n--- GENERATED_CONTENTS (Genéricos) ---")
    gen_sample = supabase.table('generated_contents').select('id, title, created_at').eq('type', 'trimestral').limit(5).order('created_at', desc=True).execute()
    
    if gen_sample.data:
        for i, row in enumerate(gen_sample.data, 1):
            print(f"{i}. {row.get('title', 'Sem título')[:60]}...")
    
    # 4. Identificar sobreposição temporal
    print("\n📅 Análise Temporal...")
    
    if term_sample.data and len(term_sample.data) > 0:
        latest_term = term_sample.data[0].get('created_at')
        print(f"Último term_plan: {latest_term}")
    
    if gen_sample.data and len(gen_sample.data) > 0:
        latest_gen = gen_sample.data[0].get('created_at')
        print(f"Último generated_content: {latest_gen}")
    
    # 5. Recomendação
    print("\n" + "="*60)
    print("📋 RECOMENDAÇÕES DE MIGRAÇÃO")
    print("="*60)
    
    if gen_count > 0:
        print(f"⚠️  Existem {gen_count} planejamentos em 'generated_contents'")
        print("    que podem estar duplicados ou precisam ser migrados.")
        print("\n✅ PRÓXIMO PASSO:")
        print("    1. Criar script de migração de dados")
        print("    2. Detectar duplicatas (mesmo user + subject + period)")
        print("    3. Migrar dados únicos de generated_contents → term_plans")
    else:
        print("✅ Não há dados em 'generated_contents' para migrar.")
        print("    Pode pular direto para refatoração do TermPlanningService.")
    
    if term_count == 0 and gen_count == 0:
        print("⚠️  ATENÇÃO: Ambas as tabelas estão vazias!")
        print("    Sistema está começando do zero.")

if __name__ == "__main__":
    try:
        analyze_data()
    except Exception as e:
        print(f"\n❌ ERRO: {e}")
