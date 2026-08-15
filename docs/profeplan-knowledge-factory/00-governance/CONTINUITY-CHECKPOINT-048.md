# CONTINUITY CHECKPOINT 048 — C.2.4 integrado; C.2.5 permanece bloqueado

Data: 15 de agosto de 2026.

## Estado canônico técnico

- repositório: `PaulinhoRehfeld/profeplan`;
- branch canônica: `main`;
- commit técnico canônico de C.2.4: `14b7ff30d1b659ed8b2c824f9a943b05cdca93bc`;
- tree: `92411aec0c9da3789bb91c87d8f423a3c69f929d`;
- parent direto: `56e125bf72aabb885b0c0bc8b27f64d76ce98106`;
- PR nº 74: integrado por squash merge em 15 de agosto de 2026;
- título canônico: `feat(knowledge-factory): implement C.2.4 durable recovery (#74)`;
- HEAD técnico validado antes do merge: `9c9556a880754c588e3f162bba7b3d0adaf5b403`;
- CI geral do HEAD final: CI Pipeline nº 518 — `success`;
- regressão de banco: Knowledge Factory DB CI nº 171 — `success`;
- regressão C.1.4: Knowledge Factory C.1.4 Adapter CI nº 66 — `success`;
- regressão C.1.5: Knowledge Factory C.1.5 Lifecycle CI nº 76 — `success`;
- regressão C.2.2: Knowledge Factory C.2.2 Staging CI nº 68 — `success`;
- regressão C.2.3: Knowledge Factory C.2.3 Integrity CI nº 47 — `success`;
- prova específica: Knowledge Factory C.2.4 Recovery CI nº 34 — `success`;
- CI pós-merge da `main`: CI Pipeline nº 523 — `success`.

O Checkpoint 047 permanece evidência histórica do encerramento de C.2.3 e do bloqueio anterior de C.2.4. Ele não deve ser reescrito.

## Resultado técnico de C.2.4

C.2.4 materializou a fronteira durável de idempotência, retomada e falha segura da ingestão controlada, preservando os contratos e ownerships estabelecidos em C.1 e C.2.1–C.2.3.

A definição técnica integrada está em:

`12-delivery/LOT-C2-4-IDEMPOTENCY-RECOVERY-AND-FAIL-SAFE.md`.

C.2.4 não criou uma segunda state machine e não alterou:

- `INGESTION_CONTRACT_VERSION = 1.0.0`;
- a topologia de estados de C.2.1;
- `STAGING_CONTRACT_VERSION = 1.0.0`;
- `INTEGRITY_CONTRACT_VERSION = 1.0.0`;
- C.1 como autoridade de identidade e autorização;
- C.2.2 como autoridade de staging/retention;
- C.2.3 como autoridade da evidência de integridade física por readback.

## Persistência durável de C.2

A migration integrada criou o control-plane mínimo próprio de C.2 por meio de:

- `kf_ingestion_runs`;
- `kf_ingestion_command_receipts`;
- `kf_ingestion_events`;
- `kf_ingestion_staging_artifacts`;
- `kf_ingestion_integrity_evidence`.

PostgreSQL permanece autoridade sobre fatos persistidos do lifecycle operacional. Storage permanece autoridade sobre bytes físicos. Nenhum byte de arquivo é persistido em PostgreSQL.

## Idempotência e replay

A unidade de idempotência permanece o `commandId`, associado a fingerprint canônico v1 recalculado server-side.

A fronteira prova:

- replay idêntico sem novo efeito lógico;
- replay divergente fail-closed;
- serialização concorrente do mesmo `commandId`;
- receipts persistidos e auditáveis;
- fingerprint separado de hash de conteúdo e de qualquer identidade bibliográfica/jurídica.

O digest binário não é idempotency key e não autoriza merge de `source_version`.

## Concorrência e CAS

C.2.4 usa fronteiras distintas para concorrência:

