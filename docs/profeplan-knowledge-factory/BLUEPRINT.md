# ProfePlan Knowledge Factory — Blueprint de Execução

Data de consolidação inicial: 7 de agosto de 2026.

Estado de navegação atualizado em 15 de agosto de 2026.

## 1. Finalidade

Este documento apresenta a trilha macro de construção da ProfePlan Knowledge Factory desde a fundação arquitetônica até o piloto operacional do agente Sócrates 2 e a expansão posterior.

Seu objetivo é reduzir ambiguidade entre Marcos, Lotes, sublotes, Pull Requests, Stories e checkpoints, oferecendo uma visão única da sequência de capacidades.

Este Blueprint:

- não substitui ADRs, definições de Lote, Stories, critérios de aceite ou checkpoints;
- não autoriza por si só qualquer implementação futura;
- não altera gates de produção;
- registra o estado atual e a ordem funcional recomendada;
- distingue etapas já formalizadas de frentes futuras ainda sujeitas a definição documental e aprovação humana.

## 2. Princípio central

A Knowledge Factory será construída em camadas. Nenhuma camada posterior deve compensar uma fundação incompleta da camada anterior.

A sequência conceitual é:

```text
CONTRATOS
  ↓
DOMÍNIO
  ↓
PERSISTÊNCIA E RLS
  ↓
ADAPTERS
  ↓
MATÉRIA-PRIMA
  ↓
COMPONENTES PEDAGÓGICOS
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

Regra arquitetônica permanente:

> O agente trabalha com matéria-prima pedagógica preparada e recuperada de forma controlada; ele não vasculha indiscriminadamente livros, currículos ou todo o acervo a cada solicitação do professor.

## 3. Visão industrial

A metáfora operacional oficial continua sendo:

- ProfePlan: loja e central de entrega;
- fontes originais: matérias-primas brutas;
- componentes pedagógicos estruturados: matérias-primas semielaboradas;
- repositório de componentes: almoxarifado inteligente;
- agentes especializados: fábricas;
- agente coordenador: central de produção;
- validadores: controle de qualidade;
- Gráfica: acabamento editorial;
- material final: produto pedagógico entregue ao professor.

## 4. Estado macro atual

```text
FASE A — FUNDAÇÃO
✅ Contratos
✅ Domínio e portas
✅ Banco, schema e RLS

FASE B — CONEXÃO COM O BANCO
✅ 3B.1 AuditRepository
✅ 3B.2 KnowledgeSourceRepository
✅ 3B.3 CurriculumRepository
✅ 3B.4 PedagogicalComponentRepository — leituras e escritas transacionais integradas
✅ 3B.5 ProductionOrderRepository — 3B.5.1–3B.5.4 integrados e encerramento documentado
✅ Gate de saída da Fase B — bloqueio parcial controlado formalizado no Checkpoint 032

FASE C — C.1 E C.2 CONCLUÍDOS; C.3 DEFINIDO EM PROPOSTA DOCUMENTAL  ← ESTADO DESTE DRAFT PR

FASE C — MATÉRIA-PRIMA
✅ C.0 Definição integral, governança e gates — integrado pelo PR nº 31
✅ C.1 Governança operacional do lifecycle de fontes — C.1.1–C.1.6 concluídos
✅ C.2 Ingestão controlada — C.2.1–C.2.6 concluídos; Checkpoint 050
📝 C.3 Extração e validação — fronteira e C.3.1–C.3.8 propostos; execução técnica bloqueada
⬜ C.4 Segmentação e classificação estrutural
⬜ C.5 Destilação pedagógica e deduplicação
⬜ C.6 Componentização, versionamento e vínculo curricular
⬜ C.7 Curadoria, corpus piloto e gate C → D

FASE D — INTELIGÊNCIA DO ALMOXARIFADO
⬜ Estratégia de embeddings
⬜ Indexação
⬜ Busca híbrida
⬜ Reranking
⬜ Context budget
⬜ Medição de custo e latência

FASE E — FÁBRICA
⬜ Runtime de agentes
⬜ Perfil Sócrates 2
⬜ Orquestrador
⬜ Produção autoral
⬜ Validação

