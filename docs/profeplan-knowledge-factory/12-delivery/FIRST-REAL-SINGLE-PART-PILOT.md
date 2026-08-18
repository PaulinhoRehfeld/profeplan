# Primeiro piloto real — reconstrução vertical de uma única parte

Data: 18 de agosto de 2026.

Base de abertura: `main@cfe7ad72701c57c5a38f39c0f1d539557f029a2f`.

## 1. Pergunta arquitetônica

Este piloto responde somente:

> O mecanismo `cartografia preliminar -> CartographicPartScope -> inspeção seletiva -> reconstrução candidata`, já comprovado em duas estruturas sintéticas, consegue reconstruir uma parte de um PDF editorial real preservando limites, dupla paginação, hierarquia e evidências sem transformar a obra inteira em contexto?

O piloto não inaugura corpus nem processamento em escala.

## 2. Artefato real autorizado

Obra delimitada para o ensaio:

- título: `Do seu jeito — Sociologia`;
- editora: Ática;
- componente: Sociologia;
- etapa: Ensino Médio;
- área: Ciências Humanas e Sociais Aplicadas;
- volume: único;
- manifestação: Manual do Professor;
- edição editorial observada: 1ª edição, São Paulo, 2024;
- ciclo declarado na obra: PNLD 2026–2029;
- código de coleção observado: `0113P260101204816`;
- nome canônico de trabalho para hints: `DOSEUJEITO_PNLD26_SOCIOLOGIA_VU_MP.pdf`;
- total físico observado: 449 páginas;
- SHA-256 do binário autorizado: `1e7f8d613fdb43a49d4a1f0a031465784b03b31b1d22e1779d279365ad82e39a`.

O nome do arquivo temporariamente montado pode conter sufixo local de cópia, como `(1)`. A identidade desta prova é fixada pelo digest e pela identidade bibliográfica, não por esse sufixo local.

A autorização desta prova é exclusivamente técnica e temporária. Ela não autoriza publicação, redistribuição, corpus, treinamento, indexação ou retenção permanente do PDF.

O binário protegido **não deve ser commitado** no repositório.

## 3. Cartografia real observada

A obra fornece informação editorial explícita útil antes de qualquer leitura profunda:

- `Conheça seu livro`: página física 5 / impressa 4;
- `Sumário`: começa na página física 7 / impressa 6;
- o Sumário continua por três páginas físicas, 7–9 / impressas 6–8;
- `Unidade 1 – Antropologia`: impressa 28 / física 29;
- `Capítulo 1 — O pensamento antropológico`: impressa 30 / física 31;
- `Evolucionismo social`: impressa 33 / física 34;
- próximo irmão cartográfico, `Trabalhando com quadrinhos`: impressa 35 / física 36.

O PDF possui `PDF PageLabels` coerentes com essa dupla paginação. Portanto, este artefato não demonstra necessidade de OCR para recuperar os labels impressos.

## 4. Parte escolhida

Escopo profundo único:

```text
Unidade 1 – Antropologia
└── Capítulo 1 — O pensamento antropológico
    └── Evolucionismo social

páginas físicas profundas: 34–35
páginas impressas: 33–34
```

Essa escolha é deliberadamente menor do que aprofundar toda a Unidade 1. A unidade é contêiner hierárquico cartografado; a seção é a parte operacional aprofundada neste piloto.

## 5. Primeira observação real

A primeira inspeção do binário real demonstrou uma diferença que o golden sample sintético não reproduzia.

Visualmente, uma entrada do Sumário é apresentada como:

```text
título editorial ........ página
```

No conteúdo nativo do PDF, porém, a mesma entrada pode estar dividida em vários objetos textuais consecutivos, por exemplo:

```text
título
pontilhado
página
```

Títulos maiores também podem ser fragmentados em mais de um objeto antes do pontilhado.

O parser cartográfico anterior aplicava o padrão de entrada a cada `text_block` isoladamente. Assim, exigia implicitamente que título, pontilhado e label estivessem no mesmo objeto PDF — uma simplificação verdadeira no fixture, mas falsa nesta obra real.

### Classificação preliminar

**Resultado B — pequena generalização.**

A informação necessária existe em texto nativo e os labels de página existem no próprio PDF. O problema observado não exige OCR e não demonstra insuficiência do modelo estrutural. A necessidade localizada é recompor uma entrada lógica do Sumário a partir de fragmentos textuais consecutivos antes de classificá-la.

## 6. Menor evolução aplicada

A evolução fica limitada a `StructuralRecognitionService`:

- acumular fragmentos textuais consecutivos dentro de cada página de Sumário;
- reconhecer a entrada quando o conjunto acumulado satisfizer `título + pontilhado + label`;
- limpar o acumulador ao encontrar cabeçalho de Sumário/Índice;
- preservar a compatibilidade com o golden sample, onde a entrada já chega inteira em um único `text_block`;
- não alterar `PdfJsDocumentInspectorAdapter`;
- não alterar contratos;
- não alterar `PartReconstructionService`;
- não adicionar OCR;
- não criar regra específica para `Do seu jeito`.

A Introdução real aparece no Sumário como cabeçalho sem label próprio antes de seu primeiro tópico. Esse fato fica registrado como observação real, mas não é necessário resolvê-lo para a seção escolhida e não amplia esta correção.

O Sumário real continua pela página física 9, enquanto a janela cartográfica atual usa a página do Sumário e a página seguinte. A parte escolhida e toda a sua cadeia hierárquica aparecem já na física 7, portanto ampliar a janela não é necessário para responder a esta prova e permanece fora desta correção.

## 7. Envelope operacional

### Entrada temporária

O teste lê o PDF somente a partir de:

```text
PROFEPLAN_REAL_PILOT_PDF
```

O digest governado desta prova está fixado no próprio teste. Opcionalmente, o operador também pode informar:

```text
PROFEPLAN_REAL_PILOT_SHA256
```

Se o binário montado não corresponder ao SHA-256 governado, a prova falha antes da cartografia.

### Retenção

Não reter:

- PDF bruto;
- cópia do livro;
- imagens extraídas;
- texto integral;
- corpus ou chunks.

Pode permanecer como evidência mínima:

- SHA-256;
- identidade bibliográfica;
- faixas físicas e labels impressos;
- estrutura candidata;
- tipos de elementos e relações;
- localizadores/evidências;
- warnings;
- classificação arquitetônica A/B/C/D;
- resultado dos testes sem reprodução extensa do conteúdo protegido.

### Descarte

O teste não cria cópia persistente nem artifact de CI e não faz upload do livro.

## 8. Critérios executáveis do piloto corrigido

A prova material deve demonstrar, no mínimo:

1. o binário possui SHA-256 exatamente igual ao digest governado;
2. o artefato possui 449 páginas físicas;
3. a cartografia encontra o `Sumário` incluindo a física 7;
4. a cartografia recompõe entradas fragmentadas sem regra específica da obra;
5. `Unidade 1 – Antropologia` começa na física 29 / impressa 28;
6. `Capítulo 1 — O pensamento antropológico` começa na física 31 / impressa 30 e permanece filho da Unidade 1;
7. `Evolucionismo social` permanece filho do Capítulo 1 e é delimitado nas físicas 34–35;
8. o início impresso da seção é `33`;
9. a reconstrução profunda usa somente `CartographicPartScope` 34–35;
10. as físicas 34–35 preservam labels impressos 33–34;
11. o título da seção é corroborado no corpo;
12. elementos e relações permanecem apoiados por evidência;
13. nós cartográficos permanecem somente em estados candidatos;
14. os contratos continuam em `1.0.0`;
15. as duas provas sintéticas continuam sem regressão.

## 9. Estado da execução

O binário verdadeiro foi disponibilizado temporariamente e inspecionado nesta etapa. Foram materialmente confirmados o SHA-256, a contagem de páginas, os `PDF PageLabels`, o Sumário e a fragmentação nativa das entradas.

A tentativa de executar o teste Node completo no runtime da conversa encontrou uma limitação operacional: o checkout/dependências do repositório não estavam montados e o runtime não conseguiu resolver GitHub/npm externamente. Isso não é tratado como sucesso do piloto.

Portanto, **não registrar a prova vertical como concluída ou verde até que o teste dedicado rode efetivamente com `PdfJsDocumentInspectorAdapter`, `StructuralRecognitionService` e `PartReconstructionService` contra este mesmo SHA-256**.

CI ordinário sem o PDF continua sendo apenas prova de integridade/regressão e mantém o teste real em `skip` por desenho.

## 10. Escopo negativo

Sem:

- commit ou publicação do PDF;
- obra inteira como contexto semântico;
- outra obra ou coleção;
- corpus;
- chunks;
- embeddings;
- retrieval/RAG;
- grafo global;
- validação semântica BNCC;
- OCR geral;
- interpretação multimodal geral;
- migration, RPC ou nova persistência;
- Supabase/Storage hospedado para o conteúdo;
- runtime multiagente;
- reabertura do PR nº 110;
- PR nº 99;
- produção.

## 11. Próxima decisão

Depois da validação de CI da pequena generalização:

1. montar novamente o mesmo binário temporário em runtime que possua as dependências do repositório;
2. executar o teste dedicado com o SHA governado;
3. registrar exatamente o primeiro resultado real;
4. se houver nova divergência, classificá-la antes de qualquer outra alteração;
5. se a prova ficar verde, auditar seletividade, regressões e copyright e parar antes do merge.
