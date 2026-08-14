# C.2.1 — contratos, receipts e state machine da ingestão controlada

Data: 14 de agosto de 2026.

Base de implementação: `main` em `a856532c6c5c40effb492f260a2d1a6b869f70b3`.

## 1. Status e autoridade

Este sublote materializa exclusivamente a superfície contratual provider-neutral de C.2.1.

Deve ser lido em conjunto com:

- `LOT-C2-CONTROLLED-INGESTION-DEFINITION.md`;
- `../00-governance/ADR-062-C2-CONTROLLED-INGESTION-BOUNDARY.md`;
- `../00-governance/CONTINUITY-CHECKPOINT-044.md`;
- `../../../packages/types/src/knowledge-factory/source-lifecycle.ts`.

C.2.1 não altera o lifecycle jurídico-editorial de C.1 e não amplia a fronteira transacional de
C.1.3.

## 2. Decisão contratual

C.2.1 cria contrato próprio, versionado como `1.0.0`, para a execução operacional de ingestão.

A composição preserva C.1 como autoridade de governança:

```text
C.1
source_version + received_file + processing_run
+ autorização histórica por finalidade/instante
        ↓
C.2.1
solicitação + comandos + state machine + receipts
        ↓
C.2.2–C.2.5
implementações operacionais futuras
```

C.2.1 reutiliza as identidades e finalidades já definidas em C.1 por tipos estreitos. Não copia a
taxonomia de identidades nem declara equivalência entre finalidades.

O envelope de comando de C.2 é próprio porque a execução de ingestão não pertence à fronteira de
comandos registral de C.1.3.

## 3. Identidades

Os contratos usam referências estreitas sobre `SourceIdentityRef`:

- `IngestionSourceVersionRef` — obrigatoriamente `source_version`;
- `IngestionReceivedFileRef` — obrigatoriamente `received_file`;
- `IngestionRunRef` — obrigatoriamente `processing_run`.

Essas identidades permanecem distintas. Uma execução não é uma fonte, uma versão, um arquivo nem um
resultado de extração.

A referência futura ao artefato temporário é representada somente por:

- `artifactId`;
- `opaqueLocator`.

O contrato não conhece bucket, path físico, signed URL, SDK ou provider.

## 4. Autorização consumida de C.1

`IngestionAuthorizationEvidence` representa a evidência provider-neutral de que uma autorização de
C.1 foi avaliada para uma `source_version`, finalidade e instante explícitos.

As finalidades aceitas por C.2.1 são somente:

- `temporary_staging`;
- `ingestion`;
- `extraction`.

Regras:

1. uma solicitação de ingestão exige evidência explícita de `temporary_staging`;
2. a mesma solicitação exige evidência independente de `ingestion`;
3. `extraction` não substitui `ingestion`;
4. `ingestion` não substitui `extraction`;
5. aprovação para extração exige evidência própria de `extraction` e revisão humana aprovada;
6. o contrato de evidência não transforma o client em autoridade de negócio.

A obtenção transacional e a revalidação dessas evidências no instante correto pertencem aos
sublotes operacionais responsáveis. C.2.1 define a linguagem e as invariantes; não cria banco, RPC ou
adapter.

## 5. State machine normativa

A sequência feliz permanece exatamente a definida pelo Lote C.2:

```text
REQUESTED
  -> STAGING
  -> STAGED
  -> VERIFYING
  -> VERIFIED
  -> PENDING_REVIEW
  -> APPROVED_FOR_EXTRACTION
```

Saídas de exceção permitidas a partir de qualquer estado não terminal acima:

```text
-> REJECTED
-> FAILED
-> CANCELLED
```

Estados terminais em C.2:

- `APPROVED_FOR_EXTRACTION`;
- `REJECTED`;
- `FAILED`;
- `CANCELLED`.

Nenhum estado terminal possui transição de saída em C.2.1.

## 6. Comandos e estados-alvo

| Comando | Estado anterior permitido | Estado-alvo | Produtor registrado | Pré-condição contratual principal |
|---|---|---|---|---|
| `request_ingestion` | criação | `REQUESTED` | `actor` explícito | fonte/arquivo/run identificados; staging e ingestion autorizados |
| `begin_staging` | `REQUESTED` | `STAGING` | `actor` explícito | `expectedState` coerente |
| `mark_staged` | `STAGING` | `STAGED` | `actor` explícito | `expectedState` coerente |
| `begin_verification` | `STAGED` | `VERIFYING` | `actor` explícito | `expectedState` coerente |
| `confirm_verified` | `VERIFYING` | `VERIFIED` | `actor` explícito | `expectedState` coerente |
| `request_review` | `VERIFIED` | `PENDING_REVIEW` | `actor` explícito | `expectedState` coerente |
| `approve_for_extraction` | `PENDING_REVIEW` | `APPROVED_FOR_EXTRACTION` | `actor` + revisão humana explícita | decisão humana APPROVE + autorização `extraction` |
| `reject_ingestion` | qualquer não terminal | `REJECTED` | `actor` explícito | reason code provider-neutral |
| `fail_ingestion` | qualquer não terminal | `FAILED` | `actor` explícito | reason code provider-neutral |
| `cancel_ingestion` | qualquer não terminal | `CANCELLED` | `actor` explícito | reason code provider-neutral |

