# Lote 3B — Registro de riscos e bloqueios

Status: **aprovado integralmente em 7 de agosto de 2026. Os riscos permanecem ativos até suas condições de mitigação/gate serem satisfeitas.**

## R-3B-01 — Acoplamento reverso com `api/`

Risco: pacote de infraestrutura importar `api/_lib/supabaseAdmin.ts`, fazendo `packages/*` depender de `api/*`.

Mitigação: client injection pelo composition root.

Gate: nenhum import de `api/` dentro de `packages/knowledge-factory-supabase`.

## R-3B-02 — Vazamento de `service_role`

Risco: secret chegar ao frontend, logs, erros ou testes.

Mitigação: adapter recebe client já criado; não lê env; não serializa client; CI descartável sem credenciais hospedadas.

Gate: qualquer secret em diff/log bloqueia merge.

## R-3B-03 — Uso de `service_role` para OPP privada

Risco: bypass de RLS e dependência apenas de filtros manuais.

Mitigação: ProductionOrderRepository prefere requester-scoped client.

Gate: adapter OPP não inicia até estratégia requester-scoped ser aprovada.

## R-3B-04 — Lookup curricular ambíguo

Risco: `findActivePackageByState(state)` retornar pacote errado quando houver ativo para mais de uma etapa.

Mitigação: corrigir contrato para incluir `stage` antes do adapter curricular.

Gate: CurriculumRepository adapter bloqueado.

## R-3B-05 — Pseudo-transação de componente

Risco: componente criado sem primeira versão, links incompletos ou current_version inconsistente.

Mitigação: função SQL/RPC transacional futura ou fronteira atômica aprovada.

Gate: escrita do componente bloqueada.

## R-3B-06 — Pseudo-transação OPP + evento

Risco: status da OPP divergir da timeline append-only.

Mitigação: comando transacional no banco antes de escrita de transição.

Gate: transição OPP via adapter bloqueada.

## R-3B-07 — Inventar métodos fora das portas

Risco: adapter virar camada de aplicação/ingestão e contornar arquitetura contract-first.

Mitigação: implementar apenas assinaturas existentes.

Gate: método não presente na porta exige nova decisão/contrato.

## R-3B-08 — Erro de provider vazando para camadas superiores

Risco: SQLSTATE/PostgREST/queries aparecerem em API ou UX.

Mitigação: `KnowledgeFactoryPersistenceError` sanitizado.

Gate: testes de tradução de erro obrigatórios.

## R-3B-09 — Logger acoplar filesystem/serverless

Risco: adapter depender diretamente do logger Node que escreve em arquivo síncrono.

Mitigação: logger mínimo injetado; adaptação no composition root.

Gate: sem import direto de `@profeplan/logger` no primeiro PR.

## R-3B-10 — Duplicação do ambiente Supabase de teste

Risco: dois stacks CI divergirem e aumentarem custo/manutenção.

Mitigação: reutilizar `Knowledge Factory DB CI`.

Gate: infraestrutura duplicada exige justificativa e aprovação.

## R-3B-11 — Teste acidental contra produção

Risco: adapter test usar URL/project ref real.

Mitigação: integração somente no Supabase descartável do Actions.

Gate: teste não pode exigir project ref, access token ou service role hospedado.

## R-3B-12 — Mapeamento parcial silencioso

Risco: row incompleta ser convertida em contrato aparentemente válido.

Mitigação: mapper explícito + `MAPPING_ERROR`/`INVALID_RESPONSE` provider-neutral.

Gate: testes negativos de row incompatível.

## R-3B-13 — Perda de consistência em leitura composta

Risco: múltiplos SELECTs retornarem estado parcialmente alterado.

Mitigação: aceitar somente onde consistência eventual é suficiente; para casos críticos, criar RPC/read model específico posteriormente.

Gate: não usar leitura composta para decisão que exige snapshot forte sem ADR.

## R-3B-14 — `@supabase/supabase-js` não declarado no workspace

Risco: depender de hoisting implícito do root.

Mitigação: declarar dependência direta no pacote no primeiro PR, reutilizando a linha de versão já presente no monorepo.

Gate: install/typecheck com lockfile atualizado e CI verde.

## R-3B-15 — Crescimento prematuro do primeiro PR

Risco: implementar cinco adapters e múltiplos gaps de uma vez.

Mitigação: primeira fatia exclusiva de AuditRepository.

Gate: segunda porta no mesmo PR bloqueia merge.

## R-3B-16 — Mistura entre log operacional e auditoria funcional

Risco: duplicar eventos, armazenar PII ou transformar logs em fonte de verdade.

Mitigação: `kf_audit_events` e telemetria operacional têm finalidades distintas.

Gate: não escrever todo log automaticamente em audit table.

## R-3B-17 — Adapters antes da migration em produção

Risco: código existir antes das tabelas no ambiente real.

Mitigação: adapters podem ser mergeados/testados sem wiring de produção; nenhum endpoint chama adapter até pre-flight e autorização de produção.

Gate: ausência de production wiring no 3B inicial.

## R-3B-18 — Nexus antecipado

Risco: desviar o foco para integração externa antes da fundação interna.

Mitigação: Nexus permanece explicitamente bloqueado.

Gate: nenhuma referência operacional ou integração Nexus no Lote 3B.

## R-3B-19 — Contrato de auditoria não expõe todos os campos físicos

Risco: `AuditRepository.listByAggregate()` devolve `DomainEvent`, mas a tabela `kf_audit_events` contém também ator, papel, correlation id, outcome e reason. Um adapter pode persistir contexto adicional e depois descartá-lo na leitura, criando percepção incorreta de auditoria completa.

Mitigação:

- primeiro adapter trata auditoria como fatia de infraestrutura;
- mapper retorna exatamente o contrato atual, sem inventar campos;
- contexto técnico adicional pode ser persistido por contexto injetado, mas não é prometido no retorno da porta;
- necessidade de auditoria enriquecida será resolvida por alteração contratual explícita posterior.

Gate: US-013.2 não recebe `Done` integral no primeiro PR do 3B.

## Regra de interpretação

A aprovação deste registro significa que os riscos, mitigações e gates são aceitos como controles obrigatórios. Não significa que os riscos foram encerrados.