- lock transacional por `commandId` para replay/idempotência;
- row lock do `processing_run`;
- validação de `expectedState`;
- validação de `expectedVersion`;
- validação de `expectedSequence`.

Dois comandos distintos concorrendo sobre a mesma expectativa produzem um vencedor e conflito conservador para o concorrente obsoleto.

## Recovery sem pseudo-transação distribuída

A arquitetura integrada permanece:

```text
PostgreSQL persiste intenção / boundary segura
        ↓
Storage executa efeito físico externo
        ↓
reconciliação observa o efeito
        ↓
PostgreSQL confirma a boundary
```

Recovery parte do último fato persistido e reconcilia o efeito físico observado. Ele não tenta inferir o que uma execução anterior provavelmente fez.

Falha técnica recuperável mantém o `processing_run` na última boundary persistida segura. Não foram adicionados estados como `RECOVERING`, `RETRYING`, `ABANDONED` ou `RECOVERABLE_ERROR`.

## Write-intent e integridade por readback

O write-intent digest existe somente para reconciliar uma tentativa física de gravação após resposta ambígua do Storage.

A evidência oficial de C.2.3 continua sendo derivada do readback dos bytes efetivamente armazenados.

Quando o objeto físico observado diverge em tamanho ou digest do write intent persistido, a retomada falha fechada.

Hash igual continua significando igualdade binária observada; não significa identidade bibliográfica, jurídica, editorial ou semântica.

## Atomicidade de `VERIFIED`

A confirmação técnica de integridade persiste na mesma transação PostgreSQL:

- integrity evidence;
- staging artifact em `VERIFIED`;
- `processing_run` em `VERIFIED`;
- ingestion event;
- command receipt.

A suíte de rollback deliberado comprovou que uma falha intermediária não deixa confirmação parcial.

## Retenção e cleanup

`expiresAt` permanece imutável. Retry e recovery não renovam indefinidamente o TTL do staging artifact.

O descarte integrado usa duas fases:

```text
DISCARD_PENDING
  ↓
delete físico + confirmação de ausência
  ↓
DISCARDED
```

A repetição converge idempotentemente para ausência física e pode retornar `already_discarded` sem executar segundo efeito destrutivo desnecessário.

A prova cobre resposta de delete perdida, segundo delete, cleanup concorrente e artifact expirado.

## Cardinalidade multi-artifact

C.2.4 não introduziu `UNIQUE(run_id)` para simplificar a cardinalidade física.

Como a semântica de agregação multi-artifact ainda não está definida de forma suficiente, a boundary falha fechada quando um segundo `artifactId` distinto tenta ser preparado para o mesmo run.

Essa contenção preserva C.2.2 e evita transformar C.2.4 em definição incidental de agregação multi-artifact.

## Segurança e least privilege

Todas as tabelas C.2.4 possuem RLS habilitado.

DML direto permanece negado a:

- `PUBLIC`;
- `anon`;
- `authenticated`;
- `service_role`.

`service_role` recebe apenas `EXECUTE` nas RPCs estreitas aprovadas.

A presença de `service_role` não constitui autorização de negócio. `request_ingestion` revalida identidades e as autorizações C.1 necessárias no instante declarado.

Erros de provider/database são traduzidos para códigos provider-neutral antes de atravessar a boundary.

## Prova remota descartável

O workflow integrado é:

`.github/workflows/knowledge-factory-c2-4-recovery-ci.yml`.

A execução verde nº 34 comprovou, em Supabase/PostgreSQL/Storage descartáveis no GitHub Actions:

- aplicação da migration do zero;
- typecheck das boundaries C.2.4;
- testes unitários de recovery/repositories;
- idempotência durável;
- lifecycle e least privilege;
- rollback por falha parcial deliberada;
- concorrência real multi-session e CAS;
- Storage reconciliation;
- cleanup idempotente;
- regressões C.2.1–C.2.3.

O teste físico de Storage C.2.4 é opt-in por `KF_C2_4_STORAGE_INTEGRATION=1`: ele é omitido do DB CI que deliberadamente não sobe Storage e é obrigatório no workflow dedicado C.2.4, onde foi executado com sucesso.

