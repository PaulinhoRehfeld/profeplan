# Decision Log

## Convenção

- Status: proposto, aprovado, substituído ou rejeitado.
- Toda decisão técnica relevante deve registrar contexto, decisão, consequências e riscos.

## ADR-001 — Escopo educacional

**Status:** aprovado

O ProfePlan atenderá apenas Ensino Fundamental II e Ensino Médio nesta fase.

## ADR-002 — Especialização dos agentes

**Status:** aprovado

Os perfis de agentes serão especializados por componente curricular, etapa e ano.

## ADR-003 — Currículos estaduais plugáveis

**Status:** aprovado

Currículos estaduais serão pacotes versionados carregados conforme o contexto do professor.

## ADR-004 — Mesmo agente para MG e RS

**Status:** aprovado

O mesmo agente poderá operar com Minas Gerais ou Rio Grande do Sul. Não haverá duplicação por Estado.

## ADR-005 — Componentes pedagógicos semielaborados

**Status:** aprovado

As fontes serão transformadas em componentes estruturados. O almoxarifado não armazenará apenas páginas brutas nem apenas produtos finalizados.

## ADR-006 — Filtros antes da busca vetorial

**Status:** aprovado

A recuperação aplicará filtros por componente, etapa, ano, currículo, finalidade, licença e status de validação antes da similaridade semântica.

## ADR-007 — Piloto Sócrates 2

**Status:** aprovado

O primeiro experimento será Filosofia do 2º ano do Ensino Médio, inicialmente com currículo de Minas Gerais.

## ADR-008 — Produção separada da Gráfica

**Status:** aprovado

Agentes pedagógicos produzem e validam o conteúdo. A Gráfica realiza acabamento editorial e exportação.

## ADR-009 — Documentação antes do código

**Status:** aprovado

Nenhuma implementação será iniciada antes da aprovação dos documentos essenciais.

## ADR-010 — Infraestrutura comum, perfis especializados

**Status:** aprovado

Sócrates 2 e os demais especialistas serão configurações sobre uma infraestrutura comum.

## ADR-011 — Continuidade por marcos e forks controlados

**Status:** aprovado

A continuidade do projeto será feita por marcos documentais e checkpoints versionados.

## ADR-012 — Epics selecionados para o MVP

**Status:** aprovado no Marco 002

EPIC-001 a EPIC-017 participam do MVP em escopo reduzido. EPIC-018 permanece fora do MVP.

## ADR-013 — Priorização MoSCoW e preservação dos gates

**Status:** aprovado no Marco 002

Should e Could serão adiadas antes de reduzir gates jurídicos, pedagógicos, curriculares, autorais, inclusivos ou de rastreabilidade.

## ADR-014 — Aprovação baseada em evidências não compensatórias

**Status:** aprovado no Marco 002

Falhas críticas não podem ser compensadas por criatividade, velocidade ou baixo custo.

## ADR-015 — Repositório canônico da implementação

**Status:** aprovado no Marco 003

`PaulinhoRehfeld/profeplan` é o repositório canônico da implementação. A documentação aprovada nos Marcos 001–003 será sincronizada de forma controlada no Lote 0.

## ADR-016 — Reutilização modular do monorepo

**Status:** aprovado no Marco 003

A Knowledge Factory será distribuída pelos módulos responsáveis — types, industry-pnld, industry-curriculum, db, ai, agents, bff, web e observabilidade.

## ADR-017 — Implementação em ondas verticais

**Status:** aprovado no Marco 003

A implementação seguirá ondas cumulativas, com capacidade testável e gate de saída.

## ADR-018 — Fronteiras síncronas e assíncronas

**Status:** aprovado no Marco 003

Ingestão, segmentação, embeddings e avaliações em lote serão assíncronos; OPP, retrieval, geração, gates e entrega serão predominantemente síncronos no MVP.

## ADR-019 — Contract-first

**Status:** aprovado no Marco 003

Contratos compartilhados e testes precederão persistência, APIs, modelos e agentes.

## ADR-020 — Recuperação híbrida filtrada

**Status:** aprovado no Marco 003

Filtros determinísticos serão aplicados antes das buscas lexical e semântica, com estado explícito de insuficiência.

