#!/usr/bin/env python3
"""
Dividir bulk_inep_updates.sql em lotes menores
"""

from pathlib import Path

sql_file = Path(__file__).parent / "bulk_inep_updates.sql"
output_dir = Path(__file__).parent / "batches"
output_dir.mkdir(exist_ok=True)

batch_size = 300  # 300 updates por arquivo

with open(sql_file, 'r', encoding='utf-8') as f:
    lines = f.readlines()

# Separar por updates
updates = []
current_update = []

for line in lines:
    if line.startswith('-- ') and current_update and '--' in line:
        updates.append(''.join(current_update))
        current_update = [line]
    else:
        current_update.append(line)

if current_update:
    updates.append(''.join(current_update))

# Dividir em lotes
total_batches = (len(updates) + batch_size - 1) // batch_size

for batch_idx in range(total_batches):
    start = batch_idx * batch_size
    end = min((batch_idx + 1) * batch_size, len(updates))
    
    batch_file = output_dir / f"batch_{batch_idx + 1:02d}_of_{total_batches:02d}.sql"
    
    with open(batch_file, 'w', encoding='utf-8') as out:
        out.write(f"-- Lote {batch_idx + 1} de {total_batches}\n")
        out.write(f"-- Updates {start + 1} a {end}\n\n")
        out.write("BEGIN;\n\n")
        
        for update in updates[start:end]:
            out.write(update)
        
        out.write("\nCOMMIT;\n")
    
    print(f"✅ Gerado: {batch_file.name}")

print(f"\n🎯 Total de lotes: {total_batches}")
print(f"📁 Pasta: {output_dir}")
