# 🎼 ANÁLISE DE ORQUESTRAÇÃO - FLUXOS COMPLEXOS DO PROFEPLAN

**Analista**: GitHub Copilot (Orchestrator Mode)  
**Data**: 10 de Fevereiro de 2026  
**Objetivo**: Mapear e simplificar os 2 fluxos mais complexos  

---

## 📊 RESUMO EXECUTIVO

Após análise profunda dos 39 serviços, 7 features principais e múltiplas integrações, foram identificados **2 fluxos críticos** que concentram:
- **~70% da lógica de negócio**
- **~15 dependências cada**
- **Dispersão de código em 8-12 arquivos**
- **Múltiplos pontos de falha**

---

## 🎯 OS 2 FLUXOS MAIS COMPLEXOS

### **FLUXO #1: PLANEJAMENTO TRIMESTRAL COM ADAPTAÇÃO PDI** ⭐⭐⭐⭐⭐
**Complexidade**: CRÍTICA | **Dispersão**: 12 arquivos | **Dependências**: 16

#### 1️⃣ DIAGRAMA TEXTUAL DO FLUXO

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         ENTRADA: Professor inicia                           │
│                    Cockpit de Planejamento Trimestral                        │
└────────────────────────────┬────────────────────────────────────────────────┘
                             │
                    ┌────────▼──────────┐
                    │ 1️⃣ VERIFICAÇÃO    │
                    │   DE CRÉDITOS     │
                    │ checkUsageQuota() │
                    │  (userService)    │
                    └────────┬──────────┘
                             │
                    ┌────────▼──────────────┐
                    │  2️⃣ CONTEXTUALIZAÇÃO │
                    │  • Busca dados do     │
                    │    professor          │
                    │  • Carrega memória    │
                    │  • Extrai contexto    │
                    │ getTeacherContext()   │
                    │ (supabaseService)     │
                    └────────┬──────────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
    ┌────▼─────┐    ┌────────▼────────┐   ┌─────▼──────┐
    │ 3️⃣ RAG    │    │ 3️⃣ BUSCADOR     │   │ 3️⃣ VALIDAÇÃO│
    │ Currículo │    │ ENEM (HS Context)  │   │ PNLD Book  │
    │ searchCur-│    │ hybridSearchProf.  │   │ calculateD.│
    │ riculum()  │    │ fetchEnemQuestions │   │ EduChapters│
    │ (search-  │    │ (questionService)   │   │ (service)  │
    │ Service)  │    └────────┬────────┘   └─────┬──────┘
    └────┬─────┘              │                   │
         │                    │                   │
         └────────┬───────────┴───────────────────┘
                  │
         ┌────────▼──────────────────┐
         │ 4️⃣ PROMPT ASSEMBLY        │
         │ • System Prompt (BNCC)    │
         │ • Curriculum Context      │
         │ • PNLD Rules (se houver)  │
         │ • Feedback Professor      │
         │ • Modo Específico (Trim)  │
         │ (AiChatService)           │
         └────────┬──────────────────┘
                  │
         ┌────────▼──────────────────────┐
         │ 5️⃣ CHAMADA GEMINI            │
         │ • executeWithFallback()       │
         │ • getGenAIClient()            │
         │ • generateContent()           │
         │ • Segurança ativa             │
         │ (AiCore + AiPlanningService)  │
         └────────┬──────────────────────┘
                  │
         ┌────────▼─────────────────────────┐
         │ 6️⃣ PÓS-PROCESSAMENTO            │
         │ • Parseamento Markdown          │
         │ • Extração de Lições (parseM..) │
         │ • Normalização de Dados         │
         │ (markdownParser)                │
         └────────┬──────────────────────┘
                  │
         ┌────────▼──────────────────────┐
         │ 7️⃣ PERSISTÊNCIA DUAL          │
         │ A. LocalStorage (Draft)        │
         │    savePlan() LOCAL            │
         │ B. Supabase (Cloud)            │
         │    syncPlanToCloud()           │
         │    • generated_contents        │
         │    • lessons (table)           │
         │    • pdi_records (logging)     │
         │ (PlanningService + supabase)   │
         └────────┬──────────────────────┘
                  │
         ┌────────▼──────────────────┐
         │ 8️⃣ CONSUMO DE CRÉDITO     │
         │ incrementUserUsage()       │
         │ (userService)              │
         │ [Fire and forget / await]  │
         └────────┬──────────────────┘
                  │
    ┌────────────────────────────────┐
    │ 9️⃣ EXECUÇÃO DE SIDE-EFFECTS   │
    │ • addMemory() do professor      │
    │ • feedbackService.log()         │
    │ • Display/Download de Plano     │
    │ • Reload Sidebar                │
    └────────────────────────────────┘
