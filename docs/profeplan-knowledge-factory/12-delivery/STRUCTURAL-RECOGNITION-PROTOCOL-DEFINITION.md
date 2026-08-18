# Protocolo de Reconhecimento Estrutural da Obra

Data: 18 de agosto de 2026.

Base: `main@ce8229ea8f05f1c550979fc268007390e3c19ab9`.

Referências:

- `BLUEPRINT.md`;
- `PHASE-C-VERTICAL-CARTOGRAPHY-RECONCILIATION.md`;
- `PHASE-C-KNOWLEDGE-CARTOGRAPHY-ACTION-PLAN.md`;
- `LOT-C3-EXTRACTION-AND-VALIDATION-DEFINITION.md`.

## 1. Objetivo

Definir a menor superfície contratual necessária para uma obra ser **reconhecida e cartografada preliminarmente antes do processamento semântico aprofundado**.

O protocolo responde:

> Que documento parece ser este, quais regiões e divisões editoriais foram observadas ou inferidas, em quais páginas elas parecem ocorrer e qual parte deverá ser processada a seguir?

Ele não responde:

- qual hierarquia editorial está canonicamente confirmada;
- o significado pedagógico dos trechos;
- quais conceitos ou relações são verdadeiros;
- qual vínculo curricular é validado;
- qual conteúdo está pronto para retrieval.

Essas autoridades permanecem em C.4–C.7.

## 2. Princípio de desenho

> **Cartografia preliminar é hipótese operacional rastreável, não conhecimento canônico.**

O contrato deve ser pequeno o suficiente para não antecipar C.4 e rico o suficiente para impedir processamento cego do livro inteiro.

## 3. Reuso obrigatório de contratos existentes

O protocolo não duplicará a paginação já existente em C.3.

`ExtractionPageRef` permanece a referência mínima de página:

```text
physicalPageNumber
printedPageLabel?
```

O protocolo também reutiliza `IngestionSourceVersionRef` para apontar para a versão governada da fonte.

Não alterar `EXTRACTION_CONTRACT_VERSION` nesta fatia.

## 4. Filename como hint transitório

O nome original do arquivo ainda não integra o handoff C.2/C.3. Reabrir C.2 apenas para isso seria prematuro.

Nesta fatia, o reconhecimento aceita zero ou mais `FilenameHint` produzidos externamente ou por futuro analisador de filename.

Um hint contém:

- identificador;
- tipo candidato;
- token bruto observado;
- valor interpretado;
- confiança.

Tipos iniciais:

- coleção;
- componente escolar/disciplina;
- designação de volume;
- papel da manifestação (`livro do estudante`, `manual do professor` etc.);
- ciclo/programa editorial;
- outro.

Nenhum hint se torna identidade canônica por sua presença.

## 5. Metadados observados

Informações encontradas dentro do documento são registradas como `DocumentMetadataObservation`.

Tipos iniciais:

- título;
- coleção;
- componente escolar;
- autoria;
- editora;
- edição;
- ISBN;
- volume;
- papel da manifestação;
- programa/ciclo editorial;
- outro.

Cada observação deve apontar para evidência e confiança.

Esta fatia não cria `canonical_metadata`; a reconciliação canônica futura poderá comparar hints, observações e identidade bibliográfica governada.

## 6. Evidência cartográfica

Toda hipótese relevante deve ser rastreável a uma origem.

Fontes candidatas iniciais:

- `filename`;
- `pdf_page_label`;
- `page_text`;
- `table_of_contents`;
- `work_organization`;
- `pdf_bookmark`;
- `human_review`.

Uma evidência poderá referenciar página e `logicalLocator` quando aplicável.

## 7. Regiões informacionais candidatas

Antes de estruturar capítulos, o protocolo poderá identificar regiões amplas:

- capa;
- folha de rosto;
- ficha catalográfica;
- créditos/expediente;
- apresentação;
- organização da obra;
- sumário/índice;
- paratexto curricular;
- conteúdo principal;
- Manual do Professor;
- referências;
- glossário/índice remissivo;
- anexos;
- desconhecida.

Uma região é candidata e possui faixa física, evidência e confiança.

## 8. Nós estruturais candidatos

A árvore preliminar usará somente tipos editoriais amplos:

- parte;
- unidade;
- capítulo;
- seção;
- subseção;
- outro.

Cada nó poderá registrar:

- identificador;
- tipo;
- título observado;
- parent candidato;
- página inicial candidata;
- página final candidata;
- página impressa declarada pelo sumário quando ainda não reconciliada;
- evidências;
- confiança;
- estado de hipótese.

