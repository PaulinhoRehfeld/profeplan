# CONTINUITY CHECKPOINT 035 — C.1.1 implementado em branch e aguardando validação por PR

Data: 12 de agosto de 2026.

## Status

**O Sublote C.1.1 — contrato normativo de estados, comandos, eventos e invariantes — foi
implementado em branch própria, de forma aditiva e provider-neutral. A implementação ainda não foi
integrada à `main`, não abre C.1.2 e não encerra `GAP-3B-04`. O próximo gate é validação pelo CI do
repositório em Pull Request e revisão humana.**

## Base canônica confirmada

Repositório:

`PaulinhoRehfeld/profeplan`

Branch canônica:

`main`

SHA confirmado antes da implementação:

`01c92dda8257935e7a6c042be12308ebccdaeb73`

Tree confirmada:

`1f178369613cba1c97f8abf0cff859587a59ad16`

Commit:

`docs(knowledge-factory): define Lot C.1 source lifecycle governance (#32)`

O PR nº 32 foi confirmado como integrado por squash merge. O Checkpoint 034 está presente na
`main` e permanece como registro histórico da definição documental de C.1.

## Branch de implementação

`feat/knowledge-factory-lot-c1-1-source-lifecycle-contracts`

Head técnico imediatamente antes deste checkpoint:

`bd0df32237881bf14cd34f20438a393d9ba463e1`

Nenhum Pull Request foi aberto por este checkpoint.

## Escopo implementado

C.1.1 foi mantido restrito a:

- contratos compartilhados em `@profeplan/types`;
- domínio puro em `@profeplan/knowledge-factory`;
- estados registral e de autorização separados;
- finalidades normativas do pipeline;
- referências mínimas de identidade;
- comandos discriminados;
- eventos auditáveis;
- recibos provider-neutral;
- idempotência por `commandId` + fingerprint;
- concorrência otimista por versão e sequência esperadas;
- validação de ator, papel, fundamento e janela temporal para grant;
- política temporal de elegibilidade `as of`;
- razões provider-neutral;
- testes unitários e de contrato.

## Estratégia de compatibilidade

C.1.1 não altera os contratos legados abaixo:

- `SourceStatus`;
- `SourceUse`;
- `KnowledgeSource`;
- `SourceVersion`;
- `SourcePermissionEvent`;
- `KnowledgeSourceRepository`;
- `evaluateSourceEligibility()` legado;
- mapper ou adapter Supabase;
- schema físico existente.

A nova superfície nasce separadamente em:

`packages/types/src/knowledge-factory/source-lifecycle.ts`

com versão própria:

`SOURCE_LIFECYCLE_CONTRACT_VERSION = '1.0.0'`

Essa decisão evita reinterpretar silenciosamente:

- `approved` como `VALIDATED + GRANTED`;
- `draft` como estado registral inequívoco;
- `allowedUses` como verdade histórica de autorização;
- `internal_review` como autorização implícita para ingestão, extração ou outras finalidades.

## Estados normativos materializados

### Lifecycle registral

- `REGISTERED`
- `PENDING_VALIDATION`
- `VALIDATED`
- `BLOCKED`
- `REPLACED`
- `ARCHIVED`

### Lifecycle da autorização

- `PENDING_REVIEW`
- `GRANTED`
- `SUSPENDED`
- `REVOKED`
- `EXPIRED`
- `BLOCKED`
- `SUPERSEDED`

Os dois `BLOCKED` permanecem em tipos distintos e não são um único super status.

## Finalidades normativas materializadas

`SourcePurpose` contém:

- `temporary_staging`;
- `ingestion`;
- `extraction`;
- `analysis_classification`;
- `distillation`;
- `quotation`;
- `indexing_embedding`;
- `retrieval`;
- `evidence`;
- `generation`.

Nenhuma finalidade concede outra por inferência.

## Identidades

C.1.1 não cria entidades persistentes completas antecipadamente. Foram criadas apenas referências
mínimas e discriminadas para manter distinguíveis:

- obra;
- edição;
- manifestação;
- arquivo recebido;
- fonte governada;
- versão da fonte;
- execução de processamento;
- derivado.

