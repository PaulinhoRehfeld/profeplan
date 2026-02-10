# 🔧 EXEMPLOS PRÁTICOS DE REFATORAÇÃO - PROFEPLAN

**Baseado em**: ANALISE_ORCHESTRATION_FLUXOS.md  
**Objetivo**: Código refatorado pronto para implementação

---

## 📐 EXEMPLO 1: PlanningOrchestrator (Sugestão #1)

### ANTES (Disperso em 10+ arquivos)
```typescript
// PlanningManager.tsx - Caótico
const handleGeneratePlan = async () => {
    const quota = await checkUsageQuota(userId); // userService
    if (!quota.allowed) throw new Error(quota.message);

    const context = await getTeacherContext(userId); // supabaseService
    const curriculum = await searchCurriculum(...); // searchService
    const enemQ = await fetchEnemQuestions(...); // questionService
    const pnldChapters = await calculateDigitalEducationChapters(...); // AiPlanningService

    const prompt = `${SYSTEM_PROMPT}\n...; // constants + manual assembly

    const plan = await executeWithFallback('GeneratePlan', async (model) => {
        const genAI = getGenAIClient(); // AiCore
        const result = await genAI.getGenerativeModel({ model }).generateContent(prompt);
        return result.response.text();
    });

    const saved = { ...plan, synced: false };
    localStorage.setItem('buffer', JSON.stringify(saved)); // localStorage

    await supabase.from('generated_contents').insert(saved); // supabase
    await incrementUserUsage(userId, 'generate'); // userService (async)

    addMemory(userId, prompt); // memoryService
    feedbackService.log(plan); // feedbackService
};
```

**Problemas**:
- ❌ 7 awaits, 3 fire-and-forget
- ❌ 10+ imports
- ❌ Sem try-catch coordenado
- ❌ Race conditions
- ❌ Impossível testar

### DEPOIS (Facade Pattern)
```typescript
// src/services/orchestration/PlanningOrchestrator.ts
export class PlanningOrchestrator {
    constructor(
        private aiService: AiService,
        private dalayer: DataAccessLayer,
        private creditManager: CreditManager,
        private eventBus: EventBus
    ) {}

    /**
     * Orquestra todo o fluxo de planejamento trimestral
     * Garante: quota → context → generation → sync → credit
     */
    async generateTermPlan(context: PlanningContext): Promise<TermPlan> {
        console.log(`[Orchestrator] Starting planning for ${context.subject}`);

        return this.creditManager.executeWithCreditCheck(
            context.userId,
            async () => {
                // 1. Enriquecer contexto (paralelo)
                const enriched = await this.enrichContext(context);

                // 2. Gerar plano
                const plan = await this.aiService.planning({
                    ...context,
                    ...enriched
                });

                // 3. Persistir
                await this.dalayer.savePlan(context.userId, plan);

                // 4. Side effects (async, mas sem bloquear)
                this.eventBus.publish('planning:generated', {
                    plan,
                    userId: context.userId
                });

                return plan;
            },
            1 // creditCost
        );
    }

    private async enrichContext(context: PlanningContext) {
        const [currResult, enemResult, pnldResult] = await Promise.allSettled([
            this.dalayer.searchCurriculum(context),
            this.dalayer.searchEnemQuestions(context),
            this.dalayer.getPnldChapters(context)
        ]);

        return {
            curriculum: currResult.status === 'fulfilled' ? currResult.value : null,
            enemQuestions: enemResult.status === 'fulfilled' ? enemResult.value : null,
            pnldChapters: pnldResult.status === 'fulfilled' ? pnldResult.value : null
        };
    }
}

