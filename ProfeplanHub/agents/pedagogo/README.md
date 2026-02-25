# AgentePedagogo - Sistema RAG

Sistema de *Retrieval Augmented Generation* (RAG) para geração de roteiros de aula baseados nos livros do PNLD.

## Características

- ✅ **Busca Semântica** com Supabase pgvector
- ✅ **Gemini text-embedding-004** (768 dimensões)
- ✅ **Geração RAG** com Gemini 2.0 Flash
- ✅ **Roteiros estruturados** em JSON

## Uso

```python
from agente_pedagogo import AgentePedagogo

# Inicializar
pedagogo = AgentePedagogo()

# Gerar roteiro
roteiro = pedagogo.criar_roteiro_aula(
    tema="Revolução Industrial",
    disciplina="História",
    ano_serie="9º ano"
)

print(roteiro)
```

## Configuração

Certifique-se de que o `.env` contém:
- `SUPABASE_URL`
- `SUPABASE_KEY`
- `API_KEY_GOOGLE`

## Estrutura do Roteiro

```json
{
  "disciplina": "História",
  "tema": "Revolução Industrial",
  "ano_serie": "9º ano",
  "objetivos": [...],
  "duracao_minutos": 50,
  "conceito": "...",
  "desenvolvimento": [...],
  "atividade_pratica": "...",
  "recursos": [...],
  "curiosidade": "...",
  "avaliacao": "...",
  "referencias_pnld": [...]
}
```

## Diferenças da Versão Anterior

| Aspecto | Versão Antiga | Versão Nova |
|---------|---------------|-------------|
| Vector DB | ChromaDB local | Supabase pgvector |
| Embedding | MiniLM (384d) | Gemini (768d) |
| Geração | RLM + GPT-4o | Gemini 2.0 Flash |
| Dependências | chromadb, rlm, sentence-transformers | supabase-py, google-generativeai |
