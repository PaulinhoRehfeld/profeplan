# Segunda prova vertical — reconstrução da Unidade 1

Data: 18 de agosto de 2026.

Base canônica: `main@abe7997257ab0d832536a19a4431acf674a43783`.

## 1. Pergunta arquitetônica

A segunda prova responde a uma única pergunta:

> O mecanismo de cartografia + reconstrução local demonstrado na Introdução generaliza para uma parte editorial estruturalmente diferente sem virar uma coleção de regras específicas para a Introdução?

A unidade de trabalho continua sendo uma parte editorial delimitada, não o livro inteiro.

## 2. Parte escolhida

O golden sample sintético já contém a segunda parte adequada:

```text
Unidade 1 - Cultura e cotidiano
páginas físicas: 14–17
páginas impressas: 13–16
```

Dentro da unidade, a cartografia também declara:

```text
Capitulo 1 - Olhares sobre a cultura
início físico: 15
início impresso declarado: 14
parent: Unidade 1
```

A unidade termina na página física 17 porque a região `teacher_manual` começa na página física 18.

Nenhuma alteração do fixture foi necessária.

## 3. Diferenças reais em relação à Introdução

A primeira prova usava uma parte raiz `part` com seções, uma atividade, um visual/legenda e orientação docente direcionada.

A segunda parte possui uma hierarquia editorial diferente:

```text
unit
  -> chapter
     -> conteúdo que continua nas páginas seguintes
```

Essa diferença revelou dois acoplamentos que a prova da Introdução não exercitava:

1. o reconstrutor tratava todo nó cartográfico filho não-atividade como `section_heading`, descartando a declaração explícita `chapter` já presente na cartografia;
2. o heading corrente era reiniciado a cada página, impedindo que conteúdo continuado em uma nova página permanecesse subordinado ao capítulo aberto na página anterior.

## 4. Generalização mínima

A evolução deliberadamente pequena é:

- adicionar `chapter_heading` ao vocabulário candidato de reconstrução;
- derivar esse tipo somente quando o nó cartográfico correspondente já declara `kind === 'chapter'`;
- preservar o heading corrente entre páginas dentro do mesmo `CartographicPartScope` até que outra estrutura reconhecida o substitua.

Não foi criada heurística tipográfica ou semântica para headings não cartografados.

O inspector atual não expõe tamanho de fonte ou layout tipográfico no contrato de extração. Por isso, textos como `Texto do capitulo` e `Galeria de atividades` permanecem `body_text` subordinado ao capítulo nesta prova. Classificá-los de outra forma sem evidência adicional seria antecipar uma abstração.

## 5. Contrato

`PART_RECONSTRUCTION_CONTRACT_VERSION` permanece `1.0.0` nesta prova.

O envelope do snapshot não muda. A única evolução do vocabulário candidato é:

```text
chapter_heading
```

Essa decisão não cristaliza a ontologia integral de C.4 nem impede revisão de versionamento após a comparação das duas provas.

## 6. Leitura seletiva

A reconstrução da Unidade 1 deve inspecionar profundamente somente:

```text
14, 15, 16, 17
```

Ela não deve ler semanticamente:

```text
11, 12, 13, 18, 19
```

Como não existe atividade cartograficamente reconhecida na Unidade 1 nesta prova, não há motivo para consultar a região do Manual do Professor. A ausência dessa consulta também é um comportamento esperado.

## 7. Hierarquia esperada

A reconstrução deve preservar pelo menos:

```text
Unidade 1 - Cultura e cotidiano
  -> Capitulo 1 - Olhares sobre a cultura
     -> Conceitos iniciais do capitulo sintetico.
     -> Texto do capitulo
     -> Conteudo sintetico destinado somente ao teste.
     -> Galeria de atividades
     -> Atividades sinteticas de encerramento.
```

A prova não afirma que todos esses textos são ontologicamente equivalentes. Ela afirma apenas que, sem evidência estrutural adicional, eles permanecem conteúdo local subordinado ao capítulo explicitamente reconhecido.

## 8. Critérios executáveis

A segunda prova passa se:

1. a cartografia delimitar `Unidade 1 = físicas 14–17`;
2. a Unidade 1 preservar o rótulo impresso inicial `13`;
3. o Capítulo 1 for filho cartográfico da Unidade 1 e preservar o rótulo impresso inicial `14`;
4. a reconstrução inspecionar apenas as páginas 14–17;
5. `Unidade 1` for reconstruída como `part_title` do escopo local;
6. `Capitulo 1` for reconstruído como `chapter_heading` com evidência cartográfica;
7. a relação `contains` preservar `Unidade -> Capítulo`;
8. conteúdo das páginas 16–17 continuar subordinado ao capítulo iniciado na página 15;
9. não seja inventada atividade ou orientação docente apenas porque existe o texto `Galeria de atividades`;
10. a prova vertical da Introdução continue passando sem regressão.

## 9. Escopo negativo

Sem:

- alteração do golden sample;
- OCR;
- interpretação multimodal profunda;
- persistência, migration, RPC ou Supabase;
- embeddings ou retrieval;
- grafo global;
- BNCC validada;
- runtime multiagente;
- PR #110;
- PR #99;
- produção.

## 10. Leitura arquitetônica esperada

Se a prova ficar verde, o resultado se aproxima do **Resultado B — pequena generalização**:

- o mecanismo fundamental não está restrito à Introdução;
- a cartografia existente contém informação suficiente para distinguir `chapter`;
- a reconstrução precisava preservar essa informação explícita e manter contexto estrutural através de limites de página;
- não foi necessário redesenhar o serviço, ampliar o fixture ou criar uma ontologia grande.

A decisão seguinte deve ocorrer somente depois da execução e auditoria da prova.