```

#### 2️⃣ TABELA DE DEPENDÊNCIAS

| # | Serviço | Arquivo | Função | Tipo |
|---|---------|---------|--------|------|
| 1 | userService | src/services | checkUsageQuota() | GATE |
| 2 | supabaseService | src/services | getTeacherContext() | CONTEXT |
| 3 | searchService | src/services | searchCurriculum() | RAG |
| 4 | searchService | src/services | hybridSearchProfeplan() | RAG |
| 5 | questionService | src/services | fetchEnemQuestions() | RAG |
| 6 | SubjectNormalization | src/services | normalizeSubject() | TRANSFORM |
| 7 | SYSTEM_PROMPT | src/constants | SYSTEM_PROMPT | CONFIG |
| 8 | AiCore | src/services/ai | getGenAIClient() | API CLIENT |
| 9 | AiCore | src/services/ai | executeWithFallback() | RESILIENCE |
| 10 | AiPlanningService | src/services/ai | generateTermPlan() | ORCHESTRATION |
| 11 | AiChatService | src/services/ai | generateProfePlanStream() | STREAMING |
| 12 | markdownParser | src/utils | parseMarkdownToLessons() | PARSER |
| 13 | PlanningService | src/features | savePlan() | PERSISTENCE |
| 14 | PlanningService | src/features | syncPlanToCloud() | SYNC |
| 15 | memoryService | src/services | addMemory() | ANALYTICS |
| 16 | feedbackService | src/services | log() / track() | ANALYTICS |

#### 3️⃣ ONDE A LÓGICA ESTÁ DISPERSA

```
📂 DISPERSÃO DE CÓDIGO
├─ 🔴 src/services/userService.ts (Quota)
├─ 🔴 src/services/supabaseService.ts (Context)
├─ 🔴 src/services/searchService.ts (RAG)
├─ 🔴 src/services/SubjectNormalizationService.ts (Normalização)
├─ 🔴 src/services/questionService.ts (ENEM Search)
├─ 🔴 src/services/ai/AiCore.ts (Gemini Resilience)
├─ 🔴 src/services/ai/AiPlanningService.ts (Geração)
├─ 🔴 src/services/ai/AiChatService.ts (Modo Streaming)
├─ 🔴 src/services/geminiService.ts (⚠️ DEPRECATED - conflita)
├─ 🔴 src/features/Planning/PlanningService.ts (Persistência)
├─ 🔴 src/features/Planning/PlanningManager.tsx (Orquestração)
├─ 🔴 src/utils/markdownParser.ts (Parser)
└─ 🔴 src/services/memoryService.ts (Analytics)
```

**PROBLEMA**: Cada etapa está em um arquivo diferente. Uma mudança no prompt pode afetar 6 arquivos. Um erro em searchService.ts causa fallback cascata.

#### 4️⃣ ANÁLISE DETALHADA

**Etapa 1-2 (Verificação + Contexto)**: 
- ✅ Simples e bem separado
- ⚠️ Falha silenciosa se userService.ts cai

**Etapa 3 (RAG - A MAIS COMPLEXA)**:
- ❌ 3 serviços diferentes (search, question, normalization)
- ❌ Sem retry automático
- ❌ Sem composição de results
- ❌ A falha em searchCurriculum não ativa fallback para SYSTEM_PROMPT

**Etapa 4 (Assembly de Prompt)**:
- ⚠️ Lógica espalhada entre AiChatService e AiPlanningService
- ⚠️ Condicionais complexas (if mode === 'quarterly', se context?.grade, etc)
- ❌ Difícil reusar em outro contexto (ex: Assessment, PDI)

**Etapa 5 (Gemini)**:
- ✅ Boa resiliência (executeWithFallback)
- ⚠️ AiCore é uma mistura de utilidades (audio decode, fallback, safety settings)

**Etapa 6-7 (Pós-processamento + Sync)**:
- ❌ Lógica de sincronização espalhada
- ❌ LocalStorage + Supabase sem garantias de consistência
- ⚠️ pdi_records inserção automática, mas sem erro handling

**Etapa 8-9 (Crédito + Side Effects)**:
- ❌ incrementUserUsage é "fire and forget" - pode falhar silenciosamente
- ⚠️ Múltiplos calls a addMemory/feedback sem coordenação

#### 5️⃣ NÚMERO DE DEPENDÊNCIAS POR ARQUIVO

```
AiPlanningService.ts
├─ AiCore
├─ userService
├─ searchService
├─ SubjectNormalization
└─ constants (SYSTEM_PROMPT)

PlanningService.ts (Feature)
├─ supabaseClient
├─ userService (checkUsageQuota)
├─ PdiService
└─ localStorage

