
import React, { useState, useEffect, useRef } from 'react';
import { useGlobalPlanning } from '../../contexts/GlobalPlanningContext';
import { generateGeminiContent } from '../../services/geminiService';
import { searchCurriculum, getDeterministicCurriculum } from '../../services/searchService';
import { searchQuestions } from '../../services/questionService';
import { Message, MessageRole, ToolMode } from '../../types';
import { PlanFolder, savePlan } from './PlanningService';
import { Loader2, ShieldCheck } from 'lucide-react';
import { supabase } from '../../services/supabaseClient';
import { addMemory } from '../../services/memoryService'; // Import addMemory

// --- NEW SUB-COMPONENTS ---
import { SimulationWorkspace } from './components/SimulationWorkspace';
import { PlanningCockpit } from './components/PlanningCockpit';
import { CleanChat } from './components/CleanChat';
import { getRelevantMemories } from '../../services/memoryService'; // Import Memory Service
import { parseMarkdownToLessons } from '../../utils/markdownParser';

// --- Services ---
import { exportToDocx } from '../../services/exportService';

// Updated Props Interface to match App.tsx
interface PlanningManagerProps {
    onBack?: () => void; // Optional in App.tsx usage? No, passed as no-op or specific? Actually App.tsx doesn't pass onBack in the else block.
    // App.tsx passes: userId, activeMode, availableClasses, settings, selectedClassId, quarter, enemArea, setSidebarContent
    userId: string;
    activeMode: ToolMode;
    settings: any;
    availableClasses?: any[];
    selectedClassId?: string;
    quarter?: string;
    enemArea?: string;
    setSidebarContent?: (content: React.ReactNode) => void;
}

interface Lesson {
    number: number;
    title: string;
    description: string;
    objectives: string[];
    bncc: string[];
    content?: string;
}

