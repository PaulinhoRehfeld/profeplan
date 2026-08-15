# Lote C.2.6 — Prova integrada e fechamento de C.2

Data da abertura governada: 15 de agosto de 2026.

Base canônica de abertura: `main` em `0e3a2984b61c1518cd8382a2e45c35c52e86ceaf`.

Tree canônica de abertura: `d9d663b2f996a2392c277ad283d3b0a8bbad4967`.

Checkpoint de autoridade na abertura: `CONTINUITY-CHECKPOINT-049.md`.

## Status

**C.2.6 foi integrado pelo PR nº 93 e revalidado pós-merge. C.2 satisfaz seus critérios globais de saída e é encerrado canonicamente pela reconciliação documental que cria o Checkpoint 050. C.3 permanece bloqueado.**

Este sublote não criou nova capacidade funcional de ingestão. Ele consolidou, em uma prova remota e descartável, as fronteiras já integradas em C.2.1–C.2.5 e verificou os critérios globais de saída de C.2.

O fechamento de C.2 não autoriza automaticamente C.3. A abertura de C.3 exige contexto, definição, inspeção e autorização humana próprios.

### Integração técnica de C.2.6

- PR nº 93: `test(knowledge-factory): prove C.2.6 integrated closure`;
- HEAD técnico validado: `4f010128b5909224bff52914672cf9a080136531`;
- tree do HEAD técnico: `a0ba9baf16adb427e93d827e11c3628852aec634`;
- squash integrado: `3b8c2d317542bd701ea61e671f9b6e4334f61b1c`;
- tree do squash: `0fbe3377d3dac6aa9730a6e895d20a0762fc855c`;
- parent direto: `57d7e387676224ef6fb5e3101270c0b6e4f8c245`;
- CI pós-merge: CI Pipeline nº 562 — `success`.

## 1. Objetivo

C.2.6 demonstrou que a ingestão controlada funciona como uma fronteira coerente e fechada entre C.1 e C.3:

```text
C.1 — identidade, competência e autorização
  ↓
C.2.1 — contrato, receipt e state machine
  ↓
C.2.2 — staging temporário seguro
  ↓
C.2.3 — integridade e duplicidade
  ↓
C.2.4 — persistência, idempotência, recovery e fail-safe
  ↓
C.2.5 — revisão humana e handoff persistido
  ↓
APPROVED_FOR_EXTRACTION
  ↓
[STOP — C.3 não é executado por C.2]
```

A prova utilizou exclusivamente fixtures sintéticas, PostgreSQL/Supabase/Storage descartáveis e GitHub Actions remoto.

## 2. Não escopo

C.2.6 não autorizou nem implementou:

- novo estado de ingestão;
- nova transição de state machine;
- bump de `INGESTION_CONTRACT_VERSION`;
- nova migration funcional de C.2;
- mudança de ownership C.1/C.2/C.3;
- parser ou leitura semântica de PDF;
- extração textual;
- OCR;
- páginas ou renderizações permanentes;
- chunks;
- embeddings;
- fila, worker ou job de extração;
- agente de extração;
- frontend de upload;
- endpoint público;
- fonte real;
- conteúdo PNLD real;
- Supabase hospedado;
- Storage hospedado;
- secrets de produção;
- produção.

## 3. Autoridades preservadas

### C.1

Permanece autoridade de:

- identidade governada;
- versão da fonte;
- competência humana;
- autorização por finalidade e por instante;
- histórico jurídico-editorial.

### C.2

Encerra sua responsabilidade como autoridade de:

- lifecycle operacional do `processing_run`;
- staging temporário;
- integridade física;
- receipts e eventos operacionais;
- recovery, CAS e concorrência;
- revisão operacional persistida;
- fato de elegibilidade `APPROVED_FOR_EXTRACTION`.

### C.3

Permanece bloqueado e será, em contexto próprio, a autoridade de execução de extração e validação do conteúdo extraído.

## 4. Estratégia de fechamento

C.2.6 não duplicou cada sublote em um novo sistema. O fechamento utilizou quatro camadas de evidência:

1. **reexecução regressiva** dos contratos, policies, adapters e provas SQL já integrados;
2. **reexecução física** de staging/integridade/cleanup em Storage descartável;
3. **cenário E2E correlacionado novo**, usando os mesmos IDs entre control plane PostgreSQL e data plane Storage;
4. **postconditions de fechamento**, verificando estados finais, handoff, descarte, ausência de bytes permanentes e ausência de superfície executora de C.3.

## 5. Artefatos específicos de C.2.6

### 5.1 Gate remoto

`.github/workflows/knowledge-factory-c2-6-closure-ci.yml`

Responsabilidades comprovadas:

- iniciar uma única stack Supabase descartável com Storage;
- revalidar contrato `1.0.0` e provider-neutrality;
- executar regressões C.2.1–C.2.5;
- aplicar somente migrations já integradas;
- executar provas SQL de C.2.4 e C.2.5;
- executar o novo E2E correlacionado;
- verificar postconditions de fechamento;
- gerar artefato de evidência;
- destruir a stack sem backup.

### 5.2 Fixture sintética de autoridade C.1

`supabase/tests/knowledge_factory_ingestion_c2_6_seed.sql`

A fixture cria apenas dados descartáveis e distintos dos cenários C.2.4/C.2.5:

- duas `source_version` sintéticas;
- dois `received_file` sintéticos;
- grants independentes de `temporary_staging` e `ingestion`;
- um grant independente de `extraction` para o caminho aprovado;
- competência `system_worker`;
- competência `legal_editorial_reviewer`;
- evidência histórica C.1 do grant `extraction`.

Nenhum dado real ou conteúdo protegido participa da fixture.

### 5.3 E2E correlacionado

`packages/knowledge-factory-supabase/test/ingestion.c2-6.e2e.integration.test.mjs`

O cenário principal utiliza um único conjunto de referências sintéticas do início ao handoff:

```text
source_version e200...001
received_file e300...001
processing_run e100...001
staging artifact e500...001
```

Fluxo provado:

```text
request_ingestion
  -> replay idêntico
  -> replay divergente bloqueado
  -> begin_staging
  -> prepareStagingArtifact
  -> stage bytes sintéticos no Storage descartável
  -> mark_staged
  -> begin_verification
  -> readback + SHA-256 real
  -> evaluateStagingIntegrity
  -> confirm_verified
  -> request_review
  -> approve_for_extraction com competência humana C.1
  -> handoff read-only
  -> STOP
```

A prova também confirma que o objeto físico continua presente no instante do handoff e que `anon` não pode lê-lo.

### 5.4 Caminho independente de cancelamento e cleanup

O mesmo E2E cria um segundo run sintético:

```text
source_version e200...002
received_file e300...002
processing_run e100...002
staging artifact e500...002
```

Esse caminho prova:

```text
request_ingestion
  -> begin_staging
  -> prepareStagingArtifact
  -> stage
  -> cancel_ingestion
  -> prepareDiscard
  -> discard físico
  -> confirmDiscard
  -> discard repetido = already_discarded
```

O run cancelado nunca pode produzir evento `ingestion_approved_for_extraction`.

### 5.5 Postconditions SQL

`supabase/tests/knowledge_factory_ingestion_c2_6_postconditions.sql`

As postconditions verificam:

- run principal em `APPROVED_FOR_EXTRACTION`;
- sequência final coerente;
- handoff persistido e reconstruível;
- decisão humana `APPROVE_FOR_EXTRACTION` única;
- autorização `extraction` independente registrada no evento;
- run alternativo em `CANCELLED`;
- artefato alternativo em `DISCARDED` com receipt de descarte;
- nenhuma coluna `bytea` nas tabelas permanentes `kf_ingestion_%`;
- ausência de rotinas executoras conhecidas de C.3;
- ausência de aprovação no run cancelado.

## 6. Matriz consolidada de evidências C.2

