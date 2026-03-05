# 🔍 DIAGNÓSTICO — Code Review PROFEPLAN v4.0

**Data:** 2026-02-28  
**Foco:** Dívida técnica, desorganização de pastas/arquivos, redundâncias  
**Contexto:** v4.0 com modificações não consolidadas; preparação para refatoração e escalabilidade

---

## 1. RESUMO EXECUTIVO

| Categoria | Severidade | Qtd | Prioridade |
|-----------|------------|-----|------------|
| **Dívida técnica (orquestração)** | 🔴 CRÍTICA | 2 fluxos | P0 |
| **Redundâncias de serviços** | 🔴 ALTA | 4+ grupos | P0 |
| **Desorganização de pastas** | 🟡 MÉDIA | 8+ itens | P1 |
| **Arquivos fora de lugar** | 🟡 MÉDIA | 5+ arquivos | P1 |
| **SQL/Python duplicados** | 🟠 ALTA | 248 SQL, 150+ Python | P2 |
| **Código morto/deprecado** | 🟡 MÉDIA | 15+ serviços | P1 |

---

## 2. DÍVIDA TÉCNICA — Orquestração

### 2.1 Fluxo #1: Planejamento Trimestral + PDI (CRÍTICO)

**Complexidade:** ~70% da lógica de negócio | **Dispersão:** 12 arquivos | **Dependências:** 16

**Problemas identificados:**
- `PlanningManager.tsx` com **11+ imports** diretos; acoplamento alto
- 7+ awaits sequenciais sem coordenação; race conditions potenciais
- Fire-and-forget em `incrementUserUsage`, `addMemory`, `feedbackService.log`
- Sem try-catch coordenado; tratamento de erro disperso
- Lógica espalhada: `userService` → `supabaseService` → `searchService` → `questionService` → `AiPlanningService` → `AiChatService` → `PlanningService` → `memoryService` → `feedbackService`

**Evidência (PlanningManager imports):**
```
geminiService, searchService, questionService, PlanningService, supabase,
memoryService, feedbackService, markdownParser, exportService, databaseService,
PlanningAuthorityService (dynamic)
```

### 2.2 Fluxo #2: Geração de Planos de Aula (CRÍTICO)

**Padrão similar:** múltiplos serviços chamados inline; sem orquestrador; difícil testar.

**Recomendação:** Introduzir `PlanningOrchestrator` (Facade) com `CreditManager`, `DataAccessLayer`, `EventBus` — conforme `EXEMPLOS_REFATORACAO.md`.

---

## 3. REDUNDÂNCIAS DE SERVIÇOS

### 3.1 PDI — 4 arquivos fragmentados

| Arquivo | Responsabilidade | Status | Problema |
|---------|------------------|--------|----------|
| `PdiService.ts` | logEvent, pdi_records | Deprecado | Ainda usado por `StudentPdiView` |
| `PdiDocumentService.ts` | getOrCreatePdi, updatePdiSection, upsertTeacherEntry | Principal | OK |
| `PdiBlock9Service.ts` | getStudentAdaptations, getAdaptationStats | Fragmentado | Deveria estar em PdiDocumentService |
| `PdiExportService.ts` | exportPdiToDocx | Deprecado | Lógica migrada para PdiDocumentService |

**Impacto:** Desenvolvedor não sabe qual usar para cada operação.

### 3.2 questionService vs SimulationFactory

- `questionService.ts`: marcado deprecated; migração para SimulationFactory
- `searchQuestions`, `fetchEnemQuestions` ainda importados por PlanningManager

### 3.3 geminiService vs AiPlanningService vs AiChatService

- `geminiService` deprecated; conflita com `AiCore` + `AiPlanningService`
- Múltiplos pontos de chamada à API Gemini

### 3.4 Dois AdminPanel com mesmo nome

- `components/Admin/AdminPanel.tsx` — admin da aplicação
- `features/SimulationFactory/components/AdminPanel.tsx` — admin de simulados

**Risco:** Confusão em imports; possível colisão.

---

## 4. DESORGANIZAÇÃO DE PASTAS E ARQUIVOS

### 4.1 Features em locations inconsistentes

| Feature (Product Brief) | Local atual | Deveria estar |
|------------------------|-------------|---------------|
| Apresentações (Tela 6) | `components/PresentationCreator` | `features/Presentations/` |
| Meus Arquivos | `components/DriveExplorer` | `features/Files/` |
| Minhas Turmas | `components/ClassManager` | `features/Classes/` |
| Banco ENEM (QuestionFinder) | `components/QuestionFinder/` | `features/SimulationFactory/` |
| Gestão Escolar | `pages/SchoolDashboard` | `features/SchoolManager/` |
| Admin principal | `components/Admin/` | `features/Admin/` |