// src/features/Planning/PlanningManager.tsx (After)
const PlanningManager: React.FC<Props> = ({ userId, context }) => {
    const orchestrator = useMemo(
        () => new PlanningOrchestrator(...),
        []
    );

    const handleGeneratePlan = async () => {
        try {
            setLoading(true);
            const plan = await orchestrator.generateTermPlan({
                userId,
                subject: selectedSubject,
                // ...
            });
            setGeneratedPlan(plan);
        } catch (error) {
            handleError(error);
        } finally {
            setLoading(false);
        }
    };

    return (
        <div>
            <button onClick={handleGeneratePlan}>Gerar Plano</button>
        </div>
    );
};
```

**Benefícios**:
- ✅ 1 try-catch
- ✅ 1 import (PlanningOrchestrator)
- ✅ Testável (mock orchestrator)
- ✅ Reutilizável (Assessment, PDI, etc)
- ✅ 70% menos código em PlanningManager

---

## 📊 EXEMPLO 2: PDI State com Zustand (Sugestão #2)

### ANTES (502 linhas em usePDIManager)
```typescript
// src/features/PDI/usePDIManager.ts (502 linhas!)
export const usePDIManager = (userId: string, userProfile: UserProfile) => {
    const [loading, setLoading] = useState(false);
    const [classes, setClasses] = useState<Class[]>([]);
    const [lessons, setLessons] = useState<any[]>([]);
    const [selectedClass, setSelectedClass] = useState<Class | null>(null);
    const [selectedLesson, setSelectedLesson] = useState<any | null>(null);
    const [studentsWithNeeds, setStudentsWithNeeds] = useState<Student[]>([]);
    const [adaptations, setAdaptations] = useState<Record<string, StudentAdaptation>>({});
    const [error, setError] = useState('');
    const [generatingId, setGeneratingId] = useState<string | null>(null);
    // ... 10+ mais estados

    useEffect(() => { loadInitialData(); }, [userId, userProfile]);
    
    const loadInitialData = async () => { /* 50+ linhas */ };
    const handleClassSelect = async (classId: string) => { /* ... */ };
    const handleGenerateAdaptation = async (studentId, lesson) => { /* ... */ };
    // ... 8+ handlers

    return {
        loading, classes, lessons, selectedClass, selectedLesson,
        studentsWithNeeds, adaptations, error, generatingId,
        // ... 15+ return values
    };
};

// Uso
const {
    loading, classes, lessons, selectedClass, selectedLesson,
    studentsWithNeeds, adaptations, error, generatingId,
    setSelectedLesson, setPdiProfileStudent, setConsolidatorStudent,
    handleClassSelect, handleGenerateAdaptation, handleValidate,
    // ... hard to track
} = usePDIManager(userId, userProfile);
```

**Problemas**:
- ❌ 15+ return values
- ❌ 500+ linhas de lógica
- ❌ Testabilidade: impossível
- ❌ Reutilização: impossível

### DEPOIS (Zustand)
```typescript
// src/features/PDI/store/pdiStore.ts
interface PDIState {
    // UI State
    selectedClass: Class | null;
    selectedLesson: Lesson | null;
    generatingId: string | null;
    feedbackModalOpen: boolean;
    viewingAdaptation: StudentAdaptation | null;

    // Data
    classes: Class[];
    lessons: Lesson[];
    studentsWithNeeds: Student[];
    adaptations: Record<string, StudentAdaptation>;
    error: string | null;

    // Actions
    selectClass: (classId: string) => Promise<void>;
    selectLesson: (lessonId: string) => void;
    setGenerating: (id: string | null) => void;
    setError: (error: string | null) => void;
    openFeedbackModal: () => void;
    closeFeedbackModal: () => void;
    viewAdaptation: (adaptation: StudentAdaptation | null) => void;

    // Async actions
    loadClasses: (userId: string, schoolId: string) => Promise<void>;
    loadLessons: (userId: string) => Promise<void>;
    generateAdaptation: (
        studentId: string,
        lessonId: string,
        context: any
    ) => Promise<StudentAdaptation>;
    saveFeedback: (adaptationId: string, feedback: string) => Promise<void>;
}

