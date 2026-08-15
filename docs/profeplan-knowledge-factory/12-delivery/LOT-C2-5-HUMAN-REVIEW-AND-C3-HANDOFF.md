# Sublote C.2.5 — revisão humana e handoff governado para C.3

Data: 15 de agosto de 2026.

Base canônica inspecionada antes do início técnico:

- `main`: `d5ebf99a6265dd6f68ae2a4d2d8ca7c429a48c82`;
- tree: `ab6d100b8daf44d5ee9839faacd2c4ad3a1148ef`;
- parent: `886fbcfe9a543d121c599adbe8f585aec5175a05`;
- checkpoint vigente: `CONTINUITY-CHECKPOINT-048.md`.

## Status

**Trabalho técnico não integrado.**

Este documento pertence à branch/PR de C.2.5. Ele não substitui o Checkpoint 048 e não autoriza merge,
C.2.6, C.3, conteúdo real, Supabase hospedado, Storage hospedado ou produção.

## 1. Pergunta arquitetônica

C.2.5 responde somente:

> Como uma decisão humana autorizada sobre um `processing_run` tecnicamente íntegro é registrada,
> auditada e transformada em um fato persistido de elegibilidade para a fase seguinte, sem executar
> a fase seguinte?

A resposta adotada é:

1. usar exclusivamente os estados e comandos já definidos em C.2.1;
2. usar C.1 como autoridade de competência humana e de autorização `extraction`;
3. persistir a decisão humana no evento append-only que materializa a transição;
4. manter receipt, evento e projeção do run na mesma transação PostgreSQL;
5. expor um snapshot read-only de handoff;
6. não possuir qualquer comando, job, fila, worker ou efeito que execute C.3.

## 2. Contratos e ownership preservados

C.2.5 preserva:

- `INGESTION_CONTRACT_VERSION = 1.0.0`;
- state machine C.2.1 sem estado novo;
- C.1 como autoridade de identidade, competência e autorização;
- C.2 como autoridade do lifecycle operacional de `processing_run`;
- C.2.2 como autoridade de staging/retenção;
- C.2.3 como autoridade de integridade física;
- C.2.4 como autoridade de idempotência, recovery, locks, CAS e fail-safe;
- Storage como autoridade sobre bytes físicos;
- PostgreSQL como autoridade sobre fatos persistidos.

C.2.5 não modifica o lifecycle jurídico-editorial de C.1 e não cria uma segunda ACL.

## 3. State machine utilizada

Somente transições já existentes em C.2.1 são materializadas:

```text
VERIFIED
  --request_review--> PENDING_REVIEW

PENDING_REVIEW
  --approve_for_extraction--> APPROVED_FOR_EXTRACTION
  --reject_ingestion--------> REJECTED
```

`APPROVED_FOR_EXTRACTION` e `REJECTED` continuam terminais em C.2.

Não foram criados estados `UNDER_HUMAN_REVIEW`, `HANDOFF_READY`, `QUEUED_FOR_EXTRACTION` ou
equivalentes.

## 4. Competência humana

A decisão humana é uma operação de negócio, não uma propriedade de `service_role`.

### 4.1 `request_review`

`request_review` é uma transição operacional, não uma decisão jurídico-editorial. A boundary exige:

- ator `system_worker`;
- assignment C.1 ativo no instante do comando;
- exatamente um assignment ativo correspondente, evitando competência ambígua;
- run em `VERIFIED` com `expectedVersion` e `expectedSequence`;
- exatamente um artefato de staging;
- evidência de integridade persistida;
- artefato `VERIFIED` e ainda dentro da retenção no instante da solicitação.

### 4.2 decisão humana

`approve_for_extraction` e a rejeição humana exigem:

- `reviewMode = human`;
- `command.actor = review.reviewer`;
- papel `legal_editorial_reviewer`;
- assignment C.1 ativo no instante da decisão;
- cardinalidade exatamente igual a um assignment ativo;
- `review.decidedAt = command.occurredAt`;
- `expectedState = PENDING_REVIEW`;
- `expectedVersion` e `expectedSequence` obrigatórios na boundary de persistência.

A evidência persiste o `reviewer_assignment_id` utilizado. Esse ID não cria competência: apenas
referencia a autoridade C.1 que a comprovou.

## 5. Aprovação humana não é autorização de extraction

A implicação abaixo é proibida:

```text
human_review_approved => extraction_authorized
```

Para `approve_for_extraction`, C.2.5 exige independentemente:

- exatamente uma evidência de autorização;
- `purpose = extraction`;
- `sourceVersion` idêntica à do run;
- `evaluatedAt = review.decidedAt`;
- autorização C.1 historicamente `GRANTED` naquele instante;
- janela `effective_from/effective_until` válida naquele instante.

A avaliação usa o histórico canônico `kf_source_governance_events`, não apenas a projeção atual do
grant. Isso impede que uma autorização atualmente `GRANTED` masque suspensão/revogação válida no
instante histórico avaliado.

O ID e o instante da autorização utilizada são persistidos no evento de aprovação.

## 6. Integridade técnica e retenção

Aprovação exige:

- exatamente um artefato vinculado ao run;
- `kf_ingestion_integrity_evidence` correspondente;
- artefato ainda em `VERIFIED`;
- decisão anterior a `expiresAt`.

A rejeição humana pode ocorrer mesmo quando o artefato já não estiver disponível fisicamente, pois
ela encerra o run e não libera C.3. Ainda assim, a cadeia de integridade persistida e a identidade do
artefato revisado devem existir.

Retry e review não alteram `expiresAt`.

## 7. Evidência persistida da decisão

