# C.4 mínimo — confirmação estrutural por revisão

Data: 21 de agosto de 2026.

Base de origem: `main@d3fd27e2ea8f65b1e47fb27416814e89be5486e5` (PR #125 integrado).

## 1. Pergunta material

> Qual é a menor superfície formal necessária para transformar uma reconstrução estrutural candidata de uma parte em decisões rastreáveis `confirmed/corrected/rejected`, sem apagar o snapshot candidato, sem persistir texto integral novamente e sem antecipar C.5?

## 2. Inspeção read-only da superfície existente

| Responsabilidade C.4 | Já comprovada? | Gap real mínimo |
|---|---|---|
| confirmar/corrigir árvore preliminar | parcial | decisão formal sobre elementos/relações candidatos |
| segmentar por fronteira editorial | sim | nenhum; reutilizar `CartographicPartScope` |
| classificar elementos por função | parcial | permitir correção explícita de tipo/parentalidade |
| reconciliar Sumário/título/corpo | sim/parcial | registrar a decisão apoiada na evidência já produzida |
| preservar dupla paginação | sim | nenhum; não duplicar mecanismo |
| produzir mapa revisável | parcial | overlay pequeno de decisões sobre snapshot candidato |

A inspeção não demonstrou necessidade de novo parser, OCR, provider, persistência hospedada ou alteração do contrato candidato `PartReconstructionCandidateSnapshot@1.0.0`.

## 3. Decisão arquitetônica mínima

O snapshot candidato permanece imutável e histórico.

C.4 mínimo acrescenta um contrato separado de revisão estrutural `1.0.0` que referencia:

- `candidateSnapshotId`;
- alvo (`element` ou `relation`);
- disposição `confirmed`, `corrected` ou `rejected`;
- justificativa obrigatória;
- evidência pertencente ao próprio alvo;
- correção opcional somente quando a disposição for `corrected`.

O resultado é um **overlay de revisão**, não uma cópia integral da parte.

Consequências desejadas:

1. nenhuma confirmação sem evidência;
2. nenhuma evidência de outro alvo pode ser reutilizada silenciosamente;
3. `confirmed` e `rejected` não carregam mutações;
4. `corrected` precisa explicitar ao menos uma correção;
5. o candidato original permanece disponível para auditoria;
6. o contrato de reconstrução candidato `1.0.0` não é quebrado.

## 4. Superfície implementada

- `packages/types/src/knowledge-factory/reconstruction-review.ts`;
- `PartStructuralReviewService`;
- exportações públicas mínimas;
- teste sintético dedicado cobrindo confirmação, correção, rejeição e falhas por evidência inválida.

## 5. O que esta entrega ainda não afirma

Esta entrega não afirma que C.4 inteiro está concluído.

Ainda precisa ser provado, antes de integração final do lote:

1. o overlay sobre a **mesma parte real já governada** do piloto (`Evolucionismo social`);
2. que a confirmação preserva localizadores e dupla paginação vindos do snapshot candidato;
3. que uma correção negativa sintética não altera retroativamente o candidato;
4. que todas as regressões anteriores permanecem verdes.

## 6. Critérios de aceite desta fronteira

1. candidato não é mutado;
2. toda decisão tem revisor, justificativa e evidência;
3. evidência pertence ao alvo decidido;
4. confirmação/correção/rejeição são distinguíveis;
5. correção de elemento não pode alterar campos de relação e vice-versa;
6. não há leitura adicional do PDF para decidir o overlay;
7. não há texto integral duplicado no contrato de revisão;
8. não há dependência de editora/coleção;
9. C.5, embeddings, corpus, RAG e grafo global permanecem fora do escopo.

## 7. Próximo gate

Executar a suíte remota aplicável e, em workspace local com o PDF privado governado, aplicar a revisão estrutural sobre o `PartReconstructionCandidateSnapshot` da seção real já usada no PR #125.

Nenhuma segunda obra deve ser aberta para esta prova.
