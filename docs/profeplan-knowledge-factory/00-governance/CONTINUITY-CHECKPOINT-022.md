# CONTINUITY CHECKPOINT 022 — Lote 3B.4B.1 contratos e porta

Data: 8 de agosto de 2026.

## Status

**O Lote 3B.4B.1 — contratos e porta foi implementado em branch isolada e está preparado para
revisão humana. Nenhuma migration, RPC ou escrita Supabase foi implementada. `GAP-3B-02` e
`GAP-3B-06` permanecem ativos.**

## Repositório e continuidade

- repositório: `PaulinhoRehfeld/profeplan`;
- branch padrão: `main`;
- branch técnica: `agent/knowledge-factory-lot-3b4b1-contracts-port`;
- base e merge-base esperados: `d9838ef290522aba6dba4e104a03420dd12192fb`;
- definição governante: `12-delivery/LOT-3B4B-COMPONENT-WRITE-BOUNDARY-DEFINITION.md`;
- Pull Request nº 20: https://github.com/PaulinhoRehfeld/profeplan/pull/20;
- estado inicial exigido: draft;
- head técnico inicial: `e09290732f1dc106f0002d3277f43b8a418be720`.

## Escopo implementado

### Contrato compartilhado 2.0.0

- `KNOWLEDGE_FACTORY_CONTRACT_VERSION` elevado de `1.1.0` para `2.0.0`;
- quatro operações de escrita provider-neutral publicadas;
- quatro comandos explícitos publicados;
- recibo de escrita provider-neutral publicado;
- propriedades dos comandos e do recibo declaradas `readonly`;
- componente, versão e evidências recebidos como snapshots somente leitura;
- lista de operações congelada em runtime.

### Porta de domínio

- `PedagogicalComponentReadRepository` criado com somente as três leituras existentes;
- `PedagogicalComponentCommandRepository` criado com somente os quatro comandos aprovados;
- `PedagogicalComponentRepository` passa a compor as duas capacidades;
- `saveComponent()` e `saveVersion()` removidos sem aliases, overloads, stubs ou depreciação;
- cada comando retorna `PedagogicalComponentWriteReceipt`.

### Compatibilidade do 3B.4A

- o adapter Supabase read-only agora implementa diretamente
  `PedagogicalComponentReadRepository`;
- nenhum método, query, mapper, coluna, erro ou comportamento de runtime do adapter foi alterado;
- a superfície do adapter continua limitada a `findById`, `findVersion` e
  `listEvidenceOrigins`.

### Provas contratuais

- type tests cobrem as superfícies exatas de leitura, comando e composição;
- type tests provam a imutabilidade dos comandos, snapshots e recibo;
- type tests provam a ausência dos dois métodos genéricos removidos;
- teste de runtime valida a versão `2.0.0`, as quatro operações e o congelamento da lista;
- typecheck acumulado comprova que não existe consumidor operacional dos `save*` removidos.

## Arquivos do sublote

- `packages/types/src/knowledge-factory/common.ts`;
- `packages/types/src/knowledge-factory/pedagogical.ts`;
- `packages/types/test/knowledge-factory.test.mjs`;
- `packages/knowledge-factory/src/repositories/pedagogical-component.repository.ts`;
- `packages/knowledge-factory/type-tests/pedagogical-component.repository.type-test.ts`;
- `packages/knowledge-factory/tsconfig.json`;
- `packages/knowledge-factory-supabase/src/component/supabase-pedagogical-component.repository.ts`;
- `packages/knowledge-factory-supabase/test/pedagogical-component.repository.test.mjs`;
- `docs/profeplan-knowledge-factory/BLUEPRINT.md`;
- `docs/profeplan-knowledge-factory/12-delivery/LOT-3B4B-COMPONENT-WRITE-BOUNDARY-DEFINITION.md`;
- `docs/profeplan-knowledge-factory/00-governance/CONTINUITY-CHECKPOINT-022.md`.

## Validações específicas

- `@profeplan/types`: typecheck verde e 12/12 testes;
- `@profeplan/knowledge-factory`: typecheck verde e 21/21 testes;
- `@profeplan/knowledge-factory-supabase`: typecheck verde e 95/95 testes;
- formatter do CI e formatação dos arquivos novos: verdes;
- lint, typecheck, build e suíte geral equivalentes ao CI: verdes;
- `@profeplan/agents`: 178/178 testes acumulados;
- `apps/web`: 87/87 testes acumulados;
- lockfile e manifestos: sem alteração;
- integração de banco: não aplicável, pois não há SQL, migration, RPC ou DML.

Os gates gerais e remotos deverão ser registrados após o commit final e a abertura do PR draft.

## Estado dos GAPs

### GAP-3B-02

Permanece ativo. O contrato agora expressa o agregado e as expectativas de concorrência, mas a
atomicidade PostgreSQL ainda depende do 3B.4B.2 e do adapter exclusivo por RPC do 3B.4B.3.

### GAP-3B-06

Permanece ativo. A superfície contratual passa a transportar `EvidenceOrigin` completo e vínculos
versionados sem side-channel, mas o encerramento ainda exige integração do adapter transacional.

## Itens expressamente ausentes

- migration, SQL, função PostgreSQL ou RPC;
- tabela de recibos, constraint, índice, grant, policy ou alteração de RLS;
- adapter Supabase de comando, mapper de escrita ou DML direto;
- alteração de erro provider-neutral ou telemetria;
- dependência, manifesto ou lockfile;
- API, frontend, composition root ou wiring;
- acesso a Supabase hospedado, secrets ou dados reais;
- integração ou escrita em produção;
- 3B.4B.2, 3B.4B.3 ou Lote 3B.5;
- encerramento de GAP ou da Fase B;
- merge ou auto-merge.

## Próximo gate humano

Revisar o Pull Request draft do 3B.4B.1 e autorizar — ou não — sua integração controlada.

Mesmo se este sublote for integrado, o 3B.4B.2 permanecerá bloqueado até nova autorização
explícita. Nenhuma continuidade implícita autoriza migration, RPC, banco ou produção.