FASE F — PILOTO
⬜ Corpus inicial de 100–300 componentes
⬜ Filosofia / 2º ano / MG
⬜ Quatro produtos pedagógicos
⬜ Comparação com agente genérico

FASE G — ESCALA
⬜ Outros anos
⬜ Outras disciplinas
⬜ Rio Grande do Sul
⬜ Gráfica avançada
⬜ Novas fábricas e capacidades
```

## 5. Fase A — Fundação

### Status

Concluída.

### Capacidades estabelecidas

- contratos compartilhados e versionados;
- enums e invariantes;
- domínio puro da Knowledge Factory;
- políticas determinísticas;
- portas abstratas de repositório;
- schema físico `kf_*`;
- constraints e FKs;
- RLS deny-by-default;
- isolamento inicial da OPP por requester;
- eventos append-only;
- ambiente Supabase descartável para validação.

### Resultado da fase

A Knowledge Factory possui linguagem de domínio, fronteiras e persistência física suficientes para iniciar adapters sem acoplar regra pedagógica ao Supabase.

## 6. Fase B — Conexão com o banco

### Status

Concluída por bloqueio parcial controlado no Checkpoint 032. `GAP-3B-05` e `GAP-3B-07`
permanecem ativos e contidos. `GAP-3B-04`, que estava contido na saída da Fase B, foi posteriormente
encerrado pelo fechamento governado do Lote C.1 em C.1.6 e no Checkpoint 043.

### Objetivo

Implementar adapters Supabase para as portas existentes, preservando domínio puro, injeção de clients, privilégios explícitos, erros provider-neutral, observabilidade sanitizada e testes fora de produção.

### 6.1 — 3B.1 AuditRepository

Status: concluído e validado.

Provou:

- package boundary;
- SYSTEM client injetado;
- mapper SQL ↔ domínio;
- INSERT append-only;
- erro provider-neutral;
- telemetria sanitizada;
- testes unitários;
- integração em Supabase descartável;
- uso controlado do CI de banco.

O GAP-3B-05 permanece ativo para auditoria enriquecida.

### 6.2 — 3B.2 KnowledgeSourceRepository

Status: concluído e integrado.

Objetivo:

- implementar leitura das fontes dentro da porta existente;
- implementar `save(source)` dentro dos limites aprovados;
- preservar procedência e autorização;
- não inventar ingestão completa;
- não criar versionamento, segmentos ou permission events além da superfície aprovada.

Restrição histórica desta etapa:

- GAP-3B-04 — lifecycle de fonte incompleto para ingestão.

Estado posterior: **encerrado em C.1.6**, após o lifecycle necessário à ingestão ter sido definido,
persistido, protegido, adaptado, testado e integrado. A menção histórica a segmentos não antecipa
C.4, lote canônico de segmentação e classificação.

Interpretação operacional:

> Esta etapa cria a ficha e a porta de persistência da matéria-prima; ainda não inicia o processamento de livros ou PDFs.

### 6.3 — 3B.3 CurriculumRepository

Status: concluído e integrado.

Resultado:

- lookup corrigido para Estado e etapa;
- adapter read-only com client SYSTEM injetado;
- pacotes hidratados com fontes ordenadas;
- nós filtrados por pacote e ordenados deterministicamente;
- testes unitários e integração descartável aprovados;
- nenhuma escrita, currículo real ou produção.

O GAP-3B-01 foi formalmente encerrado após a integração humana do PR nº 15 no commit `ad168c6926cb404a5abda5109be4a42d4d0df30b`.

Este registro atualiza o estado de navegação sem reescrever o histórico preservado nos checkpoints 016 e 017.

### 6.4 — 3B.4 PedagogicalComponentRepository

Status: **concluído. 3B.4A e todos os sublotes do 3B.4B foram integrados por decisão humana.**

Objetivo:

- permitir leitura dos componentes pedagógicos semielaborados;
- preparar o acesso ao futuro almoxarifado inteligente.

Estratégia:

```text
3B.4A — leituras — integrado pelo PR nº 17
3B.4B — escritas transacionais — definição integrada pelo PR nº 19
  3B.4B.1 — contratos e porta — integrado pelo PR nº 20
  3B.4B.2 — migration e RPCs — integrado pelo PR nº 21
  3B.4B.3 — adapter Supabase de comando — integrado pelo PR nº 22
