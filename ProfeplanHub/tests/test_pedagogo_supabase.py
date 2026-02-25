"""
Test: AgentePedagogo com Supabase

Valida que o AgentePedagogo refatorado está funcionando corretamente:
- Conexão com Supabase
- Busca semântica (RAG)
- Geração de roteiros
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

# Adicionar path do agente
sys.path.insert(0, str(Path(__file__).parent.parent / "agents" / "pedagogo"))

try:
    from agente_pedagogo import AgentePedagogo
except ImportError as e:
    print(f"{RED}❌ ERRO: Não foi possível importar AgentePedagogo: {e}{RESET}")
    sys.exit(1)


def test_pedagogo_initialization():
    """Teste 1: Inicializar AgentePedagogo"""
    print(f"\n{'='*60}")
    print("TESTE 1: Inicialização do AgentePedagogo")
    print(f"{'='*60}")
    
    try:
        pedagogo = AgentePedagogo()
        print(f"  {GREEN}✅ AgentePedagogo inicializado com sucesso{RESET}")
        return pedagogo
    except Exception as e:
        print(f"  {RED}❌ ERRO: {e}{RESET}")
        return None


def test_pedagogo_knowledge_retrieval(pedagogo):
    """Teste 2: Recuperação de conhecimento (RAG)"""
    print(f"\n{'='*60}")
    print("TESTE 2: Recuperação de Conhecimento (RAG)")
    print(f"{'='*60}")
    
    if not pedagogo:
        print(f"  {YELLOW}⏭️  Pulado (AgentePedagogo não inicializado){RESET}")
        return False
    
    try:
        tema = "Revolução Industrial"
        print(f"  Tema de teste: '{tema}'")
        
        contexto = pedagogo.recuperar_conhecimento(tema, match_count=3, match_threshold=0.3)
        
        if contexto:
            print(f"  {GREEN}✅ Contexto recuperado ({len(contexto)} caracteres){RESET}")
            print(f"\n  Preview:")
            print(f"  {contexto[:200]}...")
            return True
        else:
            print(f"  {YELLOW}⚠️  Nenhum contexto recuperado (pode ser normal se banco vazio){RESET}")
            return True  # Não é erro, apenas banco vazio
            
    except Exception as e:
        print(f"  {RED}❌ ERRO: {e}{RESET}")
        import traceback
        traceback.print_exc()
        return False


def test_pedagogo_roteiro_generation(pedagogo):
    """Teste 3: Geração de roteiro"""
    print(f"\n{'='*60}")
    print("TESTE 3: Geração de Roteiro de Aula")
    print(f"{'='*60}")
    
    if not pedagogo:
        print(f"  {YELLOW}⏭️  Pulado (AgentePedagogo não inicializado){RESET}")
        return False
    
    try:
        print(f"  Gerando roteiro de teste...")
        print(f"    - Tema: 'Fotossíntese'")
        print(f"    - Disciplina: 'Biologia'")
        print(f"    - Série: '7º ano'")
        
        roteiro = pedagogo.criar_roteiro_aula(
            tema="Fotossíntese",
            disciplina="Biologia",
            ano_serie="7º ano"
        )
        
        if roteiro:
            print(f"  {GREEN}✅ Roteiro gerado com sucesso!{RESET}")
            
            # Validar estrutura
            required_keys = ["disciplina", "tema", "ano_serie", "objetivos", "desenvolvimento"]
            missing = [k for k in required_keys if k not in roteiro]
            
            if not missing:
                print(f"  {GREEN}✅ Estrutura do roteiro válida{RESET}")
                
                print(f"\n  Preview do roteiro:")
                print(f"    - Disciplina: {roteiro.get('disciplina')}")
                print(f"    - Tema: {roteiro.get('tema')}")
                print(f"    - Série: {roteiro.get('ano_serie')}")
                print(f"    - Objetivos: {len(roteiro.get('objetivos', []))} itens")
                print(f"    - Desenvolvimento: {len(roteiro.get('desenvolvimento', []))} etapas")
                
                return True
            else:
                print(f"  {YELLOW}⚠️  Estrutura incompleta. Faltam: {missing}{RESET}")
                return False
        else:
            print(f"  {RED}❌ Roteiro não foi gerado (retornou None){RESET}")
            return False
            
    except Exception as e:
        print(f"  {RED}❌ ERRO: {e}{RESET}")
        import traceback
        traceback.print_exc()
        return False


def test_pedagogo_supabase_connection(pedagogo):
    """Teste 4: Conexão direta com Supabase"""
    print(f"\n{'='*60}")
    print("TESTE 4: Conexão Supabase do AgentePedagogo")
    print(f"{'='*60}")
    
    if not pedagogo:
        print(f"  {YELLOW}⏭️  Pulado (AgentePedagogo não inicializado){RESET}")
        return False
    
    try:
        # Testar query direta
        result = pedagogo.supabase.table("pnld_livros_conteudo").select("*", count="exact").limit(1).execute()
        
        count = result.count if hasattr(result, 'count') else 'N/A'
        print(f"  Tabela: pnld_livros_conteudo")
        print(f"  Registros totais: {count}")
        print(f"  {GREEN}✅ Conexão funcionando!{RESET}")
        
        return True
        
    except Exception as e:
        print(f"  {RED}❌ ERRO: {e}{RESET}")
        return False


def run_all_tests():
    """Executar todos os testes"""
    print(f"\n{GREEN}╔{'═'*58}╗{RESET}")
    print(f"{GREEN}║{' '*12}TESTE DO AGENTE PEDAGOGO (RAG){' '*15}║{RESET}")
    print(f"{GREEN}╚{'═'*58}╝{RESET}")
    
    # Inicializar pedagogo
    pedagogo = test_pedagogo_initialization()
    
    results = {
        "Inicialização": pedagogo is not None,
        "Conexão Supabase": test_pedagogo_supabase_connection(pedagogo),
        "Recuperação de Conhecimento": test_pedagogo_knowledge_retrieval(pedagogo),
        "Geração de Roteiro": test_pedagogo_roteiro_generation(pedagogo)
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
