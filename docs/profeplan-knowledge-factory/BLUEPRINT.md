# ProfePlan Knowledge Factory — Blueprint de Execução

Data de consolidação inicial: 7 de agosto de 2026.

Estado de navegação atualizado em 18 de agosto de 2026.

Reconciliação arquitetônica vigente:
[`12-delivery/PHASE-C-VERTICAL-CARTOGRAPHY-RECONCILIATION.md`](12-delivery/PHASE-C-VERTICAL-CARTOGRAPHY-RECONCILIATION.md).

## 1. Finalidade

Este Blueprint apresenta a trilha macro de construção da ProfePlan Knowledge Factory desde a fundação arquitetônica até o corpus pedagógico, retrieval, agentes especializados, piloto e escala.

Ele existe para manter uma visão única de:

- capacidades já integradas;
- fronteiras entre fases e lotes;
- caminho principal de transformação de fontes em conhecimento pedagógico;
- gates técnicos, jurídicos e humanos;
- próximos passos elegíveis.

O histórico detalhado de branches, commits, PRs, incidentes e decisões intermediárias permanece nos ADRs, definições de lote e checkpoints. O Blueprint deve privilegiar o **estado atual e a direção arquitetônica**, não repetir integralmente o histórico do repositório.

Este documento:

- não substitui ADRs, contratos, definições de lote ou critérios de aceite;
- não autoriza produção por si só;
- não transforma planejamento em autorização implícita;
- registra a ordem funcional recomendada;
- deve ser atualizado quando a experiência prática revelar contradições na sequência de execução.

## 2. Princípio central

A Knowledge Factory é construída em camadas de responsabilidade, mas **uma obra não precisa atravessar uma camada inteira antes que a próxima responsabilidade possa orientar seu processamento**.

A sequência conceitual continua sendo:

```text
CONTRATOS
  ↓
DOMÍNIO
  ↓
PERSISTÊNCIA E SEGURANÇA
  ↓
MATÉRIA-PRIMA GOVERNADA
  ↓
CARTOGRAFIA E ESTRUTURA
  ↓
CONHECIMENTO PEDAGÓGICO
  ↓
COMPONENTES E GRAFO
  ↓
INDEXAÇÃO E RETRIEVAL
  ↓
AGENTES
  ↓
PRODUÇÃO PEDAGÓGICA
  ↓
CONTROLE DE QUALIDADE
  ↓
PILOTO
  ↓
ESCALA
```

Regra permanente:

> O agente de produção trabalha com conhecimento pedagógico previamente preparado e recuperado de forma controlada; ele não reabre indiscriminadamente livros, currículos ou todo o acervo a cada pedido do professor.

Regra complementar da Fase C:

> **A obra é um contêiner documental e pedagógico; não é a unidade semântica de processamento. Primeiro compreendemos sua forma, depois aprofundamos cada parte e, por fim, conectamos o conhecimento.**

## 3. Visão industrial

A metáfora operacional oficial permanece:

- ProfePlan: loja e central de entrega;
- fontes originais: matérias-primas brutas;
- estrutura editorial e conhecimento extraído: matéria-prima preparada;
- componentes pedagógicos estruturados: matérias-primas semielaboradas;
- repositório de componentes e relações: almoxarifado inteligente;
- agentes especializados: fábricas;
- agente coordenador de produção: central de produção;
- validadores: controle de qualidade;
- Gráfica: acabamento editorial;
- material final: produto entregue ao professor.

A coordenação cartográfica da Fase C pertence à construção do conhecimento e não deve ser confundida com o orquestrador de produção da Fase E.

## 4. Estado macro atual

Base canônica de referência desta atualização: `main@c7cea4b7d0e4c12182a28fa85a4a2ad8f57b282e`.

