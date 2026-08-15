# CONTINUITY CHECKPOINT 047 — C.2.3 integrado; C.2.4 permanece bloqueado

Data: 14 de agosto de 2026.

## Estado canônico técnico

- repositório: `PaulinhoRehfeld/profeplan`;
- branch canônica: `main`;
- commit técnico canônico de C.2.3: `f70312a9936b99e1c131627277ad4c4a65b126a5`;
- tree: `4b47c853a2cb041ca895477abc3c710ca9393b94`;
- parent direto: `ef4e7b48a8417eb8809707951df56d4324d957f4`;
- PR nº 70: integrado por squash merge em 14 de agosto de 2026;
- título canônico: `feat(knowledge-factory): implement C.2.3 integrity verification (#70)`;
- HEAD técnico validado antes do merge: `9d34ec2ba59ccf8426362b13e398175bb40beae2`;
- CI geral do HEAD final: CI Pipeline nº 429 — `success`;
- prova específica: Knowledge Factory C.2.3 Integrity CI nº 13 — `success`;
- regressão C.2.2: Knowledge Factory C.2.2 Staging CI nº 34 — `success`;
- regressão C.1.5: Knowledge Factory C.1.5 Lifecycle CI nº 42 — `success`;
- regressão de banco: Knowledge Factory DB CI nº 96 — `success`;
- CI pós-merge da `main`: CI Pipeline nº 430 — `success`.

O Checkpoint 046 permanece evidência histórica do encerramento de C.2.2 e do bloqueio anterior de C.2.3. Ele não deve ser reescrito.

## Resultado técnico de C.2.3

C.2.3 implementou a fronteira de integridade física e duplicidade binária sobre o staging temporário de C.2.2 sem transformar hash em identidade bibliográfica, jurídica, editorial ou semântica.

A definição integrada está em:

`12-delivery/LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md`.

O contrato provider-neutral está em:

`packages/types/src/knowledge-factory/integrity.ts`.

A porta e a policy estão em:

- `packages/knowledge-factory/src/staging/integrity.port.ts`;
- `packages/knowledge-factory/src/policies/integrity.ts`.

O adapter físico continua isolado em:

`packages/knowledge-factory-supabase/src/staging/supabase-temporary-staging.adapter.ts`.

Versão do contrato:

`INTEGRITY_CONTRACT_VERSION = 1.0.0`.

## Algoritmo e origem da evidência

A v1 usa `sha-256` representado por 64 caracteres hexadecimais minúsculos.

O digest é calculado sobre **readback dos bytes efetivamente armazenados** no staging privado. Ele não é calculado somente sobre o payload alegadamente enviado antes do upload.

A evidência registra apenas informações provider-neutral:

- artifact ID;
- `processing_run`;
- `source_version`;
- `received_file`;
- algoritmo e digest;
- byte length fisicamente observado;
- instante de verificação;
- correlation ID.

Bucket, path físico, signed URL, provider SDK, região, secret, credencial, bytes e erro bruto não integram o contrato ou a evidência.

## Separação de identidade preservada

C.2.3 mantém distintos:

```text
identidade bibliográfica
  != source_version
  != received_file
  != processing_run
  != staging artifact
  != digest dos bytes
  != equivalência editorial
  != duplicidade técnica
  != duplicidade semântica
```

Digest igual é fato técnico de igualdade binária dos bytes observados. Não autoriza merge de identidades e não prova equivalência jurídica/editorial ou semântica.

## Duplicidade técnica

A classificação integrada distingue:

- `same_artifact`;
- `same_run`;
- `same_source_version`;
- `cross_source_version`.

Duplicidade binária é informação auditável e, isoladamente, não impede `VERIFIED`. Um artefato pode estar íntegro e ser tecnicamente duplicado.

A exceção fail-closed é conflito histórico do mesmo artefato físico: se o mesmo `processing_run + artifactId` for observado com digest diferente, a promoção é negada por `STAGING_INTEGRITY_DIGEST_CONFLICT`.

Replay de comando não foi redefinido por hash e permanece conceito separado.

## Lifecycle e significado de `VERIFIED`

C.2.3 materializa tecnicamente:

```text
STAGED -> VERIFIED
```

no lifecycle do artefato temporário.

`VERIFIED` significa que o artefato estava disponível, foi relido do storage, teve SHA-256 calculado sobre o readback, preservou vínculos e byte length e não apresentou conflito de integridade conhecido.

`VERIFIED` não significa:

- aprovação humana;
- unicidade;
- equivalência bibliográfica/editorial;
- autorização para extração;
- `RELEASED_FOR_EXTRACTION`.

## Acoplamento com C.2.1

A revisão integral do PR nº 70 encontrou e corrigiu um gap importante antes do merge: a primeira versão materializava `VERIFIED` no artefato, mas o comando histórico `confirm_verified` de C.2.1 ainda poderia ser interpretado sem vínculo obrigatório com a nova evidência física.

A solução final preservou integralmente `INGESTION_CONTRACT_VERSION = 1.0.0` e a topologia da state machine C.2.1.

C.2.3 adicionou `evaluateIngestionVerificationConfirmation` como gate operacional composto. A confirmação `VERIFYING -> VERIFIED` exige cumulativamente:

1. transição C.2.1 válida e `expectedState` coerente;
2. integridade física C.2.3 aprovada;
3. mesmo `processing_run`;
4. mesmo correlation ID;
5. byte length do comando, quando informado, coerente com o observado;
6. media type do comando, quando informado, não contraditório com o staging.

