# Plano de ações para cartografia, extração integral e formação do grafo de conhecimento

Data da definição: 11 de agosto de 2026.

Base documental: `BLUEPRINT.md`, `PHASE-C-EXECUTION-MAP.md`, ADR-054 e Checkpoint 033.

## Status e limite de autorização

**Especificação documental preparada para revisão humana.**

Este documento transforma as decisões de arquitetura discutidas para o processamento de livros e
outras fontes em ações implantáveis ao longo da Fase C e em requisitos de entrada para as Fases D,
E, F e G.

Ele:

- detalha o mapa C.1-C.7 sem substituir seus futuros documentos de definição;
- estabelece capacidades, artefatos, responsabilidades, gates e critérios de aceite;
- preserva os Epics, Features e Stories aprovados no Marco 003;
- não autoriza código, dependências, migrations, ingestão, fontes reais, modelos, prompts,
  embeddings, agentes executáveis, wiring, Supabase hospedado ou produção;
- não altera o próximo escopo elegível: definição documental exclusiva de C.1;
- não encerra `GAP-3B-04`, `GAP-3B-05` ou `GAP-3B-07`.

## 1. Resultado que a arquitetura deverá produzir

A Fase C não deverá produzir uma coleção de PDFs, páginas, chunks ou resumos soltos. Seu resultado
deverá ser um corpus pedagógico curado que conserve simultaneamente:

1. a organização editorial de cada obra;
2. a cobertura integral e verificável do arquivo processado;
3. conhecimentos atômicos, autorais e conectáveis;
4. relações tipadas entre conhecimentos;
5. evidências de procedência em página, bloco, tabela, célula ou elemento visual;
6. declarações curriculares da obra separadas das validações do ProfePlan;
7. versões, permissões, confiança e decisões humanas;
8. condições de elegibilidade para retrieval e produção pedagógica posterior.

O modelo conceitual obrigatório será formado por quatro representações coordenadas:

```text
ÁRVORE EDITORIAL
Livro -> região -> unidade -> capítulo -> seção -> subseção -> página -> bloco

MANIFESTO DE COBERTURA
Arquivo -> páginas esperadas -> páginas observadas -> regiões -> lotes -> resultados -> falhas

GRAFO DE CONHECIMENTO
Conceito/teoria/autor/problema/exemplo -> relação tipada -> outro nó de conhecimento

GRAFO PEDAGÓGICO-CURRICULAR
Conhecimento/atividade -> uso pedagógico -> habilidade/competência/objeto curricular
```

Essas representações se complementam. A árvore informa onde o conteúdo está; o manifesto prova o
que foi processado; o grafo conceitual conecta ideias; e o grafo pedagógico-curricular torna o
conhecimento utilizável pelo ProfePlan.

## 2. Decisões arquitetônicas obrigatórias

### 2.1 Cartografia antes da extração semântica integral

Toda obra deverá possuir um mapa editorial preliminar antes do processamento semântico aprofundado.
Esse mapa será elaborado a partir do sumário, dos marcadores internos, da hierarquia visual e do
conteúdo real das páginas.

O sumário será tratado como hipótese estrutural inicial, não como verdade final. O mapa deverá ser
reconciliado com:

- títulos e subtítulos encontrados no corpo;
- páginas físicas do arquivo e páginas impressas da obra;
- continuidade entre páginas;
- boxes, tabelas, infográficos, imagens, atividades e textos laterais;
- seções não listadas no sumário;
- páginas ausentes, duplicadas, ilegíveis ou fora de ordem.

### 2.2 Extração orientada pela hierarquia

Os lotes operacionais deverão respeitar fronteiras editoriais. Limites de páginas, tokens ou tamanho
serão restrições secundárias e nunca poderão romper silenciosamente uma seção.

Quando uma seção ultrapassar o limite operacional, sua divisão deverá conservar:

- o identificador da seção-mãe;
- a ordem dos fragmentos;
- a continuidade textual;
- o contexto mínimo necessário;
- a indicação explícita de início, continuação e encerramento.

### 2.3 Cobertura é uma reconciliação, não uma resposta do modelo

Nenhuma fonte, capítulo ou lote será considerado processado apenas porque um parser, OCR ou modelo
de linguagem produziu uma saída.

O encerramento dependerá de um manifesto que reconcilie:

- arquivo recebido;
- número e sequência de páginas;
- páginas impressas e páginas físicas;
- regiões informacionais;
- itens do sumário;
- seções descobertas no corpo;
- blocos e elementos visuais;
- lotes executados;
- resultados aceitos;
- falhas, lacunas, rejeições e reprocessamentos.

### 2.4 Árvore editorial e grafo tipado devem coexistir

A sequência da obra será preservada como procedência, mas não será automaticamente adotada como
sequência didática canônica.

O sistema deverá distinguir:

- sequência editorial da obra;
- dependência conceitual;
- organização curricular;
- sequência didática proposta;
- percurso escolhido pelo professor.

### 2.5 O vetor será índice, não fonte canônica

Embeddings não substituirão a estrutura relacional, a procedência ou a validação. A vetorização,
quando autorizada na Fase D, poderá abranger descrições ou camadas aprovadas, mas servirá apenas à
recuperação.

### 2.6 Declaração editorial não equivale a validação curricular

Mapas de BNCC, competências, habilidades e Temas Contemporâneos Transversais fornecidos pela obra
serão preservados como declarações editoriais rastreáveis. O ProfePlan somente apresentará um vínculo
como validado após conferir a fonte normativa e localizar evidências no conteúdo.

### 2.7 Responsabilidades especializadas antes de agentes executáveis

Durante a Fase C, “Cartógrafo da Obra”, “Inspetor”, “Reconstrutor”, “Extrator Conceitual”, “Analista
Pedagógico”, “Construtor de Relações”, “Analista Curricular”, “Agente de Procedência” e “Agente
Crítico” designam responsabilidades e contratos de processamento.

Essas responsabilidades poderão ser materializadas futuramente por regras determinísticas,
serviços, jobs assistidos, ferramentas de revisão ou modelos estritamente controlados, conforme a
definição de cada lote. Elas não autorizam runtime multiagente na Fase C. A decisão de instanciá-las
como agentes executáveis pertence à Fase E.

### 2.8 PDFs e representações visuais são insumos transitórios

O arquivo recebido, as páginas renderizadas, os recortes, as miniaturas e as regiões de imagem
existirão somente na área temporária de preparação e validação. Eles não integrarão o corpus
permanente, o banco relacional, o índice vetorial ou o armazenamento histórico da Knowledge
Factory.

Após a extração, a reconciliação e a revisão exigida, deverão permanecer apenas:

- identidade bibliográfica e hash não reversível do arquivo processado;
- localização lógica por obra, edição, página, região, seção, bloco, tabela ou célula;
- texto normalizado e chunks selecionados;
- estrutura editorial e dados tabulares estruturados;
- descrições semânticas de imagens, mapas, gráficos e infográficos;
- notas, conceitos, relações, vínculos curriculares, confiança e decisões de revisão;
- embeddings seletivos das unidades autorizadas para recuperação;
- recibo auditável de descarte dos artefatos temporários.

Não deverão permanecer PDFs, imagens integrais de páginas, recortes, miniaturas, renderizações,
OCRs duplicados, saídas brutas de fornecedores, mapas de coordenadas em pixels ou versões
intermediárias descartáveis. A procedência será mantida por identificadores e localizadores
lógicos; rastreabilidade não significa conservar uma cópia visual da fonte.

## 3. Inventário integral de regiões informacionais

Antes de excluir ou classificar qualquer página como preliminar ou acessória, C.2-C.4 deverão criar
um inventário de regiões da obra.

| Região | Informação procurada | Tratamento esperado |
|---|---|---|
| Capa e folha de rosto | título, autoria, edição, editora | identidade bibliográfica |
| Ficha catalográfica | ISBN, edição, classificação, responsáveis | metadados e procedência |
| Créditos e expediente | direitos, fontes, equipe, licenças | análise jurídica e de uso |
| Apresentação | público, finalidade, proposta | contexto pedagógico declarado |
| Organização da obra | tipos de seção, boxes e recursos | vocabulário editorial |
| Sumário | unidades, capítulos, seções e páginas | árvore editorial preliminar |
| Paratexto curricular | BNCC, competências, habilidades e TCT | extração estruturada e validação posterior |
| Corpo dos capítulos | conceitos, teorias, autores e argumentos | extração conceitual |
| Atividades | comandos, objetivos e operações cognitivas | análise pedagógica |
| Elementos visuais | mapas, gráficos, infográficos, imagens | extração multimodal no limite aprovado |
| Referências | obras, documentos e autores citados | procedência intelectual |
| Glossário e índices | termos e localizações | apoio à cartografia e reconciliação |
| Manual do professor | orientações, respostas e avaliação | trilha segregada e permissão específica |
| Anexos | dados e materiais complementares | classificação pelo conteúdo real |

