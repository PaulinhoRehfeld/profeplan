#!/usr/bin/env python3
"""
Import Curriculo MG JSON -> Supabase
=====================================
Importa os dados do curriculo_mg.json para a tabela curriculo_mg no Supabase.

PRÉ-REQUISITO:
  1. Execute 20260616_create_curriculo_mg_table.sql no Supabase SQL Editor
  2. pip install supabase python-dotenv
  3. Tenha SUPABASE_URL e SUPABASE_SERVICE_KEY no .env

USO:
  python scripts/import_curriculo_supabase.py
  python scripts/import_curriculo_supabase.py --clear  # limpa antes de importar
"""

import json
import os
import sys
import time
import argparse
from pathlib import Path

BASE_DIR = Path(__file__).parent.parent

def load_env():
    env_file = BASE_DIR / ".env"
    if env_file.exists():
        for line in env_file.read_text(encoding="utf-8").splitlines():
            if "=" in line and not line.startswith("#"):
                k, v = line.split("=", 1)
                os.environ.setdefault(k.strip(), v.strip().strip('"').strip("'"))
    
    # Try .env.local
    env_local = BASE_DIR / "apps" / "web" / ".env.local"
    if env_local.exists():
        for line in env_local.read_text(encoding="utf-8").splitlines():
            if "=" in line and not line.startswith("#"):
                k, v = line.split("=", 1)
                os.environ.setdefault(k.strip(), v.strip().strip('"').strip("'"))

def get_supabase_client():
    try:
        from supabase import create_client
    except ImportError:
        print("Instalando supabase...")
        os.system(f"{sys.executable} -m pip install supabase")
        from supabase import create_client
    
    # Tenta diferentes nomes de variável de ambiente
    url = (
        os.environ.get("SUPABASE_URL") or
        os.environ.get("VITE_SUPABASE_URL") or
        os.environ.get("NEXT_PUBLIC_SUPABASE_URL")
    )
    key = (
        os.environ.get("SUPABASE_SERVICE_KEY") or
        os.environ.get("SUPABASE_SERVICE_ROLE_KEY") or
        os.environ.get("SUPABASE_ANON_KEY") or
        os.environ.get("VITE_SUPABASE_ANON_KEY") or
        os.environ.get("NEXT_PUBLIC_SUPABASE_ANON_KEY")
    )
    
    if not url or not key:
        print("ERRO: Variaveis SUPABASE_URL e SUPABASE_SERVICE_KEY nao encontradas.")
        print("Configure no .env ou exporte manualmente:")
        print("  $env:SUPABASE_URL='https://xxx.supabase.co'")
        print("  $env:SUPABASE_SERVICE_KEY='eyJhbG...'")
        sys.exit(1)
    
    print(f"Conectando ao Supabase: {url[:40]}...")
    return create_client(url, key)

def main():
    parser = argparse.ArgumentParser(description="Importa curriculo MG para Supabase")
    parser.add_argument("--clear", action="store_true", help="Limpa tabela antes de importar")
    parser.add_argument("--batch", type=int, default=50, help="Tamanho do batch (default: 50)")
    parser.add_argument("--dry-run", action="store_true", help="Apenas mostra estatisticas sem importar")
    args = parser.parse_args()
    
    load_env()
    
    # Carrega JSON
    json_file = BASE_DIR / "curriculo_mg" / "curriculo_mg.json"
    if not json_file.exists():
        print(f"ERRO: JSON nao encontrado: {json_file}")
        print("Execute primeiro: python scripts/build_curriculo_json.py")
        sys.exit(1)
    
    print(f"Carregando: {json_file}")
    with open(json_file, encoding="utf-8") as f:
        data = json.load(f)
    
    records = data["curriculo"]
    meta    = data["meta"]
    
    print(f"Total de registros: {len(records)}")
    print(f"Fonte: {meta['source']}")
    print()
    
    # Remove campo chunk_text para o banco (é gerado em runtime)
    # Mantemos os outros campos
    def prepare_record(r: dict) -> dict:
        return {
            "level":                   r["level"],
            "grade":                   r["grade"],
            "grade_num":               r["grade_num"],
            "subject":                 r["subject"],
            "regime":                  r["regime"],
            "period":                  r["period"],
            "unidade_tematica":        r.get("unidade_tematica", ""),
            "competencia":             r.get("competencia", ""),
            "habilidade":              r.get("habilidade", ""),
            "habilidade_codes":        r.get("habilidade_codes", []),
            "objeto_conhecimento":     r.get("objeto_conhecimento", ""),
            "descritores_saeb":        r.get("descritores_saeb", ""),
            "orientacoes_pedagogicas": r.get("orientacoes_pedagogicas", ""),
            "chunk_text":              r.get("chunk_text", ""),
        }
    
    prepared = [prepare_record(r) for r in records]
    
    if args.dry_run:
        from collections import Counter
        subjects = Counter(r["subject"] for r in prepared)
        print("DRY RUN - Estatisticas:")
        for s, c in sorted(subjects.items()):
            print(f"  {s}: {c} blocos")
        return
    
    client = get_supabase_client()
    
    # Limpa tabela se pedido
    if args.clear:
        print("Limpando tabela curriculo_mg...")
        client.table("curriculo_mg").delete().neq("id", "00000000-0000-0000-0000-000000000000").execute()
        print("Tabela limpa.")
    
    # Importa em batches
    batch_size = args.batch
    total = len(prepared)
    imported = 0
    errors = 0
    
    print(f"Importando {total} registros em batches de {batch_size}...")
    
    for i in range(0, total, batch_size):
        batch = prepared[i : i + batch_size]
        try:
            result = client.table("curriculo_mg").upsert(batch).execute()
            imported += len(batch)
            pct = (imported / total) * 100
            print(f"  [{pct:5.1f}%] {imported}/{total} registros importados")
        except Exception as e:
            errors += len(batch)
            print(f"  ERRO no batch {i}-{i+batch_size}: {e}")
        
        # Rate limiting
        time.sleep(0.1)
    
    print()
    print("=" * 40)
    print(f"Importacao concluida!")
    print(f"  Importados: {imported}")
    print(f"  Erros:      {errors}")
    print()
    print("Verificacao no Supabase:")
    print("  SELECT subject, COUNT(*) FROM curriculo_mg GROUP BY subject ORDER BY subject;")

if __name__ == "__main__":
    main()
