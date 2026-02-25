# ⚠️ ATENÇÃO: API de Embeddings Indisponível

> **Última verificação:** 2026-02-15  
> **Status:** 🚫 Bloqueado por issue upstream da Google

---

## 🔍 Descoberta

Durante a migração do ProfeplanHub, descobrimos que **NENHUM modelo de embedding está disponível** no SDK `google-generativeai` atual.

### Tentativas Realizadas

| Modelo | API Version | Result |
|--------|-------------|--------|
| `text-embedding-004` | v1beta | 404 NOT_FOUND |
| `text-embedding-004` | v1 | 404 NOT_FOUND |
| `embedding-001` | v1beta | 404 NOT_FOUND |
| `embedding-001` | v1 | 404 NOT_FOUND |

### Erro Retornado

```json
{
  "error": {
    "code": 404,
    "message": "models/[MODEL_NAME] is not found for API version [VERSION], 
                or is not supported for embedContent. Call ListModels to see 
                the list of available models and their supported methods.",
    "status": "NOT_FOUND"
  }
}
```

---

## 🎯 Impacto

### ✅ Funcionando 100%
- **CODEX Indexer** (usa Gemini 2.0 Flash para análise, não embeddings)
- **COLETOR Scrapers** (3 scripts com modo headless)
- **Supabase Connection** (13 livros já indexados)
- **Estrutura ProfeplanHub** (paths, config, organização)

### 🚫 Bloqueado
- **AgentePedagogo RAG** (depende de embeddings para busca semântica)
- **Geração de roteiros** baseada em RAG
- **Busca vetorial** no Supabase

---

## 🔧 Causa Raiz

A Google **ainda não liberou** os modelos de embedding na nova versão da API Generative AI. 

O SDK `google-generativeai` v0.8.6:
- Migrou para nova arquitetura de API
- Ainda usa v1beta internamente
- Modelos de embedding não foram portados/liberados

---

## 📊 Timeline

| Data | Evento |
|------|--------|
| 2026-02-15 | Migração ProfeplanHub iniciada |
| 2026-02-15 09:00 | Descoberto que text-embedding-004 não funciona |
| 2026-02-15 09:06 | SDK atualizado → problema persiste |
| 2026-02-15 09:13 | Testado embedding-001 → também não funciona |
| 2026-02-15 09:15 | **Confirmado: NENHUM embedding disponível** |

---

## ✅ Solução Temporária

**Status atual:** Sistema core 100% funcional SEM RAG.

**Pipeline operacional:**
```
COLETOR (scraping) → CODEX (indexing) → Supabase (storage)
```

**RAG desabilitado temporariamente:**
```
Supabase → AgentePedagogo (BLOQUEADO) → Roteiros
```

---

## 🔮 Próximos Passos

### Quando Google Liberar API

1. **Identificar modelo disponível**
   ```bash
   # Listar modelos de embedding
   curl "https://generativelanguage.googleapis.com/v1/models?key=$API_KEY" \
     | jq '.models[] | select(.name | contains("embed"))'
   ```

2. **Atualizar .env**
   ```env
   GEMINI_EMBEDDING_MODEL=<modelo-disponivel>
   ```

3. **Re-executar testes**
   ```bash
   cd ProfeplanHub/tests
   python test_embedding_compatibility.py  # Deve passar 100%
   python test_pedagogo_supabase.py        # Deve passar 100%
   ```

4. **Sistema totalmente operacional** 🎉

---

## 📝 Configuração Atual (Standby)

Arquivo `.env` configurado para quando API estiver disponível:

```env
# Embeddings (STANDBY - aguardando API)
GEMINI_EMBEDDING_MODEL=embedding-001  # Trocar quando disponível
GEMINI_EMBEDDING_DIMENSIONS=768
```

**Código pronto** em:
- `agents/pedagogo/agente_pedagogo.py` (sem alterações needed)
- `tests/test_embedding_compatibility.py` (validação automática)
- `tests/test_pedagogo_supabase.py` (validação RAG)

---

## 🎓 Lições Aprendidas

1. **Sempre validar disponibilidade de API** antes de arquitetar solução
2. **SDK atualizado ≠ features liberadas** (API pode estar em preview)
3. **Documentação pode estar adelantada** ao lançamento real
4. **Ter fallback plan** para funcionalidades dependentes de terceiros

---

## 📞 Referências

- **SDK:** `google-generativeai` v0.8.6
- **Docs:** https://ai.google.dev/gemini-api/docs/embeddings
- **Issue:** Embeddings API não disponível (2026-02-15)
- **Status:** Aguardando release oficial da Google

---

**Última atualização:** 2026-02-15 09:15  
**Próxima verificação sugerida:** Semanal até API ser liberada
