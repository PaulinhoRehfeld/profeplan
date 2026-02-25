# ProfeplanHub - Suite de Testes

Scripts de teste automatizados para validar a migração e integração.

## Testes Disponíveis

### 1. test_embedding_compatibility.py
Valida compatibilidade de embeddings com Supabase:
- ✅ Variáveis de ambiente
- ✅ Dimensões de embedding (768)
- ✅ Conexão com Supabase
- ✅ Busca vetorial (pgvector)

```bash
python test_embedding_compatibility.py
```

### 2. test_paths_migration.py
Valida estrutura de diretórios e arquivos:
- ✅ Estrutura de pastas
- ✅ Arquivos de configuração
- ✅ paths.json
- ✅ embedding_config.json
- ✅ Arquivos migrados

```bash
python test_paths_migration.py
```

### 3. test_pedagogo_supabase.py
Valida AgentePedagogo refatorado:
- ✅ Inicialização
- ✅ Conexão Supabase
- ✅ Recuperação de conhecimento (RAG)
- ✅ Geração de roteiros

```bash
python test_pedagogo_supabase.py
```

## Executar Todos os Testes

```bash
cd ProfeplanHub/tests

# Executar individualmente
python test_embedding_compatibility.py
python test_paths_migration.py
python test_pedagogo_supabase.py

# Ou criar um runner (futuro)
python run_all_tests.py
```

## Exit Codes

- `0`: Todos os testes passaram ✅
- `1`: Alguns testes falharam ❌

## Pré-requisitos

1. `.env` configurado com credenciais
2. Supabase acessível
3. Dependências instaladas (`pip install -r requirements.txt`)

## Output Esperado

```
╔══════════════════════════════════════════════════════════╗
║               TESTE DE COMPATIBILIDADE                   ║
╚══════════════════════════════════════════════════════════╝

============================================================
TESTE 1: Variáveis de Ambiente
============================================================
  ✅ API_KEY_GOOGLE: AIzaSyBp...
  ✅ SUPABASE_URL: https://uatejrgm...
  ✅ SUPABASE_KEY: eyJhbGciOiJI...
  ...

============================================================
RELATÓRIO FINAL
============================================================
  Variáveis de Ambiente: ✅ PASSOU
  Dimensões de Embedding: ✅ PASSOU
  Conexão Supabase: ✅ PASSOU
  Busca Vetorial: ✅ PASSOU

  Total: 4/4 testes passaram

  🎉 TODOS OS TESTES PASSARAM!
```
