# CONTINUITY CHECKPOINT 052 — piloto real reconciliado; execução material local é o próximo gate

Data: 19 de agosto de 2026.

## 1. Estado canônico de origem

Base de reconciliação: `main@e0bf5c2fa5914b6e4e8eee058c989aec7f84f848`.

Marcos imediatamente anteriores:

- PR #117 integrou o fechamento da segunda prova vertical sintética;
- PRs #119–#123 definiram e preencheram progressivamente a fronteira jurídica/operacional e prepararam a pasta local do Livro 0;
- PR #118 continha a primeira implementação material do piloto real, mas divergiu da `main` após a sequência documental posterior;
- PR #124 repetiu a identificação/cartografia local do Livro 0, mas introduziu divergências documentais e tratou a seleção da parte como ainda pendente.

## 2. Reconciliação executada

A linha canônica candidata passa a ser o PR #125, branch:

`feat/knowledge-factory-real-pilot-reconciliation-v2`

Ele reaplica sobre a `main` atual somente os elementos materiais válidos do PR #118 e reconcilia a documentação dos PRs #119–#124.

PRs #118 e #124 foram fechados sem merge e preservados como evidência histórica. Nenhum deles deve ser integrado independentemente.

## 3. Artefato real governado

- obra: `Do seu jeito — Sociologia`;
- editora: Ática (SOMOS Educação);
- edição observada: 1ª edição, São Paulo, 2024;
- etapa: Ensino Médio;
- área: Ciências Humanas e Sociais Aplicadas;
- volume: único;
- manifestação: Manual do Professor;
- ciclo: PNLD 2026–2029;
- código: `0113P260101204816`;
- arquivo de trabalho: `DOSEUJEITO_PNLD26_SOCIOLOGIA_VU_MP.pdf`;
- total físico: 449 páginas;
- SHA-256 governado: `1e7f8d613fdb43a49d4a1f0a031465784b03b31b1d22e1779d279365ad82e39a`.

O PDF permanece fora do Git.

## 4. Parte única governada

```text
Unidade 1 — Antropologia
└── Capítulo 1 — O pensamento antropológico
    └── Evolucionismo social
```

Escopo profundo:

- físicas 34–35;
- impressas 33–34;
- próximo irmão cartográfico: `Trabalhando com quadrinhos`, física 36 / impressa 35.

A escolha da parte não está mais pendente.

## 5. Evidência real já observada

A inspeção anterior do mesmo binário governado confirmou:

- SHA-256 e 449 páginas físicas;
- `PDF PageLabels` coerentes com a dupla paginação;
- Sumário nas físicas 7–9;
- Unidade 1 física 29 / impressa 28;
- Capítulo 1 física 31 / impressa 30;
- seção escolhida física 34 / impressa 33;
- fragmentação técnica de entradas do Sumário em múltiplos objetos textuais consecutivos.

Essa fragmentação foi classificada como **Resultado B — pequena generalização**, não como necessidade de redesenho, OCR ou novo provider.

## 6. Alteração técnica mínima reaplicada

Somente `StructuralRecognitionService` é generalizado para recompor a entrada lógica do Sumário a partir de fragmentos consecutivos antes da classificação.

Permanecem inalterados:

- contratos `1.0.0`;
- `PdfJsDocumentInspectorAdapter`;
- `PartReconstructionService`;
- ontologia estrutural;
- persistência;
- providers;
- fronteiras C.5–C.7.

Foi reaplicado o teste dedicado `real-single-part-vertical-reconstruction.test.mjs`, condicionado a `PROFEPLAN_REAL_PILOT_PDF` e ao SHA-256 governado.

## 7. Estado do roadmap

- Etapa 0 — **12/12 concluída**;
- Etapa 1 — **4/4 concluída**;
- Etapa 2 — parte selecionada, generalização mínima e teste preparados; **execução material local ainda pendente**;
- Etapas 3–5 — bloqueadas pelo resultado material da Etapa 2.

## 8. Próximo gate material

O próximo avanço não é nova documentação, nova parte, outra obra, OCR, embeddings ou corpus.

É executar, no workspace local que contém as dependências do repositório e o PDF privado:

1. validar o SHA-256 do arquivo local;
2. apontar `PROFEPLAN_REAL_PILOT_PDF` para o PDF governado;
3. executar o teste real dedicado;
4. registrar o resultado exato;
5. se verde, auditar seletividade, dupla paginação, hierarquia e evidências;
6. se houver divergência, classificar a primeira divergência antes de qualquer nova alteração.

CI remoto sem o PDF não substitui esse gate.

## 9. Escopo negativo preservado

Sem:

- PDF no Git;
- obra inteira como contexto semântico;
- outra obra/coleção;
- OCR geral;
- corpus/chunks;
- embeddings/retrieval/RAG;
- grafo global;
- Supabase/Storage hospedado;
- runtime multiagente;
- produção.

## 10. Regra de continuidade

Ao retomar a execução, considerar este checkpoint e o PR #125 como linha de continuidade. PRs #118 e #124 são históricos/superseded e não devem ser usados como cabeças de integração.
