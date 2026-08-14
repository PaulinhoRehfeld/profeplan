# CONTINUITY CHECKPOINT 019 — Lote 3B.4A pronto para revisão

Data: 8 de agosto de 2026.

## Status

**A fatia `Lote 3B.4A — leituras do PedagogicalComponentRepository` foi implementada e validada localmente e no Supabase descartável. O Pull Request nº 17 permanece em draft, sem merge ou auto-merge. A implementação representa somente o `Pick` read-only dos três métodos autorizados; nenhuma escrita foi implementada. `GAP-3B-02` e `GAP-3B-06` continuam ativos e bloqueiam o Lote 3B.4B.**

## Repositório e Pull Request

Repositório:

`PaulinhoRehfeld/profeplan`

Branch:

`agent/knowledge-factory-lot-3b4a-read-adapter`

Pull Request:

`#17 — feat(knowledge-factory): add pedagogical component read adapter`

URL:

`https://github.com/PaulinhoRehfeld/profeplan/pull/17`

Estado:

- aberto;
- draft;
- base `main`;
- mergeável e sem conflitos no head técnico validado;
- sem merge automático;
- nenhuma integração autorizada nesta conversa.

Base e merge-base validados:

`d9680a4a53fea2b3884c5a62393f852265cbb54e`

Head técnico remoto validado antes deste checkpoint:

`75ef08a487a65342310261c0166958d7d48d2e59`

Commit local equivalente:

`aa7dd90c481fd41dcb963a957989c39c11381a04`

As árvores Git local e remota são idênticas:

`17b6627657bc1df4b2bd0feee8133b9124ed9449`

O SHA do head final que contém este próprio checkpoint somente existe depois da criação do commit documental. Por isso, sem inventar uma auto-referência criptograficamente impossível, o SHA final deverá ser revalidado após a publicação deste arquivo e registrado na descrição do PR e no handoff da conversa.

## Escopo implementado

Classe concreta:

`SupabasePedagogicalComponentReadRepository`

Conformidade estrutural:

```ts
Pick<PedagogicalComponentRepository, 'findById' | 'findVersion' | 'listEvidenceOrigins'>;
```

Métodos implementados:

1. `findById(id)`;
2. `findVersion(componentId, version)`;
3. `listEvidenceOrigins(componentVersionId)`.

Não existem no adapter:

- `saveComponent()`;
- `saveVersion()`;
- stub de escrita;
- método auxiliar público;
- alegação de implementação integral da porta completa.

## Mappers e reconstrução do domínio

Foi criado o mapper explícito:

`src/component/pedagogical-component.mapper.ts`

Ele reconstrói e valida:

- `PedagogicalComponent`;
- `PedagogicalComponentVersion`;
- `EvidenceOrigin`;
- IDs de evidência;
- IDs de nós curriculares;
- enums;
- grades;
- strings obrigatórias;
- arrays;
- opcionais;
- timestamps ISO válidos.

Respostas nulas, arrays onde se espera linha única, listas nulas, IDs vazios, enums inválidos, opcionais incompatíveis ou timestamps impossíveis geram `INVALID_RESPONSE` provider-neutral.

## Consultas e hidratação

### `findById(id)`

- tabela `kf_pedagogical_components`;
- lista explícita de onze colunas;
- filtro obrigatório por `id`;
- ausência legítima retorna `null`;
- resposta múltipla ou estruturalmente inválida falha.

### `findVersion(componentId, version)`

- tabela-base `kf_component_versions`;
- filtros obrigatórios por `component_id` e `version`;
- hidratação de `sourceEvidenceIds` em `kf_component_source_evidence`;
- IDs de evidência ordenados por `id` ascendente;
- hidratação de `curriculumNodeIds` em `kf_component_curriculum_links`;
- IDs curriculares ordenados por `curriculum_node_id` ascendente;
- arrays vazios aceitos apenas para listas vazias reais do provider;
- falha ou shape inválido em qualquer hidratação rejeita o método inteiro;
- nenhuma versão parcial é devolvida;
- ausência da linha-base retorna `null` e não inicia hidratações.

As leituras são sequenciais, sem promessa de snapshot PostgreSQL forte. Nenhuma RPC ou read model foi criado.

