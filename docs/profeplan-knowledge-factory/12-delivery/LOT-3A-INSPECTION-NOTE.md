# Lote 3A — Inspeção pré-SQL

Data: 7 de agosto de 2026.

## Status

**Gate de inspeção concluído. É seguro produzir migration e testes em PR rascunho. O PR não poderá ser considerado pronto para merge sem execução em ambiente Supabase não produtivo/descartável.**

## Base confirmada

A árvore aprovada do Lote 3 está presente. A branch `feat/knowledge-factory-persistence-schema` está sem diff líquido contra a `main` no início do trabalho.

## `supabase/migrations/` inspecionado

Foram revisadas integralmente as migrations existentes nessa raiz. Elas cobrem:

- `curriculum_rag`, pgvector, RPCs e leitura pública legada;
- documentos/chunks/agentes privados do professor;
- alinhamento PDI;
- hardening e correções de RLS;
- helpers administrativos com `SECURITY DEFINER`;
- correções de recursão RLS em `profiles`;
- busca curricular textual.

Nenhuma migration existente cria tabela, função, trigger, policy ou grant com prefixo `kf_`.

## Conflitos e riscos identificados

### Sem colisão de nomes

Nenhum objeto `public.kf_*` foi encontrado no repositório.

### RLS legado

O histórico possui recursão RLS em `profiles`. O padrão que resolveu o problema foi helper `SECURITY DEFINER` com `SET search_path = public`.

A Knowledge Factory utilizará helper próprio `public.kf_is_platform_admin()` e não alterará `is_admin_safe()`, `is_manager_or_admin_safe()` ou qualquer policy legada.

### `curriculum_rag`

`curriculum_rag` possui vector(768), IVFFlat, full-text e/ou RPCs legadas com exposição distinta da arquitetura da Knowledge Factory. Não será usada como schema canônico e não será alterada.

### Duas raízes históricas de SQL

Existem `supabase/` e `infra/supabase/`. ADR-033 já define `supabase/migrations/` como raiz canônica da Knowledge Factory. Nenhum arquivo de `infra/supabase/` será alterado neste lote.

### Ausência de infraestrutura SQL automatizada

Não existe hoje:

- `supabase/tests/` canônico;
- pgTAP no repositório;
- `supabase/config.toml` na raiz `supabase/`;
- workflow CI que aplique as migrations Supabase;
- workflow CI que execute testes RLS/SQL do Supabase.

O CI geral valida Node/TypeScript e não valida migrations SQL.

O CD de banco existente é manual e aponta para Prisma legado; não é o mecanismo de aplicação do Lote 3A.

### Ambiente desta sessão

O ambiente de execução disponível nesta sessão não possui Supabase CLI, Docker ou `psql`.

Consequência: migration e testes podem ser produzidos e revisados no PR rascunho, mas o gate de merge continuará bloqueado até execução real em ambiente Supabase não produtivo/descartável, incluindo RLS cross-user e rollback.

## Arquivos autorizados previstos

```text
supabase/
├── migrations/
│   └── 202608071120_knowledge_factory_schema.sql
└── tests/
    ├── knowledge_factory_schema.sql
    ├── knowledge_factory_rls.sql
    └── knowledge_factory_rollback.sql

docs/profeplan-knowledge-factory/
└── 00-governance/
    └── CONTINUITY-CHECKPOINT-009.md  # somente ao concluir a validação possível
```

## Gate preservado

- nenhuma aplicação em produção;
- nenhum adapter Supabase;
- nenhum vetor/retrieval;
- nenhuma alteração de contratos/domínio;
- nenhuma alteração em tabela ou policy legada;
- nenhum merge automático.