```text
FASE A — FUNDAÇÃO
✅ contratos
✅ domínio e portas
✅ banco, schema e RLS

FASE B — CONEXÃO COM O BANCO
✅ adapters essenciais integrados
✅ fronteiras transacionais críticas comprovadas
✅ Fase B encerrada por bloqueio parcial controlado

FASE C — MATÉRIA-PRIMA E CONSTRUÇÃO DO CONHECIMENTO
✅ C.0 definição integral e governança
✅ C.1 lifecycle de fontes — C.1.1–C.1.6
✅ C.2 ingestão controlada — C.2.1–C.2.6
✅ C.3.1 contratos/lifecycle/fixtures
✅ C.3.2 control plane persistente e segurança
✅ C.3.3 porta do artefato e extração textual nativa
✅ C.3.4 persistência incremental e reconciliação física
✅ C.3.5 qualidade, policy e revisão humana
⏸ C.3.6 recovery/concorrência/cancelamento/cleanup — PR #110 aberto, não integrado, suspenso para reconciliação
⬜ protocolo de reconhecimento estrutural da obra — próximo caminho principal
⬜ golden sample estrutural sintético
⬜ primeira prova vertical por parte (`Introdução`)
⬜ C.3.7 recuperação multimodal e fallback visual — não iniciar ainda
⬜ C.3.8 fechamento integrado — redefinir após prova vertical
⬜ C.4 reconstrução estrutural confirmada
⬜ C.5 destilação, relações e deduplicação
⬜ C.6 componentes, grafo curricular e versionamento
⬜ C.7 curadoria e corpus piloto

FASE D — INTELIGÊNCIA DO ALMOXARIFADO
⬜ filtros e busca estruturada
⬜ embeddings seletivos
⬜ busca híbrida
⬜ reranking
⬜ context budget
⬜ custo e latência

FASE E — FÁBRICA
⬜ runtime de agentes
⬜ Sócrates 2
⬜ orquestrador
⬜ produção autoral
⬜ validadores

FASE F — PILOTO
⬜ corpus inicial de 100–300 componentes
⬜ Filosofia / 2º ano / MG
⬜ quatro produtos pedagógicos
⬜ comparação com baseline genérico

FASE G — ESCALA
⬜ outros anos
⬜ outras disciplinas
⬜ novos currículos
⬜ gráfica avançada
⬜ novas fábricas e capacidades
```

## 5. Fases A e B — fundação já estabelecida

As Fases A e B permanecem concluídas dentro de seus limites aprovados.

Capacidades relevantes já disponíveis:

- linguagem de domínio versionada;
- contratos compartilhados;
- portas abstratas de repositório;
- schema `kf_*` e constraints;
- RLS deny-by-default;
- eventos append-only;
- adapters Supabase controlados;
- escritas transacionais por fronteiras estreitas;
- ambiente descartável para testes de banco;
- ProductionOrderRepository e PedagogicalComponentRepository nas superfícies já aprovadas.

Gaps ainda contidos:

- `GAP-3B-05` — auditoria enriquecida;
- `GAP-3B-07` — OPP normativa completa nas capacidades que pertencem a retrieval, agentes e entrega.

`GAP-3B-04` foi encerrado pelo fechamento de C.1.

## 6. Fase C — resultado esperado

A Fase C transforma fontes autorizadas em conhecimento pedagógico estruturado, rastreável, curado e elegível para futura recuperação.

Ela **não** deve terminar em uma coleção de PDFs, páginas, chunks ou resumos soltos.

Seu resultado coordenado deverá conservar quatro representações:

```text
ÁRVORE EDITORIAL
onde cada conteúdo está e a que parte pertence

MANIFESTO DE COBERTURA
o que foi processado, rejeitado, reprocessado ou permanece pendente

GRAFO DE CONHECIMENTO
como conceitos, teorias, autores, problemas e exemplos se relacionam

GRAFO PEDAGÓGICO-CURRICULAR
como conhecimentos, atividades, orientações docentes e currículo se relacionam
```

O vetor será índice de recuperação, não fonte canônica.

## 7. Princípios de processamento de obras

### 7.1 A obra não é um bloco

Nenhum livro completo deverá ser enviado como um único contexto semântico nem tratado como uma sequência cega de páginas.

A obra é primeiro cartografada e depois processada por partes editoriais coerentes.

### 7.2 Cartografia antes do aprofundamento

Antes da análise semântica aprofundada, procurar quando disponíveis:

