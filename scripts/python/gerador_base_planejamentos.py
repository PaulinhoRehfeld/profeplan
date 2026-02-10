"""
GERADOR DE BASE DE PLANEJAMENTOS - PROFEPLAN
=============================================

Este script resolve DEFINITIVAMENTE o problema de elaboração de planejamentos:

1. Varre todos os arquivos de planejamento em ingest_data/
2. Extrai automaticamente TODOS os dados curriculares
3. Gera planejamentos prontos linkados aos arquivos corretos
4. Deixa apenas quantidade de aulas e distribuição para o professor

Autor: Antigravity AI
Data: 2026-02-09
"""

import json
import os
import re
from pathlib import Path
from typing import List, Dict, Any
from datetime import datetime

# === CONFIGURAÇÕES ===
INGEST_DIR = Path("ingest_data")
OUTPUT_DB = Path("base_planejamentos.json")
OUTPUT_PLANOS = Path("planejamentos_prontos")

def extrair_info_filename(filename: str) -> Dict[str, str]:
    """
    Extrai informações do nome do arquivo.
    Exemplo: update_packet_1°ANO_ARTE_ENSINO_MÉDIO_1TRI.json
    Retorna: {ano: "1º ANO", disciplina: "ARTE", trimestre: "1º TRIMESTRE"}
    """
    pattern = r"update_packet_(\d°ANO)_(.+)_ENSINO_MÉDIO_(\d)TRI\.json"
    match = re.match(pattern, filename)
    
    if not match:
        return None
    
    ano_num, disciplina, tri_num = match.groups()
    
    # Normalizar disciplina (remover espaços extras, padronizar)
    disciplina = disciplina.strip().replace("_", " ")
    # Casos especiais
    if "QUÍMICA - ENSINO MÉDIO" in disciplina:
        disciplina = "QUÍMICA"
    
    return {
        "ano": ano_num.replace("ANO", " ANO"),  # "1° ANO"
        "disciplina": disciplina,
        "trimestre": f"{tri_num}º TRIMESTRE"
    }

def parsear_tabela_markdown(texto_limpo: str) -> Dict[str, Any]:
    """
    Parseia a tabela markdown em texto_limpo e extrai os campos.
    Retorna dicionário com: unidade_tematica, habilidades, objeto_conhecimento, competencia
    """
    # Tratar caso None
    if not texto_limpo:
        return {}
    
    linhas = texto_limpo.split("\\n")
    
    # Estrutura esperada:
    # |UNIDADE TEMÁTICA|HABILIDADE|OBJETO DO CONHECIMENTO|COMPETÊNCIA ESPECÍFICA|
    # |---|---|---|---|
    # |dados...|dados...|dados...|dados...|
    
    # Pular cabeçalho e separador, pegar linha de dados
    for i, linha in enumerate(linhas):
        # Pular cabeçalho (linha com UNIDADE TEMÁTICA)
        if "UNIDADE TEMÁTICA" in linha or "UNIDADE TEMATICA" in linha:
            continue
        # Pular separador
        if "---" in linha:
            continue
        # Pular linhas vazias
        if not linha.strip() or linha.strip() == "|":
            continue
            
        # É uma linha de dados
        if linha.startswith("|"):
            colunas = [c.strip() for c in linha.split("|") if c.strip()]
            
            if len(colunas) >= 4:
                dados = {
                    "unidade_tematica": colunas[0],
                    "habilidades_raw": colunas[1],
                    "objeto_conhecimento": colunas[2],
                    "competencia_especifica": colunas[3]
                }
                
                # Extrair códigos de habilidades (ex: EM13LGG101)
                habilidades_codigos = re.findall(r'\(([A-Z0-9]+)\)', dados["habilidades_raw"])
                dados["habilidades"] = habilidades_codigos
                
                return dados
    
    return {}