O inventário deverá registrar, no mínimo, página física, página impressa quando observável, tipo de
região, confiança da classificação, método de detecção, estado de revisão e processamento exigido.

## 4. Capacidades operacionais e responsabilidades

### 4.1 Coordenação cartográfica

Responsável por:

- criar e versionar o mapa editorial preliminar;
- converter a hierarquia em plano de cobertura;
- distribuir unidades de trabalho sem romper contexto;
- acompanhar cobertura de página, região, seção, capítulo e obra;
- impedir encerramento com lacunas não decididas;
- consolidar árvore, manifesto e grafos candidatos.

### 4.2 Inspeção documental

Responsável por:

- validar formato, integridade, checksum e contagem de páginas;
- detectar páginas ausentes, duplicadas, rotacionadas, vazias ou ilegíveis;
- reconciliar paginação física e impressa;
- estimar necessidade de OCR ou tratamento visual;
- registrar limites de qualidade antes da extração.

### 4.3 Reconstrução estrutural

Responsável por:

- reconhecer unidades, capítulos, seções, subseções e continuidade;
- identificar boxes, tabelas, atividades, infográficos e outros recursos;
- descobrir títulos internos ausentes do sumário;
- validar ou corrigir fronteiras inicialmente estimadas.

### 4.4 Extração conceitual

Responsável por localizar, sem ainda transformar em componente canônico:

- conceitos e definições;
- teorias, correntes e autores;
- argumentos, problemas e controvérsias;
- causas, consequências e relações;
- exemplos, casos e acontecimentos;
- afirmações com necessidade de verificação.

### 4.5 Análise pedagógica

Responsável por identificar:

- objetivos e estratégias didáticas;
- atividades e perguntas;
- operações cognitivas exigidas;
- pré-requisitos e dificuldades frequentes;
- nível de complexidade;
- possibilidades de mediação e aplicação, ainda como candidatas.

### 4.6 Construção de relações

Responsável por propor arestas tipadas, justificadas e rastreáveis, sem criar ligações genéricas
apenas por similaridade superficial.

### 4.7 Análise curricular

Responsável por separar:

- vínculos declarados pela obra;
- indícios encontrados no conteúdo;
- vínculos propostos durante a análise;
- validação normativa;
- aprovação humana para uso no corpus.

### 4.8 Procedência e direitos

Responsável por conservar fonte, edição, arquivo, versão, página, região, bloco, permissão, evento de
permissão e regras de uso associadas a cada contribuição.

### 4.9 Crítica e controle de qualidade

Responsável por procurar:

- omissões e cobertura incompleta;
- resultados sem evidência;
- ligações artificiais;
- OCR incorreto ou estrutura tabular destruída;
- paráfrase excessivamente próxima;
- duplicidade e contradição;
- extrapolação curricular;
- mistura entre declaração editorial e validação do ProfePlan.

### 4.10 Curadoria humana

Responsável por aprovar, corrigir, rejeitar, suspender ou solicitar reprocessamento. No corpus piloto,
nenhum resultado gerativo poderá tornar-se elegível sem decisão humana registrada.

## 5. Plano de implantação por lote da Fase C

### 5.1 C.1 - Governança operacional do lifecycle de fontes

#### Ações a incorporar à futura definição

1. Tornar explícitas as diferenças entre obra, edição, manifestação bibliográfica, arquivo digital,
   versão do arquivo, execução de processamento e versão dos resultados.
2. Definir permissões por finalidade: armazenar, extrair, analisar, destilar, citar, recuperar e usar
   como evidência não deverão ser presumidas equivalentes.
3. Registrar eventos históricos de concessão, restrição, expiração, suspensão e revogação.
4. Definir a reação de todos os estados derivados quando uma permissão for reduzida ou revogada.
5. Vincular cada execução futura à permissão vigente no instante do processamento.
6. Definir retenção dos dados derivados e descarte verificável do arquivo-fonte, páginas
   renderizadas, recortes e demais artefatos temporários.
7. Classificar separadamente livro do estudante, manual do professor, anexos e materiais digitais.

#### Artefatos esperados

- contrato de identidade bibliográfica e documental;
- máquina de estados de fonte, versão e permissão;
- matriz finalidade x permissão;
- política de revogação e impacto derivado;
- política de retenção mínima, prazo de staging e descarte verificável;
- eventos append-only;
- critérios jurídicos para corpus piloto.

