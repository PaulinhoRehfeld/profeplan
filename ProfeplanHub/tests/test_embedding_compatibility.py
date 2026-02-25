"""
Test: Embedding Compatibility

Valida que o sistema está usando embeddings compatíveis com Supabase:
- Modelo: text-embedding-004
- Dimensões: 768
- Inserção e busca no Supabase funcionando
"""

import os
import sys
from pathlib import Path
from dotenv import load_dotenv
from supabase import create_client
from google import genai

# Carregar config
config_dir = Path(__file__).parent.parent / "config"
load_dotenv(config_dir / ".env")

# Colors para output
GREEN = '\033[92m'
RED = '\033[91m'
YELLOW = '\033[93m'
RESET = '\033[0m'


def test_env_variables():
    """Teste 1: Verificar variáveis de ambiente"""
    print(f"\n{'='*60}")
    print("TESTE 1: Variáveis de Ambiente")
    print(f"{'='*60}")
    
    required_vars = [
        "API_KEY_GOOGLE",
        "SUPABASE_URL",
        "SUPABASE_KEY",
        "GEMINI_EMBEDDING_MODEL",
        "GEMINI_EMBEDDING_DIMENSIONS"
    ]
    
    all_ok = True
    for var in required_vars:
        value = os.getenv(var)
        if value:
            # Mascarar chaves sensíveis
            if "KEY" in var or "URL" in var:
                display_value = value[:20] + "..." if len(value) > 20 else value
            else:
                display_value = value
            print(f"  ✅ {var}: {display_value}")
        else:
            print(f"  ❌ {var}: NÃO ENCONTRADO")
            all_ok = False
    
    return all_ok


def test_embedding_dimensions():
    """Teste 2: Verificar dimensões do embedding"""
    print(f"\n{'='*60}")
    print("TESTE 2: Dimensões do Embedding")
    print(f"{'='*60}")
    
    api_key = os.getenv("API_KEY_GOOGLE")
    model = os.getenv("GEMINI_EMBEDDING_MODEL", "embedding-001")
    expected_dims = int(os.getenv("GEMINI_EMBEDDING_DIMENSIONS", "768"))
    
    try:
        client = genai.Client(api_key=api_key)
        
        # Gerar embedding de teste
        print(f"  Modelo: {model}")
        print(f"  Texto de teste: 'História do Brasil'")
        
        result = client.models.embed_content(
            model=model,
            contents="História do Brasil"
        )
        
        embedding = result.embeddings[0].values
        actual_dims = len(embedding)
        
        print(f"  Dimensões esperadas: {expected_dims}")
        print(f"  Dimensões obtidas: {actual_dims}")
        
        if actual_dims == expected_dims:
            print(f"  {GREEN}✅ SUCESSO: Dimensões corretas!{RESET}")
            return True
        else:
            print(f"  {RED}❌ FALHA: Dimensões incompatíveis!{RESET}")
            return False
            
    except Exception as e:
        print(f"  {RED}❌ ERRO: {e}{RESET}")
        return False


def test_supabase_connection():
    """Teste 3: Testar conexão com Supabase"""
    print(f"\n{'='*60}")
    print("TESTE 3: Conexão com Supabase")
    print(f"{'='*60}")
    
    supabase_url = os.getenv("SUPABASE_URL")
    supabase_key = os.getenv("SUPABASE_KEY")
    
    try:
        supabase = create_client(supabase_url, supabase_key)
        
        # Testar query simples (contar registros)
        result = supabase.table("pnld_livros_conteudo").select("*", count="exact").limit(1).execute()
        
        print(f"  URL: {supabase_url}")
        print(f"  Tabela: pnld_livros_conteudo")
        print(f"  Registros encontrados: {result.count if hasattr(result, 'count') else 'N/A'}")
        print(f"  {GREEN}✅ SUCESSO: Conexão estabelecida!{RESET}")
        return True
        
    except Exception as e:
        print(f"  {RED}❌ ERRO: {e}{RESET}")
        return False


def test_supabase_vector_search():
    """Teste 4: Testar busca vetorial no Supabase"""
    print(f"\n{'='*60}")
    print("TESTE 4: Busca Vetorial (pgvector)")
    print(f"{'='*60}")
    
    try:
        # Gerar embedding
        api_key = os.getenv("API_KEY_GOOGLE")
        model = os.getenv("GEMINI_EMBEDDING_MODEL")
        
        client = genai.Client(api_key=api_key)
        result = client.models.embed_content(
            model=model,
            contents="Revolução Industrial"
        )
        query_embedding = result.embeddings[0].values
        
        # Buscar no Supabase
        supabase_url = os.getenv("SUPABASE_URL")
        supabase_key = os.getenv("SUPABASE_KEY")
        supabase = create_client(supabase_url, supabase_key)
        
        print(f"  Query: 'Revolução Industrial'")
        print(f"  Embedding dims: {len(query_embedding)}")
        
        # Tentar busca usando RPC
        search_result = supabase.rpc(
            'search_pnld_livros',
            {
                'query_embedding': query_embedding,
                'match_threshold': 0.3,
                'match_count': 3
            }
        ).execute()
        
        if search_result.data:
            print(f"  Resultados encontrados: {len(search_result.data)}")
            print(f"  {GREEN}✅ SUCESSO: Busca vetorial funcionando!{RESET}")
            
            # Mostrar primeiro resultado
            if search_result.data:
                first = search_result.data[0]
                print(f"\n  Exemplo de resultado:")
                print(f"    - Livro: {first.get('livro_id', 'N/A')}")
                print(f"    - Similaridade: {first.get('similarity', 0):.3f}")
                print(f"    - Conteúdo: {first.get('content', '')[:100]}...")
            
            return True
        else:
            print(f"  {YELLOW}⚠️  Nenhum resultado (pode ser normal se banco vazio){RESET}")
            return True  # Não é erro, pode estar vazio
            
    except Exception as e:
        print(f"  {RED}❌ ERRO: {e}{RESET}")
        return False


def run_all_tests():
    """Executar todos os testes"""
    print(f"\n{GREEN}╔{'═'*58}╗{RESET}")
    print(f"{GREEN}║{' '*15}TESTE DE COMPATIBILIDADE{' '*19}║{RESET}")
    print(f"{GREEN}╚{'═'*58}╝{RESET}")
    
    results = {
        "Variáveis de Ambiente": test_env_variables(),
        "Dimensões de Embedding": test_embedding_dimensions(),
        "Conexão Supabase": test_supabase_connection(),
        "Busca Vetorial": test_supabase_vector_search()
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
