# 🔍 ANÁLISE DETALHADA - REDUNDÂNCIAS E CIRCULARIDADES
**Projeto**: PROFEPLAN  
**Data**: 10/02/2026

---

## 📊 MAPA DE REDUNDÂNCIAS COM LINHAS DE CÓDIGO

### 1. StudentService Duplicação - Resolvido

O `studentService.ts` consolidado agora é a única fonte de verdade para operações relacionadas a estudantes. O antigo `pdi/StudentService.ts` foi removido.

#### Arquivo A: `src/services/studentService.ts`
```typescript
// LINHAS 1-111

export interface Student {
    id: string;
    name: string;
    student_code?: string;
    current_school_id: string;
    class_id?: string;
    serie?: string;
    pdi_needs?: string[];
    observations?: string;
    created_at: string;
}

export const getStudentsBySchool = async (schoolId: string): Promise<Student[]> => {
    const { data, error } = await supabase
        .from('students')
        .select('*')
        .eq('current_school_id', schoolId)
        .order('name');
    // ...
};

export const createStudent = async (studentData: CreateStudentDTO) => {
    const studentCode = studentData.student_code || `STD${Date.now()}`;
    const { data, error } = await supabase
        .from('students')
        .insert([{
            ...studentData,
            student_code: studentCode
        }])
        .select()
        .single();
    // ...
};

export const updateStudent = async (studentId: string, updates: Partial<Student>) => {
    const { error } = await supabase
        .from('students')
        .update(updates)
        .eq('id', studentId);
    // ...
};
```

### 2. PdiDocumentService Fragmentação

#### Três Arquivos Gerenciando PDI:

##### A. `src/services/PdiService.ts` (LINHAS 1-60)
```typescript
export const PdiService = {
    async logEvent(
        studentId: string,
        type: PdiRecordType,
        title: string,
        content: any,
        pdiBlock?: string
    ): Promise<PdiRecord | null> {
        const profile = await ProfileService.getProfile();
        const { data, error } = await supabase
            .from('pdi_records')
            .insert({
                student_id: studentId,
                school_id: profile.school_id,
                teacher_id: profile.id,
                type,
                title,
                content,
                pdi_block: pdiBlock,
                date: new Date().toISOString()
            })
            .select()
            .single();
        // ...
    }
    // Outros métodos omitidos
};
```

##### B. `src/services/pdi/PdiDocumentService.ts` (LINHAS 1-322)
```typescript
export const PdiDocumentService = {
    async getOrCreatePdi(
        studentId: string,
        year: number = new Date().getFullYear(),
        contextualData?: { profile?: UserProfile | null, studentName?: string }
    ): Promise<{ data: PdiDocument | null, error: any }> {
        const { data: existing, error: fetchError } = await supabase
            .from('pdi_documents')
            .select('*')
            .eq('student_id', studentId)
            .eq('year', year)
            .maybeSingle();
        // ...
    },

    async updatePdiSection(pdiId: string, sectionKey: keyof PDIProfileData, sectionData: any) {
        // Validação + update
    },

    async upsertTeacherEntry(entry: TeacherEntry) {
        const { data, error } = await supabase
            .from('pdi_teacher_entries')
            .upsert(entry, { onConflict: 'pdi_document_id, teacher_id, subject, bimester' })
            .select()
            .single();
        // ...
    },

    async getTeacherEntries(pdiId: string) {
        const { data, error } = await supabase
            .from('pdi_teacher_entries')
            .select('*')
            .eq('pdi_document_id', pdiId);
        // ...
    },

    async getSchoolPdis(schoolId: string): Promise<PdiDocument[]> {
        // ...
    }
};
```

##### C. `src/services/PdiBlock9Service.ts` (LINHAS 1-50+)
```typescript
export const PdiBlock9Service = {
    async getStudentAdaptations(pdiId: string) {
        // Busca adaptações do bloco 9
    },
    
    async getAdaptationStats(pdiId: string) {
        // Estatísticas de adaptação
    }
};
```

##### D. `src/services/PdiExportService.ts`
```typescript
export const exportPdiToDocx = async (pdiId: string) => {
    // Exporta PDI para DOCX
};
```

**Análise de Fragmentação**:

| Responsabilidade | Arquivo | Localização |
|------------------|---------|-------------|
| Log de eventos PDI | PdiService.ts | Raiz services |
| CRUD completo PDI | PdiDocumentService.ts | pdi/ |
| Bloco 9 específico | PdiBlock9Service.ts | Raiz services |
| Exportação | PdiExportService.ts | Raiz services |