#### Critério adicional de saída

C.1 deverá provar que a autorização pode ser consultada e auditada em cada etapa posterior. Um
booleano atual de permissão não satisfará o gate.


### 5.2 C.2 - Ingestão controlada e handoff governado

#### Estado reconciliado

C.2 está concluído. Sua autoridade termina em staging temporário, integridade, vínculo,
idempotência, revisão humana e emissão do handoff read-only `APPROVED_FOR_EXTRACTION`. C.2 não
interpreta páginas, não localiza sumário, não constrói árvore editorial e não cria manifesto de
cobertura de extração.

#### Artefatos canônicos de C.2

- identidade composta sobre fonte e versão de C.1;
- artefato temporário com locator opaco, digest e política de retenção;
- run, receipts e events de ingestão;
- decisão humana e `IngestionHandoffEvidence` versionada;
- cleanup ou descarte verificável nos caminhos aplicáveis.

#### Limite de saída

O handoff prova que C.2 concluiu sua própria revisão, mas não prova autorização atual para executar
C.3, bytes ainda legíveis, qualidade textual, cobertura de páginas ou estrutura editorial. Essas
condições são verificadas pela autoridade própria de C.3.

### 5.3 C.3 - Extração nativa e validação observável

#### Ações delimitadas

1. Receber o handoff read-only de C.2 e criar identidade própria de run de extração.
2. Revalidar `purpose=extraction` no claim, na leitura/retomada do artefato e na finalização.
3. Ler o artefato por porta provider-neutral estreita, sem transformar locator opaco em URL pública.
4. Extrair prioritariamente a camada textual nativa de fixtures PDF inteiramente sintéticas.
5. Persistir incrementalmente páginas, ordem de leitura e elementos físicos observados.
6. Registrar método, versão do extrator, hash de entrada, proveniência e métricas por página/elemento.
7. Reconciliar cobertura esperada, extraída, rejeitada, pendente e descartada.
8. Encaminhar baixa qualidade, ausência de texto ou corrupção para decisão humana ou reprocessamento.
9. Preservar em tabelas as relações físicas de linhas, colunas e células apenas quando observadas e
   suportadas pelo adapter, sem inferir significado pedagógico.
10. Registrar imagens, mapas, gráficos e infográficos somente como marcadores observados, com tipo,
    ordem e localizador lógico; descrições geradas não pertencem ao baseline.
11. Manter OCR como fallback governado futuro, decidido em C.3.7; nenhum provedor OCR é autorizado
    por esta definição.
12. Emitir snapshot read-only versionado para C.4 somente após validação e cobertura completas.

#### Artefatos esperados

- run de extração, receipts e events próprios;
- páginas e elementos físicos observados;
- texto extraído/normalizado sem segmentação semântica;
- relações tabulares observadas quando disponíveis;
- métricas e reconciliação de cobertura;
- fila de exceções e decisões humanas;
- evidência de retenção/cleanup;
- handoff read-only `VALIDATED_FOR_SEGMENTATION` para C.4.

#### Critérios adicionais de saída

- nenhuma página elegível está ausente sem decisão registrada;
- texto nativo é tentado primeiro e a cobertura por método é explícita;
- nenhum OCR ocorre sem sublote, política, autorização e evidência próprios;
- baixa qualidade ou autorização inválida nunca avança silenciosamente;
- resultados mantêm proveniência lógica sem exigir persistência de coordenadas em pixels;
- chunks, segmentos, capítulos confirmados, classificação curricular e BNCC não são criados em C.3;
- PDF, renderizações, recortes e saídas brutas transitórias obedecem retenção e cleanup auditáveis.

### 5.4 C.4 - Reconstrução estrutural e notas candidatas

#### Ações a incorporar à futura definição

1. Confirmar ou corrigir a árvore preliminar com base no conteúdo extraído.
2. Segmentar por fronteira editorial antes de aplicar limites operacionais.
3. Classificar regiões e blocos por função editorial e informacional.
4. Gerar mapa de capítulo, unidade e obra.
5. Identificar conhecimentos candidatos e seus contextos, ainda sem promovê-los a componentes.
6. Produzir notas atômicas candidatas vinculadas a evidências.
7. Detectar referências cruzadas dentro da obra.
8. Reconciliar itens do sumário, títulos encontrados e segmentos gerados.

