# Sublote C.1.2 — Modelo físico incremental do lifecycle de fontes

Data: 12 de agosto de 2026.

Base canônica: `main` em `2db5fc07378cc7c062753078b2a3fb2025cb1afe`, árvore
`cd477c5ba7b84e8bae14a39e2d6e86228f95b819`.

Branch de implementação:
`feat/knowledge-factory-lot-c1-2-source-lifecycle-persistence`.

## Status e fronteira

Implementado na branch de C.1.2 e aberto como Draft PR nº 34. A revisão técnica final confirmou o
escopo, e a migration, os testes de schema/RLS e o rollback/reaplicação foram executados com sucesso
no Supabase descartável pelo `Knowledge Factory DB CI` run nº 32 (`31657560628`) sobre o HEAD
`c742a422373271633dea86ade80afeb3d1a7c396`. O `CI Pipeline` run nº 280 também concluiu com
`success`. C.1.2 ainda não está integrado à `main` e depende de autorização humana específica para
merge.

Esta fatia persiste os contratos de C.1.1 e prepara a atomicidade futura. Ela não cria RPCs,
adapters, ingestão, conteúdo real, wiring, acesso a Supabase hospedado ou autorização de produção.

## Decisão de autoridade

`public.kf_source_governance_events` é a fonte autoritativa do histórico registral, de autorização e
de abertura de impacto. `public.kf_source_registration_projections` e a parte mutável de
`public.kf_source_authorizations` são projeções correntes reconstruíveis.

Não existe `eligible boolean`. A elegibilidade continua derivada de estado registral, autorização,
finalidade, escopo e instante. Os estados registral e de autorização permanecem ortogonais.

## Identidades persistidas agora

`kf_source_identities` admite os oito tipos de C.1.1: `work`, `edition`, `manifestation`,
`received_file`, `governed_source`, `source_version`, `processing_run` e `derived_artifact`.

Nesta fatia, todos recebem identidade opaca persistível, mas somente `governed_source` e
`source_version` podem apontar, sem equivalência semântica automática, para `kf_sources` e
`kf_source_versions` legados. Catálogo editorial, relações obra–edição–manifestação, recibos de
arquivo, lineage de processamento e detalhes de derivados permanecem para os lotes que realmente os
consumirem. C.1.2 não antecipa um catálogo editorial nem fabrica relações ausentes.

## Tabelas adicionadas

| Tabela | Responsabilidade | Autoridade/mutabilidade |
|---|---|---|
| `kf_source_identities` | IDs tipados e pontes opcionais para IDs legados | append-only |
| `kf_source_authorization_bases` | tipo e digest/referência minimizada do fundamento | append-only |
| `kf_source_registration_projections` | estado, versão, sequência e sucessor correntes | projeção reconstruível |
| `kf_source_authorizations` | agregado de autorização, escopo e projeção corrente | escopo/fundamento/janela imutáveis; estado/versionamento mutáveis apenas pela fronteira futura |
| `kf_source_command_receipts` | `commandId`, fingerprint e resultado persistido | append-only |
| `kf_source_governance_events` | histórico temporal autoritativo | append-only |
| `kf_source_command_receipt_events` | ordem dos eventos produzidos por um comando | append-only |

## Invariantes físicas

- seis estados registrais, sete estados de autorização, dez finalidades, cinco papéis de ator e os
  tipos de comando/evento de C.1.1 são fechados por `CHECK`;
- cada autorização fixa sujeito, finalidade, restrições, fundamento e janela; alteração de escopo
  exige nova autorização/supersessão;
- `effective_until >= effective_from` quando houver término;
- sucessor registral e autorização sucessora não podem ser autorreferentes;
- `SUPERSEDED` exige sucessora e outros estados a proíbem;
- cada evento possui `event_id`, agregado, versão, sequência, ator/papel, razão, tempos,
  `correlation_id`, `command_id` e estados dimensionais compatíveis;
- `(dimension, aggregate_id, sequence)` é único;
- `command_id` é chave primária do recibo, portanto um segundo fingerprint para o mesmo comando
  conflita; replay versus conflito será decidido atomicamente apenas em C.1.3;
- a relação recibo–evento preserva ordem e impede um evento de pertencer a dois recibos;
- FKs auditáveis usam `ON DELETE RESTRICT`.

## Temporalidade e consultas “as of”

Eventos mantêm separadamente `occurred_at`, `effective_at`, janela da autorização e sequência. Uma
consulta histórica filtra eventos com `effective_at <= instant`, respeita sujeito e finalidade e
reconstrói o último estado aplicável sem apagar grants, revogações, expirações ou supersessões.

Índices parciais cobrem histórico registral, histórico da autorização e consulta por
`(subject_identity_id, purpose, effective_at, sequence, event_id)`. Não há índice vetorial nem
capacidade de retrieval.

## Compatibilidade legada

`kf_sources.status`, `kf_sources.allowed_uses`, `license_category` e
`kf_source_permission_events` permanecem intactos e legados. Nenhum backfill é executado porque os
dados existentes não provam ator, papel, fundamento, escopo completo, vigência ou equivalência entre
`approved` e `VALIDATED`/`GRANTED`.

As pontes opcionais preservam IDs sem afirmar equivalência. Enquanto C.1.4 não introduzir tradução
explícita, o repository e o adapter legados continuam consumindo somente o modelo legado.

## Concorrência e fronteira futura

As projeções carregam `aggregate_version` e `sequence`; eventos possuem sequência única; recibos
persistem comando e fingerprint. Isso permite que C.1.3 implemente compare-and-set com
`expectedVersion`/`expectedSequence` em uma transação real. C.1.2 não implementa nem simula essa
transação por chamadas PostgREST.

## Evidência runtime descartável

O `Knowledge Factory DB CI` run nº 32 (`31657560628`) concluiu com `success` no HEAD
`c742a422373271633dea86ade80afeb3d1a7c396`. Foram aprovados, em duas passagens, schema e RLS de
C.1.2, com ensaio de rollback guardado entre elas, reaplicação das migrations e validação das suítes
anteriores da Knowledge Factory. O artefato `knowledge-factory-db-validation-31657560628` foi gerado
pelo run. Essa evidência é exclusivamente não produtiva e não autoriza Supabase hospedado nem
produção.

## Rollback

O ensaio `knowledge_factory_source_lifecycle_rollback.sql` é deliberadamente destrutivo e exclusivo
para ambiente descartável. Ele se recusa a prosseguir se qualquer tabela nova contiver linhas,
remove políticas, triggers, tabelas e a função interna própria de C.1.2 e comprova que as tabelas
legadas e o helper compartilhado append-only permanecem.

Depois que histórico real existir, rollback destrutivo é proibido. A reversão operacional deverá
ser forward-only: revogar acesso/execução futura, preservar eventos e corrigir por migration aditiva.