**Problema**: Um desenvolvedor não sabe qual usar para:
- Criar PDI novo? → PdiDocumentService.getOrCreatePdi()
- Logar evento? → PdiService.logEvent()
- Exportar? → PdiExportService.exportPdiToDocx()
- Bloco 9? → PdiBlock9Service.getStudentAdaptations()

🔴 **ALTA COESÃO DESEJÁVEL NÃO ALCANÇADA**

---

## 🔄 ANÁLISE DE IMPORTAÇÕES - GRAFO DE DEPENDÊNCIAS

### Padrão 1: PlanningManager (O Orquestrador)

```
PlanningManager.tsx
  ├─ import { generateGeminiContent } from '../../services/geminiService';
  ├─ import { searchCurriculum, getDeterministicCurriculum, searchPnldBookContent } from '../../services/searchService';
  ├─ import { searchQuestions } from '../../services/questionService';
  ├─ import { savePlan, GeneratedPlan } from './PlanningService';
  ├─ import { supabase } from '../../services/supabaseClient';
  ├─ import { addMemory } from '../../services/memoryService';
  ├─ import { feedbackService } from '../../services/feedbackService';
  ├─ import { getRelevantMemories } from '../../services/memoryService';
  ├─ import { exportToDocx } from '../../services/exportService';
  ├─ import { getGeneratedContents } from '../../services/databaseService';
  └─ Dynamic: import('../../services/PlanningAuthorityService')
```

**Contagem**: 11 dependências (9 estáticas + 1 dinâmica + 1 multipla)

**Problema**: Acoplamento muito alto a uma única componente

---

### Padrão 2: Data Persistence Confusão

```
Components
  ├─ importam supabaseService
  │   ├─ getClasses()
  │   ├─ getLessons()
  │   ├─ getTeacherContext()
  │   └─ saveLessonToMemory()
  │
  ├─ importam localStorageService
  │   ├─ getLocalClasses()
  │   ├─ getLocalLessons()
  │   └─ saveClassToLocal()
  │
  └─ importam databaseService
      ├─ getGeneratedContents()
      ├─ saveGeneratedContent()
      └─ deleteGeneratedContent()

Todos terminam em:
  └─ supabaseClient.ts (cliente base)
```

**Pergunta**: Qual usar para ler classes?
```typescript
// Opção 1:
const classes = await getLocalClasses(userId);

// Opção 2:
const { data } = await supabaseService.getClasses();

// Opção 3:
const { data } = await supabase.from('classes').select();
```

**Problema**: Três caminhos para mesma coisa

---

### Padrão 3: AI Services (BEM ESTRUTURADO)

```
AiCore.ts (BASE)
  ├─ getGenAIClient()
  ├─ executeWithFallback()
  ├─ decode()
  ├─ decodeAudioData()
  └─ safetySettings

Cada AI Service especializado importa:
├─ AiChatService.ts
│   └─ importa { getGenAIClient, safetySettings } from AiCore
├─ AiPdiService.ts
│   └─ importa { executeWithFallback, getGenAIClient } from AiCore
├─ AiPlanningService.ts
│   └─ importa { executeWithFallback, getGenAIClient } from AiCore
├─ AiAdaptationService.ts
│   └─ importa { executeWithFallback, getGenAIClient } from AiCore
├─ AiAssessmentService.ts
│   └─ importa { getGenAIClient } from AiCore
├─ AiPresentationService.ts
│   └─ importa { getGenAIClient } from AiCore
└─ AiUtilityService.ts
    └─ importa { getGenAIClient, safetySettings } from AiCore
```

✅ **PADRÃO CORRETO**: Hub-and-spoke com base comum

---

## 🚨 VERIFICAÇÃO DE CIRCULARIDADES (Análise Profunda)

### Teste 1: PDI Features

```
A. PdiListPage.tsx
   ├─ importa PdiDocumentService
   ├─ importa ProfileService
   └─ não importa componentes PDI

B. PDIDashboard.tsx
   ├─ importa supabase
   ├─ importa PdiDocumentService
   └─ não importa PdiListPage

C. PDIManager.tsx
   ├─ importa usePDIManager hook
   ├─ não importa serviços diretamente
   └─ não importa outras features

Resultado: ✅ SEM CIRCULARIDADE
```

### Teste 2: Planning Features

```
A. PlanningManager.tsx
   ├─ importa PlanningService
   ├─ importa geminiService (deprecated)
   ├─ importa searchService
   ├─ importa questionService
   └─ não importa componentes

B. PlanningService.ts
   ├─ importa supabaseClient
   └─ não importa componentes

C. PlanningCockpit.tsx (component dentro)
   ├─ importa PdiDocumentService
   ├─ importa getUserProfile
   ├─ importa PnldService
   └─ não importa PlanningManager

Resultado: ✅ SEM CIRCULARIDADE
```