#### Tipologia estrutural mínima candidata

- metadado editorial;
- declaração jurídica;
- paratexto pedagógico;
- declaração curricular;
- conceito;
- definição;
- explicação;
- teoria ou corrente;
- autor;
- argumento ou controvérsia;
- exemplo ou caso;
- atividade ou questão;
- orientação ao professor;
- tabela ou gráfico estruturado; descrição semântica de mapa, imagem ou infográfico;
- referência bibliográfica.

#### Artefatos esperados

- árvore editorial validada;
- segmentos estruturais;
- notas atômicas candidatas;
- mapas de capítulo, unidade e obra;
- manifesto hierárquico reconciliado.

#### Critérios adicionais de saída

- cada segmento possui ancestralidade editorial e localização;
- cada nota candidata aponta para evidência verificável;
- recursos pedagógicos não são confundidos com exposição conceitual;
- a obra somente fecha quando capítulos e regiões periféricas estiverem reconciliados.

### 5.5 C.5 - Destilação multifonte, relações e deduplicação

#### Ações a incorporar à futura definição

1. Destilar contribuições autorais a partir de segmentos aprovados.
2. Comparar duas ou mais fontes autorizadas quando o piloto assim definir.
3. Separar consenso, complementaridade, divergência e controvérsia.
4. Criar arestas tipadas com evidência e justificativa.
5. Detectar notas duplicadas, próximas, complementares ou contraditórias.
6. Evitar que a sequência de uma única coleção se torne ontologia canônica.
7. Verificar similaridade autoral antes de promover uma síntese.
8. Submeter união, relação, manutenção separada ou rejeição à decisão humana.

#### Vocabulário inicial de relações candidatas

Relações editoriais:

- `PERTENCE_A`, `VEM_ANTES_DE`, `VEM_DEPOIS_DE`, `CONTINUA_EM`, `LOCALIZADO_EM`.

Relações conceituais:

- `DEFINE`, `EXEMPLIFICA`, `CONTRASTA_COM`, `DEPENDE_DE`, `APROFUNDA`, `QUESTIONA`,
  `APLICA`, `CAUSA`, `CONSEQUENCIA_DE`, `ASSOCIADO_A`.

Relações teóricas:

- `FORMULADO_POR`, `DEFENDIDO_POR`, `CRITICADO_POR`, `PERTENCE_A_CORRENTE`, `REVISA`,
  `SUPERA`.

Relações pedagógicas:

- `PRE_REQUISITO_DE`, `ADEQUADO_PARA`, `PODE_SER_ENSINADO_COM`, `POSSUI_ERRO_FREQUENTE`,
  `ADMITE_ATIVIDADE`, `EXIGE_MEDIACAO`.

Esse vocabulário será normativo somente após contrato próprio, validação contra o modelo de domínio
existente e aprovação humana. Não se autoriza criar enums ou schema a partir desta lista.

#### Artefatos esperados

- contribuições destiladas;
- relações candidatas justificadas;
- conjuntos de consenso e divergência;
- relatório de similaridade e autoria;
- decisões de deduplicação auditáveis.

#### Critérios adicionais de saída

- nenhuma relação é aceita apenas porque dois vetores ou termos são semelhantes;
- divergências não desaparecem na consolidação;
- sínteses preservam evidências sem reproduzir extensamente a fonte;
- toda decisão de fusão ou separação pode ser reconstruída.

### 5.6 C.6 - Componentização, grafo curricular e versionamento

#### Ações a incorporar à futura definição

1. Promover somente sínteses e relações aprovadas a componentes canônicos.
2. Manter árvore editorial, notas, componentes e relações como entidades distintas.
3. Versionar conteúdo, evidências, relações e vínculos curriculares.
4. Representar nós editoriais, conceituais, curriculares e de evidência.
5. Armazenar cada vínculo curricular com origem, estado, justificativa e revisão.
6. Validar códigos e descrições contra fontes normativas oficiais versionadas.
7. Localizar, no conteúdo, a seção, o conceito e a atividade que sustentam o vínculo.
8. Persistir pelas fronteiras transacionais aprovadas na Fase B.

#### Estados mínimos do vínculo curricular

```text
DECLARADO_PELA_OBRA
DETECTADO_NO_CONTEUDO
PROPOSTO_PELO_PROCESSAMENTO
VALIDADO_NORMATIVAMENTE
APROVADO_PELO_CURADOR
REJEITADO
SUSPENSO
```