### `listEvidenceOrigins(componentVersionId)`

- tabela `kf_component_source_evidence`;
- filtro obrigatório por `component_version_id`;
- oito colunas explícitas;
- ordenação por `recorded_at` e `id`, ambos ascendentes;
- reconstrução integral de `EvidenceOrigin`;
- lista vazia somente quando o provider retorna `[]` sem erro;
- falha e resposta inválida não são convertidas em coleção vazia.

## Client, erros e telemetria

- client SYSTEM recebido exclusivamente por `SupabaseSystemContext` injetado;
- nenhum `createClient()` no adapter;
- nenhuma leitura de `process.env` no adapter;
- nenhum import de `api/` ou `supabaseAdmin`;
- nenhum client REQUESTER usado;
- nenhuma mensagem bruta do Supabase/PostgREST atravessa a borda;
- `PGRST116` em consulta logicamente única é tratado como cardinalidade inválida, não como ausência silenciosa;
- telemetria registra somente a allowlist aprovada;
- nenhum título, resumo, keyword, conteúdo, lote de IDs, payload, secret, JWT ou erro bruto é registrado.

## Testes implementados

### Unitários sem rede

Foram adicionados 25 testes ao pacote Supabase. Cobertura comprovada:

- mapeamento dos três contratos;
- opcionais;
- arrays vazios legítimos;
- enums, IDs, grades e timestamps inválidos;
- filtros, tabelas e colunas explícitas;
- ordenações determinísticas;
- ausência legítima nos dois métodos `find*`;
- ausência sem hidratação desnecessária;
- hidratação integral dos dois conjuntos de IDs;
- falha do provider em cada hidratação;
- shape inválido em cada hidratação;
- proibição de retorno parcial;
- lista vazia de evidências;
- resposta nula ou malformada;
- erros provider-neutral;
- timeout e falha de rede;
- telemetria allowlisted e sanitizada;
- uso do client injetado;
- superfície pública restrita ao `Pick` read-only;
- ausência de escrita, RPC, env, client interno, `any` generalizado e `SELECT *`.

Suíte unitária acumulada do pacote:

`95/95` testes verdes.

### Integração descartável

Foi criada uma fixture SQL exclusivamente sintética porque a FK circular `current_version_id` exige uma transação PostgreSQL com constraint diferida. A fixture é executada pelo `psql` administrativo já existente no `Knowledge Factory DB CI`; ela não pertence ao adapter e não é migration.

Os dois testes novos comprovam:

- leitura de componente existente;
- ausência de componente;
- leitura de versão existente;
- ausência de versão;
- evidências vinculadas reais e ordenadas;
- vínculos curriculares reais e ordenados;
- versão sem vínculos com arrays vazios;
- reconstrução real e isolada de `EvidenceOrigin`;
- desempate por `recorded_at` e `id`;
- ausência de vazamento de outro componente;
- contagens inalteradas antes e depois das leituras do adapter;
- FK real rejeitando fixture administrativa inválida;
- acesso pelo client SYSTEM local descartável.

Integração acumulada dos adapters:

`8/8` testes verdes:

- AuditRepository: `2/2`;
- KnowledgeSourceRepository: `2/2`;
- CurriculumRepository: `2/2`;
- PedagogicalComponent read adapter: `2/2`.

## Validações executadas

### Local

- `git diff --check`: verde;
- Prettier do código ativo e dos arquivos novos: verde;
- ESLint no filtro oficial do CI: verde;
- TypeScript no filtro oficial do CI: verde;
- typecheck próprio do pacote: verde;
- build no filtro oficial do CI: verde;
- testes unitários do pacote: `95/95` verdes;
- suíte geral do monorepo: verde;
- árvore de trabalho limpa após o commit técnico;
- lockfile inalterado;
- nenhuma dependência adicionada.

O ambiente local utilizou Node 24 e pnpm 11.16.0. O CI oficial abaixo confirmou o conteúdo com Node 22 e pnpm 11.5.2.

### CI geral

