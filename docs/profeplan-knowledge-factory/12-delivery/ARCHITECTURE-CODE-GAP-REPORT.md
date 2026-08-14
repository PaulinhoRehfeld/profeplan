# Relatório de diferenças — arquitetura aprovada versus código existente

## Objetivo

Identificar o que já existe, o que pode ser adaptado e o que ainda precisa ser construído, sem confundir nomes de diretórios com capacidades prontas.

## Resumo executivo

O monorepo possui elementos importantes para a Knowledge Factory, mas ainda não implementa o fluxo aprovado de ponta a ponta.

Há:

- runtime de agentes;
- agentes disciplinares;
- quality gates;
- feature flags;
- observabilidade inicial;
- scripts de currículo e PNLD;
- pacote de tipos;
- pacote de IA;
- banco Prisma legado;
- APIs Vercel;
- Gráfica;
- aplicação web.

Faltam contratos comuns e uma cadeia integrada de procedência, autorização, componentes pedagógicos, currículo versionado, retrieval filtrado, OPP, gates calibrados e entrega auditável.

## GAP-001 — Contratos canônicos da Knowledge Factory

**Arquitetura aprovada:** contratos compartilhados e versionados antes de infraestrutura.

**Código atual:** `packages/types` possui contratos gerais, mas nenhum núcleo Knowledge Factory.

**Ação:** primeiro PR contract-first em `packages/types`.

## GAP-002 — Schemas executáveis e invariantes

**Arquitetura:** contratos devem ser validáveis em runtime e testáveis.

**Código atual:** Zod está disponível no frontend, não no pacote de tipos. Não há tooling de testes em `packages/types`.

**Ação:** decidir no primeiro PR se tipos puros são suficientes ou se uma dependência de schema precisa de autorização separada.

## GAP-003 — Procedência e licença como gate

**Arquitetura:** toda fonte precisa de procedência, versão, checksum, permissão e status.

**Código atual:** `industry-pnld` possui scripts, mas o Lote 0 não encontrou contrato canônico integrado ao runtime e ao acesso.

**Ação:** lote posterior, após contratos.

## GAP-004 — Componente pedagógico semielaborado

**Arquitetura:** unidade autoral, versionada, revisável, deduplicável e vinculada a evidências.

**Código atual:** não há contrato canônico compartilhado identificado.

**Ação:** definir no primeiro PR; persistir somente em lote posterior.

## GAP-005 — Pacote curricular versionado

**Arquitetura:** currículo MG plugável, versionado e selecionado por contexto.

**Código atual:** scripts Python e pipeline MG existem, mas não há contrato compartilhado integrado aos agentes e à OPP.

**Ação:** criar contrato agora; adaptar pipeline depois.

## GAP-006 — Filtros antes da similaridade

**Arquitetura:** componente, etapa, ano, currículo, licença, status e perfil devem filtrar o universo antes da busca.

**Código atual:** há experiências de RAG e busca, mas não foi comprovado um QueryPlan canônico com esses filtros obrigatórios.

**Ação:** contrato no primeiro PR; implementação e experimentos em lote posterior.

## GAP-007 — Estado explícito de insuficiência

**Arquitetura:** retrieval insuficiente não pode ser mascarado por geração livre.

**Código atual:** não foi identificado contrato compartilhado de `SufficiencyResult` e códigos de insuficiência.

**Ação:** primeiro PR.

## GAP-008 — Ordem de Produção Pedagógica

**Arquitetura:** OPP coordena pedido, contexto, estado, eventos, gates e entrega.

**Código atual:** existem fluxos de geração, mas não uma OPP canônica versionada.

**Ação:** contrato e máquina de estados pura no primeiro PR; execução depois.

## GAP-009 — Sócrates 2 como perfil versionado

**Arquitetura:** perfil sobre runtime comum, com escopo, produtos e bloqueios.

**Código atual:** agentes disciplinares e registro existem, mas o perfil específico aprovado ainda não está implementado e não deve ser ativado no Lote 0.

**Ação:** apenas contrato de perfil no primeiro PR; implementação posterior.

## GAP-010 — Quality gates calibrados

**Arquitetura:** gates não compensatórios, calibrados com casos dourados.

**Código atual:** quality gates existem, mas o workflow específico não roda e os steps de meta-validação imprimem mensagens estáticas.

**Ação:** definir findings/resultados no contrato; calibrar e integrar em lote posterior.

## GAP-011 — ModelPolicy

**Arquitetura:** agentes não acessam SDKs diretamente.

**Código atual:** `packages/agents` declara SDKs OpenAI e Anthropic diretamente; `packages/ai` também usa OpenAI.

**Ação:** não refatorar no primeiro PR. Planejar camada de política em lote posterior.

## GAP-012 — Observabilidade por OPP

**Arquitetura:** tokens, custo, latência e eventos por etapa.

**Código atual:** observabilidade de agentes e logger existem, mas não foi comprovada correlação integral por OPP.

**Ação:** contratos de evento no primeiro PR, integração posterior.

## GAP-013 — Persistência e RLS

**Arquitetura:** corpus compartilhado protegido e acesso por serviço autorizado.

**Código atual:** Prisma/DB está excluído do CI e associado a stack legada; Supabase é usado no produto, mas a divisão física permanece aberta.

**Ação:** nenhuma migration agora. Realizar desenho físico e revisão RLS em lote próprio.

## GAP-014 — Backend operacional duplicado

**Arquitetura:** uma superfície clara para OPP e retrieval.

**Código atual:** coexistem `api/` Vercel e `apps/bff` Azure. O deploy comprovado usa Vercel; BFF está excluído e sem deploy real.

**Ação:** priorizar `api/` nos lotes próximos, salvo decisão humana futura.

## GAP-015 — CI de agentes

**Arquitetura:** mudanças em agentes devem passar typecheck, testes e gates.

**Código atual:** workflow falha no setup de pnpm.

**Ação:** correção separada, sem misturar com o primeiro PR contract-first, a menos que os paths do PR o acionem indevidamente.

## GAP-016 — Testes Python

**Arquitetura:** ingestão e currículo precisam de processamento reproduzível.

**Código atual:** pipelines Python não têm workflow identificado.

**Ação:** CI Python em lote posterior.

## GAP-017 — Entrega versus Gráfica

**Arquitetura:** conteúdo validado gera contrato de entrega; Gráfica apenas finaliza.

**Código atual:** pacote gráfico existe, mas a fronteira contratual não é canônica.

**Ação:** contrato de entrega no primeiro PR; integração gráfica posterior.

## GAP-018 — Baseline e comparação genérica

**Arquitetura:** casos dourados e baseline justo.

**Código atual:** não há dataset/runner do piloto comprovado.

**Ação:** fixtures sintéticas no primeiro PR; casos dourados e baseline em lotes posteriores.

## Conflitos que não devem ser resolvidos agora

- Prisma versus SQL Supabase;
- API Vercel versus BFF Azure como arquitetura definitiva;
- OpenAI versus outros provedores;
- modelo/dimensão de embedding;
- HNSW versus IVFFlat;
- reranker;
- cache;
- formato avançado de Gráfica;
- expansão para RS.

## Conclusão

A arquitetura aprovada é compatível com o monorepo, desde que seja introduzida de forma aditiva e contract-first. Tentar conectar diretamente scripts, agentes e banco antes dos contratos aumentaria o acoplamento e perpetuaria as divergências existentes.
