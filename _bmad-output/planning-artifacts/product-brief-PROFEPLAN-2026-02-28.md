---
stepsCompleted: [1, 2, 3, 4, 5]
inputDocuments: []
date: 2026-02-28
author: PAULINHO
---

# Product Brief: PROFEPLAN

<!-- Content will be appended sequentially through collaborative workflow steps -->

## Executive Summary

O PROFEPLAN é um ecossistema de planejamento pedagógico alimentado por IA que devolve tempo e saúde mental aos professores da educação básica. O produto reduz a carga burocrática de elaborar planos de aula do zero, alinhados às diretrizes curriculares (BNCC), através de um assistente inteligente, planejamento trimestral automatizado a partir de documentos oficiais (ex.: planos de curso da Secretaria de Educação de Minas Gerais), criação de planos de aula, materiais do aluno, exercícios, adaptações para alunos com deficiência, avaliações e apresentações — tudo integrado com ferramentas que o professor já usa (Google Drive, Canva, Google Classroom, NotebookLM). O sucesso do PROFEPLAN é medido pelo tempo e bem-estar que devolve ao educador, permitindo que ele foque no que realmente importa: o vínculo humano na sala de aula.

---

## Core Vision

### Problem Statement

Professores da educação básica (ensino fundamental e médio) gastam tempo excessivo elaborando planos de aula do zero e alinhando conteúdos às diretrizes curriculares oficiais (BNCC). O trabalho é altamente burocrático, repetitivo e um dos principais fatores de esgotamento (burnout) na profissão.

### Problem Impact

Muitos professores trabalham em dois ou três turnos, lidam com salas lotadas e levam o planejamento para casa, ocupando noites e finais de semana. Isso compromete saúde mental, vida pessoal e a energia disponível para o trabalho em sala — o que deveria ser o foco principal da profissão.

### Why Existing Solutions Fall Short

Concorrentes como Teachy e Plurall são pagos ou exigem contrato com as escolas — o custo recai sobre a instituição ou sobre o professor. Além disso, planos prontos genéricos, buscas em grupos e redes sociais, ou trabalho manual em editores de texto não estão alinhados às especificidades curriculares de cada rede, não integram planejamento trimestral com planos de aula e não oferecem suporte metodológico consistente. O professor continua refazendo trabalho repetitivo, sem ganho real de tempo ou qualidade.

### Proposed Solution

O PROFEPLAN é um ecossistema integrado em múltiplas telas:

1. **Assistente (Tela 1):** O professor solicita o que precisa (ex.: "crie uma aula sobre climas do Brasil") e recebe apoio imediato.
2. **Planejamento Trimestral (Tela 2):** Com base em dados pré-carregados (planos de curso da SEE-MG) e no número de aulas, o sistema distribui o conteúdo, reserva datas para avaliações e outros itens configurados.
3. **Planos de Aula, Materiais e Exercícios (Tela 3):** Criação de planos de aula, material do aluno e exercícios, vinculados ao planejamento trimestral.
4. **Adaptações (Tela 4):** Adaptação para alunos com deficiência.
5. **Avaliações (Tela 5):** Criação de avaliações.
6. **Apresentações (Tela 6):** Geração de apresentações.
7. **Banco ENEM (Tela 7):** Acesso a questões do ENEM.
8. **Base PNLD (em desenvolvimento):** Base de dados dos livros aprovados pelo PNLD — indica onde estão textos e exercícios nos livros dos alunos (referência, não impressão), auxiliando o professor a localizar conteúdos programados. A mesma base serve como laboratório criativo para conteúdos autorais do PROFEPLAN.

Todos os arquivos são salvos, compartilhados e podem ser linkados com Google Drive, Canva, Google Classroom e NotebookLM. O alinhamento curricular é garantido por RAG com Azure OpenAI.

### Modelo de Negócio

- **Professor:** Uso gratuito, financiado por patrocínios (empresas com compromisso social, associações, instituições filantrópicas, editais, investidores anjo).
- **Redes e secretarias:** Versões premium e personalizadas (currículo local, relatórios, dashboards, integrações) para quem deseja customização.
- **Estratégia:** Startup e-tech em parceria com universidade; alinhamento aos ODS (Objetivos de Desenvolvimento Sustentável), especialmente ODS 4; participação em editais.
- **Go-to-market:** Início em Minas Gerais, com expansão posterior.

### Key Differentiators

