# Lote C.2.6 — Prova integrada e fechamento de C.2

Data da abertura governada: 15 de agosto de 2026.

Base canônica de abertura: `main` em `0e3a2984b61c1518cd8382a2e45c35c52e86ceaf`.

Tree canônica de abertura: `d9d663b2f996a2392c277ad283d3b0a8bbad4967`.

Checkpoint de autoridade na abertura: `CONTINUITY-CHECKPOINT-049.md`.

## Status

**C.2.6 em validação técnica. C.2 ainda não está formalmente encerrado e C.3 permanece bloqueado.**

Este sublote não cria nova capacidade funcional de ingestão. Ele consolida, em uma prova remota e descartável, as fronteiras já integradas em C.2.1–C.2.5 e verifica os critérios globais de saída de C.2.

Nenhum merge desta branch, mesmo que tecnicamente verde, autoriza automaticamente C.3. O fechamento canônico de C.2 depende de revisão humana, integração governada, CI pós-merge e checkpoint posterior.

## 1. Objetivo

C.2.6 deve demonstrar que a ingestão controlada funciona como uma fronteira coerente e fechada entre C.1 e C.3:

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

A prova deve usar exclusivamente fixtures sintéticas, PostgreSQL/Supabase/Storage descartáveis e GitHub Actions remoto.

## 2. Não escopo

C.2.6 não autoriza nem implementa:

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

Permanece autoridade de:

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

C.2.6 não duplica cada sublote em um novo sistema. O fechamento utiliza quatro camadas de evidência:

1. **reexecução regressiva** dos contratos, policies, adapters e provas SQL já integrados;
2. **reexecução física** de staging/integridade/cleanup em Storage descartável;
3. **cenário E2E correlacionado novo**, usando os mesmos IDs entre control plane PostgreSQL e data plane Storage;
4. **postconditions de fechamento**, verificando estados finais, handoff, descarte, ausência de bytes permanentes e ausência de superfície executora de C.3.

## 5. Artefatos específicos de C.2.6

### 5.1 Gate remoto

`.github/workflows/knowledge-factory-c2-6-closure-ci.yml`

Responsabilidades:

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

## 8. Idempotência, replay e concorrência

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

O PR técnico de C.2.6 somente estará apto à revisão humana final quando:

1. CI geral estiver verde;
2. `Knowledge Factory C.2.6 Closure CI` estiver verde;
3. nenhum arquivo de produção, frontend ou C.3 tiver sido introduzido;
4. nenhuma migration funcional nova tiver sido criada;
5. `INGESTION_CONTRACT_VERSION` continuar `1.0.0`;
6. state machine C.2.1 permanecer inalterada;
7. E2E correlacionado concluir em `APPROVED_FOR_EXTRACTION` sem executar C.3;
8. caminho cancelado concluir em `CANCELLED` + `DISCARDED`;
9. regressões de atomicidade e concorrência permanecerem verdes;
10. diff integral for revisado humanamente.

## 13. Fechamento canônico posterior ao merge

Mesmo se todos os gates acima passarem, C.2 somente será declarado **concluído canonicamente** depois de:

1. autorização humana específica para merge;
2. integração do PR técnico de C.2.6;
3. reconfirmação SHA/tree/parent da `main`;
4. CI pós-merge verde;
5. reconciliação documental global;
6. criação de checkpoint posterior ao 049;
7. declaração explícita de que C.3 continua bloqueado.

Até essa sequência ocorrer, o Checkpoint 049 permanece a autoridade vigente.

## 14. Bloqueios preservados

Continuam bloqueados durante e após este PR técnico:

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