Estados iniciais:

- `candidate`;
- `reviewed_candidate`;
- `rejected`.

Não existe estado `confirmed` neste contrato. Confirmação estrutural é autoridade de C.4.

## 9. Cobertura de inspeção

O snapshot deve informar quais faixas físicas foram efetivamente inspecionadas.

Isso impede que o sistema confunda:

> “não encontrei”

com:

> “não olhei”.

O contrato admite:

- total de páginas físicas conhecido quando disponível;
- uma ou mais faixas inspecionadas;
- warnings explícitos.

## 10. Snapshot preliminar

`StructuralRecognitionSnapshot` representa uma fotografia versionada da hipótese cartográfica.

Contém:

- versão contratual;
- snapshot id;
- source version;
- hash do artefato;
- timestamp;
- filename hints;
- observações de metadados;
- regiões candidatas;
- nós estruturais candidatos;
- faixas inspecionadas;
- total físico de páginas quando conhecido;
- warnings.

Ele não contém chunks, embeddings, conceitos, BNCC validada ou componentes.

## 11. Escopo de parte

A saída operacional mais importante é `CartographicPartScope`.

Ele delimita **qual parte deverá ser processada a seguir**, sem afirmar que a hierarquia é canônica.

Deve conter:

- scope id;
- snapshot de origem;
- nó raiz candidato quando aplicável;
- faixa física inclusiva;
- motivo da delimitação;
- confiança.

Motivos iniciais:

- fronteira declarada no sumário;
- fronteira observada na organização da obra;
- heading observado no corpo;
- marcador PDF;
- decisão humana.

## 12. Invariantes mínimas

1. `physicalPageNumber`, início e fim de faixas são inteiros positivos.
2. `endPhysicalPage >= startPhysicalPage`.
3. confidence deve estar no intervalo fechado `[0,1]` quando validada por serviço futuro.
4. ids e títulos/valores obrigatórios não podem ser vazios.
5. um `CartographicPartScope` não pode apontar para faixa fora do documento quando `totalPhysicalPages` for conhecido.
6. filename hint não pode ser promovido implicitamente a metadado canônico.
7. nó `reviewed_candidate` continua candidato; revisão não equivale à confirmação C.4.
8. ausência de inspeção de uma faixa não pode ser registrada como ausência de conteúdo.
9. evidência C.3 existente deve ser reutilizada quando a hipótese deriva de texto/página já observados.
10. nenhum tipo deste contrato carrega provider, bucket, URL assinada, OCR, embedding ou modelo LLM.

## 13. Estratégia de leitura futura

O PDF.js atual percorre todas as páginas e o serviço C.3.3 exige sequência completa 1..N. Essa implementação continuará válida para extração integral física quando necessária.

O protocolo de reconhecimento, porém, deverá permitir no próximo passo uma estratégia de **inspeção incremental/janelada**, por exemplo:

```text
1. inspecionar primeiras páginas
2. procurar organização/sumário
3. ampliar janela se estrutura ainda não estiver clara
4. inspecionar página alvo indicada pelo sumário quando necessário
5. gerar mapa preliminar
6. selecionar uma parte
```

Não alterar o parser nesta fatia contratual.

## 14. Golden sample seguinte

Após este contrato, criar fixture PDF sintética contendo:

- filename informativo;
- capa;
- ficha;
- organização da obra;
- sumário;
- deslocamento entre página física e impressa;
- uma Introdução;
- títulos/subtítulos;
- visual sintético com legenda;
- atividade;
- orientação docente relacionada;
- declaração curricular sintética;
- região final de Manual do Professor.

A primeira prova deverá selecionar e aprofundar somente `Introdução`.

## 15. Escopo negativo

Esta fatia não inclui:

- migration/tabela/RPC;
- persistência nova;
- alteração de C.2;
- alteração de `EXTRACTION_CONTRACT_VERSION`;
- parser novo;
- leitura janelada concreta;
- conteúdo real;
- PNLD real;
- OCR;
- modelo multimodal;
- C.4 canônico;
- grafo conceitual;
- BNCC validada;
- embeddings/retrieval;
- produção.

## 16. Gate

Esta fatia está pronta quando:

- tipos provider-neutral estão exportados em `@profeplan/types`;
- testes provam o vocabulário e a separação entre hipótese e confirmação;
- `ExtractionPageRef` é reutilizado;
- não há dependência de parser/provider/banco;
- CI principal está verde;
- o próximo passo fica inequívoco: golden sample + inspeção incremental.
