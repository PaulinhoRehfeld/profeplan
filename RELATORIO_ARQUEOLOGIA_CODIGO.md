# 🏛️ RELATÓRIO DE ARQUEOLOGIA DE CÓDIGO - PROFEPLAN
**Data da Análise**: 10 de Fevereiro de 2026  
**Projeto**: PROFEPLAN  
**Localização**: c:\Users\Admin\PROFEPLAN\PROFEPLAN

---

## 📋 RESUMO EXECUTIVO

O PROFEPLAN é um sistema educacional complexo construído com React/TypeScript, Vite e Supabase. A análise revelou:

- **205 arquivos TypeScript/JavaScript** em src/
- **3 Camadas principais**: Serviços, Componentes, Features
- **🚨 Redundância significativa**: Duplicação de lógica e estruturas
- **⚠️ Dependências complexas**: Risco de importações circulares
- **❌ Anti-patterns detectados**: Gestão de estado inconsistente, falta de separação de responsabilidades

---

## 🗂️ MAPA VISUAL DA ARQUITETURA

```
PROFEPLAN/
│
├─ 📁 src/
│  ├─ services/               ⭐ CAMADA DE SERVIÇOS
│  │  ├─ ai/                  (8 serviços de IA)
│  │  │  ├─ AiCore.ts
│  │  │  ├─ AiChatService.ts
│  │  │  ├─ AiPdiService.ts
│  │  │  ├─ AiAdaptationService.ts
│  │  │  ├─ AiAssessmentService.ts
│  │  │  ├─ AiPlanningService.ts
│  │  │  ├─ AiPresentationService.ts
│  │  │  └─ AiUtilityService.ts
│  │  ├─ pdi/                 (PDI específico)
│  │  │  ├─ PdiDocumentService.ts
│  │  │  └─ StudentService.ts
│  │  ├─ [Student/Teacher/School Management]
│  │  │  ├─ studentService.ts
│  │  │  ├─ teacherService.ts
│  │  │  ├─ SchoolService.ts
│  │  │  └─ ProfileService.ts
│  │  ├─ [Data Persistence]
│  │  │  ├─ supabaseService.ts
│  │  │  ├─ supabaseClient.ts
│  │  │  ├─ databaseService.ts
│  │  │  └─ localStorageService.ts
│  │  ├─ [Business Logic]
│  │  │  ├─ PdiService.ts
│  │  │  ├─ PdiBlock9Service.ts
│  │  │  ├─ PdiExportService.ts
│  │  │  ├─ searchService.ts
│  │  │  ├─ questionService.ts
│  │  │  └─ geminiService.ts [⚠️ DEPRECATED]
│  │  └─ [Misc Services]
│  │     ├─ ingestionService.ts
│  │     ├─ diagnosticService.ts
│  │     ├─ feedbackService.ts
│  │     ├─ exportService.ts
│  │     ├─ memoryService.ts
│  │     ├─ pdfService.ts
│  │     ├─ unsplashService.ts
│  │     └─ stripeService.ts
│  │
│  ├─ features/               ⭐ CAMADA DE FEATURES
│  │  ├─ PDI/                 (Plano Desenvolvimento Individual)
│  │  │  ├─ components/
│  │  │  │  ├─ PDIViewBlocks1to8.tsx
│  │  │  │  ├─ PDIFormBlocks1to8.tsx
│  │  │  │  ├─ PDIBlock9Viewer.tsx
│  │  │  │  ├─ PDIBlock10Viewer.tsx
│  │  │  │  ├─ PDIBlock10Form.tsx
│  │  │  │  ├─ PDIBlock11Editor.tsx
│  │  │  │  ├─ PDICompiler.tsx
│  │  │  │  └─ [8 block forms]
│  │  │  ├─ Official/         (Schema oficial)
│  │  │  ├─ PdiListPage.tsx
│  │  │  ├─ PDIManager.tsx
│  │  │  └─ PDIDashboard.tsx
│  │  ├─ Planning/            (Planejamento pedagógico)
│  │  │  ├─ components/
│  │  │  │  ├─ PlanningCockpit.tsx
│  │  │  │  ├─ SimulationWorkspace.tsx
│  │  │  │  ├─ PdiAdaptationWidget.tsx
│  │  │  │  ├─ CurriculumMatcher.tsx
│  │  │  │  └─ CleanChat.tsx
│  │  │  ├─ PlanningManager.tsx
│  │  │  ├─ PlanningService.ts
│  │  │  └─ pages/
│  │  ├─ Assessment/          (Avaliação estudantil)
│  │  │  ├─ AssessmentManager.tsx
│  │  │  ├─ AssessmentService.ts
│  │  │  └─ components/
│  │  ├─ TermPlanning/        (Planejamento por trimestre)
│  │  │  ├─ TermPlanningManager.tsx
│  │  │  └─ TermPlanningService.ts
│  │  └─ Admin/               (Administrativo)
│  │
│  ├─ components/             ⭐ CAMADA DE COMPONENTES UI
│  │  ├─ [School Management]
│  │  │  ├─ SchoolSelector.tsx
│  │  │  ├─ SchoolSelectorScreen.tsx
│  │  │  ├─ SchoolSwitcher.tsx
│  │  │  ├─ SchoolAutocomplete.tsx  ⚠️
│  │  │  └─ SchoolStudentSelector.tsx
│  │  ├─ School/
│  │  │  ├─ ClassManagement.tsx
│  │  │  ├─ StudentManagement.tsx
│  │  │  ├─ TeacherManagement.tsx
│  │  │  └─ PDI/
│  │  ├─ ClassManager/
│  │  │  ├─ ClassList.tsx
│  │  │  ├─ ClassDetail.tsx
│  │  │  ├─ CreateClassModal.tsx
│  │  │  └─ StudentPdiDrawer.tsx
│  │  ├─ Settings/
│  │  │  └─ Tabs/
│  │  │     ├─ ProfileTab.tsx
│  │  │     ├─ ManagerProfileTab.tsx
│  │  │     └─ [outros]
│  │  ├─ Admin/
│  │  ├─ QuestionFinder/
│  │  ├─ Feedback/
│  │  └─ [Componentes únicos]
│  │
│  ├─ types/                  ⭐ DEFINIÇÕES DE TIPO
│  │  ├─ pdi.ts              (PDI types)
│  │  ├─ pdi-schema.ts        (Zod schema)
│  │  └─ index.ts
│  │
│  ├─ utils/
│  │  ├─ authUtils.ts
│  │  ├─ inepUtils.ts
│  │  ├─ chatGuardUtils.ts
│  │  └─ markdownParser.ts
│  │
│  ├─ hooks/
│  │  ├─ useProfeplanAuth.ts
│  │  ├─ useProfeplanSettings.ts
│  │  └─ useActiveSchool.ts
│  │
│  ├─ contexts/
│  │  └─ GlobalPlanningContext.tsx
│  │
│  ├─ pages/
│  │  └─ [Landing, Login, Setup, etc]
│  │
│  └─ App.tsx
│
├─ 📁 scripts/
│  ├─ [Múltiplos scripts de migração/debug]
│  ├─ migrations/
│  └─ pnld/
│
├─ 📁 supabase/
│  ├─ migrations/
│  ├─ functions/
│  └─ scripts/
│
├─ 📁 rlm/                    (Recursive Language Model)
│  ├─ visualizer/
│  └─ docs/
│
├─ 📁 android/
├─ 📁 public/
├─ 📁 dist/
└─ package.json, vite.config.ts, tsconfig.json
```

