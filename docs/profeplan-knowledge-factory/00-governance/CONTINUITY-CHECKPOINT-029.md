# CONTINUITY CHECKPOINT 029 — Sublote 3B.5.3 implementado para revisão

Data: 11 de agosto de 2026.

## Status

**O Sublote 3B.5.3 — migration e RPCs transacionais de OPP foi implementado em branch isolada e
está preparado para revisão humana. Nenhuma publicação, Pull Request, merge, adapter de comando,
wiring, Supabase hospedado ou produção foi realizada. As provas PostgreSQL reais estão preparadas,
mas dependem do Supabase descartável do DB CI porque esta sessão local não possui Docker/Supabase.**

## Base e branch

- repositório canônico: `PaulinhoRehfeld/profeplan`;
- branch-base: `main`;
- commit-base: `b0d83c1b0a27dd20ca9bba891297c7453bb6e5fa`;
- origem da base: squash merge do Pull Request nº 26;
- branch técnica: `feat/knowledge-factory-production-order-write-rpcs`;
- definição vinculante:
  `12-delivery/LOT-3B5-PRODUCTION-ORDER-REPOSITORY-DEFINITION.md`.

## Escopo implementado

### Migration transacional

`202608111900_kf_production_order_write_rpcs.sql` adiciona:

- `kf_production_order_write_receipts`, com command, requester, operação, fingerprint, OPP, evento,
  estado e instante de commit;
- helpers internos de payload fechado, tipos, fingerprint, matriz de transição e evento derivado;
- `kf_create_production_order(uuid, jsonb)`;
- `kf_transition_production_order(uuid, jsonb)`.

Os recibos não armazenam tema, motivo, payload, contexto pedagógico, turma, token ou credencial.

### Fronteira REQUESTER de criação

- executável por `authenticated`, nunca por `anon` ou `service_role`;
- deriva `requester_id` exclusivamente de `auth.uid()`;
- rejeita identidade ausente;
- não aceita requester, status ou timestamps dentro do snapshot `order`;
- persiste OPP `requested`, evento `created` e recibo em uma única transação;
- deriva `created_at` e `updated_at` do `occurredAt` validado;
- payload fechado impede campos desconhecidos;
- replay exige mesmo command, requester, operação e fingerprint.

### Fronteira SYSTEM de transição

- executável somente por `service_role`;
- recebe requester esperado, nunca usa SYSTEM como ownership implícito;
- bloqueia somente a OPP alvo;
- compara requester, status e `updated_at` esperados;
- exige monotonicidade de `occurredAt`;
- repete a matriz estrutural do contrato TypeScript;
- deriva tipo, estado anterior e estado seguinte do evento;
- persiste UPDATE, evento e recibo em uma única transação;
- não tenta reproduzir gates pedagógicos cujos insumos não estão no banco.

### Privilégio mínimo

- `authenticated` perdeu INSERT direto em `kf_production_orders`;
- `service_role` perdeu INSERT/UPDATE direto em `kf_production_orders`;
- `service_role` perdeu INSERT direto em `kf_production_order_events`;
- SELECTs requester existentes e RLS foram preservados;
- trigger append-only de eventos foi preservado;
- helpers e recibos não recebem grants de API;
- rollback guardado restaura apenas os grants preparatórios anteriores e se recusa a descartar
  recibos já persistidos.

## Provas adicionadas

### Transação, autorização e idempotência

- criação deriva requester, estado, timestamps e evento;
- criação e transição falham integralmente quando o terceiro INSERT é interrompido;
- payload desconhecido, transição inválida e evento regressivo falham;
- requester divergente é indistinguível de OPP ausente;
- estado ou timestamp obsoleto resulta em conflito;
- mesmo comando/payload retorna replay sem duplicação;
- mesmo command com fingerprint ou requester divergente resulta em conflito;
- matriz SQL é comparada exaustivamente com a matriz TypeScript;
- DML direto e execução pelo papel incorreto são negados;
- evento permanece append-only.

### Concorrência multi-sessão

O script `knowledge_factory_production_order_concurrency.sh` é restrito ao URL local canônico do
Supabase descartável e prepara duas barreiras reais:

- duas sessões com o mesmo `commandId` produzem um commit lógico e um replay;
- duas transições distintas com a mesma expectativa produzem exatamente um vencedor e um conflito
  `PT409`;
- o rollback guardado é chamado enquanto existem recibos e deve recusar a remoção;
- as fixtures concorrentes são limpas antes do ensaio normal de rollback.

### Compatibilidade das leituras

- os testes de schema e RLS passaram a criar OPP pela RPC REQUESTER;
- a integração A/B do adapter read-only prepara OPP/eventos pelas duas RPCs, sem reintroduzir DML
  direto de `service_role`;
- o adapter read-only e sua superfície pública não foram alterados.

## Validação local

- sintaxe Bash: aprovada;
- sintaxe do teste de integração Node: aprovada;
- Prettier específico e formatter geral: aprovados;
- typecheck de `@profeplan/knowledge-factory-supabase`: aprovado;
- pacote Supabase: 133/133 testes unitários aprovados;
- lint, typecheck, build e suíte geral equivalentes ao CI: aprovados;
- lockfile e dependências: inalterados;
- execução SQL, concorrência, rollback, reaplicação e DB lint: preparados para o DB CI, não
  executáveis nesta sessão sem stack descartável.

## Exclusões preservadas

Não fazem parte deste sublote:

- implementação de `ProductionOrderRequestRepository` ou
  `ProductionOrderTransitionRepository`;
- qualquer adapter de comando do 3B.5.4;
- `.insert()`, `.update()`, `.upsert()` ou `.delete()` em adapter;
- API, frontend, composition root, autenticação ou criação de client;
- worker, fila, scheduler, agente, retrieval, geração, validação ou entrega;
- dados pedagógicos, curriculares, PNLD, PDI ou turmas reais;
- aplicação no Supabase hospedado, deploy ou produção;
- encerramento de `GAP-3B-03`, `GAP-3B-07`, Lote 3B.5 ou Fase B;
- início do 3B.5.4;
- push, Pull Request ou merge automático.

## Estado de continuidade

- ✅ Lote 3B.4 integrado e concluído;
- ✅ definição documental do Lote 3B.5 integrada;
- ✅ 3B.5.1 — contratos `3.0.0` e contexto REQUESTER integrado;
- ✅ 3B.5.2 — adapter REQUESTER read-only integrado pelo Pull Request nº 26;
- 🔵 3B.5.3 — migration e RPCs implementado localmente para revisão;
- ⬜ 3B.5.4 — adapters de comando não iniciado;
- 🟡 `GAP-3B-03` permanece ativo;
- 🟡 `GAP-3B-07` permanece ativo;
- 🟡 Fase B permanece aberta.

## Próximo gate humano

Revisar o diff completo do 3B.5.3 e o commit local verificável. Qualquer push e abertura de Pull
Request draft exigirá autorização explícita vinculada ao commit e ao repositório canônico. O DB CI
deverá aprovar migration, grants, atomicidade, replay, concorrência, rollback, reaplicação,
integração A/B e DB lint antes de qualquer integração.

O 3B.5.4 permanecerá bloqueado até autorização explícita posterior à integração humana do 3B.5.3.
