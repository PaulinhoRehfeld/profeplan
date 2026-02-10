#!/usr/bin/env python3
"""
Script para gerar SQL de atualização de INEPs a partir do Google Sheets
"""

import csv
import re
import sys
from pathlib import Path

def normalize_name(name):
    """Normaliza nome da escola para matching"""
    if not name:
        return ""
    # Remove acentos, caracteres especiais, múltiplos espaços
    normalized = name.upper().strip()
    normalized = re.sub(r'\s+', ' ', normalized)
    return normalized

def generate_sql_from_csv(csv_file_path, output_sql_path):
    """
    Gera SQL a partir do CSV exportado do Google Sheets
    
    Esperado: Colunas com Nome, INEP, Município
    """
    
    updates = []
    errors = []
    
    try:
        with open(csv_file_path, 'r', encoding='utf-8-sig') as f:
            # Detectar delimitador
            sample = f.read(1024)
            f.seek(0)
            sniffer = csv.Sniffer()
            delimiter = sniffer.sniff(sample).delimiter
            
            reader = csv.DictReader(f, delimiter=delimiter)
            
            for idx, row in enumerate(reader, 1):
                # Detectar colunas (adapte conforme sua planilha)
                # Assumindo: Nome em 'Escola', INEP em 'INEP', Cidade em 'Município'
                
                school_name = None
                inep = None
                city = None
                
                # Tentar encontrar colunas automaticamente
                for key in row.keys():
                    key_lower = key.lower()
                    if 'escola' in key_lower or 'nome' in key_lower:
                        school_name = row[key]
                    elif 'inep' in key_lower or 'código' in key_lower:
                        inep = row[key]
                    elif 'município' in key_lower or 'cidade' in key_lower:
                        city = row[key]
                
                # Validar
                if not school_name or not inep or not city:
                    continue
                
                # Limpar INEP (remover prefixo se tiver)
                inep_clean = re.sub(r'\D', '', inep)
                if len(inep_clean) == 8 and inep_clean.startswith('31'):
                    inep_clean = inep_clean[2:]  # Remove prefixo 31
                
                if len(inep_clean) != 6:
                    errors.append(f"Linha {idx}: INEP inválido '{inep}' para {school_name}")
                    continue
                
                # Normalizar nome e cidade
                name_normalized = normalize_name(school_name)
                city_normalized = city.upper().strip()
                
                # Gerar UPDATE
                sql = f"""UPDATE schools 
SET inep_code = '{inep_clean}', city = '{city_normalized}' 
WHERE UPPER(name) = '{name_normalized}' 
  AND UPPER(city) ILIKE '%{city_normalized}%' 
  AND inep_code IS NULL;"""
                
                updates.append((school_name, inep_clean, city_normalized, sql))
        
        # Escrever SQL
        with open(output_sql_path, 'w', encoding='utf-8') as out:
            out.write("-- =====================================================\n")
            out.write("-- ATUALIZAÇÃO AUTOMÁTICA DE INEPs\n")
            out.write(f"-- Total de escolas: {len(updates)}\n")
            out.write("-- =====================================================\n\n")
            
            out.write("BEGIN;\n\n")
            
            for name, inep, city, sql in updates:
                out.write(f"-- {name} ({city}) - INEP: {inep}\n")
                out.write(sql + "\n\n")
            
            out.write("COMMIT;\n\n")
            
            out.write("-- =====================================================\n")
            out.write("-- VERIFICAÇÃO\n")
            out.write("-- =====================================================\n")
            out.write("SELECT COUNT(*) as total_atualizados FROM schools WHERE inep_code IS NOT NULL;\n")
        
        print(f"✅ SQL gerado com sucesso!")
        print(f"📄 Arquivo: {output_sql_path}")
        print(f"📊 Total de updates: {len(updates)}")
        
        if errors:
            print(f"\n⚠️ Erros encontrados ({len(errors)}):")
            for err in errors[:10]:
                print(f"  - {err}")
        
        return True
        
    except Exception as e:
        print(f"❌ Erro: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python generate_inep_updates.py <arquivo.csv>")
        print("\nExporte a planilha do Google Sheets como CSV e passe o caminho.")
        sys.exit(1)
    
    csv_file = sys.argv[1]
    output_file = Path(__file__).parent / "bulk_inep_updates.sql"
    
    if not Path(csv_file).exists():
        print(f"❌ Arquivo não encontrado: {csv_file}")
        sys.exit(1)
    
    generate_sql_from_csv(csv_file, output_file)