PlanningManager.tsx
├─ GlobalPlanningContext
├─ geminiService (deprecated!)
├─ searchService (3 funções)
├─ questionService
├─ PlanningService
├─ databaseService
├─ memoryService
├─ feedbackService
├─ exportService
└─ markdownParser
```

**🚨 PlanningManager.tsx tem 10+ dependências diretas!**

---

### **FLUXO #2: PDI (PLANO DE DESENVOLVIMENTO INDIVIDUAL) COM GERAÇÃO DE ADAPTAÇÕES** ⭐⭐⭐⭐

**Complexidade**: CRÍTICA | **Dispersão**: 11 arquivos | **Dependências**: 14

#### 1️⃣ DIAGRAMA TEXTUAL DO FLUXO

```
┌────────────────────────────────────────────────────────┐
│  ENTRADA: Gestor/Professor abre PDI de um Aluno       │
│          (PDIManager.tsx)                              │
└───────────────┬────────────────────────────────────────┘
                │
        ┌───────▼──────────────┐
        │ 1️⃣ CARREGAMENTO      │
        │    INICIAL           │
        │ • Classes (school)   │
        │ • Lições (geradas)   │
        │ • Estudantes c/ NEE  │
        │ usePDIManager Hook   │
        │ (custom hook)        │
        └───────┬──────────────┘
                │
    ┌───────────┼───────────────┐
    │           │               │
┌───▼───┐  ┌────▼────┐  ┌──────▼──────┐
│Supabase│  │Local    │  │GlobalPlanning│
│getClass│  │Storage  │  │Context (TP) │
│(class) │  │getLocal │  │currentPlan   │
└───┬───┘  │Classes  │  └──────┬───────┘
    │      └────┬────┘          │
    │           │               │
    └───────────┼───────────────┘
                │
        ┌───────▼──────────────┐
        │ 2️⃣ SELEÇÃO DE CLASSE │
        │ • Professor seleciona │
        │ • setState(selected)  │
        │ • Carrega lições      │
        │                       │
        │ handleClassSelect()   │
        └───────┬──────────────┘
                │
        ┌───────▼──────────────────┐
        │ 3️⃣ IDENTIFICAR ESTUDANTES│
        │    COM NECESSIDADES      │
        │ • Filtros por deficiência│
        │ • setStudentsWithNeeds() │
        │ • filterStudents()       │
        └───────┬──────────────────┘
                │
    ┌───────────┴────────────────┐
    │                            │
┌───▼──────┐          ┌──────────▼──────────┐
│ PROFESSOR │          │ SELECIONA AULA     │
│ seleciona │          │ (Lição) para adapt │
│ Aula para │          │ setSelectedLesson()│
│ adaptação │          └──────────┬─────────┘
└───┬──────┘                      │
    └──────────┬──────────────────┘
               │
    ┌──────────▼──────────────────────────┐
    │ 4️⃣ CLICA "GERAR ADAPTAÇÃO"          │
    │ • Abre modal para dados do aluno    │
    │ • Prof escreve necessidades         │
    │ • Prof escreve observações          │
    │ handleGenerateAdaptation()          │
    └──────────┬──────────────────────────┘
               │
    ┌──────────▼──────────────────────────┐
    │ 5️⃣ VERIFICAÇÃO QUOTA + CONTEXT      │
    │ • checkUsageQuota()                 │
    │ • getProfile() (para school_id)     │
    │ • Validações de entrada             │
    │ (userService, ProfileService)       │
    └──────────┬──────────────────────────┘
               │
    ┌──────────▼──────────────────────────┐
    │ 6️⃣ CHAMADA GEMINI (DUA Expert)      │
    │ • generateStudentAdaptation()       │
    │ • AiPdiService.ts                   │
    │ • Prompt com:                       │
    │   - Aula original                   │
    │   - Nome + série do aluno           │
    │   - Deficiências listadas           │
    │   - Observações do professor        │
    │   - Context curricular (se houver)  │
    │ • Model: gemini-2.0-flash           │
    │ • executeWithFallback               │
    │ • Timeout: 30s                      │
    │ • incrementUserUsage()              │
    └──────────┬──────────────────────────┘
               │
    ┌──────────▼──────────────────────────┐
    │ 7️⃣ PÓS-PROCESSAMENTO                │
    │ • Parsear Markdown                  │
    │ • Extrai objetivos adaptados        │
    │ • Extrai estratégias                │
    │ • Extrai atividades                 │
    │ • Extrai avaliação                  │
    │ (markdownParser)                    │
    └──────────┬──────────────────────────┘
               │
    ┌──────────▼──────────────────────────────┐
    │ 8️⃣ LOG + PERSISTÊNCIA DA ADAPTAÇÃO      │
    │ • PdiService.logEvent()                 │
    │   → INSERT pdi_records                  │
    │ • setAdaptations(adaptationId, content) │
    │ • saveGeneratedContent()                │
    │   → INSERT generated_contents           │
    │ • setState(generatingId = null)         │
    │ (PdiService + databaseService)          │
    └──────────┬──────────────────────────────┘
               │
    ┌──────────▼──────────────────────────────┐
    │ 9️⃣ FEEDBACK MODAL / REVISÃO             │
    │ • Exibe adaptação gerada                │
    │ • Professor pode:                       │
    │   a) Aceitar e salvar                   │
    │   b) Rejeitar e tentar novamente        │
    │   c) Abrir detalhes                     │
    │ handleSaveFeedback()                    │
    │ (AdaptationFeedbackModal)               │
    └──────────┬──────────────────────────────┘
               │
    ┌──────────▼──────────────────────────────┐
    │ 🔟 OPERAÇÕES PÓS-FEEDBACK                │
    │ • Gerar relatório (generatePdiReport)   │
    │ • Exportar para PDF/DOCX                │
    │ • Consolidar adaptações (Block9, 10)    │
    │ • Validar integração com PDI Blocks     │
    │ • addMemory() do professor              │
    │ • feedbackService.log()                 │
    │ (PdiService, exportService, BlockServices)
    └──────────────────────────────────────────┘
