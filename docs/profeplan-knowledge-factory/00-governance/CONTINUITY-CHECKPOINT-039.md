# Checkpoint 039 — C.1.3 definido documentalmente; implementação permanece bloqueada

Data: 13 de agosto de 2026.

## Estado canônico de partida

- repositório: `PaulinhoRehfeld/profeplan`;
- `main` verificada antes da abertura: `7faf6af817099ce45757d606b392695bc4baee0d`;
- tree-base: `ec15e050785672c399db9169fd8431f9f00c2bf5`;
- parent da `main` de partida: `673318c2d3370f60997fd0a15b68bc69c6be5755`;
- branch documental: `docs/knowledge-factory-lot-c1-3-atomic-boundary`.

A branch foi criada exatamente a partir do SHA-base acima. Este checkpoint materializa a definição
documental de C.1.3 na branch. A `main` não é alterada por este commit documental.

## Estado do Lote C.1

- C.1 — definição integrada;
- C.1.1 — contratos integrados;
- C.1.2 — persistência/RLS/grants integrados;
- C.1.3 — definição documental materializada na branch; implementação bloqueada;
- C.1.4 — bloqueado;
- C.1.5 — bloqueado;
- C.1.6 — bloqueado;
- C.2–C.7 — bloqueados.

## Decisões fechadas para C.1.3

- RPC pública estreita por comando, não mega-RPC;
- helpers internos compartilhados e sem `EXECUTE` externo;
- 13 comandos de C.1.1 como superfície fechada;
- `processing_run` e `derived_artifact` não registráveis nesta fatia;
- fonte autoritativa de competência via assignment dedicada se a implementação for autorizada;
- `service_role` somente como canal técnico de `EXECUTE`;
- DML direto continua revogado;
- fingerprint SHA-256 canônico calculado/verificado no banco;
- replay antes de revalidar estado/competência;
- CAS obrigatório para mutações existentes;
- `aggregateVersion` como token UUID opaco;
- `sequence` como ordinal monotônico;
- `effectiveAt`/`occurredAt` não regressivos por agregado;
- impacto conservador e atômico para comandos restritivos;
- supersession predecessor→`SUPERSEDED` + successor→`GRANTED` em uma transação;
- taxonomia provider-neutral existente preservada;
- rollback e concorrência definidos como gates obrigatórios.

## Artefatos documentais materializados

- `09-data/LOT-C1-3-SOURCE-LIFECYCLE-TRANSACTION-BOUNDARY.md`;
- `10-legal-security/LOT-C1-3-EXECUTE-COMPETENCE-MATRIX.md`;
- `12-delivery/LOT-C1-3-SOURCE-LIFECYCLE-ATOMIC-BOUNDARY-DEFINITION.md`;
- `00-governance/ADR-060-C1-3-ATOMIC-BOUNDARY.md`;
- este `CONTINUITY-CHECKPOINT-039.md`;
- navegação da Fase C atualizada no `README.md` da Knowledge Factory.

## GAPs

- `GAP-3B-04` permanece ativo e contido;
- `GAP-3B-05` permanece ativo e contido;
- `GAP-3B-07` permanece ativo e contido.

C.1.3 não pode encerrar `GAP-3B-04` isoladamente. A decisão continua destinada a C.1.6 após
fronteira atômica implementada, adapters e testes integrados.

## Não realizado

Nenhuma migration, RPC, helper SQL, tabela, teste executável, adapter, API, frontend, ingestão,
Supabase hospedado, secret, produção ou PR foi criado/aberto por este checkpoint.

Nenhuma autorização deste commit documental deve ser interpretada como autorização de implementação.

## Próximo gate

A próxima ação segura é revisar o commit documental de C.1.3. Se a definição for aprovada, um gate
humano separado poderá autorizar exclusivamente a implementação de migration/RPCs/testes de C.1.3
em ambiente descartável. C.1.4, C.2, push adicional, PR, merge e produção permanecem gates separados.