- nome do arquivo;
- capa;
- folha de rosto;
- ficha catalográfica;
- créditos/expediente;
- apresentação;
- seção `Conheça seu livro`, `Organização da obra`, `Como usar este livro` ou equivalente;
- sumário/índice;
- paratextos curriculares;
- início do corpo principal;
- Manual do Professor e regiões finais.

Essa inspeção cria uma **árvore preliminar**, não uma hierarquia canônica definitiva.

### 7.3 Nome do arquivo é pista

Devem ser distinguidas conceitualmente:

```text
filename_hints
  -> pistas derivadas do nome do arquivo

detected_metadata
  -> dados observados no documento

canonical_metadata
  -> metadados reconciliados
```

Nome de arquivo nunca substitui identidade bibliográfica ou jurídica.

### 7.4 Dupla paginação

A Knowledge Factory deverá diferenciar:

- página física do arquivo/PDF;
- página impressa/editorial;
- rótulo de página quando aplicável;
- confiança e método de correspondência.

Deslocamentos entre página PDF e página impressa são comportamento normal de livros, não exceção.

### 7.5 Gramática editorial da coleção

Quando a obra explicar sua própria organização, essa região deve ser processada cedo porque fornece vocabulário para reconhecer boxes, atividades, infográficos, biografias, glossários e outros recursos.

Os nomes declarados pela coleção são preservados como tipos editoriais observados; a ontologia canônica do ProfePlan pode posteriormente mapeá-los sem apagar a terminologia original.

### 7.6 Manual do Professor

Orientações, respostas esperadas, mediação, avaliação e referências internas do Manual do Professor são conhecimento pedagógico estruturalmente relevante.

O sistema deverá poder relacionar, quando houver evidência:

```text
conteúdo/atividade
  -> questão/comando
  -> resposta ou expectativa
  -> orientação ao professor
  -> mediação/avaliação
  -> conceito/currículo relacionado
```

### 7.7 Elementos visuais

O caminho futuro distingue:

```text
texto nativo
  -> padrão

compreensão multimodal
  -> elemento visual com função informacional/pedagógica

OCR localizado
  -> texto relevante não recuperável nativamente
```

OCR não é etapa obrigatória de livros editoriais com camada textual adequada.

## 8. Modelo operacional vertical da Fase C

As responsabilidades continuam separadas em C.3–C.7, mas o processamento da obra ocorre verticalmente por partes.

### Passagem 1 — cartografia preliminar

```text
arquivo governado
  ↓
identidade e pistas
  ↓
regiões preliminares
  ↓
sumário/organização
  ↓
paginação física x impressa
  ↓
árvore candidata
  ↓
plano de partes
```

### Passagem 2 — ciclo por parte

```text
parte delimitada
  ↓
extração observável — C.3
  ↓
reconstrução estrutural — C.4
  ↓
contribuições e relações candidatas — C.4/C.5 conforme autorização
  ↓
reconciliação e revisão
  ↓
próxima parte
```

A passagem por C.4/C.5 só ocorre quando seus contratos e gates estiverem aprovados; o modelo vertical não autoriza antecipação material. Ele apenas remove a exigência artificial de terminar o livro inteiro em C.3 antes de usar informação estrutural para orientar o próprio processamento.

### Passagem 3 — consolidação da obra

```text
partes reconciliadas
  ↓
árvore confirmada
  ↓
relações entre partes
  ↓
destilação/deduplicação
  ↓
componentes e grafo curricular
  ↓
curadoria
```

## 9. Estado e fronteira de C.3

C.3.1–C.3.5 estão integrados e permanecem válidos como infraestrutura de evidência observável.

C.3 tem autoridade sobre:

- runs de extração;
- autorização temporal de extração;
- leitura provider-neutral do artefato;
- páginas físicas;
- texto nativo;
- elementos observados;
- proveniência;
- persistência incremental;
- métricas e cobertura física;
- qualidade e revisão humana de extração.

C.3 não transforma observação em conhecimento pedagógico canônico.

A cartografia preliminar poderá usar observações de sumário, títulos, marcadores e regiões para orientar execução. A confirmação da hierarquia pertence a C.4.

