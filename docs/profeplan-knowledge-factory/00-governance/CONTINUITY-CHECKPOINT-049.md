# CONTINUITY CHECKPOINT 049 — C.2.5 integrado; C.2.6 permanece bloqueado

Data: 15 de agosto de 2026.

## Estado canônico técnico

- repositório: `PaulinhoRehfeld/profeplan`;
- branch canônica: `main`;
- commit técnico canônico de C.2.5: `01a985a94272608007a57fd60695fed719c625d2`;
- tree: `a73ad7e9efda8e1c04bcddd3ed129bc44d85eaf1`;
- parent direto: `69211a2a64c05c341f5fd2d5742a1d252607e22d`;
- PR nº 84: integrado por squash merge em 15 de agosto de 2026;
- título canônico: `feat(knowledge-factory): implement C.2.5 human review handoff (#84)`;
- HEAD técnico validado antes do merge: `041b1890f08bcd39e74a34073fb77aabfdb300e9`;
- tree do HEAD técnico validado: `a73ad7e9efda8e1c04bcddd3ed129bc44d85eaf1`;
- CI geral do HEAD final: CI Pipeline nº 538 — `success`;
- regressão de banco: Knowledge Factory DB CI nº 178 — `success`;
- regressão C.1.4: Knowledge Factory C.1.4 Adapter CI nº 72 — `success`;
- regressão C.1.5: Knowledge Factory C.1.5 Lifecycle CI nº 82 — `success`;
- regressão C.2.2: Knowledge Factory C.2.2 Staging CI nº 74 — `success`;
- regressão C.2.3: Knowledge Factory C.2.3 Integrity CI nº 53 — `success`;
- regressão C.2.4: Knowledge Factory C.2.4 Recovery CI nº 41 — `success`;
- prova específica: Knowledge Factory C.2.5 Human Review CI nº 6 — `success`;
- CI pós-merge da `main`: CI Pipeline nº 547 — `success`.

O Checkpoint 048 permanece evidência histórica do encerramento de C.2.4 e do bloqueio anterior de C.2.5. Ele não deve ser reescrito.

## Exceção governada de status externo no merge

Imediatamente antes do merge, a `main`, o HEAD autorizado, a genealogia, `behind_by: 0`, a mergeabilidade e os oito workflows técnicos foram reconfirmados.

O GitHub mantinha `mergeable_state: unstable` exclusivamente porque dois statuses externos da Vercel permaneciam em `failure`:

- `Vercel – site`;
- `Vercel – profeplan`.

Os dois failures estavam associados ao limite externo `api-deployments-free-per-day`, e não a falha de código ou de gate técnico da Knowledge Factory. A integração somente ocorreu após autorização humana explícita para dispensar **exclusivamente** esses dois statuses externos, mantendo todas as demais guardas.

Essa exceção não altera a política geral de CI, não transforma failures de aplicação em aceitáveis e não autoriza ignorar checks técnicos futuros.

## Resultado técnico de C.2.5

C.2.5 materializou a fronteira de revisão humana e handoff governado para a futura C.3, preservando os contratos, ownerships e gates estabelecidos em C.1 e C.2.1–C.2.4.

A definição técnica integrada está em:

`12-delivery/LOT-C2-5-HUMAN-REVIEW-AND-C3-HANDOFF.md`.

C.2.5 não criou uma segunda state machine e não alterou:

- `INGESTION_CONTRACT_VERSION = 1.0.0`;
- a topologia de estados de C.2.1;
- C.1 como autoridade de identidade, competência e autorização;
- C.2 como autoridade do lifecycle operacional de `processing_run`;
- C.2.2 como autoridade de staging e retenção;
- C.2.3 como autoridade da evidência de integridade física;
- C.2.4 como autoridade de idempotência, recovery, locks, CAS e fail-safe;
- Storage como autoridade sobre bytes físicos;
- PostgreSQL como autoridade sobre fatos persistidos.

## State machine preservada

C.2.5 materializa exclusivamente transições já definidas em C.2.1:

```text
VERIFIED
  --request_review--> PENDING_REVIEW

PENDING_REVIEW
  --approve_for_extraction--> APPROVED_FOR_EXTRACTION
  --reject_ingestion--------> REJECTED
```

`APPROVED_FOR_EXTRACTION` e `REJECTED` continuam terminais dentro de C.2.

Não foram criados estados como `UNDER_HUMAN_REVIEW`, `HANDOFF_READY`, `QUEUED_FOR_EXTRACTION`, `EXTRACTING` ou equivalentes.

## Competência humana e autoridade de negócio

A decisão humana permanece dependente da autoridade C.1.

`approve_for_extraction` e a rejeição humana exigem, entre outras invariantes:

- `reviewMode = human`;
- ator do comando igual ao reviewer;
- papel `legal_editorial_reviewer`;
- assignment C.1 ativo no instante da decisão;
- cardinalidade exatamente igual a um assignment aplicável;
- run em `PENDING_REVIEW`;
- `expectedVersion` e `expectedSequence` válidos.

