# C.2.4 — idempotência, retomada e falha segura

Data de implementação técnica: 14/15 de agosto de 2026.

Base reconciliada da branch: `main` em `56e125bf72aabb885b0c0bc8b27f64d76ce98106`.

Estado deste documento: **implementação em Draft PR; não integrada**.

## 1. Autoridade e fronteiras preservadas

C.2.4 materializa operacionalmente as invariantes já definidas em C.2.1–C.2.3 sem redefinir seus contratos históricos.

Permanecem inalterados:

- `INGESTION_CONTRACT_VERSION = 1.0.0`;
- state machine do `processing_run` de C.2.1;
- `STAGING_CONTRACT_VERSION = 1.0.0`;
- `INTEGRITY_CONTRACT_VERSION = 1.0.0`;
- SHA-256 por readback como autoridade de integridade física;
- separação entre igualdade binária e identidade bibliográfica/jurídica;
- revisão humana e autorização de `extraction` como capacidades posteriores de C.2.5.

C.1 continua autoridade sobre identidades governadas e autorizações. C.2 passa a ser autoridade sobre o lifecycle operacional persistido de um `processing_run`.

## 2. Problema resolvido

Antes de C.2.4, C.2 possuía:

- idempotência contratual por `commandId + fingerprint`;
- state machine determinística;
- staging temporário provider-neutral;
- integridade SHA-256 sobre readback;

mas não possuía persistência capaz de responder com segurança a:

- replay após perda da resposta;
- dois comandos simultâneos;
- retry durante execução concorrente;
- crash entre Storage e PostgreSQL;
- timeout de provider com resultado desconhecido;
- falha após digest calculado e antes de `VERIFIED`;
- cleanup concorrente com recovery.

C.2.4 introduz o control-plane durável mínimo necessário para resolver essas situações.

## 3. Unidade e chave de idempotência

Os conceitos permanecem separados:

| Conceito | Unidade/chave |
|---|---|
| idempotência do comando | `commandId` |
| equivalência do comando | fingerprint canônico v1 |
| lifecycle operacional | `processing_run` |
| retry físico | mesmo run + mesmo artifact preparado |
| staging artifact | `artifactId` |
| arquivo recebido | `received_file` |
| igualdade binária | SHA-256 dos bytes observados |
| identidade bibliográfica | fora de C.2.4 |

O digest do arquivo não é idempotency key.

## 4. Fingerprint canônico v1

A boundary usa envelope canônico:

```text
fingerprintVersion = 1
operation
payload canônico
→ SHA-256
→ hexadecimal minúsculo de 64 caracteres
```

`commandId` e o fingerprint recebido não participam do payload canônico.

O caller pode calcular o fingerprint pela policy compartilhada, porém PostgreSQL recalcula o valor independentemente antes de aceitar o comando. Um `commandId` reutilizado com comando divergente retorna conflito fail-closed.

## 5. Persistência C.2.4

A migration cria cinco estruturas próprias de C.2:

### `kf_ingestion_runs`

Projection operacional do `processing_run` com:

- request;
- source version;
- received file;
- actor solicitante;
- state;
- aggregate version;
- sequence.

### `kf_ingestion_command_receipts`

Receipt append-only por `commandId`, contendo fingerprint, operação, run, state resultante, versão, sequence, correlation ID e motivo terminal quando aplicável.

### `kf_ingestion_events`

Histórico append-only de transições implementadas até `VERIFIED`, com unicidade de `(run_id, sequence)`.

### `kf_ingestion_staging_artifacts`

Control-plane durável do artifact físico:

- identidade composta;
- lifecycle físico;
- tamanho/media type;
- `createdAt`/`expiresAt` imutáveis;
- locator opaco quando confirmado;
- write-intent digest;
- estado e receipt do descarte.

Nenhum byte do arquivo é armazenado em PostgreSQL.

### `kf_ingestion_integrity_evidence`

Evidência C.2.3 persistida com digest SHA-256, byte length, tempo, correlation ID e classificação de duplicidade binária.

O índice de digest é deliberadamente **não exclusivo**.

## 6. Write-intent digest versus evidence C.2.3

C.2.4 persiste um SHA-256 dos bytes que o caller pretende gravar antes do efeito externo.

Esse digest serve exclusivamente para responder:

> O objeto encontrado após um timeout ambíguo corresponde exatamente ao conjunto de bytes cuja gravação foi tentada?

Ele não é:

- evidence oficial de C.2.3;
- identidade bibliográfica;
- identidade jurídica;
- autorização;
- idempotency key.

A integridade oficial permanece o SHA-256 calculado pelo adapter sobre **readback do objeto armazenado**.

## 7. Fronteira PostgreSQL ↔ Storage

PostgreSQL e Storage não são tratados como uma falsa transação distribuída.

O fluxo é uma saga durável:

```text
intenção persistida em PostgreSQL
        ↓
efeito físico no Storage
        ↓
reconciliação/observação
        ↓
confirmação transacional em PostgreSQL
```

Somente fatos confirmados no PostgreSQL fazem o `processing_run` avançar.

## 8. Timeout ambíguo e recovery

`SupabaseTemporaryStagingAdapter.stage()` não remove automaticamente o object key quando o erro é `UNAVAILABLE` ou `UNKNOWN`, porque o provider pode ter concluído o upload antes da perda da resposta.

A porta provider-neutral `TemporaryStagingRecoveryPort.inspect()` observa:

- `absent`; ou
- `present`, com readback SHA-256 e tamanho observado.

A policy de domínio permite:

- retry do upload somente se o objeto estiver ausente;
- reutilização do objeto presente somente quando run/artifact + tamanho + digest correspondem ao write intent persistido;
- conflito fail-closed diante de qualquer divergência;
- nenhuma retomada após `expiresAt`.

## 9. CAS e concorrência

A boundary usa duas serializações distintas:

1. advisory transaction lock por `commandId` para idempotência/replay;
2. row lock do `processing_run` + expected state/version/sequence para concorrência do aggregate.

Consequências:

- duas execuções simultâneas do mesmo comando produzem um apply e um replay;
- dois command IDs concorrentes sobre a mesma expectativa produzem um winner e um CAS conflict;
- replay após commit não adiciona evento;
- replay divergente falha fechado.

## 10. Atomicidade de `VERIFIED`

A confirmação de integridade executa na mesma transação PostgreSQL:

```text
insert integrity evidence
+ artifact STAGED → VERIFIED
+ processing_run VERIFYING → VERIFIED
+ append ingestion event
+ persist command receipt
```

Uma falha posterior a qualquer operação intermediária reverte o conjunto integral.

A suíte injeta deliberadamente uma falha na gravação do receipt para provar que evidence, artifact e run também fazem rollback.

## 11. Retenção e cleanup

`expiresAt` é imutável e retry não amplia retenção.

Antes da expiração, um artifact ainda necessário a um run recuperável não pode entrar em descarte.

No instante de expiração ou depois dele, C.2.2 já considera o artifact inelegível para avanço; C.2.4 pode então prepará-lo para cleanup mesmo que o run ainda precise posteriormente ser marcado como falha terminal.

O descarte possui duas boundaries:

```text
DB: DISCARD_PENDING
→ Storage: delete + confirmação de ausência
→ DB: DISCARDED
```

Repetir o efeito físico quando o objeto já está ausente produz `already_discarded`.

Se a resposta da confirmação PostgreSQL for perdida depois do commit, o snapshot persistido continua autoridade e o receipt original de descarte não é sobrescrito.

## 12. Terminalidade

C.2.4 não adiciona estados ao `processing_run`.

- falha técnica terminal → `FAILED`;
- cancelamento controlado → `CANCELLED`;
- erro técnico recuperável → permanece no último estado persistido não terminal;
- sucesso técnico desta etapa → `VERIFIED`.

`PENDING_REVIEW`, `REJECTED` por revisão e `APPROVED_FOR_EXTRACTION` permanecem fora da superfície RPC de C.2.4.

## 13. Cardinalidade conservadora

C.2.2 possui policy de limites que admite múltiplos artifacts por run, enquanto a state machine C.2.1 transporta um artifact de staging na transição atual.

C.2.4 não impõe `UNIQUE(run_id)` no schema, mas a boundary durável falha fechada ao tentar preparar um segundo `artifactId` distinto para o mesmo run.

Essa contenção evita inventar semântica de agregação multi-artifact. Uma futura definição explícita poderá ampliar a boundary sem migração destrutiva da cardinalidade física.

## 14. Segurança

Todas as cinco tabelas possuem RLS habilitado.

DML direto é revogado de:

- `PUBLIC`;
- `anon`;
- `authenticated`;
- `service_role`.

`service_role` recebe somente `EXECUTE` nas RPCs estreitas de C.2.4.

A existência de `service_role` não constitui autorização de negócio. `request_ingestion` revalida:

- kind de `source_version`;
- kind de `received_file`;
- autorizações C.1 `temporary_staging` e `ingestion` válidas no instante declarado.

Erros provider/database são traduzidos para códigos provider-neutral no adapter.

## 15. Superfície RPC C.2.4

Somente:

```text
kf_ingestion_request
kf_ingestion_begin_staging
kf_ingestion_mark_staged
kf_ingestion_begin_verification
kf_ingestion_confirm_verified
kf_ingestion_fail
kf_ingestion_cancel

kf_ingestion_prepare_staging_artifact
kf_ingestion_prepare_discard
kf_ingestion_confirm_discard
kf_ingestion_recovery_snapshot
```

Não existem RPCs de revisão humana ou aprovação para extraction neste sublote.

## 16. Prova automatizada

A suíte C.2.4 usa exclusivamente fixtures sintéticas e infraestrutura descartável dentro do GitHub Actions.

Cobertura específica:

- canonical fingerprint;
- replay idêntico;
- replay divergente;
- mesma command ID concorrente;
- command IDs concorrentes no mesmo run;
- CAS state/version/sequence;
- write intent idempotente/divergente;
- timeout ambíguo;
- recovery de objeto presente/ausente;
- conflict de bytes observados;
- retenção imutável;
- rollback integral de `confirm_verified`;
- evidence + run + artifact atomicamente `VERIFIED`;
- Storage local/descartável;
- descarte repetido;
- `already_discarded`;
- direct DML negado a `service_role`;
- ausência de RPC C.2.5;
- regressão C.2.1–C.2.3.

## 17. Fora de escopo

C.2.4 não implementa:

- C.2.5 ou C.2.6;
- revisão humana;
- handoff para extraction;
- parsing/OCR/extração;
- fila/worker/cron;
- lock distribuído persistente;
- outbox genérico;
- conteúdo real;
- PNLD real;
- Storage/Supabase hospedado;
- produção.

## 18. Gate

Enquanto o Draft PR técnico não estiver integralmente verde, revisado e posteriormente integrado por autorização humana específica, C.2.4 permanece **não integrado** e C.2.5 continua bloqueado.