Não foi criada tabela paralela de review porque a decisão é o fato que produz a transição do agregado.
A evidência mínima auditável é persistida no `kf_ingestion_events` append-only:

- `review_id`;
- `reviewer_assignment_id`;
- `reviewer_actor_id`;
- `reviewer_actor_role`;
- `review_decision`;
- `review_decided_at`;
- `review_reason`;
- `reviewed_artifact_id`;
- `extraction_authorization_id` somente em aprovação;
- `extraction_authorization_evaluated_at` somente em aprovação.

O evento continua ligado a:

- `run_id`;
- `aggregate_version`;
- `sequence`;
- `command_id`;
- `correlation_id`;
- `from_state`/`to_state`;
- ator e razão do comando.

O receipt continua sendo a prova idempotente do comando aplicado/reproduzido.

## 8. Handoff governado

O handoff é representado por três fatos consistentes:

1. run terminal em `APPROVED_FOR_EXTRACTION`;
2. receipt `approve_for_extraction` correspondente à mesma versão/sequence;
3. evento `ingestion_approved_for_extraction` com review e autorização independentes.

`kf_ingestion_handoff_snapshot` apenas reconstrói esses fatos em forma provider-neutral.

Ele **não**:

- abre PDF;
- lê bytes;
- extrai texto;
- executa OCR;
- cria página/chunk/embedding;
- publica job;
- enfileira trabalho;
- chama worker;
- inicia C.3.

A eventual execução de C.3 deverá reavaliar sua própria autorização `extraction` no instante real da
execução. O snapshot de C.2.5 prova apenas que a autorização estava válida no instante da aprovação
humana.

## 9. Idempotência e replay

C.2.5 reutiliza a estratégia de C.2.4:

```text
commandId + canonical fingerprint
```

Regras:

- mesmo `commandId` + mesmo fingerprint: replay do receipt já persistido;
- mesmo `commandId` + fingerprint divergente: conflito fail-closed;
- fingerprint é recalculado server-side;
- replay é resolvido antes de reavaliar competência corrente, preservando a decisão histórica já
  comprometida;
- nenhum replay cria segundo evento.

## 10. Concorrência

A boundary reutiliza:

- advisory lock transacional por `commandId`;
- row lock `FOR UPDATE` do run;
- `expectedState`;
- `expectedVersion`;
- `expectedSequence`.

Consequências:

- dois cliques do mesmo comando convergem para applied + replay;
- dois commandIds sobre o mesmo snapshot têm somente um vencedor;
- `approve` e `reject` concorrentes não podem ambos vencer;
- decisão sobre snapshot obsoleto falha com conflito;
- resposta perdida é recuperável por replay idêntico;
- estado terminal não aceita segunda decisão.

Nenhum lock distribuído permanente foi introduzido.

## 11. Atomicidade e fail-closed

Run, receipt e evento da decisão são escritos na mesma transação PostgreSQL.

A prova de atomicidade injeta falha deliberada no insert do evento após o caminho de atualização da
projeção/receipt ter iniciado. A expectativa é rollback integral:

- run permanece `PENDING_REVIEW`;
- receipt da decisão não existe;
- review event não existe.

Falha fechada é exigida para:

- actor/reviewer divergentes;
- reviewer sem assignment;
- assignment expirado;
- assignment ambíguo;
- estado/versão/sequence obsoletos;
- artifact cardinality diferente de um;
- ausência de integrity evidence;
- artifact indisponível para aprovação;
- autorização `extraction` ausente, expirada ou historicamente não `GRANTED`;
- replay divergente;
- conflito concorrente.

## 12. Least privilege

As novas RPCs são estreitas, `SECURITY DEFINER`, com `search_path` fixo:

- `kf_ingestion_request_review`;
- `kf_ingestion_approve_for_extraction`;
- `kf_ingestion_reject`;
- `kf_ingestion_handoff_snapshot`.

Somente `service_role` recebe `EXECUTE` técnico.

`anon` e `authenticated` não recebem a capability. `service_role` continua sem DML direto nas tabelas
C.1/C.2 e sem `EXECUTE` dos helpers internos.

`service_role` não substitui o assignment C.1 do reviewer.

## 13. Provider-neutrality

O domínio compartilhado não expõe:

- bucket;
- path de Storage;
- signed URL;
- token;
- `SupabaseClient`;
- SQLSTATE;
- erro bruto do provider.

O adapter converte falhas de persistência para o contrato provider-neutral já existente.

## 14. Provas sintéticas

O gate C.2.5 usa exclusivamente Supabase/PostgreSQL descartável e IDs sintéticos.

Ele cobre, entre outros:

- request de review válido;
- aprovação válida;
- rejeição válida;
- reviewer sem competência;
- reviewer com assignment expirado;
- autorização `extraction` expirada;
- stale state/version/sequence;
- replay idêntico e divergente;
- resposta perdida;
- `service_role` sem business authority implícita;
- receipt/event auditáveis;
- snapshot de handoff;
- rejected run sem handoff;
- DML direto bloqueado;
- rollback deliberado;
- concorrência real entre duas sessões para o mesmo commandId;
- corrida real approve versus reject;
- regressão C.2.2–C.2.4;
- ausência de superfície de execução de C.3.

## 15. Bloqueios preservados

Permanecem bloqueados:

- merge sem autorização humana específica;
- C.2.6;
- implementação/execução de C.3;
- C.3–C.7;
- conteúdo real;
- PNLD real;
- PDF/livro real;
- Supabase hospedado;
- Storage hospedado;
- secrets de produção;
- produção.

Checkpoint 049 não pertence a este PR técnico antes de eventual integração e fechamento documental.