Os nomes finais dependerão do contrato de C.6. A exigência normativa é preservar a distinção de
significado, não antecipar o enum.

#### Nós curriculares que não poderão ser colapsados

- Competência Geral da Educação Básica;
- Competência Específica de área;
- habilidade da BNCC;
- habilidade ou desdobramento do currículo estadual;
- unidade temática ou categoria equivalente;
- objeto de conhecimento;
- Tema Contemporâneo Transversal.

#### Artefatos esperados

- componentes e versões;
- arestas aprovadas;
- evidências completas;
- vínculos curriculares versionados;
- justificativas e estados de revisão;
- relatório de conformidade transacional.

#### Critérios adicionais de saída

- declaração da editora nunca aparece como validação independente;
- o professor poderá distinguir fonte, evidência e decisão do ProfePlan;
- nenhuma relação curricular genérica substitui os tipos normativos;
- versões rejeitadas ou suspensas ficam inelegíveis sem apagar histórico.

### 5.7 C.7 - Curadoria, cobertura e corpus piloto

#### Ações a incorporar à futura definição

1. Criar filas separadas para revisão estrutural, conceitual, pedagógica, curricular, jurídica e
   autoral.
2. Validar cobertura nos níveis lote, capítulo, unidade e obra.
3. Impedir aprovação da obra com seção, página ou região sem decisão.
4. Avaliar cobertura curricular e conceitual sem exigir distribuição artificialmente uniforme.
5. Aprovar, rejeitar, suspender, substituir ou solicitar reprocessamento.
6. Gerar manifesto imutável do corpus piloto.
7. Publicar somente componentes e relações elegíveis.
8. Registrar lacunas conhecidas para orientar retrieval e produção.

#### Hierarquia de consolidação obrigatória

```text
bloco/página -> lote -> seção -> capítulo -> unidade -> obra -> corpus piloto
```

Cada nível deverá avaliar continuidade, omissões, duplicidade, relações internas, confiança e
decisões pendentes.

#### Artefatos esperados

- rubricas de curadoria;
- decisões humanas auditáveis;
- relatórios de cobertura hierárquica;
- grafo e componentes elegíveis;
- manifesto versionado do corpus piloto;
- lista explícita de lacunas e exclusões.

#### Critérios adicionais de saída

- o corpus piloto contém 100-300 componentes revisados no escopo aprovado;
- todo componente elegível possui procedência e vínculo a evidência;
- toda relação elegível possui tipo, justificativa, confiança e revisão;
- nenhuma lacuna está oculta por uma taxa média de cobertura;
- a amostra está congelada e reproduzível para os experimentos da Fase D.

## 6. Estados da informação ao longo da Fase C

As seguintes camadas não poderão ser colapsadas em um único registro:

```text
arquivo recebido
-> representação temporária de extração
-> texto normalizado/bloco estruturado/descrição semântica
-> segmento estruturado
-> contribuição identificada
-> síntese destilada
-> nota atômica candidata
-> componente versionado
-> relação ou vínculo candidato
-> item revisado
-> item aprovado
-> item elegível para retrieval
```

Uma aprovação em uma camada não implica aprovação das seguintes. Texto extraído com alta confiança,
por exemplo, não é automaticamente correto, autoral, curricularmente válido ou elegível.

## 7. Requisitos transversais de evidência e versionamento

Cada resultado relevante deverá poder informar:

- qual obra, edição e arquivo o originou;
- qual execução e versão de processamento o produziu;
- qual página física e impressa o localiza;
- qual região, seção, bloco, tabela ou célula o sustenta;
- qual permissão estava vigente;
- qual método ou responsabilidade o produziu;
- qual confiança foi atribuída e por quê;
- quem revisou e qual decisão tomou;
- quais versões o sucederam ou substituíram.

Esses localizadores são lógicos e textuais. Não autorizam retenção permanente do PDF, da imagem da
página, do recorte, da miniatura ou de coordenadas visuais. Quando a validação depender da inspeção
visual, ela ocorrerá durante a janela temporária de staging e sua decisão será registrada antes do
descarte.

Relações deverão possuir identidade e histórico próprios. Alterar uma ligação conceitual ou
curricular não poderá exigir reescrever silenciosamente os nós conectados.

## 8. Impactos obrigatórios na Fase D - retrieval

A Fase D deverá usar o corpus como almoxarifado estruturado, não como um diretório de chunks.