- **Gratuito para o professor:** Diferente de Teachy e Plurall (pagos/contrato escola). Financiado por patrocínio e impact; receita via customização para redes.
- **RAG com Azure OpenAI:** Conteúdo metodologicamente embasado e alinhado à BNCC e às bases curriculares oficiais.
- **Base de dados institucional:** Uso de planos de curso da Secretaria de Educação de Minas Gerais como fonte primária.
- **Base PNLD (em desenvolvimento):** Mapeamento dos livros aprovados pelo PNLD — indicação de textos e exercícios por assunto; laboratório criativo para conteúdo autoral.
- **Ecossistema integrado:** Fluxo contínuo desde o planejamento trimestral até planos de aula, materiais, avaliações e apresentações.
- **Integrações nativas:** Google Drive, Canva, Google Classroom, NotebookLM.
- **Filosofia de produto:** Empoderar o professor — não substituí-lo — removendo trabalho repetitivo para que ele possa focar no vínculo e na inspiração dos alunos.

---

## Target Users

### Primary Users

**Persona 1: A Professora Sobrecarregada na Linha de Frente**

| Atributo | Descrição |
|----------|-----------|
| **Nome** | Ana, 38 anos |
| **Perfil** | Professora do Ensino Fundamental II ou Médio (ex.: Matemática ou História). Leciona em duas ou três escolas (rede pública estadual em MG + escola particular menor) para complementar a renda. |
| **Rotina** | Acorda às 5h30, dá aulas pela manhã, corre para a segunda escola à tarde. Chega em casa às 18h30 exausta. Depois da família, o "terceiro turno" começa às 21h ou no domingo à tarde: o planejamento. |
| **Onde o PROFEPLAN entra** | Substitui 3 horas no domingo (PDFs da BNCC, Word) por 2 minutos: digita o tema e recebe plano estruturado e validado. |
| **Dor principal** | Ligar criatividade à burocracia — cruzar ideias de aula com códigos BNCC e diretrizes PNLD. O PROFEPLAN automatiza essa parte mecânica. |
| **Sucesso** | Recuperar tempo e energia para focar na sala de aula e na família. |

### Secondary Users

**Persona 2: O Coordenador Pedagógico / Gestor da Rede**

| Atributo | Descrição |
|----------|-----------|
| **Nome** | Carlos, 45 anos |
| **Perfil** | Coordenador pedagógico de escola ou gestor de secretaria municipal de educação. |
| **Necessidade** | Garantir que todos os professores planejem em dia e alinhados ao currículo da rede, sem sobrecarregar a equipe. |
| **Onde o PROFEPLAN entra** | Ferramenta de gestão e padronização. Assina o plano Premium para injetar o material didático da escola no RAG da IA. |
| **Dor principal** | Acompanhar a qualidade pedagógica de dezenas de professores sem microgerenciar. |
| **Sucesso** | Se o professor usar o PROFEPLAN, a aula sai alinhada às regras da escola — qualidade com menor esforço de supervisão. |

### User Journey

**Ana (Professora):**
- **Descoberta:** Indicação de colegas, grupos de professores ou formação.
- **Onboarding:** Cadastro simples; começa pelo Assistente (Tela 1).
- **Uso diário:** Domingo ou noites — gera planos, materiais e avaliações em minutos.
- **Momento "aha!":** Ver um plano completo em minutos em vez de horas.
- **Longo prazo:** PROFEPLAN vira rotina de planejamento; finais de semana livres.

**Carlos (Coordenador/Gestor):**
- **Descoberta:** Professores adotam; ele percebe necessidade de padronização.
- **Onboarding:** Conhece o Premium; vê valor em customizar com materiais da rede.
- **Uso:** Adoção institucional; acompanhamento sem microgerenciar.
- **Momento "aha!":** "Consigo garantir alinhamento sem cobrar planos manualmente."
- **Longo prazo:** PROFEPLAN como padrão da rede; coordenação focada em apoio, não fiscalização.

---

## Success Metrics

### Sucesso pelo olhar do usuário

**Ana (Professora):**
- **Momento "Uau":** Domingo à tarde — digita o tema e, em menos de 3 minutos, recebe plano de aula completo, criativo, com códigos BNCC preenchidos.
- **Percepção de valor:** "Terminei o planejamento da semana em 20 minutos e posso usar o resto do domingo para descansar ou ficar com a família."
- **Comportamento de sucesso:** Uso semanal (retenção) e indicação do PROFEPLAN no grupo de WhatsApp dos colegas.

**Carlos (Coordenador):**
- **Momento "Uau":** Ao abrir o painel e ver que 100% dos professores entregaram os planos no prazo, padronizados, usando a base (RAG) da escola.
- **Percepção de valor:** Deixar de ser "cobrador de tarefas" e ter tempo para ser orientador pedagógico.

### North Star Metric

**Planos de aula gerados e exportados com sucesso por semana.**

### Business Objectives

| Horizonte | Objetivo |
|-----------|----------|
| **3 meses** | Validar motor de IA e usabilidade. Base sólida de professores ativos (WAU) em MG usando a versão gratuita de forma recorrente. Tempo médio de geração de plano < 3 minutos. |
| **12 meses** | Comprovar modelo B2B2C — primeiras escolas/secretarias parceiras convertidas para Premium pago (com material didático próprio injetado no RAG). |

