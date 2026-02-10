#!/usr/bin/env python3
"""
Script para gerar SQL de atualização de INEPs a partir de Excel
"""

import re
import sys
from pathlib import Path

try:
    import openpyxl
except ImportError:
    print("❌ Biblioteca 'openpyxl' não encontrada!")
    print("📦 Instale com: pip install openpyxl")
    sys.exit(1)

def normalize_name(name):
    """Normaliza nome da escola para matching"""
    if not name:
        return ""
    normalized = str(name).upper().strip()
    normalized = re.sub(r'\s+', ' ', normalized)
    return normalized

def has_x_marker(row, columns_to_check):
    """Verifica se a linha tem 'X' em alguma das colunas especificadas"""
    # Colunas U, V, W, X, Y = índices 20, 21, 22, 23, 24 (0-indexed)
    for col_idx in columns_to_check:
        if col_idx < len(row):
            cell_value = row[col_idx]
            if cell_value and str(cell_value).strip().upper() == 'X':
                return True
    return False

def generate_sql_from_excel(excel_file_path, output_sql_path):
    """
    Gera SQL a partir do arquivo Excel
    """
    
    try:
        print(f"📖 Lendo arquivo: {excel_file_path}")
        wb = openpyxl.load_workbook(excel_file_path, read_only=True, data_only=True)
        sheet = wb.active
        print(f"✅ Planilha carregada: {sheet.title}")
        
        # Detectar colunas (primeira linha = cabeçalho)
        headers = [cell.value for cell in sheet[1]]
        print(f"📋 Colunas encontradas: {len(headers)}")
        
        # Encontrar índices das colunas importantes
        name_col = None
        inep_col = None
        city_col = None
        
        for idx, header in enumerate(headers):
            if not header:
                continue
            h = str(header).lower()
            if 'escola' in h or 'nome' in h:
                name_col = idx
                print(f"  📌 Nome da Escola: Coluna {idx} ({header})")
            elif 'inep' in h or 'código' in h:
                inep_col = idx
                print(f"  📌 INEP: Coluna {idx} ({header})")
            elif 'município' in h or 'cidade' in h:
                city_col = idx
                print(f"  📌 Cidade: Coluna {idx} ({header})")
        
        if name_col is None or inep_col is None or city_col is None:
            print("\n⚠️ Não consegui detectar as colunas automaticamente!")
            print("Por favor, informe manualmente os índices das colunas (0-indexed):")
            name_col = int(input("Coluna do Nome da Escola: "))
            inep_col = int(input("Coluna do INEP: "))
            city_col = int(input("Coluna do Município: "))
        
        # Colunas U, V, W, X, Y (marcadores de filtro)
        marker_columns = [20, 21, 22, 23, 24]  # Índices 0-based
        
        updates = []
        errors = []
        skipped = 0
        
        print(f"\n🔍 Processando linhas...")
        
        for row_idx, row in enumerate(sheet.iter_rows(min_row=2, values_only=True), start=2):
            # Verificar se tem 'X' nas colunas marcadoras
            if not has_x_marker(row, marker_columns):
                skipped += 1
                continue
            
            # Extrair dados
            school_name = row[name_col] if name_col < len(row) else None
            inep = row[inep_col] if inep_col < len(row) else None
            city = row[city_col] if city_col < len(row) else None
            
            # Validar
            if not school_name or not inep or not city:
                errors.append(f"Linha {row_idx}: Dados incompletos")
                continue
            
            # Limpar INEP
            inep_clean = re.sub(r'\D', '', str(inep))
            if len(inep_clean) == 8 and inep_clean.startswith('31'):
                inep_clean = inep_clean[2:]
            
            if len(inep_clean) != 6:
                errors.append(f"Linha {row_idx}: INEP inválido '{inep}' para {school_name}")
                continue
            
            # Normalizar
            name_normalized = normalize_name(school_name)
            city_normalized = str(city).upper().strip()
            
            # Escapar aspas simples
            name_escaped = name_normalized.replace("'", "''")
            city_escaped = city_normalized.replace("'", "''")
            
            # Gerar UPDATE
            sql = f"""UPDATE schools 
SET inep_code = '{inep_clean}', city = '{city_escaped}' 
WHERE UPPER(name) = '{name_escaped}' 
  AND UPPER(city) ILIKE '%{city_escaped}%' 
  AND inep_code IS NULL;"""
            
            updates.append((school_name, inep_clean, city_normalized, sql))
        
        wb.close()
        
        # Escrever SQL
        print(f"\n📝 Gerando SQL...")
        with open(output_sql_path, 'w', encoding='utf-8') as out:
            out.write("-- =====================================================\n")
            out.write("-- ATUALIZAÇÃO AUTOMÁTICA DE INEPs\n")
            out.write(f"-- Fonte: {Path(excel_file_path).name}\n")
            out.write(f"-- Total de escolas: {len(updates)}\n")
            out.write(f"-- Linhas ignoradas (sem X): {skipped}\n")
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
        
        print(f"\n✅ SQL gerado com sucesso!")
        print(f"📄 Arquivo: {output_sql_path}")
        print(f"📊 Total de updates: {len(updates)}")
        print(f"🚫 Linhas ignoradas (sem X): {skipped}")
        
        if errors:
            print(f"\n⚠️ Erros encontrados ({len(errors)}):")
            for err in errors[:10]:
                print(f"  - {err}")
            if len(errors) > 10:
                print(f"  ... e mais {len(errors) - 10} erros")
        
        return True
        
    except Exception as e:
        print(f"❌ Erro: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    excel_file = r"C:\Users\Admin\PROFEPLAN\ESCOLASMG\escolas_origem.xlsx"
    output_file = Path(__file__).parent / "bulk_inep_updates.sql"
    
    if not Path(excel_file).exists():
        print(f"❌ Arquivo não encontrado: {excel_file}")
        sys.exit(1)
    
    generate_sql_from_excel(excel_file, output_file)
    
    print("\n🎯 Próximo passo:")
    print("   1. Abra Supabase SQL Editor")
    print("   2. Cole o conteúdo de bulk_inep_updates.sql")
    print("   3. Execute!")
