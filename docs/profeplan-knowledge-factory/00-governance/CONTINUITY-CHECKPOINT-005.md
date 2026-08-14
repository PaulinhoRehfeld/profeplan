# Continuidade — Primeiro PR contract-first

## Status

**Primeiro Pull Request de código concluído tecnicamente e aguardando aprovação humana para merge.**

- repositório: `PaulinhoRehfeld/profeplan`;
- branch base: `main`;
- base aprovada: `c0b0fe19d8fceaf82475814bd8e7eff964837929`;
- branch de trabalho: `feat/knowledge-factory-contracts`;
- Pull Request: `#3 — feat(knowledge-factory): add versioned domain contracts and fixtures`;
- merge automático: proibido;
- dependências novas: nenhuma;
- migrations, banco, RLS, APIs, IA, agentes e frontend: não alterados.

## Objetivo concluído

Foi implementada a primeira fatia contract-first da ProfePlan Knowledge Factory em `packages/types`, contendo somente:

- contratos TypeScript puros e versionados;
- enumerações por constantes `as const` e tipos literais;
- funções puras para invariantes;
- fixtures exclusivamente sintéticas;
- exports estritamente aditivos;
- testes de invariantes com o runner nativo do Node 22;
- scripts locais de typecheck e testes sem dependências adicionais.

## Arquivos alterados

```text
packages/types/
├── package.json
├── tsconfig.json
├── src/
│   ├── index.ts
│   └── knowledge-factory/
│       ├── agent.ts
│       ├── common.ts
│       ├── curriculum.ts
│       ├── delivery.ts
│       ├── fixtures.ts
│       ├── index.ts
│       ├── opp.ts
│       ├── pedagogical.ts
│       ├── retrieval.ts
│       ├── source.ts
│       └── validation.ts
└── test/
    └── knowledge-factory.test.mjs

docs/profeplan-knowledge-factory/00-governance/
└── CONTINUITY-CHECKPOINT-005.md
```

## Contratos criados

### Base e versionamento

- `EntityId`;
- `ISODateTime`;
- `VersionTag`;
- `VersionedEntity`;
- versão pública inicial dos contratos;
- etapas, anos escolares e Estados curriculares suportados pelo contrato.

### Fontes e procedência

- `KnowledgeSource`;
- `SourceVersion`;
- `SourcePermissionEvent`;
- `SourceSegment`;
- tipos, status, licenças e usos permitidos.

### Conhecimento pedagógico

- `PedagogicalComponent`;
- `PedagogicalComponentVersion`;
- `EvidenceOrigin`;
- tipos e estados dos componentes semielaborados.

### Currículo

- `CurriculumPackage`;
- `CurriculumNode`;
- `CurriculumLink`;
- status e relações curriculares.

### Agentes

- `AgentScope`;
- `AgentProfile`;
- modos de escopo e permissões de ferramentas.

### Ordem de Produção Pedagógica

- `PedagogicalProductionOrder`;
- `OppEvent`;
- estados, eventos e transições permitidas.

### Recuperação

- `QueryFilters`;
- `QueryPlan`;
- `SufficiencyResult`;
- `ContextItem`;
- `ContextPackage`;
- razões tipadas de insuficiência.

### Validação

- `ValidationFinding`;
- `ValidationReport`;
- prioridades, estados e domínios de validação.

### Entrega

- `DeliveryTraceability`;
- `DeliveryContract`;
- payload de plano de aula;
- payload de texto didático;
- payload de atividade reflexiva;
- payload de avaliação formativa.

## Invariantes testadas

1. toda entidade versionável preserva identificador e versão;
2. serialização preserva identificadores e versões;
3. fonte bloqueada não pode ser recuperada;
4. licença restrita ou desconhecida bloqueia geração;
5. componente não aprovado não entra em produção;
6. componente aprovado exige evidência e vínculo curricular;
7. `QueryPlan` exige filtros determinísticos obrigatórios;
8. apenas um pacote curricular pode estar ativo no contexto avaliado;
9. Minas Gerais permanece o currículo do MVP;
10. Rio Grande do Sul permanece bloqueado;
11. `EPIC-018` permanece bloqueado;
12. transições inválidas da OPP são rejeitadas;
13. finding aberto de prioridade `must` bloqueia aprovação;
14. insuficiência não pode ser tratada como sucesso;
15. os quatro produtos preservam rastreabilidade;
16. serialização da entrega preserva OPP, identificadores e versões.

## Fixtures sintéticas

Foram criadas fixtures fictícias para:

- fonte e versão;
- segmento;
- pacote e nó curricular MG;
- componente pedagógico e evidência;
- perfil e escopo do Sócrates 2 inativo;
- OPP;
- QueryPlan;
- suficiência e contexto;
- finding;
- plano, texto, atividade e avaliação.

Nenhuma fixture utiliza material PNLD, conteúdo protegido, estudante real, escola real, credencial ou dado de produção.

## Tooling

Scripts adicionados a `@profeplan/types`:

```text
pnpm --filter @profeplan/types typecheck
pnpm --filter @profeplan/types test
```

O teste usa `node:test` e o type stripping nativo do Node 22. Nenhuma biblioteca foi adicionada.

## Validação executada

O workflow geral do Pull Request concluiu com sucesso:

- instalação;
- Prettier;
- ESLint;
- typecheck;
- build;
- testes.

As falhas preexistentes documentadas no Marco 004 permaneceram fora do escopo e não foram corrigidas silenciosamente.

## Itens deliberadamente não implementados

- persistência;
- banco, migrations e RLS;
- APIs e jobs;
- embeddings, dimensões, índices e reranking;
- providers ou modelos de IA;
- prompts e agentes executáveis;
- ativação do Sócrates 2;
- fontes reais ou PNLD;
- pacote curricular do Rio Grande do Sul;
- frontend;
- Gráfica e formatos avançados;
- correções gerais do monorepo.

## Rollback

O rollback é um revert simples do Pull Request:

- remover o export aditivo;
- remover os contratos, fixtures e testes;
- restaurar `packages/types/package.json` e `tsconfig.json`;
- nenhum dado, migration, tabela ou feature flag precisa ser restaurado.

## Próximo gate

Antes de qualquer lote posterior:

1. revisar o Pull Request nº 3;
2. aprovar ou solicitar ajustes;
3. somente após aprovação explícita, realizar o merge manual;
4. definir o próximo lote documental e técnico;
5. não iniciar persistência, retrieval, IA ou agentes sem nova autorização.

## Fork

O próximo fork deverá ocorrer somente após a decisão humana sobre o Pull Request nº 3 e a definição formal do lote seguinte.