```

Estado integrado do 3B.4A:

- `findById`, `findVersion` e `listEvidenceOrigins` implementados como subconjunto read-only;
- adapter atribuível somente à capacidade read-only da porta, sem stubs de escrita e sem alegar
  implementação integral;
- leituras compostas sequenciais, sem promessa de snapshot forte e sem retorno parcial;
- squash merge do PR nº 17 no commit `1c03d21590bf004489d0f4d07e42aaf29db44ac5`;
- testes unitários, CI geral, integração no Supabase descartável e Vercel aprovados.

Estado integrado das escritas:

- o contrato `2.0.0` transporta evidências completas e vínculos curriculares sem side-channel;
- as quatro operações usam RPCs PostgreSQL estreitas, transacionais e idempotentes;
- o adapter 3B.4B.3 usa exclusivamente essas RPCs e permanece separado da leitura;
- atomicidade, rollback, replay, fingerprint divergente e concorrência foram aprovados no Supabase
  descartável;
- o PR nº 22 foi integrado no commit `99b7981695eccb8b6019d570ff6e77529574a58f`, após CI geral,
  DB CI e Vercel verdes;
- `GAP-3B-02` e `GAP-3B-06` estão formalmente encerrados;
- nenhuma escrita multi-tabela poderá simular atomicidade por chamadas independentes ao provider;
- wiring, Supabase hospedado e produção continuam sujeitos a gates próprios.

Definição específica:

- `12-delivery/LOT-3B4-PEDAGOGICAL-COMPONENT-ADAPTER-DEFINITION.md` — definição histórica do 3B.4 e do 3B.4A;
- `12-delivery/LOT-3B4B-COMPONENT-WRITE-BOUNDARY-DEFINITION.md` — definição contratual e
  transacional integrada do 3B.4B.

### 6.5 — 3B.5 ProductionOrderRepository

Status: **concluído. A definição documental e os quatro sublotes foram integrados pelos Pull
Requests nº 24 a 28, e o encerramento pós-merge foi formalizado no Checkpoint 031. Nenhum wiring,
Supabase hospedado ou acesso à produção foi iniciado.**

Objetivo:

- persistir e consultar Ordens de Produção Pedagógica;
- registrar timeline coerente de produção;
- preservar isolamento por requester.

Pré-condições:

- requester-scoped client formalmente definido e efêmero;
- criação de OPP + evento `created` atômica;
- transição OPP + evento atômica e server-only;
- idempotência e concorrência otimista;
- separação entre leitura, solicitação e transição.

Estratégia proposta:

```text
3B.5.1 — contratos e contextos — integrado
3B.5.2 — adapter requester read-only — integrado
3B.5.3 — migration e RPCs — integrado
3B.5.4 — adapters de comando — integrado
```

Estado dos gaps:

- GAP-3B-03 — encerrado após integração dos quatro sublotes e checkpoint pós-merge;
- GAP-3B-07 — ativo e contido; a fatia física atual não representa a OPP normativa completa.

Definição específica:

- `12-delivery/LOT-3B5-PRODUCTION-ORDER-REPOSITORY-DEFINITION.md`.

### Gate de saída da Fase B

A Fase B termina quando as portas previstas para o MVP tiverem adapters seguros ou uma decisão formal de bloqueio parcial, sem pseudo-transações e sem wiring de produção implícito.

Resultado: **satisfeito por bloqueio parcial controlado no Checkpoint 032**. Os adapters previstos
foram concluídos, as fronteiras transacionais críticas foram comprovadas no Supabase descartável e
não existe dependência de produção. As contenções registradas naquele momento foram:

- `GAP-3B-04` — destinado à governança operacional do lifecycle de fontes na Fase C; **encerrado
  posteriormente em C.1.6 / Checkpoint 043**;
- `GAP-3B-05` — auditoria enriquecida e conclusão integral da `US-013.2` continuam bloqueadas até
  extensão contratual explícita;
- `GAP-3B-07` — OPP normativa completa e capacidades de contexto, retrieval, validação e entrega
  continuam destinadas às fases correspondentes e não foram antecipadas.

O encerramento deste gate não iniciou automaticamente a Fase C; cada lote permaneceu sujeito a
definição e autorização próprias.

## 7. Fase C — Matéria-prima e preparação do conhecimento

### Status

C.0 foi integrado pelo PR nº 31. O Lote C.1 foi executado de C.1.1 a C.1.6 e está **concluído**.
C.1.6 foi integrado pelo PR nº 57 no commit
`3ae0f5554eed5e7bd7f208647e068a304127058d`, tree
`26da88424ade53819e3597258a224d575647a5a6`, com CI pós-merge nº 362 verde.

A auditoria final está em
[`12-delivery/LOT-C1-6-SOURCE-LIFECYCLE-CLOSURE-MATRIX.md`](12-delivery/LOT-C1-6-SOURCE-LIFECYCLE-CLOSURE-MATRIX.md)
e o estado de continuidade de fechamento em
[`00-governance/CONTINUITY-CHECKPOINT-043.md`](00-governance/CONTINUITY-CHECKPOINT-043.md).
`GAP-3B-04` está encerrado.

A definição documental do Lote C.2 foi integrada pelo PR nº 59 no commit
`787432fa8e7f5d891899c94b1089803430a4734a`, tree
`fc4d517def95ce23e5ddb73d935e1628710142d7`, com CI pós-merge nº 366 verde. Sua definição está em
[`12-delivery/LOT-C2-CONTROLLED-INGESTION-DEFINITION.md`](12-delivery/LOT-C2-CONTROLLED-INGESTION-DEFINITION.md)
e a decisão de fronteira está no ADR-062.

C.2.1 foi integrado pelo PR nº 62 no commit
`e0ba47bf063b324df141c370ebf371763fbf2364`, tree
`a78d930b9491724c79665e420ceebc609b122d18`, com CI pós-merge nº 373 verde. A superfície contratual
está em
[`12-delivery/LOT-C2-1-INGESTION-CONTRACTS-AND-STATE-MACHINE.md`](12-delivery/LOT-C2-1-INGESTION-CONTRACTS-AND-STATE-MACHINE.md)
e o estado pós-merge no Checkpoint 045.

C.2.2 foi integrado pelo PR nº 67 no commit
`7557bc3aa80ce5ebd6423b10a179fa3790b97cb6`, tree
`61747e439323dcc165c8d3a084e4d73c66f06c4a`, com CI pós-merge nº 412 verde. A fronteira de intake/staging
está em
[`12-delivery/LOT-C2-2-SECURE-STAGING-LIMITS-AND-RETENTION.md`](12-delivery/LOT-C2-2-SECURE-STAGING-LIMITS-AND-RETENTION.md)
e o estado pós-merge no Checkpoint 046.

C.2.3 foi integrado pelo PR nº 70 no commit `f70312a9936b99e1c131627277ad4c4a65b126a5`, tree
`4b47c853a2cb041ca895477abc3c710ca9393b94`, com CI pós-merge nº 430 verde; sua fronteira está em
[`12-delivery/LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md`](12-delivery/LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md)
e o estado pós-merge no Checkpoint 047.

C.2.4 foi integrado pelo PR nº 74 no commit `14b7ff30d1b659ed8b2c824f9a943b05cdca93bc`, tree
`92411aec0c9da3789bb91c87d8f423a3c69f929d`, com CI pós-merge nº 523 verde; sua fronteira está em
[`12-delivery/LOT-C2-4-IDEMPOTENCY-RECOVERY-AND-FAIL-SAFE.md`](12-delivery/LOT-C2-4-IDEMPOTENCY-RECOVERY-AND-FAIL-SAFE.md)
e o estado pós-merge no Checkpoint 048.

C.2.5 foi integrado pelo PR nº 84 no commit `01a985a94272608007a57fd60695fed719c625d2`, tree
`a73ad7e9efda8e1c04bcddd3ed129bc44d85eaf1`, com CI pós-merge nº 547 verde; sua fronteira está em
[`12-delivery/LOT-C2-5-HUMAN-REVIEW-AND-C3-HANDOFF.md`](12-delivery/LOT-C2-5-HUMAN-REVIEW-AND-C3-HANDOFF.md).
O estado pós-merge está no Checkpoint 049.

C.2.6 foi integrado pelo PR nº 93 no commit `3b8c2d317542bd701ea61e671f9b6e4334f61b1c`, tree
`0fbe3377d3dac6aa9730a6e895d20a0762fc855c`, com CI pós-merge nº 562 verde; sua prova integrada e
matriz de fechamento estão em
[`12-delivery/LOT-C2-6-INTEGRATED-PROOF-AND-CLOSURE.md`](12-delivery/LOT-C2-6-INTEGRATED-PROOF-AND-CLOSURE.md).
O Checkpoint 050 formaliza o encerramento canônico do Lote C.2 e mantém C.3 bloqueado.

Durante o merge do PR nº 93 houve uma corrida concorrente governada: o PR nº 92 da frente comercial
avançou a `main` entre a última leitura pré-merge e o squash de C.2.6. O commit técnico de C.2.6 ficou
como filho direto de `57d7e387676224ef6fb5e3101270c0b6e4f8c245`. A comparação pós-merge confirmou
exatamente os sete arquivos de C.2.6 e o CI nº 562 validou a árvore composta final. O evento e a
limitação TOCTOU da API estão registrados no Checkpoint 050.

O mapa integral C.0–C.7 está definido em
[`12-delivery/PHASE-C-EXECUTION-MAP.md`](12-delivery/PHASE-C-EXECUTION-MAP.md), e C.1 possui definição
específica em
[`12-delivery/LOT-C1-SOURCE-LIFECYCLE-GOVERNANCE-DEFINITION.md`](12-delivery/LOT-C1-SOURCE-LIFECYCLE-GOVERNANCE-DEFINITION.md).

O plano complementar de ações para cartografia da obra, cobertura integral, paratextos, notas
atômicas e grafo tipado está em
[`12-delivery/PHASE-C-KNOWLEDGE-CARTOGRAPHY-ACTION-PLAN.md`](12-delivery/PHASE-C-KNOWLEDGE-CARTOGRAPHY-ACTION-PLAN.md).
Ele detalha requisitos de C.1-C.7 e impactos nas Fases D-G, sem antecipar runtime de agentes ou
alterar os gates vigentes.

### Objetivo

Transformar fontes autorizadas em componentes pedagógicos estruturados, rastreáveis e curados.

### Estrutura de execução

| Lote | Capacidade | Epics/Stories principais | Estado |
|---|---|---|---|
| C.0 | Definição integral, governança e gates | EPIC-001 | integrado/encerrado |
| C.1 | Lifecycle de fontes, procedência e direitos | EPIC-002; US-002.1–002.2 | **concluído — C.1.1–C.1.6** |
| C.2 | Ingestão controlada | EPIC-003; US-003.1 | **concluído — C.2.1–C.2.6** |
| C.3 | Extração e validação | EPIC-003; US-003.1 | **definição documental proposta; C.3.1–C.3.8 bloqueados** |
| C.4 | Segmentação e classificação | EPIC-003; US-003.2 | bloqueado |
| C.5 | Destilação e deduplicação | EPIC-005; US-005.1–005.2 | bloqueado |
| C.6 | Componentes, versões e currículo | EPIC-004/006; US-004.1–004.3 e US-006.1–006.2 | bloqueado |
| C.7 | Curadoria e corpus piloto | EPIC-004/005/006 | bloqueado |

`Bloqueado` significa visível e planejado, mas não autorizado. Cada lote e sublote exige definição,
DoR, autorização humana, testes, revisão, merge humano e checkpoint próprios.

### Fluxo esperado

```text
Fonte autorizada
  ↓
