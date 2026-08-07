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

## Pendências transferidas ao Lote 0

- baseline real dos comandos e do CI;
- falhas preexistentes;
- sincronização documental;
- módulos exatos de destino;
- branch e escopo do primeiro PR;
- autorização humana específica antes do código.

## Procedência

Snapshot controlado do documento aprovado no commit `cb36d71b1533fe7fa022c1aedca2c8790ab69692` de `PaulinhoRehfeld/profeplan_v5`.