export const usePDIStore = create<PDIState>((set, get) => ({
    // Initial State
    selectedClass: null,
    selectedLesson: null,
    generatingId: null,
    feedbackModalOpen: false,
    viewingAdaptation: null,
    classes: [],
    lessons: [],
    studentsWithNeeds: [],
    adaptations: {},
    error: null,

    // UI Actions
    selectClass: async (classId: string) => {
        set({ selectedClass: get().classes.find(c => c.id === classId) || null });
    },

    selectLesson: (lessonId: string) => {
        set({ selectedLesson: get().lessons.find(l => l.id === lessonId) || null });
    },

    setGenerating: (id: string | null) => {
        set({ generatingId: id });
    },

    setError: (error: string | null) => {
        set({ error });
    },

    openFeedbackModal: () => {
        set({ feedbackModalOpen: true });
    },

    closeFeedbackModal: () => {
        set({ feedbackModalOpen: false });
    },

    viewAdaptation: (adaptation: StudentAdaptation | null) => {
        set({ viewingAdaptation: adaptation });
    },

    // Data Loading
    loadClasses: async (userId: string, schoolId: string) => {
        try {
            const classes = await classService.getClasses(schoolId);
            const students = classes.flatMap(c => c.students || []);
            const withNeeds = students.filter(s => s.needs_adaptation);
            
            set({
                classes,
                studentsWithNeeds: withNeeds,
                error: null
            });
        } catch (error) {
            set({ error: (error as Error).message });
        }
    },

    loadLessons: async (userId: string) => {
        try {
            const lessons = await databaseService.getGeneratedContents(userId);
            set({ lessons, error: null });
        } catch (error) {
            set({ error: (error as Error).message });
        }
    },

    // AI Generation
    generateAdaptation: async (
        studentId: string,
        lessonId: string,
        context: any
    ) => {
        set({ generatingId: studentId, error: null });

        try {
            const adaptation = await AiService.pdi({
                studentId,
                lessonId,
                ...context
            });

            set(state => ({
                adaptations: {
                    ...state.adaptations,
                    [studentId]: adaptation
                },
                generatingId: null
            }));

            return adaptation;
        } catch (error) {
            set({ 
                error: (error as Error).message,
                generatingId: null
            });
            throw error;
        }
    },

    saveFeedback: async (adaptationId: string, feedback: string) => {
        try {
            await PdiService.saveFeedback(adaptationId, feedback);
            set({ feedbackModalOpen: false });
        } catch (error) {
            set({ error: (error as Error).message });
        }
    }
}));
```

### Uso em Componentes (MUITO MAIS SIMPLES)
```typescript
// src/features/PDI/PDIManager.tsx
const PDIManager: React.FC<Props> = ({ userId, userProfile }) => {
    // ANTES: 18 destructures
    // DEPOIS: 1 hook
    const {
        selectedClass,
        selectedLesson,
        classes,
        generatingId,
        loadClasses,
        loadLessons,
        generateAdaptation
    } = usePDIStore();

    useEffect(() => {
        if (userProfile?.school_id) {
            loadClasses(userId, userProfile.school_id);
            loadLessons(userId);
        }
    }, [userId, userProfile?.school_id, loadClasses, loadLessons]);

    return (
        <div>
            <ClassSelector
                classes={classes}
                onSelect={({ id }) => usePDIStore.setState({ selectedClass: id })}
            />

            {selectedClass && (
                <LessonSelector
                    lessons={usePDIStore(state => state.lessons)}
                    onSelect={({ id }) => usePDIStore.setState({ selectedLesson: id })}
                />
            )}

            {selectedLesson && (
                <StudentAdaptationForm
                    onSubmit={(studentId, context) =>
                        generateAdaptation(studentId, selectedLesson.id, context)
                    }
                    isLoading={generatingId !== null}
                />
            )}
        </div>
    );
};
```

**Benefícios**:
- ✅ 500 linhas → 150 linhas
- ✅ State centralizado (DevTools)
- ✅ Fácil de testar
- ✅ Fácil de debugar
- ✅ Reutilizável

---

## 🗄️ EXEMPLO 3: DataAccessLayer (Sugestão #3)

### ANTES (Chamadas diretas a Supabase + LocalStorage)
```typescript
// Espalhado em múltiplos arquivos
const classes = await supabase
    .from('classes')
    .select('*')
    .eq('school_id', schoolId);

// Outro lugar
const localClasses = JSON.parse(
    localStorage.getItem(`classes_${userId}`) || '[]'
);

// Sem sincronização
```

### DEPOIS (Data Access Layer Unificado)
```typescript
// src/services/data/DataAccessLayer.ts
export class DataAccessLayer {
    private supabaseGateway: SupabaseGateway;
    private localGateway: LocalStorageGateway;
    private syncManager: SyncManager;

    constructor() {
        this.supabaseGateway = new SupabaseGateway(supabase);
        this.localGateway = new LocalStorageGateway();
        this.syncManager = new SyncManager(
            this.supabaseGateway,
            this.localGateway
        );
    }