registro de procedência
  ↓
versão governada
  ↓
permissão/licença por finalidade
  ↓
staging temporário controlado
  ↓
execução de ingestão rastreável
  ↓
revisão humana / handoff
  ↓
extração
  ↓
segmentação
  ↓
classificação
  ↓
destilação pedagógica
  ↓
deduplicação
  ↓
vínculo curricular
  ↓
componente pedagógico
  ↓
curadoria
```

### Fontes iniciais previstas

- documentos próprios;
- currículo de Minas Gerais;
- BNCC aplicável;
- fontes abertas ou expressamente autorizadas;
- PNLD somente dentro de regras jurídicas e de autorização previamente aprovadas.

### Princípio autoral

Não armazenar apenas páginas ou chunks crus como produto de consumo dos agentes.

PDFs, imagens integrais de páginas, renderizações, recortes e miniaturas serão insumos temporários
de ingestão e validação, nunca componentes do corpus permanente. Depois da extração e da revisão
exigida, deverão ser descartados de forma verificável. O armazenamento definitivo ficará restrito a
texto normalizado, chunks selecionados, dados estruturados, descrições semânticas de elementos
visuais, procedência lógica, componentes, relações, vínculos e embeddings seletivos.

As obras editoriais previstas são predominantemente PDFs com camada textual utilizável. A extração
nativa do texto e da estrutura do arquivo será o caminho padrão. OCR não fará parte do fluxo comum:
será um fallback pontual, acionado somente para páginas ou elementos cuja camada textual esteja
ausente, corrompida ou comprovadamente insuficiente, sempre com justificativa, métricas e revisão.

O objetivo é produzir matérias-primas pedagógicas semielaboradas que preservem:

- procedência;
- contexto;
- tipo pedagógico;
- vínculo curricular;
- direitos de uso;
- rastreabilidade;
- espaço para geração autoral posterior.

## 8. Fase D — Inteligência do almoxarifado

### Status

Futura.

### Objetivo

Permitir recuperação rápida, precisa e econômica dos componentes relevantes.

### Ordem obrigatória

```text
filtros determinísticos
  ↓