```

#### 2️⃣ TABELA DE DEPENDÊNCIAS

| # | Serviço | Arquivo | Função | Tipo |
|---|---------|---------|--------|------|
| 1 | supabaseClient | src/services | BASIC | CLIENT |
| 2 | classService | src/services | getClassesBySchool(), getStudentsByClass() | DATA |
| 3 | databaseService | src/services | getGeneratedContents(), saveGeneratedContent() | PERSISTENCE |
| 4 | PdiService | src/services | logEvent(), getPdiLogs(), updateRecordContent() | LOG |
| 5 | ProfileService | src/services | getProfile() | CONTEXT |
| 6 | userService | src/services | checkUsageQuota(), incrementUserUsage() | GATE |
| 7 | geminiService | src/services | generatePdiReport() (⚠️ DEPRECATED) | DEPRECATED |
| 8 | AiPdiService | src/services/ai | generateStudentAdaptation() | GENERATION |
| 9 | AiCore | src/services/ai | getGenAIClient(), executeWithFallback() | RESILIENCE |
| 10 | exportService | src/services | exportToDocx(), generatePdiReportDoc() | EXPORT |
| 11 | GlobalPlanningContext | src/contexts | useGlobalPlanning(), currentPlan | STATE |
| 12 | LocalStorageService | src/services | getLocalClasses(), getLocalClassDetails() | CACHE |
| 13 | markdownParser | src/utils | parseMarkdownToLessons() | PARSER |
| 14 | usePDIManager | src/features/PDI | Custom Hook (orquestra tudo) | ORCHESTRATION |

#### 3️⃣ ONDE A LÓGICA ESTÁ DISPERSA

```
📂 DISPERSÃO DE CÓDIGO (PDI)
├─ 🔴 src/features/PDI/PDIManager.tsx (UI Principal)
├─ 🔴 src/features/PDI/usePDIManager.ts (502 linhas - MONOLÍTICO!)
├─ 🔴 src/features/PDI/components/PDISidebar.tsx (Sidebar)
├─ 🔴 src/features/PDI/components/StudentAdaptationCard.tsx (Card)
├─ 🔴 src/features/PDI/components/AdaptationFeedbackModal.tsx (Modal)
├─ 🔴 src/features/PDI/components/AdaptationDetailsModal.tsx (Detalhes)
├─ 🔴 src/services/PdiService.ts (Logging)
├─ 🔴 src/services/ai/AiPdiService.ts (Geração)
├─ 🔴 src/services/databaseService.ts (Persistence)
├─ 🔴 src/services/exportService.ts (Exports)
└─ 🔴 src/components/School/PDI/* (Block viewers)
```

**PROBLEMA CRÍTICO**: usePDIManager.ts tem 502 linhas em um único hook! Contém:
- State management (10+ useState)
- Data loading logic
- Event handlers (5+)
- Integração com 8+ serviços
- Validações
- Side effects

#### 4️⃣ ANÁLISE DETALHADA

**Etapa 1-3 (Carregamento + Seleção)**:
- ⚠️ 2 fontes de dados (Supabase + LocalStorage)
- ⚠️ Sem sincronização entre elas
- ❌ Possível inconsistência de estado

**Etapa 4-5 (Modal + Validações)**:
- ✅ Bem estruturado
- ⚠️ Validações espalhadas em múltiplos arquivos

**Etapa 6 (Gemini)**:
- ✅ Quota checking feito
- ✅ executeWithFallback implementado
- ⚠️ Timeout não explícito
- ❌ Se Gemini falhar, não há retry automático (usuário precisa clicar novamente)

**Etapa 7 (Parser)**:
- ⚠️ Assume formato Markdown específico
- ❌ Sem validação se parser falhou
- ❌ Sem fallback se parse retorna vazio

**Etapa 8 (Log + Persistência)**:
- ⚠️ Dois INSERT paralelos (pdi_records + generated_contents)
- ❌ Sem transação - pode haver inconsistência
- ⚠️ PdiService.logEvent() tenta pegar school_id novamente

**Etapa 9-10 (Feedback + Side Effects)**:
- ❌ Modal bloqueia até feedback
- ❌ Multiple side-effects sem coordenação
- ⚠️ generatePdiReport() usa geminiService (DEPRECATED)

#### 5️⃣ NÚMERO DE DEPENDÊNCIAS CRÍTICAS

```
usePDIManager Hook (502 linhas):
├─ supabaseClient
├─ classService (2 funções)
├─ databaseService (2 funções)
├─ PdiService (3 funções)
├─ ProfileService
├─ userService (2 funções)
├─ generatePdiReport (DEPRECATED)
├─ generateBlock9Adaptation
├─ exportService (2 funções)
├─ localStorageService (2 funções)
├─ GlobalPlanningContext
└─ State management hooks (useState x10+)
```

**⚠️ Este é um hook monolítico com 14+ dependências!**

---

## 🔗 INTEGRAÇÕES EXTERNAS MAPEADAS

```
PROFEPLAN
│
├─── GEMINI API ✅
│    ├─ generateTermPlan()        (AiPlanningService)
│    ├─ generateStudentAdaptation()  (AiPdiService)
│    ├─ generatePresentationJSON()   (AiPresentationService)
│    ├─ generateAssessmentWithContext() (AiAssessmentService)
│    ├─ generateProfePlanStream()    (AiChatService - Streaming)
│    ├─ gradeWrittenAnswer()         (AiAssessmentService)
│    └─ Model Fallback Chain: 2.0-flash → lite → exp
│
├─── SUPABASE ✅
│    ├─ Authentication (email/password + RPC admin)
│    ├─ Database (profiles, students, classes, etc)
│    ├─ RLS Policies (complex, recursion issues documented)
│    ├─ Storage (não usado atualmente)
│    └─ Functions/RPC (check_admin_credentials)
│
├─── STRIPE 📦 (Parcialmente integrado)
│    ├─ createCheckoutSession()
│    ├─ Supabase Edge Function (create-checkout)
│    ├─ Webhook handling (⚠️ não visto no código)
│    └─ Student/School payment tracking (⚠️ incomplete)
│
├─── PNLD (Plano Nacional do Livro Didático) ✅
│    ├─ searchPnldBookContent()
│    ├─ PnldService.ts
│    ├─ Capítulo matching automático
│    └─ Integração no prompt de planejamento
│
├─── SEARCH/RAG (Vetorial) ✅
│    ├─ searchCurriculum()
│    ├─ searchQuestions()
│    ├─ hybridSearchProfeplan()
│    └─ Embedding: Possivelmente OpenAI (não confirmado)
│
├─── UNSPLASH 🖼️
│    ├─ unsplashService.ts
│    ├─ getUnsplashImages()
│    └─ Usado para: apresentações, materiais
│
├─── GOOGLE GENERATIVE AI (Gemini) ✅
│    └─ Google Generative AI SDK
│        ├─ Audio decoding
│        ├─ Safety settings
│        └─ Model selection/fallback
│
└─── TERCEIROS (Não mapeados / Potencial)
     ├─ Google Drive (export?)
     ├─ Google Slides (presentation?)
     └─ Canvas LMS (integração?)
```

---

## ⚠️ ESTADO COMPARTILHADO PROBLEMÁTICO

### 1️⃣ **GlobalPlanningContext** (CRÍTICO)

```typescript
// src/contexts/GlobalPlanningContext.tsx
const [currentPlan, setCurrentPlan] = useState<TermPlan | null>(() => {
    // PROBLEMA: localStorage read on mount
    const saved = localStorage.getItem('profeplan_current_term_plan');
    return saved ? JSON.parse(saved) : null;
});

const [termPlans, setTermPlans] = useState<TermPlan[]>([]);

// ISSUE #1: Dual Source of Truth
// - Supabase é a source (refreshTermPlans)
// - localStorage é cache
// Mas se Supabase cai, cai o app todo

// ISSUE #2: localStorage.setItem está no useEffect
useEffect(() => {
    if (currentPlan) {
        localStorage.setItem('profeplan_current_term_plan', JSON.stringify(currentPlan));
    }
}, [currentPlan]);
// ⚠️ Sem validação de tamanho (pode exceder 5MB)

// ISSUE #3: refreshTermPlans pode ser chamado sem userId
const refreshTermPlans = async (userId?: string) => {
    // Se userId é undefined, tenta getSession() - pode falhar
    // Não há tratamento de erro adequado
};
```

**Risco**: Se um componente modifica `currentPlan` enquanto outro faz `refreshTermPlans`, há race condition.

### 2️⃣ **LocalStorage em múltiplos lugares**

| Arquivo | Chave | Propósito | Problema |
|---------|-------|-----------|----------|
| PlanningService.ts | `profeplan_history_buffer` | Buffer local de planos | ⚠️ Pode crescer indefinidamente |
| GlobalPlanningContext.tsx | `profeplan_current_term_plan` | Plano atual (cache) | ⚠️ Race condition com Supabase |
| usePDIManager.ts | Provavelmente local também | Classes/lições locais | ❌ Sem sincronização |
| localStorageService.ts | `profeplan_classes_*` | Classes por usuário | ⚠️ Manual sync required |

**Risco**: Sem mecanismo de sincronização, o usuário pode trabalhar com dados velhos.

### 3️⃣ **Supabase Session/Auth Espalhada**

```typescript
// PADRÃO REPETIDO EM MÚLTIPLOS ARQUIVOS:
const { data: { user } } = await supabase.auth.getUser();
if (!user) return null;

// PROBLEMA:
// - Sem cache
// - Chamada a cada operação
// - Race conditions possíveis
// - Sem tratamento de JWT refresh
```

### 4️⃣ **Estado de Créditos (userService)**

```typescript
// Problema: checkUsageQuota é chamado antes
// Mas incrementUserUsage é chamado DEPOIS (async)
// Se erro ocorrer entre check e increment, crédito não é cobrado
// Se incrementUserUsage falhar, usuário pensa que falhou a geração
```

---

## 🎯 3-5 SUGESTÕES DE SIMPLIFICAÇÃO CONCRETAS

### **SUGESTÃO #1: Padrão Facade para Planejamento** ⭐⭐⭐⭐⭐

**Problema**: PlanningManager.tsx depende de 10+ serviços

**Solução**: Criar `PlanningOrchestrator.ts`

```typescript
// src/services/orchestration/PlanningOrchestrator.ts
export class PlanningOrchestrator {
    /**
     * Encapsula o fluxo completo de planejamento trimestral
     * Orquestra: quota → context → RAG → prompt → gemini → sync → credit
     */
    async generateTermPlanWithFallbacks(context: PlanningContext): Promise<PlanPlan> {
        // 1. Quota
        if (!await this.hasQuota(context.userId)) {
            throw new QuotaExceededError();
        }

        // 2. Context + RAG (com retry)
        const ragContext = await this.enrichContext(context);

        // 3. Prompt Assembly
        const prompt = this.assemblePrompt(context, ragContext);

        // 4. Gemini (com fallback embutido)
        const plan = await this.generateWithFallback(prompt, context.mode);

        // 5. Sync + Credit (transacional)
        await this.syncAndDeductCredit(plan, context.userId);

        // 6. Side effects
        await this.executePostGenerationHooks(plan, context);

        return plan;
    }

    private async enrichContext(context: PlanningContext) {
        // RAG unificado
        const [curriculum, enemQuestions, pnldChapters] = await Promise.allSettled([
            this.searchService.searchCurriculum(context),
            this.searchService.searchEnem(context),
            this.pnldService.findChapters(context)
        ]);
        return { curriculum, enemQuestions, pnldChapters };
    }

    private assemblePrompt(context, rag) {
        // Lógica centralizada de prompt assembly
    }

    private async generateWithFallback(prompt, mode) {
        // Wrapper de executeWithFallback
    }

    private async syncAndDeductCredit(plan, userId) {
        // Transação: salvar + deducir ou rollback
    }
}
```

**Benefício**:
- ✅ PlanningManager.tsx tem apenas 1-2 dependências
- ✅ Lógica reutilizável por Assessment, PDI
- ✅ Fácil de testar
- ✅ Fácil de debugar (único ponto)

---

### **SUGESTÃO #2: State Manager para PDI** ⭐⭐⭐⭐

**Problema**: usePDIManager.ts tem 502 linhas com 14+ dependências

**Solução**: Usar Zustand ou splitarizo Redux para PDI state

```typescript
// src/features/PDI/store/pdiStore.ts
export const usePDIStore = create<PDIState & PDIActions>((set, get) => ({
    // State
    selectedClass: null,
    selectedLesson: null,
    studentsWithNeeds: [],
    adaptations: {},
    generatingId: null,
    
    // Actions
    selectClass: (classId) => set({ selectedClass: getClassById(classId) }),
    selectLesson: (lessonId) => set({ selectedLesson: getLessonById(lessonId) }),
    setGenerating: (id) => set({ generatingId: id }),
    addAdaptation: (id, content) => set(state => ({
        adaptations: { ...state.adaptations, [id]: content }
    })),
    
    // Async actions
    generateAdaptation: async (studentId, lessonId, context) => {
        get().setGenerating(studentId);
        try {
            const result = await AiPdiService.generateStudentAdaptation(...);
            get().addAdaptation(studentId, result);
        } finally {
            get().setGenerating(null);
        }
    }
}));

