# Prova vertical — reconstrução da Introdução

Data: 18 de agosto de 2026.

Base: `main@f4bf8c38b8bb347fe49afca35ec010fb1db44a2d`.

## 1. Objetivo

Provar a primeira travessia vertical do caminho principal depois da cartografia preliminar:

```text
golden sample sintético
  -> cartografia preliminar
  -> CartographicPartScope = Introdução
  -> extração somente da parte
  -> reconstrução estrutural candidata
  -> relação visual/legenda
  -> atividade
  -> orientação docente correspondente
```

A prova não tenta compreender o livro inteiro nem criar conhecimento pedagógico canônico.

## 2. Unidade de trabalho

A cartografia integrada pelo PR nº 113 delimita:

```text
Introdução
páginas físicas: 11–13
páginas impressas: 10–12
```

A próxima unidade editorial começa na página física 14.

O Manual do Professor está cartografado em região separada, na página física 18 do golden sample.

## 3. Autoridade desta prova

Esta fatia inicia uma superfície **C.4-local candidata**.

Ela pode reconstruir e classificar candidatos a:

- título da parte;
- heading de seção;
- texto expositivo;
- atividade e comando;
- marcador visual físico já observado por C.3;
- legenda;
- heading/texto de orientação docente;
- relações estruturais entre esses elementos.

Ela não pode criar como verdade canônica:

- conceitos;
- teorias;
- relações conceituais globais;
- alinhamento BNCC validado;
- componente pedagógico final;
- embedding;
- elegibilidade para retrieval.

## 4. Marcador visual

O golden sample passa a conter um pequeno XObject de imagem inteiramente sintético na página física 12.

O `PdfJsDocumentInspectorAdapter` usa a operator list pública do PDF.js somente para registrar que uma imagem foi fisicamente observada, produzindo `image_marker`.

Nesta prova:

- o conteúdo da imagem não é interpretado;
- não há OCR;
- não há modelo multimodal;
- não há retenção de imagem extraída;
- C.4 recebe somente o marcador lógico e a legenda textual.

Isso permite provar a relação `caption_for_visual` sem antecipar C.3.7.

## 5. Relação com Manual do Professor

O processamento principal lê apenas as páginas 11–13.

Como a cartografia já identificou uma região `teacher_manual`, a prova pode realizar uma consulta direcionada nessa região para procurar orientação explicitamente ancorada no título da atividade.

No golden sample:

```text
Atividade guiada
  -> Atividade guiada - orientação
  -> texto de orientação
```

A relação é candidata e rastreável. Não é produzida por similaridade global sobre o livro inteiro.

## 6. Contrato candidato

`PART_RECONSTRUCTION_CONTRACT_VERSION = 1.0.0`.

O snapshot contém:

- referência ao snapshot de reconhecimento estrutural;
- `CartographicPartScope` de origem;
- páginas efetivamente inspecionadas;
- elementos candidatos;
- relações candidatas;
- evidências por página/localizador;
- warnings.

Tipos iniciais de elemento:

```text
part_title
section_heading
body_text
activity_heading
activity_prompt
visual_marker
caption
teacher_guidance_heading
teacher_guidance_text
```

Relações iniciais:

```text
contains
caption_for_visual
teacher_guidance_for_activity
```

Esse vocabulário é propositalmente pequeno e não define ainda a ontologia integral de C.4.

## 7. Critérios da prova

A prova só passa se:

1. a cartografia entregar `Introdução = físicas 11–13`;
2. a reconstrução inspecionar profundamente somente 11–13;
3. páginas 14–17 e 19 não forem lidas para reconstruir a parte;
4. a consulta docente for dirigida à região do Manual já cartografada;
5. o título `Introdução` for corroborado no corpo;
6. os dois subtítulos esperados forem reconstruídos;
7. o texto expositivo permanecer subordinado ao heading correspondente;
8. `Atividade guiada` e seu comando forem preservados;
9. o PDF.js observar um `image_marker` real no fixture;
10. a legenda se relacione ao marcador visual;
11. a orientação docente se relacione à atividade;
12. não haja OCR, multimodalidade, embeddings, BNCC validada ou corpus.

## 8. Escopo negativo

Sem:

- conteúdo real;
- PNLD real;
- banco/migration/RPC;
- persistência nova;
- C.3.6;
- OCR;
- interpretação multimodal da imagem;
- destilação conceitual;
- deduplicação multifonte;
- grafo global;
- validação curricular;
- runtime multiagente;
- produção.

## 9. Próxima decisão após a prova

Se esta fatia ficar verde, revisar o resultado antes de ampliar o escopo.

O próximo teste deverá usar uma segunda parte estruturalmente diferente — preferencialmente uma Unidade/Capítulo — para descobrir quais regras do reconstruction são realmente gerais e quais pertencem apenas à Introdução.

Somente depois disso a definição integral de C.4 deverá ser cristalizada.

Síntese:

> **A primeira unidade de conhecimento não é “o livro”; é uma parte editorial compreendida, reconstruída e relacionada às evidências necessárias sem perder sua posição dentro da obra.**
