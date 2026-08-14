# CONTINUITY CHECKPOINT 046 — C.2.2 integrado; C.2.3 permanece bloqueado

Data: 14 de agosto de 2026.

## Estado canônico

- repositório: `PaulinhoRehfeld/profeplan`;
- branch canônica: `main`;
- commit técnico canônico de C.2.2: `7557bc3aa80ce5ebd6423b10a179fa3790b97cb6`;
- tree: `61747e439323dcc165c8d3a084e4d73c66f06c4a`;
- parent direto: `93d50fc9b2fae63195db59477300215be0700ed5`;
- PR nº 67: integrado por squash merge em 14 de agosto de 2026;
- título canônico: `feat(knowledge-factory): implement C.2.2 secure staging (#67)`;
- HEAD do PR validado antes do merge: `504d856de49780d7cc5414549824c0aefc558234`;
- CI geral do PR: CI Pipeline nº 411 — `success`;
- prova física específica: Knowledge Factory C.2.2 Staging CI nº 21 — `success`;
- regressão C.1.4: Knowledge Factory C.1.4 Adapter CI nº 32 — `success`;
- regressão C.1.5: Knowledge Factory C.1.5 Lifecycle CI nº 29 — `success`;
- regressão de banco: Knowledge Factory DB CI nº 83 — `success`;
- CI pós-merge da `main`: CI Pipeline nº 412 — `success`.

O estado anterior estava formalizado pelo Checkpoint 045. Esse checkpoint permanece evidência histórica do encerramento de C.2.1 e do bloqueio anterior de C.2.2 e não deve ser reescrito.

## Autorização e governança aplicada

C.2.2 foi aberto em contexto próprio por autorização humana explícita após inspeção canônica. A execução permaneceu 100% remota, usando GitHub como fonte canônica e GitHub Actions para as provas descartáveis.

A autorização permitiu ações ordinárias estritamente dentro de C.2.2, incluindo branch, implementação, testes sintéticos, Draft PR, revisão, Ready, squash merge e reconciliação documental.

A autorização não incluiu e não foi usada para:

- secrets ou credenciais hospedadas;
- Supabase hospedado;
- bucket/container hospedado;
- storage de produção;
- `service_role` real;
- conteúdo real, PNLD real ou PDF real;
- produção;
- checksum/deduplicação de C.2.3;
- extração ou C.3;
- force push ou alteração de branch protection.

## Definition of Ready de C.2.2 comprovada

Antes da implementação foram confirmados remotamente:

- a `main` vigente e sua genealogia;
- PR nº 63 e Checkpoint 045 integrados;
- CI Pipeline nº 380 verde no checkpoint anterior;
- definição normativa de C.2;
- ADR-062;
- definição técnica e contratos integrados de C.2.1;
- `INGESTION_CONTRACT_VERSION = 1.0.0`;
- state machine, commands, receipts e invariantes de C.2.1;
- `TemporaryStagingArtifactRef` provider-neutral;
- independência entre `temporary_staging`, `ingestion` e `extraction`;
- ausência de porta canônica de staging previamente existente;
- existência do package provider-specific `@profeplan/knowledge-factory-supabase`;
- ausência de branch/PR concorrente de C.2.2;
- C.2.3–C.2.6 e C.3–C.7 preservados como bloqueados.

A `main` havia avançado um commit documental/comercial após o Checkpoint 045. C.2.2 foi corretamente baseado na `main` real `93d50fc9b2fae63195db59477300215be0700ed5`, cujo histórico preservava integralmente C.2.1.

## Resultado técnico de C.2.2

C.2.2 criou uma fronteira física mínima, temporária e governada para intake/staging, sem misturar bytes com extração, corpus ou persistência PostgreSQL permanente.

A definição técnica integrada está em:

`12-delivery/LOT-C2-2-SECURE-STAGING-LIMITS-AND-RETENTION.md`.

O contrato complementar está em:

`packages/types/src/knowledge-factory/staging.ts`.

A porta e policy provider-neutral estão em:

- `packages/knowledge-factory/src/staging/staging.port.ts`;
- `packages/knowledge-factory/src/policies/staging.ts`.

O primeiro adapter físico está isolado em:

`packages/knowledge-factory-supabase/src/staging/supabase-temporary-staging.adapter.ts`.

Versão do contrato complementar:

`STAGING_CONTRACT_VERSION = 1.0.0`.

## Reuso de C.2.1 sem duplicação

C.2.2 reutiliza diretamente:

- `IngestionRequest`;
- `source_version`;
- `received_file`;
- `processing_run`;
- `TemporaryStagingArtifactRef`;
- evidências independentes de autorização para `temporary_staging` e `ingestion`;
- correlation IDs e identidades já presentes no boundary de C.2.1.

A policy de intake chama a policy de solicitação de C.2.1 antes de admitir bytes. C.2.2 não redefiniu a state machine do `processing_run` nem reabriu C.1.

## Lifecycle físico do artefato

O lifecycle do artefato temporário foi mantido distinto do lifecycle do `processing_run`.

Vocabulário normativo:

```text
EXPECTED
  -> RECEIVING
  -> STAGED
  -> VERIFIED
  -> RELEASED_FOR_EXTRACTION
  -> DISCARD_PENDING
  -> DISCARDED

RECEIVING/STAGED/VERIFIED
  -> QUARANTINED
  -> FAILED
```

C.2.2 materializa operacionalmente somente os estados que pertencem ao seu escopo:

- `STAGED` — após criação física confirmada;
- `DISCARDED` — após remoção e verificação de ausência.

`VERIFIED` e `RELEASED_FOR_EXTRACTION` não foram implementados por C.2.2. Continuam dependentes dos sublotes posteriores correspondentes.

## Política de intake e limites

A policy centralizada e tipada cobre:

- arquivo individual máximo de 50 MiB;
- máximo de 10 arquivos por `processing_run`;
- máximo de 200 MiB por `processing_run`;
- duração máxima de intake de 15 minutos;
- media type `application/pdf`;
- extensão `.pdf`;
- retenção padrão de 6 horas;
- retenção máxima de 24 horas;
- filename máximo de 255 caracteres;
- filename hostil, barras, `..`, null/control characters;
- normalização NFC do filename;
- media type normalizado;
- assinatura física mínima `%PDF-` apenas como proteção de intake.

Nenhum digest criptográfico, checksum, deduplicação ou equivalência binária foi implementado.

## Provider-neutrality e isolamento

O domínio e contratos compartilhados não expõem:

- bucket;
- path físico;
- signed URL;
- região;
- access key;
- secret;
- `SupabaseClient`;
- erro bruto de provider;
- SQLSTATE.

O adapter deriva internamente o object key de `processing_run + artifactId`, com segmentos codificados. O filename original nunca compõe o object key.

`upsert` permanece desabilitado. Colisão não sobrescreve objeto existente e é traduzida para `CONFLICT` provider-neutral.

O locator opaco vincula logicamente `processing_run + artifactId` sem revelar provider. Um discard com run divergente falha com `INVALID_INPUT` antes de qualquer chamada ao storage.

## Retenção e descarte verificável

Todo descriptor de staging possui `createdAt` e `expiresAt`.

Artefato no instante de expiração ou depois não está disponível para novo avanço.

O adapter somente emite `TemporaryStagingDiscardReceipt` em estado `DISCARDED` depois de:

1. solicitar a remoção;
2. consultar o namespace privado correspondente;
3. confirmar a ausência do objeto.

Se a ausência não puder ser comprovada, a operação falha de forma sanitizada e não declara descarte concluído.

Em falha não conflitiva de upload é tentado cleanup best-effort. Em conflito, cleanup é deliberadamente proibido para não apagar objeto preexistente.

## Persistência deliberadamente não criada

C.2.2 não adicionou:

- tabela;
- migration;
- RPC;
- RLS/grant PostgreSQL;
- persistência de bytes no Postgres.

Essa decisão preserva a separação de responsabilidades: a persistência/command boundary operacional da execução pertence a C.2.4. Bytes permanecem exclusivamente em storage temporário durante a prova física.

## Prova remota e descartável

O workflow integrado é:

`.github/workflows/knowledge-factory-c2-2-staging-ci.yml`.

A execução verde nº 21:

- iniciou Supabase local/descartável no runner com Storage habilitado;
- gerou somente credenciais locais efêmeras e as mascarou;
- criou bucket privado exclusivamente dentro da stack descartável;
- executou typecheck dos packages envolvidos;
- executou 14 testes de policy C.2.2;
- executou 9 testes de boundary/adapter;
- executou a integração física de Storage;
- comprovou upload sintético, colisão sem overwrite, isolamento por run e locator opaco;
- comprovou que identidade `anon` não consegue ler nem alterar o artefato temporário, independentemente de o provider representar uma operação negada como erro ou no-op;
- comprovou descarte verificável e repetível;
- removeu o bucket descartável;
- destruiu a stack com `supabase stop --no-backup`;
- publicou evidência sanitizada como artifact de CI.

Nenhum recurso hospedado participou da prova.

## Regressões e gates do PR nº 67

Antes do squash merge foram confirmados:

- base canônica em `93d50fc9b2fae63195db59477300215be0700ed5`;
- HEAD exato `504d856de49780d7cc5414549824c0aefc558234`;
- `0 behind` da `main`;
- 14 arquivos alterados, estritamente compatíveis com C.2.2;
- nenhuma review thread pendente;
- nenhum secret ou credencial real;
- nenhum conteúdo real;
- nenhuma migration, Edge Function, frontend ou endpoint;
- nenhuma implementação de C.2.3;
- nenhum provider vazando para o domínio compartilhado;
- CI Pipeline nº 411 — `success`;
- C.2.2 Staging CI nº 21 — `success`;
- C.1.4 Adapter CI nº 32 — `success`;
- C.1.5 Lifecycle CI nº 29 — `success`;
- Knowledge Factory DB CI nº 83 — `success`;
- squash merge executado com `expected_head_sha`.

Os dois checks Vercel no HEAD final do PR permaneceram impedidos exclusivamente por `build-rate-limit`, ocorrência externa conhecida da camada gratuita. Nenhum gate técnico foi relaxado por esse motivo.

## Validação pós-merge

A `main` foi confirmada em:

- SHA `7557bc3aa80ce5ebd6423b10a179fa3790b97cb6`;
- tree `61747e439323dcc165c8d3a084e4d73c66f06c4a`;
- parent `93d50fc9b2fae63195db59477300215be0700ed5`.

O CI Pipeline nº 412, executado por `push` nesse SHA, terminou `success` com formatter, lint, typecheck, build e testes verdes.

## Estado operacional após este checkpoint

- C.0 — concluído;
- C.1 — concluído;
- C.2 — em execução governada;
- C.2.1 — integrado e revalidado;
- **C.2.2 — integrado e revalidado**;
- **C.2.3 — bloqueado**;
- C.2.4–C.2.6 — bloqueados;
- C.3–C.7 — bloqueados;
- `GAP-3B-05` — ativo e contido;
- `GAP-3B-07` — ativo e contido;
- conteúdo real — bloqueado;
- Supabase hospedado — bloqueado;
- storage hospedado — bloqueado;
- produção — bloqueada.

## Definition of Ready de C.2.3

C.2.3 altera novamente a natureza técnica do lote porque introduzirá integridade criptográfica, checksum, duplicidade e vínculo.

Ele **não pode iniciar automaticamente** após C.2.2.

Antes de qualquer implementação de C.2.3 será obrigatório, em contexto próprio:

1. confirmar a `main` e o checkpoint canônico vigente;
2. inspecionar integralmente C.2.1 e C.2.2 já integrados;
3. revalidar a definição normativa de C.2 e o ADR-062;
4. separar integridade física de equivalência jurídica/editorial;
5. definir algoritmo(s) de digest e representação provider-neutral sem usar checksum como identidade bibliográfica;
6. definir decisões explícitas para replay, duplicado técnico, conflito de identidade e rejeição sem antecipar C.2.4;
7. usar exclusivamente fixtures sintéticas e infraestrutura descartável;
8. manter C.2.4–C.2.6 e C.3–C.7 bloqueados;
9. obter autorização explícita para qualquer recurso hospedado, secret, credencial, conteúdo real ou produção.

Este checkpoint **não autoriza C.2.3**.

## Próximo escopo elegível

O próximo sublote na sequência canônica é:

`C.2.3 — integridade, checksum, duplicidade e vínculo`.

Ele permanece **BLOQUEADO** nesta continuidade e deverá começar em nova conversa/contexto com inspeção canônica própria.

## Autoridade de continuidade

Após a integração desta reconciliação documental, o Checkpoint 046 passa a ser a referência operacional corrente para a Knowledge Factory.

O Checkpoint 045 permanece histórico e não será reescrito.