    /**
     * Busca com fallback: Supabase → LocalStorage
     */
    async getClasses(userId: string, schoolId: string): Promise<Class[]> {
        try {
            const remote = await this.supabaseGateway.getClasses(schoolId);
            
            // Sync em background
            this.localGateway.setClasses(userId, remote);
            
            return remote;
        } catch (error) {
            console.warn('Supabase error, using local cache:', error);
            
            const local = this.localGateway.getClasses(userId);
            if (local.length === 0) {
                throw new Error('No data available (offline and no cache)');
            }
            
            return local;
        }
    }

    /**
     * Busca com merge automático
     */
    async getClassesWithSync(
        userId: string,
        schoolId: string
    ): Promise<Class[]> {
        const [remote, local] = await Promise.allSettled([
            this.supabaseGateway.getClasses(schoolId),
            Promise.resolve(this.localGateway.getClasses(userId))
        ]);

        const remoteData = remote.status === 'fulfilled' ? remote.value : [];
        const localData = local.status === 'fulfilled' ? local.value : [];

        // Merge: remote wins on conflict
        const merged = this.syncManager.merge(remoteData, localData);

        // Store merged locally
        this.localGateway.setClasses(userId, merged);

        return merged;
    }

    /**
     * Salvar com sincronização
     */
    async saveClass(userId: string, klass: Class): Promise<void> {
        // Otimista: salva local primeiro
        this.localGateway.saveClass(userId, klass);

        try {
            // Depois sincroniza com Supabase
            await this.supabaseGateway.saveClass(klass);
        } catch (error) {
            console.error('Failed to sync class to cloud:', error);
            // Ainda temos no local, pode tentar depois
            this.syncManager.markForSync(klass.id, 'classes');
            throw error;
        }
    }

    /**
     * Sincronizar pendências
     */
    async syncPending(userId: string): Promise<void> {
        const pending = this.syncManager.getPending();

        for (const item of pending) {
            try {
                await this.supabaseGateway.save(item.type, item.data);
                this.syncManager.markAsSynced(item.id);
            } catch (error) {
                console.error(`Failed to sync ${item.id}:`, error);
            }
        }
    }
}

// src/services/gateways/SupabaseGateway.ts
export class SupabaseGateway {
    constructor(private supabase: SupabaseClient) {}

    async getClasses(schoolId: string): Promise<Class[]> {
        const { data, error } = await this.supabase
            .from('classes')
            .select('*')
            .eq('school_id', schoolId);

        if (error) throw error;
        return data || [];
    }

    async saveClass(klass: Class): Promise<void> {
        const { error } = await this.supabase
            .from('classes')
            .upsert(klass);

        if (error) throw error;
    }
}

// src/services/gateways/LocalStorageGateway.ts
export class LocalStorageGateway {
    private getKey(userId: string, type: string) {
        return `profeplan_${userId}_${type}`;
    }

    getClasses(userId: string): Class[] {
        const data = localStorage.getItem(this.getKey(userId, 'classes'));
        return data ? JSON.parse(data) : [];
    }

    setClasses(userId: string, classes: Class[]): void {
        localStorage.setItem(
            this.getKey(userId, 'classes'),
            JSON.stringify(classes)
        );
    }

    saveClass(userId: string, klass: Class): void {
        const classes = this.getClasses(userId);
        const index = classes.findIndex(c => c.id === klass.id);

        if (index >= 0) {
            classes[index] = klass;
        } else {
            classes.push(klass);
        }

        this.setClasses(userId, classes);
    }
}

// src/services/sync/SyncManager.ts
export class SyncManager {
    private pending: Map<string, any> = new Map();

    constructor(
        private remote: SupabaseGateway,
        private local: LocalStorageGateway
    ) {}

    merge(remote: any[], local: any[]): any[] {
        const merged = [...remote];

        for (const localItem of local) {
            const remoteItem = merged.find(r => r.id === localItem.id);

            if (!remoteItem) {
                // Local item doesn't exist remotely, add it
                merged.push(localItem);
            } else if (localItem.updated_at > remoteItem.updated_at) {
                // Local is newer, use it
                const index = merged.findIndex(r => r.id === localItem.id);
                merged[index] = localItem;
            }
            // else: remote is newer, keep remote
        }

        return merged;
    }

