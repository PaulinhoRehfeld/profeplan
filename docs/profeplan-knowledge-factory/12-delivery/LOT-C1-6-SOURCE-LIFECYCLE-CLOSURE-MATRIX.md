# C.1.6 — Matriz de fechamento do Lote C.1 e decisão sobre GAP-3B-04

Data: 14 de agosto de 2026.

Base canônica auditada: `main` em `5fe6bb968ab980806df8f98e6581ba9d96810e07`.

Tree auditada: `d30089175e3cf98a69d9d5ebc3e557ba118807ae`.

Parent direto: `f033faa51ed33ac504c5775e8bdcca7915c00d89`.

## 1. Autoridade e propósito

Este documento materializa o gate de fechamento de C.1.6 definido em
`LOT-C1-SOURCE-LIFECYCLE-GOVERNANCE-DEFINITION.md`.

C.1.6 é um sublote de auditoria, reconciliação e decisão. Ele não cria uma nova arquitetura e não
antecipa C.2. Seu objetivo é verificar se o lifecycle necessário para permitir que uma futura
ingestão controlada seja construída sobre uma fronteira governada está definido, persistido,
protegido, adaptado, testado e integrado.

A auditoria considera como evidência canônica, entre outros:

- `LOT-3B-DEFINITION.md` e Checkpoints 015/032 para a origem e contenção de `GAP-3B-04`;
- `LOT-C1-SOURCE-LIFECYCLE-GOVERNANCE-DEFINITION.md` para o contrato normativo de C.1;
- os contratos C.1.1 em `packages/types/src/knowledge-factory/source-lifecycle.ts`;
- `LOT-C1-2-SOURCE-LIFECYCLE-PHYSICAL-MODEL.md` e `LOT-C1-2-RLS-GRANTS-MATRIX.md`;
- os artefatos normativos e executáveis de C.1.3;
- o Checkpoint 041 e os ports/adapters C.1.4;
- `LOT-C1-5-SOURCE-LIFECYCLE-TEST-EVIDENCE-MATRIX.md` e o Checkpoint 042;
- CI geral pós-C.1.5 documental: run nº 360, concluído com sucesso.

## 2. Definition of Ready de C.1.6

| Requisito | Evidência | Resultado |
|---|---|---|
| C.1.1–C.1.5 integrados | Checkpoints 040–042 e genealogia da `main` | satisfeito |
| CI e DB CI aplicáveis verdes | evidências acumuladas C.1.2–C.1.5 + CI nº 360 na `main` | satisfeito |
| documentação e diff revisados | definição C.1, mapa C, Checkpoints 032–042 e matriz C.1.5 auditados | satisfeito |
| nenhum bypass de segurança aberto | RLS/grants deny-by-default; DML direto revogado; competência C.1.3; leituras C.1.4 estreitas | satisfeito |
| impacto derivado formalmente endereçado | contrato de impacto conservador + eventos de impacto + fail closed; materialização futura permanece nos lotes donos das entidades | satisfeito |
| retenção formalmente endereçada | C.1 separa inelegibilidade de descarte; C.1.2 persiste somente metadados minimizados; prazos exatos ficam bloqueados antes de corpus real | satisfeito |

Nenhuma lacuna encontrada nessa verificação exige alteração funcional em C.1.6.

## 3. Origem e evolução de GAP-3B-04

### 3.1 Problema original

O Lote 3B registrou `GAP-3B-04 — lifecycle de fonte incompleto para ingestão` porque o
`KnowledgeSourceRepository` mínimo permitia `save(source)`, mas não oferecia a superfície completa
para governar versões, segmentos e eventos de permissão. O Lote 3B.2 foi deliberadamente limitado à
porta existente, sem inventar métodos, pseudo-ingestão ou DML paralelo.

### 3.2 Contenção na saída da Fase B

O Checkpoint 032 manteve o gap ativo e contido e destinou sua resolução à primeira frente da Fase C:

- estados e invariantes do lifecycle;
- procedência, licença, permissão, revogação e bloqueio;
- contratos/portas adequados;
- fronteira transacional e modelo físico;
- minimização, retenção e rastreabilidade;
- segurança, testes descartáveis e rollback.

