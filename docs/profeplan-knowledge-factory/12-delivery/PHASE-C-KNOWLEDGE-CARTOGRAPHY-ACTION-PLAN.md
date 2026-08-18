# Plano de ações para cartografia vertical e formação do grafo de conhecimento

Data da definição inicial: 11 de agosto de 2026.

Reconciliação operacional: 18 de agosto de 2026.

Base documental: `BLUEPRINT.md`, `PHASE-C-EXECUTION-MAP.md`, ADRs e checkpoints vigentes.

Emenda de referência:
[`PHASE-C-VERTICAL-CARTOGRAPHY-RECONCILIATION.md`](PHASE-C-VERTICAL-CARTOGRAPHY-RECONCILIATION.md).

## Status e limite

Este plano passa a ser **parte central do caminho principal da Fase C**, e não apenas detalhamento complementar.

Ele não autoriza por si só:

- conteúdo real protegido;
- PNLD real em infraestrutura hospedada;
- OCR real;
- modelo multimodal/provider novo;
- embeddings;
- runtime multiagente;
- produção.

Ele orienta a construção de fixtures sintéticas, contratos e provas necessárias para compreender corretamente a estrutura de obras antes da ingestão semântica aprofundada.

## 1. Resultado arquitetônico

A Fase C deve produzir um corpus pedagógico que preserve quatro representações coordenadas:

```text
ÁRVORE EDITORIAL
obra -> região -> parte -> unidade -> capítulo -> seção -> subseção -> página -> elemento

MANIFESTO DE COBERTURA
arquivo -> páginas -> regiões -> partes -> execuções -> resultados -> lacunas

GRAFO DE CONHECIMENTO
conceito/teoria/autor/problema/exemplo -> relação tipada -> conhecimento

GRAFO PEDAGÓGICO-CURRICULAR
conhecimento/atividade/orientação -> uso pedagógico -> currículo
```

A árvore informa **onde**; o manifesto prova **o que foi processado**; o grafo conceitual informa **como as ideias se relacionam**; o grafo pedagógico-curricular informa **como o conhecimento pode servir ao professor**.

## 2. Princípios obrigatórios

### 2.1 A obra é contêiner, não unidade semântica

Nunca tratar um livro completo como um único contexto de análise.

Processamento profundo ocorre por partes editoriais delimitadas.

### 2.2 Cartografia antes do aprofundamento

Antes da análise semântica detalhada, produzir mapa editorial preliminar a partir de evidências como:

- filename;
- capa e folha de rosto;
- ficha catalográfica;
- apresentação;
- seção de organização da obra;
- sumário/índice;
- marcadores PDF;
- títulos observados;
- paginação física e impressa;
- regiões do Manual do Professor;
- paratextos curriculares.

### 2.3 Sumário é hipótese estrutural

O sumário orienta, mas precisa ser reconciliado com:

- títulos/subtítulos reais;
- início/fim das partes;
- elementos não listados;
- boxes e atividades;
- páginas ausentes/duplicadas;
- continuidade entre páginas;
- regiões finais.

### 2.4 Estrutura orienta extração

Fronteira editorial tem precedência sobre divisão arbitrária por tokens/páginas.

Quando uma parte precisar ser fragmentada tecnicamente, preservar:

- parent/ancestralidade;
- ordem;
- continuidade;
- início/continuação/fim;
- contexto mínimo.

### 2.5 Cobertura é reconciliação

Nenhum parser/modelo pode declarar sozinho que “a obra foi processada”.

O manifesto deve reconciliar páginas, regiões, partes, resultados, falhas e decisões.

### 2.6 Estrutura editorial ≠ sequência didática canônica

Preservar separadamente:

- ordem editorial;
- dependência conceitual;
- organização curricular;
- sequência didática proposta;
- percurso escolhido pelo professor.

### 2.7 Declaração da obra ≠ validação do ProfePlan

Competências/habilidades declaradas pela editora são evidências editoriais rastreáveis, não validações independentes.

### 2.8 Embedding é índice

Vetores nunca substituem árvore, procedência, relações ou validação.

## 3. Protocolo de Reconhecimento Estrutural da Obra

O primeiro trabalho da coordenação cartográfica é responder:

```text
QUE DOCUMENTO É ESTE?
COMO ELE SE ORGANIZA?
ONDE COMEÇA O CONTEÚDO PEDAGÓGICO RELEVANTE?
QUAIS SÃO SUAS PARTES?
COMO DEVO DIVIDIR O PROCESSAMENTO?
```

### Etapa 1 — pistas externas

Extrair do nome do arquivo apenas pistas, nunca verdades finais.

