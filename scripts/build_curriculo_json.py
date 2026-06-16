#!/usr/bin/env python3
"""
Build Currículo MG JSON
=======================
Parseia todos os arquivos .md de curriculo_mg/PlanosMG/MD/
e gera um JSON estruturado por disciplina, ano, série e período.

Saída: curriculo_mg/curriculo_mg.json
Chunks para RAG: curriculo_mg/chunks/
"""

import os
import re
import json
from pathlib import Path
from typing import Optional

# ── Paths ─────────────────────────────────────────────────────────────────────
BASE_DIR = Path(__file__).parent.parent
MD_DIR   = BASE_DIR / "curriculo_mg" / "PlanosMG" / "MD"
OUT_JSON = BASE_DIR / "curriculo_mg" / "curriculo_mg.json"
CHUNKS_DIR = BASE_DIR / "curriculo_mg" / "chunks"

# ── Normalização de disciplinas ────────────────────────────────────────────────
SUBJECT_MAP = {
    "arte":              "Artes",
    "artes":             "Artes",
    "biologia":          "Biologia",
    "ciencias":          "Ciências",
    "ciências":          "Ciências",
    "educacaofisica":    "Educação Física",
    "educação_digital":  "Educação Digital",
    "educacao_digital":  "Educação Digital",
    "educação_física":   "Educação Física",
    "educacao_fisica":   "Educação Física",
    "ensinoreligioso":   "Ensino Religioso",
    "filosofia":         "Filosofia",
    "fisica":            "Física",
    "física":            "Física",
    "geografia":         "Geografia",
    "historia":          "História",
    "história":          "História",
    "linguainglesa":     "Língua Inglesa",
    "língua_inglesa":    "Língua Inglesa",
    "linguaportuguesa":  "Língua Portuguesa",
    "língua_portuguesa": "Língua Portuguesa",
    "matematica":        "Matemática",
    "matemática":        "Matemática",
    "quimica":           "Química",
    "química":           "Química",
    "sociologia":        "Sociologia",
}

LEVEL_MAP = {
    "em": "Ensino Médio",
    "ef": "Ensino Fundamental",
}

# ── Parse do nome do arquivo ───────────────────────────────────────────────────
def parse_filename(filename: str) -> Optional[dict]:
    """
    Extrai metadados do nome do arquivo.
    Padrões: 1ANO_EM_FILOSOFIA, 6ANO_EF_HISTORIA, etc.
    """
    stem = Path(filename).stem  # sem extensão
    
    # Remove caracteres especiais para normalização
    stem_norm = stem.lower()
    
    # Padrão: {ANO}ANO_{LEVEL}_{SUBJECT}
    match = re.match(r"(\d+)ano?_(\w{2})_(.+)", stem_norm)
    if not match:
        return None
    
    grade_num = match.group(1)
    level_code = match.group(2)
    subject_raw = match.group(3)
    
    # Normaliza disciplina (remove acentos simples, underscores)
    subject_key = subject_raw.replace(" ", "_").lower()
    # Remove sufixos como "- ensino medio"
    subject_key = re.sub(r"[\s\-]+ensino.*", "", subject_key).strip("_")
    
    subject = SUBJECT_MAP.get(subject_key, subject_raw.replace("_", " ").title())
    level   = LEVEL_MAP.get(level_code, level_code.upper())
    grade   = f"{grade_num}º Ano"
    
    return {
        "grade": grade,
        "grade_num": int(grade_num),
        "level": level,
        "subject": subject,
    }

# ── Parse do conteúdo Markdown ─────────────────────────────────────────────────
FIELD_PATTERNS = {
    "unidade_tematica":       r"\*\*UNIDADE TEMÁTICA:\*\*\s*(.+)",
    "competencia":            r"\*\*COMPETÊNCIA:\*\*\s*(.+)",
    "habilidade":             r"\*\*HABILIDADE:\*\*\s*(.+)",
    "objeto_conhecimento":    r"\*\*OBJETO DE CONHECIMENTO:\*\*\s*(.+)",
    "descritores_saeb":       r"\*\*DESCRITORES DO SAEB:\*\*\s*(.+)",
    "orientacoes_pedagogicas":r"\*\*ORIENTAÇÕES PEDAGÓGICAS:\*\*\s*(.+)",
}