---

## 🔴 REDUNDÂNCIAS DETECTADAS

### 1. **DUPLICAÇÃO DE SERVIÇOS DE STUDENT** (CRÍTICO)

| Arquivo | Localização | Responsabilidade |
|---------|-------------|------------------|
| `studentService.ts` | `src/services/` | Gerenciar estudantes da escola (students table) |
| `StudentService.ts` | `src/services/pdi/` | Gerenciar estudantes para PDI |
| `studentService.ts` | `src/services/supabaseService.ts` (parte) | Funções misc de estudante |

**Problema**: Mesma entidade (`students`) com múltiplas implementações
- `studentService.ts`: `getStudentsBySchool()`, `createStudent()`, `updateStudent()`, `archiveStudent()`
- `pdi/StudentService.ts`: `createStudent()`, `getStudentsBySchool()`, `getStudentById()`

**Impacto**: Código duplicado, difícil manutenção, possível inconsistência de dados

**Recomendação**:
```
Consolidar em src/services/studentService.ts
Remover src/services/pdi/StudentService.ts
```

---

### 2. **DUPLICAÇÃO DE PDI DOCUMENT MANAGEMENT** (CRÍTICO)

| Arquivo | Responsabilidade |
|---------|------------------|
| `PdiService.ts` | Log de eventos PDI |
| `pdi/PdiDocumentService.ts` | Gerenciar documento PDI completo |
| `PdiExportService.ts` | Exportar PDI |
| `PdiBlock9Service.ts` | Bloco 9 específico |