### C.3.6

O PR #110 permanece aberto e não integrado. Seu hardening de recovery, concorrência, cancelamento e cleanup não foi descartado, mas está suspenso até a prova vertical revelar como essa infraestrutura deve se encaixar no processamento por partes.

### C.3.7

Não iniciar como “módulo de OCR”. A futura definição deve tratar **recuperação multimodal e fallback visual**, da qual OCR localizado é apenas uma possível técnica.

### C.3.8

Deverá ser reconciliado depois da primeira prova vertical; não deve pressupor que o único E2E relevante seja processar horizontalmente uma obra inteira até um handoff monolítico para C.4.

## 10. C.4 — reconstrução estrutural

C.4 permanece responsável por:

- confirmar ou corrigir a árvore preliminar;
- segmentar por fronteiras editoriais;
- classificar regiões e elementos por função;
- identificar notas/contribuições candidatas;
- reconciliar sumário, títulos e corpo;
- produzir mapas confirmados de seção, capítulo, unidade e obra.

A árvore preliminar anterior a C.4 é uma hipótese operacional rastreável, não autoridade canônica.

## 11. C.5 — destilação, relações e deduplicação

C.5 deverá:

- destilar contribuições autorais;
- preservar consenso, complementaridade, divergência e controvérsia;
- criar relações tipadas com evidência;
- evitar que a sequência de uma única coleção vire ontologia canônica;
- detectar duplicidade e proximidade;
- manter decisão humana no corpus piloto.

## 12. C.6 — componentes e grafo curricular

C.6 promove apenas resultados aprovados a componentes canônicos.

Deverá manter distintos:

- declaração curricular da obra;
- detecção no conteúdo;
- proposta do processamento;
- validação normativa;
- aprovação humana.

Informação editorial explícita tem precedência sobre uma inferência gerativa sobre “o que a editora quis dizer”, mas não equivale à validação independente do ProfePlan.

## 13. C.7 — curadoria e corpus piloto

C.7 fecha a Fase C quando houver:

- cobertura hierárquica reconciliada;
- componentes e relações revisados;
- procedência e permissões confiáveis;
- lacunas explícitas;
- manifesto reproduzível do corpus piloto;
- 100–300 componentes revisados no escopo aprovado;
- autorização humana para iniciar experimentos da Fase D.

## 14. Próxima prova obrigatória

Antes de novo hardening de exceções, criar um **golden sample estrutural inteiramente sintético** contendo:

- filename informativo;
- capa e ficha sintéticas;
- seção de organização da obra;
- sumário;
- paginação física diferente da impressa;
- uma `Introdução`;
- títulos e subtítulos;
- texto expositivo original;
- elemento visual sintético com legenda;
- atividade;
- orientação docente relacionada;
- declaração curricular sintética;
- região final de Manual do Professor.

Primeira prova vertical:

```text
arquivo sintético
  -> reconhecer identidade
  -> localizar estrutura
  -> construir árvore preliminar
  -> selecionar somente `Introdução`
  -> extrair a parte
  -> reconstruir títulos/subtítulos/elementos
  -> manter relações texto-visual-atividade-orientação
  -> reconciliar cobertura da parte
  -> produzir saída revisável
```

Não processar o livro sintético inteiro como um único contexto.

## 15. Fase D — inteligência do almoxarifado

A recuperação deverá seguir, em princípio:

```text
filtros determinísticos
  ↓
busca lexical/estruturada
  ↓
busca semântica seletiva
  ↓
fusão/reranking
  ↓
checagem de suficiência
  ↓
pacote de contexto
```

Embeddings serão escolhidos por experimento e servirão à recuperação, não à canonicidade do conhecimento.

Métricas mínimas:

- precisão;
- recall;
- relevância pedagógica;
- mistura indevida de ano/componente/currículo;
- latência;
- tokens;
- custo;
- taxa de insuficiência detectada corretamente.

## 16. Fase E — fábrica de agentes

Só depois de retrieval mensurável ativaremos runtime agêntico de produção.

O primeiro perfil permanece Sócrates 2, com escopo piloto de Filosofia, Ensino Médio, 2º ano e currículo de Minas Gerais.