    markForSync(id: string, type: string): void {
        this.pending.set(id, { id, type });
    }

    markAsSynced(id: string): void {
        this.pending.delete(id);
    }

    getPending(): Array<{ id: string; type: string }> {
        return Array.from(this.pending.values());
    }
}
```

### Uso
```typescript
// Antes: 2-3 chamadas diferentes + manual sync
// Depois: 1 chamada, automático
const dal = new DataAccessLayer();

const classes = await dal.getClassesWithSync(userId, schoolId);
// ✅ Remote + local merged
// ✅ Offline support
// ✅ Sync pending in background
```

**Benefícios**:
- ✅ Single source of truth pattern
- ✅ Offline first
- ✅ Sync manager centralizado
- ✅ Fácil mudar provider (add SQLite)

---

## 🤖 EXEMPLO 4: AiService Consolidado (Sugestão #4)

### ANTES (Espalhado em 6 arquivos)
```typescript
// AiPlanningService.ts
export const generateTermPlan = async (context) => { /* ... */ };

// AiPdiService.ts
export const generateStudentAdaptation = async (...) => { /* ... */ };

// AiChatService.ts
export const generateProfePlanStream = async (...) => { /* ... */ };

// AiAssessmentService.ts
export const generateAssessmentWithContext = async (...) => { /* ... */ };

// Cada um com seu próprio error handling, prompt assembly, etc.
```

### DEPOIS (Unified Service)
```typescript
// src/services/ai/AiService.ts
export class AiService {
    private genAI: GoogleGenerativeAI;
    private logger: Logger;
    private metrics: MetricsCollector;

    constructor(
        apiKey: string,
        private promptFactory: PromptFactory
    ) {
        this.genAI = new GoogleGenerativeAI(apiKey);
        this.logger = new Logger('AiService');
        this.metrics = new MetricsCollector();
    }

    /**
     * Gerar Plano Trimestral
     */
    async planning(context: PlanningContext): Promise<string> {
        return this.execute('planning', context, async () => {
            const prompt = this.promptFactory.buildPlanningPrompt(context);
            return this.generateContent(prompt);
        });
    }

    /**
     * Gerar Adaptação PDI/DUA
     */
    async pdi(context: PDIContext): Promise<string> {
        return this.execute('pdi', context, async () => {
            const prompt = this.promptFactory.buildPDIPrompt(context);
            return this.generateContent(prompt);
        });
    }

    /**
     * Gerar Prova/Avaliação
     */
    async assessment(context: AssessmentContext): Promise<string> {
        return this.execute('assessment', context, async () => {
            const prompt = this.promptFactory.buildAssessmentPrompt(context);
            return this.generateContent(prompt);
        });
    }

    /**
     * Chat em Streaming
     */
    async *chat(
        message: string,
        history: Array<{ role: string; content: string }>,
        context: ChatContext
    ): AsyncGenerator<string> {
        const startTime = Date.now();

        try {
            const prompt = this.promptFactory.buildChatPrompt(
                message,
                history,
                context
            );

            yield* this.generateContentStream(prompt);

            this.metrics.recordSuccess('chat', Date.now() - startTime);
        } catch (error) {
            this.metrics.recordError('chat', error);
            throw error;
        }
    }

    /**
     * Grade Written Answer
     */
    async grade(
        question: string,
        answer: string,
        rubric: string
    ): Promise<GradingResult> {
        return this.execute('grading', { question, answer }, async () => {
            const prompt = this.promptFactory.buildGradingPrompt(
                question,
                answer,
                rubric
            );
            const response = await this.generateContent(prompt);
            return this.parseGradingResponse(response);
        });
    }

    /**
     * Core execution com resilience
     */
    private async execute<T>(
        actionName: string,
        context: any,
        operation: () => Promise<T>
    ): Promise<T> {
        const startTime = Date.now();
        let lastError: Error | null = null;

        for (const model of this.getModelChain()) {
            try {
                this.logger.info(
                    `[${actionName}] Tentando modelo: ${model}`
                );

                // Store model choice
                this.metrics.recordAttempt(actionName, model);

                const result = await this.withModel(model, operation);

                // Sucesso
                this.metrics.recordSuccess(
                    actionName,
                    Date.now() - startTime,
                    model
                );

                return result;
            } catch (error) {
                lastError = error as Error;
                this.logger.warn(
                    `[${actionName}] Falha no modelo ${model}: ${lastError.message}`
                );
                // Continue para próximo modelo
            }
        }

        // Todos falharam
        this.metrics.recordFailure(actionName, lastError!);
        throw new Error(
            `All models failed for ${actionName}. Last error: ${lastError?.message}`
        );
    }