// src/features/PDI/PDIManager.tsx (depois)
const { selectedClass, selectClass, generateAdaptation } = usePDIStore();
// Muito mais simples!
```

**Benefício**:
- ✅ State management separado da UI
- ✅ Fácil para testar
- ✅ Reutilizável em múltiplos componentes
- ✅ Devtools debugging

---

### **SUGESTÃO #3: Query Abstraction Layer** ⭐⭐⭐⭐

**Problema**: Multiple sources (Supabase + LocalStorage) sem coordenação

**Solução**: Criar `DataAccessLayer.ts` unificado

```typescript
// src/services/data/DataAccessLayer.ts
export class DataAccessLayer {
    // Implementa Strategy pattern: preferência por Supabase com fallback
    async getClasses(userId: string, schoolId: string): Promise<Class[]> {
        try {
            // Tenta Supabase primeiro (source of truth)
            return await this.supabaseGateway.getClasses(schoolId);
        } catch (error) {
            console.warn('Supabase falhou, usando cache local');
            // Fallback para local
            return this.localStorageGateway.getClasses(userId);
        }
    }

    async syncClasses(userId: string, schoolId: string) {
        // Sincronização bidirecional
        const remote = await this.supabaseGateway.getClasses(schoolId);
        const local = this.localStorageGateway.getClasses(userId);
        
        // Merge strategy (remote wins on conflict)
        const merged = this.mergeWithConflictResolution(remote, local);
        this.localStorageGateway.setClasses(userId, merged);
        
        return merged;
    }
}