def processar_arquivo_planejamento(filepath: Path) -> Dict[str, Any]:
    """
    Processa um arquivo de planejamento e extrai todas as informações.
    """
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    info = extrair_info_filename(filepath.name)
    if not info:
        print(f"[WARN] Nao foi possivel extrair info de: {filepath.name}")
        return None
    
    # Processar conteúdo vetorial
    unidades = []
    for item in data.get("conteudo_vetorial", []):
        parsed = parsear_tabela_markdown(item.get("texto_limpo", ""))
        
        if parsed:
            unidade = {
                "pagina": item.get("pagina"),
                "capitulo": item.get("capitulo"),
                "unidade_tematica": parsed.get("unidade_tematica", ""),
                "habilidades": parsed.get("habilidades", []),
                "objeto_conhecimento": parsed.get("objeto_conhecimento", ""),
                "competencia_especifica": parsed.get("competencia_especifica", ""),
                "tags": item.get("tags", [])
            }
            unidades.append(unidade)
    
    # Estrutura do planejamento pronto
    planejamento = {
        "id": f"{info['ano'].replace(' ', '').replace('º', '')}_{info['disciplina'].replace(' ', '_')}_{info['trimestre'].replace(' ', '').replace('º', '')}",
        "disciplina": info["disciplina"],
        "ano": info["ano"],
        "trimestre": info["trimestre"],
        "nivel": "Ensino Médio",
        "arquivo_fonte": str(filepath),
        "processado_em": datetime.now().isoformat(),
        "unidades": unidades,
        "campos_professor": {
            "quantidade_aulas": None,
            "distribuicao_por_unidade": None,
            "observacoes": None
        }
    }
    
    return planejamento

def gerar_base_completa():
    """
    Gera a base de dados completa de planejamentos.
    """
    print(">>> GERADOR DE BASE DE PLANEJAMENTOS - INICIADO")
    print("=" * 60)
    
    # 1. Escanear diretório
    files = list(INGEST_DIR.glob("update_packet_*.json"))
    # Filtrar arquivo de teste
    files = [f for f in files if "test_" not in f.name]
    
    print(f"[INFO] Encontrados {len(files)} arquivos de planejamento")
    
    # 2. Processar cada arquivo
    planejamentos = []
    mapeamento = []
    
    for filepath in sorted(files):
        print(f"\\n[PROC] Processando: {filepath.name}")
        
        planejamento = processar_arquivo_planejamento(filepath)
        
        if planejamento:
            planejamentos.append(planejamento)
            
            # Criar entrada de mapeamento
            mapeamento.append({
                "id": planejamento["id"],
                "disciplina": planejamento["disciplina"],
                "ano": planejamento["ano"],
                "trimestre": planejamento["trimestre"],
                "arquivo_fonte": planejamento["arquivo_fonte"],
                "num_unidades": len(planejamento["unidades"]),
                "status": "disponível"
            })
            
            print(f"   [OK] {planejamento['disciplina']} - {planejamento['ano']} - {planejamento['trimestre']}")
            print(f"   [STATS] {len(planejamento['unidades'])} unidades extraidas")
    
    # 3. Salvar base de mapeamento
    base_dados = {
        "versao": "1.0",
        "gerado_em": datetime.now().isoformat(),
        "total_planejamentos": len(planejamentos),
        "mapeamento": mapeamento
    }
    
    with open(OUTPUT_DB, 'w', encoding='utf-8') as f:
        json.dump(base_dados, f, ensure_ascii=False, indent=2)
    
    print(f"\\n[SALVO] Base de mapeamento salva em: {OUTPUT_DB}")
    
    # 4. Salvar planejamentos individuais prontos
    OUTPUT_PLANOS.mkdir(exist_ok=True)
    
    for plano in planejamentos:
        filename = f"{plano['id']}.json"
        filepath = OUTPUT_PLANOS / filename
        
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(plano, f, ensure_ascii=False, indent=2)
    
    print(f"[SALVO] {len(planejamentos)} planejamentos prontos salvos em: {OUTPUT_PLANOS}")
    
    # 5. Relatório final
    print("\\n" + "=" * 60)
    print("RELATORIO FINAL")
    print("=" * 60)
    
    # Agrupar por disciplina
    disciplinas = {}
    for p in planejamentos:
        disc = p["disciplina"]
        if disc not in disciplinas:
            disciplinas[disc] = []
        disciplinas[disc].append(p)
    
    print(f"\\nTotal de disciplinas: {len(disciplinas)}")
    for disc, planos in sorted(disciplinas.items()):
        print(f"   - {disc}: {len(planos)} planejamentos")
    
    print(f"\\n[SUCESSO] Base de dados criada com {len(planejamentos)} planejamentos prontos.")
    print("\\nProximos passos:")
    print("   1. Revisar planejamentos em: planejamentos_prontos/")
    print("   2. Integrar com sistema Profeplan")
    print("   3. Professor precisa apenas definir: quantidade de aulas e distribuicao")

if __name__ == "__main__":
    gerar_base_completa()

