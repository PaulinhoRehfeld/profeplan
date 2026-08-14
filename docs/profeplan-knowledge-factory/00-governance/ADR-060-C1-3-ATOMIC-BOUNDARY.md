## ADR-060 — C.1.3 usa RPCs estreitas, competência explícita e CAS idempotente

**Status:** aprovado para a definição documental de C.1.3 em 13 de agosto de 2026; implementação não autorizada.

C.1.3 implementará os 13 comandos já integrados em C.1.1 por RPCs PostgreSQL estreitas por comando,
com helpers internos compartilhados e não executáveis pelos papéis de API. Não será criada uma
mega-RPC genérica de lifecycle.

A execução será server-only e `service_role` funcionará apenas como canal técnico de `EXECUTE`, sem
DML direto e sem constituir competência de negócio. O ator informado no comando deverá possuir
atribuição vigente em fonte autoritativa própria; curator e legal/editorial reviewer permanecem
competências separadas, e system worker, auditor e technical admin não recebem decisão autônoma.

Idempotência será serializada por `commandId`; o fingerprint será SHA-256 canônico calculado e
verificado no banco; replay idêntico retornará o receipt histórico sem reexecutar invariantes.
Mutações de agregados existentes exigirão `expectedVersion` e `expectedSequence`; `aggregateVersion`
será token opaco de revisão e `sequence` o ordinal histórico. Eventos não poderão regressar
`effectiveAt`/`occurredAt` em relação ao último evento do agregado.

Comandos que reduzam ou alterem elegibilidade abrirão avaliação de impacto na mesma transação.
`supersede_authorization` preservará o predecessor em `SUPERSEDED`, criará uma autorização sucessora
`GRANTED` e registrará todos os eventos/receipt de forma atômica, sem editar silenciosamente escopo
histórico.

A implementação futura exige migration isolada, SECURITY DEFINER com `search_path` seguro, grants
mínimos, rollback, replay, concorrência e testes negativos em Supabase descartável. Merge não
autoriza Supabase hospedado ou produção. C.1.4, C.2 e fechamento de GAP-3B-04 permanecem fora de
escopo.


## Gate

A materialização documental desta ADR na branch de C.1.3 não autoriza migration, RPC, adapter, C.1.4, C.2, PR, merge, Supabase hospedado ou produção.