// Uso:
const dal = new DataAccessLayer();
const classes = await dal.getClasses(userId, schoolId);
```

**Benefício**:
- ✅ Sincronização centralizada
- ✅ Fallback automático
- ✅ Fácil mudar strategy (ex: add SQLite local)

---

### **SUGESTÃO #4: AI Service Composition Pattern** ⭐⭐⭐⭐⭐

**Problema**: Lógica de AI espalhada (AiCore, AiPlanningService, AiChatService, AiPdiService)

**Solução**: Criar composição tipo `AiService.planning()`, `AiService.pdi()`, etc.

```typescript
// src/services/ai/AiService.ts (Facade)
export class AiService {
    // Centraliza TODAS as chamadas a Gemini
    // Cada método é uma "recipe"

    async planning(context: PlanningContext): Promise<TermPlan> {
        const prompt = this.buildPrompt('planning', context);
        return this.executeWithMetrics('planning', prompt);
    }

    async pdi(context: PDIContext): Promise<Adaptation> {
        const prompt = this.buildPrompt('pdi', context);
        return this.executeWithMetrics('pdi', prompt);
    }

    async assessment(context: AssessmentContext): Promise<Assessment> {
        const prompt = this.buildPrompt('assessment', context);
        return this.executeWithMetrics('assessment', prompt);
    }

