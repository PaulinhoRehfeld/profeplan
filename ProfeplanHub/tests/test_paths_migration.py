"""
Test: Paths Migration

Valida que a estrutura de diretórios está correta e paths estão configurados
"""

import os
import sys
import json
from pathlib import Path

# Colors
GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
RESET = '\033[0m'


def test_directory_structure():
    """Teste 1: Estrutura de diretórios"""
    print(f"\n{'='*60}")
    print("TESTE 1: Estrutura de Diretórios")
    print(f"{'='*60}")
    
    hub_dir = Path(__file__).parent.parent
    
    required_dirs = [
        "agents/codex",
        "agents/coletor",
        "agents/pedagogo",
        "agents/designer",
        "data/raw_pdfs",
        "data/indexed_books",
        "data/schools",
        "config",
        "docs",
        "tests"
    ]
    
    all_ok = True
    for dir_path in required_dirs:
        full_path = hub_dir / dir_path
        exists = full_path.exists() and full_path.is_dir()
        
        status = f"{GREEN}✅{RESET}" if exists else f"{RED}❌{RESET}"
        print(f"  {status} {dir_path}")
        
        if not exists:
            all_ok = False
    
    return all_ok


def test_config_files():
    """Teste 2: Arquivos de configuração"""
    print(f"\n{'='*60}")
    print("TESTE 2: Arquivos de Configuração")
    print(f"{'='*60}")
    
    hub_dir = Path(__file__).parent.parent
    config_dir = hub_dir / "config"
    
    required_files = [
        ".env",
        ".env.example",
        "paths.json",
        "embedding_config.json"
    ]
    
    all_ok = True
    for filename in required_files:
        file_path = config_dir / filename
        exists = file_path.exists() and file_path.is_file()
        
        status = f"{GREEN}✅{RESET}" if exists else f"{RED}❌{RESET}"
        print(f"  {status} config/{filename}")
        
        if not exists:
            all_ok = False
    
    return all_ok


def test_paths_json():
    """Teste 3: Validar paths.json"""
    print(f"\n{'='*60}")
    print("TESTE 3: Configuração de Paths (paths.json)")
    print(f"{'='*60}")
    
    hub_dir = Path(__file__).parent.parent
    paths_file = hub_dir / "config" / "paths.json"
    
    try:
        with open(paths_file, 'r', encoding='utf-8') as f:
            paths_config = json.load(f)
        
        required_keys = ["base_dir", "data", "agents", "legacy", "supabase"]
        
        all_ok = True
        for key in required_keys:
            if key in paths_config:
                print(f"  {GREEN}✅{RESET} {key}: {paths_config[key]}")
            else:
                print(f"  {RED}❌{RESET} {key}: NÃO ENCONTRADO")
                all_ok = False
        
        # Validar subkeys importantes
        if "data" in paths_config:
            data_keys = ["raw_pdfs", "indexed_books", "schools"]
            for key in data_keys:
                if key in paths_config["data"]:
                    print(f"  {GREEN}✅{RESET}   data.{key}: {paths_config['data'][key]}")
                else:
                    print(f"  {RED}❌{RESET}   data.{key}: NÃO ENCONTRADO")
                    all_ok = False
        
        return all_ok
        
    except Exception as e:
        print(f"  {RED}❌ ERRO ao ler paths.json: {e}{RESET}")
        return False


def test_embedding_config():
    """Teste 4: Validar embedding_config.json"""
    print(f"\n{'='*60}")
    print("TESTE 4: Configuração de Embeddings")
    print(f"{'='*60}")
    
    hub_dir = Path(__file__).parent.parent
    embedding_file = hub_dir / "config" / "embedding_config.json"
    
    try:
        with open(embedding_file, 'r', encoding='utf-8') as f:
            config = json.load(f)
        
        # Validar campos críticos
        checks = {
            "provider": ("google_gemini", config.get("provider")),
            "model": ("models/text-embedding-004", config.get("model")),
            "dimensions": (768, config.get("dimensions")),
            "distance_metric": ("cosine", config.get("distance_metric"))
        }
        
        all_ok = True
        for key, (expected, actual) in checks.items():
            if actual == expected:
                print(f"  {GREEN}✅{RESET} {key}: {actual}")
            else:
                print(f"  {RED}❌{RESET} {key}: esperado={expected}, atual={actual}")
                all_ok = False
        
        return all_ok
        
    except Exception as e:
        print(f"  {RED}❌ ERRO ao ler embedding_config.json: {e}{RESET}")
        return False


def test_migrated_files():
    """Teste 5: Arquivos migrados"""
    print(f"\n{'='*60}")
    print("TESTE 5: Arquivos Migrados")
    print(f"{'='*60}")
    
    hub_dir = Path(__file__).parent.parent
    
    files_to_check = {
        "CODEX": [
            "agents/codex/codex_indexer.py",
            "agents/codex/deliver_maps.py",
            "agents/codex/tech_lead.py",
            "agents/codex/ARCHITECTURE.md"
        ],
        "COLETOR": [
            "agents/coletor/coletor_ftd.py",
            "agents/coletor/coletor_moderna.py",
            "agents/coletor/coletor_pnld.py",
            "agents/coletor/README.md"
        ],
        "PEDAGOGO": [
            "agents/pedagogo/agente_pedagogo.py",
            "agents/pedagogo/README.md"
        ],
        "DESIGNER": [
            "agents/designer/agente_designer.py"
        ]
    }
    
    all_ok = True
    for component, files in files_to_check.items():
        print(f"\n  {component}:")
        for file_path in files:
            full_path = hub_dir / file_path
            exists = full_path.exists() and full_path.is_file()
            
            status = f"{GREEN}✅{RESET}" if exists else f"{RED}❌{RESET}"
            print(f"    {status} {file_path}")
            
            if not exists:
                all_ok = False
    
    return all_ok


def run_all_tests():
    """Executar todos os testes"""
    print(f"\n{GREEN}╔{'═'*58}╗{RESET}")
    print(f"{GREEN}║{' '*17}TESTE DE PATHS E ESTRUTURA{' '*13}║{RESET}")
    print(f"{GREEN}╚{'═'*58}╝{RESET}")
    
    results = {
        "Estrutura de Diretórios": test_directory_structure(),
        "Arquivos de Config": test_config_files(),
        "paths.json": test_paths_json(),
        "embedding_config.json": test_embedding_config(),
        "Arquivos Migrados": test_migrated_files()
    }
    
    # Relatório final
    print(f"\n{'='*60}")
    print("RELATÓRIO FINAL")
    print(f"{'='*60}")
    
    passed = sum(1 for v in results.values() if v)
    total = len(results)
    
    for test_name, result in results.items():
        status = f"{GREEN}✅ PASSOU{RESET}" if result else f"{RED}❌ FALHOU{RESET}"
        print(f"  {test_name}: {status}")
    
    print(f"\n  Total: {passed}/{total} testes passaram")
    
    if passed == total:
        print(f"\n  {GREEN}🎉 TODOS OS TESTES PASSARAM!{RESET}")
        return 0
    else:
        print(f"\n  {RED}⚠️  ALGUNS TESTES FALHARAM{RESET}")
        return 1


if __name__ == "__main__":
    sys.exit(run_all_tests())