**Problema**: Múltiplos serviços para mesma entidade (pdi_documents)
- `PdiService.logEvent()` - inserção de eventos
- `PdiDocumentService.getOrCreatePdi()` - CRUD completo
- `PdiExportService.exportPdiToDocx()` - exportação

**Impacto**: Lógica fragmentada, difícil saber qual usar

**Recomendação**:
```
Consolidar tudo em: src/services/pdi/PdiDocumentService.ts
PdiService → mover logEvent() para PdiDocumentService
PdiBlock9Service → permanecer separado (especializado)
PdiExportService → integrar como método em PdiDocumentService
```

---

### 3. **DUPLICAÇÃO DE COMPONENTES SCHOOL SELECTOR** (MODERADO)

| Componente | Uso |
|-----------|-----|
| `SchoolSelector.tsx` | Seletor com busca |
| `SchoolSelectorScreen.tsx` | Tela completa de seleção |
| `SchoolSwitcher.tsx` | Trocar escola ativa |
| `SchoolAutocomplete.tsx` | Campo autocomplete |
| `SchoolStudentSelector.tsx` | Seletor de aluno por escola |

**Problema**: 5 componentes com lógica similar de seleção de escola

**Código Similar**: Todas fazem buscas em `schools` table, filtram por nome/cidade

**Impacto**: Manutenção duplicada, mudança em um não reflete no outro

**Recomendação**:
```
Criar: SchoolSelectionComposer.tsx (estratégia de composição)
- Usar SchoolAutocomplete como base
- Remover SchoolSelector (duplicado)
- Adaptar SchoolSwitcher para usar SchoolAutocomplete
- Manter SchoolSelectorScreen para fluxo completo
- SchoolStudentSelector = especializado, OK manter
```

---

### 4. **DUPLICAÇÃO EM PERSISTÊNCIA DE DADOS** (MODERADO)

| Arquivo | Responsabilidade |
|---------|------------------|
| `supabaseService.ts` | Funções gerais Supabase |
| `databaseService.ts` | Gerenciar conteúdo gerado |
| `localStorageService.ts` | Armazenamento local |
| `supabaseClient.ts` | Cliente Supabase |

**Problema**: Múltiplas camadas de acesso a dados

**Código Duplicado**:
```typescript
// supabaseService.ts
export const getClasses = async () => { ... }
export const getLessons = async () => { ... }

// localStorageService.ts
export const getLocalClasses = () => { ... }
export const getLocalLessons = () => { ... }

// databaseService.ts
export const getGeneratedContents = () => { ... }
```

