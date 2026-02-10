#!/usr/bin/env python3
import re
import sys
from pathlib import Path

try:
    import openpyxl
except ImportError:
    print("❌ pip install openpyxl")
    sys.exit(1)

def normalize_name(name):
    if not name: return ""
    return str(name).upper().strip().replace("'", "''")

def has_target_level(row):
    target_cols = [20, 21, 22, 24]
    for col_idx in target_cols:
        if col_idx < len(row):
            val = row[col_idx]
            if val and str(val).strip().upper() == 'X':
                return True
    return False

excel_file = r"C:\Users\Admin\PROFEPLAN\ESCOLASMG\escolas_origem.xlsx"
output_dir = Path(r"C:\Users\Admin\PROFEPLAN\PROFEPLAN\.agent\scripts\all_schools_batches")
output_dir.mkdir(exist_ok=True)

wb = openpyxl.load_workbook(excel_file, read_only=True, data_only=True)
sheet = wb.active

updates = []
seen_ineps = set()

for row in sheet.iter_rows(min_row=10, values_only=True):
    city = row[3]; inep = row[4]; name = row[5]
    if not name or not inep or not city: continue
    if not has_target_level(row): continue
    
    inep_clean = re.sub(r'\D', '', str(inep))
    if len(inep_clean) != 6 or inep_clean in seen_ineps: continue
    seen_ineps.add(inep_clean)
    
    name_norm = normalize_name(name)
    city_norm = str(city).upper().strip().replace("'", "''")
    
    # SQL ULTRA SEGURO:
    # 1. LIMIT 1 garante que só uma escola receba o INEP se houver nomes duplicados
    # 2. NOT EXISTS garante que não tentemos usar um INEP que já existe em outra escola
    sql = f"UPDATE schools SET inep_code = '{inep_clean}' WHERE id = (SELECT id FROM schools WHERE UPPER(TRIM(name)) = '{name_norm}' AND UPPER(TRIM(city)) = '{city_norm}' AND inep_code IS NULL LIMIT 1) AND NOT EXISTS (SELECT 1 FROM schools WHERE inep_code = '{inep_clean}');"
    updates.append(f"-- {name} ({city})\n{sql}")

wb.close()

# Lotes menores (250) para maior compatibilidade
batch_size = 250
total_batches = (len(updates) + batch_size - 1) // batch_size

for i in range(total_batches):
    batch = updates[i*batch_size : (i+1)*batch_size]
    with open(output_dir / f"ultra_safe_batch_{i+1:02d}.sql", 'w', encoding='utf-8') as f:
        f.write("\n\n".join(batch))

print(f"✅ Gerados {total_batches} lotes ULTRA SEGUROS em: {output_dir}")