- workflow: `CI Pipeline`;
- run ID: `31255639000`;
- run number: `235`;
- head: `75ef08a487a65342310261c0166958d7d48d2e59`;
- conclusão: `SUCCESS`;
- instalação, Prettier, ESLint, TypeScript, build e testes: verdes.

### Knowledge Factory DB CI

- workflow: `Knowledge Factory DB CI`;
- run ID: `31255639007`;
- run number: `15`;
- head: `75ef08a487a65342310261c0166958d7d48d2e59`;
- conclusão: `SUCCESS`;
- Supabase descartável, schema, constraints, RLS, rollback, reaplicação, fixture sintética, integração TypeScript, DB lint, artifact e destruição: verdes;
- artifact: `knowledge-factory-db-validation-31255639007`;
- artifact ID: `9021321370`;
- digest: `sha256:557fa24a97296c8f83df45f35b716ac3a73b784e11d82dfcad8ee388b8aa1657`.

### Vercel

- status do head técnico: `SUCCESS`;
- nenhuma configuração foi alterada;
- nenhuma falha funcional relacionada ao adapter.

## Arquivos modificados

- `.github/workflows/knowledge-factory-db-ci.yml`;
- `packages/knowledge-factory-supabase/src/component/pedagogical-component.mapper.ts`;
- `packages/knowledge-factory-supabase/src/component/supabase-pedagogical-component.repository.ts`;
- `packages/knowledge-factory-supabase/src/index.ts`;
- `packages/knowledge-factory-supabase/test/fixtures/pedagogical-component.sql`;
- `packages/knowledge-factory-supabase/test/pedagogical-component.integration.test.mjs`;
- `packages/knowledge-factory-supabase/test/pedagogical-component.repository.test.mjs`;
- este `CONTINUITY-CHECKPOINT-019.md`.

Nenhuma migration, contrato de domínio, porta, package manifest, lockfile, schema, constraint, índice, FK, RLS, API, frontend ou configuração de produção foi alterado.

## GAPs e Stories

- `GAP-3B-01`: encerrado desde a integração humana do PR nº 15;
- `GAP-3B-02`: ativo; continua bloqueando escrita transacional de componente e versão;
- `GAP-3B-03`: ativo conforme escopo de OPP;
- `GAP-3B-04`: ativo conforme lifecycle de fonte;
- `GAP-3B-05`: ativo conforme auditoria enriquecida;
- `GAP-3B-06`: ativo; continua bloqueando persistência integral de evidências e vínculos;
- nenhum gap novo foi identificado.

O adapter fornece infraestrutura parcial para US-004.1, US-004.2 e US-004.3, sem conceder `Done` integral a qualquer Story.

- o Lote 3B.4A está pronto somente para revisão humana;
- o Lote 3B.4 completo não está concluído;
- o Lote 3B.4B não foi iniciado;
- o Lote 3B.5 não foi iniciado;
- a Fase B não está concluída.

## Segurança e fronteira de produção

- nenhum secret real foi solicitado, exibido ou versionado;
- somente chave local descartável, capturada e mascarada no workflow;
- nenhum project ref, URL hospedada, usuário ou dado real;
- nenhum Supabase hospedado ou produção acessado;
- nenhuma migration, função PostgreSQL, RPC ou RLS;
- nenhuma escrita no adapter;
- nenhuma API, frontend ou consumidor recebeu wiring;
- nenhuma fonte, currículo ou componente pedagógico real;
- nenhum PNLD, retrieval, embedding, agente ou Sócrates 2 executável;
- nenhuma integração de produção foi autorizada.

## Próximo gate humano

Depois da publicação deste checkpoint e da revalidação dos checks associados ao novo SHA final, o próximo gate é revisar o Pull Request nº 17 e decidir entre:

1. solicitar ajustes;
2. rejeitar ou adiar;
3. autorizar integração controlada por squash merge em conversa própria.

Mesmo com todos os checks verdes, não realizar merge automático.

## Próximo momento de fork

**Este checkpoint marca o próximo momento oficial de fork.**

A próxima conversa deverá começar pela leitura deste checkpoint, pela revisão do Pull Request nº 17 e pela decisão humana explícita sobre sua integração. O Lote 3B.4B, o Lote 3B.5 e produção permanecem bloqueados.