## ADR-021 — Escolhas de retrieval orientadas por experimentos

**Status:** aprovado no Marco 003

Embedding, dimensão, índice, fusão, reranker, orçamento e cache serão escolhidos por experimento reproduzível.

## ADR-022 — Corpus compartilhado sem leitura pública direta

**Status:** aprovado no Marco 003

Conhecimento global será acessado por serviços autorizados. Licença, status, perfil do agente e escopo participam da autorização.

## ADR-023 — Quality gates calibrados e não compensatórios

**Status:** aprovado no Marco 003

Validadores existentes só entram no pipeline obrigatório após avaliação contra casos dourados.

## ADR-024 — ModelPolicy e observabilidade por OPP

**Status:** aprovado no Marco 003

Agentes não acessam SDKs de provedor diretamente. Modelos, limites, retry e fallback são resolvidos por política versionada.

## ADR-025 — Baseline justo e piloto controlado

**Status:** aprovado no Marco 003

A avaliação usa casos dourados, execução pareada e baseline genérico justo.

## ADR-026 — Sócrates 2 como perfil do runtime comum

**Status:** aprovado no Marco 003

Sócrates 2 será um perfil versionado, não um agente duplicado por Estado ou ano.

## ADR-027 — Primeiro PR de código contract-first

**Status:** aprovado no Marco 003

O primeiro PR de código conterá somente contratos, enums, fixtures e testes, sem banco, migrations, IA, API ou mudança de comportamento.

## ADR-028 — Aprovação do Lote 0 e autorização da fatia contratual

**Status:** aprovado no Marco 004

O baseline técnico, a sincronização documental controlada, o mapa de módulos, as falhas preexistentes, a branch `feat/knowledge-factory-contracts`, o escopo do primeiro PR e a tarefa restrita para o Codex foram aprovados integralmente.

O primeiro PR será implementado em `packages/types`, com contratos versionados, enums, fixtures sintéticas, testes de invariantes e exports aditivos.

Nova dependência, alteração fora do escopo autorizado, persistência, API, IA, agentes, embeddings, PNLD real, currículo RS ou mudança de comportamento exigem nova autorização humana.

As Stories US-001.1, US-001.2, US-002.1, US-002.2, US-004.1, US-004.2, US-010.1, US-014.1, US-015.1 e US-016.1 recebem `Ready for Code — contract slice`.

## ADR-029 — Pacote dedicado ao domínio da Knowledge Factory

**Status:** aprovado para o Lote 2

As regras de negócio da Knowledge Factory serão implementadas em um pacote dedicado `@profeplan/knowledge-factory`, separado de `@profeplan/types`.

O novo pacote dependerá dos contratos de `@profeplan/types` e não dependerá de DB, IA, agents, API, frontend ou providers externos.

Consequências:

- `@profeplan/types` permanece como contrato compartilhado;
- políticas e ciclo de vida ficam coesos em uma camada de domínio própria;
- banco, agentes e APIs poderão reutilizar o domínio sem dependência circular;
- criação de novo workspace exige CI e scripts próprios mínimos;
- nenhuma dependência externa nova será adicionada sem autorização humana.

## ADR-030 — Repositórios como portas, não adapters concretos

**Status:** aprovado para o Lote 2

O Lote 2 criará interfaces abstratas de repositório orientadas ao domínio. Implementações Supabase, PostgreSQL, Prisma ou outras serão proibidas até o Lote 3.

As portas não poderão expor SQL, nomes de tabela, clients de provider, vetores ou HTTP.

## ADR-031 — Domínio puro, determinístico e sem I/O

**Status:** aprovado para o Lote 2

Políticas do Lote 2 serão puras, determinísticas, sem estado global e sem acesso a rede, filesystem, banco ou provider.

Decisões de elegibilidade, ciclo de vida, escopo e OPP deverão ser testáveis apenas com contratos e fixtures sintéticas.

## ADR-032 — Dependência de contratos somente em tempo de compilação no Lote 2

**Status:** aprovado em 7 de agosto de 2026, antes do merge do PR nº 5

