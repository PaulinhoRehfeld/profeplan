#!/usr/bin/env python3
"""
Gerar SQL com SKIP automático em duplicatas
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
    if not name:
        return ""
    normalized = str(name).upper().strip()
    normalized = re.sub(r'\s+', ' ', normalized)
    return normalized.replace("'", "''")

excel_file = r"C:\Users\Admin\PROFEPLAN\ESCOLASMG\escolas_origem.xlsx"
output_file = Path(__file__).parent / "bulk_inep_updates_final.sql"

print(f"📖 Lendo: {excel_file}")
wb = openpyxl.load_workbook(excel_file, read_only=True, data_only=True)
sheet = wb.active

updates = []
errors = []
processed = 0
seen_ineps = {}

print("🔍 Processando linhas...")

for row_idx, row in enumerate(sheet.iter_rows(min_row=10, values_only=True), start=10):
    processed += 1
    
    if processed % 100 == 0:
        print(f"  Processadas: {processed}")
    
    city = row[3] if len(row) > 3 else None
    inep = row[4] if len(row) > 4 else None
    name = row[5] if len(row) > 5 else None
    dep_admin = row[6] if len(row) > 6 else None
    
    if not name or not inep or not city:
        continue
    
    if dep_admin and 'ESTADUAL' not in str(dep_admin).upper():
        continue
    
    inep_clean = re.sub(r'\D', '', str(inep))
    
    if len(inep_clean) != 6:
        errors.append(f"Linha {row_idx}: INEP inválido '{inep}'")
        continue
    
    if inep_clean in seen_ineps:
        errors.append(f"Linha {row_idx}: INEP {inep_clean} duplicado na planilha")
        continue
    
    seen_ineps[inep_clean] = {'row': row_idx, 'name': name}
    
    name_norm = normalize_name(name)
    city_norm = str(city).upper().strip().replace("'", "''")
    
    # SQL com EXCEPTION HANDLING - ignora duplicatas
    sql = f"""-- {name} ({city}) - INEP: {inep_clean}
DO $$
BEGIN
    UPDATE schools 
    SET inep_code = '{inep_clean}' 
    WHERE UPPER(TRIM(name)) = '{name_norm}' 
      AND UPPER(TRIM(city)) = '{city_norm}' 
      AND inep_code IS NULL
      AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '{inep_clean}');
EXCEPTION 
    WHEN unique_violation THEN
        -- INEP já existe em outra escola, ignorar silenciosamente
        NULL;
END $$;
"""
    
    updates.append((name, inep_clean, city, sql))

wb.close()

print(f"\n📝 Gerando SQL...")
with open(output_file, 'w', encoding='utf-8') as out:
    out.write("-- =====================================================\n")
    out.write("-- ATUALIZAÇÃO AUTOMÁTICA DE INEPs (COM EXCEPTION HANDLER)\n")
    out.write(f"-- Total de escolas: {len(updates)}\n")
    out.write("-- Duplicatas serão ignoradas automaticamente\n")
    out.write("-- =====================================================\n\n")
    
    for name, inep, city, sql in updates:
        out.write(sql + "\n")
    
    out.write("\n-- VERIFICAÇÃO FINAL\n")
    out.write("SELECT COUNT(*) as total_com_inep FROM schools WHERE inep_code IS NOT NULL;\n")
    out.write("SELECT COUNT(*) as total_sem_inep FROM schools WHERE inep_code IS NULL;\n")
    out.write("\n-- Ver escolas que ficaram sem INEP\n")
    out.write("SELECT name, city FROM schools WHERE inep_code IS NULL ORDER BY city, name LIMIT 50;\n")

print(f"\n✅ SUCESSO!")
print(f"📄 Arquivo: {output_file}")
print(f"📊 Total de escolas: {len(updates)}")