def parse_habilidades_codes(text: str) -> list[str]:
    """Extrai códigos de habilidade como EM13CHS101, EF09MA03, etc."""
    return re.findall(r"\(([A-Z]{2}\d{2}[A-Z]+\d+[A-Z]*(?:[A-Z]{2}MG)?[A-Z]?)\)", text)

def parse_md_content(content: str, meta: dict) -> list[dict]:
    """
    Parseia o conteúdo de um arquivo MD e retorna lista de registros,
    um por bloco (período + unidade temática).
    """
    records = []
    
    # Detecta regime (Bimestre ou Trimestre)
    regime = "Bimestre"
    if re.search(r"trimestre", content, re.IGNORECASE):
        regime = "Trimestre"
    
    # Divide por períodos (### 1º BIMESTRE, ### 2º TRIMESTRE, etc.)
    period_pattern = r"###\s+(\d+)[ºo°]\s+(BIMESTRE|TRIMESTRE|PERÍODO)"
    period_splits = list(re.finditer(period_pattern, content, re.IGNORECASE))
    
    if not period_splits:
        # Sem subdivisão de período — trata como período único
        period_splits_ranges = [(1, content)]
    else:
        period_splits_ranges = []
        for i, m in enumerate(period_splits):
            period_num = int(m.group(1))
            start = m.end()
            end = period_splits[i+1].start() if i+1 < len(period_splits) else len(content)
            period_splits_ranges.append((period_num, content[start:end]))
    
    for period_num, period_text in period_splits_ranges:
        # Extrai cada "bloco" de habilidade dentro do período
        # Divide por linhas que começam com - **UNIDADE TEMÁTICA:**
        blocks = re.split(r"\n(?=- \*\*UNIDADE TEMÁTICA:)", period_text)
        
        for block in blocks:
            if not block.strip():
                continue
            
            record = {
                "grade":           meta["grade"],
                "grade_num":       meta["grade_num"],
                "level":           meta["level"],
                "subject":         meta["subject"],
                "regime":          regime,
                "period":          period_num,
            }
            
            # Extrai cada campo
            for field, pattern in FIELD_PATTERNS.items():
                m = re.search(pattern, block, re.IGNORECASE)
                val = m.group(1).strip() if m else ""
                # Limpa valores genéricos
                if val in ("[Não especificada no documento para este item]",
                           "[Não há orientações transcritas para esta habilidade no documento original].",
                           "Não consta no documento.", "[Não especificado]", ""):
                    val = ""
                record[field] = val
            
            # Extrai códigos de habilidade
            codes = parse_habilidades_codes(record.get("habilidade", ""))
            record["habilidade_codes"] = codes
            
            # Gera chunk_text para embeddings
            parts = []
            if record.get("unidade_tematica"):
                parts.append(f"Unidade: {record['unidade_tematica']}")
            if record.get("objeto_conhecimento"):
                parts.append(f"Objetos: {record['objeto_conhecimento']}")
            if record.get("habilidade"):
                parts.append(f"Habilidades: {record['habilidade']}")
            if record.get("descritores_saeb"):
                parts.append(f"SAEB: {record['descritores_saeb']}")
            if record.get("orientacoes_pedagogicas"):
                parts.append(f"Orientações: {record['orientacoes_pedagogicas']}")
            
            record["chunk_text"] = (
                f"{record['level']} | {record['grade']} | {record['subject']} | "
                f"{record['period']}º {record['regime']}\n"
                + "\n".join(parts)
            )
            
            # Só adiciona se tiver algum conteúdo real
            if any([record.get("habilidade"), record.get("objeto_conhecimento"),
                    record.get("unidade_tematica")]):
                records.append(record)
    
    return records

# ── Deduplicação de arquivos ────────────────────────────────────────────────────
def pick_best_file(files: list[Path]) -> Path:
    """
    Para disciplinas com arquivos duplicados (com/sem acento),
    escolhe o de maior tamanho (mais completo).
    """
    return max(files, key=lambda f: f.stat().st_size)