### Key Performance Indicators

| KPI | Descrição |
|-----|-----------|
| **WAU** | Usuários ativos semanais |
| **Custo de token por plano** | Manter margem saudável na Azure |
| **NPS** | Net Promoter Score alto entre professores |
| **Taxa de conversão** | Contas gratuitas → redes pagas (Premium) |

---

## Estado Atual do Ecossistema

**Contexto:** O PROFEPLAN possui todas as funcionalidades estabelecidas no Product Brief. O foco não é construir do zero, mas **melhorar, refatorar e escalar**. A equipe BMAD foi acionada para potencializar o projeto.

### Mapeamento Product Brief ↔ Código Atual

| Product Brief | Módulo Atual | Status | Caminho |
|---------------|--------------|--------|---------|
| Tela 1: Assistente | CHAT (Início) | ✅ Funcional | `FeatureRenderer` → `ToolMode.CHAT` |
| Tela 2: Planejamento Trimestral | QUARTERLY_PLANNING | ✅ Funcional | `TermPlanningManager`, `TermPlanningService` |
| Tela 3: Planos de Aula | PLANNING | ✅ Funcional | `PlanningManager`, `PlanningCockpit`, `PlanningService` |
| Tela 4: Adaptações PDI/DUA | INCLUSION | ✅ Funcional | `PdiAdaptationWidget`, `AiAdaptationService` |
| Tela 5: Avaliações | ASSESSMENT | ✅ Funcional | `AssessmentManager`, `AssessmentSetup` |
| Tela 6: Apresentações | PRESENTATIONS | ✅ Funcional | `PresentationCreator`, `AiPresentationService` |
| Tela 7: Banco ENEM | SIMULATION | ✅ Funcional | `SimulationFactory`, `QuestionBankService`, `QuestionSearchWidget` |
| Base PNLD | industry-pnld, PnldService | 🚧 Em desenvolvimento | `packages/industry-pnld`, `PnldService.ts` |
| Meus Arquivos | FILES | ✅ Funcional | `DriveExplorer`, `HistoryList` |
| Minhas Turmas | CLASSES | ✅ Funcional | `ClassManager`, `ClassDetail` |
| Gestão Escolar (Carlos) | SCHOOL_MANAGER | ✅ Funcional | `SchoolDashboard`, `TeacherManagement` |

### Arquitetura Técnica Atual

- **Monorepo:** `profeplan-monorepo` v4.0.0 (npm workspaces)
- **Frontend:** React 19 + Vite 6 + TypeScript (`apps/web`)
- **Packages:** `industry-pnld`, `industry-curriculum`, `graphics-profeplan`
- **Backend/DB:** Supabase
- **IA:** Gemini (via `geminiService`), Azure OpenAI (RAG)
- **Documentação de débito técnico:** `EXEMPLOS_REFATORACAO.md`, `ANALISE_TECNICA_REDUNDANCIAS.md`, `ANALISE_ORCHESTRATION_FLUXOS.md`

---

## MVP Scope: Refatoração e Escalabilidade

*Reframed:* O MVP não é "o que construir" — é **priorizar melhorias, refatoração e preparação para escala**.

### Prioridades de Refatoração (Core)

1. **Orquestração:** Consolidar fluxos dispersos em orquestradores (ex.: `PlanningOrchestrator`) — reduzir 10+ imports e race conditions por feature.
2. **Consolidação de serviços:** Unificar `PdiService`, `PdiDocumentService`, `PdiBlock9Service` em camada clara; eliminar duplicações em `StudentService`, etc.
3. **Facade / DAL:** Introduzir Data Access Layer e Credit Manager para separar responsabilidades e viabilizar testes.
4. **Base PNLD:** Finalizar pipeline de ingestão e indexação; expor busca por assunto para o professor no fluxo de planejamento.

### Fora do Escopo Imediato (Deferir)

- Novas telas ou funcionalidades principais
- Expansão para outras redes/estados (foco em MG primeiro)
- Integrações adicionais (Manter Drive, Canva, Classroom como estão)

### Critérios de Sucesso do Refactoring

- Redução de débito técnico documentado
- Testes unitários cobrindo orquestradores e serviços críticos
- Tempo médio de geração de plano < 3 minutos (métrica mantida)
- WAU em crescimento ou estável durante a refatoração

### Visão Futura (Pós-Refatoração)

- **Potencialização:** Motor de IA mais robusto; RAG com base PNLD completa; laboratório criativo de conteúdo autoral.
- **Escala:** Multi-tenancy para redes; painel Premium para coordenadores; preparação para B2B2C.
- **Arquitetura:** Monorepo enxuto; packages isolados e testáveis; CI/CD e observabilidade.
