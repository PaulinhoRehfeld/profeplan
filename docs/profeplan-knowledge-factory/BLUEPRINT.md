# ProfePlan Knowledge Factory — Blueprint de Execução

Data de consolidação: 7 de agosto de 2026.

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
🔵 3B.3 CurriculumRepository        ← ESTADO ATUAL
⬜ 3B.4 PedagogicalComponentRepository
⬜ 3B.5 ProductionOrderRepository

FASE C — MATÉRIA-PRIMA
⬜ Governança operacional de fontes
⬜ Ingestão
⬜ Extração
⬜ Segmentação
⬜ Destilação
⬜ Componentização
⬜ Curadoria

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

Restrição ativa:

- GAP-3B-04 — lifecycle de fonte incompleto para ingestão.

Interpretação operacional:

> Esta etapa cria a ficha e a porta de persistência da matéria-prima; ainda não inicia o processamento de livros ou PDFs.

### 6.3 — 3B.3 CurriculumRepository

Status: em definição documental.

Pré-condição:

- resolver formalmente GAP-3B-01.

Problema atual:

- a porta consulta pacote ativo apenas por Estado;
- o schema admite um pacote ativo por `(state, stage)`.

Direção aprovada:

- revisar a porta antes do adapter;
- implementar inicialmente leitura controlada;
- não misturar currículos estaduais;
- manter currículo como pacote versionado e plugável.

### 6.4 — 3B.4 PedagogicalComponentRepository

Status: pendente.

Objetivo:

- permitir leitura dos componentes pedagógicos semielaborados;
- preparar o acesso ao futuro almoxarifado inteligente.

Estratégia:

```text
3B.4A — leituras
3B.4B — escritas transacionais
```

Restrição ativa:

- GAP-3B-02 — componente + versão exigem atomicidade real.

Nenhuma escrita multi-tabela deverá simular atomicidade por chamadas independentes ao provider.

### 6.5 — 3B.5 ProductionOrderRepository

Status: pendente.

Objetivo:

- persistir e consultar Ordens de Produção Pedagógica;
- registrar timeline coerente de produção;
- preservar isolamento por requester.

Pré-condições:

- requester-scoped client formalmente definido;
- atomicidade OPP + evento aprovada.

Restrição ativa:

- GAP-3B-03.

### Gate de saída da Fase B

A Fase B termina quando as portas previstas para o MVP tiverem adapters seguros ou uma decisão formal de bloqueio parcial, sem pseudo-transações e sem wiring de produção implícito.

## 7. Fase C — Matéria-prima e preparação do conhecimento

### Status

Futura. A nomenclatura dos próximos Lotes ainda deverá ser formalizada documentalmente antes da implementação.

### Objetivo

Transformar fontes autorizadas em componentes pedagógicos estruturados, rastreáveis e curados.

### Fluxo esperado

```text
Fonte autorizada
  ↓
registro de procedência
  ↓
versão
  ↓
permissão/licença
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

Exige:

- adapters necessários ao fluxo de matéria-prima aprovados;
- GAPs relevantes resolvidos ou formalmente contidos;
- testes de integração descartáveis verdes;
- nenhuma dependência implícita de produção.

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

> **FASE B — Lote 3B.3 — CurriculumRepository em definição documental.**

Próximo objetivo imediato:

> aprovar a correção do lookup curricular para Estado e etapa e, somente depois, implementar o adapter read-only sem conteúdo curricular real.

Próxima grande mudança de natureza do projeto:

> após encerrar os adapters necessários, iniciar documentalmente a fase de entrada e preparação das matérias-primas pedagógicas.
