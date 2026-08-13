# Continuidade — Marco 004, Lote 0

## Status

**Marco 004 — Lote 0 aprovado integralmente em 6 de agosto de 2026, sem ressalvas.**

A aprovação humana confirmou o baseline, as falhas preexistentes, a sincronização documental, os módulos de destino, a branch e o escopo do primeiro PR contract-first.

Nenhum código de produto foi escrito durante o Lote 0. Nenhuma migration, tabela, RLS, dependência, embedding, modelo ou configuração de produção foi alterada.

## Repositório e branches

- repositório canônico: `PaulinhoRehfeld/profeplan`;
- branch base confirmada: `main`;
- commit base auditado: `a6e105ac4260adf7c314ff0338a9f7bbd13610b5`;
- branch documental do Lote 0: `docs/knowledge-factory-lot0`;
- Pull Request documental: `#2 — docs(knowledge-factory): complete Marco 004 Lot 0 baseline`;
- branch autorizada para o primeiro PR de código: `feat/knowledge-factory-contracts`;
- título autorizado: `feat(knowledge-factory): add versioned domain contracts and fixtures`.

A branch de código ainda não foi criada neste marco.

## Baseline técnico aprovado

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

O CI do commit base e o CI do Pull Request documental passaram no escopo ativo:

- instalação;
- Prettier;
- lint filtrado;
- typecheck filtrado;
- build filtrado;
- testes.

O verde é parcial porque exclui `apps/bff`, `packages/db`, `packages/ai` e `packages/auth` de lint, typecheck e build.

### CI de agentes

Permanece como falha preexistente. O workflow fixa pnpm 9 e o monorepo fixa pnpm 11.5.2. A falha ocorre antes de instalar dependências e executar testes.

## Falhas preexistentes aprovadas como baseline

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

Essas falhas não deverão ser corrigidas silenciosamente nem atribuídas à Knowledge Factory.

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

## Módulos de destino aprovados

### Primeiro PR

- `packages/types/src/knowledge-factory/`;
- export aditivo em `packages/types/src/index.ts`;
- tooling mínimo e isolado em `packages/types`, apenas dentro das regras autorizadas.

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

`apps/bff` não é destino inicial da Knowledge Factory.

## Primeiro PR autorizado

Objetivo único:

Adicionar contratos puros, versionados, fixtures sintéticas e testes de invariantes da ProfePlan Knowledge Factory em `packages/types`, sem implementar persistência, APIs, IA, agentes ou mudanças de comportamento.

### Conteúdo permitido

- contratos e enums;
- fixtures sintéticas;
- testes de invariantes;
- exports aditivos;
- scripts mínimos e configuração local de teste;
- documentação diretamente relacionada.

### Restrições absolutas

- banco, migrations e RLS;
- APIs e jobs;
- agentes e prompts;
- providers e embeddings;
- fontes reais e PNLD;
- frontend;
- Gráfica;
- Rio Grande do Sul;
- novos agentes e disciplinas;
- refatoração ampla do monorepo;
- correção silenciosa das falhas preexistentes.

Qualquer necessidade de nova dependência exige interrupção e nova autorização humana.

## Stories autorizadas

As seguintes Stories recebem o status:

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

O status se aplica somente aos contratos e invariantes. As Stories de negócio continuam parciais ou bloqueadas até seus lotes próprios.

## Critérios de aceite preservados

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

### Primeiro PR de código

- revert simples;
- remoção de exports aditivos;
- nenhum dado, migration ou feature flag a restaurar.

## Decisão formal

A aprovação total autoriza a abertura e execução do primeiro PR contract-first no próximo ciclo, usando a tarefa de `12-delivery/FIRST-PR-CODEX-TASK.md`.

Não autoriza lotes posteriores, banco, retrieval, embeddings, agentes executáveis, Sócrates 2 ativo ou expansão de escopo.

## Fork

**Este é o momento oficial do próximo fork.**

A próxima conversa deverá iniciar o primeiro PR de código, mantendo o escopo contract-first e parando imediatamente caso seja necessária nova dependência ou alteração fora de `packages/types`.

## Mensagem de continuidade

```text
Estamos continuando a ProfePlan Knowledge Factory no repositório `PaulinhoRehfeld/profeplan`.

Os Marcos 001, 002, 003 e o Marco 004 — Lote 0 foram aprovados integralmente.

Leia primeiro:

`docs/profeplan-knowledge-factory/00-governance/CONTINUITY-CHECKPOINT-004.md`

Leia também:

- `docs/profeplan-knowledge-factory/README.md`
- `docs/profeplan-knowledge-factory/SYNC-MANIFEST.md`
- `docs/profeplan-knowledge-factory/00-governance/DECISION-LOG.md`
- `docs/profeplan-knowledge-factory/12-delivery/LOT-0-BASELINE-REPORT.md`
- `docs/profeplan-knowledge-factory/12-delivery/PREEXISTING-FAILURES.md`
- `docs/profeplan-knowledge-factory/12-delivery/MODULE-DESTINATION-MAP.md`
- `docs/profeplan-knowledge-factory/12-delivery/ARCHITECTURE-CODE-GAP-REPORT.md`
- `docs/profeplan-knowledge-factory/12-delivery/FIRST-CODE-PR.md`
- `docs/profeplan-knowledge-factory/12-delivery/FIRST-PR-CODEX-TASK.md`

Branch base: `main`.

Crie a branch autorizada:

`feat/knowledge-factory-contracts`

Execute somente o primeiro PR contract-first autorizado.

Objetivo único: adicionar contratos puros, versionados, fixtures sintéticas e testes de invariantes da ProfePlan Knowledge Factory em `packages/types`, sem persistência, APIs, IA, agentes ou mudanças de comportamento.

Utilize esforço alto.

Antes de editar:

1. inspecione `packages/types`;
2. liste os arquivos que pretende criar ou alterar;
3. confirme o escopo do diff;
4. identifique qualquer necessidade de nova dependência;
5. pare e solicite autorização se nova dependência for necessária.

Não altere banco, migrations, RLS, `packages/db`, `packages/ai`, `packages/agents`, `apps/bff`, `apps/web`, `api/`, PNLD, currículo, embeddings, providers, prompts, agentes executáveis ou Gráfica.

Não corrija falhas preexistentes fora do escopo.

Execute e registre typecheck e testes específicos de `packages/types`, além do CI geral aplicável.

Não faça merge automático.

Ao final, apresente o diff, os contratos, as invariantes, os comandos executados, as falhas preexistentes observadas, o rollback e o resumo do Pull Request.
```
