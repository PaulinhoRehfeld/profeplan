# C.5 mínimo — contribuição candidata rastreável

Data: 21 de agosto de 2026.

Base de origem: `main@3967134aa40cc9852e7a5e9496f458012f562ebb` (PR #132 integrado).

## 1. Pergunta material

> Qual é a menor superfície de C.5 capaz de transformar elementos estruturalmente confirmados de uma parte em uma contribuição de conhecimento candidata, autoral e rastreável, sem promover ainda componente pedagógico canônico, relação global ou corpus?

## 2. Decisão de fronteira

C.5 mínimo não cria `PedagogicalComponent`.

Ele cria somente `KnowledgeContributionCandidate@1.0.0`, com:

- estado exclusivamente `candidate`;
- tipo `conceptual`, `contextual` ou `methodological`;
- enunciado autoral curto;
- referência ao snapshot C.4 que confirmou a estrutura;
- referência ao snapshot candidato de reconstrução;
- IDs dos elementos-fonte confirmados;
- evidências herdadas desses elementos;
- data de criação.

A contribuição candidata não possui `canonicalKey`, status aprovado, vínculo curricular, embedding, relação global ou autoridade de produção.

## 3. Gate C.4 → C.5

Uma proposta C.5 somente é elegível quando:

1. o `PartStructuralReviewSnapshot` pertence ao mesmo `PartReconstructionCandidateSnapshot`;
2. todos os elementos-fonte existem no snapshot candidato;
3. todos os elementos-fonte foram explicitamente `confirmed` por C.4;
4. há evidência rastreável nesses elementos;
5. o enunciado proposto não é cópia textual exata de um elemento-fonte.

A proteção contra cópia exata é um limite mínimo, não uma avaliação completa de qualidade autoral ou similaridade semântica.

## 4. C.5.1 — contrato mínimo

Foi introduzido um contrato separado de contribuição candidata.

Ele reutiliza a linguagem de contribuição já presente posteriormente em `EvidenceOrigin` (`conceptual`, `contextual`, `methodological`) sem antecipar a criação de componentes pedagógicos.

`curricular` fica fora desta primeira superfície porque alinhamento curricular pertence a responsabilidades posteriores e gates próprios.

## 5. C.5.2 — prova sintética

A prova sintética demonstra que:

- um elemento de corpo confirmado pode sustentar contribuição candidata;
- a contribuição preserva procedência e evidência;
- o enunciado candidato é distinto do texto observado;
- cópia textual exata é rejeitada;
- elemento estrutural não confirmado não pode sustentar contribuição C.5.

A destilação nesta etapa é uma fronteira de validação/assemblagem de uma proposta autoral; ela não pressupõe ainda um modelo LLM específico.

## 6. C.5.3 — mesma parte real governada

A prova real reutiliza exclusivamente:

```text
Unidade 1 — Antropologia
└── Capítulo 1 — O pensamento antropológico
    └── Evolucionismo social
```

Escopo profundo permanece:

- física 34–35;
- impressa 33–34.

O teste:

1. valida o mesmo SHA-256 governado;
2. cartografa a seção;
3. reconstrói somente físicas 34–35;
4. confirma estruturalmente o título e um elemento de corpo;
5. produz uma única contribuição `contextual` candidata;
6. prova que a evidência permanece dentro de 34–35;
7. prova que o enunciado não é cópia exata do texto-fonte;
8. prova que C.5 não dispara nova inspeção do PDF.

A contribuição real inicial é deliberadamente conservadora:

> `A seção confirmada apresenta conteúdo expositivo sobre evolucionismo social.`

Ela prova a cadeia de procedência C.3 → C.4 → C.5 sem inventar afirmações conceituais sobre o conteúdo privado que não foi inspecionado nesta execução remota.

## 7. O que ainda não foi aberto

Permanecem fora de escopo:

- relações entre contribuições;
- consenso, complementaridade ou divergência;
- deduplicação;
- ontologia canônica;
- `PedagogicalComponent`;
- C.6 e C.7;
- currículo/BNCC;
- embeddings;
- retrieval/RAG;
- grafo global;
- segunda obra;
- produção.

## 8. Critérios de aceite

1. nenhuma contribuição nasce de elemento estrutural não confirmado;
2. toda contribuição possui evidência herdada de elementos-fonte;
3. evidência mantém página/localizador original;
4. contribuição permanece `candidate`;
5. contrato C.4 não é alterado;
6. contrato de `PedagogicalComponent` não é alterado;
7. contribuição não duplica texto integral observado;
8. a prova real permanece limitada à mesma parte governada;
9. C.5 não reabre o PDF após a reconstrução;
10. regressões anteriores permanecem verdes.

## 9. Próximo gate

Executar a suíte aplicável e, no workspace local que contém o PDF privado governado, executar também `real-single-part-contribution.test.mjs` com `PROFEPLAN_REAL_PILOT_PDF`.

Somente após esse gate será elegível discutir a próxima capacidade de C.5, provavelmente relações entre duas contribuições. Deduplicação e controvérsia não devem ser implementadas antes de existir evidência material que as exercite.
