# CONTINUITY CHECKPOINT 030 — Sublote 3B.5.4 implementado para revisão

Data: 11 de agosto de 2026.

## Status

**O Sublote 3B.5.4 — adapters de comando do ProductionOrderRepository foi implementado em branch
isolada e está preparado para revisão humana. Nenhuma publicação, Pull Request, merge, wiring,
Supabase hospedado, produção, encerramento de GAP ou início de fase posterior foi realizado. A
integração PostgreSQL real está preparada, mas depende do Supabase descartável do DB CI.**

## Base e branch

- repositório canônico: `PaulinhoRehfeld/profeplan`;
- branch-base: `main`;
- commit-base: `e223de4d02b39df748c3063d0e495f528c025e9d`;
- origem da base: squash merge do Pull Request nº 27;
- branch técnica: `feat/knowledge-factory-production-order-command-adapters`;
- definição vinculante:
  `12-delivery/LOT-3B5-PRODUCTION-ORDER-REPOSITORY-DEFINITION.md`.

## Escopo implementado

### Adapter REQUESTER de criação

- `SupabaseProductionOrderRequestRepository` implementa somente
  `ProductionOrderRequestRepository`;
- recebe `SupabaseRequesterContext` injetado e não cria client;
- rejeita requester vazio antes de acessar o provider;
- chama exclusivamente `kf_create_production_order`;
- separa `commandId` de um payload reconstruído por allowlist;
- nunca envia requester, status, `createdAt` ou `updatedAt` no payload;
- não possui fallback SYSTEM, leitura de token, sessão ou ambiente.

### Adapter SYSTEM de transição

- `SupabaseProductionOrderTransitionRepository` implementa somente
  `ProductionOrderTransitionRepository`;
- recebe `SupabaseSystemContext` injetado e não cria client;
- chama exclusivamente `kf_transition_production_order`;
- envia requester esperado, compare-and-set, destino, evento e instante aprovados pelo contrato;
- nunca recebe nem deriva tipo, estado anterior ou estado seguinte do evento;
- não executa `evaluateOppTransition()` e pressupõe decisão de domínio aceita antes da chamada;
- não possui fallback REQUESTER nem leitura privada de OPP.

### Mapper e recibo

- payloads de criação e transição são mapeados campo a campo;
- propriedades runtime fora do contrato não atravessam a fronteira;
- resposta válida exige exatamente uma row e exatamente as sete colunas aprovadas;
- command, operação, OPP, evento e status devem coincidir com a expectativa do adapter;
- `replayed` deve ser booleano e `committedAt`, um ISO date-time válido;
- recibos retornados são imutáveis e provider-neutral.

### Erros e observabilidade

- `22023`, `PT409` e `P0002` permanecem mapeados para `INVALID_INPUT`, `CONFLICT` e `NOT_FOUND`;
- ausência autenticada reconhecível é `UNAUTHORIZED`, enquanto `42501` genérico permanece
  `FORBIDDEN`;
- respostas incompatíveis são `INVALID_RESPONSE`;
- nenhum SQLSTATE, detalhe, hint, payload ou credencial atravessa a borda;
- telemetria contém somente operação, adapter, duração, resultado, tipo/id agregado, row count,
  correlation id SYSTEM quando disponível e código provider-neutral em falha;
- logger não altera o resultado da persistência.

## Provas adicionadas

### Unitárias e de tipo

- cada classe é atribuível somente à sua capacidade específica;
- nenhuma classe concreta alega implementar a composição integral;
- payloads fechados omitem campos derivados e propriedades desconhecidas;
- recibos rejeitam cardinalidade, coluna, identidade, operação, status, replay ou timestamp
  incompatível;
- contexto REQUESTER ausente falha antes da RPC;
- erros e transporte são sanitizados sem retry implícito;
- telemetria positiva e negativa é allowlisted;
- fonte não contém `.from()`, DML, `createClient`, env ou fallback entre contextos.

### Integração descartável preparada

- REQUESTER cria OPP pela RPC e recebe recibo;
- mesmo comando produz replay e payload divergente produz conflito;
- leitura REQUESTER confirma ownership, estado e primeiro evento;
- SYSTEM transiciona pela RPC, recebe replay e respeita compare-and-set;
- requester esperado divergente permanece indistinguível de OPP ausente;
- REQUESTER não executa transição e SYSTEM não executa criação;
- timeline final contém somente os dois eventos atômicos esperados.

## Validação local

- Prettier específico: aprovado;
- `git diff --check`: aprovado;
- typecheck de `@profeplan/knowledge-factory-supabase`: aprovado;
- pacote Supabase: 155/155 testes unitários aprovados, incluindo 22 novos testes;
- formatter, lint, typecheck e build gerais equivalentes ao CI: aprovados;
- frontend: 87/87 testes aprovados;
- agentes: 178/178 testes aprovados;
- contratos, domínio e demais suítes locais: aprovados;
- lockfile e dependências do projeto: inalterados;
- integração PostgreSQL real: preparada para o DB CI, não executada localmente sem stack
  descartável.

## Exclusões preservadas

Não fazem parte deste sublote:

- composição de read, request e transition em uma classe concreta;
- `.from()`, `.insert()`, `.update()`, `.upsert()` ou `.delete()` nos adapters;
- criação de client, leitura de env, sessão, token ou credencial;
- API, frontend, composition root, autenticação ou endpoint;
- chamada da política de domínio dentro do adapter;
- worker, fila, scheduler, agente, retrieval, geração, validação ou entrega;
- dados pedagógicos, curriculares, PNLD, PDI ou turmas reais;
- aplicação no Supabase hospedado, deploy ou produção;
- encerramento de `GAP-3B-03`, `GAP-3B-07`, Lote 3B.5 ou Fase B;
- início da Fase C;
- push, Pull Request ou merge automático.

## Estado de continuidade

- ✅ Lote 3B.4 integrado e concluído;
- ✅ definição documental do Lote 3B.5 integrada;
- ✅ 3B.5.1 — contratos `3.0.0` e contexto REQUESTER integrado;
- ✅ 3B.5.2 — adapter REQUESTER read-only integrado;
- ✅ 3B.5.3 — migration e RPCs transacionais integrado pelo Pull Request nº 27;
- 🔵 3B.5.4 — adapters de comando implementado localmente para revisão;
- 🟡 `GAP-3B-03` permanece ativo até integração e checkpoint pós-merge;
- 🟡 `GAP-3B-07` permanece ativo;
- 🟡 Lote 3B.5 e Fase B permanecem abertos.

## Próximo gate humano

Revisar o diff completo do 3B.5.4 e o commit local verificável. Qualquer push e abertura de Pull
Request draft exigirá autorização explícita vinculada ao commit e ao repositório canônico. O CI
geral e o DB CI deverão aprovar os adapters, a separação de papéis e a integração descartável antes
de qualquer integração.

Mesmo após eventual merge, o encerramento do Lote 3B.5 e da Fase B dependerá de checkpoint
pós-merge e decisão humana específicos.