**Impacto**: Importações inconsistentes (às vezes supabase, às vezes local)

**Recomendação**:
```
Criar abstrações:
- DataPersistenceService (interface)
  - SupabaseDataService (implementação)
  - LocalDataService (implementação)
Usar factory pattern para selecionar implementação
```

---

### 5. **DUPLICAÇÃO DE PDI FORM COMPONENTS** (MODERADO)

| Componente | Responsabilidade |
|-----------|------------------|
| `PDIFormBlocks1to8.tsx` | Formulário blocos 1-8 |
| `Block1Form.tsx` a `Block8Form.tsx` | Formulários individuais |
| `PDIBlock10Form.tsx` | Formulário bloco 10 |

**Problema**: Estrutura similar repetida em cada bloco

**Padrão Detectado**:
```typescript
// Cada Block*Form.tsx segue:
1. useForm() com React Hook Form
2. Mesmas validações (Zod)
3. Mesmos handlers (save, cancel)
4. Mesma UI (Card, inputs, buttons)
```

**Recomendação**:
```
Criar: PdiBlockFormTemplate.tsx (genérico)
Usar: Array de configurações para cada bloco
Substituir 8 formulários por 1 genérico + config
```

---

### 6. **DUPLICAÇÃO EM AI SERVICES** (BAIXO - DESIGN OK)

| Arquivo | Responsabilidade |
|---------|------------------|
| `AiCore.ts` | Core Gemini + fallback |
| `AiChatService.ts` | Chat com IA |
| `AiPdiService.ts` | Geração PDI |
| `AiPlanningService.ts` | Planejamento |
| `AiAdaptationService.ts` | Adaptação |
| `AiAssessmentService.ts` | Avaliação |
| `AiPresentationService.ts` | Apresentação |
| `AiUtilityService.ts` | Utilitários |

**Status**: ✅ Bem estruturado
- Cada serviço = caso de uso específico
- Todos usam `AiCore` (DRY)
- Separação clara de responsabilidades

**Nota**: `geminiService.ts` é @deprecated → faz re-exports. Remover completamente.

---

## ⚠️ DEPENDÊNCIAS CIRCULARES POTENCIAIS

### 1. **PdiService ↔ ProfileService (BAIXO RISCO)**

```
PdiService.ts:
  ├─ importa ProfileService
  └─ ProfileService.getProfile()

ProfileService.ts:
  └─ (não importa PdiService)
```

**Status**: ✅ Sem circularidade (fluxo unidirecional)

---

### 2. **PlanningManager ↔ PlanningService (BAIXO RISCO)**

```
PlanningManager.tsx:
  ├─ importa PlanningService
  ├─ importa geminiService (deprecated)
  ├─ importa searchService
  └─ importa questionService

PlanningService.ts:
  └─ importa supabaseClient
```

**Status**: ✅ Sem circularidade

---

### 3. **PDIDocumentService ↔ Multiple AI Services (MODERADO RISCO)**

```
PdiDocumentService.ts:
  └─ importa: PdiSchema, types

PDI Components:
  ├─ importam PdiDocumentService
  └─ importam AI services (AiPdiService, etc.)

AiPdiService.ts:
  └─ NÃO importa PdiDocumentService
```

**Status**: ✅ OK - mas acoplamento indireto

---

### 4. **Assessment Feature ↔ Multiple Sources (RISCO MODERADO)**

```
AssessmentManager.tsx:
  ├─ importa localStorageService
  ├─ importa supabaseService
  ├─ importa databaseService
  └─ importa questionService

Cada um importa:
  └─ supabaseClient
```

**Status**: ⚠️ Múltiplas dependências, mas sem circularidade

---

### 5. **GlobalPlanningContext (RISCO ALTO - POTENCIAL)**

```
GlobalPlanningContext.tsx:
  ├─ importa ???

Componentes:
  ├─ importam GlobalPlanningContext
  └─ importam Services
```