A materialização física dessas identidades continua pertencendo a C.1.2 e lotes posteriores.

## Comandos, eventos e recibos

Os contratos distinguem famílias de:

- registro/validação;
- autorização;
- abertura de avaliação de impacto.

Os envelopes carregam, conforme aplicável:

- `commandId`;
- fingerprint;
- ator e papel;
- versão e sequência esperadas;
- `occurredAt`;
- `effectiveAt`;
- `correlationId`;
- razão;
- fundamento minimizado;
- agregado e versão;
- sequência;
- estado anterior/posterior;
- IDs de eventos no recibo;
- flag de replay.

Nenhum payload inclui texto integral de fonte, PDF, página, credencial, contrato integral ou conteúdo
sensível desnecessário.

## Elegibilidade temporal

Foi criada política própria e explícita:

`evaluateGovernedSourceEligibility()`

A entrada representa:

`(sourceVersionId, purpose, instant, registrationHistory, authorizationHistory)`

A saída é discriminada entre:

- `ELIGIBLE`; ou
- `INELIGIBLE` com razões controladas.

A política:

- usa somente o instante recebido;
- não usa `Date.now()`;
- ignora eventos futuros em consulta histórica;
- ordena eventos por instante efetivo, sequência e ID;
- agrupa autorizações por `authorizationId`;
- torna a escolha determinística quando a entrada chega fora de ordem;
- deriva expiração pela janela temporal mesmo sem evento de manutenção;
- falha fechada para janela temporal inválida;
- não transfere autorização entre versões;
- não converte ausência de informação em autorização.

## Idempotência e concorrência

Foi materializado comportamento puro para:

- comando novo;
- replay seguro quando `commandId` e fingerprint coincidem;
- conflito quando o mesmo `commandId` chega com fingerprint divergente;
- conflito por versão esperada divergente;
- conflito por sequência esperada divergente;
- conflito por estado esperado divergente.

Nenhum compare-and-set de banco foi implementado. A fronteira física permanece destinada a C.1.3.

## Invariantes cobertas

A matriz implementada cobre as invariantes obrigatórias da autorização de C.1.1, incluindo:

1. `VALIDATED` não implica `GRANTED`;
2. finalidade não autorizada é inelegível;
3. autorização expirada é inelegível;
4. fonte bloqueada é inelegível;
5. autorização suspensa é inelegível;
6. revogação vale a partir do instante efetivo;
7. grant futuro não vale antes de `effectiveFrom`;
8. janela invertida é inválida;
9. substituição não transfere autorização;
10. `REVOKED → GRANTED` no mesmo grant é proibido;
11. `EXPIRED → GRANTED` no mesmo grant é proibido;
12. `BLOCKED → VALIDATED` diretamente é proibido;
13. replay idêntico é seguro;
14. fingerprint divergente conflita;
15. estado/versão/sequência esperados divergentes conflitam;
16. grant sem fundamento é rejeitado;
17. ator ausente ou papel incompetente é rejeitado;
18. consulta histórica é determinística;
19. políticas permanecem sem provider, rede, filesystem e relógio global;
20. ausência de informação falha fechada.

Foram adicionados ainda controles para:

- `effectiveUntil` malformado;
- múltiplos grants ativos com resultado determinístico por autorização.

## Validação executada fora do provider

O ambiente de execução não conseguiu clonar o GitHub diretamente por restrição de rede. Para não
abrir PR apenas para obter CI, a fatia modificada foi reconstruída isoladamente e validada com as
mesmas opções essenciais de TypeScript estrito do repositório.

Resultados:

- TypeScript 5.8.3, `strict`, `moduleResolution: Bundler`, `noEmit`: **verde**;
- testes de invariantes centrais: **20/20 verdes**;
- testes adicionais de janela malformada e ordenação entre grants: **2/2 verdes**;
- verificações de contrato/enum: **6/6 verdes**;
- total da validação independente executada: **28/28 verdes**.

Essa validação não substitui o CI oficial do repositório.

## CI oficial

O workflow `.github/workflows/ci.yml` executa em:

- push para `main` ou `develop`;
- Pull Request contra `main` ou `develop`.