### Teste 3: Data Services

```
supabaseClient.ts (BASE)
  └─ GoogleGenerativeAI (external)

supabaseService.ts
  ├─ importa supabaseClient ✅
  └─ não importa nada de services

localStorageService.ts
  ├─ não importa supabase ✅
  └─ usa localStorage (browser API)

databaseService.ts
  ├─ importa supabaseClient
  └─ não importa outros services ✅

Resultado: ✅ SEM CIRCULARIDADE
```

### Teste 4: School Components

```
SchoolAutocomplete.tsx
  ├─ importa { supabase } from supabaseClient
  └─ não importa outros componentes

SchoolSelector.tsx
  ├─ importa supabaseClient
  └─ não importa SchoolAutocomplete

SchoolSwitcher.tsx
  ├─ importa SchoolAutocomplete (SIM - importa componente!)
  └─ impode supabaseClient

SchoolSelectorScreen.tsx
  └─ não importa outro componente

Resultado: ⚠️ BAIXO RISCO
Detalhes: SchoolSwitcher usa SchoolAutocomplete, mas não bidirecional
```

---

## 📈 ESTATÍSTICAS DE IMPORTAÇÕES

### Top 10 Módulos Mais Importados

| Módulo | Importado por | Vezes | Risco |
|--------|---------------|-------|-------|
| `supabaseClient` | 20+ arquivos | 40+ | ALTO |
| `geminiService` | 8 arquivos | 15+ | MÉDIO |
| `PdiDocumentService` | 12 arquivos | 18+ | MÉDIO |
| `localStorageService` | 6 arquivos | 8+ | BAIXO |
| `databaseService` | 5 arquivos | 7+ | BAIXO |
| `supabaseService` | 8 arquivos | 12+ | MÉDIO |
| `searchService` | 4 arquivos | 6+ | BAIXO |
| `ProfileService` | 5 arquivos | 7+ | BAIXO |
| `feedbackService` | 3 arquivos | 4+ | BAIXO |
| `exportService` | 4 arquivos | 5+ | BAIXO |

**Problema**: `supabaseClient` é muito importante, qualquer mudança afeta 20+ arquivos

---

## 🧪 RECOMENDAÇÕES TÉCNICAS ESPECÍFICAS

### 1. Consolidação de StudentService

**Antes**:
```typescript
// Dois arquivos, duas interfaces diferentes
import { Student } from './studentService';
import { Student } from './pdi/StudentService'; // ❌ CONFLITO
```

**Depois**:
```typescript
// Um único arquivo, uma única interface
import type { Student } from './studentService';

// Unifique a interface:
export interface Student {
    id: string;
    name: string;
    student_code?: string;
    current_school_id: string;
    school_id?: string; // Compatibilidade
    class_id?: string;
    state_unique_id?: string;
    pdi_needs?: string[];
    observations?: string;
    created_at: string;
}

// Unifique os métodos:
export const StudentService = {
    async getStudentsBySchool(schoolId: string): Promise<Student[]>,
    async getStudentById(id: string): Promise<Student | null>,
    async createStudent(data: CreateStudentDTO): Promise<Student>,
    async updateStudent(id: string, data: Partial<Student>): Promise<Student>,
    async archiveStudent(id: string, reason: string, details: string): Promise<void>
};
```

### 2. Consolidação de PdiDocumentService

```typescript
// Mover tudo para PdiDocumentService
export const PdiDocumentService = {
    // Operações CRUD (já tem)
    async getOrCreatePdi(...),
    async updatePdiSection(...),
    async getTeacherEntries(...),
    async getSchoolPdis(...),
    
    // Adicionar logEvent (de PdiService)
    async logEvent(
        studentId: string,
        type: PdiRecordType,
        title: string,
        content: any,
        pdiBlock?: string
    ): Promise<PdiRecord | null>,
    
    // Adicionar exportação (de PdiExportService)
    async exportPdiToDocx(pdiId: string): Promise<Blob>,
    
    // Manter separado (especializado)
    // Block9 → PdiBlock9Service (OK separado)
};
```

### 3. Data Persistence Adapter Pattern

