# Checkpoint 039 — C.1.3 redefinido sobre a genealogia recuperada; implementação permanece bloqueada

Data: 14 de agosto de 2026.

## Estado canônico de partida

- repositório: `PaulinhoRehfeld/profeplan`;
- branch canônica: `main`;
- commit canônico verificado: `39068d3225185d29c38c8b5841a21f60636b58b2`;
- tree canônica: `a0cba189c9797f4f932dda5a1e548d32fa4d99a4`;
- PR nº 43: integrado por merge commit em 14 de agosto de 2026;
- primeiro pai do merge: `5426c5b8031fa3783b4268911b7517aa00ead600`;
- segundo pai do merge: `28848a09d72875b06d8ada688a8ee72270c3a016`;
- lineage da Knowledge Factory preservada materialmente até C.1.2;
- o commit histórico de definição documental C.1.3 `af4c68622b125317b16ac895ef39d4e61a62537e` permanece fora da genealogia canônica e não foi cherry-picked.

O primeiro pai continha o avanço concorrente legítimo do PR nº 45, `fix(payments): harden Stripe webhook fulfillment`, em `infra/supabase`. A auditoria pós-merge confirmou que esse avanço e a recuperação da Knowledge Factory foram preservados sem sobreposição de conteúdo.

## Motivo deste checkpoint

Durante a recuperação canônica da Knowledge Factory, C.1.3 foi deliberadamente excluído para impedir que uma definição posterior fosse incorporada antes de C.1.2 e da genealogia recuperada estarem novamente estabilizados na `main`.

Após a integração governada do PR nº 43, a Definition of Ready de C.1.3 foi reavaliada contra:

- `BLUEPRINT.md`;
- `PHASE-C-EXECUTION-MAP.md`;
- `LOT-C1-SOURCE-LIFECYCLE-GOVERNANCE-DEFINITION.md`;
- `CONTINUITY-CHECKPOINT-038.md`;
- ADR-043 e ADR-058;
- contratos C.1.1 em `packages/types/src/knowledge-factory/source-lifecycle.ts`;
- persistência C.1.2 em `supabase/migrations/202608122230_kf_source_lifecycle_persistence.sql`;
- o antigo commit `af4c68622b125317b16ac895ef39d4e61a62537e` usado exclusivamente como evidência histórica de projeto.

A revisão concluiu que as decisões técnicas documentais de C.1.3 continuam compatíveis com o estado canônico recuperado. Por isso, os artefatos normativos válidos foram rematerializados sem reincorporar a genealogia antiga.

## Artefatos normativos rematerializados

- `00-governance/ADR-060-C1-3-ATOMIC-BOUNDARY.md`;
- `09-data/LOT-C1-3-SOURCE-LIFECYCLE-TRANSACTION-BOUNDARY.md`;
- `10-legal-security/LOT-C1-3-EXECUTE-COMPETENCE-MATRIX.md`;
- `12-delivery/LOT-C1-3-SOURCE-LIFECYCLE-ATOMIC-BOUNDARY-DEFINITION.md`.

Os cabeçalhos desses documentos preservam a base histórica em que a definição original foi produzida. Para continuidade material após a recuperação, prevalece este Checkpoint 039 e o SHA canônico acima.

## Estado do Lote C.1

- C.1 — definição integrada;
- C.1.1 — contratos integrados;
- C.1.2 — persistência, RLS e grants integrados e recuperados na `main`;
- C.1.3 — definição documental rematerializada e revisada; implementação bloqueada;
- C.1.4 — bloqueado;
- C.1.5 — bloqueado;
- C.1.6 — bloqueado;
- C.2–C.7 — bloqueados.

## Definition of Ready de C.1.3

A inspeção confirmou:

- 13 comandos fechados em C.1.1;
- estados registrais e de autorização preservados;
- eventos e receipts provider-neutral existentes;
- `commandId`, fingerprint, `expectedVersion`, `expectedSequence`, `aggregateVersion` e `sequence` materializados nos contratos/persistência necessários;
- histórico autoritativo e projeções reconstruíveis preservados;
- pseudo-transação PostgREST proibida por ADR-043/ADR-058;
- fronteira candidata por RPCs estreitas por comando;
- replay idempotente definido;
- compare-and-set definido;
- temporalidade não regressiva definida;
- matriz command→actor definida;
- `service_role` tratado somente como canal técnico, não como competência de negócio;
- DML direto deve permanecer revogado;
- `SECURITY DEFINER` exige `search_path` seguro e objetos schema-qualified;
- rollback, concorrência e negative privilege tests definidos;
- adapters permanecem fora de C.1.3 e pertencem a C.1.4;
- ingestão e C.2 permanecem fora de escopo.

## Decisões preservadas

- RPC estreita por comando, sem mega-RPC genérica;
- helpers internos sem `EXECUTE` externo;
- fingerprint SHA-256 canônico recalculado no banco;
- replay antes de revalidar estado ou competência atual;
- CAS obrigatório para mutações existentes;
- `aggregateVersion` como token opaco e `sequence` como ordinal monotônico;
- `effectiveAt` e `occurredAt` não regressivos por agregado;
- impacto conservador aberto atomicamente para comandos restritivos;
- supersessão predecessor→`SUPERSEDED` + successor→`GRANTED` em uma única transação;
- `processing_run`, `derived_artifact`, expiração explícita e fechamento de impacto permanecem fora desta fatia;
- fonte autoritativa mínima de competência deverá ser criada somente se a implementação de C.1.3 for autorizada.

## Segurança e dados

Nenhuma ação deste checkpoint:

- cria ou altera tabela no banco;
- aplica migration;
- cria RPC ou helper SQL executável;
- concede `EXECUTE` ou DML;
- acessa Supabase hospedado;
- usa credencial, secret ou project ref real;
- altera produção;
- processa PDF, PNLD ou qualquer conteúdo real.

A futura implementação de C.1.3 é uma fronteira de segurança sensível, pois envolve `SECURITY DEFINER`, grants, competência de ator e escrita multi-registro. Ela deve permanecer um gate explícito separado antes de qualquer SQL executável.

## GAPs

- `GAP-3B-04` permanece ativo e contido;
- `GAP-3B-05` permanece ativo e contido;
- `GAP-3B-07` permanece ativo e contido.

C.1.3 isoladamente não encerra `GAP-3B-04`. A decisão permanece destinada a C.1.6 após C.1.4 e C.1.5 integrados.

## Próximo gate

O próximo passo técnico possível é implementar exclusivamente a migration/RPCs e testes de C.1.3 em branch controlada e Supabase descartável, preservando C.1.4, C.2, Supabase hospedado e produção bloqueados.

Por envolver fronteira `SECURITY DEFINER`, grants e competência jurídico-editorial, esse passo não é tratado como rotina pré-autorizada. Ele exige revisão explícita do risco de segurança antes da primeira escrita SQL executável.