| Critério global de C.2 | Evidência consolidada | Gate C.2.6 |
|---|---|---|
| somente fonte/versão governada e autorizada abre ingestão | C.1 + request boundary C.2.4 | seed C.1 + E2E `request_ingestion` |
| finalidades distintas | C.1/C.2.4/C.2.5 | grants separados `temporary_staging`, `ingestion`, `extraction` |
| execução auditável | receipts/eventos C.2.4/C.2.5 | E2E + postconditions |
| staging temporário e provider-neutral | C.2.2 | adapter real + locator opaco + teste anon |
| bytes fora de Postgres/corpus | C.2.2/C.2.4 | Storage real + postcondition sem `bytea` |
| limites fail-closed | C.2.2 | regressão policy/adapter + bucket restrito |
| integridade criptográfica | C.2.3 | SHA-256 readback real no E2E |
| duplicidade/replay/conflito explícitos | C.2.3/C.2.4 | regressões + replay E2E |
| idempotência segura | C.2.4 | replay idêntico/divergente + SQL |
| concorrência segura | C.2.4/C.2.5 | provas multi-session reaplicadas |
| falha sem aprovação parcial | C.2.4/C.2.5 | atomicity SQL reaplicada + run cancelado |
| revisão humana antes de C.3 | C.2.5 | reviewer C.1 + decisão persistida |
| revogação/suspensão/expiração/bloqueio não avança | C.1/C.2.5 | regressão C.2.5 reaplicada |
| descarte verificável | C.2.2/C.2.4 | caminho cancelado + `DISCARDED` persistido |
| somente sintético/descartável | todos | workflow sem secrets/recurso hospedado |
| nenhuma produção ativada | todos | ausência de deploy/wiring no gate |
| C.3 não executado | C.2.5/C.2.6 | static denylist + handoff read-only |

## 7. Segurança negativa

O fechamento preserva deny-by-default por meio de:

- bucket privado descartável;
- teste de leitura `anon` negada;
- regressões de grants C.2.4/C.2.5;
- `service_role` tratado somente como canal técnico;
- competência humana resolvida em C.1;
- SQL de prova executado apenas pelo superusuário descartável do ambiente CI;
- ausência de secret real;
- supressão de credenciais descartáveis nos logs de startup.

## 8. Idempotência, replay, fingerprint e concorrência

C.2.6 não redefine a semântica já aprovada.

Permanece:

```text
commandId + canonical fingerprint
```

A prova consolidada inclui:

- replay idêntico do request retornando receipt original;
- replay divergente falhando `CONFLICT`;
- fingerprints recalculados pelo código compartilhado e novamente pelo banco;
- advisory lock por commandId;
- CAS por estado/versão/sequence;
- concorrência multi-session C.2.4;
- corrida de decisão humana C.2.5.

### Correção de canonicalização descoberta pelo E2E

O primeiro run integrado expôs uma divergência preexistente no cálculo JavaScript do fingerprint v1. O PostgreSQL ordenava chaves JSON com `COLLATE "C"`; o JS usava `localeCompare('en')`.

A correção alterou somente a implementação JS para comparação bytewise UTF-8 compatível com a ordem canônica do banco. O vetor de regressão explícito fixa o fingerprint:

`7a812ddb177c2ab737ab429a925b74c167638af7ce4ac6ed63bd86b512399317`.

A correção não alterou contrato, migration, state machine ou `INGESTION_CONTRACT_VERSION`, que permanece `1.0.0`.

## 9. Staging, integridade e descarte

O data plane continua separado do control plane:

- bytes existem somente em Storage temporário;
- PostgreSQL conserva metadados, estado, digest e evidência;
- locator físico não atravessa o contrato público;
- integridade usa readback físico real;
- cleanup físico pode ser repetido sem erro material;
- descarte possui confirmação persistida independente da remoção física.

O caminho aprovado mantém o artefato disponível no instante da decisão humana e do handoff. O teste destrói a stack inteira somente como teardown do ambiente descartável, não como semântica de negócio do handoff.

## 10. Handoff e fronteira com C.3

O único resultado positivo de C.2 é:

`APPROVED_FOR_EXTRACTION`

