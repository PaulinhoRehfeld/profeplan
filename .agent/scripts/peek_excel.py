#!/usr/bin/env python3
"""
Script para visualizar TODAS as linhas iniciais da planilha
"""

import sys
from pathlib import Path

try:
    import openpyxl
except ImportError:
    print("❌ pip install openpyxl")
    sys.exit(1)

excel_file = r"C:\Users\Admin\PROFEPLAN\ESCOLASMG\escolas_origem.xlsx"

wb = openpyxl.load_workbook(excel_file, read_only=True, data_only=True)
sheet = wb.active

print("📋 PRIMEIRAS 10 LINHAS DA PLANILHA:\n")
for row_idx, row in enumerate(sheet.iter_rows(max_row=10, values_only=True), start=1):
    print(f"LINHA {row_idx}:")
    non_empty = [(idx, val) for idx, val in enumerate(row) if val]
    for idx, val in non_empty[:15]:  # Primeiras 15 colunas não-vazias
        print(f"  [{idx:2d}] {val}")
    print()

wb.close()
