# CONTINUITY CHECKPOINT 016 — Abertura documental do Lote 3B.3

Data: 7 de agosto de 2026.

## Status

**O Lote 3B.2 está integrado. O ciclo 3B.3 foi aberto somente para definição documental. O adapter curricular, a alteração da porta e qualquer código continuam bloqueados até revisão e integração humana desta documentação.**

## Repositório e base

Repositório:

`PaulinhoRehfeld/profeplan`

Branch documental:

`agent/knowledge-factory-lot-3b3-definition`

Pull Request:

`#14 — docs(knowledge-factory): define Lote 3B.3 curriculum adapter`

Estado na abertura:

`draft`

Base:

`d7eab04afc7358b344beb8f86c2584ef1437558b`

## Decisão em revisão

A proposta resolve a ambiguidade de:

`findActivePackageByState(state)`

substituindo-a por:

`findActivePackageByStateAndStage(state, stage)`

A mudança é necessária porque o schema garante um pacote ativo por `(state, stage)`, e não apenas por Estado.

## Escopo futuro condicionado ao merge

Depois da aprovação documental, poderá ser implementado um adapter SYSTEM e read-only com os quatro métodos da porta:

- localizar pacote por ID;
- localizar pacote ativo por Estado e etapa;
- localizar nó por ID;
- listar nós por pacote.

## Bloqueios preservados

- nenhum código do adapter nesta branch;
- nenhuma mudança em contrato nesta branch;
- nenhum currículo real;
- nenhuma migration ou RPC;
- nenhuma escrita curricular;
- nenhuma API, frontend ou produção;
- nenhum retrieval, embedding ou agente;
- Lotes 3B.4 e 3B.5 não iniciados.

## GAPs

- GAP-3B-01: alvo desta definição, ainda aberto;
- GAP-3B-02: ativo;
- GAP-3B-03: ativo;
- GAP-3B-04: ativo;
- GAP-3B-05: ativo.

## Próximo gate humano

Revisar o PR documental e decidir entre:

1. solicitar ajustes;
2. aprovar e integrar a definição;
3. rejeitar ou adiar o Lote 3B.3.

Somente a integração humana desta definição autorizará a criação da branch de código.
