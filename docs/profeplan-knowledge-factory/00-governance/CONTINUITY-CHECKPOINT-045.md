# CONTINUITY CHECKPOINT 045 — C.2.1 integrado; C.2.2 permanece bloqueado

Data: 14 de agosto de 2026.

## Estado canônico

- repositório: `PaulinhoRehfeld/profeplan`;
- branch canônica: `main`;
- commit canônico de C.2.1: `e0ba47bf063b324df141c370ebf371763fbf2364`;
- tree: `a78d930b9491724c79665e420ceebc609b122d18`;
- parent direto: `a856532c6c5c40effb492f260a2d1a6b869f70b3`;
- PR nº 62: integrado por squash merge em 14 de agosto de 2026;
- título canônico: `feat(knowledge-factory): define C.2.1 ingestion contracts (#62)`;
- HEAD do PR validado antes do merge: `ce8cba892298767bd1c94bf47c56b36cabe4f2f0`;
- CI do PR: CI Pipeline nº 372 — `success`;
- regressão específica: Knowledge Factory C.1.5 Lifecycle CI nº 8 — `success` em Supabase descartável;
- CI pós-merge da `main`: CI Pipeline nº 373 — `success`.

O estado anterior estava formalizado pelo Checkpoint 044. Esse checkpoint permanece evidência
histórica da definição de C.2 e não deve ser reescrito.

## Autorização humana e governança aplicada

A continuidade de C.2.1 foi aberta por autorização humana explícita, com ações ordinárias sem risco
de segurança pré-autorizadas dentro do sublote. A execução permaneceu estritamente remota e usou o
GitHub como fonte canônica.

A autorização não incluiu e continua não incluindo:

- secrets ou credenciais reais;
- Supabase hospedado;
- storage real;
- produção;
- exclusões destrutivas;
- force push;
- alteração de branch protection;
- C.2.2 ou qualquer etapa posterior.

## Definition of Ready de C.2.1 comprovada

Antes de implementar foram confirmados remotamente:

- `main` em `a856532c6c5c40effb492f260a2d1a6b869f70b3`;
- tree `33fc9e4bd4fc2fe1cb04263230c274cb4e0c0b9a`;
- parent `787432fa8e7f5d891899c94b1089803430a4734a`;
- PR nº 60 integrado;
- CI Pipeline nº 369 verde;
- Checkpoint 044 presente e canônico;
- definição normativa de C.2 presente;
- ADR-062 integrado;
- contratos C.1 `1.0.0`, exports, testes e consumidores inspecionados;
- ausência de PR ou branch concorrente de implementação de C.2.1;
- autorização humana específica para C.2.1 nesta continuidade;
- C.2.2–C.2.6 e C.3–C.7 mantidos bloqueados.

## Resultado técnico de C.2.1

C.2.1 materializou uma superfície contratual própria e provider-neutral para a execução controlada
de ingestão, sem ampliar semanticamente a fronteira registral de C.1.3.

A definição técnica integrada está em:

`12-delivery/LOT-C2-1-INGESTION-CONTRACTS-AND-STATE-MACHINE.md`.

O contrato compartilhado está em:

`packages/types/src/knowledge-factory/ingestion.ts`.

A política determinística está em:

`packages/knowledge-factory/src/policies/ingestion.ts`.

Versão do contrato:

`INGESTION_CONTRACT_VERSION = 1.0.0`.

## Reuso de C.1 sem duplicação

C.2.1 reutiliza por composição e estreitamento conceitos já canônicos de C.1:

- `source_version`;
- `received_file`;
- `processing_run`;
- `temporary_staging`;
- `ingestion`;
- `extraction`;
- ator identificado;
- command ID;
- fingerprint;
- correlation ID;
- timestamps;
- versão e sequência esperadas.

C.2.1 não reabre C.1.3 e não transforma sua fronteira de comando registral em fronteira operacional
de ingestão.

## State machine integrada

Fluxo feliz canônico:

```text
REQUESTED
  -> STAGING
  -> STAGED
  -> VERIFYING
  -> VERIFIED
  -> PENDING_REVIEW
  -> APPROVED_FOR_EXTRACTION
```

Saídas controladas a partir de qualquer estado não terminal:

```text
REJECTED | FAILED | CANCELLED
```

Estados terminais dentro de C.2:

- `APPROVED_FOR_EXTRACTION`;
- `REJECTED`;
- `FAILED`;
- `CANCELLED`.

A máquina não permite saltos de estado, avanço após estado terminal ou aprovação implícita.

## Comandos, eventos e receipts

C.2.1 integrou comandos tipados e mapeamento determinístico comando → estado-alvo para:

- `request_ingestion`;
- `begin_staging`;
- `mark_staged`;
- `begin_verification`;
- `confirm_verified`;
- `request_review`;
- `approve_for_extraction`;
- `reject_ingestion`;
- `fail_ingestion`;
- `cancel_ingestion`.

Os eventos e receipts transportam apenas dados de domínio provider-neutral. Eles não expõem:

- `SupabaseClient`;
- bucket;
- signed URL;
- SQLSTATE;
- `service_role`;
- SDK de storage;
- stack trace;
- secret;
- path físico de provider.

Comando inválido produz decisão de domínio negada, não receipt de sucesso. Isso preserva a diferença
entre o estado de negócio `REJECTED` e a rejeição técnica de uma transição inválida.

## Idempotência e concorrência otimista no contrato

A regra integrada de replay é:

```text
commandId novo
  -> comando novo

mesmo commandId + mesmo fingerprint
  -> replay estável do mesmo receipt

mesmo commandId + fingerprint diferente
  -> INGESTION_IDEMPOTENCY_CONFLICT
```

Transições operacionais carregam `expectedState`, e o envelope preserva `expectedVersion` e
`expectedSequence` quando aplicáveis. Persistência e fronteira transacional de C.2 não foram
antecipadas.

## Autorização por finalidade preservada

C.2.1 mantém independentes as finalidades já governadas por C.1:

- `temporary_staging`;
- `ingestion`;
- `extraction`.

Uma solicitação de ingestão exige evidência explícita de `temporary_staging` e `ingestion` para a
mesma `source_version`.

Autorização de `extraction` não substitui `ingestion`, e autorização de `ingestion` não substitui
`extraction`.

## Revisão humana e limite C.2 → C.3

O contrato de revisão registra explicitamente:

- identidade da revisão;
- `reviewMode: 'human'`;
- revisor identificado;
- decisão;
- instante;
- motivo.

`APPROVED_FOR_EXTRACTION` só satisfaz a invariante contratual quando coexistem:

```text
review.reviewMode == human
AND
review.decision == APPROVE_FOR_EXTRACTION
AND
autorização C.1 independente para purpose == extraction
```

C.2.1 não implementa o handoff operacional para C.3; essa fronteira permanece destinada a C.2.5 e
à prova integrada de C.2.6.

## Staging preservado como fronteira futura

`REQUESTED` não transporta referência de staging.

A referência provider-neutral `TemporaryStagingArtifactRef` aparece apenas no comando que confirma
`STAGING -> STAGED`, com:

- `artifactId`;
- `opaqueLocator`.

Ela não identifica bucket, provider, path físico ou signed URL.

Nenhum artefato físico foi criado por C.2.1.

## Testes sintéticos integrados

C.2.1 adicionou exclusivamente fixtures sintéticas e testes de:

- versão e shape do contrato;
- lista exata de estados;
- estados terminais;
- mapeamento comando → estado-alvo;
- happy path sequencial;
- saídas excepcionais;
- saltos inválidos;
- expected-state mismatch;
- terminais sem saída;
- replay idêntico;
- conflito de fingerprint;
- independência entre finalidades;
- revisão humana obrigatória;
- receipt serializável;
- ausência de detalhes de provider na superfície compartilhada.

A suíte `@profeplan/knowledge-factory` executou 77 testes, com 77 aprovados e 0 falhas durante a
validação do PR.

## Histórico de CI e correção de baseline do próprio PR

Na primeira rodada do PR, o CI Pipeline nº 371 encontrou exclusivamente formatação Prettier em
`packages/knowledge-factory/src/policies/ingestion.ts`.

A correção foi feita sem alterar configuração de qualidade ou relaxar CI. O HEAD final
`ce8cba892298767bd1c94bf47c56b36cabe4f2f0` executou:

- Prettier — verde;
- ESLint — verde;
- TypeScript — verde;
- Build — verde;
- Tests — verde.

O CI Pipeline nº 372 terminou `success`.

## Regressão C.1.5

O workflow Knowledge Factory C.1.5 Lifecycle CI nº 8 terminou `success` sobre o HEAD final do PR.

A prova usou exclusivamente Supabase descartável no GitHub Actions e confirmou, entre outros:

- contratos provider-neutral;
- RLS positiva e negativa;
- competência e least privilege;
- comandos e supersession;
- idempotência e CAS;
- rollback de falha parcial;
- concorrência real multi-sessão;
- leitura histórica;
- rollback e reaplicação estrutural;
- regressão de adapter;
- prova temporal e de supersession;
- lint do banco descartável;
- descarte final da stack.

Nenhum Supabase hospedado ou produção foi acessado.

## Gates do PR nº 62

Antes do squash merge foram confirmados:

- base canônica ainda em `a856532c6c5c40effb492f260a2d1a6b869f70b3`;
- HEAD exato `ce8cba892298767bd1c94bf47c56b36cabe4f2f0`;
- `0 behind` da `main`;
- nove arquivos alterados, estritamente C.2.1;
- nenhuma review thread pendente;
- nenhum secret;
- nenhuma dependência nova;
- nenhum provider vazando para os contratos;
- CI Pipeline nº 372 — `success`;
- Knowledge Factory C.1.5 Lifecycle CI nº 8 — `success`;
- squash merge executado com `expected_head_sha`.

