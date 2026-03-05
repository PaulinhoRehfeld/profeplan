---
stepsCompleted: [1, 2, 3, 4, 5, 6, 7, 8]
inputDocuments:
  - product-brief-PROFEPLAN-2026-02-28.md
  - DIAGNOSTICO-CODE-REVIEW-PROFEPLAN-2026-02-28.md
  - EXEMPLOS_REFATORACAO.md
  - ANALISE_ORCHESTRATION_FLUXOS.md
  - ANALISE_TECNICA_REDUNDANCIAS.md
workflowType: 'architecture'
project_name: 'PROFEPLAN'
user_name: 'PAULINHO'
date: '2026-02-28'
---

# Documento de Arquitetura — PROFEPLAN

**Versão:** 1.0 | **Data:** 2026-02-28  
**Objetivo:** Plano claro e rigoroso de refatoração e consolidação para preparar o terreno seguro antes de criar novas features. Foco em escalabilidade, padrões (DAL, Facade) e eliminação de dívida técnica.

---

## 1. Contexto do Projeto

### 1.1 Situação Atual

- **Ecossistema:** Todas as funcionalidades do Product Brief já implementadas (v4.0)
- **Problema:** Muitas modificações não consolidadas; estrutura desorganizada
- **Objetivo:** Melhorar, refatorar e escalar — **não** construir do zero

### 1.2 Escopo Arquitetural

| Área | Status | Prioridade |
|------|--------|------------|
| Orquestração (Planning, PDI) | Dívida crítica | P0 |
| Consolidação de serviços (PDI, questionService) | Redundâncias | P0 |
| Organização de pastas (features vs components) | Inconsistência | P1 |
| Arquivos fora de lugar (SQL em src) | Limpeza | P1 |
| SQL/Python duplicados | Limpeza | P2 |

### 1.3 Tecnologias Existentes

- **Frontend:** React 19, Vite 6, TypeScript
- **Backend/DB:** Supabase
- **IA:** Gemini (via AiCore), Azure OpenAI (RAG)
- **Monorepo:** npm workspaces (apps/web, packages/industry-pnld, industry-curriculum, graphics-profeplan)

---

## 2. Decisões Arquiteturais Principais

### AD-01: Orquestradores (Facade Pattern)

**Decisão:** Introduzir orquestradores para fluxos críticos (Planning, Assessment, PDI) em vez de lógica dispersa em componentes.

**Motivação:** PlanningManager com 11+ imports e 7 awaits; race conditions; impossível testar.

**Implementação:**
- `PlanningOrchestrator` — fluxo de planejamento trimestral e planos de aula
- `AssessmentOrchestrator` — geração de avaliações
- `PdiOrchestrator` — fluxo de adaptações PDI (opcional; PDI pode usar store antes)

**Estrutura:**
```
src/services/orchestration/
├── PlanningOrchestrator.ts
├── AssessmentOrchestrator.ts
├── types.ts
└── index.ts
```

**Contratos:**
- Orquestrador recebe `CreditManager`, `DataAccessLayer`, `EventBus` (injeção)
- Um try-catch por fluxo; side-effects via EventBus (fire-and-forget coordenado)
- Testes unitários com mocks dos colaboradores

---

### AD-02: Data Access Layer (DAL)

**Decisão:** Criar camada de acesso a dados que abstrai Supabase e serviços fragmentados.

**Motivação:** Múltiplos pontos de acesso direto ao Supabase; PdiService, PdiDocumentService, PdiBlock9Service dispersos.

**Implementação:**
- `DataAccessLayer` (ou `DAL`) com métodos por domínio
- Planning: `savePlan()`, `getGeneratedContents()`, `searchCurriculum()`, `searchEnemQuestions()`, `getPnldChapters()`
- PDI: `getOrCreatePdi()`, `updatePdiSection()`, `logPdiEvent()`, `exportPdiToDocx()`, `getStudentAdaptations()`

**Estrutura:**
```
src/services/dal/
├── DataAccessLayer.ts      # Interface principal
├── PlanningDAL.ts          # Operações de planejamento
├── PdiDAL.ts               # Operações PDI (consolida PdiService + PdiBlock9 + PdiExport)
├── SchoolDAL.ts            # Escolas, turmas, alunos
└── index.ts
```

**Regra:** Componentes e orquestradores **não** importam `supabase` diretamente; usam DAL.

