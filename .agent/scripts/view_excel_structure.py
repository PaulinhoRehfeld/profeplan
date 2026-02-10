#!/usr/bin/env python3
"""
Script para visualizar estrutura da planilha Excel
"""

import sys
from pathlib import Path

try:
    import openpyxl
except ImportError:
    print("❌ Biblioteca 'openpyxl' não encontrada!")
    print("📦 Instale com: pip install openpyxl")
    sys.exit(1)

excel_file = r"C:\Users\Admin\PROFEPLAN\ESCOLASMG\escolas_origem.xlsx"

if not Path(excel_file).exists():
    print(f"❌ Arquivo não encontrado: {excel_file}")
    sys.exit(1)

print(f"📖 Lendo arquivo: {excel_file}")
wb = openpyxl.load_workbook(excel_file, read_only=True, data_only=True)
sheet = wb.active
print(f"✅ Planilha: {sheet.title}\n")

# Mostrar cabeçalhos
headers = [cell.value for cell in sheet[1]]
print("📋 COLUNAS ENCONTRADAS:\n")
for idx, header in enumerate(headers):
    if header:
        print(f"  [{idx:2d}] {header}")

# Mostrar primeira linha de dados
print("\n📄 PRIMEIRA LINHA DE DADOS:\n")
first_data_row = list(sheet.iter_rows(min_row=2, max_row=2, values_only=True))[0]
for idx, value in enumerate(first_data_row[:30]):  # Primeiras 30 colunas
    if value:
        print(f"  [{idx:2d}] {value}")

wb.close()
