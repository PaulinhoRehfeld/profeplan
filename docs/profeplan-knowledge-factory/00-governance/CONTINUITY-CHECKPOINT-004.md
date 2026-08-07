# Continuidade — Marco 004, Lote 0

## Status

Lote 0 concluído documentalmente em 6 de agosto de 2026.

**Aguardando aprovação humana.**

Nenhum código de produto foi escrito. Nenhuma migration, tabela, RLS, dependência, embedding, modelo ou configuração de produção foi alterada.

## Repositório e branches

- repositório canônico: `PaulinhoRehfeld/profeplan`;
- branch base confirmada: `main`;
- commit base auditado: `a6e105ac4260adf7c314ff0338a9f7bbd13610b5`;
- branch documental do Lote 0: `docs/knowledge-factory-lot0`;
- branch proposta para o primeiro PR de código: `feat/knowledge-factory-contracts`.

A branch de código ainda não foi criada.

## Baseline técnico

### Stack

- Node.js 22;
- pnpm 11.5.2;
- TypeScript 5.8;
- Vite/React no app web;
- Vitest no web e agentes;
- Vercel como deploy efetivo do web/API;
- Supabase no produto;
- Prisma presente em pacote legado/excluído;
- Python nos pipelines de currículo e PNLD.

### CI geral

O último CI do commit base passou:

- instalação;
- Prettier;
- lint filtrado;
- typecheck filtrado;
- build filtrado;
- testes.

O verde é parcial porque exclui `apps/bff`, `packages/db`, `packages/ai` e `packages/auth` de lint, typecheck e build.

### CI de agentes

Está preexistente e vermelho. O workflow fixa pnpm 9 e o monorepo fixa pnpm 11.5.2. A falha ocorre antes de instalar dependências e executar testes.

## Falhas preexistentes principais

1. conflito de versão do pnpm no workflow de agentes;
2. referência residual a `docs/blueprint` sem `.gitmodules` válido;
3. módulos relevantes excluídos do CI geral;
4. BFF com teste stub;
5. IA sem suíte de testes declarada;
6. pacote de tipos sem scripts de validação;
7. pipelines Python sem CI identificado;
8. CD manual/legado;
9. `main` sem proteção e sem required checks;
10. deploy de agentes apenas como TODO;
11. instalação geral sem frozen lockfile;
12. scripts raiz diferentes do baseline filtrado;
13. acoplamento IA → DB legado;
14. coexistência de API Vercel e BFF Azure.

A lista detalhada está em `12-delivery/PREEXISTING-FAILURES.md`.

## Documentação sincronizada

A sincronização controlada foi feita a partir de:

- `PaulinhoRehfeld/profeplan_v5`;
- branch `docs/profeplan-knowledge-factory`;
- commit `cb36d71b1533fe7fa022c1aedca2c8790ab69692`.

Foram materializados no repositório canônico:

- visão geral;
- manifesto de sincronização;
- Decision Log;
- checkpoint do Marco 003;
- baseline do Lote 0;
- falhas preexistentes;
- mapa de módulos;
- relatório de gaps;
- escopo do primeiro PR;
- tarefa restrita para o Codex;
- este checkpoint.

O conteúdo integral não materializado byte a byte continua normativo no commit de origem, conforme `SYNC-MANIFEST.md`.

## Módulos de destino confirmados

### Primeiro PR

- `packages/types/src/knowledge-factory/`;
- export aditivo em `packages/types/src/index.ts`;
- tooling mínimo e isolado em `packages/types`, somente se autorizado.

### Lotes posteriores

- PNLD/procedência: `packages/industry-pnld`;
- currículo MG: `packages/industry-curriculum`;
- persistência/RLS: desenho posterior entre Supabase e `packages/db`;
- IA/ModelPolicy/retrieval: `packages/ai`, após saneamento e decisão;
- runtime e Sócrates 2: `packages/agents`;
- API operacional provável: `api/` Vercel;
- frontend: `apps/web`;
- observabilidade: `packages/logger` e infraestrutura existente;
- acabamento: `packages/graphics-profeplan`.

`apps/bff` não foi confirmado como destino operacional da Knowledge Factory.

## Conflitos arquitetônicos identificados

- contratos da Knowledge Factory ainda inexistentes;
- Zod está no frontend, não no pacote de tipos;
- pacote de tipos não possui tooling;
- duas superfícies de backend coexistem;
- Prisma legado e Supabase coexistem sem decisão física para a Knowledge Factory;
- agentes acessam SDKs diretamente, contrariando a ModelPolicy futura;
- quality gates existem, mas não estão calibrados e seu CI está quebrado;
- pipelines Python não estão integrados ao CI;
- não existe OPP canônica;
- não existe estado de insuficiência canônico;
- não existe contrato canônico de entrega e rastreabilidade.

## Primeiro PR proposto

Título:

`feat(knowledge-factory): add versioned domain contracts and fixtures`

Escopo:

- contratos e enums;
- fixtures sintéticas;
- testes de invariantes;
- exports aditivos;
- tooling mínimo do pacote, se aprovado.

Proibições:

- banco, migrations e RLS;
- APIs e jobs;
- agentes e prompts;
- providers e embeddings;
- fontes reais e PNLD;
- frontend;
- Gráfica;
- RS, novos agentes e disciplinas;
- refatoração ampla do monorepo.

## Stories com prontidão

Após aprovação deste Lote 0, as seguintes Stories poderão receber:

`Ready for Code — contract slice`

- US-001.1;
- US-001.2;
- US-002.1;
- US-002.2;
- US-004.1;
- US-004.2;
- US-010.1;
- US-014.1;
- US-015.1;
- US-016.1.

O status se aplica somente aos contratos e invariantes. As Stories de negócio continuarão parciais ou bloqueadas até seus lotes próprios.

## Critérios de aceite do primeiro PR

- alterações concentradas em `packages/types`;
- contratos versionados e API pública explícita;
- TypeScript strict;
- fixtures sintéticas;
- invariantes críticas testadas;
- nenhuma dependência nova sem aprovação;
- nenhuma migration ou mudança de comportamento;
- CI aplicável preservado;
- rollback por revert simples;
- falhas preexistentes não misturadas.

## Rollback

### Lote 0 documental

- fechar o PR sem merge;
- excluir a branch `docs/knowledge-factory-lot0`;
- nenhuma alteração permanece em `main`.

### Primeiro PR de código futuro

- revert simples;
- remoção de exports aditivos;
- nenhum dado, migration ou feature flag a restaurar.

## Decisão necessária

Aprovar ou rejeitar:

1. o baseline do Lote 0;
2. a sincronização documental controlada;
3. `packages/types` como destino do primeiro PR;
4. `api/` como superfície operacional provável para lotes posteriores;
5. não usar `apps/bff` como destino inicial;
6. a branch `feat/knowledge-factory-contracts`;
7. o escopo e os critérios do primeiro PR;
8. as dez Stories em `Ready for Code — contract slice`;
9. a tarefa restrita em `FIRST-PR-CODEX-TASK.md`.

## Fork

**Ainda não fazer o próximo fork.**

Primeiro é necessária aprovação humana deste Lote 0. Após aprovação, este checkpoint deverá ser atualizado para `aprovado`, e então será entregue a mensagem de continuidade e a autorização — ou não — para iniciar o primeiro PR contract-first.
