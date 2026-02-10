#!/usr/bin/env python3
"""
Gerar SQL para TODAS as escolas com Fund2, Médio ou Técnico
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

def has_target_level(row):
    """
    Verifica se escola oferece Fund2, Médio ou Técnico
    Baseado na estrutura da planilha:
    - Col 20: Ensino Fundamental - Anos finais
    - Col 21: Ensino Médio - Propedêutico
    - Col 22: Ensino Médio - Integrado
    - Col 24: Nível técnico - Presencial
    """
    target_cols = [20, 21, 22, 24]  # Colunas de interesse (0-indexed)
    
    for col_idx in target_cols:
        if col_idx < len(row):
            val = row[col_idx]
            if val and str(val).strip().upper() == 'X':
                return True
    return False

excel_file = r"C:\Users\Admin\PROFEPLAN\ESCOLASMG\escolas_origem.xlsx"
output_file = Path(__file__).parent / "bulk_inep_all_schools.sql"

print(f"📖 Lendo: {excel_file}")
wb = openpyxl.load_workbook(excel_file, read_only=True, data_only=True)
sheet = wb.active

updates = []
errors = []
processed = 0
filtered_out = 0
seen_ineps = {}

print("🔍 Processando linhas...")
print("📌 Filtrando: Fund2 (Anos Finais) + Médio + Técnico\n")

for row_idx, row in enumerate(sheet.iter_rows(min_row=10, values_only=True), start=10):
    processed += 1
    
    if processed % 100 == 0:
        print(f"  Processadas: {processed} | Selecionadas: {len(updates)} | Filtradas: {filtered_out}")
    
    city = row[3] if len(row) > 3 else None
    inep = row[4] if len(row) > 4 else None
    name = row[5] if len(row) > 5 else None
    
    if not name or not inep or not city:
        continue
    
    # FILTRO: Só escolas com Fund2, Médio ou Técnico
    if not has_target_level(row):
        filtered_out += 1
        continue
    
    inep_clean = re.sub(r'\D', '', str(inep))
    
    if len(inep_clean) != 6:
        errors.append(f"Linha {row_idx}: INEP inválido '{inep}'")
        continue
    
    if inep_clean in seen_ineps:
        errors.append(f"Linha {row_idx}: INEP {inep_clean} duplicado")
        continue
    
    seen_ineps[inep_clean] = {'row': row_idx, 'name': name}
    
    name_norm = normalize_name(name)
    city_norm = str(city).upper().strip().replace("'", "''")
    
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
        NULL;
END $$;
"""
    
    updates.append((name, inep_clean, city, sql))

wb.close()

print(f"\n📝 Gerando SQL...")
with open(output_file, 'w', encoding='utf-8') as out:
    out.write("-- =====================================================\n")
    out.write("-- ATUALIZAÇÃO DE INEPs - TODAS AS REDES\n")
    out.write("-- Filtro: Fund2 (Anos Finais) + Ensino Médio + Técnico\n")
    out.write(f"-- Total de escolas: {len(updates)}\n")
    out.write(f"-- Escolas filtradas (não atendem critério): {filtered_out}\n")
    out.write("-- =====================================================\n\n")
    
    for name, inep, city, sql in updates:
        out.write(sql + "\n")
    
    out.write("\n-- VERIFICAÇÃO FINAL\n")
    out.write("SELECT COUNT(*) as total_com_inep FROM schools WHERE inep_code IS NOT NULL;\n")
    out.write("SELECT COUNT(*) as total_sem_inep FROM schools WHERE inep_code IS NULL;\n")

print(f"\n✅ SUCESSO!")
print(f"📄 Arquivo: {output_file}")
print(f"📊 Escolas selecionadas: {len(updates)}")
print(f"🚫 Escolas filtradas (sem Fund2/Médio/Técnico): {filtered_out}")
print(f"⚠️ Duplicatas: {len([e for e in errors if 'duplicado' in e])}")
