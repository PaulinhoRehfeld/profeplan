#!/usr/bin/env python3
"""
Script FINAL para gerar SQL de atualização de INEPs
Baseado na estrutura real da planilha
"""

import re
import sys
from pathlib import Path

try:
    import openpyxl
except ImportError:
    print("❌ pip install openpyxl")
    sys.exit(1)

def normalize_name(name):
    """Normaliza nome da escola"""
    if not name:
        return ""
    normalized = str(name).upper().strip()
    normalized = re.sub(r'\s+', ' ', normalized)
    return normalized.replace("'", "''")  # Escapar aspas

excel_file = r"C:\Users\Admin\PROFEPLAN\ESCOLASMG\escolas_origem.xlsx"
output_file = Path(__file__).parent / "bulk_inep_updates.sql"

print(f"📖 Lendo: {excel_file}")
wb = openpyxl.load_workbook(excel_file, read_only=True, data_only=True)
sheet = wb.active

# Estrutura da planilha:
# Linha 6 = cabeçalhos
# Linha 10+ = dados
# Col 3 = Município
# Col 4 = Código da Escola (INEP)
# Col 5 = Nome da Escola
# Col 6 = Dependência Administrativa

updates = []
errors = []
processed = 0

print("🔍 Proces sand linhas...")

for row_idx, row in enumerate(sheet.iter_rows(min_row=10, values_only=True), start=10):
    processed += 1
    
    if processed % 100 == 0:
        print(f"  Processadas: {processed}")
    
    # Extrair dados
    city = row[3] if len(row) > 3 else None
    inep = row[4] if len(row) > 4 else None
    name = row[5] if len(row) > 5 else None
    dep_admin = row[6] if len(row) > 6 else None
    
    # Validar
    if not name or not inep or not city:
        continue
    
    # Filtrar apenas ESTADUAL
    if dep_admin and 'ESTADUAL' not in str(dep_admin).upper():
        continue
    
    # Limpar INEP
    inep_clean = re.sub(r'\D', '', str(inep))
    
    if len(inep_clean) != 6:
        errors.append(f"Linha {row_idx}: INEP inválido '{inep}' ({len(inep_clean)} dígitos)")
        continue
    
    # Normalizar
    name_norm = normalize_name(name)
    city_norm = str(city).upper().strip().replace("'", "''")
    
    # Gerar SQL
    sql = f"""UPDATE schools 
SET inep_code = '{inep_clean}' 
WHERE UPPER(TRIM(name)) = '{name_norm}' 
  AND UPPER(TRIM(city)) = '{city_norm}' 
  AND inep_code IS NULL;"""
    
    updates.append((name, inep_clean, city, sql))

wb.close()

# Escrever SQL
print(f"\n📝 Gerando SQL...")
with open(output_file, 'w', encoding='utf-8') as out:
    out.write("-- =====================================================\n")
    out.write("-- ATUALIZAÇÃO AUTOMÁTICA DE INEPs\n")
    out.write(f"-- Total de escolas ESTADUAIS: {len(updates)}\n")
    out.write("-- =====================================================\n\n")
    
    out.write("BEGIN;\n\n")
    
    for name, inep, city, sql in updates:
        out.write(f"-- {name} ({city}) - INEP: {inep}\n")
        out.write(sql + "\n\n")
    
    out.write("COMMIT;\n\n")
    
    out.write("-- =====================================================\n")
    out.write("-- VERIFICAÇÃO\n")
    out.write("-- =====================================================\n")
    out.write("SELECT COUNT(*) as total_com_inep FROM schools WHERE inep_code IS NOT NULL;\n")
    out.write("SELECT COUNT(*) as total_sem_inep FROM schools WHERE inep_code IS NULL;\n")

print(f"\n✅ SUCESSO!")
print(f"📄 Arquivo: {output_file}")
print(f"📊 Total de escolas: {len(updates)}")
print(f"⚠️ Erros: {len(errors)}")

if errors and len(errors) <= 10:
    print("\nErros:")
    for err in errors:
        print(f"  - {err}")

print("\n🎯 Próximos passos:")
print("   1. Abra Supabase SQL Editor")
print(f"   2. Cole o conteúdo de: {output_file.name}")
print("   3. Execute!")
