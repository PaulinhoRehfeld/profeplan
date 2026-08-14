# ADR-061 — Encerramento do Lote C.1 e do GAP-3B-04

Data: 14 de agosto de 2026.

**Status:** aprovado e materializado por C.1.6 após integração do PR nº 57.

## Contexto

`GAP-3B-04` foi registrado na Fase B porque a porta mínima de fontes não cobria o lifecycle completo
necessário a uma ingestão governada. A contenção aprovada destinou a resolução à Fase C, sem
antecipar ingestão real, segmentação ou produção.

A definição normativa posterior de C.1 estabeleceu um critério de fechamento mais preciso: o gap
somente poderia ser encerrado quando o lifecycle necessário à ingestão estivesse definido,
persistido, protegido, adaptado, testado e integrado.

C.1 foi então executado em seis sublotes:

- C.1.1 — contratos normativos;
- C.1.2 — persistência, RLS e grants;
- C.1.3 — fronteira atômica, competência, idempotência, CAS, concorrência e impacto;
- C.1.4 — ports/adapters provider-neutral e leitura histórica;
- C.1.5 — prova integrada de contrato, segurança, concorrência e rollback;
- C.1.6 — auditoria final, matriz de fechamento e decisão sobre o gap.

## Decisão

1. O Lote **C.1 — Governança operacional do lifecycle de fontes está concluído**.
2. `GAP-3B-04 — lifecycle de fonte incompleto para ingestão` está **encerrado**.
3. A menção histórica a `SourceSegment` no texto do gap original não transforma segmentação em
   requisito residual de C.1. A decomposição canônica posterior atribui:
   - C.2 — ingestão controlada;
   - C.3 — extração;
   - C.4 — segmentação e classificação estrutural.
4. Nenhuma autorização, competência ou direito é transferido implicitamente entre finalidades,
   versões ou sucessores.
5. `service_role` permanece somente canal técnico e não representa competência jurídico-editorial.
6. O fechamento de C.1 não autoriza Supabase hospedado, migration de produção, conteúdo real,
   ingestão, PDF/OCR, wiring, frontend, endpoints, jobs, filas, agentes ou produção.
7. C.2 torna-se apenas o próximo lote estrutural candidato e continua bloqueado até sua própria
   autorização humana e verificação de Definition of Ready.

## Evidências

A decisão é sustentada por:

- `12-delivery/LOT-C1-SOURCE-LIFECYCLE-GOVERNANCE-DEFINITION.md`;
- `12-delivery/LOT-C1-5-SOURCE-LIFECYCLE-TEST-EVIDENCE-MATRIX.md`;
- `12-delivery/LOT-C1-6-SOURCE-LIFECYCLE-CLOSURE-MATRIX.md`;
- Checkpoints 040, 041, 042 e 043;
- PR nº 57, squash `3ae0f5554eed5e7bd7f208647e068a304127058d`;
- CI Pipeline nº 361 no HEAD do PR — verde;
- CI Pipeline nº 362 na `main` pós-merge — verde;
- evidências DB/C.1.3/C.1.4/C.1.5 herdadas e registradas nos artefatos dos respectivos sublotes.

## Consequências

### Positivas

- futura ingestão poderá ser desenhada sobre uma fronteira de lifecycle já governada;
- direitos e finalidade permanecem históricos, temporais e auditáveis;
- a separação entre domínio, provider e competência fica preservada;
- não é necessário criar nova arquitetura apenas para encerrar C.1;
- segmentação não é antecipada fora do lote que a possui.

### Riscos residuais aceitos

- política de retenção concreta de conteúdo real depende do corpus e fundamento jurídico aplicável e
  deve ser fechada antes de ingestão real;
- impacto material sobre chunks, embeddings, relações e componentes dependerá das entidades que
  serão criadas por lotes posteriores;
- `GAP-3B-05` e `GAP-3B-07` permanecem ativos e contidos;
- migrations do lifecycle permanecem não aplicadas a ambiente hospedado.

Esses riscos não reabrem `GAP-3B-04`, pois não representam lacuna no lifecycle abstrato e integrado
de C.1.

## Autoridade

Para o estado operacional corrente de C.1 e `GAP-3B-04`, o Checkpoint 043 e a matriz de fechamento
C.1.6 prevalecem sobre marcadores de status preservados em snapshots históricos.