Divergências ou ausência de valor verificado falham fechadas por `INGESTION_VERIFICATION_EVIDENCE_MISMATCH`.

Essa composição não cria segunda state machine nem antecipa atomicidade persistida, replay ou recovery de C.2.4.

## Persistência deliberadamente não criada

C.2.3 não adicionou:

- migration;
- tabela;
- índice global de hash;
- RPC;
- RLS/grant;
- trigger;
- fila;
- worker;
- persistência definitiva de evidência.

Essa decisão é intencional. Persistência transacional, lookup concorrente, idempotência, retomada, compare-and-swap e recuperação segura pertencem ao sublote C.2.4.

## Prova remota descartável

O workflow integrado é:

`.github/workflows/knowledge-factory-c2-3-integrity-ci.yml`.

A execução verde nº 13 comprovou, em Supabase local/descartável no GitHub Actions:

- typecheck dos packages envolvidos;
- policy e boundary provider-neutral;
- SHA-256 conhecido sobre fixture sintética;
- digest calculado após readback;
- mutação pós-staging alterando o digest observado;
- conflito do mesmo artefato com digest diferente;
- duplicidade entre runs e `source_version`s sem colapso de identidade;
- locator inválido bloqueado antes do provider;
- erro provider sanitizado;
- bucket privado e acesso anônimo negado;
- regressões C.2.1 e C.2.2;
- criação e destruição da stack descartável;
- artifact de evidência sanitizada.

Nenhum recurso hospedado, secret real ou conteúdo protegido participou da prova.

## Gates e revisão do PR nº 70

Antes do squash merge foram confirmados:

- base canônica `ef4e7b48a8417eb8809707951df56d4324d957f4`;
- HEAD exato `9d34ec2ba59ccf8426362b13e398175bb40beae2`;
- `0 behind` da `main`;
- 13 arquivos de escopo;
- nenhuma review thread pendente;
- revisão integral do diff;
- CI Pipeline nº 429 — `success`;
- C.2.3 Integrity CI nº 13 — `success`;
- C.2.2 Staging CI nº 34 — `success`;
- C.1.5 Lifecycle CI nº 42 — `success`;
- Knowledge Factory DB CI nº 96 — `success`;
- squash merge protegido por `expected_head_sha`.

Os dois checks Vercel no HEAD final registraram exclusivamente a ocorrência externa conhecida `build-rate-limit`. Isso foi registrado separadamente e nenhum gate técnico próprio foi relaxado.

## Validação pós-merge

A `main` foi confirmada em:

- SHA `f70312a9936b99e1c131627277ad4c4a65b126a5`;
- tree `4b47c853a2cb041ca895477abc3c710ca9393b94`;
- parent `ef4e7b48a8417eb8809707951df56d4324d957f4`.

O CI Pipeline nº 430 executado por `push` nesse SHA terminou `success` com formatter, lint, typecheck, build e testes verdes.

## Estado operacional após este checkpoint

- C.0 — concluído;
- C.1 — concluído;
- C.2 — em execução governada;
- C.2.1 — integrado e revalidado;
- C.2.2 — integrado e revalidado;
- **C.2.3 — integrado e revalidado**;
- **C.2.4 — bloqueado**;
- C.2.5–C.2.6 — bloqueados;
- C.3–C.7 — bloqueados;
- `GAP-3B-05` — ativo e contido;
- `GAP-3B-07` — ativo e contido;
- conteúdo real — bloqueado;
- Supabase hospedado — bloqueado;
- storage hospedado — bloqueado;
- produção — bloqueada.

## Definition of Ready de C.2.4

C.2.4 é o próximo sublote canônico e muda novamente a natureza do boundary: ele tratará **idempotência, retomada e falha segura** da ingestão controlada.

Ele não pode ser iniciado automaticamente pela conclusão de C.2.3.

Antes de qualquer implementação de C.2.4 será obrigatório, em contexto próprio:

1. confirmar a `main`, sua genealogia e o checkpoint canônico vigente;
2. inspecionar C.2.1–C.2.3 integrados e suas responsabilidades separadas;
3. definir ownership persistente das evidências/decisões que realmente precisam sobreviver ao processo;
4. distinguir idempotência de comando, duplicidade binária e identidade de fonte;
5. definir atomicidade e comportamento concorrente sem pseudo-transações;
6. definir retomada após crash/falha parcial e condições de terminalidade segura;
7. definir relação entre replay, retries, retention e descarte do staging;
8. justificar qualquer migration/tabela/RPC/RLS/grant antes de criá-los;
9. usar somente fixtures sintéticas e infraestrutura descartável nas provas;
10. manter C.2.5–C.2.6 e C.3–C.7 bloqueados;
11. manter conteúdo real, Supabase hospedado, storage hospedado e produção bloqueados salvo decisão específica futura.

Este checkpoint **não inicia C.2.4**.

## Próximo escopo elegível

O próximo sublote na sequência canônica é:

`C.2.4 — idempotência, retomada e falha segura`.

Ele permanece **BLOQUEADO** após C.2.3 e deverá começar em novo contexto com inspeção canônica própria.

## Autoridade de continuidade

Após a integração desta reconciliação documental, o Checkpoint 047 passa a ser a referência operacional corrente para a Knowledge Factory.

O Checkpoint 046 permanece histórico e não será reescrito.
