# CONTINUITY CHECKPOINT 020 — Lote 3B.4A integrado à main

Data: 8 de agosto de 2026.

## Status

**O Lote 3B.4A — leituras do `PedagogicalComponentRepository` foi integrado à `main` por squash merge do Pull Request nº 17. A fatia integrada continua sendo somente o subconjunto read-only dos três métodos autorizados. O Lote 3B.4 completo não está concluído: `GAP-3B-02` e `GAP-3B-06` permanecem ativos e bloqueiam o 3B.4B. O Lote 3B.5 não foi iniciado.**

## Repositório e continuidade

Repositório:

`PaulinhoRehfeld/profeplan`

Branch padrão:

`main`

Branch documental deste checkpoint:

`agent/knowledge-factory-checkpoint-020`

Base confirmada desta branch:

`1c03d21590bf004489d0f4d07e42aaf29db44ac5`

A `main` não avançou após esse commit durante a inspeção que iniciou este checkpoint.

## Merge do Pull Request nº 17

Pull Request:

`feat(knowledge-factory): add pedagogical component read adapter`

URL:

https://github.com/PaulinhoRehfeld/profeplan/pull/17

Estado confirmado:

- fechado;
- integrado;
- não draft após a integração;
- método: squash merge;
- sem auto-merge.

Head final validado antes do merge:

`f68947b3b24895c51ed6108351d26c0563583176`

Commit resultante na `main`:

`1c03d21590bf004489d0f4d07e42aaf29db44ac5`

A `main` avançou por exatamente um squash commit em relação à base do PR, `d9680a4a53fea2b3884c5a62393f852265cbb54e`.

## Escopo efetivamente integrado

Foram integrados exclusivamente os três métodos de leitura:

- `findById(id)`;
- `findVersion(componentId, version)`;
- `listEvidenceOrigins(componentVersionId)`.

A implementação:

- usa `Pick<PedagogicalComponentRepository, ...>` para representar somente a capacidade read-only;
- recebe client SYSTEM por injeção;
- usa listas explícitas de colunas;
- aplica mappers SQL → domínio;
- hidrata integralmente `sourceEvidenceIds` e `curriculumNodeIds`;
- reconstrói `EvidenceOrigin`;
- mantém ordenação determinística;
- rejeita retorno parcial;
- diferencia ausência legítima, coleção vazia, resposta inválida e falha do provider;
- mantém erros provider-neutral e telemetria sanitizada.

Nenhum método de escrita, stub ou alegação de implementação integral da porta foi integrado.

## Arquivos integrados pelo squash

- `.github/workflows/knowledge-factory-db-ci.yml`;
- `docs/profeplan-knowledge-factory/00-governance/CONTINUITY-CHECKPOINT-019.md`;
- `packages/knowledge-factory-supabase/src/component/pedagogical-component.mapper.ts`;
- `packages/knowledge-factory-supabase/src/component/supabase-pedagogical-component.repository.ts`;
- `packages/knowledge-factory-supabase/src/index.ts`;
- `packages/knowledge-factory-supabase/test/fixtures/pedagogical-component.sql`;
- `packages/knowledge-factory-supabase/test/pedagogical-component.integration.test.mjs`;
- `packages/knowledge-factory-supabase/test/pedagogical-component.repository.test.mjs`.

## Evidências de validação do head final

### CI geral

- workflow: `CI Pipeline`;
- run ID: `31255893800`;
- run number: `236`;
- head: `f68947b3b24895c51ed6108351d26c0563583176`;
- conclusão: `SUCCESS`;
- instalação, Prettier, ESLint, TypeScript, build e testes: verdes.

### Knowledge Factory DB CI

- workflow: `Knowledge Factory DB CI`;
- run ID: `31255893768`;
- run number: `16`;
- head: `f68947b3b24895c51ed6108351d26c0563583176`;
- conclusão: `SUCCESS`;
- fixture sintética transacional: verde;
- integração do componente: `2/2`;
- integração acumulada dos adapters: `8/8`;
- schema, constraints, RLS, rollback, reaplicação e DB lint: verdes;
- stack descartável encerrado sem backup;
- artifact: `knowledge-factory-db-validation-31255893768`;
- digest: `sha256:03e7d0751b46eb447211cf6991c1a9fb3e4e85b4d1e0effe9a9657123164d954`.

### Vercel

- head final do PR: `SUCCESS`;
- commit pós-merge da `main`: `SUCCESS`;
- nenhuma configuração da Vercel foi alterada.

## Estado dos Lotes

- Lote 3B.1 — integrado;
- Lote 3B.2 — integrado;
- Lote 3B.3 — integrado;
- Lote 3B.4A — integrado;
- Lote 3B.4B — bloqueado e não iniciado;
- Lote 3B.4 completo — não concluído;
- Lote 3B.5 — não iniciado;
- Fase B — não concluída.

## Estado dos GAPs

- `GAP-3B-01`: encerrado após a integração do PR nº 15;
- `GAP-3B-02`: ativo; bloqueia atomicidade de componente, primeira versão e `currentVersionId`;
- `GAP-3B-03`: ativo; bloqueia transição atômica de OPP e evento;
- `GAP-3B-04`: ativo conforme lifecycle de fontes;
- `GAP-3B-05`: ativo conforme auditoria enriquecida;
- `GAP-3B-06`: ativo; bloqueia persistência integral de evidências e vínculos curriculares;
- nenhum gap novo foi identificado nesta consolidação.

## Atualização documental desta branch

Esta branch altera somente:

- `docs/profeplan-knowledge-factory/BLUEPRINT.md`, para refletir o estado real pós-merge;
- `docs/profeplan-knowledge-factory/00-governance/CONTINUITY-CHECKPOINT-020.md`, para registrar esta continuidade.

O `CONTINUITY-CHECKPOINT-019.md` permanece inalterado como evidência histórica do estado pré-merge do PR nº 17.

Pull Request documental:

`A registrar após a abertura do PR draft.`

## Fronteira preservada

Nesta consolidação documental não houve:

- alteração de código, contrato, adapter, mapper ou teste;
- migration, função PostgreSQL ou RPC;
- alteração de schema, constraint, índice, FK ou RLS;
- alteração de workflow ou lockfile;
- wiring em API ou frontend;
- acesso a Supabase de produção;
- uso de dados pedagógicos reais;
- início do Lote 3B.4B;
- início do Lote 3B.5;
- merge automático.

A fronteira de produção continua integralmente preservada.

## Próximo gate humano

O próximo gate é revisar o Pull Request documental deste checkpoint e decidir entre solicitar ajustes, rejeitar/adiar ou autorizar seu squash merge.

Somente depois da integração humana deste checkpoint, e mediante nova autorização explícita, poderá ser aberta uma etapa exclusivamente documental para definir a fronteira contratual e transacional do Lote 3B.4B.

Essa definição deverá tratar `GAP-3B-02` e `GAP-3B-06` sem antecipar código, migration, RPC, escrita ou Lote 3B.5.

## Próximo momento de fork

**Este checkpoint marca o próximo momento oficial de fork.**

A próxima conversa deverá iniciar pela leitura deste `CONTINUITY-CHECKPOINT-020.md`, pela confirmação do estado do PR documental e pelo gate humano correspondente.
