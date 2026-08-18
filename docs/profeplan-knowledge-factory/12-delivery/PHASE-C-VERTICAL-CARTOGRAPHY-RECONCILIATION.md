# Fase C — Reconciliação arquitetônica por cartografia vertical da obra

Data: 18 de agosto de 2026.

Status: **emenda arquitetônica documental para reconciliação da sequência de execução da Fase C**.

Base canônica de origem: `main@c7cea4b7d0e4c12182a28fa85a4a2ad8f57b282e`, após integração de C.3.5.

Documentos reconciliados por esta emenda:

- `BLUEPRINT.md`;
- `12-delivery/PHASE-C-EXECUTION-MAP.md`;
- `12-delivery/PHASE-C-KNOWLEDGE-CARTOGRAPHY-ACTION-PLAN.md`;
- `12-delivery/LOT-C3-EXTRACTION-AND-VALIDATION-DEFINITION.md`.

Esta emenda não substitui contratos já integrados de C.1, C.2 ou C.3.1–C.3.5. Seu objetivo é corrigir a interpretação executiva que vinha exigindo o encerramento horizontal de toda a extração antes de permitir que a cartografia da obra orientasse o processamento.

## 1. Problema identificado

A arquitetura documental já estabelecia que a Fase C deveria produzir simultaneamente árvore editorial, manifesto de cobertura, grafo de conhecimento e grafo pedagógico-curricular e que a cartografia deveria preceder a extração semântica integral.

Entretanto, a sequência executiva C.3 inteiro -> C.4 inteiro passou a ser interpretada operacionalmente como:

```text
extrair fisicamente a obra inteira
  -> validar fisicamente a obra inteira
  -> somente então reconstruir sua organização editorial
  -> somente então iniciar análise semântica e pedagógica
```

Essa interpretação conflita com o próprio plano de cartografia e não representa adequadamente livros didáticos reais, nos quais capa, ficha catalográfica, apresentação, seção de organização da obra, sumário, paginação editorial, paratextos curriculares e Manual do Professor fornecem informações estruturais que devem orientar o restante do processamento.

A correção não elimina as fronteiras de responsabilidade entre C.3, C.4, C.5, C.6 e C.7. Ela altera a **ordem operacional de aplicação dessas responsabilidades sobre cada obra**.

## 2. Princípio arquitetônico principal

> **A obra é um contêiner documental e pedagógico; não é a unidade semântica de processamento.**

Nenhum livro completo deverá ser tratado como um único bloco de contexto, um único lote semântico ou uma sequência cega de páginas.

O processamento profundo deverá ser orientado por uma cartografia preliminar da obra e ocorrer por partes editoriais delimitadas e reconciliáveis.

A unidade operacional preferencial será a menor parte que preserve contexto editorial e pedagógico suficiente, por exemplo:

- introdução;
- unidade;
- capítulo;
- seção;
- subseção;
- recurso pedagógico autocontido;
- conjunto explicitamente relacionado de texto + atividade + orientação docente.

Limites técnicos de páginas, tokens ou bytes continuam existindo, mas são secundários às fronteiras editoriais. Quando uma parte precisar ser fragmentada tecnicamente, a ancestralidade e a continuidade deverão permanecer explícitas.

## 3. Fluxo corrigido da obra

A execução deixa de ser entendida como uma esteira exclusivamente horizontal e passa a adotar um ciclo vertical por partes.

### Passagem 1 — reconhecimento e cartografia preliminar

```text
arquivo autorizado
  -> pistas do nome do arquivo
  -> identidade documental
  -> inspeção das páginas preliminares relevantes
  -> localização de sumário/índice e seção de organização da obra
  -> reconciliação inicial de paginação física x impressa
  -> árvore editorial preliminar
  -> inventário de regiões informacionais
  -> plano de partes da obra
```

Essa passagem não destila conhecimento pedagógico canônico. Ela cria hipóteses cartográficas rastreáveis que orientarão a extração e a reconstrução posteriores.

### Passagem 2 — ciclo vertical por parte

Para cada parte delimitada:

```text
parte candidata
  -> extração observável
  -> reconstrução estrutural da parte
  -> classificação de elementos editoriais
  -> identificação de contribuições conceituais e pedagógicas candidatas
  -> tratamento de elementos visuais relevantes
  -> vinculação de atividades e orientações docentes quando observáveis
  -> reconciliação da cobertura da parte
  -> decisão de qualidade/revisão
  -> próxima parte
```

As responsabilidades continuam pertencendo aos lotes correspondentes. A passagem vertical não autoriza C.5, C.6 ou C.7 antes de seus contratos e gates; ela apenas impede que a obra precise atravessar fisicamente toda uma camada antes que a estrutura já observável possa orientar a camada anterior ou seguinte.

### Passagem 3 — reconciliação da obra e relações globais