---

### AD-03: Credit Manager

**Decisão:** Centralizar verificação e consumo de créditos em `CreditManager`.

**Motivação:** `checkUsageQuota` e `incrementUserUsage` espalhados; fire-and-forget causa inconsistências.

**Implementação:**
```typescript
interface CreditManager {
  executeWithCreditCheck<T>(userId: string, fn: () => Promise<T>, cost: number): Promise<T>;
  checkQuota(userId: string): Promise<{ allowed: boolean; message?: string }>;
}
```

**Regra:** Qualquer operação que consuma crédito passa por `executeWithCreditCheck`.

---

### AD-04: EventBus para Side-Effects

**Decisão:** Usar EventBus para efeitos secundários (memória, feedback, analytics) em vez de chamadas diretas.

**Motivação:** `addMemory`, `feedbackService.log` como fire-and-forget não coordenados.

**Implementação:**
- Eventos: `planning:generated`, `assessment:generated`, `pdi:adaptation:saved`
- Assinantes: `memoryService`, `feedbackService` escutam e processam
- Orquestrador publica; não conhece os assinantes

---

### AD-05: Consolidação PDI

**Decisão:** Unificar PdiService, PdiBlock9Service, PdiExportService em `PdiDocumentService` (já existente) e expor via `PdiDAL`.

**Motivação:** 4 arquivos com responsabilidades sobrepostas; desenvolvedor não sabe qual usar.

**Ações:**
1. Migrar `logEvent` de PdiService para PdiDocumentService
2. Migrar `getStudentAdaptations`, `getAdaptationStats` de PdiBlock9Service para PdiDocumentService
3. Migrar `exportPdiToDocx` de PdiExportService para PdiDocumentService
4. Atualizar `StudentPdiView` para usar PdiDocumentService (ou PdiDAL)
5. Deprecar e remover PdiService, PdiBlock9Service, PdiExportService

---

### AD-06: Migração questionService → SimulationFactory

**Decisão:** Remover `questionService`; toda busca de questões ENEM passa por SimulationFactory.

**Motivação:** questionService deprecated; PlanningManager ainda importa.

**Ações:**
1. Expor API do SimulationFactory para busca (ex.: `searchQuestions(context)`)
2. Atualizar PlanningOrchestrator/DAL para usar SimulationFactory
3. Remover questionService

---

### AD-07: Organização de Features

**Decisão:** Toda tela do Product Brief vira feature em `features/`; componentes reutilizáveis em `components/`.

**Mapeamento:**

| Product Brief | De (atual) | Para (target) |
|---------------|------------|---------------|
| Apresentações | components/PresentationCreator | features/Presentations/ |
| Meus Arquivos | components/DriveExplorer | features/Files/ |
| Minhas Turmas | components/ClassManager | features/Classes/ |
| Gestão Escolar | pages/SchoolDashboard | features/SchoolManager/ |
| Admin | components/Admin/ + features/Admin/ | features/Admin/ (unificado) |
| QuestionFinder | components/QuestionFinder/ | features/SimulationFactory/components/ |

**Regra:** `FeatureRenderer` continua roteando por ToolMode; cada ToolMode mapeia a uma feature em `features/`.

---

### AD-08: Serviços Agrupados por Domínio

**Decisão:** Organizar `services/` por domínio em subpastas.

**Estrutura alvo:**
```
services/
├── ai/                 # Mantém
├── dal/                # Novo (Data Access Layer)
├── orchestration/      # Novo (Orquestradores)
├── planning/           # PlanningService, etc.
├── pdi/                # PdiDocumentService (consolidado)
├── school/             # SchoolService, classService, studentService, teacherService
├── export/             # exportService, pdfService, presentationGenerator
├── credit/             # CreditManager (userService créditos)
└── shared/             # supabaseClient, memoryService, feedbackService, etc.
```

---

### AD-09: Arquivos SQL/Schema fora de src

**Decisão:** Mover SQL e schemas de `apps/web/src` para `infra/supabase/` ou `scripts/sql/`.

**Arquivos a mover:**
- fix_schools_rls.sql, teacher_memory.sql, erp_schema.sql, profiles_schema.sql, debug_db.ts

---

### AD-10: Renomear AdminPanel de SimulationFactory