busca lexical/estruturada
  ↓
busca semântica
  ↓
fusão/reranking
  ↓
checagem de suficiência
  ↓
pacote de contexto
```

### Decisões que só serão tomadas por experimento

- modelo de embedding;
- dimensão;
- campos vetorizados;
- índice;
- estratégia de fusão;
- reranker;
- cache;
- limites de recuperação;
- orçamento de contexto.

### Regra permanente

> Metadados e filtros pedagógicos restringem o território antes de qualquer similaridade vetorial.

### Métricas mínimas

- precisão;
- recall;
- relevância pedagógica;
- incidência de conteúdo inadequado ao ano/componente;
- latência;
- tokens;
- custo;
- taxa de insuficiência corretamente detectada.

## 9. Fase E — Fábrica de agentes

### Status

Futura.

### Objetivo

Ativar o primeiro fluxo agêntico sobre infraestrutura e retrieval já mensuráveis.

### Sócrates 2

Perfil piloto:

- componente: Filosofia;
- etapa: Ensino Médio;
- ano: 2º ano;
- currículo inicial: Minas Gerais;
- currículo futuro plugável: Rio Grande do Sul;
- runtime compartilhado e versionado;
- não duplicado por Estado.

### Contexto do agente

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

### Orquestrador

Responsável por:

- interpretar a OPP;
- selecionar agentes e capacidades;
- controlar escopo de conhecimento;
- coordenar retrieval;
- controlar orçamento;
- acionar validadores;
- impedir expansão de domínio não autorizada.

## 10. Fase F — Produção e piloto controlado

### Escopo do piloto

- Filosofia;
- 2º ano do Ensino Médio;
- Minas Gerais;
- Sócrates 2;
- 100–300 componentes pedagógicos revisados.

### Produtos mínimos

1. plano de aula;
2. texto didático;
3. atividade reflexiva;
4. avaliação formativa curta.

### Fluxo de produção

```text
Pedido do professor
  ↓