Nenhum conteúdo real, recurso hospedado, secret de produção ou ambiente de produção participou da prova.

## Gates e revisão do PR nº 74

Antes do squash merge foram confirmados:

- base canônica `56e125bf72aabb885b0c0bc8b27f64d76ce98106`;
- HEAD exato `9c9556a880754c588e3f162bba7b3d0adaf5b403`;
- `0 behind` da `main`;
- 29 arquivos de escopo;
- nenhuma review thread bloqueante;
- revisão integral do diff;
- CI Pipeline nº 518 — `success`;
- Knowledge Factory DB CI nº 171 — `success`;
- C.1.4 Adapter CI nº 66 — `success`;
- C.1.5 Lifecycle CI nº 76 — `success`;
- C.2.2 Staging CI nº 68 — `success`;
- C.2.3 Integrity CI nº 47 — `success`;
- C.2.4 Recovery CI nº 34 — `success`;
- squash merge protegido por `expected_head_sha`.

## Validação pós-merge

A `main` foi confirmada em:

- SHA `14b7ff30d1b659ed8b2c824f9a943b05cdca93bc`;
- tree `92411aec0c9da3789bb91c87d8f423a3c69f929d`;
- parent `56e125bf72aabb885b0c0bc8b27f64d76ce98106`.

O CI Pipeline nº 523, executado por `push` nesse SHA, terminou `success` com Prettier, ESLint, TypeScript, Build e Tests verdes.

## Estado operacional após este checkpoint

- C.0 — concluído;
- C.1 — concluído;
- C.2 — em execução governada;
- C.2.1 — integrado e revalidado;
- C.2.2 — integrado e revalidado;
- C.2.3 — integrado e revalidado;
- **C.2.4 — integrado e revalidado**;
- **C.2.5 — bloqueado**;
- C.2.6 — bloqueado;
- C.3–C.7 — bloqueados;
- `GAP-3B-05` — ativo e contido;
- `GAP-3B-07` — ativo e contido;
- conteúdo real — bloqueado;
- Supabase hospedado — bloqueado;
- storage hospedado — bloqueado;
- produção — bloqueada.

## Definition of Ready de C.2.5

C.2.5 é o próximo sublote canônico e trata **revisão humana e handoff governado para C.3**.

Ele não pode ser iniciado automaticamente pela conclusão de C.2.4.

Antes de qualquer implementação de C.2.5 será obrigatório, em contexto próprio:

1. confirmar `main`, genealogia e Checkpoint 048 como autoridade de continuidade vigente;
2. inspecionar C.2.1–C.2.4 integrados e preservar seus ownerships;
3. definir explicitamente a competência e a evidência da revisão humana;
4. preservar a autorização independente de `extraction` sob autoridade de C.1;
5. definir quais transições já existentes da state machine C.2.1 serão materializadas sem criar estados novos silenciosamente;
6. definir handoff provider-neutral para C.3 sem iniciar extração;
7. provar idempotência, concorrência, autorização, rollback e least privilege da nova boundary quando aplicável;
8. usar somente fixtures sintéticas e infraestrutura descartável nas provas;
9. manter C.2.6 e C.3–C.7 bloqueados até suas próprias definições e autorizações;
10. manter conteúdo real, PNLD real, Supabase hospedado, Storage hospedado e produção bloqueados salvo decisão humana específica futura.

Este checkpoint **não inicia C.2.5**.

## Próximo escopo elegível

O próximo sublote na sequência canônica é:

`C.2.5 — revisão humana e handoff para C.3`.

Ele permanece **BLOQUEADO** após C.2.4 e deverá começar em novo contexto com inspeção canônica própria e autorização humana específica.

## Autoridade de continuidade

Após a integração desta reconciliação documental, o Checkpoint 048 passa a ser a referência operacional corrente para a Knowledge Factory.

O Checkpoint 047 permanece histórico e não será reescrito.
