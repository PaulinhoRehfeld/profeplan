
import React, { useState, useEffect, useRef } from 'react';
import { useGlobalPlanning } from '../../contexts/GlobalPlanningContext';
import { generateGeminiContent } from '../../services/ai/AiPlanningService';
import { searchCurriculum, getDeterministicCurriculum, searchPnldBookContent } from '../../services/searchService';
import { searchQuestions } from '../../services/questionService';
import { Message, MessageRole, ToolMode } from '../../types';
import { PlanFolder, savePlan, GeneratedPlan } from './PlanningService';
import { Loader2, ShieldCheck } from 'lucide-react';
import { supabase } from '../../services/supabaseClient';

import { addMemory } from '../../services/memoryService'; // Import addMemory
import { feedbackService } from '../../services/feedbackService'; // Feedback Service

// --- NEW SUB-COMPONENTS ---
import { SimulationWorkspace } from './components/SimulationWorkspace';
import { PlanningCockpit } from './components/PlanningCockpit';
import { CleanChat } from './components/CleanChat';
import { getRelevantMemories } from '../../services/memoryService'; // Import Memory Service
import { parseMarkdownToLessons } from '../../utils/markdownParser';

// --- Services ---
import { exportToDocx } from '../../services/exportService';
import { getGeneratedContents } from '../../services/databaseService';

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

    // Feedback Logic
    const [feedbackContext, setFeedbackContext] = useState<string | null>(null);

    // --- Chat State ---
    const [messages, setMessages] = useState<Message[]>([]);
    const [input, setInput] = useState('');
    const [isThinking, setIsThinking] = useState(false);
    const [selectedPnldBookId, setSelectedPnldBookId] = useState<string>('');
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
                    loadLessonTracking(plan.id, plan.lessons);
                }
                // 2. Fallback / Source of Truth: Parse the Text
                else if (plan.generatedText) {
                    console.log("[PlanningManager] Hydrating from Markdown Source");
                    const lessons = parseMarkdownToLessons(plan.generatedText);
                    setParsedLessons(lessons);
                    loadLessonTracking(plan.id, lessons);
                } else {
                    setParsedLessons([]);
                }
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

    const loadLessonTracking = async (planId: string, currentLessons?: Lesson[]) => {
        if (!userId) return;
        const lessonsToCheck = currentLessons || parsedLessons;

        try {
            const contents = await getGeneratedContents(userId);
            const tracking: Record<number, string> = {};

            if (lessonsToCheck && lessonsToCheck.length > 0) {
                lessonsToCheck.forEach(lesson => {
                    // Check for Planos de Aula (type 'plano') matching the lesson number
                    const hasPlan = contents.some((c: any) =>
                        c.type === 'plano' &&
                        (c.title.startsWith(`${lesson.number} -`) || c.title.includes(`Aula ${lesson.number}`))
                    );

                    if (hasPlan) {
                        tracking[lesson.number] = 'prepared';
                    }
                });
            }

            setLessonTracking(tracking);
        } catch (error) {
            console.error("Error loading lesson tracking:", error);
        }
    };

    // --- Handlers ---
    const handleSendMessage = async (e: React.FormEvent, overrideInput?: string) => {
        e.preventDefault();
        // Resolve input priority: Direct Argument > State
        let activeInput = overrideInput || input;

        if (!activeInput.trim()) return;

        // --- FEEDBACK LOOP INTERCEPTION ---
        // Se existe um contexto de feedback pendente, tratamos como solicitação de ajuste
        if (feedbackContext) {
            try {
                // 1. Save Feedback
                await feedbackService.saveFeedback({
                    userId,
                    feature: 'lesson_planning',
                    feedbackText: activeInput,
                    originalContentSummary: feedbackContext.substring(0, 100) + '...'
                });

                // 2. Modify Prompt for Regeneration
                const originalInstruction = activeInput;
                activeInput = `[ATENÇÃO: FEEDBACK DO PROFESSOR (PRIORIDADE CRÍTICA)]
O professor solicitou o seguinte ajuste no plano anterior:
"${originalInstruction}"

INSTRUÇÃO DE REGENERAÇÃO:
Ignore qualquer regra anterior que conflite com este pedido. O feedback do professor é soberano. Recrie o plano incorporando esta mudança imediatamente.`;

                // Reset context loop (so next msg is normal unless we re-trigger)
                setFeedbackContext(null);
            } catch (e) {
                console.error("Feedback error", e);
            }
        }

        const userMsg: Message = { id: Date.now().toString(), role: MessageRole.USER, content: activeInput, timestamp: new Date() };
        setMessages(prev => [...prev, userMsg]);
        setInput('');
        setIsThinking(true);

        try {
            // GOVERNANCE: PEDAGOGICAL SPECIALIST MODE
            if (activeMode === ToolMode.SPECIALIST) {
                const { PlanningAuthority } = await import('../../services/PlanningAuthorityService');
                const response = await PlanningAuthority.askSpecialist(activeInput, { history: [] });
                const aiMsg: Message = { id: (Date.now() + 1).toString(), role: MessageRole.ASSISTANT, content: response, timestamp: new Date() };
                setMessages(prev => [...prev, aiMsg]);
                setIsThinking(false);
                return;
            }

            // --- AUTO-ROUTING TO PLANNING AUTHORITY IF USER ASKS FOR PLANNING (RLM-002) ---
            const lowerInputText = activeInput.toLowerCase();
            const keywordsPlanning = ['planejamento', 'plano', 'gerar', 'trimestre', 'bimestre', 'aula'];
            const isPlanningTask = keywordsPlanning.some(k => lowerInputText.includes(k));

            if (isPlanningTask && (activeMode === ToolMode.QUARTERLY_PLANNING || activeMode === ToolMode.PLANNING)) {
                console.log("👮 RLM ROUTING: Redirecting chat request to PlanningAuthority...");
                const { PlanningAuthority } = await import('../../services/PlanningAuthorityService');

                // Construct intent from current state
                const currentIntent: any = {
                    subject: localSettings.subject || 'História',
                    grade: localSettings.grade || '6º Ano',
                    level: localSettings.level || 'Ensino Fundamental',
                    period: localSettings.quarter ? parseInt(localSettings.quarter) : 1,
                    regime: 'Trimestre',
                    teacherName: localSettings.userName || 'Professor(a)',
                    totalClasses: (localSettings.workloadWeekly || 2) * 12,
                    reserves: localSettings.reserves || { monthlyExam: true, termExam: true, recovery: true },
                    userId: userId,
                    feedback: activeInput, // Prompt becomes the feedback/instruction
                    gradingGrid: localSettings.grading || {},
                    userSettings: appSettings
                };

                try {
                    const response = await PlanningAuthority.executePlanning(currentIntent);
                    const aiMsg: Message = { id: (Date.now() + 1).toString(), role: MessageRole.ASSISTANT, content: response, timestamp: new Date() };
                    setMessages(prev => [...prev, aiMsg]);
                    setIsThinking(false);
                    return;
                } catch (rlmError: any) {
                    console.warn("RLM Block/Error:", rlmError.message);
                }
            }

            // Context Builder
            const selectedPlan = termPlans.find(p => p.id === selectedTermPlanId);
            let context = `Você é um assistente pedagógico especialista.`;

            // --- Contexto de Memória do Professor (Learning) ---
            try {
                const memories = await getRelevantMemories(userId, activeInput);
                if (memories.length > 0) {
                    const memoryText = memories.map(m => `- ${m.content}`).join('\n');
                    context += `\n\n[MEMÓRIA DE PREFERÊNCIAS DO USUÁRIO]:\n${memoryText}\n(Use estas preferências para personalizar o tom e o estilo da resposta.)`;
                }
            } catch (err) {
                console.warn("Failed to fetch memories", err);
            }

            // --- DETERMINISTIC vs RAG ---
            // Se for Planejamento Trimestral, usamos a busca EXATA (Anti-Alucinação)
            const isQuarterlyPlanning = activeMode === ToolMode.QUARTERLY_PLANNING || (activeMode === ToolMode.PLANNING && activeInput.toLowerCase().includes('trimestral'));

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
                const retrievalResults = await searchCurriculum(activeInput, {
                    disciplina: selectedPlan?.subject,
                    ano: selectedPlan?.grade
                }) as any[];

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
            if (activeInput.includes('[AÇÃO: LISTA DE EXERCÍCIOS]') && selectedLesson) {
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

                    const dbQuestions = await searchQuestions(selectedLesson.title, [area]);

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

                        context += `\n\n[BANCO DE QUESTÕES VIA RAG - USE ESTAS QUESTÕES]:\n${questionsText}\n\n[INSTRUÇÃO RAG]: Encontrei ${dbQuestions.length} questões no banco de dados. Use OBRIGATORIAMENTE essas questões. Somente se o usuário solicitou mais do que ${dbQuestions.length}, crie questões inéditas para completar.`;
                    } else {
                        context += `\n\n[BANCO DE QUESTÕES]: Nenhuma questão exata encontrada no banco para este tema. Crie questões inéditas baseadas no currículo.`;
                    }
                } catch (ragError) {
                    console.error('[RAG] Falha ao buscar questões:', ragError);
                }
            }

            // --- RAG: PROJETO CODEX (PNLD BOOKS) ---
            if (selectedPnldBookId) {
                try {
                    const bookResults = await searchPnldBookContent(activeInput, {
                        livro_titulo: selectedPnldBookId // We use ID as title for now or match properly
                    });

                    if (bookResults && bookResults.length > 0) {
                        const bookContext = bookResults.map((r: any) =>
                            `[Livro PNLD: ${r.metadata?.livro_titulo}] [Pág: ${r.metadata?.pagina}] [Cap: ${r.metadata?.capitulo}]: ${r.content}`
                        ).join('\n\n');

                        context += `\n\n--- CONTEÚDO DO LIVRO PNLD (PROJETO CODEX) ---\n${bookContext}\n\n[INSTRUÇÃO PNLD]: O professor está usando o livro oficial. Use os fragmentos acima para basear suas explicações, exercícios e referências de página. SEJA PRECISO.`;
                    }
                } catch (codexError) {
                    console.error('[Codex] Falha ao buscar conteúdo do livro:', codexError);
                }
            }

            // --- Dynamic Temperature Control ---
            // User Request: "PRÁTICAS DE LINGUAGEM HABILIDADE... temperatura precisa ser zero"
            // Heuristic: If prompt contains keywords indicating factual curriculum retrieval, drop temp to 0.
            // Heuristic: If prompt contains keywords indicating factual curriculum retrieval, drop temp to 0.
            const keywordsStrict = ['habilidade', 'bncc', 'objeto de conhecimento', 'práticas de linguagem', 'descritor', 'saeb', 'código', 'planejamento trimestral'];
            const isStrictQuery = keywordsStrict.some(k => activeInput.toLowerCase().includes(k.toLowerCase())) || isQuarterlyPlanning;

            const dynamicTemp = isStrictQuery ? 0.1 : 0.7;

            const response = await generateGeminiContent(activeInput, [], context, userId, dynamicTemp);


            // --- AUTO-PERSISTENCE & MEMORY ---
            // Detect if response looks like a plan, material, or exam
            const upperResponse = response.toUpperCase();
            let type: GeneratedPlan['type'] = 'documento';
            let folder = PlanFolder.MATERIAL_ALUNO; // Default fallback
            let title = `Conteúdo Gerado ${new Date().toLocaleTimeString()}`;

            if (upperResponse.includes('[AÇÃO: PLANO DE AULA DETALHADO]') || upperResponse.includes('PLANO DE AULA')) {
                type = 'plano'; folder = PlanFolder.PLANO_AULA;
                title = selectedLesson ? `Plano - Aula ${selectedLesson.number}` : 'Plano de Aula';
            }
            else if (upperResponse.includes('[AÇÃO: MATERIAL DIDÁTICO]') || upperResponse.includes('ROTEIRO DE ESTUDO') || upperResponse.includes('MATERIAL DO ALUNO')) {
                type = 'material'; folder = PlanFolder.MATERIAL_ALUNO;
                title = selectedLesson ? `Material - Aula ${selectedLesson.number}` : 'Material Didático';
            }
            else if (upperResponse.includes('[AÇÃO: LISTA DE EXERCÍCIOS]') || upperResponse.includes('QUESTÕES') || upperResponse.includes('EXERCÍCIOS') || upperResponse.includes('ATIVIDADE')) {
                type = 'exercicio'; folder = PlanFolder.ATIVIDADES;
                title = selectedLesson ? `Exercícios - Aula ${selectedLesson.number}` : 'Lista de Exercícios';
            }

            if (type !== 'documento' || upperResponse.includes('# ')) {
                // Support quick action [TYPE:] tags in input for better accuracy
                if (type === 'documento' && activeInput.includes('[TYPE:')) {
                    if (activeInput.includes('MATERIAL')) { type = 'material'; folder = PlanFolder.MATERIAL_ALUNO; }
                    if (activeInput.includes('EXERCISES')) { type = 'exercicio'; folder = PlanFolder.ATIVIDADES; }
                }

                // 2. Save to Drive (Async) with tracking
                console.log(`[Drive] Iniciando salvamento automático: ${title} (${type})`);
                savePlan(userId, {
                    type,
                    title,
                    content: response,
                    createdAt: new Date().toISOString()
                }, folder)
                    .then(() => console.log('✅ Conteúdo salvo no Drive com sucesso!'))
                    .catch(e => console.error('❌ Falha no salvamento automático:', e));

                // 3. Save to Memory (Async) - Context for AI
                addMemory(userId, `Gerou ${title}: ${activeInput.substring(0, 100)}...`, [type, 'auto-generated'])
                    .then(() => console.log('🧠 Memória pedagógica atualizada.'))
                    .catch(e => console.error('Memory failed', e));
            }

            const aiMsg: Message = { id: (Date.now() + 1).toString(), role: MessageRole.ASSISTANT, content: response, timestamp: new Date() };
            setMessages(prev => [...prev, aiMsg]);

            // --- AUTO PROMPT FOR FEEDBACK ---
            // If response is substantial (Plan/Content), trigger the feedback loop
            if (response.length > 200 && !feedbackContext) {
                setTimeout(() => {
                    const followUp: Message = {
                        id: (Date.now() + 2).toString(),
                        role: MessageRole.ASSISTANT,
                        content: "Existem ajustes a serem feitos, professor?",
                        timestamp: new Date()
                    };
                    setMessages(prev => [...prev, followUp]);
                    setFeedbackContext(response); // Mark context for next user input
                }, 1000);
            }
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
        if (action === 'material') prompt = `[TYPE: MATERIAL]\nCrie um roteiro de material didático (resumo para alunos) sobre o tema: ${selectedLesson.title}.`;
        if (action === 'enem') prompt = `[TYPE: EXERCISES]\nCrie uma lista de exercícios de fixação sobre o tema: ${selectedLesson.title}.`;

        setInput(prompt);
    };

    const handleSavePlan = async (content: string) => {
        try {
            if (!userId) throw new Error("ID do usuário não encontrado.");

            const title = selectedLesson
                ? `${selectedLesson.number} - ${selectedLesson.title}`
                : `Plano Gerado ${new Date().toLocaleDateString()}`;

            let folder = PlanFolder.PLANO_AULA;
            let type: GeneratedPlan['type'] = 'plano'; // Default to 'plano' (Planos de Aula)

            const upperContent = content.toUpperCase();

            // 1. Explicit Tag Detection (Highest Priority)
            if (upperContent.includes('[TYPE: EXERCISES]')) {
                folder = PlanFolder.ATIVIDADES;
                type = 'exercicio';
            } else if (upperContent.includes('[TYPE: MATERIAL]')) {
                folder = PlanFolder.MATERIAL_ALUNO;
                type = 'material';
            }
            // 2. Keyword Fallback (Case Insensitive)
            else if (upperContent.includes('QUESTÕES') || upperContent.includes('GABARITO') || upperContent.includes('EXERCÍCIOS') || upperContent.includes('LISTA')) {
                folder = PlanFolder.ATIVIDADES;
                type = 'exercicio';
            } else if (upperContent.includes('ROTEIRO') || upperContent.includes('MATERIAL') || upperContent.includes('RESUMO')) {
                folder = PlanFolder.MATERIAL_ALUNO;
                type = 'material';
            }

            await savePlan(userId, {
                type: type,
                title: title,
                content: content,
                createdAt: new Date().toISOString()
            }, folder);

            // alert('Salvo com sucesso em "Meus Arquivos"!'); // UI feedback handled by button state usually, but alert is ok for now or toast
            // Refresh tracking to update UI (strikethrough and count)
            if (selectedTermPlanId) {
                await loadLessonTracking(selectedTermPlanId);
            }

            return true;
        } catch (e: any) {
            console.error(e);
            if (e.message) alert(`Erro ao salvar: ${e.message}`);
            else alert("Erro ao salvar: Ocorreu um problema desconhecido.");
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
                userId={userId} // Pass userId
                handleExportDocx={handleExportDocx}
                handleSavePlan={handleSavePlan}
                isThinking={isThinking}
                input={input}
                setInput={setInput}
                handleSendMessage={handleSendMessage}
                messagesEndRef={messagesEndRef}
                selectedPnldBookId={selectedPnldBookId}
                setSelectedPnldBookId={setSelectedPnldBookId}
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