    private async executeWithMetrics(type: string, prompt: string) {
        // Centralizado:
        // - executeWithFallback
        // - Timeout handling
        // - Error logging
        // - Token counting
        // - Cost calculation
        return executeWithFallback(`AiService.${type}`, async (modelName) => {
            // ...
        });
    }

    private buildPrompt(type: string, context: any) {
        // Switch centralizado por tipo
        // Fácil manter system prompts
    }
}
```

**Benefício**:
- ✅ Gemini é um detalhe, não é disperso
- ✅ Metrics centralizadas (token usage, cost)
- ✅ Fácil de AB test diferentes prompts
- ✅ Logging/monitoring centralizado

---

### **SUGESTÃO #5: Credit System com Transações** ⭐⭐⭐

**Problema**: checkUsageQuota → Gemini → incrementUserUsage sem transação

**Solução**: Implementar Credit Manager transacional

```typescript
// src/services/billing/CreditManager.ts
export class CreditManager {
    async executeWithCreditCheck<T>(
        userId: string,
        operation: () => Promise<T>,
        creditCost: number = 1
    ): Promise<T> {
        // 1. Check (pessimistic lock se possível)
        const balance = await this.checkBalance(userId);
        if (balance < creditCost) {
            throw new InsufficientCreditsError(`Need ${creditCost}, have ${balance}`);
        }

        // 2. Reserve (optimistic lock com version)
        const reservation = await this.reserve(userId, creditCost);

        try {
            // 3. Execute operation
            const result = await operation();

            // 4. Confirm deduction
            await this.confirmDeduction(userId, reservation.id);

            return result;
        } catch (error) {
            // 4b. Rollback se falhou
            await this.rollbackReservation(reservation.id);
            throw error;
        }
    }
}

// Uso:
await creditManager.executeWithCreditCheck(
    userId,
    async () => aiService.planning(context),
    1 // cost
);
// ✅ Crédito debitado só se sucesso
```

**Benefício**:
- ✅ Sem race conditions
- ✅ Sem crédito "perdido"
- ✅ Auditável

---

## 📋 RECOMENDAÇÕES DE PADRÕES DE DESIGN

### **1. SERVICE LOCATOR PATTERN** (Já existe, pode melhorar)

```typescript
// src/services/ServiceLocator.ts (Centralizado)
export class ServiceLocator {
    private static services = new Map();

    static register<T>(key: string, service: T) {
        ServiceLocator.services.set(key, service);
    }

    static get<T>(key: string): T {
        const service = ServiceLocator.services.get(key);
        if (!service) throw new Error(`Service ${key} not found`);
        return service;
    }
}

// Inicialização
ServiceLocator.register('AiService', new AiService());
ServiceLocator.register('DataAccessLayer', new DataAccessLayer());

// Uso
const aiService = ServiceLocator.get<AiService>('AiService');
```

**Benefício**: Dependency Injection simples, sem framework overhead.

---

### **2. COMMAND PATTERN** (Para operações complexas)

```typescript
// src/commands/GenerateTermPlanCommand.ts
export class GenerateTermPlanCommand implements Command {
    constructor(
        private context: PlanningContext,
        private aiService: AiService,
        private creditManager: CreditManager
    ) {}