**Decisão:** Renomear `features/SimulationFactory/components/AdminPanel.tsx` → `SimulationAdminPanel.tsx`.

**Motivação:** Evitar colisão com `components/Admin/AdminPanel.tsx`.

---

## 3. Padrões de Implementação

### 3.1 Nomenclatura

| Tipo | Padrão | Exemplo |
|------|--------|---------|
| Componente React | PascalCase | `PlanningCockpit`, `PdiAdaptationWidget` |
| Feature pasta | PascalCase | `Planning`, `SimulationFactory` |
| Serviço/classe | PascalCase | `PlanningOrchestrator`, `DataAccessLayer` |
| Arquivo TS/TSX | PascalCase para componentes | `PlanningManager.tsx` |
| Arquivo serviço | camelCase ou PascalCase | `planningService.ts` ou `PlanningService.ts` |
| Evento EventBus | `domain:action` | `planning:generated`, `pdi:adaptation:saved` |

### 3.2 Estrutura de Orquestrador

```typescript
// Padrão obrigatório
export class XOrchestrator {
  constructor(
    private dal: DataAccessLayer,
    private creditManager: CreditManager,
    private eventBus: EventBus,
    private aiService?: AiService
  ) {}

  async execute(context: XContext): Promise<XResult> {
    return this.creditManager.executeWithCreditCheck(
      context.userId,
      async () => {
        const enriched = await this.enrichContext(context);
        const result = await this.generate(enriched);
        await this.dal.persist(result);
        this.eventBus.publish('domain:action', result);
        return result;
      },
      context.creditCost ?? 1
    );
  }
}
```

### 3.3 Tratamento de Erros

- Orquestrador: um try-catch no ponto de entrada (ex.: `handleGeneratePlan`)
- DAL: propagar erros do Supabase; não engolir
- Componente: exibir mensagem ao usuário; não logar stack em produção

### 3.4 Testes

- Orquestradores: testes unitários com mocks de DAL, CreditManager, EventBus
- DAL: testes de integração opcionais; preferir E2E para fluxos críticos
- Componentes: testes de renderização e interação (React Testing Library)

---

## 4. Estrutura de Projeto Alvo

### 4.1 apps/web/src (após refatoração)

```
src/
├── features/
│   ├── Planning/           # Assistente + Planos de Aula
│   ├── TermPlanning/       # Planejamento Trimestral
│   ├── Assessment/         # Avaliações
│   ├── PDI/                # Adaptações PDI/DUA
│   ├── SimulationFactory/  # Banco ENEM (inclui QuestionFinder)
│   ├── Presentations/      # Apresentações (movido de components)
│   ├── Files/              # Meus Arquivos (movido de DriveExplorer)
│   ├── Classes/            # Minhas Turmas (movido de ClassManager)
│   ├── SchoolManager/      # Gestão Escolar (movido de pages)
│   └── Admin/              # Admin unificado
├── components/             # Apenas componentes reutilizáveis
│   ├── ui/                 # Botões, inputs, modais
│   ├── layout/             # Sidebar, MainLayout
│   └── shared/             # MarkdownRenderer, ErrorBoundary, etc.
├── services/
│   ├── ai/
│   ├── dal/
│   ├── orchestration/
│   ├── planning/
│   ├── pdi/
│   ├── school/
│   ├── export/
│   ├── credit/
│   └── shared/
├── contexts/
├── hooks/
├── layouts/
├── pages/                  # Apenas rotas (Landing, VerifyEmail, etc.)
├── schemas/
├── types/
└── utils/
```

### 4.2 packages/ (inalterado por ora)

- industry-pnld
- industry-curriculum
- graphics-profeplan

### 4.3 infra/ e scripts/

- SQL: consolidar em `infra/supabase/migrations/` ou `scripts/sql/`
- Scripts Python: desduplicar entre `scripts/` e `packages/` (P2)

---

## 5. Roadmap de Refatoração

### Fase 1 — Fundação (P0)

| # | Tarefa | Dependência | Critério de conclusão |
|---|--------|-------------|------------------------|
| 1.1 | Criar `CreditManager` | - | Interface + implementação com userService |
| 1.2 | Criar `EventBus` | - | Pub/sub mínimo; assinantes memory, feedback |
| 1.3 | Criar `DataAccessLayer` (interface) | - | Tipos e contratos |
| 1.4 | Implementar `PlanningDAL` | 1.3 | Métodos: savePlan, getGeneratedContents, searchCurriculum, searchEnemQuestions, getPnldChapters |
| 1.5 | Implementar `PlanningOrchestrator` | 1.1, 1.2, 1.4 | Substitui lógica em PlanningManager |
| 1.6 | Migrar PlanningManager para usar PlanningOrchestrator | 1.5 | 1 import; 1 try-catch; testes passando |