OPP
  ↓
roteamento
  ↓
currículo
  ↓
retrieval
  ↓
pacote de contexto
  ↓
Sócrates 2
  ↓
produção autoral
  ↓
validação
  ↓
contrato de entrega
```

### Controle de qualidade

Devem participar, conforme o produto:

- validação curricular;
- validação conceitual;
- validação pedagógica;
- inclusão e acessibilidade;
- autoria e risco de reprodução;
- rastreabilidade;
- custo/tokens/latência.

Finding `Must` aberto permanece bloqueante e não compensatório.

### Baseline obrigatório

Comparar Sócrates 2 com agente genérico em execução pareada e casos dourados.

Medir:

- qualidade pedagógica;
- aderência curricular;
- relevância do repertório;
- criatividade;
- alucinação;
- mistura entre ano/componente;
- tokens;
- latência;
- custo.

### Critério estratégico

A expansão só deve ocorrer se a arquitetura especializada demonstrar ganho real e mensurável em relação ao baseline genérico.

## 11. Fase G — Escala

### Status

Futura e fora do piloto inicial.

### Ordem recomendada

1. expandir Filosofia para 1º e 3º anos;
2. validar reutilização do runtime comum;
3. adicionar nova disciplina;
4. expandir repertório e currículos;
5. introduzir Rio Grande do Sul como pacote curricular plugável;
6. ampliar produtos;
7. integrar acabamento gráfico avançado;
8. escalar para demais agentes e fábricas.

### Capacidades explicitamente posteriores

- expansão ampla de disciplinas;
- currículo RS em produção;
- outros Estados;
- Gráfica avançada;
- PDF/PPTX sofisticados;
- novas fábricas;
- EPIC-018;
- integrações externas adicionais.

## 12. Produção é uma trilha separada

Nenhuma conclusão de um Lote técnico autoriza automaticamente:

- migration em Supabase real;
- uso de `service_role` real;
- wiring de API de produção;
- ativação no frontend;
- processamento de fontes reais;
- exposição de agentes aos professores.

A entrada em produção exige gate próprio com, no mínimo:

- alvo formalmente identificado;
- snapshot/schema;
- drift analysis;
- backup/pre-flight;
- comandos exatos;
- plano de rollback e resposta a falha;
- revisão de segurança;
- autorização humana explícita.

## 13. Gates entre as fases

### A → B

Concluído: contratos, domínio e schema aprovados.

### B → C

Critérios satisfeitos no Checkpoint 032:

- adapters necessários ao fluxo de matéria-prima aprovados — satisfeito;
- GAPs relevantes resolvidos ou formalmente contidos — satisfeito no momento por contenção de
  `GAP-3B-04`, `GAP-3B-05` e `GAP-3B-07`;
- testes de integração descartáveis verdes — satisfeito;
- nenhuma dependência implícita de produção — satisfeito.

A passagem arquitetural foi aberta documentalmente pela integração de C.0. Depois disso, C.1 foi
executado de forma controlada e concluído. `GAP-3B-04` foi encerrado em C.1.6; `GAP-3B-05` e
`GAP-3B-07` permanecem ativos e contidos.

A definição de C.2 foi integrada pelo PR nº 59 e formalizou sua fronteira operacional. C.2.1 foi
integrado pelo PR nº 62 como superfície contract-first. C.2.2 foi integrado pelo PR nº 67 como
fronteira física mínima de intake/staging temporário, com CI pós-merge nº 412 verde. C.2.3 foi
integrado pelo PR nº 70 como fronteira de integridade criptográfica, duplicidade binária e vínculo,
com CI pós-merge nº 430 verde e reconciliação registrada no Checkpoint 047. C.2.4 foi integrado pelo
PR nº 74 como fronteira durável de idempotência, recovery e fail-safe, com CI pós-merge nº 523 verde
e Checkpoint 048. C.2.5 foi integrado pelo PR nº 84 como fronteira de revisão humana e handoff
governado, com CI pós-merge nº 547 verde e Checkpoint 049. C.2.6 foi integrado pelo PR nº 93 como
prova E2E consolidada e gate de fechamento, com CI pós-merge nº 562 verde. **C.2 está encerrado no
Checkpoint 050; C.3–C.7 permanecem bloqueados.**

O fechamento de C.2 não constitui autorização para extração, conteúdo real, Storage hospedado,
Supabase hospedado, wiring ou produção.

### C → D

Exige:

- corpus piloto curado;
- procedência e permissões confiáveis;
- tipologia de componentes estável;
- amostra suficiente para experimentos de retrieval.

### D → E

Exige:

- estratégia de retrieval escolhida por evidência;
- filtros determinísticos funcionando;
- budget de contexto definido;
- métricas mínimas conhecidas;
- insuficiência detectável.

### E → F

Exige:

- Sócrates 2 versionado;
- OPP e orquestração testadas;
- validadores bloqueantes ativos;
- nenhum acesso indiscriminado ao corpus.

### F → G

Exige:

- piloto comparativo concluído;
- ganho mensurável sobre baseline genérico;
- custos e latência aceitáveis;
- qualidade pedagógica aprovada;
- riscos autorais controlados.

## 14. Regra de documentação antes do código

Cada nova frente deverá seguir:

```text
DEFINIR
  ↓