## Validação pós-merge

A `main` foi confirmada em:

- SHA `e0ba47bf063b324df141c370ebf371763fbf2364`;
- tree `a78d930b9491724c79665e420ceebc609b122d18`;
- parent `a856532c6c5c40effb492f260a2d1a6b869f70b3`.

O CI Pipeline nº 373, executado por `push` nesse SHA, terminou `success` com formatter, lint,
typecheck, build e testes verdes.

## Ocorrência externa Vercel

No HEAD final do PR nº 62, o projeto Vercel `site` concluiu com sucesso. O projeto `profeplan`
permaneceu impedido de gerar deployment pelo limite externo `build-rate-limit` da camada gratuita,
mesma classe já observada durante os PRs nº 59 e nº 60.

Essa ocorrência não foi tratada como falha do código e nenhum gate de qualidade ou segurança foi
relaxado por esse motivo.

## Gaps herdados

O estado dos gaps não foi alterado incidentalmente:

- `GAP-3B-01` — encerrado;
- `GAP-3B-02` — encerrado;
- `GAP-3B-03` — encerrado;
- `GAP-3B-04` — encerrado em C.1.6;
- `GAP-3B-05` — ativo e contido;
- `GAP-3B-06` — encerrado;
- `GAP-3B-07` — ativo e contido.

C.2.1 não tentou resolver `GAP-3B-05` nem `GAP-3B-07`.

## Reconciliação documental pós-merge

A reconciliação foi iniciada na branch:

`docs/knowledge-factory-c2-1-post-merge`.

Foi aberto o Draft PR nº 63:

`docs(knowledge-factory): formalize C.2.1 post-merge`.

Seu escopo é exclusivamente documental e inclui:

- este Checkpoint 045;
- README;
- Blueprint;
- mapa vivo da Fase C.

O Checkpoint 044 permanece histórico e não será reescrito. A reconciliação só será considerada
canônica depois de revisão integral, CI aplicável verde e integração governada do PR nº 63.

## Estado operacional após este checkpoint

- C.0 — concluído;
- C.1 — concluído;
- `GAP-3B-04` — encerrado;
- C.2 — em execução governada;
- **C.2.1 — integrado e revalidado**;
- **C.2.2 — bloqueado**;
- C.2.3–C.2.6 — bloqueados;
- C.3–C.7 — bloqueados;
- `GAP-3B-05` — ativo e contido;
- `GAP-3B-07` — ativo e contido;
- conteúdo real — bloqueado;
- Supabase hospedado — bloqueado;
- storage real — bloqueado;
- produção — bloqueada.

## Definition of Ready de C.2.2

C.2.2 representa mudança de natureza arquitetônica porque introduzirá intake/staging, limites,
retenção e questões explícitas de segurança/storage.

Por decisão de governança desta continuidade, ele **não pode iniciar automaticamente** após C.2.1.

Antes de qualquer implementação de C.2.2 será obrigatório, em contexto próprio:

1. confirmar a `main` e o checkpoint canônico vigente;
2. inspecionar o contrato C.2.1 integrado e seus invariantes;
3. inspecionar novamente a definição normativa de C.2 e o ADR-062;
4. definir a fronteira de segurança do staging e a política de retenção/descarte;
5. identificar limites, tipos aceitos e ameaça de abuso sem antecipar checksum/deduplicação de C.2.3;
6. definir testes exclusivamente sintéticos/descartáveis;
7. confirmar que C.2.3–C.2.6 e C.3 permanecem bloqueados;
8. obter autorização explícita para qualquer ação que envolva secrets, credenciais, storage real,
   Supabase hospedado ou produção.

Este checkpoint **não autoriza C.2.2**.

## Limites preservados

C.2.1 não criou nem ativou:

- bucket;
- Supabase Storage;
- S3;
- Azure Blob;
- filesystem operacional;
- upload;
- multipart;
- signed URL;
- leitura de bytes;
- checksum real;
- MIME físico;
- migration;
- tabela;
- RPC;
- RLS;
- grants;
- adapter Supabase;
- Edge Function;
- API;
- frontend;
- fila;
- worker;
- cron;
- Trigger.dev;
- fonte real;
- PNLD real;
- PDF real;
- OCR;
- extração;
- segmentação;
- chunks;
- embeddings;
- retrieval;
- agentes;
- produção.

## Próximo escopo elegível

O próximo sublote na sequência canônica é:

`C.2.2 — intake/staging seguro, limites e retenção`.

Ele permanece **BLOQUEADO** nesta continuidade e deverá começar em nova conversa/contexto com
inspeção canônica própria. Nenhuma ação de C.2.2 deve ser inferida da conclusão de C.2.1.

## Autoridade de continuidade

Após a integração desta reconciliação documental, o Checkpoint 045 passa a ser a referência
operacional corrente para a Knowledge Factory.

O Checkpoint 044 permanece evidência histórica da definição de C.2 e do bloqueio anterior de C.2.1.