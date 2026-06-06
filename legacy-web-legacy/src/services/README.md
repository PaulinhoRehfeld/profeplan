# Services — Código Fonte Reconstruído

Esta pasta contém os serviços do app legado PROFEPLAN, **reconstruídos a partir do build compilado** em `dist/assets/`.

O código-fonte TypeScript original foi perdido; estes arquivos foram reescritos com base na análise de:
- `dist/assets/markdownParser-Dou529D6.js` (RAG, curriculum, AI prompts)
- `dist/assets/PlanningManager-BSlnLa0n.js` (planning logic)

---

## Arquivos

| Arquivo | Descrição | Status |
|---------|-----------|--------|
| `supabaseClient.ts` | Cliente Supabase centralizado | ✅ Reconstruído |
| `aiService.ts` | Geração AI — **migrado Azure → OpenAI direto** | ✅ Reconstruído + Migrado |
| `curriculumRagService.ts` | Busca RAG de currículo SEE/MG | ✅ Reconstruído |
| `questionService.ts` | Busca híbrida de questões ENEM/SAEB | ✅ Reconstruído |

---

## Configuração Necessária

### 1. Adicionar chave OpenAI no `.env`

```env
VITE_OPENAI_API_KEY=sk-...   # sua chave OpenAI real
VITE_OPENAI_MODEL=gpt-4o-mini
```

### 2. Aplicar migration do Supabase

Execute no **SQL Editor do Supabase Dashboard**:
```
supabase/migrations/20260606_search_curriculum_rag.sql
```

Isso cria:
- Tabela `curriculum_rag` com suporte a pgvector
- Função RPC `search_curriculum_rag`
- Função RPC `get_curriculo_completo`

### 3. Rebuild do app

```bash
cd legacy-web-legacy
npm run build
```

---

## O que foi corrigido

| Erro | Causa | Solução |
|------|-------|---------|
| `profeplan-ai.openai.azure.com` → ERR_NAME_NOT_RESOLVED | Recurso Azure deletado | Migrado para OpenAI direto |
| `search_curriculum_rag` → 404 | Função RPC não existia no Supabase | Migration SQL criada |
| `metadata` → 404 | Coluna ausente ou RLS bloqueando | Fallback gracioso com warn |

---

## Próximos Passos

- [ ] Popular a tabela `curriculum_rag` com o currículo real da SEE/MG
- [ ] Gerar embeddings Gemini para os trechos curriculares (para busca semântica)
- [ ] Configurar pipeline de ingestão via `ingest_data/`