mais a evidência read-only de handoff.

C.2.6 não cria nem chama:

- `startExtraction`;
- `executeExtraction`;
- `enqueueExtraction`;
- `publishExtractionJob`;
- `createExtractionJob`;
- equivalentes SQL `kf_ingestion_*` que executem extração.

A autorização `extraction` registrada no handoff prova apenas que ela estava válida no instante da revisão humana. C.3 deverá reavaliar sua própria autorização no instante real de eventual execução.

## 11. Rollback e reapply

C.2.6 não adiciona migration funcional; portanto não cria um novo rollback de schema.

A prova de reapply é composta por:

- idempotência de staging preparation;
- replay idêntico dos comandos;
- cleanup físico idempotente;
- regressões de rollback deliberado C.2.4 e C.2.5;
- reconstrução do ambiente inteiro a partir de migrations canônicas em stack descartável.

Em produção futura, qualquer reversão continuará forward-only e auditável, conforme a definição de C.2.

## 12. Critério de saída técnico de C.2.6

Os dez critérios técnicos foram satisfeitos pelo HEAD final do PR nº 93:

1. CI geral verde — CI Pipeline nº 560;
2. `Knowledge Factory C.2.6 Closure CI` verde — run nº 3;
3. nenhum arquivo de produção, frontend ou C.3 introduzido;
4. nenhuma migration funcional nova criada;
5. `INGESTION_CONTRACT_VERSION = 1.0.0` preservado;
6. state machine C.2.1 inalterada;
7. E2E correlacionado concluído em `APPROVED_FOR_EXTRACTION` sem executar C.3;
8. caminho cancelado concluído em `CANCELLED` + `DISCARDED`;
9. regressões de atomicidade e concorrência verdes;
10. diff integral revisado humanamente antes do merge.

Além do gate específico, também fecharam em `success` no HEAD final:

- Knowledge Factory C.2.4 Recovery CI nº 44;
- Knowledge Factory C.2.5 Human Review CI nº 10;
- Knowledge Factory DB CI nº 187;
- Knowledge Factory C.1.5 Lifecycle CI nº 84.

## 13. Integração, corrida concorrente e fechamento canônico

A autorização humana de merge exigia HEAD exato, base esperada, `behind_by: 0`, mergeabilidade e seis workflows técnicos verdes, com exceção restrita aos statuses Vercel associados a `api-deployments-free-per-day`.

A verificação imediatamente anterior confirmou essas condições sobre a `main` em:

`0e3a2984b61c1518cd8382a2e45c35c52e86ceaf`.

Entre essa verificação e a operação de squash, o PR nº 92 da frente comercial foi integrado, criando:

`57d7e387676224ef6fb5e3101270c0b6e4f8c245`.

A API protegeu o HEAD do PR nº 93 por `expected_head_sha`, mas não ofereceu guarda equivalente do base SHA na mesma operação. O squash de C.2.6 foi então aplicado sobre o novo tip da `main` e gerou:

`3b8c2d317542bd701ea61e671f9b6e4334f61b1c`.

A comparação direta entre o parent `57d7e387...` e o squash `3b8c2d31...` mostrou exatamente os sete arquivos de C.2.6, sem arquivo comercial no diff técnico e sem perda do avanço concorrente.

O CI Pipeline nº 562 foi executado por `push` na árvore composta final e terminou `success` com Prettier, ESLint, TypeScript, Build e Tests verdes.

A reconciliação documental posterior cria o Checkpoint 050 e declara C.2 canonicamente encerrado, mantendo C.3 bloqueado.

## 14. Bloqueios preservados

Continuam bloqueados após o fechamento de C.2:

- C.3–C.7;
- conteúdo real;
- PNLD real;
- PDF/livro real;
- Supabase hospedado;
- Storage hospedado;
- secrets de produção;
- produção;
- wiring de runtime;
- qualquer execução de extração.

O próximo passo arquitetural candidato é somente a inspeção e definição governada de C.3, em contexto próprio e mediante nova autorização humana específica.