```typescript
// Nova abstração
export interface DataPersistenceAdapter {
    getClasses(userId: string): Promise<Class[]>;
    getClass(id: string): Promise<Class | null>;
    saveClass(data: Class): Promise<Class>;
    deleteClass(id: string): Promise<void>;
    
    getLessons(classId: string): Promise<Lesson[]>;
    saveLessonToMemory(lesson: Lesson): Promise<void>;
    
    getTeacherContext(userId: string): Promise<TeacherContext>;
}

// Implementação 1: Supabase
export class SupbaseDataAdapter implements DataPersistenceAdapter {
    async getClasses(userId: string) {
        return supabase
            .from('classes')
            .select('*')
            .eq('user_id', userId);
    }
    // ...
}

// Implementação 2: LocalStorage
export class LocalDataAdapter implements DataPersistenceAdapter {
    async getClasses(userId: string) {
        const classes = localStorage.getItem(`classes_${userId}`);
        return JSON.parse(classes || '[]');
    }
    // ...
}

// Factory para seleção
export function createDataAdapter(strategy: 'local' | 'remote'): DataPersistenceAdapter {
    if (strategy === 'local') {
        return new LocalDataAdapter();
    }
    return new SupbaseDataAdapter();
}

// Uso em componentes
const adapter = createDataAdapter(useOfflineMode ? 'local' : 'remote');
const classes = await adapter.getClasses(userId);
```

### 4. Refatoração de Nomenclatura

```typescript
// ANTES - Confuso
PdiService → logEvent()
pdi/StudentService → StudentService
SchoolSelector vs SchoolSelectorScreen

// DEPOIS - Claro
PdiDocumentService → logEvent()
StudentService (único)
SchoolSelectionComposer (wrapper)
├─ SchoolAutocomplete (base)
├─ SchoolSwitcher (usar autocomplete)
└─ SchoolSelectorScreen (tela completa)
```

---

## 📋 CHECKLIST DE VERIFICAÇÃO PÓS-REFATORAÇÃO

### StudentService Consolidação
- [ ] Criar backup de ambos os arquivos
- [ ] Mesclar interfaces
- [ ] Mesclar métodos
- [ ] Unificar assinaturas de retorno
- [ ] Testar todas as importações (find references)
- [ ] Atualizar 8+ arquivos que importam
- [ ] Remover arquivo duplicado
- [ ] Executar testes

### PdiDocumentService Consolidação
- [ ] Adicionar logEvent() a PdiDocumentService
- [ ] Adicionar exportPdiToDocx() a PdiDocumentService
- [ ] Atualizar importações em 6+ arquivos
- [ ] Manter PdiBlock9Service (especializado)
- [ ] Remover ou deprecate PdiService se vazio
- [ ] Remover ou integrar PdiExportService
- [ ] Executar testes

### Data Adapter Refatoração
- [ ] Criar interface DataPersistenceAdapter
- [ ] Implementar SupbaseDataAdapter
- [ ] Implementar LocalDataAdapter
- [ ] Criar factory function
- [ ] Refatorar 4+ componentes para usar adapter
- [ ] Remover imports diretos de supabaseService, localStorageService, databaseService
- [ ] Executar testes

---

## 🎯 ORDEM DE IMPLEMENTAÇÃO RECOMENDADA

**Dia 1**: StudentService Consolidação (crítico)
```bash
1. Copiar src/services/studentService.ts → temp_backup.ts
2. Copiar src/services/pdi/StudentService.ts → temp_backup2.ts
3. Mesclar code em src/services/studentService.ts
4. Atualizar imports em: PdiListPage, PDIDashboard, PDIManager, etc
5. Remover src/services/pdi/StudentService.ts
6. npm run build (verificar compilação)
7. npm test (se houver testes)
```

**Dia 2**: PdiDocumentService Consolidação (crítico)
```bash
1. Adicionar método logEvent() a PdiDocumentService
2. Adicionar método exportPdiToDocx() a PdiDocumentService
3. Mover tipo PdiRecord para tipos
4. Atualizar imports em 6+ arquivos
5. Remover/deprecate PdiService
6. Remover/integrar PdiExportService
7. npm run build
```

**Dia 3**: Cleanup de geminiService (importante)
```bash
1. Encontrar 8+ arquivos que importam geminiService
2. Substituir por imports diretos de ai/*.ts
3. Remover src/services/geminiService.ts
4. npm run build
```

**Semana 2**: Data Adapter Refatoração (médio prazo)
```bash
1. Criar src/services/core/DataAdapter.ts (interface)
2. Criar src/services/core/adapters/
3. Implementar SupbaseAdapter.ts
4. Implementar LocalAdapter.ts
5. Refatorar componentes um por um
6. Testes integração
```

---

**Conclusão**: O código está **funcionando mas fragmentado**. As consolidações acima resolveriam 80% dos problemas de manutenibilidade.

