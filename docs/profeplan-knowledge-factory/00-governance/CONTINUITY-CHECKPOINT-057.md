# CONTINUITY CHECKPOINT 057 — C.5 mínimo implementado; gate real preparado

Data: 21 de agosto de 2026.

## 1. Estado canônico de origem

Base:

`main@3967134aa40cc9852e7a5e9496f458012f562ebb`

Esse commit integrou por squash o PR #132 e consolidou C.4 mínimo com gate material real aprovado, 136/136 testes locais e confirmação estrutural rastreável sobre a seção `Evolucionismo social`.

## 2. Próxima pergunta arquitetônica

Com C.4 mínimo integrado, a próxima lacuna material é:

> transformar uma parte estruturalmente confirmada em contribuição de conhecimento candidata, autoral e rastreável, sem criar ainda componente pedagógico canônico.

## 3. Branch corrente

`feat/knowledge-factory-c5-minimal-contribution-candidate`

## 4. Escopo aprovado

Foram autorizadas sem necessidade de novos gates intermediários:

- C.5.1 — contrato mínimo de contribuição candidata;
- C.5.2 — prova sintética de destilação autoral rastreável;
- C.5.3 — prova na mesma parte real governada.

## 5. Implementação

A branch introduz:

- `KnowledgeContributionCandidate@1.0.0`;
- `KnowledgeContributionService`;
- estado exclusivamente `candidate`;
- tipos iniciais `conceptual`, `contextual`, `methodological`;
- vínculo obrigatório ao snapshot C.4 e ao snapshot de reconstrução;
- elementos-fonte obrigatoriamente confirmados em C.4;
- herança de evidências dos elementos-fonte;
- rejeição de cópia textual exata como contribuição destilada;
- nenhuma criação direta de `PedagogicalComponent`.

## 6. Prova sintética

O teste sintético cobre:

1. criação de contribuição autoral candidata a partir de corpo confirmado;
2. procedência até evidência de página/localizador;
3. rejeição de cópia textual exata;
4. rejeição de elemento-fonte não confirmado.

## 7. Prova real preparada

Foi preparado `real-single-part-contribution.test.mjs` para o mesmo PDF e a mesma parte real governada:

```text
Unidade 1 — Antropologia
└── Capítulo 1 — O pensamento antropológico
    └── Evolucionismo social
```

A prova mantém profundas apenas as físicas 34–35, confirma C.4 para título + primeiro elemento de corpo e produz uma contribuição `contextual` mínima, sem inventar afirmação conceitual não observada remotamente.

O arquivo privado permanece fora do Git e a execução material depende de `PROFEPLAN_REAL_PILOT_PDF` no workspace local.

## 8. Escopo negativo

Sem:

- relações C.5 entre contribuições;
- consenso/complementaridade/divergência;
- deduplicação;
- C.6/C.7;
- currículo/BNCC;
- embeddings/RAG;
- grafo global;
- segunda obra;
- produção.

## 9. Próximo gate

1. abrir Draft PR;
2. executar CI remoto aplicável;
3. corrigir somente divergências materiais observadas;
4. executar a prova real local com o mesmo PDF governado;
5. registrar resultado e submeter à revisão humana antes de integração.