Durante a implementação do Lote 2 verificou-se que todos os usos de `@profeplan/types` no novo pacote são exclusivamente `import type`. A declaração inicial `@profeplan/types: workspace:*` no `package.json` exigia atualizar o importer do novo workspace no `pnpm-lock.yaml`, embora nenhum símbolo de runtime fosse consumido.

Decisão aprovada:

- `@profeplan/knowledge-factory` não declarará dependência de runtime/package-manager em `@profeplan/types` no Lote 2;
- os contratos serão resolvidos em tempo de compilação pelo alias `@profeplan/types` já definido no `tsconfig.base.json` do monorepo;
- todos os imports de contratos permanecerão `import type`;
- `pnpm-lock.yaml` permanecerá inalterado;
- se lote posterior exigir símbolo de runtime de `@profeplan/types`, a dependência explícita deverá ser reavaliada e documentada.

Consequências:

- domínio permanece sem dependências de runtime;
- lockfile não recebe alteração sem necessidade funcional;
- typecheck continua validando integralmente os contratos;
- reduz-se acoplamento entre pacotes no Lote 2;
- existe dependência arquitetônica de compilação, embora não exista dependência de runtime;
- a decisão deve ser revista caso a política de build/package publication do monorepo mude.

## ADR-033 — SQL Supabase como persistência canônica da Knowledge Factory

**Status:** aprovado para o Lote 3 em 7 de agosto de 2026

A Knowledge Factory usará migrations SQL em `supabase/migrations/` como fonte física de verdade. As tabelas `kf_*` não serão duplicadas em Prisma neste lote.

## ADR-034 — Tabelas `public.kf_*` com deny-by-default

**Status:** aprovado para o Lote 3 em 7 de agosto de 2026

O schema físico inicial usará `public.kf_*`, grants explícitos, RLS e corpus global sem leitura direta de professor.

## ADR-035 — Adapter Supabase em pacote separado

**Status:** aprovado para o Lote 3 em 7 de agosto de 2026

Adapters concretos serão implementados posteriormente em `@profeplan/knowledge-factory-supabase`. O Lote 3 fica dividido em 3A (schema/RLS) e 3B (adapters).

## ADR-036 — Isolamento do MVP por requester, sem inventar tenant novo

**Status:** aprovado para o Lote 3 em 7 de agosto de 2026

No MVP individual, OPPs serão isoladas por `requester_id = auth.uid()`. Não será criada tabela tenant nem `school_id` será promovido a tenant universal.

## ADR-037 — Vetores e retrieval permanecem fora do schema do Lote 3

**Status:** aprovado para o Lote 3 em 7 de agosto de 2026

Nenhuma tabela, coluna ou índice do Lote 3 escolherá embedding, dimensão, `vector`, IVFFlat, HNSW, full-text retrieval ou reranking. `curriculum_rag` permanece legado e não é schema canônico da Knowledge Factory.

## ADR-038 — Merge de migration não autoriza aplicação em produção

**Status:** aprovado para o Lote 3 em 7 de agosto de 2026

Aprovação/merge do código da migration e autorização para executá-la no Supabase de produção são gates humanos independentes. Produção exige teste não produtivo, matriz RLS, ensaio de rollback e pre-flight do banco alvo.

## ADR-039 — Proveniência e auditoria append-only

**Status:** aprovado para o Lote 3 em 7 de agosto de 2026

Eventos de permissão, OPP e auditoria serão append-only em uso normal. Correção histórica ocorrerá por novo evento, bloqueio, suspensão ou supersessão, não por edição silenciosa.

## Pendências após aprovação do Lote 3

- integrar o PR documental nº 6 após CI verde;
- iniciar Lote 3A apenas em nova branch a partir da `main` integrada;
- criar migration somente após nova inspeção do schema/migrations no ciclo 3A;
- validar 3A em ambiente não produtivo antes do Lote 3B;
- não aplicar migration em produção sem autorização humana específica;
- manter retrieval, embeddings, IA, fontes reais, currículo real, Sócrates 2 executável e EPIC-018 bloqueados.

## Procedência

Snapshot controlado dos Marcos 001–003, complementado pelos Marcos 004, Lotes 1 e 2 e pelas aprovações humanas registradas até o Lote 3 em 7 de agosto de 2026.