    /**
     * Geração com timeout
     */
    private async generateContent(
        prompt: string,
        timeoutMs: number = 30000
    ): Promise<string> {
        const controller = new AbortController();
        const timeout = setTimeout(
            () => controller.abort(),
            timeoutMs
        );

        try {
            const model = this.genAI.getGenerativeModel({
                model: this.getCurrentModel()
            });

            const result = await model.generateContent(prompt);
            const response = await result.response;

            return response.text();
        } finally {
            clearTimeout(timeout);
        }
    }

    /**
     * Geração em streaming
     */
    private async *generateContentStream(
        prompt: string,
        timeoutMs: number = 60000
    ): AsyncGenerator<string> {
        const model = this.genAI.getGenerativeModel({
            model: this.getCurrentModel()
        });

        const result = await model.generateContentStream(prompt);

        for await (const chunk of result.stream) {
            if (chunk.text) {
                yield chunk.text;
            }
        }
    }

    /**
     * Helper: Change model for a specific operation
     */
    private async withModel<T>(
        modelName: string,
        operation: () => Promise<T>
    ): Promise<T> {
        const previous = this.currentModel;
        this.currentModel = modelName;

        try {
            return await operation();
        } finally {
            this.currentModel = previous;
        }
    }

    private getModelChain(): string[] {
        return [
            'gemini-2.0-flash',
            'gemini-2.0-flash-lite-preview-02-05',
            'gemini-flash-latest',
            'gemini-2.0-flash-exp'
        ];
    }

    private getCurrentModel(): string {
        return this.currentModel || this.getModelChain()[0];
    }

    private currentModel: string = '';

    private parseGradingResponse(response: string): GradingResult {
        // Parse estruturado
        const match = response.match(
            /Score:\s*(\d+)\/(\d+).*?Feedback:\s*(.*?)(?=---|\Z)/s
        );

        if (!match) {
            throw new Error('Invalid grading response format');
        }

        return {
            score: parseInt(match[1], 10),
            maxScore: parseInt(match[2], 10),
            feedback: match[3].trim()
        };
    }
}

// src/services/ai/PromptFactory.ts
export class PromptFactory {
    buildPlanningPrompt(context: PlanningContext): string {
        return `
${SYSTEM_PROMPT_PLANNING}

DADOS DO CONTEXTO:
- Subject: ${context.subject}
- Grade: ${context.grade}
- Period: ${context.period}
- Curriculum: ${context.curriculum || 'BNCC Geral'}
- PNLD Book: ${context.pnldBook || 'Não especificado'}
- Teacher Memory: ${context.teacherMemory || 'Novo professor'}

TAREFA:
Gere um plano trimestral completo...
`;
    }

    buildPDIPrompt(context: PDIContext): string {
        return `
${SYSTEM_PROMPT_PDI}

ALUNO:
- Nome: ${context.studentName}
- Série: ${context.grade}
- Necessidades: ${context.needs.join(', ')}
- Observações: ${context.observations}

AULA ORIGINAL:
${context.originalContent.substring(0, 3000)}

TAREFA:
Crie uma adaptação DUA para este aluno...
`;
    }

    buildAssessmentPrompt(context: AssessmentContext): string {
        // ...
    }

    buildChatPrompt(
        message: string,
        history: any[],
        context: ChatContext
    ): string {
        // ...
    }

    buildGradingPrompt(
        question: string,
        answer: string,
        rubric: string
    ): string {
        // ...
    }
}

// src/services/ai/MetricsCollector.ts
export class MetricsCollector {
    private attempts: Map<string, { model: string; count: number }[]> = new Map();
    private successes: Map<string, { model: string; duration: number }[]> = new Map();
    private failures: Map<string, Error[]> = new Map();

    recordAttempt(action: string, model: string): void {
        // Track attempt
    }