### 3.3 Critério canônico posterior de encerramento

A definição específica de C.1 refinou o gate de forma explícita: `GAP-3B-04` só pode ser encerrado
quando o **lifecycle necessário à ingestão** estiver definido, persistido, protegido, adaptado,
testado e integrado.

Essa formulação é a autoridade operacional para C.1.6.

### 3.4 Segmentos não são requisito residual de C.1

A menção histórica a `SourceSegment` no gap original descrevia uma lacuna da porta 3B.2, não uma
obrigação de transformar C.1 em lote de segmentação.

A decomposição canônica da Fase C atribui:

- C.1 — identidade, lifecycle registral, autorizações, competência, histórico e impacto;
- C.2 — ingestão controlada;
- C.3 — extração;
- C.4 — segmentos estruturais e classificação.

Portanto, criar `SourceSegment` em C.1.6 para “fechar” o texto histórico violaria a separação de
responsabilidades e anteciparia C.4. O fechamento do gap exige que a futura ingestão possa consultar
e executar o lifecycle governado; não exige que a segmentação futura já exista.

## 4. Matriz de fechamento de C.1

| Requisito normativo | Origem principal | Sublote responsável | Artefato/evidência integrada | Estado | Risco residual / dependência futura |
|---|---|---|---|---|---|
| identidade registral da fonte | definição C.1 §§4–5 | C.1.1–C.1.3 | `SourceIdentityRef`, estados registrais, identidades persistidas, RPCs registrais | satisfeito | catálogo editorial detalhado pertence aos lotes consumidores |
| obra/edição/manifestação/arquivo/versão distinguíveis | definição C.1 §4 | C.1.1–C.1.2 | oito `SOURCE_IDENTITY_KINDS`; `kf_source_identities`; pontes legadas sem equivalência automática | satisfeito | relações editoriais completas não são necessárias antes do consumidor real |
| validação registral | definição C.1 §5 | C.1.1–C.1.3 | `request_validation`, `confirm_validation`, CAS e máquina de estados | satisfeito | dados reais continuam proibidos |
| bloqueio registral | definição C.1 §5 | C.1.1–C.1.3 | `block_source`, estado `BLOCKED`, impacto conservador | satisfeito | execução real de impacto depende das entidades futuras |
| substituição | definição C.1 §5 | C.1.1–C.1.3 | `replace_source`, sucessor explícito, sem transferência implícita de autorização | satisfeito | sucessor real só existirá em uso futuro |
| arquivamento | definição C.1 §5 | C.1.1–C.1.3 | `archive_source`, histórico preservado | satisfeito | política operacional de reabertura continua fora do fluxo produtivo atual |
| autorização por finalidade | definição C.1 §§6–8 | C.1.1–C.1.3 | dez finalidades; autorização escopada; RPC de grant | satisfeito | cada consumidor futuro deve pedir sua finalidade exata |
| fundamento jurídico/editorial | definição C.1 §§4.10/6 | C.1.1–C.1.2 | `SourceAuthorizationBasisRef`; base persistida minimizada | satisfeito | contrato integral/segredo não é copiado para o corpus |
| janelas temporais | definição C.1 §§6–8 | C.1.1–C.1.5 | `effectiveFrom/effectiveUntil`; consulta `as of`; teste de expiração C.1.5 | satisfeito | relógio/runtime futuro deve fornecer instante explícito |
| suspensão | definição C.1 | C.1.1–C.1.5 | comando/evento `suspend`; testes de elegibilidade e histórico | satisfeito | nenhuma ação produtiva real executada |
| retomada | definição C.1 | C.1.1–C.1.5 | comando/evento `resume`; máquina de autorização testada | satisfeito | idem |
| revogação | definição C.1 | C.1.1–C.1.5 | comando/evento `revoke`; impacto conservador; testes | satisfeito | retenção de conteúdo real deverá obedecer decisão jurídica aplicável |
| bloqueio de finalidade | definição C.1 | C.1.1–C.1.5 | `block_purpose`; sequência canônica `GRANTED → SUSPENDED → BLOCKED` testada | satisfeito | nenhuma finalidade futura é implicitamente autorizada |
| supersessão | definição C.1 | C.1.1–C.1.5 | transação predecessor/sucessor; ausência de transferência de finalidade comprovada | satisfeito | sucessor deve possuir decisão própria |
| consulta histórica `as of` | definição C.1 §7 | C.1.1, C.1.2, C.1.4–C.1.5 | eventos autoritativos + três RPCs históricas + adapters read + E2E | satisfeito | query de produção permanece bloqueada |
| append-only/auditabilidade | definição C.1 §§7/15 | C.1.2–C.1.5 | eventos/receipts/bases/identidades protegidos; histórico ordenado | satisfeito | auditoria geral enriquecida GAP-3B-05 é separada e não bloqueia C.1 |
| persistência segura | definição C.1 | C.1.2 | migration aditiva, constraints, FKs, índices, projeções reconstruíveis | satisfeito | migration hospedada não aplicada |
| RLS e grants mínimos | definição C.1 §15 | C.1.2–C.1.5 | deny-by-default; leitura administrativa controlada; ausência de DML direto runtime | satisfeito | produção exige gate próprio |
| competência | definição C.1/C.1.3 | C.1.3–C.1.5 | `kf_source_actor_assignments`, role/finalidade, expiração, negativos | satisfeito | assignments reais permanecem proibidos |
| atomicidade | definição C.1 | C.1.3–C.1.5 | 13 RPCs estreitas; falha parcial sem estado publicado | satisfeito | nenhuma pseudo-transação PostgREST alternativa permitida |
| idempotência/fingerprint | definição C.1 | C.1.1–C.1.5 | `commandId`, SHA-256 canônico, replay e conflito divergente | satisfeito | consumidor futuro deve preservar command IDs |
| CAS/concorrência | definição C.1 | C.1.3–C.1.5 | version/sequence checks + concorrência multi-session | satisfeito | retry futuro não pode contornar conflito |
| provider-neutrality | definição C.1 §§16–18 | C.1.1/C.1.4–C.1.5 | ports próprios; adapters sem regra jurídica; erros/receipts traduzidos | satisfeito | nenhum adapter paralelo permitido |
| impacto derivado | definição C.1 §13 | C.1.1/C.1.3–C.1.5 | `open_impact_assessment`; abertura atômica em comandos restritivos; fail closed; histórico lido | satisfeito no escopo C.1 | mutação/quarentena de chunks, embeddings e demais derivados pertence aos lotes que os materializarem |
| retenção/minimização | definição C.1 §§13.3/15.5 | C.1.1–C.1.2 | metadados mínimos; sem PDF/OCR bruto/contrato integral; inelegibilidade ≠ apagar | satisfeito para C.1 | prazos jurídicos exatos devem ser definidos antes de corpus real, sem bloquear lifecycle abstrato |
| integração de ponta a ponta | definição C.1/C.1.5 | C.1.5 | política provider-neutral → adapter → RPC → persistência; expiração e supersessão E2E | satisfeito | somente fixtures sintéticas |
| rollback | definição C.1 | C.1.2–C.1.5 | rollback/reapply estrutural em Supabase descartável | satisfeito | após histórico real, reversão destrutiva é proibida; usar forward-only |
| observabilidade sanitizada | definição C.1/C.1.4 | C.1.4–C.1.5 | telemetria allowlisted, sem payload jurídico/secret | satisfeito | observabilidade produtiva pertence ao wiring futuro |
| ausência de produção | não escopo C.1 | C.1.1–C.1.6 | nenhum Supabase hospedado, dado real, PDF, secret, assignment real ou migration produtiva | satisfeito | produção continua sob gate próprio |

