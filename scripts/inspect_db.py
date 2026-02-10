import os
from supabase import create_client
from dotenv import load_dotenv
from collections import defaultdict

load_dotenv()

SUPABASE_URL = os.getenv("VITE_SUPABASE_URL") or os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY") or os.getenv("VITE_SUPABASE_ANON_KEY")

if not SUPABASE_URL or not SUPABASE_KEY:
    print("❌ Missing Supabase credentials")
    exit(1)

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)

def inspect_database():
    print("=" * 80)
    print("RELATORIO COMPLETO DO BANCO DE DADOS - curriculos_mg")
    print("=" * 80)
    
    try:
        # Buscar TODOS os registros
        print("\nBuscando todos os registros...")
        response = supabase.table("curriculos_mg").select("metadata, disciplina, content").execute()
        
        if not response.data:
            print("[AVISO] Banco de dados vazio!")
            return
        
        total = len(response.data)
        print(f"[OK] Total de registros encontrados: {total}")
        
        # Análise por disciplina
        disciplinas = defaultdict(lambda: {"count": 0, "anos": set(), "periodos": set(), "sources": set()})
        
        for record in response.data:
            meta = record.get('metadata') or {}
            
            # Tentar extrair disciplina de múltiplas fontes
            disc = (record.get('disciplina') or 
                   meta.get('disciplina') or 
                   meta.get('Disciplina') or 
                   "Sem Disciplina")
            
            ano = meta.get('ano_escolar') or meta.get('ano') or meta.get('Ano') or "N/A"
            periodo = meta.get('periodo') or meta.get('período') or meta.get('Período') or "N/A"
            source = meta.get('source') or meta.get('Source') or "N/A"
            
            disciplinas[disc]["count"] += 1
            disciplinas[disc]["anos"].add(ano)
            disciplinas[disc]["periodos"].add(periodo)
            disciplinas[disc]["sources"].add(source)
        
        # Relatorio por disciplina
        print("\n" + "=" * 80)
        print("DISCIPLINAS ENCONTRADAS")
        print("=" * 80)
        
        for disc in sorted(disciplinas.keys()):
            info = disciplinas[disc]
            print(f"\n[{disc}]")
            print(f"   Registros: {info['count']}")
            print(f"   Anos: {', '.join(sorted(info['anos']))}")
            print(f"   Períodos: {', '.join(sorted(info['periodos']))}")
            print(f"   Fontes: {', '.join(sorted(info['sources']))}")
        
        # Disciplinas ausentes (esperadas)
        print("\n" + "=" * 80)
        print("DISCIPLINAS ESPERADAS MAS AUSENTES/INCOMPLETAS")
        print("=" * 80)
        
        expected = [
            "Física", "Matemática", "Língua Portuguesa", "Biologia",
            "Geografia", "Inglês", "Arte", "Educação Física"
        ]
        
        found_disciplines = set(disciplinas.keys())
        
        for exp in expected:
            if exp not in found_disciplines:
                print(f"[AUSENTE] {exp} - TOTALMENTE AUSENTE")
            elif disciplinas[exp]["count"] < 3:
                print(f"[INCOMPLETO] {exp} - DADOS INSUFICIENTES (apenas {disciplinas[exp]['count']} registros)")
        
        # Analise de qualidade
        print("\n" + "=" * 80)
        print("ANALISE DE QUALIDADE DOS METADADOS")
        print("=" * 80)
        
        sem_disciplina = 0
        sem_ano = 0
        sem_periodo = 0
        
        for record in response.data:
            meta = record.get('metadata') or {}
            disc = record.get('disciplina') or meta.get('disciplina')
            ano = meta.get('ano_escolar') or meta.get('ano')
            periodo = meta.get('periodo') or meta.get('período')
            
            if not disc:
                sem_disciplina += 1
            if not ano:
                sem_ano += 1
            if not periodo:
                sem_periodo += 1
        
        print(f"Registros sem disciplina: {sem_disciplina}")
        print(f"Registros sem ano: {sem_ano}")
        print(f"Registros sem período: {sem_periodo}")
        
        if sem_disciplina > 0 or sem_ano > 0 or sem_periodo > 0:
            print("\n[ATENCAO] Existem registros com metadados incompletos!")
        else:
            print("\n[OK] Todos os registros possuem metadados completos!")
        
        # Resumo executivo
        print("\n" + "=" * 80)
        print("RESUMO EXECUTIVO")
        print("=" * 80)
        print(f"Total de disciplinas catalogadas: {len(disciplinas)}")
        print(f"Total de registros: {total}")
        print(f"Média de registros por disciplina: {total / len(disciplinas):.1f}")
        
    except Exception as e:
        print(f"[ERRO] Erro ao inspecionar banco: {e}")

if __name__ == "__main__":
    inspect_database()