Somente após partes suficientes terem sido compreendidas e reconciliadas:

```text
partes reconciliadas
  -> árvore editorial confirmada
  -> cobertura da obra
  -> relações entre partes
  -> relações conceituais candidatas
  -> relações pedagógicas/curriculares candidatas
  -> destilação e deduplicação conforme C.5
  -> componentização conforme C.6
  -> curadoria e corpus conforme C.7
```

A ordem editorial original é preservada como procedência, mas não se torna automaticamente ontologia ou sequência didática canônica.

## 4. Protocolo de reconhecimento estrutural da obra

Antes de processamento semântico aprofundado, a coordenação cartográfica deverá procurar e reconciliar, quando disponíveis:

1. nome do arquivo;
2. capa;
3. folha de rosto;
4. ficha catalográfica;
5. créditos e expediente;
6. apresentação;
7. seção do tipo `Conheça seu livro`, `Organização da obra`, `Como usar este livro` ou equivalente;
8. sumário ou índice;
9. paratextos curriculares;
10. início do corpo pedagógico principal;
11. regiões de Manual do Professor;
12. referências, anexos, glossários e índices finais.

A janela inicial não terá número rígido universal de páginas. A inspeção deve parar quando houver evidência suficiente para formar uma cartografia preliminar ou registrar explicitamente que a obra exige estratégia alternativa.

## 5. Metadados: pista, detecção e canonicidade

O nome do arquivo poderá orientar a inspeção, mas nunca constituirá sozinho identidade bibliográfica ou verdade canônica.

Devem existir conceitualmente três camadas distintas:

```text
filename_hints
  -> inferências de baixo custo derivadas do nome do arquivo

detected_metadata
  -> dados observados em capa, ficha catalográfica, folha de rosto, expediente ou outras regiões

canonical_metadata
  -> metadados reconciliados após corroborar, resolver conflito ou registrar revisão
```

Exemplos de pistas úteis incluem coleção, componente curricular, volume único/seriado, livro do estudante/manual do professor, edição e referência ao PNLD, sem presumir que abreviações ou nomes sejam universais entre editoras.

## 6. Dupla paginação é requisito normal, não exceção

A arquitetura deverá distinguir explicitamente:

- página física/índice do arquivo digital;
- página impressa/editorial quando observável;
- rótulos não numéricos quando existirem;
- confiança e método de detecção da correspondência.

Nenhuma relação estrutural poderá depender silenciosamente da equivalência entre número físico do PDF e número impresso.

A reconciliação deverá suportar páginas preliminares não numeradas, numeração romana, páginas repetidas, páginas sem número impresso e deslocamentos editoriais.

## 7. Árvore editorial preliminar como hipótese rastreável

O sumário é uma das principais fontes para a árvore preliminar, mas não é autoridade final.

Cada nó preliminar deverá registrar, conforme o contrato futuro permitir:

- tipo candidato: parte, unidade, capítulo, seção, subseção ou outro;
- título observado;
- página impressa declarada;
- página física estimada;
- origem da observação: sumário, marcador PDF, corpo, seção de organização ou revisão humana;
- confiança;
- estado: candidato, confirmado, corrigido, rejeitado ou equivalente futuro.

C.4 continua responsável pela reconstrução estrutural confirmada. A novidade é que uma **cartografia candidata** pode e deve existir antes da confirmação de C.4 para orientar o que C.3 extrai e em que ordem.

## 8. Gramática editorial da coleção

Quando a obra explicar sua própria organização, essa informação deverá ser extraída antes do processamento dos capítulos.

A gramática editorial pode declarar recursos como:

- boxes;
- seções de atividade;
- infográficos;
- biografias;
- glossários;
- retomadas;
- debates;
- projetos;
- mundo digital/mundo do trabalho;
- recursos específicos da coleção.

Esses rótulos são **tipos editoriais declarados pela obra**, não categorias universais automaticamente canônicas. A Knowledge Factory poderá mapear posteriormente esses tipos para uma ontologia editorial/pedagógica própria sem apagar a terminologia original.

## 9. Elementos e relações internas da parte

Uma parte não será representada apenas como texto corrido. O processamento deverá ser capaz de distinguir candidatos a:

- texto expositivo;
- título e subtítulo;
- definição;
- citação;
- box;
- atividade;
- questão;
- orientação docente;
- resposta esperada;
- fotografia;
- charge/tirinha;
- mapa;
- gráfico;
- tabela;
- infográfico;
- legenda;
- crédito;
- referência;
- declaração curricular.

A modelagem final dos tipos permanece sujeita aos contratos de C.4–C.6. Esta emenda apenas exige que elementos heterogêneos não sejam achatados em um único bloco textual durante o caminho principal.

## 10. Elementos visuais: semântica multimodal antes de OCR genérico