### Fase 2 — Consolidação PDI (P0)

| # | Tarefa | Dependência | Critério de conclusão |
|---|--------|-------------|------------------------|
| 2.1 | Consolidar PdiService + PdiBlock9Service + PdiExportService em PdiDocumentService | - | Um único serviço PDI |
| 2.2 | Criar PdiDAL | 2.1 | Encapsula PdiDocumentService |
| 2.3 | Atualizar StudentPdiView | 2.1 | Usa PdiDocumentService ou PdiDAL |
| 2.4 | Remover PdiService, PdiBlock9Service, PdiExportService | 2.2, 2.3 | Arquivos deletados |

### Fase 3 — questionService e geminiService (P0)

| # | Tarefa | Dependência | Critério de conclusão |
|---|--------|-------------|------------------------|
| 3.1 | Expor API de busca em SimulationFactory | - | searchQuestions(context) |
| 3.2 | Atualizar PlanningDAL para usar SimulationFactory | 3.1 | questionService removido de imports |
| 3.3 | Remover questionService | 3.2 | Arquivo deletado |
| 3.4 | Auditar geminiService vs AiPlanningService | - | Um único ponto de chamada Gemini |

### Fase 4 — Organização de Pastas (P1)

| # | Tarefa | Dependência | Critério de conclusão |
|---|--------|-------------|------------------------|
| 4.1 | Criar features/Presentations, migrar PresentationCreator | - | Feature isolada |
| 4.2 | Criar features/Files, migrar DriveExplorer | - | Idem |
| 4.3 | Criar features/Classes, migrar ClassManager | - | Idem |
| 4.4 | Criar features/SchoolManager, migrar SchoolDashboard | - | Idem |
| 4.5 | Unificar Admin em features/Admin | - | FeedbackReport + AdminPanel + RagIngestion |
| 4.6 | Mover QuestionFinder para SimulationFactory | - | Idem |
| 4.7 | Renomear SimulationFactory/AdminPanel → SimulationAdminPanel | - | Sem colisão |

### Fase 5 — Limpeza (P1)

| # | Tarefa | Dependência | Critério de conclusão |
|---|--------|-------------|------------------------|
| 5.1 | Mover SQL/schema de apps/web/src | - | infra/ ou scripts/ |
| 5.2 | Reorganizar services/ por domínio | 1-4 | Subpastas implementadas |

### Fase 6 — Opcional (P2)

- Consolidar SQL (fix_*); documentar precedência
- Desduplicar scripts Python
- PdiOrchestrator + PDI store (Zustand) conforme EXEMPLOS_REFATORACAO
- AssessmentOrchestrator

---

## 6. Critérios de Sucesso da Refatoração

- [ ] PlanningManager com ≤ 5 imports diretos; fluxo via PlanningOrchestrator
- [ ] Nenhum componente importa `supabase` diretamente (exceto DAL)
- [ ] PDI com um único serviço (PdiDocumentService)
- [ ] questionService e PdiService/PdiBlock9Service/PdiExportService removidos
- [ ] Toda feature do Product Brief em `features/`
- [ ] SQL e schemas fora de `apps/web/src`
- [ ] Testes unitários para PlanningOrchestrator
- [ ] WAU estável ou em crescimento durante refatoração
- [ ] Tempo médio de geração de plano < 3 minutos mantido

---

## 7. Referências

- Product Brief: `_bmad-output/planning-artifacts/product-brief-PROFEPLAN-2026-02-28.md`
- Diagnóstico: `_bmad-output/planning-artifacts/DIAGNOSTICO-CODE-REVIEW-PROFEPLAN-2026-02-28.md`
- EXEMPLOS_REFATORACAO.md
- ANALISE_ORCHESTRATION_FLUXOS.md
- ANALISE_TECNICA_REDUNDANCIAS.md

---

**Documento de Arquitetura concluído.** Pronto para iniciar a Fase 1 da refatoração.
