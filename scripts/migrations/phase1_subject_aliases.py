"""
PHASE 1 - Migração: Criação da Tabela subject_aliases
Versão simplificada usando apenas insert direto (sem RPC)
"""

from supabase import create_client

# Configurações
SUPABASE_URL = "https://uatejrgmbzgoeayfascf.supabase.co"
SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVhdGVqcmdtYnpnb2VheWZhc2NmIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2NjUxNDYzOCwiZXhwIjoyMDgyMDkwNjM4fQ.eN6j9GnE_7rKqM5QS1hJyAznUPT0l5taSVAq8tBhrLE"

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def populate_subject_aliases():
    """Popula a tabela subject_aliases (assumindo que já existe)"""
    
    print("🚀 FASE 1: Populando subject_aliases...")
    
    variants = [
        # Língua Portuguesa
        {'input_variant': 'portugues', 'normalized_name': 'Língua Portuguesa', 'category': 'Linguagens'},
        {'input_variant': 'português', 'normalized_name': 'Língua Portuguesa', 'category': 'Linguagens'},
        {'input_variant': 'lingua portuguesa', 'normalized_name': 'Língua Portuguesa', 'category': 'Linguagens'},
        {'input_variant': 'Língua Portuguesa', 'normalized_name': 'Língua Portuguesa', 'category': 'Linguagens'},
        
        # História
        {'input_variant': 'historia', 'normalized_name': 'História', 'category': 'Ciências Humanas'},
        {'input_variant': 'história', 'normalized_name': 'História', 'category': 'Ciências Humanas'},
        {'input_variant': 'História', 'normalized_name': 'História', 'category': 'Ciências Humanas'},
        
        # Matemática
        {'input_variant': 'matematica', 'normalized_name': 'Matemática', 'category': 'Matemática'},
        {'input_variant': 'matemática', 'normalized_name': 'Matemática', 'category': 'Matemática'},
        {'input_variant': 'Matemática', 'normalized_name': 'Matemática', 'category': 'Matemática'},
        
        # Língua Inglesa
        {'input_variant': 'ingles', 'normalized_name': 'Língua Inglesa', 'category': 'Linguagens'},
        {'input_variant': 'inglês', 'normalized_name': 'Língua Inglesa', 'category': 'Linguagens'},
        {'input_variant': 'lingua inglesa', 'normalized_name': 'Língua Inglesa', 'category': 'Linguagens'},
        {'input_variant': 'Língua Inglesa', 'normalized_name': 'Língua Inglesa', 'category': 'Linguagens'},
        
        # Geografia
        {'input_variant': 'geografia', 'normalized_name': 'Geografia', 'category': 'Ciências Humanas'},
        {'input_variant': 'Geografia', 'normalized_name': 'Geografia', 'category': 'Ciências Humanas'},
        
        # Biologia
        {'input_variant': 'biologia', 'normalized_name': 'Biologia', 'category': 'Ciências da Natureza'},
        {'input_variant': 'Biologia', 'normalized_name': 'Biologia', 'category': 'Ciências da Natureza'},
        
        # Física
        {'input_variant': 'fisica', 'normalized_name': 'Física', 'category': 'Ciências da Natureza'},
        {'input_variant': 'física', 'normalized_name': 'Física', 'category': 'Ciências da Natureza'},
        {'input_variant': 'Física', 'normalized_name': 'Física', 'category': 'Ciências da Natureza'},
        
        # Química
        {'input_variant': 'quimica', 'normalized_name': 'Química', 'category': 'Ciências da Natureza'},
        {'input_variant': 'química', 'normalized_name': 'Química', 'category': 'Ciências da Natureza'},
        {'input_variant': 'Química', 'normalized_name': 'Química', 'category': 'Ciências da Natureza'},
        
        # Filosofia
        {'input_variant': 'filosofia', 'normalized_name': 'Filosofia', 'category': 'Ciências Humanas'},
        {'input_variant': 'Filosofia', 'normalized_name': 'Filosofia', 'category': 'Ciências Humanas'},
        
        # Sociologia
        {'input_variant': 'sociologia', 'normalized_name': 'Sociologia', 'category': 'Ciências Humanas'},
        {'input_variant': 'Sociologia', 'normalized_name': 'Sociologia', 'category': 'Ciências Humanas'},
        
        # Artes
        {'input_variant': 'artes', 'normalized_name': 'Artes', 'category': 'Linguagens'},
        {'input_variant': 'arte', 'normalized_name': 'Artes', 'category': 'Linguagens'},
        {'input_variant': 'Artes', 'normalized_name': 'Artes', 'category': 'Linguagens'},
        
        # Educação Física
        {'input_variant': 'educacao fisica', 'normalized_name': 'Educação Física', 'category': 'Linguagens'},
        {'input_variant': 'educação física', 'normalized_name': 'Educação Física', 'category': 'Linguagens'},
        {'input_variant': 'Educação Física', 'normalized_name': 'Educação Física', 'category': 'Linguagens'},
        {'input_variant': 'ed fisica', 'normalized_name': 'Educação Física', 'category': 'Linguagens'},
        
        # Redação
        {'input_variant': 'redacao', 'normalized_name': 'Redação', 'category': 'Linguagens'},
        {'input_variant': 'redação', 'normalized_name': 'Redação', 'category': 'Linguagens'},
        {'input_variant': 'Redação', 'normalized_name': 'Redação', 'category': 'Linguagens'},
    ]
    
    inserted = 0
    skipped = 0
    
    for variant in variants:
        try:
            supabase.table('subject_aliases').insert(variant).execute()
            inserted += 1
            print(f"✓ {variant['input_variant']} → {variant['normalized_name']}")
        except Exception as e:
            # Provavelmente duplicata
            skipped += 1
    
    print(f"\n✅ Inseridos: {inserted} | Ignorados (duplicatas): {skipped}")
    
    # Verificar
    print("\n📊 Verificando dados...")
    result = supabase.table('subject_aliases').select('category, normalized_name').execute()
    
    if result.data:
        by_category = {}
        for row in result.data:
            cat = row.get('category', 'Sem Categoria')
            if cat not in by_category:
                by_category[cat] = set()
            by_category[cat].add(row['normalized_name'])
        
        print("\n=== DISCIPLINAS POR CATEGORIA ===")
        for cat, subjects in sorted(by_category.items()):
            print(f"{cat}: {', '.join(sorted(subjects))}")
    
    print("\n✅ POPULAÇÃO COMPLETA!")

if __name__ == "__main__":
    try:
        populate_subject_aliases()
    except Exception as e:
        print(f"\n❌ ERRO: {e}")
        print("\n⚠️ NOTA: A tabela 'subject_aliases' precisa ser criada manualmente via Supabase Dashboard SQL Editor:")
        print("\nSQL a executar:")
        print("""
CREATE TABLE IF NOT EXISTS subject_aliases (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    input_variant TEXT NOT NULL UNIQUE,
    normalized_name TEXT NOT NULL,
    category TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_subject_aliases_input 
ON subject_aliases(LOWER(input_variant));
        """)
