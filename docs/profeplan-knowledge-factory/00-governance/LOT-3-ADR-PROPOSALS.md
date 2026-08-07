# ADRs propostas — Lote 3

## Status

Todas as decisões abaixo estão **propostas** e aguardam aprovação humana. Após aprovação serão incorporadas ao `DECISION-LOG.md` e ao checkpoint do Lote 3.

## ADR-033 — SQL Supabase como persistência canônica da Knowledge Factory

**Status:** proposto

### Decisão

A Knowledge Factory usará migrations SQL em `supabase/migrations/` como fonte de verdade física para seu schema.

`packages/db`/Prisma não receberá cópia das tabelas `kf_*` neste lote.

### Motivos

- Supabase é a persistência operacional do produto;
- Prisma está associado a stack legada e fora do CI ativo;
- duas definições físicas gerariam drift;
- RLS é requisito nativo deste domínio.

### Consequência

A decisão não remove Prisma do monorepo e não decide seu futuro para outros domínios.

---

## ADR-034 — Tabelas `public.kf_*` com deny-by-default

**Status:** proposto

### Decisão

As tabelas do Lote 3 serão criadas no schema `public` com prefixo `kf_` e defesa em profundidade:

- grants explícitos;
- RLS;
- corpus global sem leitura direta de professor;
- acesso de backend via adapters e políticas de domínio.

### Motivos

- o repositório atual usa Supabase/PostgREST em `public`;
- não há configuração canônica de schema customizado;
- criar schema customizado agora adicionaria infraestrutura não necessária ao objetivo do lote.

### Consequência

A adoção futura de schema dedicado continua possível.

---

## ADR-035 — Adapter Supabase em pacote separado

**Status:** proposto

### Decisão

A infraestrutura concreta será isolada em:

`@profeplan/knowledge-factory-supabase`

O pacote `@profeplan/knowledge-factory` continuará puro e sem dependência de Supabase.

### Consequência

O Lote 3 será dividido em:

- 3A: schema/RLS;
- 3B: adapters.

O PR 3B só inicia após validação do 3A em ambiente não produtivo.

---

## ADR-036 — Isolamento do MVP por requester, sem inventar tenant novo

**Status:** proposto

### Decisão

No MVP individual, OPPs serão isoladas por:

`requester_id = auth.uid()`

Nenhuma tabela `tenant` será criada pela Knowledge Factory neste lote, e `school_id` não será tratado como tenant universal.

### Motivos

- público inicial é professor individual;
- o modelo corporativo/escolar do produto ainda não deve ser redefinido por este módulo;
- segurança cross-user pode ser comprovada já.

### Consequência

Futuro B2B/B2G poderá adicionar organização/tenant sem quebrar a identidade da OPP.

---

## ADR-037 — Vetores e retrieval permanecem fora do schema do Lote 3

**Status:** proposto

### Decisão

Nenhuma tabela/coluna/índice do Lote 3 escolherá:

- modelo de embedding;
- dimensão;
- vector type;
- IVFFlat;
- HNSW;
- full-text retrieval;
- reranking.

### Motivo

ADR-021 exige experimentação reproduzível antes da promoção dessas escolhas.

### Consequência

A migration legada `curriculum_rag` não é schema canônico da Knowledge Factory.

---

## ADR-038 — Merge de migration não autoriza aplicação em produção

**Status:** proposto

### Decisão

Haverá dois gates humanos independentes:

1. aprovação/merge do código da migration;
2. autorização para executar a migration no Supabase de produção.

Antes do segundo gate são obrigatórios:

- ambiente não produtivo;
- testes de RLS;
- ensaio de rollback;
- verificação de divergência de migrations;
- backup/registro pré-flight.

### Consequência

Nenhuma automação poderá interpretar merge como deploy de banco autorizado.

---

## ADR-039 — Proveniência e auditoria append-only

**Status:** proposto

### Decisão

Eventos de permissão, OPP e auditoria serão append-only em uso normal.

Entidades históricas não usarão cascade delete como mecanismo de governança.

Correção de histórico ocorrerá por novo evento, bloqueio, suspensão ou supersessão, não por edição silenciosa.

### Consequência

Rollback destrutivo só é aceitável antes de uso real ou com preservação/exportação explicitamente aprovada.

## Aprovação recomendada

Recomenda-se aprovar ADR-033 a ADR-039 em conjunto, pois formam a fronteira arquitetônica necessária para iniciar o PR 3A sem misturar banco, retrieval, IA e aplicação produtiva.