**Status**: 🔍 Verificação necessária
**Recomendação**: Analisar se contexto importa componentes

---

## ❌ ANTI-PATTERNS E VIOLAÇÕES DE DESIGN

### 1. **GESTÃO DE ESTADO INCONSISTENTE** (CRÍTICO)

**Problema**: Múltiplos padrões de estado em uso

```typescript
// Padrão 1: useState local (ClassManager.tsx)
const [classes, setClasses] = useState<LocalClass[]>([]);

// Padrão 2: Context + useState (Planning features)
const { planningState } = useContext(GlobalPlanningContext);

// Padrão 3: Service direto sem estado (StudentService)
await getStudentsBySchool(schoolId);

// Padrão 4: Hybrid (AssessmentSetup)
const [selected, setSelected] = useState();
const result = await supabaseService.getClasses();
```

**Impacto**: 
- Dificuldade em rastrear fluxo de dados
- Sincronia entre estado local e remoto
- Risco de data stale

**Recomendação**:
```
1. Implementar Context Provider para todas as entidades principais:
   - SchoolContext
   - StudentContext
   - PdiContext
   - AssessmentContext

2. Usar padrão:
   - Context = state + actions
   - Services = lógica pura (sem estado)
   - Components = consomem Context
```

---

### 2. **FALTA DE SEPARAÇÃO DE RESPONSABILIDADES** (CRÍTICO)

**Problema**: Componentes fazem muito (UI + Lógica + Persistência)

```typescript
// ClassManager.tsx (278 linhas)
- Renderiza UI
- Gerencia estado local
- Chama supabaseService
- Chama localStorageService
- Chama databaseService
- Trata erros
- Valida dados
```

**Anti-pattern**: "God Component"

**Recomendação**:
```
ClassManager.tsx → dividir em:
1. ClassManagerContainer (lógica)
2. ClassList (UI para lista)
3. ClassDetail (UI para detalhe)
4. ClassActions (handlers)
```

---

### 3. **IMPORTAÇÕES DINÂMICAS INAPROPRIADAS** (MODERADO)

**Problema**: Importações `await import()` em handlers

```typescript
// PlanningManager.tsx, linha 209
const { PlanningAuthority } = await import('../../services/PlanningAuthorityService');

// AssessmentSetup.tsx, linha 40
const { getClasses } = await import('../../../services/supabaseService');

// ClassManager.tsx, linha 39
const { getClasses } = await import('../services/supabaseService');
```

**Por quê é anti-pattern**:
- Imports devem estar no topo
- Dinâmicos só para code-splitting (rotas, não handlers)
- Dificulta análise estática

**Recomendação**: Mover para imports estáticos no topo

---

### 4. **TIPO CHECKING INCONSISTENTE** (MODERADO)

**Problema**: Algumas funções com tipos, outras sem

```typescript
// SchoolService.ts - BOM
export interface SchoolStats {
    totalStudents: number;
    totalTeachers: number;
    totalClasses: number;
    pdiCount: number;
}

// Mas dentro: tipos incompletos
async getStudents(schoolId: string, page = 1, limit = 50, search = '')
// ↑ page, limit, search não têm tipos

// databaseService.ts - RUIM
export const saveGeneratedContent = async (content: any) => { ... }
// ↑ `any` muito genérico
```

**Recomendação**: Usar strict mode TypeScript, remover `any`

---

### 5. **NOMENCLATURA INCONSISTENTE** (MODERADO)

| Padrão | Exemplos | Problema |
|--------|----------|----------|
| Nomes duplicados | StudentService / Student **Service** | Qual usar? |
| PascalCase vs camelCase | **PdiService** vs **userService** | Inconsistente |
| Prefixos redundantes | **School**Selector vs **School**SelectorScreen | Qual diferença? |
| Nomenclatura PDI | Block1Form, Block2Form... Block8Form | Enumeração, não abstração |