    recordSuccess(
        action: string,
        duration: number,
        model: string
    ): void {
        // Track success
        console.log(`✅ ${action} succeeded in ${duration}ms (${model})`);
    }

    recordError(action: string, error: Error): void {
        // Track error
        console.error(`❌ ${action} failed:`, error);
    }

    recordFailure(action: string, lastError: Error): void {
        // Track all attempts failed
    }

    getMetrics() {
        return {
            attempts: Object.fromEntries(this.attempts),
            successes: Object.fromEntries(this.successes),
            failures: Object.fromEntries(this.failures)
        };
    }
}
```

### Uso
```typescript
// Antes: 6 imports diferentes
import { generateTermPlan } from '../../services/ai/AiPlanningService';
import { generateStudentAdaptation } from '../../services/ai/AiPdiService';
import { generateAssessmentWithContext } from '../../services/ai/AiAssessmentService';
// ...

// Depois: 1 import
const aiService = new AiService(apiKey, new PromptFactory());

const plan = await aiService.planning(context);
const adaptation = await aiService.pdi(context);
const assessment = await aiService.assessment(context);
const grading = await aiService.grade(q, a, rubric);

// Metrics
const metrics = aiService.getMetrics();
console.log(metrics);
// {
//   attempts: { planning: [{model: 'gemini-2.0-flash', count: 1}], ...},
//   successes: { planning: [{duration: 2500, model: '...'}], ...},
//   failures: {}
// }
```

**Benefícios**:
- ✅ 6 serviços → 1
- ✅ Fallback centralizado
- ✅ Métricas/logging centralizado
- ✅ Timeout consistente
- ✅ Fácil AB test prompts

---

## 💳 EXEMPLO 5: CreditManager Transacional (Sugestão #5)

### ANTES (Fire-and-forget problemático)
```typescript
// PlanningService.ts
const quota = await checkUsageQuota(userId); // Check
if (!quota.allowed) throw new Error(...);

const plan = await generateWithGemini(...); // Pode falhar

localStorage.setItem(...); // Local save

await supabase.insert(plan); // Cloud save, pode falhar

await incrementUserUsage(userId, 'generate'); // Fire and forget!
// ⚠️ Se falhar, crédito não é cobrado
// ⚠️ Se Gemini falha, crédito é cobrado mesmo assim?
```

### DEPOIS (Transacional)
```typescript
// src/services/billing/CreditManager.ts
export class CreditManager {
    constructor(private dal: DataAccessLayer) {}

    /**
     * Executa operação com garantia de crédito
     * - Check/Reserve antes
     * - Confirm/Rollback depois
     */
    async executeWithCreditCheck<T>(
        userId: string,
        operation: () => Promise<T>,
        costInCredits: number = 1
    ): Promise<T> {
        // 1. Check balance (pessimistic)
        const balance = await this.getBalance(userId);
        if (balance < costInCredits) {
            throw new InsufficientCreditsError(
                `Saldo insuficiente. Necessário: ${costInCredits}, Tem: ${balance}`
            );
        }

        // 2. Reserve credits (optimistic lock)
        const reservation = await this.reserve(
            userId,
            costInCredits,
            'operation'
        );

        try {
            // 3. Execute operation
            const result = await operation();

            // 4. Confirm reservation (mark as used)
            await this.confirmReservation(reservation.id);

            return result;
        } catch (error) {
            // 4b. Rollback if operation failed
            await this.cancelReservation(reservation.id);
            throw error;
        }
    }

    /**
     * Get current balance
     */
    async getBalance(userId: string): Promise<number> {
        const user = await this.dal.getUserProfile(userId);
        return user.credits || 0;
    }

    /**
     * Reserve credits (returns reservation ID)
     */
    private async reserve(
        userId: string,
        amount: number,
        reason: string
    ): Promise<CreditReservation> {
        const reservation: CreditReservation = {
            id: generateUUID(),
            userId,
            amount,
            reason,
            status: 'reserved',
            createdAt: new Date(),
            expiresAt: new Date(Date.now() + 5 * 60 * 1000) // 5 min timeout
        };

        // Store reservation
        await this.dal.saveCreditReservation(reservation);

        return reservation;
    }

