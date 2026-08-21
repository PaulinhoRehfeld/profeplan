# CONTINUITY CHECKPOINT 055 — C.4 mínimo implementado; prova material real pendente

Data: 21 de agosto de 2026.

## 1. Estado canônico de origem

Base: `main@d3fd27e2ea8f65b1e47fb27416814e89be5486e5`, resultante do squash do PR #125.

Marco anterior:

- primeiro piloto real governado classificado VERDE;
- 132/132 testes locais aprovados no piloto;
- cartografia seletiva, dupla paginação, hierarquia e reconstrução profunda limitada às físicas 34–35 comprovadas;
- próxima entrada formal autorizada: C.4 mínimo `candidate → confirmed/corrected/rejected`.

## 2. Branch e PR correntes

Branch:

`feat/knowledge-factory-c4-minimal-structural-review`

Draft PR:

`#132 — feat(knowledge-factory): add minimal C.4 structural review boundary`

## 3. Gap material confirmado

A inspeção read-only demonstrou que a superfície C.4-local já comprovada cobre:

- `CartographicPartScope`;
- reconstrução local;
- evidências/localizadores;
- dupla paginação;
- ancestralidade e relações locais.

O gap mínimo não exige redesenho estrutural. Ele está concentrado na decisão editorial formal e auditável sobre candidatos.

## 4. Implementação C.4 mínima

Foi acrescentado um overlay de revisão estrutural separado do snapshot candidato:

- contrato `PartStructuralReviewSnapshot@1.0.0`;
- decisões `confirmed`, `corrected`, `rejected`;
- revisor e justificativa obrigatórios;
- evidência obrigatória pertencente ao próprio alvo;
- correções somente em decisões `corrected`;
- candidato original preservado e não mutado;
- nenhum texto integral duplicado no overlay;
- nenhuma nova leitura do PDF pelo serviço de revisão.

O contrato `PartReconstructionCandidateSnapshot@1.0.0` permanece inalterado.

## 5. Provas sintéticas preparadas

O teste dedicado cobre:

1. confirmação;
2. correção negativa de classificação estrutural;
3. rejeição;
4. ausência de evidência;
5. evidência pertencente a outro alvo;
6. correção indevida em decisão `confirmed`;
7. preservação do snapshot candidato.

## 6. Encadeamento com o piloto real

O teste real existente do Livro 0 foi estendido para, após a mesma reconstrução governada de:

```text
Unidade 1 — Antropologia
└── Capítulo 1 — O pensamento antropológico
    └── Evolucionismo social
```

aplicar `PartStructuralReviewService` ao `part_title` real reconstruído.

A prova material, quando executada com `PROFEPLAN_REAL_PILOT_PDF`, deverá confirmar simultaneamente:

- C.4 referencia o mesmo `PartReconstructionCandidateSnapshot`;
- a decisão real é `confirmed`;
- a evidência da confirmação permanece nas físicas 34–35;
- o snapshot candidato é byte-a-byte equivalente antes/depois da revisão via serialização determinística usada no teste;
- nenhuma inspeção adicional do PDF ocorre durante C.4.

## 7. Estado dos gates

- implementação C.4 mínima: **concluída na branch**;
- testes sintéticos: **implementados; aguardando execução/check remoto aplicável**;
- encadeamento do teste real: **implementado**;
- execução material com PDF privado: **pendente**;
- revisão humana final: **pendente**;
- integração: **bloqueada até os gates acima**.

## 8. Escopo negativo preservado

Sem:

- segunda obra;
- PDF no Git;
- OCR geral;
- novo parser/provider;
- corpus/chunks;
- embeddings/retrieval/RAG;
- grafo global;
- C.5–C.7;
- Supabase/Storage hospedado de conteúdo;
- runtime multiagente;
- produção.

## 9. Próximo gate material

Executar a suíte da branch em workspace com dependências e, para o teste real, com o mesmo PDF privado governado do PR #125.

Se a suíte e a prova real forem verdes, registrar o resultado e submeter o PR #132 à revisão humana final. Se houver divergência, classificar a primeira divergência antes de ampliar a arquitetura.