Contexto previsto:

```text
IDENTIDADE
+ ESCOPO
+ CURRÍCULO ATIVO
+ CONTEXTO DO PROFESSOR/TURMA
+ QUERY PLAN
+ COMPONENTES RECUPERADOS
+ POLÍTICAS DE QUALIDADE
+ ORÇAMENTO DE TOKENS
```

O orquestrador de produção não deve reabrir livros inteiros para responder ao professor.

## 17. Fase F — piloto controlado

Escopo estratégico permanece:

- Filosofia;
- 2º ano do Ensino Médio;
- Minas Gerais;
- Sócrates 2;
- 100–300 componentes pedagógicos revisados.

Produtos mínimos:

1. plano de aula;
2. texto didático;
3. atividade reflexiva;
4. avaliação formativa curta.

Comparação obrigatória com baseline genérico, medindo qualidade, aderência curricular, criatividade, alucinação, mistura de escopo, tokens, latência e custo.

## 18. Fase G — escala

Somente depois do piloto:

1. ampliar anos da disciplina validada;
2. validar reutilização do runtime;
3. adicionar disciplina;
4. expandir currículos;
5. ampliar produtos;
6. introduzir acabamento gráfico avançado;
7. escalar novas fábricas.

Integrações externas não são incorporadas por novidade tecnológica. Nexus, Evolution ou qualquer outra plataforma somente entram quando houver aderência arquitetônica e contribuição concreta mensurável para o ProfePlan.

## 19. Produção é trilha separada

Nenhum lote técnico autoriza automaticamente:

- migration em banco hospedado real;
- `service_role` real;
- wiring de API de produção;
- ativação no frontend;
- processamento de fonte real protegida;
- exposição de agentes a professores.

Produção exige gate próprio, análise de alvo, drift, backup/pre-flight, rollback, segurança e autorização humana explícita.

## 20. Governança proporcional ao risco

Manter documentação antes do código, mas evitar microgovernança que não reduz risco real.

Fluxo normal:

```text
DEFINIR A FRONTEIRA
  ↓
DOCUMENTAR O COMPORTAMENTO PRINCIPAL
  ↓
APROVAR
  ↓
IMPLEMENTAR EM BRANCH/PR
  ↓
TESTAR
  ↓
REVISAR
  ↓
MERGE HUMANO QUANDO APLICÁVEL
  ↓
REGISTRAR CONTINUIDADE QUANDO HOUVER GANHO REAL
```

Fixtures, testes, correções necessárias ao próprio gate e reexecuções de CI dentro de escopo aprovado não devem exigir nova autorização por microação.

## 21. Regra de continuidade de conversas

Trocar de conversa em marcos naturais, especialmente quando houver:

- integração de mudança arquitetônica relevante;
- mudança de natureza entre documentação e implementação;
- fechamento de uma prova vertical;
- crescimento de contexto que dificulte manter decisões e estado técnico.

Antes da troca, registrar de forma suficiente:

- estado canônico;
- branch/PR;
- decisões tomadas;
- pendências;
- próximo objetivo;
- escopo explicitamente bloqueado.

Não criar checkpoint apenas para obedecer ritual quando o PR, a documentação e o estado canônico já preservarem continuidade suficiente.

## 22. Próximo objetivo oficial

A prioridade atual não é C.3.7 nem novo hardening de exceções.

A ordem é:

```text
1. reconciliar documentalmente a Fase C com cartografia vertical;
2. definir o Protocolo de Reconhecimento Estrutural da Obra;
3. criar golden sample sintético;
4. provar cartografia preliminar;
5. executar primeira prova vertical somente da `Introdução`;
6. revisar lacunas concretas;
7. decidir como absorver/corrigir C.3.6;
8. decidir recuperação multimodal/OCR com base em necessidade demonstrada;
9. preparar, em fronteira própria, o primeiro conteúdo real juridicamente autorizado.
```

Regra de síntese:

> **Primeiro provar o caminho principal da construção do conhecimento; depois endurecer exceções, concorrência e fallbacks que esse caminho demonstrar precisar.**