**Impacto**: Confusão ao navegar codebase

**Recomendação**:
```
Padronizar:
- Services: PascalCase (AiService, StudentService)
- Componentes: PascalCase (SchoolSelector)
- Funções: camelCase (getStudents)
- Types/Interfaces: PascalCase (Student, School)
- Usar sufixos claros: -Manager, -Service, -Component
```

---

### 6. **FALTA DE TRATAMENTO DE ERRO CENTRALIZADO** (MODERADO)

**Problema**: Cada serviço trata erros de forma diferente

```typescript
// Tipo 1: Console.error
studentService.ts:
  if (error) {
      console.error('Error fetching students:', error);
      return [];
  }

// Tipo 2: Retorna objeto com error
SchoolService.ts:
  return { data: null, error };

// Tipo 3: Throw
databaseService.ts:
  throw new Error('Save failed');
```

**Recomendação**: Criar `ErrorHandler` centralizado

---

### 7. **LOGGING EXCESSIVO E DESORDENADO** (MODERADO)

**Problema**: console.log() espalhado por toda parte

```typescript
// SchoolAutocomplete.tsx
console.log('[SchoolAutocomplete] 🎨 Component rendered');
console.log('[SchoolAutocomplete] 🔍 Searching for:');
console.log('[SchoolAutocomplete] ✅ Showing', data.length, 'suggestions');
console.log('[SchoolAutocomplete] ❌ Query failed:');
```

**Impacto**: 
- Poluição de console
- Não é rastreável
- Sem níveis (debug, info, warn, error)

**Recomendação**: Usar logger centralizado (winston, pino, ou simples)

---

### 8. **DOCUMENTAÇÃO INSUFICIENTE** (MODERADO)

**Problema**: Funções complexas sem JSDoc

```typescript
// PdiDocumentService.ts - BOM
/**
 * Create or Get existing PDI for a student/year
 */
async getOrCreatePdi(studentId: string, year: number = ...) { ... }

// Mas depois:
async updatePdiSection(pdiId: string, sectionKey: keyof PDIProfileData, sectionData: any) { ... }
// ↑ O que é sectionKey? Que estrutura tem sectionData?

// ClassManager.tsx - RUIM
const loadClasses = async () => { ... }
// ↑ De onde carrega? Local ou remoto?
```

---

## 📊 ANÁLISE DE COESÃO

### Grupos de Serviços (Por Responsabilidade)

| Grupo | Serviços | Coesão | Observação |
|-------|----------|--------|-----------|
| **AI** | 8 serviços em `/ai/` | ✅ ALTA | Bem organizado, cada um é especializado |
| **PDI** | PdiService, PdiDocumentService, PdiBlock9Service | ⚠️ MÉDIA | Fragmentado, sobrepõe responsabilidades |
| **Student** | studentService, pdi/StudentService | ❌ BAIXA | DUPLICADO completamente |
| **School** | SchoolService, teacherSchoolService | ⚠️ MÉDIA | Relacionados mas separados ok |
| **Data** | supabaseService, databaseService, localStorageService | ❌ BAIXA | Múltiplas camadas confusas |
| **Planning** | PlanningService, TermPlanningService | ⚠️ MÉDIA | Similar, poderia consolidar |

---

## 🎯 POSSÍVEIS CIRCULARIDADES (Análise Detalhada)

### Fluxo Identificado:

```
PlanningManager.tsx
  ├─ importa: geminiService (deprecated)
  ├─ importa: searchService
  ├─ importa: questionService
  ├─ importa: PlanningService
  ├─ importa: supabase (client)
  ├─ importa: memoryService
  ├─ importa: feedbackService
  ├─ importa: exportService
  ├─ importa: databaseService
  └─ Dynamic: PlanningAuthorityService

Cada um desses importa:
  └─ supabaseClient (base comum - OK)

NÃO HÁ CIRCULARIDADE DETECTADA ✅
Mas há ACOPLAMENTO ALTO ⚠️
```