DOCUMENTAR
  ↓
APROVAR
  ↓
CRIAR BRANCH
  ↓
IMPLEMENTAR
  ↓
TESTAR
  ↓
REVISAR
  ↓
MERGE HUMANO
  ↓
CHECKPOINT
```

Não iniciar etapa futura por continuidade implícita.

## 15. Regra de forks e continuidade

Forks de conversa devem ocorrer em marcos naturais, especialmente após:

- merge de um Lote ou sublote relevante;
- checkpoint oficial;
- mudança de camada arquitetônica;
- crescimento significativo do contexto.

Antes do fork, deve existir um checkpoint versionado registrando:

- estado atual;
- decisão humana;
- branch e PR;
- pendências;
- próximo escopo autorizado;
- itens explicitamente bloqueados.

## 16. Visão executiva

A Knowledge Factory não será construída começando pela IA.

Ela será construída na seguinte ordem:

```text
1. definir o que existe;
2. definir as regras;
3. guardar com segurança;
4. conectar o domínio ao armazenamento;
5. preparar a matéria-prima;
6. organizar o almoxarifado;
7. aprender a recuperar somente o necessário;
8. ativar o agente especializado;
9. produzir com controle de qualidade;
10. provar que o resultado é melhor;
11. somente então escalar.
```

## 17. Estado de navegação

Ponto atual oficial deste Blueprint:

> **FASE C APÓS O FECHAMENTO DE C.2 — C.0 integrado; C.1.1–C.1.6 concluídos; Lote C.1 encerrado;
> `GAP-3B-04` encerrado; definição documental de C.2 integrada pelo PR nº 59; C.2.1 pelo PR nº 62;
> C.2.2 pelo PR nº 67; C.2.3 pelo PR nº 70; C.2.4 pelo PR nº 74; C.2.5 pelo PR nº 84; e C.2.6
> integrado pelo PR nº 93 no commit `3b8c2d317542bd701ea61e671f9b6e4334f61b1c`, tree
> `0fbe3377d3dac6aa9730a6e895d20a0762fc855c`, com CI pós-merge nº 562 verde.**

Atualização de navegação da Fase C:

> **C.2.1–C.2.6 estão integrados e revalidados; o Lote C.2 está encerrado no Checkpoint 050. C.3
> permanece bloqueado. C.4–C.7 e as Fases D–G continuam bloqueados. `GAP-3B-05` e `GAP-3B-07`
> permanecem ativos e contidos. Produção permanece não autorizada.**

Registro de concorrência:

> Durante o merge do PR nº 93, o PR nº 92 da frente comercial avançou a `main` entre a verificação
> pré-merge e o squash. O commit de C.2.6 foi aplicado sobre `57d7e387676224ef6fb5e3101270c0b6e4f8c245`.
> A comparação pós-merge confirmou os sete arquivos autorizados de C.2.6 e o CI nº 562 validou a
> árvore composta final. O Checkpoint 050 preserva esse evento e a limitação TOCTOU como evidência.

Próximo objetivo possível, somente após integração humana desta proposta, checkpoint próprio,
reconfirmação canônica e nova autorização explícita:

> abrir **C.3.1 — contratos, lifecycle, proveniência, vocabulário de qualidade e fixtures
> sintéticas**, sem parser, OCR, conteúdo real, PNLD real, PDF/livro real, Storage/Supabase hospedados
> ou produção.

Próxima grande mudança de natureza do projeto:

> A definição documental de C.3 estabelece a primeira camada com autoridade para executar extração,
> mas não a implementa nem a inicia. O handoff de C.2 é entrada necessária e insuficiente: C.3 deverá
> revalidar a autorização `purpose=extraction` no instante de claim, leitura/retomada e finalização.
> Segmentos, chunks semânticos e hierarquia editorial confirmada pertencem a C.4.
