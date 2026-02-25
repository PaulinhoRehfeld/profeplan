import shutil
import os
from pathlib import Path

# Configurar paths
base = Path(r"C:\Users\Admin\PROFEPLAN")
hub = base / "PROFEPLAN" / "ProfeplanHub"

print("Migrando arquivos CODEX...")
# Copiar CODEX
codex_src = base / "CODEX"
codex_dest = hub / "agents" / "codex"

files_to_copy_codex = [
    "codex_indexer.py",
    "deliver_maps.py",
    "tech_lead.py",
    "ARCHITECTURE.md"
]

for file in files_to_copy_codex:
    src = codex_src / file
    if src.exists():
        shutil.copy2(src, codex_dest)
        print(f"✅ {file}")
    else:
        print(f"⚠️ Não encontrado: {file}")

print("\nMigrando arquivos COLETOR...")
# Copiar COLETOR
coletor_src = base / "COLETOR"
coletor_dest = hub / "agents" / "coletor"

files_to_copy_coletor = [
    "coletor_ftd.py",
    "coletor_moderna.py",
    "coletor_pnld.py",
    "assistente_manual.py",
    "README.md"
]

for file in files_to_copy_coletor:
    src = coletor_src / file
    if src.exists():
        shutil.copy2(src, coletor_dest)
        print(f"✅ {file}")
    else:
        print(f"⚠️ Não encontrado: {file}")

print("\nMigrando arquivos SMARTCLASS...")
# Copiar SMARTCLASS
smartclass_src = base / "SMARTCLASS" / "PROJETO_ANTIGRAVITY"
pedagogo_dest = hub / "agents" / "pedagogo"
designer_dest = hub / "agents" / "designer"

# Pedagogo
if (smartclass_src / "agente_pedagogo.py").exists():
    shutil.copy2(smartclass_src / "agente_pedagogo.py", pedagogo_dest)
    print("✅ agente_pedagogo.py")

# Designer
if (smartclass_src / "agente_designer.py").exists():
    shutil.copy2(smartclass_src / "agente_designer.py", designer_dest)
    print("✅ agente_designer.py")

print("\nMigrando dados de escolas MG...")
# Copiar JSONs de escolas
escolasmg_src = base / "ESCOLASMG"
schools_dest = hub / "data" / "schools"

schools_files = [
    "banco_escolas_final.json",
    "banco_escolas_mg_filtrado.json"
]

for file in schools_files:
    src = escolasmg_src / file
    if src.exists():
        shutil.copy2(src, schools_dest)
        print(f"✅ {file}")

print("\n✅ Migração de arquivos concluída!")