def group_files_by_subject(md_dir: Path) -> dict:
    """Agrupa arquivos por (grade_num, level, subject), evitando duplicatas."""
    groups: dict[tuple, list[Path]] = {}
    
    for f in sorted(md_dir.glob("*.md")):
        meta = parse_filename(f.name)
        if not meta:
            print(f"  ⚠️  Ignorado (nome inválido): {f.name}")
            continue
        
        key = (meta["grade_num"], meta["level"], meta["subject"])
        groups.setdefault(key, []).append(f)
    
    # Resolve duplicatas
    best: dict[tuple, tuple[Path, dict]] = {}
    for key, files in groups.items():
        chosen = pick_best_file(files)
        meta = parse_filename(chosen.name)
        best[key] = (chosen, meta)
        if len(files) > 1:
            print(f"  📎 Duplicatas para {key[2]} {key[0]}ºAno: "
                  f"escolhido {chosen.name} ({chosen.stat().st_size/1024:.0f}KB)")
    
    return best

# ── Main ───────────────────────────────────────────────────────────────────────
def main():
    print("🚀 ProPlan Currículo MG — Build JSON")
    print(f"   Fonte: {MD_DIR}")
    print(f"   Saída: {OUT_JSON}")
    print()
    
    if not MD_DIR.exists():
        print(f"❌ Pasta não encontrada: {MD_DIR}")
        return
    
    CHUNKS_DIR.mkdir(parents=True, exist_ok=True)
    
    groups = group_files_by_subject(MD_DIR)
    
    all_records: list[dict] = []
    stats = {"files": 0, "records": 0, "skipped": 0}
    
    for key, (filepath, meta) in sorted(groups.items()):
        try:
            content = filepath.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            content = filepath.read_text(encoding="latin-1")
        
        records = parse_md_content(content, meta)
        
        if not records:
            print(f"  ⚠️  Sem registros em: {filepath.name}")
            stats["skipped"] += 1
            continue
        
        all_records.extend(records)
        stats["files"] += 1
        stats["records"] += len(records)
        
        label = f"{meta['subject']} — {meta['grade']} {meta['level']}"
        print(f"  ✅ {label}: {len(records)} blocos")
    
    # ── Estrutura final do JSON ────────────────────────────────────────────────
    output = {
        "meta": {
            "source": "Currículo Referência MG — SEE-MG 2026",
            "state": "Minas Gerais",
            "total_records": len(all_records),
            "generated_at": __import__("datetime").datetime.now().isoformat(),
        },
        "curriculo": all_records,
    }
    
    # ── Salva JSON principal ───────────────────────────────────────────────────
    OUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    with open(OUT_JSON, "w", encoding="utf-8") as f:
        json.dump(output, f, ensure_ascii=False, indent=2)
    
    print()
    print(f"📦 JSON salvo: {OUT_JSON} ({OUT_JSON.stat().st_size / 1024:.0f} KB)")
    
    # ── Gera chunks individuais por disciplina/série ───────────────────────────
    by_subject: dict[str, list] = {}
    for r in all_records:
        key_name = f"{r['level'].replace(' ','_')}_{r['grade_num']}ANO_{r['subject'].replace(' ','_')}"
        by_subject.setdefault(key_name, []).append(r)
    
    for chunk_key, records in by_subject.items():
        chunk_file = CHUNKS_DIR / f"{chunk_key}.json"
        with open(chunk_file, "w", encoding="utf-8") as f:
            json.dump(records, f, ensure_ascii=False, indent=2)
    
    print(f"📂 Chunks por disciplina/série: {len(by_subject)} arquivos em {CHUNKS_DIR}/")
    print()
    print("═══════════════════════════════════════")
    print(f"✅ Concluído!")
    print(f"   Arquivos processados: {stats['files']}")
    print(f"   Blocos de conteúdo:   {stats['records']}")
    print(f"   Ignorados:            {stats['skipped']}")
    print("═══════════════════════════════════════")
    
    # ── Prévia de um registro ──────────────────────────────────────────────────
    if all_records:
        print()
        print("📋 Exemplo de registro:")
        sample = all_records[0]
        for k, v in sample.items():
            if k == "chunk_text":
                print(f"   chunk_text: [{len(v)} chars]")
            elif k == "orientacoes_pedagogicas":
                print(f"   orientacoes_pedagogicas: [{len(v)} chars]")
            else:
                val_str = str(v)[:80] + ("..." if len(str(v)) > 80 else "")
                print(f"   {k}: {val_str}")

if __name__ == "__main__":
    main()