### Ações futuras

1. Definir filtros determinísticos por disciplina, etapa, ano, currículo, tipo, status, permissão e
   versão antes da similaridade.
2. Avaliar recuperação hierárquica: obra, capítulo, seção, componente e evidência.
3. Avaliar campos separados para busca lexical, estrutural, semântica e por relações.
4. Impedir que embeddings de trechos protegidos sejam a única representação recuperável.
5. Criar pacotes de contexto que incluam conhecimentos, relações, evidências mínimas e alertas de
   divergência.
6. Detectar insuficiência, cobertura parcial e conflito entre fontes.
7. Medir se o grafo melhora precisão e economia em relação a chunks planos.

### Experimentos obrigatórios

- busca plana por chunks versus recuperação por componentes;
- recuperação sem relações versus recuperação com vizinhança tipada;
- contexto de uma única fonte versus síntese multifonte;
- recuperação apenas semântica versus filtros + lexical + semântica + reranking;
- diferentes níveis de expansão do grafo dentro do mesmo budget de tokens.

### Gate adicional D -> E

Antes de ativar agentes, deverá estar comprovado que o pacote de contexto não perde procedência,
não mistura anos ou disciplinas, sinaliza insuficiência e cabe no orçamento definido.

## 9. Impactos obrigatórios na Fase E - fábrica de agentes

Somente na Fase E as responsabilidades especializadas poderão ser avaliadas como agentes
executáveis.

### Ações futuras

1. Definir um Coordenador de Produção separado do pipeline de ingestão.
2. Impedir que o Sócrates 2 reabra livros inteiros em cada solicitação.
3. Entregar ao agente apenas o pacote de contexto aprovado pela Fase D.
4. Definir capacidade explícita de pedir evidência adicional sem ampliar indiscriminadamente o
   domínio.
5. Versionar prompts, ferramentas, políticas e modelos.
6. Aplicar validadores conceitual, pedagógico, curricular, autoral e de inclusão.
7. Bloquear geração quando o corpus for insuficiente ou conflitante além do limite aprovado.

O Cartógrafo da Obra pertence ao pipeline interno de construção do conhecimento. O Orquestrador da
Fase E pertence à produção pedagógica. Eles não deverão ser fundidos em um agente onisciente.

## 10. Impactos obrigatórios na Fase F - piloto controlado

O piloto continua restrito a Filosofia, 2º ano do Ensino Médio, Minas Gerais, Sócrates 2 e 100-300
componentes curados. O livro de Sociologia usado na discussão é evidência de requisitos
arquitetônicos, não autorização para alterar a disciplina piloto.

### Ações futuras

1. Selecionar duas ou três fontes autorizadas com organizações diferentes.
2. Trabalhar com recorte limitado de capítulos e nós curriculares.
3. Verificar se sequências editoriais distintas convergem para componentes comuns sem apagar
   contribuições particulares.
4. Produzir os quatro produtos mínimos usando o mesmo corpus congelado.
5. Comparar Sócrates 2 e agente genérico em casos pareados.
6. Medir qualidade, aderência, criatividade, reprodução indevida, tokens, custo e latência.
7. Auditar se cada produto pode ser explicado por componentes e evidências aprovados.

### Critérios adicionais F -> G

- ganho mensurável sobre o baseline genérico;
- ausência de dependência de releitura integral das fontes;
- rastreabilidade suficiente sem expor conteúdo protegido;
- sequência didática não indevidamente copiada de uma única obra;
- custo e latência compatíveis com o produto.

## 11. Impactos obrigatórios na Fase G - escala

A escala somente poderá ocorrer depois de validar o modelo no piloto.

### Ações futuras

1. Medir reutilização de conceitos entre 1º, 2º e 3º anos sem misturar nível de complexidade.
2. Avaliar novas disciplinas após estabilizar taxonomias e relações.
3. Introduzir novo pacote curricular sem duplicar o grafo conceitual.
4. Escalar ingestão, OCR e multimodalidade apenas com métricas de cobertura e custo.
5. Automatizar curadoria somente nos pontos em que o piloto demonstrar risco aceitável.
6. Preservar segregação entre corpus global, currículo ativo e contexto do professor.
7. Manter RS, Gráfica avançada, PDF/PPTX sofisticados, novas fábricas e EPIC-018 bloqueados até seus
   gates próprios.

## 12. Matriz resumida de implantação