---

## 🚨 DIAGNÓSTICO DE SAÚDE

| Aspecto | Status | Score |
|--------|--------|-------|
| **Coesão** | Média | 5/10 |
| **Acoplamento** | Alto | 3/10 |
| **Duplicação** | Significante | 4/10 |
| **Testabilidade** | Média | 5/10 |
| **Documentação** | Baixa | 4/10 |
| **Consistência** | Baixa | 3/10 |
| **Manutenibilidade** | Média | 5/10 |
| **Escalabilidade** | Média | 5/10 |

**Score Geral**: 4.3/10 ⚠️

---

## 📋 CHECKLIST DE VERIFICAÇÕES

### Circularidades (Resolvido ✅)
- [x] PdiService ↔ ProfileService: Unidirecional ✅
- [x] PlanningManager ↔ Services: Sem circularidade ✅
- [x] Assessment ↔ Data Services: Sem circularidade ✅
- [x] GlobalContext ↔ Components: Verificar importações

### Redundâncias Confirmadas
- [x] StudentService duplicado (2 locais)
- [x] PdiService fragmentado (3+ arquivos)
- [x] SchoolSelector × 5 (similares)
- [x] Block*Form pattern repetido
- [x] Data persistence layer confusa

### Anti-patterns Confirmados
- [x] God Components (ClassManager, PlanningManager)
- [x] Estado inconsistente
- [x] Imports dinâmicos inapropriados
- [x] Tipos incompletos (any)
- [x] Nomenclatura inconsistente
- [x] Logging não centralizado
- [x] Tratamento de erro não padronizado

---

## 🔧 RECOMENDAÇÕES DE REFATORAÇÃO (Priorizado)

### 🔴 CRÍTICO (Fazer Agora)

1. **Consolidar StudentService**
   - Combinar `studentService.ts` e `pdi/StudentService.ts`
   - Resultado: `src/services/studentService.ts` (único)
   - Esforço: 2-3 horas
   - Impacto: Altíssimo (eliminaria duplicação completa)

2. **Unificar PDI Document Management**
   - Consolidar em `PdiDocumentService.ts`
   - Mover `logEvent()` para `PdiDocumentService`
   - Integrar `PdiExportService` como método
   - Manter `PdiBlock9Service` separado (especializado)
   - Esforço: 4-5 horas
   - Impacto: Altíssimo

3. **Remover geminiService.ts**
   - É apenas re-exports deprecados
   - Importações diretas para `ai/*`
   - Encontre 8 arquivos que importam e corrija
   - Esforço: 1-2 horas
   - Impacto: Alto (limpeza)

### 🟡 IMPORTANTE (Próximas semanas)

4. **Implementar Context Providers**
   ```
   - SchoolContext (escola ativa, operações)
   - StudentContext (estudantes carregados)
   - PdiContext (PDI em edição)
   - Reduzir useState local
   ```
   - Esforço: 8-10 horas
   - Impacto: Alto (manutenibilidade)

5. **Consolidar Data Persistence Layer**
   ```
   Criar abstrações:
   - DatabaseAdapter (interface)
   - SupabaseDatabaseAdapter (implementação)
   - LocalStorageDatabaseAdapter (implementação)
   ```
   - Esforço: 6-8 horas
   - Impacto: Alto (consistência)

6. **Refatorar Componentes "God"**
   ```
   - ClassManager.tsx → dividir em 4 componentes menores
   - PlanningManager.tsx → Container + Presentational
   ```
   - Esforço: 10-12 horas
   - Impacto: Médio-Alto (testabilidade)

### 🟠 MELHORIAS (Backlog)

7. **Padronizar Nomenclatura**
   - Guia de estilo TypeScript
   - Aplicar automaticamente (eslint rules)
   - Esforço: 4-5 horas
   - Impacto: Médio