Camadas conceituais:

```text
filename_hints

detected_metadata

canonical_metadata
```

Possíveis pistas:

- coleção;
- componente;
- PNLD/edição;
- volume único ou seriado;
- livro do estudante/Manual do Professor;
- tipo de material.

### Etapa 2 — inspeção documental inicial

Procurar, quando existirem:

1. capa;
2. folha de rosto;
3. ficha catalográfica;
4. créditos/expediente;
5. apresentação;
6. organização da obra;
7. sumário/índice;
8. paratexto curricular;
9. primeiro conteúdo principal;
10. regiões de Manual do Professor;
11. referências/anexos/glossários.

A janela de páginas é adaptativa. O processo para quando houver evidência suficiente para criar um mapa preliminar ou quando uma exceção explícita for registrada.

### Etapa 3 — reconciliação da paginação

Manter pelo menos:

```text
physical_page_index
printed_page_label/number
confidence
source/method
```

Suportar deslocamento, páginas não numeradas, romanos, rótulos e ausência de número impresso.

### Etapa 4 — árvore candidata

Cada nó candidato deve poder conservar:

- tipo editorial candidato;
- título;
- origem da detecção;
- página impressa declarada;
- página física estimada/observada;
- parent candidato;
- confiança;
- estado candidato/confirmado/corrigido/rejeitado conforme contrato futuro.

### Etapa 5 — gramática editorial

Se a própria obra explicar recursos editoriais, capturar seu vocabulário antes dos capítulos.

Exemplos genéricos:

- boxes;
- `retome`;
- atividades;
- infográficos;
- biografias;
- glossário;
- debates;
- projetos;
- recursos digitais.

Preservar o nome original da coleção e posteriormente mapeá-lo para categorias canônicas do ProfePlan.

### Etapa 6 — plano de partes

A coordenação gera uma fila de partes coerentes:

```text
parte 01 — Introdução
parte 02 — capítulo/unidade seguinte
parte 03 — ...
...
parte N — Manual/orientações/referências conforme classificação
```

Cada parte registra sua faixa candidata e dependências editoriais.

## 4. Inventário integral de regiões

Nenhuma página deve ser descartada como “preliminar” antes de ser classificada.

| Região | Informação procurada | Tratamento |
|---|---|---|
| capa/folha de rosto | título, autoria, edição | identidade |
| ficha catalográfica | ISBN, edição, responsáveis | metadados/procedência |
| expediente | direitos/licenças/equipe | jurídico/procedência |
| apresentação | público/finalidade | contexto declarado |
| organização da obra | gramática editorial | cartografia |
| sumário | partes/títulos/páginas | árvore candidata |
| paratexto curricular | competências/habilidades/TCT | declaração editorial |
| corpo | exposição conceitual | processamento por parte |
| atividades | comandos/perguntas | análise pedagógica |
| elementos visuais | fotografia/mapa/gráfico/charge/infográfico | multimodal quando necessário |
| referências | obras/documentos/autores | procedência intelectual |
| glossário/índice | termos/localização | cartografia/reconciliação |
| Manual do Professor | orientações/respostas/avaliação | trilha pedagógica relacionada |
| anexos | materiais complementares | classificar por conteúdo |

## 5. Coordenação cartográfica

A coordenação cartográfica torna-se responsável por:

- iniciar reconhecimento;
- criar/versionar mapa preliminar;
- converter mapa em plano de partes;
- distribuir trabalho sem romper contexto;
- acompanhar cobertura por parte e obra;
- atualizar o mapa quando uma parte revelar fronteira diferente;
- impedir encerramento com lacunas não decididas;
- consolidar árvore confirmada e manifesto.

Na Fase C isso é uma **responsabilidade**, não obrigação de runtime multiagente. Pode usar código determinístico, parser, modelos controlados e revisão humana conforme cada contrato.

## 6. Ciclo vertical por parte

Para cada parte:

```text
1. receber ancestralidade e faixa candidata
2. executar extração observável C.3
3. reconciliar cobertura física local
4. reconstruir estrutura C.4 quando autorizado
5. classificar elementos editoriais/informacionais
6. identificar contribuições candidatas
7. relacionar visual/texto/atividade/orientação quando houver evidência
8. revisar ambiguidades
9. consolidar parte
10. devolver correções ao mapa da obra
```

O livro nunca é enviado inteiro para um modelo “entender tudo”.

## 7. Tipologia editorial/pedagógica candidata

A ontologia final será definida nos contratos de C.4–C.6, mas o caminho principal deve preservar heterogeneidade suficiente para distinguir candidatos a:

### Estrutura

- parte;
- unidade;
- capítulo;
- seção;
- subseção.

### Texto/conhecimento

- exposição;
- definição;
- citação;
- conceito;
- teoria/corrente;
- autor;
- argumento/controvérsia;
- exemplo/caso.

### Pedagógico

- atividade;
- questão;
- resposta/expectativa;
- orientação docente;
- estratégia de mediação;
- avaliação;
- projeto.

### Visual

- fotografia;
- obra de arte;
- mapa;
- gráfico;
- tabela;
- infográfico;
- charge/tirinha;
- legenda;
- crédito.

### Paratextual/curricular

- metadado editorial;
- declaração jurídica;
- declaração curricular;
- referência bibliográfica;
- glossário.

## 8. Elementos visuais

Não reduzir “imagem” a um placeholder genérico.

Quando visual for relevante, registrar separadamente:

```text
observação física
  -> tipo/localização

descrição visual
  -> o que aparece

contexto editorial
  -> onde/como foi inserido

função pedagógica candidata
  -> o que o elemento ajuda a observar/compreender

relações
  -> texto/atividade/conceito/orientação associados
```

A função pedagógica é uma interpretação posterior e deve manter evidência e confiança.

## 9. Recuperação visual e OCR

Estratégia:

```text
A. texto nativo
   padrão

B. análise multimodal localizada
   para elemento visual informacional/pedagógico

C. OCR localizado
   quando texto relevante não é recuperável nativamente
```

Não criar OCR genérico da obra inteira sem necessidade comprovada.

C.3.7 deverá formalizar essa fronteira depois da prova vertical.

## 10. Manual do Professor

Manual do Professor é região/manifestações de primeira classe.

Quando houver relação explícita ou forte evidência editorial, permitir cadeia candidata:

```text
atividade
  -> questão/comando
  -> expectativa/resposta
  -> orientação docente
  -> mediação/avaliação
  -> conteúdo/conceito
  -> vínculo curricular declarado/validado
```

Não relacionar apenas por similaridade textual global.

## 11. Cartografia curricular

Extrair como declaração editorial:

- Competência Geral;
- Competência Específica;
- habilidade BNCC;
- currículo estadual quando declarado;
- TCT;
- outros códigos declarados.

Estados futuros devem distinguir declaração, detecção, proposta, validação normativa e aprovação humana.

## 12. Manifesto de cobertura

A cobertura deve consolidar:

```text
arquivo
 -> páginas físicas
 -> regiões
 -> partes
 -> páginas/elementos de cada parte
 -> resultados
 -> falhas/reprocessamentos
 -> decisões humanas
```

Uma média alta de cobertura nunca mascara página/região obrigatória sem decisão.

## 13. Grafo de conhecimento

Após partes estruturadas e contribuições elegíveis, relações candidatas podem incluir:

### Editoriais

- `PERTENCE_A`;
- `VEM_ANTES_DE`;
- `VEM_DEPOIS_DE`;
- `CONTINUA_EM`;
- `LOCALIZADO_EM`.

### Conceituais

- `DEFINE`;
- `EXEMPLIFICA`;
- `CONTRASTA_COM`;
- `DEPENDE_DE`;
- `APROFUNDA`;
- `QUESTIONA`;
- `APLICA`;
- `CAUSA`;
- `CONSEQUENCIA_DE`.

### Teóricas

- `FORMULADO_POR`;
- `DEFENDIDO_POR`;
- `CRITICADO_POR`;
- `PERTENCE_A_CORRENTE`;
- `REVISA`.

### Pedagógicas

- `PRE_REQUISITO_DE`;
- `ADEQUADO_PARA`;
- `PODE_SER_ENSINADO_COM`;
- `ADMITE_ATIVIDADE`;
- `EXIGE_MEDIACAO`.

Esse vocabulário continua candidato até contrato próprio.

## 14. Estados da informação

Não colapsar:

```text
arquivo recebido
-> observação física
-> mapa editorial candidato
-> texto/elemento normalizado
-> estrutura confirmada
-> contribuição candidata
-> síntese destilada
-> nota atômica
-> componente versionado
-> relação/vínculo candidato
-> item revisado
-> item aprovado
-> item elegível
```

Alta confiança de extração não implica correção pedagógica, autoral ou curricular.

## 15. Golden sample sintético

O próximo artefato de teste deverá ser construído **do zero**, apenas inspirado na variedade estrutural observada em livros didáticos.

Requisitos mínimos:

1. filename com pistas;
2. capa sintética;
3. ficha sintética;
4. `Conheça seu livro`/organização;
5. sumário;
6. deslocamento PDF x página impressa;
7. `Introdução`;
8. títulos/subtítulos;
9. texto original;
10. visual sintético + legenda;
11. atividade;
12. orientação de professor relacionada;
13. declaração curricular sintética;
14. região final de Manual do Professor.

Deve ser pequeno o suficiente para auditoria humana completa.

## 16. Primeira prova vertical — Introdução

Critério de sucesso:

```text
arquivo
  -> metadados/pistas
  -> organização/sumário localizados
  -> paginação reconciliada
  -> árvore preliminar gerada
  -> Introdução delimitada
  -> texto extraído
  -> títulos/subtítulos reconstruídos
  -> visual e legenda preservados
  -> atividade identificada
  -> orientação docente ligada
  -> cobertura local reconciliada
  -> saída humana revisável
```

A prova deve explicitar falhas e incertezas; não deve esconder lacunas para produzir um JSON “bonito”.

## 17. Critérios antes de expandir para segunda parte

Não expandir automaticamente.

Revisar:

- precisão do mapa;
- correspondência de paginação;
- fronteiras de seção;
- perda de texto;
- elementos visuais ignorados;
- relações erradas entre atividade/manual;
- custo/complexidade;
- pontos em que regra determinística bastaria;
- pontos que realmente exigem modelo.

Se a mesma arquitetura funcionar em uma segunda parte estruturalmente diferente, aumenta a evidência de generalização interna.

## 18. Destilação e multifonte

Somente após estrutura elegível:

- produzir sínteses próprias;
- comparar fontes autorizadas;
- preservar divergências;
- evitar reprodução extensa;
- não converter sequência de coleção em ontologia;
- submeter deduplicação à revisão no piloto.

## 19. Retrieval — impacto futuro

A Fase D deverá explorar:

```text
filtro determinístico
+ busca lexical/estruturada
+ busca semântica
+ relações tipadas
+ reranking
```

Experimentos relevantes:

- chunks planos vs componentes;
- sem relações vs vizinhança de grafo;
- uma fonte vs síntese multifonte;
- busca semântica isolada vs híbrida;
- diferentes expansões de grafo dentro do mesmo token budget.

## 20. Agentes — impacto futuro

Durante a Fase C, nomes como:

- Cartógrafo;
- Inspetor;
- Reconstrutor;
- Extrator Conceitual;
- Analista Pedagógico;
- Analista Curricular;
- Crítico;

representam **responsabilidades**, não necessariamente agentes LLM executáveis.

Runtime multiagente pertence à Fase E.

O Cartógrafo da Obra não deve ser confundido com o Orquestrador de Produção.

## 21. Riscos e controles

| Risco | Controle |
|---|---|
| ler livro inteiro como bloco | processamento por partes |
| iniciar exceções antes do happy path | prova vertical primeiro |
| sumário incompleto | reconciliação com corpo |
| páginas deslocadas | dupla paginação |
| perder gramática da coleção | processar organização da obra cedo |
| ignorar Manual do Professor | região/trilha explícita |
| descrever imagem sem função | análise contextual e relação com conteúdo |
| OCR desnecessário | fallback localizado |
| relação curricular inventada | separar declaração de validação |
| grafo ruidoso | relações tipadas + evidência + curadoria |
| sequência de coleção virar cânone | destilação multifonte |
| retenção indevida de artefato | staging e descarte governados |

## 22. Relação com C.3.6

O PR #110 permanece suspenso e não integrado durante a prova do caminho principal.

Depois da primeira prova vertical, revisar se recovery/cleanup deve operar por:

- run global;
- parte;
- batch;
- combinação hierárquica.

Evitar cristalizar esse detalhe antes de observar o fluxo real.

## 23. Próximas ações

```text
1. integrar reconciliação documental
2. definir contrato do reconhecimento estrutural
3. criar golden sample
4. provar cartografia
5. provar Introdução verticalmente
6. revisar resultado
7. testar segunda parte
8. decidir hardening C.3.6
9. decidir multimodal/OCR
10. preparar primeiro conteúdo real autorizado
```

## 24. Critério de sucesso

A cartografia estará funcionando quando o ProfePlan puder responder, para qualquer conhecimento elegível:

> de qual obra/edição veio, em que parte se encontra, em qual página física e impressa, qual elemento o sustenta, que atividade/orientação se relaciona, quais relações foram propostas/validadas e por que esse item pode ser recuperado sem reabrir a obra inteira.

Síntese operacional:

> **Compreender a estrutura não é uma etapa posterior à extração do livro; é o mecanismo que determina como a extração útil deve acontecer.**