O `reviewer_assignment_id` persistido referencia a competência comprovada em C.1; ele não cria competência própria em C.2.

`service_role` continua sendo somente canal técnico. O fato de uma RPC ser executada por `service_role` não concede autoridade jurídico-editorial nem autorização de negócio.

## Aprovação humana e autorização independente de `extraction`

Aprovação humana não implica autorização de extração.

A equivalência abaixo permanece proibida:

```text
human_review_approved => extraction_authorized
```

Para produzir `APPROVED_FOR_EXTRACTION`, C.2.5 exige autorização C.1 independente com:

- `purpose = extraction`;
- `sourceVersion` correspondente à execução;
- autorização historicamente `GRANTED` no instante da decisão;
- janela temporal válida naquele instante;
- instante de avaliação igual ao instante da decisão humana.

A evidência persiste o identificador e o instante da autorização utilizada.

O handoff comprova que a autorização estava válida no instante da decisão humana. Uma eventual execução futura em C.3 deverá verificar novamente sua própria autorização `extraction` no instante real da execução.

## Evidência persistida da revisão

A decisão humana é registrada no evento append-only que materializa a transição, sem criar tabela paralela de review.

A evidência inclui, conforme a decisão:

- `review_id`;
- `reviewer_assignment_id`;
- `reviewer_actor_id`;
- `reviewer_actor_role`;
- `review_decision`;
- `review_decided_at`;
- `review_reason`;
- `reviewed_artifact_id`;
- `extraction_authorization_id` na aprovação;
- `extraction_authorization_evaluated_at` na aprovação.

Receipt e evento permanecem vinculados a run, command, correlation, aggregate version, sequence e transição de estado.

## Handoff governado não executa C.3

O handoff é um fato persistido de elegibilidade, sustentado por:

1. run terminal em `APPROVED_FOR_EXTRACTION`;
2. receipt correspondente ao `approve_for_extraction` na mesma versão/sequence;
3. evento `ingestion_approved_for_extraction` contendo revisão humana e autorização independente.

`kf_ingestion_handoff_snapshot` reconstrói esses fatos em forma read-only e provider-neutral.

C.2.5 não:

- abre PDF;
- lê conteúdo;
- extrai texto;
- executa OCR;
- cria páginas;
- cria chunks;
- gera embeddings;
- publica job;
- cria fila;
- inicia worker;
- inicia agente;
- executa C.3.

## Idempotência, replay e recuperação

C.2.5 reutiliza a estratégia de C.2.4:

```text
commandId + canonical fingerprint
```

A fronteira prova:

- fingerprint recalculado server-side;
- replay idêntico devolvendo o receipt já persistido;
- replay divergente fail-closed;
- recuperação após resposta RPC perdida por retry idêntico;
- nenhum segundo evento em replay;
- preservação da decisão histórica já comprometida.

## Concorrência e CAS

C.2.5 reutiliza:

- advisory lock transacional por `commandId`;
- row lock do run;
- `expectedState`;
- `expectedVersion`;
- `expectedSequence`.

As provas demonstraram:

- concorrência do mesmo `commandId` convergindo para applied + replay;
- dois commandIds sobre o mesmo snapshot com somente um vencedor;
- corrida real `approve` versus `reject` com um único estado terminal vencedor;
- snapshot obsoleto falhando conservadoramente;
- estado terminal recusando segunda decisão.

## Atomicidade e fail-closed

Run, receipt e evento da decisão são persistidos na mesma transação PostgreSQL.

A prova de rollback deliberado demonstrou que falha intermediária não deixa:

- run parcialmente aprovado;
- receipt órfão;
- review event parcial.

A fronteira falha fechada para competência, autorização, cardinalidade, integridade, retenção, state/version/sequence, replay divergente e conflitos concorrentes inválidos.

## Segurança e least privilege

As RPCs C.2.5 são estreitas e `SECURITY DEFINER`, com `search_path` fixo:

- `kf_ingestion_request_review`;
- `kf_ingestion_approve_for_extraction`;
- `kf_ingestion_reject`;
- `kf_ingestion_handoff_snapshot`.

`anon` e `authenticated` não recebem essas capabilities. `service_role` recebe somente `EXECUTE` técnico e permanece sem DML direto nas tabelas C.1/C.2 e sem autoridade de negócio implícita.

Erros de provider/database permanecem traduzidos para códigos provider-neutral antes de atravessar a boundary.

## Prova remota descartável

O workflow integrado é:

`.github/workflows/knowledge-factory-c2-5-human-review-ci.yml`.

A execução verde nº 6 comprovou, em Supabase/PostgreSQL descartáveis no GitHub Actions:

- competência humana;
- reviewer inexistente ou sem competência;
- assignment expirado;
- autorização `extraction` independente;
- autorização `extraction` expirada;
- state/version/sequence esperados;
- fingerprint recalculado server-side;
- replay idêntico e replay divergente;
- resposta RPC perdida e retry;
- receipt/event auditáveis;
- auditoria do reviewer;
- rollback deliberado;
- atomicidade run + receipt + event;
- concorrência real multi-sessão;
- concorrência do mesmo commandId;
- corrida approve versus reject;
- terminalidade;
- least privilege e DML direto bloqueado;
- erros provider-neutral;
- ausência de superfície executora de C.3;
- regressões C.2.2–C.2.4.

Nenhum conteúdo real, recurso hospedado, secret de produção ou ambiente de produção participou da prova.

## Gates e revisão do PR nº 84

Antes do squash merge foram confirmados:

- base canônica `69211a2a64c05c341f5fd2d5742a1d252607e22d`;
- HEAD exato `041b1890f08bcd39e74a34073fb77aabfdb300e9`;
- tree do HEAD `a73ad7e9efda8e1c04bcddd3ed129bc44d85eaf1`;
- `behind_by: 0`;
- `mergeable: true`;
- 17 arquivos de escopo;
- nenhuma review submetida;
- nenhuma review thread;
- revisão integral do diff;
- os oito workflows técnicos em `success`;
- exceção humana específica somente para os dois statuses Vercel associados a quota externa;
- squash merge protegido por `expected_head_sha`.

## Validação pós-merge

A `main` foi confirmada em:

- SHA `01a985a94272608007a57fd60695fed719c625d2`;
- tree `a73ad7e9efda8e1c04bcddd3ed129bc44d85eaf1`;
- parent `69211a2a64c05c341f5fd2d5742a1d252607e22d`.

A tree do squash é exatamente a tree técnica previamente validada no HEAD do PR nº 84.

O CI Pipeline nº 547, executado por `push` nesse SHA, terminou `success` com Prettier, ESLint, TypeScript, Build e Tests verdes.

## Estado operacional após este checkpoint

- C.0 — concluído;
- C.1 — concluído;
- C.2 — em execução governada;
- C.2.1 — integrado e revalidado;
- C.2.2 — integrado e revalidado;
- C.2.3 — integrado e revalidado;
- C.2.4 — integrado e revalidado;
- **C.2.5 — integrado e revalidado**;
- **C.2.6 — bloqueado**;
- C.3–C.7 — bloqueados;
- `GAP-3B-05` — ativo e contido;
- `GAP-3B-07` — ativo e contido;
- conteúdo real — bloqueado;
- PNLD real — bloqueado;
- Supabase hospedado — bloqueado;
- Storage hospedado — bloqueado;
- produção — bloqueada.

## Definition of Ready de C.2.6

C.2.6 é o próximo sublote canônico e trata **prova integrada, fechamento de C.2 e gate governado para C.3**.

Ele não pode ser iniciado automaticamente pela conclusão de C.2.5.

Antes de qualquer implementação ou fechamento de C.2.6 será obrigatório, em contexto próprio:

1. confirmar `main`, genealogia e Checkpoint 049 como autoridade de continuidade vigente;
2. inspecionar C.2.1–C.2.5 integrados e preservar seus ownerships e contratos;
3. construir a matriz consolidada de evidências de C.2;
4. provar o fluxo end-to-end exclusivamente com fixtures sintéticas e infraestrutura descartável;
5. incluir segurança negativa, replay, duplicidade, conflito, concorrência e fail-closed;
6. provar retenção, descarte e cleanup verificáveis, incluindo rollback/reapply quando aplicável;
7. comprovar que `temporary_staging`, `ingestion` e `extraction` permanecem finalidades distintas;
8. comprovar que o handoff para C.3 continua apenas fato/contrato e que nenhuma chamada executável de C.3 ocorre;
9. reconciliar a documentação global de C.2 e seus critérios de saída;
10. manter C.3–C.7 bloqueados até autorização humana própria;
11. manter conteúdo real, PNLD real, Supabase hospedado, Storage hospedado, secrets e produção bloqueados;
12. não alterar `INGESTION_CONTRACT_VERSION`, state machine ou ownerships sem nova decisão arquitetônica explícita.

Este checkpoint **não inicia C.2.6**.

## Próximo escopo elegível

O próximo sublote na sequência canônica é:

`C.2.6 — prova integrada, fechamento e gate para C.3`.

Ele permanece **BLOQUEADO** após C.2.5 e deverá começar em novo contexto com inspeção canônica, Definition of Ready e autorização humana específica.

C.3 continua bloqueado mesmo após a futura conclusão de C.2.6 até possuir sua própria inspeção, definição e autorização humana.

## Autoridade de continuidade

Após a integração desta reconciliação documental, o Checkpoint 049 passa a ser a referência operacional corrente para a Knowledge Factory.

O Checkpoint 048 permanece histórico e não será reescrito.
