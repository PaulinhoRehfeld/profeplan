# ProfePlan Knowledge Factory — Current State

**Status:** continuidade operacional resumida
**Data de referência:** 19 de agosto de 2026
**Baseline:** `main@d3fd27e2ea8f65b1e47fb27416814e89be5486e5`
**Checkpoint de referência:** `CONTINUITY-CHECKPOINT-053.md`

## 1. Propósito

A ProfePlan Knowledge Factory é a frente responsável por transformar fontes curriculares, pedagógicas e bibliográficas em conhecimento estruturado, rastreável e recuperável para agentes especializados.

A arquitetura atual rejeita a ideia de tratar uma obra inteira como uma unidade semântica única.

Princípio operacional vigente:

> O livro é um contêiner editorial. A estrutura determina os recortes; chunks não determinam a estrutura.

Fluxo conceitual:

`cartografia → reconstrução local por parte → relações entre partes → estruturas derivadas → chunks/embeddings quando autorizados e necessários`

## 2. Linha canônica

A `main` atual integra o PR #125, que reconciliou o primeiro piloto real de uma única parte após divergências entre linhas anteriores.

Os PRs #118 e #124 são históricos/superseded e não devem ser usados como cabeças de integração.

A fonte operacional detalhada é:

`docs/profeplan-knowledge-factory/00-governance/CONTINUITY-CHECKPOINT-053.md`

## 3. O que já foi demonstrado

A frente já possui:

- lifecycle de fontes governado;
- ingestão controlada e estados definidos;
- contratos provider-neutral em áreas relevantes;
- integridade/checksum e evidências;
- revisão humana em gates definidos;
- cartografia preliminar;
- reconhecimento estrutural;
- reconstrução local por parte;
- duas provas verticais sintéticas integradas;
- preparação e reconciliação do primeiro piloto real sobre obra editorial verdadeira.

## 4. Artefato real governado no piloto

Obra utilizada no piloto:

- `Do seu jeito — Sociologia`;
- Editora Ática / SOMOS Educação;
- 1ª edição observada, 2024;
- Ensino Médio;
- volume único;
- Manual do Professor;
- PNLD 2026–2029;
- 449 páginas físicas.

O PDF permanece fora do Git.

A integridade do binário é governada por SHA-256 registrado no checkpoint específico. Agentes devem consultar a fonte canônica em vez de copiar o valor para novos documentos sem necessidade.

## 5. Parte única selecionada

A parte governada para reconstrução profunda é:

```text
Unidade 1 — Antropologia
└── Capítulo 1 — O pensamento antropológico
    └── Evolucionismo social
```

Escopo profundo estabelecido:

- páginas físicas 34–35;
- páginas impressas 33–34;
- próximo irmão cartográfico: `Trabalhando com quadrinhos`, física 36 / impressa 35.

## 6. Descoberta material relevante

A inspeção real observou fragmentação técnica de entradas do Sumário em múltiplos objetos textuais consecutivos.

A resposta arquitetônica aprovada foi uma pequena generalização do `StructuralRecognitionService` para recompor a entrada lógica antes da classificação.

Isso foi classificado como generalização localizada, não como justificativa para:

- redesenho amplo;
- OCR geral;
- novo provider;
- ontologia maior;
- processamento semântico da obra inteira.

## 7. Fronteiras preservadas

Permanecem preservados, conforme checkpoint corrente:

- contratos estruturais/reconstrução `1.0.0`;
- `PdfJsDocumentInspectorAdapter`;
- `PartReconstructionService`;
- ontologia estrutural vigente;
- limites entre as fases posteriores.

Elementos reconstruídos permanecem candidatos/evidências enquanto não houver gate específico de confirmação canônica.

## 8. Estado do roadmap do piloto real

Segundo o Checkpoint 053:

- Etapa 0 — 12/12 concluída;
- Etapa 1 — 4/4 concluída;
- Etapa 2 — parte selecionada, generalização mínima e teste preparados;
- execução material local da Etapa 2 — pendente;
- Etapas 3–5 — bloqueadas pelo resultado material dessa execução.

## 9. Próximo gate material

O próximo trabalho relevante não é criar mais infraestrutura ou documentação da Knowledge Factory.

É executar localmente o teste dedicado usando o PDF privado governado e o workspace com dependências instaladas.

Sequência resumida:

1. validar a integridade do PDF local;
2. apontar `PROFEPLAN_REAL_PILOT_PDF` para o arquivo governado;
3. executar o teste real dedicado;
4. registrar o resultado exato;
5. se verde, auditar seletividade, paginação física/impressa, hierarquia e evidências;
6. se houver divergência, classificar a primeira divergência antes de alterar arquitetura.

CI remoto sem o PDF não substitui esse gate.

## 10. Escopo negativo corrente

Não avançar, apenas por conveniência, para:

- PDF no Git;
- obra inteira em contexto semântico;
- segunda obra antes do gate atual;
- OCR geral;
- corpus/chunks em escala;
- embeddings/retrieval/RAG;
- grafo global;
- Storage hospedado para o piloto;
- runtime multiagente amplo;
- produção.

## 11. Fontes que devem ser lidas antes de trabalhar nesta frente

No mínimo:

- `docs/profeplan-knowledge-factory/BLUEPRINT.md`;
- `docs/profeplan-knowledge-factory/00-governance/CONTINUITY-CHECKPOINT-053.md`;
- `docs/profeplan-knowledge-factory/00-governance/RISK-PROPORTIONAL-EXECUTION-GOVERNANCE.md`;
- `docs/profeplan-knowledge-factory/12-delivery/REAL-PILOT-EXECUTION-ROADMAP.md`;
- contratos e provas específicos afetados pela tarefa.

## 12. Regra de continuidade

Quando este resumo divergir de um checkpoint posterior, o checkpoint posterior prevalece e este arquivo deve ser atualizado apenas se a divergência for material para continuidade geral.