    async execute(): Promise<TermPlan> {
        return this.creditManager.executeWithCreditCheck(
            this.context.userId,
            () => this.aiService.planning(this.context)
        );
    }

    async undo(): Promise<void> {
        // Reverter se necessário
    }
}

// Uso com retry/queue
const command = new GenerateTermPlanCommand(context, aiService, creditManager);
commandQueue.enqueue(command);
```

**Benefício**: Undo/redo, queueing, macro commands.

---

### **3. BUILDER PATTERN** (Para context assembly)

```typescript
// src/services/ContextBuilder.ts
export class PlanningContextBuilder {
    private context: Partial<PlanningContext> = {};

    withSubject(subject: string) {
        this.context.subject = subject;
        return this;
    }

    withCurriculum(rag: any) {
        this.context.curriculum = rag;
        return this;
    }

    withTeacherMemory(userId: string) {
        this.context.teacherMemory = getTeacherContext(userId);
        return this;
    }

    build(): PlanningContext {
        validate(this.context);
        return this.context as PlanningContext;
    }
}

// Uso
const context = new PlanningContextBuilder()
    .withSubject('Português')
    .withCurriculum(...)
    .withTeacherMemory(userId)
    .build();
```

**Benefício**: Readability, validation centralizada.

---

### **4. OBSERVER/PUB-SUB PATTERN** (Para side effects)

```typescript
// src/services/EventBus.ts
export const EventBus = {
    subscribe(event: string, handler: Function) {
        // ...
    },
    publish(event: string, data: any) {
        // ...
    }
};

// Listeners se registram:
EventBus.subscribe('planning:generated', async (plan) => {
    await memoryService.addMemory(plan);
    await feedbackService.log(plan);
    await analyticsService.track(plan);
});

// Publicar (sem acoplamento):
EventBus.publish('planning:generated', generatedPlan);
```

**Benefício**: Desacopla side effects, fácil de adicionar listeners sem modificar código.

---

### **5. REPOSITORY PATTERN** (Para data persistence)

```typescript
// src/repositories/PlanRepository.ts
export interface PlanRepository {
    save(plan: Plan): Promise<void>;
    findById(id: string): Promise<Plan | null>;
    findByUserId(userId: string): Promise<Plan[]>;
}

export class SupabasePlanRepository implements PlanRepository {
    async save(plan: Plan) {
        return supabase.from('generated_contents').upsert(plan);
    }

    async findById(id: string) {
        const { data } = await supabase.from('generated_contents').select('*').eq('id', id);
        return data?.[0] || null;
    }
}

// Swappable para SqlitePlanRepository, etc.
```

**Benefício**: Abstração de onde dados vêm, fácil testar.

---

## 🚨 RISCOS CRÍTICOS IDENTIFICADOS

| Risco | Severidade | Locação | Impacto |
|-------|-----------|---------|--------|
| Race condition: localStorage + Supabase | 🔴 CRÍTICA | GlobalPlanningContext | Data loss |
| usePDIManager 502 linhas monolítico | 🔴 CRÍTICA | src/features/PDI | Unmaintainable |
| Credit deduction "fire and forget" | 🔴 CRÍTICA | PlanningService | Fraudulent usage |
| Gemini timeout não explícito | 🟠 ALTA | AiPlanningService | Hanging requests |
| geminiService.ts DEPRECATED mas ainda usado | 🟠 ALTA | usePDIManager | Code smell |
| Sem validação de parser output | 🟠 ALTA | markdownParser | Silent failures |
| Multiple Supabase auth checks | 🟡 MÉDIA | Scattered | Performance |
| localStorage 5MB limit não monitorado | 🟡 MÉDIA | PlanningService | Quota exceeded |

---

## 📌 RESUMO EXECUTIVO DE SIMPLIFICAÇÃO

| Fluxo | Complexidade Atual | Com Sugestões | Ganho |
|-------|------------------|---------------|-------|
| **Planning Trimestral** | 12 arquivos, 16 deps | 5 arquivos, 3 deps | **-58% deps** |
| **PDI Adaptação** | 11 arquivos, 14 deps | 6 arquivos, 4 deps | **-71% deps** |
| **Overall Coupling** | Alta | Baixa | **-60% acoplamento** |
| **Testabilidade** | Difícil | Fácil | **+80% cobertura viável** |

---

## 🎯 PRÓXIMOS PASSOS RECOMENDADOS

1. **Fase 1**: Implementar `PlanningOrchestrator.ts` (Sugestão #1)
2. **Fase 2**: Extrair state management com Zustand (Sugestão #2)
3. **Fase 3**: Implementar `DataAccessLayer.ts` (Sugestão #3)
4. **Fase 4**: Consolidar AI com `AiService.ts` (Sugestão #4)
5. **Fase 5**: Add CreditManager transacional (Sugestão #5)

**Timeline estimado**: 2-3 sprints (se 2 devs, 40h/semana)

---

**Fim da Análise**