A capacidade futura de tratamento visual deverá distinguir três estratégias:

```text
1. extração textual nativa
   caminho padrão para texto recuperável

2. compreensão multimodal do elemento visual
   quando imagem, mapa, gráfico, infográfico, charge, layout ou relação texto-imagem possui função informacional/pedagógica

3. OCR localizado
   fallback quando existe texto relevante não recuperável de modo nativo
```

OCR não será tratado como etapa obrigatória para livros editoriais que já possuem camada textual utilizável.

C.3.7 deve ser reinterpretado como **decisão governada de recuperação multimodal e fallback visual**, mantendo OCR como uma das técnicas possíveis e não como objetivo em si.

Nenhum provedor novo, OCR, modelo multimodal hospedado ou processamento de conteúdo real é autorizado por esta emenda.

## 11. Manual do Professor como região estrutural de primeira classe

Livro do estudante, Manual do Professor, suplemento e demais manifestações continuam identidades documentais distintas quando assim caracterizados por C.1.

Quando um Manual do Professor estiver incorporado à mesma manifestação física ou digital, sua região deverá ser cartografada explicitamente.

O processamento futuro deverá permitir relações rastreáveis entre:

```text
conteúdo/atividade do aluno
  -> questão ou comando
  -> resposta/expectativa
  -> orientação ao professor
  -> estratégia de mediação/avaliação
  -> conceitos e relações curriculares correspondentes
```

Essas relações não deverão ser inferidas globalmente apenas por similaridade; devem usar localização editorial, referências internas e evidência textual/visual sempre que disponíveis.

## 12. Declarações curriculares da obra

Mapas de BNCC, competências, habilidades ou Temas Contemporâneos Transversais publicados pela própria obra devem ser capturados como **declarações editoriais rastreáveis**.

A prioridade de evidência será:

```text
informação editorial explicitamente declarada
  > inferência gerativa sobre o que a editora teria pretendido
```

Entretanto, declaração editorial não equivale a validação curricular independente do ProfePlan. A distinção de estados já prevista para C.6 permanece obrigatória.

## 13. Papel da coordenação cartográfica

A responsabilidade denominada `Coordenação cartográfica`/`Cartógrafo da Obra` torna-se central no caminho principal da Fase C.

Ela deverá:

- coordenar reconhecimento inicial;
- produzir e versionar a árvore preliminar;
- escolher fronteiras de partes;
- distribuir trabalho sem romper contexto;
- acompanhar cobertura hierárquica;
- solicitar inspeção localizada quando houver ambiguidade;
- impedir processamento cego do livro inteiro;
- reconciliar descobertas que alterem a cartografia;
- consolidar o mapa da obra ao final.

Na Fase C essa responsabilidade não implica necessariamente um agente LLM autônomo. Pode ser implementada progressivamente por regras determinísticas, parser, jobs controlados, modelos assistidos e revisão humana. A decisão de runtime multiagente permanece sob a Fase E.

## 14. Relação corrigida entre C.3 e C.4

A fronteira conceitual é preservada:

### C.3

Autoridade sobre evidência observável:

- páginas físicas;
- texto nativo;
- elementos observados;
- método e proveniência;
- métricas;
- cobertura física;
- qualidade;
- decisões de extração.

### Cartografia preliminar

Camada candidata compartilhada para **orientar execução**, construída a partir de observações como sumário, marcadores e títulos, sem declarar hierarquia canônica.

### C.4

Autoridade sobre:

- confirmação/correção da árvore;
- segmentação editorial;
- classificação estrutural/informacional;
- notas candidatas;
- mapas confirmados de seção, capítulo, unidade e obra.

Consequentemente, C.4 não precisa esperar que C.3 tenha processado semanticamente a obra inteira para que hipóteses estruturais orientem o processamento. O gate entre responsabilidades é mantido por estado dos dados, não por uma barreira artificial de "livro inteiro concluído".

## 15. Modelo de consolidação

A cobertura continua hierárquica, mas a unidade operacional muda:

```text
bloco/elemento
  -> página
  -> parte operacional
  -> seção
  -> capítulo
  -> unidade
  -> obra
  -> corpus
```

Uma obra não fecha enquanto houver parte esperada sem decisão explícita. Entretanto, partes já reconciliadas podem alimentar provas controladas de etapas posteriores quando o contrato e o gate correspondentes estiverem aprovados.

## 16. Golden sample estrutural antes do primeiro livro completo

O próximo artefato de prova deverá ser um **golden sample inteiramente sintético**, inspirado apenas na diversidade estrutural observada em livros didáticos reais, sem copiar texto, imagens ou conteúdo protegido.

Ele deverá conter no mínimo:

- nome de arquivo informativo;
- capa sintética;
- ficha catalográfica sintética;
- seção `Conheça seu livro` ou equivalente;
- sumário;
- paginação física diferente da paginação impressa;
- uma `Introdução` como primeira parte;
- títulos e subtítulos;
- texto expositivo original/sintético;
- pelo menos um elemento visual sintético com legenda;
- uma atividade;
- uma orientação de Manual do Professor relacionada à atividade;
- uma declaração curricular sintética;
- região final de orientações docentes.

O golden sample deverá ser pequeno o suficiente para revisão humana integral e rico o suficiente para provar o caminho principal.

## 17. Primeira prova vertical obrigatória

A primeira prova após esta reconciliação deverá demonstrar, sem conteúdo real protegido:

```text
arquivo sintético
  -> reconhecer identidade e pistas do filename
  -> localizar sumário/organização da obra
  -> reconciliar paginação física x impressa
  -> construir árvore preliminar
  -> selecionar apenas a parte `Introdução`
  -> extrair essa parte
  -> reconstruir seus títulos/subtítulos
  -> reconhecer texto, visual, atividade e orientação docente
  -> manter as relações entre os elementos
  -> reconciliar cobertura da parte
  -> produzir saída revisável
```

A prova não deverá processar o livro sintético inteiro de uma vez.

## 18. Estado de C.3.6 e PR nº 110

O PR nº 110 (`feat/knowledge-factory: implement C.3.6 recovery and cleanup`) permanece **aberto e não integrado** enquanto esta reconciliação arquitetônica é avaliada.

A infraestrutura proposta de retry, cancelamento, concorrência e cleanup não é considerada descartada. Ela é classificada como **endurecimento de confiabilidade potencialmente reutilizável**, subordinado ao caminho principal corrigido.

Não corrigir ou mergear C.3.6 automaticamente durante esta emenda. Após a primeira prova vertical, decidir se:

1. o PR nº 110 deve ser corrigido e integrado como infraestrutura genérica;
2. deve ser ajustado ao novo modelo operacional por partes;
3. parte de sua superfície deve ser simplificada ou adiada.

## 19. Atualização de estados executivos

O estado canônico considerado nesta reconciliação é:

```text
C.0  concluído
C.1  concluído
C.2  concluído
C.3.1 concluído
C.3.2 concluído
C.3.3 concluído
C.3.4 concluído
C.3.5 concluído
C.3.6 em PR aberto, não integrado e temporariamente suspenso para reconciliação
C.3.7 não iniciar
C.3.8 não iniciar
C.4   não iniciar como lote horizontal integral antes da prova vertical de cartografia
```

Essa suspensão não constitui rollback dos sublotes integrados.

## 20. Próximas ações aprovadas após esta emenda

Ordem recomendada:

1. reconciliar documentalmente Blueprint, mapa da Fase C, plano de cartografia e definição C.3 com esta emenda;
2. definir contrato mínimo do Protocolo de Reconhecimento Estrutural da Obra;
3. criar golden sample sintético;
4. provar cartografia inicial;
5. provar ciclo vertical somente da `Introdução`;
6. revisar o resultado humano e registrar lacunas concretas;
7. somente então retomar hardening de recovery/cleanup e decisão multimodal/OCR;
8. preparar fronteira jurídica e operacional específica para primeiro conteúdo real controlado.

## 21. Escopo negativo desta reconciliação

Esta emenda não autoriza:

- ingestão ou persistência de livro PNLD real;
- upload de conteúdo protegido para infraestrutura hospedada;
- OCR real;
- chamadas a modelo multimodal sobre conteúdo protegido;
- chunks/embeddings de obra real;
- publicação em corpus;
- C.4–C.7 técnicos fora da prova vertical futura;
- runtime multiagente;
- alteração de produção;
- merge automático do PR nº 110;
- Nexus ou Evolution como dependência arquitetônica.

Integrações externas, inclusive Nexus ou atualizações da Evolution, somente serão avaliadas quando demonstrarem aderência arquitetônica e contribuição concreta ao ProfePlan.

## 22. Critério de saída da reconciliação

Esta reconciliação estará pronta para fechar quando:

- não houver contradição documental entre `cartografia antes da extração semântica integral` e o gate C.3 -> C.4;
- o caminho principal por partes estiver explícito no Blueprint e no mapa executivo;
- C.3 continuar preservando evidência observável sem assumir semântica canônica;
- C.4 continuar responsável pela confirmação estrutural;
- o golden sample e a primeira prova vertical estiverem definidos como próximos passos;
- PR nº 110 estiver explicitamente classificado como suspenso, não perdido nem implicitamente aprovado;
- nenhum conteúdo real, OCR, novo provedor ou produção tiver sido antecipado.

A regra de síntese desta emenda é:

> **Primeiro compreender a forma da obra, depois aprofundar cada parte, depois conectar o conhecimento; robustez e exceções endurecem um caminho principal já provado, não o substituem.**