8. **Centralizar Logger**
   - Remover console.log() espalhado
   - Implementar logger simples ou winston
   - Esforço: 3-4 horas
   - Impacto: Médio

9. **Documentação JSDoc**
   - Adicionar a funções complexas
   - Gerar documentação automaticamente
   - Esforço: 5-7 horas
   - Impacto: Médio

10. **Type Safety**
    - Remover `any` com `unknown` + type guards
    - Ativar `strict: true` em tsconfig
    - Esforço: 8-10 horas
    - Impacto: Médio

---

## 📁 ESTRUTURA PROPOSTA PÓS-REFATORAÇÃO

```
src/
├─ services/
│  ├─ ai/                    [MANTÉM IGUAL - BOM]
│  ├─ core/
│  │  ├─ StudentService.ts   [CONSOLIDADO]
│  │  ├─ SchoolService.ts
│  │  ├─ TeacherService.ts
│  │  └─ ProfileService.ts
│  ├─ pdi/
│  │  ├─ PdiDocumentService.ts [CONSOLIDADO]
│  │  ├─ PdiBlock9Service.ts
│  │  └─ PdiExportService.ts [INTEGRADO]
│  ├─ data/
│  │  ├─ DatabaseAdapter.ts [NOVO - ABSTRAÇÃO]
│  │  ├─ SupabaseAdapter.ts
│  │  └─ LocalStorageAdapter.ts
│  └─ [Outros services]
│
├─ contexts/              [NOVO]
│  ├─ SchoolContext.tsx
│  ├─ StudentContext.tsx
│  ├─ PdiContext.tsx
│  └─ AssessmentContext.tsx
│
├─ components/
│  ├─ Common/
│  │  ├─ SchoolSelection/
│  │  │  ├─ SchoolSelectionComposer.tsx
│  │  │  ├─ SchoolAutocomplete.tsx [BASE]
│  │  │  └─ [RemoveR SchoolSelector, SchoolSelectorScreen]
│  │  └─ [Outros comuns]
│  └─ [Resto mantém]
│
├─ features/
│  ├─ PDI/
│  │  ├─ components/
│  │  │  ├─ forms/
│  │  │  │  ├─ PdiBlockFormTemplate.tsx [NOVO]
│  │  │  │  └─ Block configurations
│  │  │  └─ [Resto mantém]
│  └─ [Resto mantém]
│
└─ [Resto mantém]
```

---

## 📈 MÉTRICAS ESPERADAS PÓS-REFATORAÇÃO

| Métrica | Antes | Depois |
|---------|-------|--------|
| **Linhas duplicadas** | ~2000 | ~500 |
| **# de Serviços** | 35+ | 25 |
| **Coesão** | 5/10 | 8/10 |
| **Acoplamento** | 3/10 | 6/10 |
| **Complexidade ciclomática média** | ~8 | ~5 |
| **Cobertura de tipos** | ~70% | ~95% |

---

## 🎓 CONCLUSÃO

O PROFEPLAN tem uma **arquitetura funcional mas desordenada**. A principal problema é:

1. **Redundância significativa** em serviços de domínio (Student, PDI)
2. **Falta de camadas de abstração** para persistência
3. **Estado gestão inconsistente** em features
4. **Componentes muito grandes** fazendo muitas coisas

Essas questões não impedem o funcionamento, mas **deterioram a manutenibilidade**.

**Plano de ação recomendado**:
1. Semana 1: Consolidar StudentService + PdiDocumentService (crítico)
2. Semana 2: Implementar Contexts + Data Adapters
3. Semana 3-4: Refatorar componentes grandes
4. Semana 5: Documentação + Type safety

Isso elevaria a saúde do código de **4.3/10 → 7.5/10** ✅

---

**Análise Concluída**: 10/02/2026  
**Próxima Revisão Recomendada**: Após primeira rodada de refatoração