    /**
     * Confirm (apply deduction)
     */
    private async confirmReservation(reservationId: string): Promise<void> {
        const reservation = await this.dal.getCreditReservation(reservationId);

        if (!reservation) {
            throw new Error(`Reservation ${reservationId} not found`);
        }

        // Atomic update: check version and deduct
        const updated = await this.dal.deductCredits(
            reservation.userId,
            reservation.amount,
            {
                reservationId,
                reason: reservation.reason
            }
        );

        if (!updated) {
            throw new Error('Credit deduction failed (version mismatch?)');
        }

        // Mark reservation as confirmed
        await this.dal.updateCreditReservation(reservationId, {
            status: 'confirmed',
            confirmedAt: new Date()
        });
    }

    /**
     * Rollback reservation
     */
    private async cancelReservation(reservationId: string): Promise<void> {
        const reservation = await this.dal.getCreditReservation(reservationId);

        if (!reservation) return;

        await this.dal.updateCreditReservation(reservationId, {
            status: 'cancelled',
            cancelledAt: new Date()
        });
    }

    /**
     * Clean up expired reservations (background job)
     */
    async cleanupExpiredReservations(): Promise<number> {
        const expired = await this.dal.getExpiredReservations();
        let cleaned = 0;

        for (const reservation of expired) {
            await this.cancelReservation(reservation.id);
            cleaned++;
        }

        return cleaned;
    }
}

// src/services/orchestration/PlanningOrchestrator.ts (updated)
export class PlanningOrchestrator {
    constructor(
        private aiService: AiService,
        private dal: DataAccessLayer,
        private creditManager: CreditManager
    ) {}

    async generateTermPlan(context: PlanningContext): Promise<TermPlan> {
        return this.creditManager.executeWithCreditCheck(
            context.userId,
            async () => {
                // Só executa se check passou
                const plan = await this.aiService.planning(context);

                // Salva
                await this.dal.savePlan(context.userId, plan);

                // Side effects
                this.notifySuccess(context.userId, plan);

                return plan;
            },
            1 // 1 credit
        );
    }

    private notifySuccess(userId: string, plan: TermPlan) {
        // Async, não bloqueia
        Promise.all([
            this.dal.addUserMemory(userId, plan),
            this.dal.logAnalytic('plan_generated', { userId })
        ]).catch(err => console.error('Post-success hook failed:', err));
    }
}
```

### Database Schema para transações
```sql
-- credits table
CREATE TABLE user_credits (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id),
    balance INTEGER NOT NULL DEFAULT 0,
    version INTEGER NOT NULL DEFAULT 1, -- Optimistic lock
    updated_at TIMESTAMP DEFAULT now()
);

-- Reservation table
CREATE TABLE credit_reservations (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id),
    amount INTEGER NOT NULL,
    reason TEXT NOT NULL,
    status TEXT NOT NULL, -- 'reserved', 'confirmed', 'cancelled'
    created_at TIMESTAMP DEFAULT now(),
    expires_at TIMESTAMP NOT NULL,
    confirmed_at TIMESTAMP,
    cancelled_at TIMESTAMP
);

-- Audit log
CREATE TABLE credit_transactions (
    id UUID PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id),
    amount INTEGER NOT NULL,
    type TEXT NOT NULL, -- 'deduction', 'refund', 'grant'
    reason TEXT NOT NULL,
    reservation_id UUID REFERENCES credit_reservations(id),
    created_at TIMESTAMP DEFAULT now()
);
```

**Benefícios**:
- ✅ Crédito só é debitado se sucesso
- ✅ Sem race conditions
- ✅ Auditável (transaction log)
- ✅ Rollback automático

---

## 📝 RESUMO DE IMPLEMENTAÇÃO

| Sugestão | Complexidade | Tempo Est | ROI |
|----------|-------------|----------|-----|
| #1: Orchestrator | MÉDIA | 8-12h | ⭐⭐⭐⭐⭐ |
| #2: Zustand State | BAIXA | 4-6h | ⭐⭐⭐⭐⭐ |
| #3: DataAccessLayer | ALTA | 16-20h | ⭐⭐⭐⭐ |
| #4: AiService | ALTA | 12-16h | ⭐⭐⭐⭐ |
| #5: CreditManager | MÉDIA | 8-12h | ⭐⭐⭐ |

**Total**: ~50-66 horas (2-3 sprints)

---

**Fim dos Exemplos Práticos**