**Convenção ausente:** feature vs componente vs página.

### 4.2 features/Admin vs components/Admin

- `features/Admin/`: apenas `FeedbackReport`
- `components/Admin/`: `AdminPanel`, modais, `RagIngestionWidget`
- Inconsistência: Admin fragmentado em duas pastas.

### 4.3 Serviços na raiz sem agrupamento por domínio

```
services/
├── ai/           # OK — subpasta
├── pdi/          # OK — subpasta
├── ProfileService.ts, SchoolService.ts, classService.ts, databaseService.ts,
│   exportService.ts, feedbackService.ts, memoryService.ts, ... (35+ na raiz)
```

**Recomendação:** Agrupar por domínio: `services/planning/`, `services/school/`, `services/export/`, etc.

### 4.4 Arquivos SQL/schema dentro de apps/web/src

| Arquivo | Local atual | Deveria estar |
|---------|-------------|---------------|
| `fix_schools_rls.sql` | apps/web/src | infra/supabase/ ou scripts/sql/ |
| `teacher_memory.sql` | apps/web/src | idem |
| `erp_schema.sql` | apps/web/src | idem |
| `profiles_schema.sql` | apps/web/src | idem |
| `debug_db.ts` | apps/web/src | scripts/ ou .diagnostics/ |

---

## 5. SQL E PYTHON — DUPLICAÇÃO MACIÇA

### 5.1 SQL (248 scripts — INVENTARIO_CODIGO_MORTO.md)

- **fix_admin_*.sql:** 11 scripts; consolidar
- **fix_rls_*.sql:** 13 scripts; RLS não resolvido definitivamente
- **fix_infinite_recursion_*.sql:** 2 versões (v1 falhou)
- **fix_school_*.sql:** 4 versões
- **Migrações:** ~35 em infra/supabase; algumas sem data no nome

### 5.2 Python (150+ scripts)

- 40+ scripts duplicados entre `scripts/`, `packages/`, `ProfeplanHub/`
- Ex: `populate_pnld_livros.py` em `scripts/pnld/` e `packages/industry-pnld/src/`
- `integrador_pnld_livros.py` em scripts e packages

---

## 6. TOOLMODE E SIDEBAR — INCONSISTÊNCIA

- **ToolMode enum:** inclui `ACTIVITIES`, `AUDITOR`, `SPECIALIST`, `HISTORY` sem item correspondente na Sidebar
- Sidebar filtra por feature; alguns modos podem estar órfãos

---

## 7. PONTOS POSITIVOS

- SimulationFactory com API clara (`index.ts`) e exports bem definidos
- PDI com subestrutura consistente (Official/sections, components/forms)
- `FeatureRenderer` centraliza roteamento por ToolMode
- Product Brief mapeia bem os módulos
- Packages Python com README e propósito
- Migrações Supabase com data no nome (maioria)

---

## 8. PRIORIZAÇÃO PARA REFATORAÇÃO

| Prioridade | Ação | Esforço | Impacto |
|------------|------|---------|---------|
| **P0** | Criar PlanningOrchestrator (Facade) | Alto | Crítico |
| **P0** | Consolidar PdiService + PdiBlock9Service + PdiExportService → PdiDocumentService | Médio | Alto |
| **P0** | Migrar questionService → SimulationFactory; remover imports antigos | Baixo | Médio |
| **P1** | Mover PresentationCreator, DriveExplorer, ClassManager para features/ | Médio | Médio |
| **P1** | Mover SQL/schema de apps/web/src para infra/ ou scripts/ | Baixo | Baixo |
| **P1** | Renomear SimulationFactory/AdminPanel → SimulationAdminPanel | Baixo | Baixo |
| **P2** | Consolidar SQL (fix_*); documentar precedência | Alto | Médio |
| **P2** | Desduplicar scripts Python entre scripts/ e packages/ | Médio | Médio |

---

## 9. REFERÊNCIAS

- `ANALISE_TECNICA_REDUNDANCIAS.md` — redundâncias PDI, StudentService, imports
- `ANALISE_ORCHESTRATION_FLUXOS.md` — fluxos Planning e PDI
- `EXEMPLOS_REFATORACAO.md` — PlanningOrchestrator, Facade, DAL
- `INVENTARIO_CODIGO_MORTO.md` — SQL, Python, TypeScript duplicados
- `_bmad-output/planning-artifacts/product-brief-PROFEPLAN-2026-02-28.md` — Product Brief e MVP Scope

---

**Próximo passo:** Documento de Arquitetura (create-architecture) com plano de refatoração e consolidação.