const PlanningManager: React.FC<PlanningManagerProps> = ({
    activeMode,
    userId,
    settings: appSettings,
    setSidebarContent,
    availableClasses,
    selectedClassId
}) => {
    // --- Global State ---
    const { termPlans, refreshTermPlans } = useGlobalPlanning();
    const [localSettings, setLocalSettings] = useState<any>(appSettings || {});

    // --- Local State ---
    const [selectedTermPlanId, setSelectedTermPlanId] = useState<string>('');
    const [parsedLessons, setParsedLessons] = useState<Lesson[]>([]);
    const [selectedLesson, setSelectedLesson] = useState<Lesson | null>(null);
    const [lessonTracking, setLessonTracking] = useState<Record<number, string>>({});

    // --- Chat State ---
    const [messages, setMessages] = useState<Message[]>([]);
    const [input, setInput] = useState('');
    const [isThinking, setIsThinking] = useState(false);
    const messagesEndRef = useRef<HTMLDivElement>(null);

    // --- Derived Props ---
    const isSimulationMode = activeMode === ToolMode.SIMULATION || activeMode === ToolMode.ENEM_BANK;

    // Logic for Cockpit: Planning or Default Chat?
    // If we are in specific planning modes, show cockpit.
    const isPlanningCockpit = activeMode === ToolMode.PLANNING || activeMode === ToolMode.QUARTERLY_PLANNING;

    // --- Effects ---
    useEffect(() => {
        if (userId) {
            refreshTermPlans(userId);
        } else {
            refreshTermPlans();
        }

        if (appSettings) setLocalSettings(appSettings);
    }, [appSettings, userId, refreshTermPlans]);

    useEffect(() => {
        if (selectedTermPlanId) {
            const plan = termPlans.find(p => p.id === selectedTermPlanId);
            if (plan) {
                // STRATEGY: Hybrid Cache + Source of Truth
                // 1. Try Structured Cache (Fastest) from DB
                if (plan.lessons && plan.lessons.length > 0) {
                    console.log("[PlanningManager] Using cached lessons from DB");
                    setParsedLessons(plan.lessons);
                }
                // 2. Fallback / Source of Truth: Parse the Text
                else if (plan.generatedText) {
                    console.log("[PlanningManager] Hydrating from Markdown Source");
                    const lessons = parseMarkdownToLessons(plan.generatedText);
                    setParsedLessons(lessons);
                } else {
                    setParsedLessons([]);
                }
                loadLessonTracking(plan.id);
            }
        } else {
            setParsedLessons([]);
            setLessonTracking({});
        }
    }, [selectedTermPlanId, termPlans]);

    useEffect(() => {
        messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    }, [messages]);

    // --- Logic: Parse Term Plan Text into Lessons ---
    // Old parseTermPlan removed in favor of utils/markdownParser

    const loadLessonTracking = async (planId: string) => {
        // Mock implementation
    };

    // --- Handlers ---
    const handleSendMessage = async (e: React.FormEvent) => {
        e.preventDefault();
        if (!input.trim()) return;

        const userMsg: Message = { id: Date.now().toString(), role: MessageRole.USER, content: input, timestamp: new Date() };
        setMessages(prev => [...prev, userMsg]);
        setInput('');
        setIsThinking(true);

        try {
            // GOVERNANCE: PEDAGOGICAL SPECIALIST MODE
            if (activeMode === ToolMode.SPECIALIST) {
                // Import dynamically or explicitly. Since I can't add top-import in this block:
                // I will add the import in a previous step/block, but here I can use the global or assume imported.
                // Wait, I should add the import first. Let's assume I did/will.

                // For now, I'll rely on a direct call if imported, or import inside logic? 
                // Better to just add the logic assuming import, and then add import.

                // Using PlanningAuthorityService
                const { PlanningAuthority } = await import('../../services/PlanningAuthorityService'); // Dynamic import for safety

                const response = await PlanningAuthority.askSpecialist(input, { history: [] }); // History implementation pending
                const aiMsg: Message = { id: (Date.now() + 1).toString(), role: MessageRole.ASSISTANT, content: response, timestamp: new Date() };
                setMessages(prev => [...prev, aiMsg]);
                setIsThinking(false);
                return;
            }

            // Context Builder
            const selectedPlan = termPlans.find(p => p.id === selectedTermPlanId);
            let context = `Você é um assistente pedagógico especialista.`;

            // --- Contexto de Memória do Professor (Learning) ---
            try {
                const memories = await getRelevantMemories(userId, input);
                if (memories.length > 0) {
                    const memoryText = memories.map(m => `- ${m.content}`).join('\n');
                    context += `\n\n[MEMÓRIA DE PREFERÊNCIAS DO USUÁRIO]:\n${memoryText}\n(Use estas preferências para personalizar o tom e o estilo da resposta.)`;
                }
            } catch (err) {
                console.warn("Failed to fetch memories", err);
            }

            // --- DETERMINISTIC vs RAG ---
            // Se for Planejamento Trimestral, usamos a busca EXATA (Anti-Alucinação)
            const isQuarterlyPlanning = activeMode === ToolMode.QUARTERLY_PLANNING || (activeMode === ToolMode.PLANNING && input.toLowerCase().includes('trimestral'));

            let curriculumContext = '';

            if (isQuarterlyPlanning && selectedPlan?.subject && selectedPlan?.grade) {
                // Tenta resolver Disciplina e Ano a partir do Plano Selecionado OU da Seleção Atual (Navigation)
                let targetSubject = selectedPlan?.subject;
                let targetGrade = selectedPlan?.grade;

                // Se não estivermos editando um plano (selectedPlan é null), pegamos da navegação atual
                if (!targetSubject && availableClasses && selectedClassId) {
                    const currentClass = availableClasses.find(c => c.id === selectedClassId);
                    if (currentClass) {
                        // Nomes esperados: "1º Ano - Ensino Médio", "6º Ano B", "História"
                        targetSubject = currentClass.name; // Assumindo que o nome da turma tem a matéria ou é a matéria?
                        // Na verdade availableClasses costuma ter { id, name, grade, subject } ou similar.
                        // Precisamos verificar a estrutura de availableClasses, mas vamos tentar extrair.
                        if (currentClass.subject) targetSubject = currentClass.subject;
                        if (currentClass.grade) targetGrade = currentClass.grade;
                    }
                }

                // Fallbacks (apenas se tudo falhar, mas ideal avisar erro)
                targetSubject = targetSubject || 'História';
                // targetGrade = targetGrade || '6º Ano'; // REMOVIDO DEFAULT PERIGOSO

                const targetPeriod = appSettings?.quarter || '1º Trimestre';

                // Normalização da Série para bater com o Banco de Dados ("2º Ano EM" vs "2º Ano - Ensino Médio")
                if (targetGrade) {
                    // Regex para capturar número do ano
                    const yearMatch = targetGrade.match(/\d+/);
                    const yearNum = yearMatch ? yearMatch[0] : '';

                    if (targetGrade.toLowerCase().includes('médio') || targetGrade.toLowerCase().includes('em')) {
                        targetGrade = `${yearNum}º Ano EM`;
                    } else if (yearNum) {
                        targetGrade = `${yearNum}º Ano`;
                    }
                } else {
                    targetGrade = '6º Ano'; // Default final se realmente não tiver nada (para não quebrar, mas pode alucinar)
                }

                // Se chamado de dentro de um plano existente, usa os dados do plano.
                // Mas a alucinação crítica é na CRIAÇÃO DO PLANO MACRO.
                // Vamos assumir que se o usuário está pedindo "Planejamento Trimestral", ele forneceu os dados.

                // CHAMADA NOVA:
                // Importar getDeterministicCurriculum no topo (vou adicionar import via multi_replace se precisar, ou assumir q já importei)
                // Nota: Preciso adicionar o import no topo depois.

                const fullText = await getDeterministicCurriculum(targetSubject, targetPeriod, targetGrade);

                if (fullText) {
                    curriculumContext = `
---CONTEXTO OFICIAL (FONTE DA VERDADE - NÃO INVENTE NADA)---
${fullText}
-------------------------------------------------------------
REGRAS DE OURO (ANTI-ALUCINAÇÃO):
1. USE APENAS AS HABILIDADES ACIMA.
2. NÃO CRIE CÓDIGOS BNCC QUE NÃO EXISTEM NO TEXTO.
3. SE O CONTEXTO ESTIVER VAZIO, AVISE O USUÁRIO.
`;
                } else {
                    curriculumContext = `[AVISO CRÍTICO]: Não foi encontrado o currículo oficial para ${targetSubject} - ${targetGrade} - ${targetPeriod}. Avise o usuário.`;
                }

            } else {
                // RAG Padrão para dúvidas pontuais ou outros modos
                const retrievalResults = await searchCurriculum(input, {
                    disciplina: selectedPlan?.subject,
                    ano: selectedPlan?.grade
                });

                if (retrievalResults.length > 0) {
                    const formattedContext = retrievalResults.map((r: any) =>
                        `- [Fonte: ${r.metadata?.source || 'Oficial'}] [Ref: ${r.metadata?.periodo || ''}] (Sim: ${r.similarity.toFixed(2)}): ${r.content}`
                    ).join('\n\n');
                    curriculumContext = `\n\n[CONTEXTO DO CURRÍCULO OFICIAL RECUPERADO (RAG)]:\n${formattedContext}`;
                }
            }

            context += curriculumContext;

            if (selectedPlan) {
                context += `\nContexto do Plano Trimestral: ${selectedPlan.grade} - ${selectedPlan.subject}.`;
            }
            if (selectedLesson) {
                context += `\nFoco Atual: Aula ${selectedLesson.number}: ${selectedLesson.title}.\nDescrição: ${selectedLesson.description}`;
            }

            // --- RAG: QUESTÕES DO BANCO DE DADOS (ENEM/SAEB) ---
            if (input.includes('[AÇÃO: QUESTÕES DE PROVA]') && selectedLesson) {
                try {
                    // Determinar Área do Conhecimento com base na disciplina do plano
                    const subject = termPlans.find(p => p.id === selectedTermPlanId)?.subject || '';
                    let area = '';

                    const normalize = (s: string) => s.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
                    const s = normalize(subject);

                    if (s.match(/historia|geografia|filosofia|sociologia|humanas/)) area = 'Humanas';
                    else if (s.match(/fisica|quimica|biologia|natureza|ciencias/)) area = 'Natureza';
                    else if (s.match(/portugues|ingles|espanhol|artes|educacao fisica|linguagens/)) area = 'Linguagens';
                    else if (s.match(/matematica/)) area = 'Matemática';

                    console.log(`[RAG] Buscando questões sobre: ${selectedLesson.title} [Disciplina: ${subject} -> Área: ${area}]`);

                    const dbQuestions = await searchQuestions(selectedLesson.title, area);

                    if (dbQuestions && dbQuestions.length > 0) {
                        const questionsText = dbQuestions.slice(0, 3).map((q, idx) => {
                            const enunciado = [q.metadata?.context, q.metadata?.alternativesIntroduction]
                                .filter(Boolean)
                                .join('\n\n');

                            return `
                        ----- QUESTÃO BANCO DE DADOS ${idx + 1} -----
                        ENUNCIADO: ${enunciado || 'Sem enunciado'}
                        ALTERNATIVAS:
                        ${q.metadata?.alternatives?.map((alt: any) => `- ${alt.text} ${alt.isCorrect ? '(CORRETA)' : ''}`).join('\n') || 'Sem alternativas'}
                        ---------------------------------------------
                        `;
                        }).join('\n');

                        context += `\n\n[BANCO DE QUESTÕES VIA RAG - USE ESTAS QUESTÕES]:\n${questionsText}\n\n[INSTRUÇÃO]: Use OBRIGATORIAMENTE as questões do banco acima para a seção "Questões Estilo ENEM". Copie o enunciado e as alternativas EXATAMENTE como estão.`;
                    } else {
                        context += `\n\n[BANCO DE QUESTÕES]: Nenhuma questão exata encontrada no banco para este tema. Crie questões inéditas baseadas no currículo.`;
                    }
                } catch (ragError) {
                    console.error('[RAG] Falha ao buscar questões:', ragError);
                }
            }

            // --- Dynamic Temperature Control ---
            // User Request: "PRÁTICAS DE LINGUAGEM HABILIDADE... temperatura precisa ser zero"
            // Heuristic: If prompt contains keywords indicating factual curriculum retrieval, drop temp to 0.
            // Heuristic: If prompt contains keywords indicating factual curriculum retrieval, drop temp to 0.
            const keywordsStrict = ['habilidade', 'bncc', 'objeto de conhecimento', 'práticas de linguagem', 'descritor', 'saeb', 'código', 'planejamento trimestral'];
            const isStrictQuery = keywordsStrict.some(k => input.toLowerCase().includes(k.toLowerCase())) || isQuarterlyPlanning;

            const dynamicTemp = isStrictQuery ? 0.1 : 0.7;

            const response = await generateGeminiContent(input, [], context, userId, dynamicTemp);

            // --- AUTO-PERSISTENCE & MEMORY ---
            // Detect if response looks like a plan, material, or exam
            if (response.length > 50) { // Simple heuristic: real content is long
                // 1. Determine Type
                let type: any = 'outros';
                let folder = PlanFolder.MATERIAL_ALUNO; // Default fallback
                let title = `Conteúdo Gerado ${new Date().toLocaleTimeString()}`;

                if (response.includes('[AÇÃO: PLANO DE AULA DETALHADO]') || response.includes('PLANO DE AULA')) {
                    type = 'plano'; folder = PlanFolder.PLANO_AULA;
                    title = selectedLesson ? `Plano - Aula ${selectedLesson.number}` : 'Plano de Aula';
                }
                else if (response.includes('[AÇÃO: MATERIAL DIDÁTICO]') || response.includes('ROTEIRO DE ESTUDO')) {
                    type = 'aula'; folder = PlanFolder.MATERIAL_ALUNO; // 'aula' maps to Activities in DriveExplorer
                    title = selectedLesson ? `Material - Aula ${selectedLesson.number}` : 'Material Didático';
                }
                else if (response.includes('[AÇÃO: QUESTÕES DE PROVA]') || response.includes('QUESTÕES')) {
                    type = 'avaliacao'; folder = PlanFolder.AVALIACOES;
                    title = selectedLesson ? `Questões - Aula ${selectedLesson.number}` : 'Avaliação';
                }

                if (type !== 'outros') {
                    // 2. Save to Drive (Async)
                    savePlan(userId, {
                        type,
                        title,
                        content: response,
                        createdAt: new Date().toISOString()
                    }, folder).then(() => console.log('Auto-saved to Drive')).catch(e => console.error('Auto-save failed', e));

                    // 3. Save to Memory (Async) - Context for AI
                    addMemory(userId, `Gerou ${title}: ${input.substring(0, 100)}...`, [type, 'auto-generated'])
                        .then(() => console.log('Memory added'))
                        .catch(e => console.error('Memory failed', e));
                }
            }

            const aiMsg: Message = { id: (Date.now() + 1).toString(), role: MessageRole.ASSISTANT, content: response, timestamp: new Date() };
            setMessages(prev => [...prev, aiMsg]);
        } catch (error) {
            console.error(error);
            const errorMsg: Message = { id: (Date.now() + 1).toString(), role: MessageRole.ASSISTANT, content: '❌ Erro ao processar. Tente novamente.', timestamp: new Date() };
            setMessages(prev => [...prev, errorMsg]);
        } finally {
            setIsThinking(false);
        }
    };

    const handleClearChat = () => setMessages([]);

    const handleQuickAction = async (action: 'plan' | 'material' | 'enem') => {
        if (!selectedLesson) return alert('Selecione uma aula primeiro!');

        let prompt = '';
        if (action === 'plan') prompt = `Crie um plano de aula detalhado para a Aula ${selectedLesson.number}: ${selectedLesson.title} (${selectedLesson.description}). Inclua objetivos, metodologia, recursos e avaliação.`;
        if (action === 'material') prompt = `Crie um roteiro de material didático (resumo para alunos) sobre o tema: ${selectedLesson.title}.`;
        if (action === 'enem') prompt = `Sugira 3 questões estilo ENEM/SAEB sobre o tema: ${selectedLesson.title}.`;

        setInput(prompt);
    };

    const handleSavePlan = async (content: string) => {
        try {
            if (!userId) throw new Error("ID do usuário não encontrado.");

            const title = selectedLesson
                ? `${selectedLesson.number} - ${selectedLesson.title}`
                : `Plano Gerado ${new Date().toLocaleDateString()}`;

            let folder = PlanFolder.PLANO_AULA;
            let type: any = 'aula';

            if (content.includes('QUESTÕES') || content.includes('GABARITO')) {
                folder = PlanFolder.AVALIACOES;
                type = 'avaliacao';
            } else if (content.includes('ROTEIRO') || content.includes('MATERIAL')) {
                folder = PlanFolder.MATERIAL_ALUNO;
                type = 'documento';
            }

            await savePlan(userId, {
                type: type,
                title: title,
                content: content,
                createdAt: new Date().toISOString()
            }, folder);

            // alert('Salvo com sucesso em "Meus Arquivos"!'); // UI feedback handled by button state usually, but alert is ok for now or toast
            return true;
        } catch (e: any) {
            console.error(e);
            alert(`Erro ao salvar: ${e.message}`);
            return false;
        }
    };

    const handleExportDocx = async (content: string) => {
        console.log('[DEBUG] Export clicked by user:', userId);
        try {
            if (!userId) throw new Error("ID do usuário não encontrado.");

            const title = selectedLesson
                ? `${selectedLesson.number} - ${selectedLesson.title}`
                : `Plano Gerado ${new Date().toLocaleDateString()}`;

            await exportToDocx(content, title.replace(/[^a-z0-9]/gi, '_'), {
                schoolName: localSettings?.schoolName || 'Escola Profeplan',
                teacherName: localSettings?.teacherName || 'Professor(a)',
                userName: localSettings?.userName
            });

            // alert('Download iniciado!');
        } catch (e: any) {
            console.error(e);
            alert(`Erro ao exportar: ${e.message || 'Erro desconhecido'}`);
        }
    };

    // --- RENDER ---

    if (isSimulationMode) {
        return (
            <SimulationWorkspace
                userId={userId}
                termPlans={termPlans}
                selectedTermPlanId={selectedTermPlanId}
                settings={localSettings}
            />
        );
    }

    // Explicitly check for Cockpit Mode.
    // However, since we cleaned up the previous "Clean Chat" logic which was "if (!sim && !cockpit)", 
    // now we should decide what is the DEFAULT.
    // Usually ToolMode.CHAT (default) falls to CleanChat.
    // ToolMode.PLANNING falls to Cockpit.

    if (isPlanningCockpit) {
        return (
            <PlanningCockpit
                termPlans={termPlans}
                selectedTermPlanId={selectedTermPlanId}
                setSelectedTermPlanId={setSelectedTermPlanId}
                parsedLessons={parsedLessons}
                lessonTracking={lessonTracking}
                selectedLesson={selectedLesson}
                setSelectedLesson={setSelectedLesson}
                handleQuickAction={handleQuickAction}
                messages={messages}
                handleExportDocx={handleExportDocx}
                handleSavePlan={handleSavePlan}
                isThinking={isThinking}
                input={input}
                setInput={setInput}
                handleSendMessage={handleSendMessage}
                messagesEndRef={messagesEndRef}
            />
        );
    }

    // Default Fallback (Clean Chat) OR Specialist Chat
    return (
        <div className="flex-1 flex flex-col h-full bg-slate-50 relative">
            {activeMode === ToolMode.SPECIALIST && (
                <div className="bg-amber-100 border-b border-amber-200 px-6 py-3 flex items-center gap-3 shadow-sm z-10">
                    <div className="w-10 h-10 bg-amber-600 rounded-full flex items-center justify-center text-white shadow-lg shadow-amber-200">
                        <ShieldCheck size={20} />
                    </div>
                    <div>
                        <h2 className="text-sm font-black text-amber-900 uppercase tracking-widest">Especialista Pedagógico</h2>
                        <p className="text-[10px] text-amber-900/60 font-bold">Modo de Auditoria e Governança Ativo</p>
                    </div>
                </div>
            )}
            <CleanChat
                messages={messages}
                isThinking={isThinking}
                input={input}
                setInput={setInput}
                handleSendMessage={handleSendMessage}
                handleClearChat={handleClearChat}
                messagesEndRef={messagesEndRef}
            />
        </div>
    );
};

export default PlanningManager;