| Decisão | C.1 | C.2 | C.3 | C.4 | C.5 | C.6 | C.7 | Posterior |
|---|---:|---:|---:|---:|---:|---:|---:|---|
| Identidade, versão e permissão | X | X | X | X | X | X | X | auditoria contínua |
| Cartografia editorial |  |  | observação física | autoridade semântica |  |  | X | navegação/retrieval |
| Manifesto de cobertura |  |  | X | X | X | X | X | observabilidade |
| Extração tabular e paratextos |  |  | relações observadas | interpretação estrutural |  | X | X | validação curricular |
| Notas atômicas |  |  |  | X | X | X | X | retrieval |
| Relações tipadas |  |  |  | candidato | X | X | X | grafo e agentes |
| Separação curricular por estado |  |  |  | X | X | X | X | validação/produção |
| Destilação multifonte |  |  |  |  | X | X | X | produção autoral |
| Curadoria hierárquica |  |  | revisão | revisão | revisão | revisão | X | escala controlada |

## 13. Gates não compensatórios

Os seguintes gates são bloqueantes e não poderão ser compensados por boa qualidade média em outra
dimensão:

- fonte sem permissão compatível;
- página ou região sem decisão de cobertura;
- contribuição sem evidência;
- tabela com relações de coluna destruídas;
- síntese com reprodução indevida;
- vínculo curricular sem tipo ou origem;
- relação sem justificativa;
- item sem revisão exigida;
- versão suspensa ou revogada;
- mistura de disciplina, etapa, ano ou Estado fora do escopo.

## 14. Riscos e controles

| Risco | Consequência | Controle obrigatório |
|---|---|---|
| Tratar sumário como estrutura completa | omissões de boxes e paratextos | reconciliação sumário-corpo-layout |
| Parar após poucas páginas | corpus incompleto apresentado como integral | manifesto e gate de cobertura |
| OCR linearizar tabela | códigos associados à coluna errada | extração por célula e revisão visual |
| Confundir declaração da editora com validação | falsa aderência curricular | estados e evidências separados |
| Vetorizar tudo sem estrutura | custo, ruído e baixa explicabilidade | estrutura canônica antes do índice |
| Copiar sequência de uma coleção | dependência editorial e baixa autoria | destilação multifonte e grafo independente |
| Criar relações por proximidade superficial | teia ruidosa | vocabulário tipado, evidência e curadoria |
| Transformar papéis em agentes prematuros | perda de controle e custo | runtime agêntico bloqueado até Fase E |
| Revogar fonte sem propagar impacto | novos usos indevidos | lifecycle histórico e elegibilidade derivada |
| Automatizar aprovação cedo demais | erro pedagógico/jurídico em escala | curadoria humana obrigatória no piloto |
| Reter PDFs, páginas ou recortes após a extração | custo, risco jurídico e duplicação desnecessária | staging temporário, minimização e recibo de descarte |
| Vetorizar representações redundantes | crescimento desnecessário e ruído de retrieval | embeddings seletivos apenas para unidades aprovadas |

## 15. Próximas ações documentais autorizáveis

Sem iniciar implementação, a ordem documental recomendada permanece:

1. revisar este plano em conjunto com o mapa integral da Fase C;
2. integrar o pacote documental de C.0 por decisão humana;
3. criar checkpoint pós-merge;
4. autorizar separadamente a definição documental de C.1;
5. em C.1, incorporar identidade, finalidade de uso, revogação e impacto derivado;
6. somente após o gate de C.1, definir C.2 com manifesto, cartografia preliminar e inventário de
   regiões;
7. manter C.3-C.7 e Fases D-G bloqueadas até seus próprios gates.

## 16. Critério de sucesso deste plano

Este plano terá sido implantado corretamente quando o ProfePlan puder demonstrar, para qualquer
componente elegível:

> de qual fonte autorizada surgiu, onde a contribuição foi localizada, qual parte da obra foi
> processada, como o conhecimento foi destilado, com quais outros conhecimentos se relaciona, qual
> vínculo curricular foi declarado ou validado, quem aprovou e por que ele pode ser recuperado por
> um agente sem reabrir indiscriminadamente a obra original.

O sucesso também exige demonstrar que o arquivo-fonte e todas as representações visuais transitórias
foram descartados após a validação, sem perda da procedência lógica dos dados derivados.

Esse é o fundamento do almoxarifado inteligente: conhecimento preparado, conectado, econômico e
auditável, sem substituir a autoria docente nem transformar livros em respostas prontas.
