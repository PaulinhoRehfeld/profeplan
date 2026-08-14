# Continuidade — Aprovação do Lote 3 e preparação do Lote 3A

## Status

**Lote 3 documental aprovado integralmente. ADR-033 a ADR-039 aprovadas. Lote 3A definido documentalmente. Nenhuma migration criada ou aplicada. Lote 3B permanece bloqueado.**

Data: 7 de agosto de 2026.

## Repositório

`PaulinhoRehfeld/profeplan`

## Base aprovada

`main` após o merge do Lote 2 no commit:

`738255844d95abbb698ee3621707dbbeb228ec58`

## Pull Request documental

PR nº 6:

`docs(knowledge-factory): define lot 3 persistence and RLS`

Branch:

`docs/knowledge-factory-lot3-definition`

## Decisões aprovadas

### ADR-033

Supabase SQL em `supabase/migrations/` é a fonte física canônica da Knowledge Factory. Não haverá duplicação das tabelas `kf_*` em Prisma neste lote.

### ADR-034

As tabelas serão `public.kf_*`, com RLS, grants explícitos e deny-by-default.

### ADR-035

Adapters concretos Supabase ficarão em pacote separado, mantendo `@profeplan/knowledge-factory` puro. O Lote 3 foi dividido em 3A e 3B.

### ADR-036

No MVP individual, OPP é isolada por `requester_id = auth.uid()`. Não será criada tabela tenant nem `school_id` será promovido a tenant universal.

### ADR-037

Vetores, embeddings, full-text, IVFFlat, HNSW, reranking e retrieval não fazem parte do Lote 3.

### ADR-038

Merge da migration e aplicação no Supabase de produção são autorizações humanas independentes.

### ADR-039

Eventos de permissão, OPP e auditoria são append-only em uso normal.

## Modelo físico aprovado

O Lote 3A poderá criar exclusivamente as 15 tabelas `kf_*` definidas em:

`docs/profeplan-knowledge-factory/09-data/LOT-3-PHYSICAL-DATA-MODEL.md`

Nenhuma tabela legada será alterada ou migrada automaticamente.

`curriculum_rag` é legado e não é schema canônico da Knowledge Factory.

## Segurança aprovada

- `anon`: sem acesso às tabelas `kf_*`;
- professor autenticado: somente suas próprias OPPs, via RLS;
- corpus global: sem leitura direta por professor;
- manager/school_admin: sem poder global automático de curadoria;
- admin: acesso mínimo somente se puder ser implementado com segurança e sem recursão RLS;
- service role: apenas backend/jobs futuros, nunca frontend;
- eventos históricos: append-only.

## Lote 3A

Definição completa em:

`docs/profeplan-knowledge-factory/12-delivery/LOT-3A-DEFINITION.md`

### Objetivo

Criar schema, constraints, RLS, proteção append-only e testes de isolamento, sem conectar a aplicação ao banco novo.

### Branch prevista

`feat/knowledge-factory-persistence-schema`

### PR previsto

`feat(knowledge-factory): add persistence schema and RLS foundation`

### Mudanças autorizáveis no próximo ciclo

Primariamente:

- migration SQL nova em `supabase/migrations/`;
- testes SQL/sintéticos do schema e RLS;
- documentação/checkpoint.

### Continuam proibidos

- aplicação da migration em produção;
- adapters Supabase;
- alterações em `@profeplan/types`;
- alterações em `@profeplan/knowledge-factory`;
- API;
- frontend;
- agentes;
- IA;
- OpenAI;
- embeddings;
- pgvector da Knowledge Factory;
- full-text retrieval;
- PNLD real;
- currículo MG real;
- currículo RS;
- Sócrates 2 executável;
- EPIC-018;
- Gráfica.

## Gate de parada

O trabalho do Lote 3A deverá interromper e pedir nova decisão humana se encontrar:

- conflito com schema/migration existente;
- necessidade de alterar contratos/domínio;
- RLS insegura ou recursiva;
- necessidade de privilégios amplos;
- necessidade de nova dependência;
- ausência de ambiente seguro para testar isolamento;
- necessidade de tocar tabelas legadas;
- tentativa de incorporar retrieval/vetores;
- necessidade de aplicar em produção.

## Gate de produção

**Não autorizado.**

Mesmo que o futuro PR 3A seja aprovado e merged, a aplicação no Supabase de produção exigirá uma autorização humana distinta após evidências de teste em ambiente não produtivo e ensaio de rollback.

## Próximo passo

1. integrar o PR documental nº 6 após CI verde;
2. realizar fork de continuidade antes da implementação do Lote 3A;
3. no novo ciclo, criar `feat/knowledge-factory-persistence-schema` a partir da `main` integrada;
4. inspecionar migrations/schema atuais antes de escrever SQL;
5. produzir migration e testes somente dentro do escopo do Lote 3A;
6. não realizar merge nem aplicação em produção sem aprovação humana explícita.

## Próximo fork

Este checkpoint é o ponto de entrada do próximo fork. O novo chat deve iniciar pela leitura deste documento e do `LOT-3A-DEFINITION.md`.