C.2.1 registra quem executou o comando por `SourceActorRef`, mas não inventa uma matriz nova de
competência por papel. A competência específica da revisão humana e sua fronteira operacional serão
fechadas em C.2.5.

## 7. Retry, replay e transição inválida

Todo comando carrega:

- `commandId`;
- `fingerprint`;
- `correlationId`;
- `actor`;
- `occurredAt`;
- `reason`;
- versão/sequência esperadas quando aplicável.

A regra de idempotência é:

```text
commandId novo
  -> new

mesmo commandId + mesmo fingerprint
  -> replay do mesmo receipt

mesmo commandId + fingerprint diferente
  -> INGESTION_IDEMPOTENCY_CONFLICT
```

Transição com `expectedState` divergente falha com razão provider-neutral antes de avaliar o avanço.
Transição não prevista pela máquina falha com `INGESTION_INVALID_TRANSITION`.

Retry ou replay nunca cria aprovação silenciosa.

## 8. Revisão humana

C.2.1 define somente o contrato necessário para que o gate futuro seja inequívoco:

- identidade da revisão;
- revisor identificado;
- decisão `APPROVE_FOR_EXTRACTION` ou `REJECT`;
- instante;
- motivo.

A presença de uma revisão não concede `extraction`. A aprovação exige simultaneamente:

```text
review.decision == APPROVE_FOR_EXTRACTION
AND
C.1 authorization evidence purpose == extraction
```

O handoff operacional para C.3 não é implementado neste sublote.

## 9. Receipts

`IngestionCommandReceipt` é evidência estável de comando aplicado ou replay consistente.

Ele contém somente:

- versão do contrato;
- `commandId` e fingerprint;
- `correlationId`;
- operação;
- `processing_run`;
- aggregate version e sequence;
- IDs de eventos;
- estado anterior quando houver;
- estado resultante;
- outcome `applied` ou `replayed`;
- instante de commit;
- reason code provider-neutral quando aplicável.

Um comando inválido não produz receipt de sucesso. Ele produz decisão de domínio negada com razão
provider-neutral. Isso evita confundir a transição válida para o estado de negócio `REJECTED` com a
rejeição técnica de um comando inválido.

Receipts não carregam stack trace, SQLSTATE, mensagem de provider, signed URL, secret, bucket ou
path físico.

## 10. Metadados técnicos minimizados

C.2.1 admite no contrato somente campos que já são necessários para os sublotes seguintes sem
executar a validação física:

- media type declarado, opcional;
- tamanho em bytes, opcional;
- referência opaca do artefato temporário, opcional.

Checksum real, media type detectado, duplicidade, política de tamanho, retenção, quarentena e
lifecycle físico do staging continuam destinados a C.2.2/C.2.3.

## 11. Fixtures e testes

Somente fixtures sintéticas são permitidas.

A prova de C.2.1 cobre:

- versão e shape do contrato;
- estados e terminais;
- mapeamento determinístico comando → estado-alvo;
- sequência feliz;
- saídas de exceção;
- saltos inválidos;
- estado esperado divergente;
- terminais sem saída;
- replay idêntico;
- conflito de fingerprint;
- independência entre `temporary_staging`, `ingestion` e `extraction`;
- revisão humana obrigatória;
- serialização estável do receipt;
- ausência de detalhes de provider no contrato compartilhado.

## 12. Não escopo preservado

C.2.1 não cria nem altera:

- migration, tabela, RPC, RLS ou grant;
- Supabase hospedado;
- bucket ou storage;
- S3, Azure Blob ou filesystem operacional;
- upload, bytes ou PDF;
- checksum real;
- adapter;
- Edge Function ou API;
- frontend;
- job, fila, worker ou cron;
- extração, OCR, chunks ou embeddings;
- handoff operacional para C.3;
- conteúdo real, PNLD real ou produção.

## 13. Gate de saída de C.2.1

C.2.1 está pronto para integração quando:

- contrato `1.0.0` estiver fechado e exportado;
- state machine estiver determinística e sem atalho para C.3;
- autorização por finalidade estiver preservada;
- revisão humana estiver estruturalmente obrigatória para aprovação;
- idempotência e invariantes estiverem cobertas por testes sintéticos;
- receipts forem provider-neutral;
- CI aplicável estiver verde;
- o diff não contiver implementação de C.2.2 ou produção.

A conclusão de C.2.1 não autoriza iniciar C.2.2.
