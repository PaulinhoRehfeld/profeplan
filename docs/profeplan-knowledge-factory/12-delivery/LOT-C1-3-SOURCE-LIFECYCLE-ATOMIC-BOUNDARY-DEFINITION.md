# Sublote C.1.3 — Definição da fronteira atômica do lifecycle de fontes

Data: 13 de agosto de 2026.

Base canônica verificada:

- `main`: `7faf6af817099ce45757d606b392695bc4baee0d`;
- tree: `ec15e050785672c399db9169fd8431f9f00c2bf5`;
- Checkpoint anterior: `CONTINUITY-CHECKPOINT-038.md`.

## Status

**Definição documental preparada. Implementação não autorizada.**

C.1.3 é o próximo sublote técnico candidato depois da integração de C.1.2, mas migration, RPCs,
testes executáveis e qualquer alteração física continuam bloqueados até nova autorização humana.

## 1. Objetivo exclusivo

Definir a fronteira transacional mínima capaz de executar os comandos já contratados em C.1.1 sem:

- pseudo-transação PostgREST;
- DML paralelo;
- bypass por `service_role`;
- alteração silenciosa de histórico;
- duplicação por retry;
- corrida de versão/sequence;
- transferência implícita de autorização;
- antecipação de C.1.4 ou C.2.

## 2. Decisões fechadas nesta definição

### D1 — RPCs estreitas por comando

Adotar RPC pública por comando, com helpers internos compartilhados. Rejeitar RPC monolítica de
lifecycle.

### D2 — Competência autoritativa

Criar, se a implementação for autorizada, `kf_source_actor_assignments` como fonte técnica mínima de
atribuição de papéis. O papel declarado no payload não é suficiente.

### D3 — EXECUTE server-only

A superfície C.1.3 será executável por `service_role` somente como canal técnico. `authenticated`,
platform admin, professor e school admin não recebem `EXECUTE` direto. DML das tabelas permanece
revogado.

### D4 — Fingerprint calculado pelo banco

SHA-256 canônico de `{fingerprintVersion:1, operation, payload}`. `commandId` e fingerprint recebido
ficam fora do material hasheado. Divergência caller↔cálculo é `INVALID_INPUT`.

### D5 — Replay antes de estado e competência atuais

Mesmo `commandId`/fingerprint/operação retorna receipt histórico sem reexecutar invariantes.
Fingerprint divergente é `CONFLICT`.

### D6 — CAS obrigatório em mutações existentes

`expectedVersion` e `expectedSequence` tornam-se obrigatórios para alteração de agregado existente.
`expectedState` é exigido quando o contrato do comando o oferece.

### D7 — AggregateVersion opaco

Novo token UUID textual por revisão comprometida. `sequence` continua sendo o ordinal monotônico.
Não usar SemVer para estado concorrencial.

### D8 — Temporalidade não regressiva

Novo evento não pode possuir `effectiveAt` ou `occurredAt` anterior ao último evento em sequence do
mesmo agregado. Correção histórica retroativa complexa fica fora de C.1.3.

### D9 — Impacto conservador

Comandos que restringem ou alteram elegibilidade abrem evento de impacto na mesma transação, mesmo
antes da lineage completa.

### D10 — Supersession atômica

`supersede_authorization` encerra predecessor em `SUPERSEDED`, cria successor em `GRANTED`, gera os
eventos correspondentes e abre impacto em uma única transação. Nenhum scope antigo é editado.

### D11 — C.1.3 não amplia o contrato de comandos

Não criar `expire_authorization`, classificação/encerramento de impacto, processing run ou comando de
derivados nesta fatia.

## 3. Command matrix consolidada

| Comando | Aggregate principal | Estado resultante | Evento principal | Eventos adicionais |
|---|---|---|---|---|
| register_identity | subject identity | REGISTERED | source_registered | nenhum |
| request_validation | subject identity | PENDING_VALIDATION | source_validation_requested | nenhum |
| confirm_validation | subject identity | VALIDATED | source_validated | nenhum |
| block_source | subject identity | BLOCKED | source_blocked | impact |
| replace_source | subject identity | REPLACED | source_replaced | impact |
| archive_source | subject identity | ARCHIVED | source_archived | impact |
| grant_authorization | authorization | GRANTED | authorization_granted | nenhum |
| suspend_authorization | authorization | SUSPENDED | authorization_suspended | impact |
| resume_authorization | authorization | GRANTED | authorization_resumed | nenhum |
| revoke_authorization | authorization | REVOKED | authorization_revoked | impact |
| block_purpose | authorization | BLOCKED | authorization_blocked | impact |
| supersede_authorization | predecessor authorization | SUPERSEDED | authorization_superseded | successor grant + impact |
| open_impact_assessment | subject identity / impact | n/a | source_impact_assessment_opened | nenhum |

