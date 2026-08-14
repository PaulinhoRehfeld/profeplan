# CONTINUITY CHECKPOINT 026 — Definição documental do Lote 3B.5

Data: 11 de agosto de 2026.

## Estado proposto para revisão

**O Lote 3B.5 foi definido documentalmente sobre a `main` pós-encerramento do 3B.4. Nenhum código,
migration, RPC, grant, RLS, workflow, wiring, Supabase hospedado ou produção foi alterado.**

Base canônica verificada:

- repositório: `PaulinhoRehfeld/profeplan`;
- branch-base: `main`;
- commit-base: `d54f092e451d6663404e4b747c56196c9bd2536d`;
- origem da base: squash merge do Pull Request nº 23;
- branch documental: `agent/knowledge-factory-lot-3b5-definition`;
- Pull Request documental: a registrar após publicação.

## Resultado da inspeção

A porta atual:

```ts
findById(id);
save(order);
appendEvent(event);
listEvents(oppId);
```

não consegue garantir atomicidade entre OPP e timeline. Além disso, o INSERT autenticado preparado
no schema permite criar OPP `requested` sem evento `created`.

A inspeção também reconciliou o contrato normativo não materializado do Marco 003. O domínio e o
schema atuais são uma fatia mínima e não persistem toda a OPP normativa, seus atores, sequência,
contexto, inclusão, correlação, tentativas, componentes utilizados, validações e entrega.

## Decisões propostas

1. decompor a porta em leitura, solicitação e transição;
2. remover `save` e `appendEvent` no contrato `3.0.0`;
3. usar contexto REQUESTER efêmero nas leituras e na criação;
4. criar OPP, evento `created` e recibo em uma única RPC REQUESTER;
5. executar transição somente no backend server-side, após decisão aceita da política de domínio;
6. atualizar OPP, inserir evento derivado e recibo em uma única RPC server-only;
7. aplicar idempotência por `commandId`, fingerprint, replay e conflito;
8. aplicar compare-and-set por requester, estado e `updatedAt`;
9. preservar RLS nas leituras e proibir DML direto nas escritas;
10. registrar `GAP-3B-07` para a cobertura normativa ainda ausente.

## Sublotes propostos

| Sublote | Conteúdo                                      | Exclusões centrais               |
| ------- | --------------------------------------------- | -------------------------------- |
| 3B.5.1  | contratos `3.0.0` e contextos                 | sem migration/RPC/adapter        |
| 3B.5.2  | adapter REQUESTER read-only                   | sem escrita ou SYSTEM fallback   |
| 3B.5.3  | recibos, duas RPCs, grants e testes DB        | sem hosted Supabase/produção     |
| 3B.5.4  | adapters REQUESTER create e SYSTEM transition | sem API/frontend/wiring/produção |

Cada sublote exigirá branch, PR, CI e decisão humana próprios.

## GAPs

### GAP-3B-03

Permanece ativo. Seu encerramento exige contratos, atomicidade de criação/transição, requester
isolation, server-only transition, rollback, idempotência, concorrência, adapters exclusivos das
RPCs, integração humana dos quatro sublotes e checkpoint pós-merge.

### GAP-3B-07

Novo gap. A fatia física atual é menor que o contrato normativo da OPP. Ele não bloqueia a
infraestrutura mínima, mas impede:

- declarar a OPP funcional completa;
- marcar US-010.1 ou US-010.2 como integralmente concluídas;
- antecipar contexto, inclusão, observabilidade, retrieval, geração, validação ou entrega;
- confundir encerramento da Fase B com conclusão das Fases C–E.

`GAP-3B-04` e `GAP-3B-05` permanecem ativos e fora deste lote.

## Riscos adicionados

- R-3B-22 — requester context reutilizado ou adulterado;
- R-3B-23 — criação de OPP sem evento inicial;
- R-3B-24 — RPC de transição exposta ao requester;
- R-3B-25 — fatia mínima apresentada como OPP funcional completa.

## Estado preservado

- Fase A — concluída;
- Lotes 3B.1 a 3B.4 — integrados;
- Lote 3B.5 — definição documental proposta; código não iniciado;
- `GAP-3B-01`, `GAP-3B-02` e `GAP-3B-06` — encerrados;
- `GAP-3B-03`, `GAP-3B-04`, `GAP-3B-05` e `GAP-3B-07` — ativos;
- Fase B — não concluída;
- Fase C — não iniciada;
- produção — não autorizada.

## Limites desta branch

- somente documentação e governança;
- nenhuma alteração de contrato TypeScript ainda;
- nenhuma migration, função, RPC, grant, policy, tabela, trigger ou índice;
- nenhum adapter, mapper, fixture de código ou workflow;
- nenhum API, frontend, composition root, auth ou worker;
- nenhum acesso ao Supabase hospedado;
- nenhuma aplicação em produção;
- nenhum dado pedagógico ou de estudante real;
- nenhum início implícito do 3B.5.1;
- nenhum merge ou auto-merge autorizado por este checkpoint.

## Próximo gate humano

Revisar o Pull Request documental do Lote 3B.5 e decidir entre solicitar ajustes, rejeitar/adiar ou
autorizar seu squash merge.

Somente após eventual integração poderá ser iniciado o 3B.5.1 — contratos e contextos — mediante
nova autorização explícita. Os demais sublotes não são autorizados por continuidade.