Como nenhum PR foi autorizado/aberto nesta etapa, o CI principal ainda não executou contra esta
branch. Consequentemente, C.1.1 está **pronto para validação por PR**, mas não deve ser declarado
integrado ou encerrado antes desse gate.

O status Vercel da branch não é tratado como substituto do CI de contrato, typecheck e testes.

## Diff técnico revisado antes deste checkpoint

Comparação contra a base canônica confirmou alteração técnica somente em:

- `packages/types/src/knowledge-factory/source-lifecycle.ts`;
- `packages/types/src/knowledge-factory/index.ts`;
- `packages/types/test/source-lifecycle.test.mjs`;
- `packages/knowledge-factory/src/domain/reasons.ts`;
- `packages/knowledge-factory/src/index.ts`;
- `packages/knowledge-factory/src/policies/source-lifecycle.ts`;
- `packages/knowledge-factory/src/policies/source-authorization.ts`;
- `packages/knowledge-factory/src/policies/governed-source-eligibility.ts`;
- `packages/knowledge-factory/test/source-lifecycle.test.mjs`;
- `packages/knowledge-factory/test/governed-source-eligibility.test.mjs`.

Não há mudança técnica em:

- `packages/knowledge-factory-supabase`;
- `supabase/`;
- migrations;
- SQL/RPC/RLS/grants;
- API;
- frontend;
- jobs/filas;
- retrieval;
- agentes;
- conteúdo real.

## Navegação documental pós-PR nº 32

Durante a inspeção foi confirmado que alguns textos vivos integrados pelo próprio PR nº 32 ainda
mantêm redação de pré-merge, por exemplo referências a “integração pendente” da definição de C.1.
Isso é tratado como dívida de navegação, não como conflito semântico.

Este checkpoint não reescreve o Checkpoint 034 nem altera retrospectivamente a história. A limpeza
de navegação de `README`, `BLUEPRINT` e status textuais dos ADRs 056–058 deve ocorrer de forma
controlada antes ou durante a revisão do PR de C.1.1, sem mudar as decisões aprovadas.

## Estado dos GAPs

### `GAP-3B-04`

**ATIVO E CONTIDO.**

C.1.1 satisfaz somente a parcela contratual. O gap continua exigindo:

- C.1.2 — persistência, RLS e grants;
- C.1.3 — fronteira atômica;
- C.1.4 — adapters;
- C.1.5 — integração, segurança e concorrência;
- C.1.6 — inspeção e decisão explícita de fechamento.

### `GAP-3B-05`

**ATIVO E CONTIDO.**

Os eventos específicos de C.1.1 não ampliam nem encerram a auditoria geral de `US-013.2`.

### `GAP-3B-07`

**ATIVO E CONTIDO.**

Nenhuma OPP foi transformada em job de ingestão e nenhuma capacidade futura de retrieval, geração,
validação ou entrega foi antecipada.

## Itens expressamente não realizados

- migration;
- SQL;
- RPC;
- RLS;
- grants;
- DML;
- Supabase hospedado;
- `service_role`;
- produção;
- upload;
- PDF real;
- PNLD real;
- OCR;
- ingestão;
- extração;
- segmentação;
- chunks;
- embeddings;
- pgvector;
- retrieval;
- reranking;
- agentes;
- Sócrates 2 executável;
- API;
- frontend;
- job/fila;
- wiring;
- Gráfica;
- Nexus;
- C.1.2.

## Gate de saída desta branch

Antes de qualquer integração, ainda são obrigatórios:

1. abrir PR somente com autorização humana explícita;
2. executar o CI oficial;
3. revisar formatter/lint/typecheck/test do repositório;
4. revisar o diff completo do PR;
5. corrigir qualquer regressão sem ampliar escopo;
6. manter C.1.2 bloqueado;
7. merge permanecer humano.

## Próximo gate humano

O próximo passo seguro é autorizar, separadamente, a abertura de um **PR draft de C.1.1 contra
`main`** para executar o CI e permitir revisão formal.

A abertura ou eventual integração desse PR não autoriza C.1.2 automaticamente.