## 4. Table matrix consolidada

Abreviações:

- I — `kf_source_identities`;
- B — `kf_source_authorization_bases`;
- R — `kf_source_registration_projections`;
- A — `kf_source_authorizations`;
- C — `kf_source_command_receipts`;
- E — `kf_source_governance_events`;
- CE — `kf_source_command_receipt_events`;
- AA — `kf_source_actor_assignments` proposta.

| Comando | Tabelas |
|---|---|
| register_identity | AA(r), I, R, C, E, CE |
| request_validation | AA(r), I(r), R, C, E, CE |
| confirm_validation | AA(r), I(r), R, C, E, CE |
| block_source | AA(r), I(r), R, C, E, CE |
| replace_source | AA(r), I(r), R, C, E, CE |
| archive_source | AA(r), I(r), R, C, E, CE |
| grant_authorization | AA(r), I(r), R(r/lock), B, A, C, E, CE |
| suspend_authorization | AA(r), A, C, E, CE |
| resume_authorization | AA(r), A, C, E, CE |
| revoke_authorization | AA(r), A, C, E, CE |
| block_purpose | AA(r), A, C, E, CE |
| supersede_authorization | AA(r), I(r), R(r/lock), B, A, C, E, CE |
| open_impact_assessment | AA(r), I(r), A(r opc.), C, E, CE |

Não foi demonstrada necessidade de outra tabela nova em C.1.3.

## 5. Definition of Ready para implementação

A implementação somente poderá iniciar quando houver aprovação explícita desta definição e dos dois
documentos complementares:

- `09-data/LOT-C1-3-SOURCE-LIFECYCLE-TRANSACTION-BOUNDARY.md`;
- `10-legal-security/LOT-C1-3-EXECUTE-COMPETENCE-MATRIX.md`.

Critérios:

- [x] 13 comandos executáveis fechados;
- [x] não comandos identificados e bloqueados;
- [x] command→table matrix;
- [x] command→actor matrix;
- [x] fingerprint canônico definido;
- [x] replay definido;
- [x] CAS obrigatório definido;
- [x] aggregateVersion definido como token opaco;
- [x] monotonicidade temporal definida;
- [x] locks de comando e agregado definidos;
- [x] supersession definida;
- [x] impacto conservador definido;
- [x] source de competência demonstrada;
- [x] EXECUTE mínimo definido;
- [x] DML paralelo proibido;
- [x] rollback matrix definida;
- [x] concurrency matrix definida;
- [x] erros provider-neutral preservados;
- [x] C.1.4/C.2 fora de escopo;
- [x] produção fora de escopo.

Após aprovação humana, o sublote poderá ser considerado `READY FOR CODE — C.1.3 only`.

## 6. Escopo provável da implementação futura

Se autorizada, a implementação deverá se limitar aproximadamente a:

```text
supabase/migrations/<timestamp>_kf_source_lifecycle_command_boundary.sql
supabase/tests/knowledge_factory_source_lifecycle_commands.sql
supabase/tests/knowledge_factory_source_lifecycle_idempotency.sql
supabase/tests/knowledge_factory_source_lifecycle_concurrency.sql
supabase/tests/knowledge_factory_source_lifecycle_command_privileges.sql
supabase/tests/knowledge_factory_source_lifecycle_command_rollback.sql
```

A divisão de testes poderá ser ajustada ao runner sem reduzir cobertura.

Nenhuma alteração em `packages/knowledge-factory-supabase` pertence a C.1.3; adapters são C.1.4.

## 7. Definition of Done futura de C.1.3

C.1.3 somente estará tecnicamente concluído quando, em Supabase descartável:

- as RPCs aprovadas existirem;
- helpers internos não forem executáveis externamente;
- service_role continuar sem DML direto;
- ator incompetente falhar;
- transições válidas forem atômicas;
- falha intermediária fizer rollback integral;
- replay não duplicar histórico;
- fingerprint divergente conflitar;
- dois writers concorrentes não vencerem sobre a mesma versão;
- supersession concorrente não criar dois sucessores válidos;
- grant concorrente com bloqueio registral for serializado deterministicamente;
- impacto obrigatório fizer parte da mesma transação;
- receipt/event/projection permanecerem coerentes;
- suites anteriores da Knowledge Factory continuarem verdes;
- nenhuma produção for acessada.

Isso ainda não encerra `GAP-3B-04`; C.1.4, C.1.5 e C.1.6 permanecem necessários.

## 8. Gate humano seguinte

Após revisão desta formalização, a próxima autorização possível é exclusivamente para implementar
migration/RPCs/testes de C.1.3 em branch controlada. Push, PR, merge e produção continuam gates
separados.