## 5. Auditoria do critério de saída global de C.1

A definição canônica exige evidência integrada de:

- identidade bibliográfica/documental suficiente;
- lifecycle registral;
- autorização histórica por finalidade e vigência;
- consulta `as of`;
- persistência segura;
- append-only e auditabilidade;
- RLS/grants adequados;
- comandos atômicos;
- adapters provider-neutral;
- idempotência e concorrência;
- revogação/expiração;
- contrato de propagação de impacto;
- testes unitários e integração descartável;
- rollback;
- documentação e checkpoint.

Todos os itens técnicos estão satisfeitos pelas evidências integradas de C.1.1–C.1.5. O item final de
documentação/checkpoint é concluído por C.1.6 após a integração governada desta matriz e o registro
do checkpoint pós-merge.

## 6. Decisão formal sobre GAP-3B-04

### Resultado da auditoria: elegível para encerramento

`GAP-3B-04` pode ser **ENCERRADO** no fechamento documental final de C.1.6.

Justificativa:

1. o problema original era a ausência de uma fronteira completa de lifecycle sobre o adapter mínimo
   3B.2;
2. C.1.1 definiu a semântica provider-neutral;
3. C.1.2 persistiu identidades, autorizações, eventos, recibos, temporalidade, RLS e grants;
4. C.1.3 implementou a escrita atômica, competência, idempotência, CAS, concorrência e impacto;
5. C.1.4 implementou ports/adapters de comando e leitura histórica sem reabrir DML direto;
6. C.1.5 comprovou a capacidade integrada, segurança, expiração, supersessão, rollback e
   provider-neutrality;
7. C.1.6 não encontrou requisito residual do lifecycle que pertença legitimamente a C.1.

O fechamento não significa que ingestão, segmentos, extração ou derivados já existam. Significa que
a lacuna de governança que impedia desenhar a ingestão sobre uma fonte controlada foi eliminada.

## 7. Decisão sobre o Lote C.1

### Resultado da auditoria: apto ao fechamento

O Lote C.1 está **APTO A SER DECLARADO CONCLUÍDO** quando:

- esta matriz estiver integrada;
- a `main` pós-merge estiver verde;
- o Checkpoint 043 (ou numeração canônica subsequente) registrar o SHA/tree/parent efetivos e a
  decisão final;
- a documentação viva for reconciliada sem reescrever snapshots históricos.

Nenhum código adicional é necessário ou desejável em C.1.6.

## 8. Riscos residuais classificados

### Não bloqueantes para C.1

- relações editoriais detalhadas obra–edição–manifestação serão materializadas apenas quando um lote
  consumidor precisar delas;
- políticas concretas de retenção de conteúdo real dependem da base jurídica/corpus real;
- execução de impacto sobre chunks, embeddings, grafo e componentes só pode existir após essas
  entidades existirem;
- `GAP-3B-05` e `GAP-3B-07` permanecem independentes e contidos;
- nenhuma migration C.1 foi aplicada ao Supabase hospedado.

Esses pontos não são requisitos residuais de C.1. Eles são dependências futuras explicitamente
atribuídas aos lotes que criam ou operam as entidades correspondentes.

### Regra de continuidade

Nenhum risco residual acima autoriza antecipar C.2 ou produção.

## 9. Gates proporcionais de C.1.6

Como C.1.6 é exclusivamente documental e não altera TypeScript, SQL, migrations, RLS, grants,
workflows ou adapters:

- CI geral do PR é obrigatório;
- revisão de changed files, comentários, threads e divergência da base é obrigatória;
- os gates DB/C.1.3/C.1.4/C.1.5 já integrados permanecem evidência herdada e não precisam ser
  duplicados sem mudança técnica;
- qualquer falha geral de formatter/lint/typecheck/test causada pelo diff documental deve ser
  corrigida antes do merge.

## 10. Limites invioláveis

Este fechamento não inicia ou autoriza:

- C.2–C.7;
- ingestão real;
- PDF/OCR/extraction/chunking/embedding real;
- fonte, currículo, estudante, turma ou assignment real;
- Supabase hospedado;
- migrations de produção;
- secret/project ref real;
- frontend, endpoint, API, job, fila, worker ou wiring;
- runtime de agentes;
- ativação da Knowledge Factory em produção.

C.2 permanece bloqueado até autorização humana própria, mesmo após o encerramento de
`GAP-3B-04` e C.1.
