import React, { useState, useEffect, useRef } from 'react';
import { supabase } from '../../services/supabaseClient'; // Added Supabase Import
import { AssistantStatus, GuardContext, analisarPositivo, searchLocalPlans } from '../../utils/chatGuardUtils';
import { Send, Image as ImageIcon, Loader2, Bot, User, Trash2, X, Download, Wand2, Book, FileText, LayoutList, Search, ChevronRight, CheckCircle2, RefreshCw, ArrowUpDown, Copy } from 'lucide-react'; // Added Icons
import { generateProfePlanStream, generateCanvaData } from '../../services/geminiService'; // Added generateCanvaData
import { savePlan, PlanFolder } from './PlanningService';
import { ToolMode, Message, MessageRole, UserSettings } from '../../types'; // Added UserSettings
import { exportToDocx, exportSimuladoToDocx } from '../../services/exportService'; // Added Export
import { saveLessonToMemory } from '../../services/supabaseService'; // Added Memory Save
import { fetchTermPlans } from '../TermPlanning/TermPlanningService'; // Import Fetch
import { hybridSearchProfeplan } from '../../services/searchService'; // Search Service
import { TermPlan } from '../../contexts/GlobalPlanningContext';

interface Question {
    id: string; // or number, depends on DB. Assuming string for safety or UUID.
    metadata: {
        id: string;
        origem?: string;
        ano?: string;
        disciplina?: string;
        assunto?: string;
        enunciado?: string;
        gabarito?: string;
        habilidade_bncc?: string;
    }
    content: string; // The full text? Often 'content' in vector stores.
    similarity?: number;
}

interface PlanningManagerProps {
    userId: string;
    activeMode: ToolMode;
    availableClasses: any[];
    settings: any;
    selectedClassId: string;
    quarter?: string;
    enemArea?: string;
    setSidebarContent?: (content: React.ReactNode) => void; // New Prop
}

interface ParsedLesson {
    number: number;
    title: string;
    content: string;
}

const PlanningManager: React.FC<PlanningManagerProps> = ({
    userId, activeMode, availableClasses, settings, selectedClassId, quarter, enemArea, setSidebarContent
}) => {
    const [messages, setMessages] = useState<Message[]>([]);
    const [input, setInput] = useState('');
    const [isThinking, setIsThinking] = useState(false);
    const [selectedImage, setSelectedImage] = useState<{ data: string; type: string } | null>(null);
    const messagesEndRef = useRef<HTMLDivElement>(null);

    // Context & Term Plan State

    const [termPlans, setTermPlans] = useState<TermPlan[]>([]);
    const [selectedTermPlanId, setSelectedTermPlanId] = useState<string>('');
    const [parsedLessons, setParsedLessons] = useState<ParsedLesson[]>([]);
    const [selectedLesson, setSelectedLesson] = useState<ParsedLesson | null>(null);
    const [lessonTracking, setLessonTracking] = useState<Record<number, string>>({}); // { 1: 'prepared' }

    // --- Simulation Mode State ---
    const [simMode, setSimMode] = useState<'manual' | 'mirror'>('manual');
    const [simSearchQuery, setSimSearchQuery] = useState('');
    const [simSearchResults, setSimSearchResults] = useState<any[]>([]); // Using any for now to match RPC result
    const [simCart, setSimCart] = useState<any[]>([]);
    const [simLoading, setSimLoading] = useState(false);
    const [simObservations, setSimObservations] = useState(''); // Header instructions

    // --- Simulation Handlers ---
    const handleSimSearch = async () => {
        if (!simSearchQuery.trim()) return;
        setSimLoading(true);
        try {
            const { hybridSearchProfeplan } = await import('../../services/searchService');
            const results = await hybridSearchProfeplan({
                textoBusca: simSearchQuery,
                limit: 12,
                matchThreshold: 0.4
            });
            setSimSearchResults(results || []);
        } catch (e) {
            console.error(e);
        } finally {
            setSimLoading(false);
        }
    };

    const handleMirrorSearch = async () => {
        const plan = termPlans.find(p => p.id === selectedTermPlanId);
        if (!plan) {
            alert('Selecione um Planejamento Trimestral no topo primeiro!');
            return;
        }
        setSimLoading(true);
        try {
            const query = `Questões de ${plan.subject} sobre ${plan.grade} ${plan.period}º ${plan.regime}. Tópicos: ${plan.generatedText?.slice(0, 200) || ''}`;
            setSimSearchQuery(query);
            const { hybridSearchProfeplan } = await import('../../services/searchService');
            const results = await hybridSearchProfeplan({
                textoBusca: query,
                disciplina: plan.subject,
                limit: 15,
                matchThreshold: 0.5
            });
            setSimSearchResults(results || []);
        } catch (e) {
            console.error(e);
        } finally {
            setSimLoading(false);
        }
    };

    const handleAddToCart = (question: any) => {
        if (!simCart.find(q => q.id === question.id)) {
            setSimCart(prev => [...prev, question]);
        }
    };

    const handleRemoveFromCart = (id: any) => {
        setSimCart(prev => prev.filter(q => q.id !== id));
    };

    const handleSimAction = async (action: 'balance' | 'export_pdf' | 'export_word' | 'generate_ab') => {
        if (simCart.length === 0) return alert('Selecione questões primeiro!');

        if (action === 'balance') {
            const prompt = `Analise este simulado com ${simCart.length} questões. IDs: ${simCart.map(q => q.id).join(', ')}. Conteúdo: ${simCart.map(q => q.content).join(' || ')}.\n\nVerifique o equilíbrio de dificuldade e distribuição de temas. Sugira melhorias.`;
            await processAiResponse(prompt, "Análise de Equilíbrio - Simulado");
        } else if (action === 'export_word') {
            try {
                const title = `Simulado_${new Date().toLocaleDateString('pt-BR')}`;
                const contentSummary = simCart.map(q => q.content).join('\n---\n');

                await savePlan(userId, {
                    type: 'avaliacao',
                    title: title,
                    content: contentSummary,
                    createdAt: new Date().toISOString(),
                }, PlanFolder.SIMULADOS);

                const { exportSimuladoToDocx } = await import('../../services/exportService');
                await exportSimuladoToDocx(simCart, simObservations, 'Versão Única', settings);
            } catch (e: any) {
                alert(`Erro: ${e.message}`);
            }
        } else if (action === 'generate_ab') {
            try {
                const title = `Simulado_AB_${new Date().toLocaleDateString('pt-BR')}`;
                const contentSummary = `Geração A/B com ${simCart.length} questões.`;

                await savePlan(userId, {
                    type: 'avaliacao',
                    title: title,
                    content: contentSummary,
                    createdAt: new Date().toISOString(),
                }, PlanFolder.SIMULADOS);

                const { exportSimuladoToDocx } = await import('../../services/exportService');
                await exportSimuladoToDocx(simCart, simObservations, 'Versão A', settings);

                const shuffled = [...simCart].sort(() => Math.random() - 0.5);
                setTimeout(async () => {
                    await exportSimuladoToDocx(shuffled, simObservations, 'Versão B', settings);
                }, 1000);
            } catch (e: any) {
                alert(`Erro: ${e.message}`);
            }
        }
    };

    // --- Folder Routing Logic ---
    const determineFolder = (mode: ToolMode): PlanFolder => {
        switch (mode) {
            case ToolMode.PLANNING: return PlanFolder.PLANO_AULA;
            case ToolMode.QUARTERLY_PLANNING: return PlanFolder.PLANEJAMENTO_TRI_BI;
            case ToolMode.ACTIVITIES: return PlanFolder.MATERIAL_ALUNO;
            case ToolMode.SIMULATION: return PlanFolder.SIMULADOS;
            case ToolMode.ENEM_BANK: return PlanFolder.AVALIACOES;
            default: return PlanFolder.MATERIAL_ALUNO;
        }
    };

    const handleExportDocx = async (specificContent?: string) => {
        // Use provided content OR find the last assistant message
        const contentToSave = specificContent || [...messages].reverse().find(m => m.role === MessageRole.ASSISTANT)?.content;

        if (!contentToSave) return;

        const plan = termPlans.find(p => p.id === selectedTermPlanId);
        const subject = plan ? plan.subject : 'Doc';
        const title = `PROFEPLAN_${subject}_${new Date().toLocaleDateString('pt-BR').replace(/\//g, '-')}`;

        // 1. CREDIT CHECK & SAVE (The Transaction)
        try {
            const folder = determineFolder(activeMode);
            // Construct plan object for saving
            const planToSave = {
                type: mapModeToType(activeMode),
                title: title,
                content: contentToSave,
                createdAt: new Date().toISOString(),
                // folder: folder // REMOVED
            };

            await savePlan(userId, planToSave, folder); // This deducts credit!

            // 2. TRACKING UPDATE (New)
            if (selectedLesson && selectedTermPlanId) {
                try {
                    const { updateLessonTracking } = await import('../../services/supabaseService');
                    await updateLessonTracking(userId, selectedTermPlanId, selectedLesson.number, 'prepared');

                    // Optimistic UI Update
                    setLessonTracking(prev => ({ ...prev, [selectedLesson.number]: 'prepared' }));
                } catch (trackError) {
                    console.warn("Failed to update tracking", trackError);
                }
            }

            // 3. GENERATE DOCUMENT
            await exportToDocx(contentToSave, title, settings);

            // Feedback
            setMessages(prev => [...prev, {
                id: Date.now().toString(),
                role: MessageRole.ASSISTANT,
                content: "✅ **Documento Salvo, Exportado e Marcado como Feito!** (1 Crédito Descontado)",
                timestamp: new Date()
            }]);

        } catch (error: any) {
            alert(`Erro ao salvar: ${error.message}`);
            return; // Stop export
        }
    };

    // Load Term Plans on Mount
    useEffect(() => {
        const loadPlans = async () => {
            const plans = await fetchTermPlans(userId);
            setTermPlans(plans);
        };
        loadPlans();
    }, [userId]);

    // Fetch Tracking when ID changes
    useEffect(() => {
        if (!selectedTermPlanId) {
            setLessonTracking({});
            return;
        }

        const fetchStatus = async () => {
            try {
                const { getLessonTracking } = await import('../../services/supabaseService');
                const { data } = await getLessonTracking(selectedTermPlanId);
                if (data) {
                    const map: Record<number, string> = {};
                    data.forEach((item: any) => {
                        map[item.lesson_index] = item.status;
                    });
                    setLessonTracking(map);
                }
            } catch (e) {
                console.error("Tracking fetch error:", e);
            }
        };

        fetchStatus();
    }, [selectedTermPlanId]);

    // Parse Lessons when Plan Selected
    useEffect(() => {
        if (!selectedTermPlanId) {
            setParsedLessons([]);
            return;
        }
        const plan = termPlans.find(p => p.id === selectedTermPlanId);
        if (!plan?.generatedText) return;

        // Regex Otimizado (v3) para capturar variações:
        // - "Aula 1", "Aula 01", "Encontro 1", "Semana 1", "Atividade 1"
        // - Com ou sem negrito (**Aula 1**)
        // - Com ou sem marcadores (•, -, 1., *) e espaços extras
        const regex = /(?:^|[\n\r])(?:[•\-\*\d\.]+)?\s*(?:\*\*)?(?:Aula|Encontro|Semana|Atividade)(?:\*\*)?\s*(\d+)[\.:\)\s-]*(.*?)(?=$|[\n\r]|$)/gim;

        const matches = [...plan.generatedText.matchAll(regex)];

        if (matches.length === 0) {
            console.warn("Nenhuma aula encontrada com o regex atual no plano:", plan.id);
        }

        const lessons: ParsedLesson[] = matches.map(m => {
            // Limpeza extra no título (remove markdown residual, datas, etc)
            let rawTitle = m[2].trim();
            // Remove negrito fechando se houver
            rawTitle = rawTitle.replace(/\*\*$/, '').trim();
            // Remove datas comuns no formato (dd/mm) se tiver
            rawTitle = rawTitle.replace(/\([\d\/]+\)$/, '').trim();

            return {
                number: parseInt(m[1]),
                title: rawTitle,
                content: m[0].trim() // Contexto completo (linha inteira)
            };
        });

        setParsedLessons(lessons);
    }, [selectedTermPlanId, termPlans]);





    // --- Sidebar Effect (Actions Portal) ---
    useEffect(() => {
        if (!setSidebarContent) return;

        const sidebar = (
            <div className="space-y-6 animate-in slide-in-from-right duration-500">
                <div>
                    <h3 className="font-black text-[10px] uppercase tracking-[0.2em] text-slate-400 italic mb-4">Ações Pedagógicas</h3>
                    <div className="grid grid-cols-1 gap-3">
                        <button
                            onClick={() => handleQuickAction('plan')}
                            className="bg-white border border-slate-200 text-slate-600 hover:border-indigo-500 hover:bg-indigo-50 hover:text-indigo-700 py-2 px-3 rounded-xl flex items-center gap-3 transition-all shadow-sm group"
                        >
                            <div className="p-2 bg-indigo-100 text-indigo-600 rounded-lg group-hover:bg-indigo-600 group-hover:text-white transition-colors">
                                <Book size={18} />
                            </div>
                            <span className="text-xs font-bold uppercase tracking-wide">Planejar Aula</span>
                        </button>
                        <button
                            onClick={() => handleQuickAction('material')}
                            className="bg-white border border-slate-200 text-slate-600 hover:border-emerald-500 hover:bg-emerald-50 hover:text-emerald-700 py-2 px-3 rounded-xl flex items-center gap-3 transition-all shadow-sm group"
                        >
                            <div className="p-2 bg-emerald-100 text-emerald-600 rounded-lg group-hover:bg-emerald-600 group-hover:text-white transition-colors">
                                <FileText size={18} />
                            </div>
                            <span className="text-xs font-bold uppercase tracking-wide">Material Aluno</span>
                        </button>
                        <button
                            onClick={() => handleQuickAction('enem')}
                            className="bg-white border border-slate-200 text-slate-600 hover:border-amber-500 hover:bg-amber-50 hover:text-amber-700 py-2 px-3 rounded-xl flex items-center gap-3 transition-all shadow-sm group"
                        >
                            <div className="p-2 bg-amber-100 text-amber-600 rounded-lg group-hover:bg-amber-600 group-hover:text-white transition-colors">
                                <Search size={18} />
                            </div>
                            <span className="text-xs font-bold uppercase tracking-wide">Questões ENEM</span>
                        </button>
                    </div>
                </div>

                <div className="pt-6 border-t border-slate-100">
                    <p className="text-[10px] text-slate-400 text-center italic">
                        Selecione as ações acima para gerar conteúdo.
                        <br />
                        Utilize o chat abaixo para refinar.
                        <br />
                        Utilize o botão "Salvar" na mensagem gerada.
                    </p>
                </div>
            </div>
        );

        setSidebarContent(sidebar);
        return () => setSidebarContent(null);
    }, [setSidebarContent, selectedLesson]);

    // Carregar histórico local ao iniciar
    useEffect(() => {
        const saved = localStorage.getItem(`profeplan_chat_${userId}`);
        if (saved) {
            try {
                const parsed = JSON.parse(saved);
                // Converter strings de data de volta para objetos Date
                setMessages(parsed.map((m: any) => ({ ...m, timestamp: new Date(m.timestamp) })));
            } catch (e) {
                console.error('Erro ao carregar chat local:', e);
            }
        }
    }, [userId]);

    // Salvar histórico local sempre que mudar
    useEffect(() => {
        if (messages.length > 0) {
            localStorage.setItem(`profeplan_chat_${userId}`, JSON.stringify(messages));
        }
    }, [messages, userId]);

    // Auto-scroll
    useEffect(() => {
        messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    }, [messages, isThinking]);

    const handleClearChat = () => {
        if (confirm('Limpar histórico do chat?')) {
            setMessages([]);
            setMessages([]);
            // localStorage.removeItem(`profeplan_chat_${userId}`); // Optional: decide if clear also deletes local storage immediately or just state. keeping behavior.
            localStorage.removeItem(`profeplan_chat_${userId}`);
        }
    };

    const handleImageUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (file) {
            const reader = new FileReader();
            reader.onloadend = () => {
                setSelectedImage({ data: reader.result as string, type: file.type });
            };
            reader.readAsDataURL(file);
        }
    };

    const mapModeToType = (mode: ToolMode): 'plano' | 'aula' | 'avaliacao' | 'documento' | 'trimestral' | 'enem' => {
        switch (mode) {
            case ToolMode.PLANNING: return 'plano';
            case ToolMode.QUARTERLY_PLANNING: return 'trimestral';
            case ToolMode.ACTIVITIES: return 'aula';
            case ToolMode.SIMULATION: return 'avaliacao';
            case ToolMode.ENEM_BANK: return 'enem';
            default: return 'documento';
        }
    };

    // --- GUARD STATE MACHINE ---
    const [guardContext, setGuardContext] = useState<GuardContext>({ status: 'IDLE' });

    // --- HANDLERS DA MÁQUINA DE ESTADOS ---

    const handleConfirm = async (overrideText?: string) => {
        const confirmText = overrideText || "Sim, pode seguir com este planejamento.";
        const userMsg: Message = { id: Date.now().toString(), role: MessageRole.USER, content: confirmText, timestamp: new Date() };
        setMessages(prev => [...prev, userMsg]);
        setInput('');
        setGuardContext(prev => ({ ...prev, status: 'PROCESSANDO' }));
        setIsThinking(true);

        const plan = guardContext.foundPlan;
        let contextPrompt = confirmText;

        if (plan) {
            contextPrompt += `\n\n[CONTEXTO CONFIRMADO]: O usuário confirmou o uso do seguinte planejamento:\n` +
                `ID: ${plan.id}\nDisciplina: ${plan.subject}\nSérie: ${plan.grade}\nPeríodo: ${plan.period}º ${plan.regime}\n` +
                `Conteúdo Gerado Anteriormente: ${plan.generatedText?.slice(0, 2000)}...`;
        }

        await processAiResponse(contextPrompt, guardContext.originalIntent || confirmText);
        setGuardContext({ status: 'IDLE' });
    };

    const handleReject = async (overrideText?: string) => {
        const rejectText = overrideText || "Não, buscar outro.";
        const userMsg: Message = { id: Date.now().toString(), role: MessageRole.USER, content: rejectText, timestamp: new Date() };
        setMessages(prev => [...prev, userMsg]);
        setInput('');
        setGuardContext({ status: 'IDLE' });
        setIsThinking(true);

        await processAiResponse(rejectText);
    };

    const processAiResponse = async (promptToSend: string, originalIntentForHistory?: string) => {
        try {
            let historyParams = messages.slice(-10);
            if (historyParams.length > 0 && historyParams[0].role === MessageRole.ASSISTANT) {
                historyParams = historyParams.slice(1);
            }
            const history = historyParams.map(m => ({
                role: m.role === MessageRole.USER ? 'user' : 'model',
                parts: [{ text: m.content }]
            }));

            let finalPrompt = promptToSend;

            // --- CONTEXT INJECTION START ---
            // 1. Global Context (Quarter/Enem)
            if (activeMode === ToolMode.QUARTERLY_PLANNING && quarter && !finalPrompt.includes('[Contexto]')) {
                finalPrompt += `\n[Contexto]: Planejamento para o ${quarter}.`;
            } else if (activeMode === ToolMode.ENEM_BANK && enemArea && !finalPrompt.includes('[Contexto]')) {
                finalPrompt += `\n[Contexto]: Área do Conhecimento: ${enemArea}.`;
            }

            // 2. Class Context
            if (selectedClassId) {
                const cls = availableClasses.find(c => c.id === selectedClassId);
                if (cls && !finalPrompt.includes('[TURMA]')) finalPrompt += `\n[TURMA]: ${cls.name}.`;
            }

            // 3. Plan & Lesson Context (CRITICAL FIX)
            // Only inject if not already present (to avoid duplication with Quick Actions)
            if (!finalPrompt.includes('[PLANEJAMENTO]') && !finalPrompt.includes('[AULA SELECIONADA]')) {
                const planContext = termPlans.find(p => p.id === selectedTermPlanId);

                if (planContext) {
                    finalPrompt += `\n\n[CONTEXTO DO PLANEJAMENTO]:\nDisciplina: ${planContext.subject}\nSérie: ${planContext.grade}\nPeríodo: ${planContext.period}º ${planContext.regime}`;

                    if (selectedLesson) {
                        finalPrompt += `\n\n[AULA SELECIONADA ATUALMENTE]:\nAula Nº: ${selectedLesson.number}\nTítulo: ${selectedLesson.title}\nConteúdo/Resumo: ${selectedLesson.content}`;
                        finalPrompt += `\n\n[INSTRUÇÃO]: O usuário está falando especificamente sobre esta aula acima. Use este contexto para responder.`;
                    }
                }
            }
            // --- CONTEXT INJECTION END ---

            const stream = await generateProfePlanStream(
                finalPrompt,
                history,
                activeMode,
                selectedImage ? { inlineData: { data: selectedImage.data.split(',')[1], mimeType: selectedImage.type } } : undefined,
                undefined,
                settings.access_level || 'free',
                userId
            );

            let fullText = '';
            const aiId = (Date.now() + 1).toString();
            setMessages(prev => [...prev, { id: aiId, role: MessageRole.ASSISTANT, content: '', timestamp: new Date() }]);

            for await (const chunk of stream) {
                fullText += chunk.text || '';
                setMessages(prev => prev.map(m => m.id === aiId ? { ...m, content: fullText } : m));
            }

            // REMOVED AUTOMATIC SAVE - SAVING IS NOW MANUAL AND CREDITED
            // if (fullText.trim().length > 50) {
            //     const type = mapModeToType(activeMode);
            //     const titleBase = originalIntentForHistory || promptToSend;
            //     const finalTitle = `${type.toUpperCase()} - ${titleBase.slice(0, 40)}...`;
            //     await savePlan(userId, { type, title: finalTitle, content: fullText, createdAt: new Date().toISOString() });
            // }

        } catch (err: any) {
            console.error("Erro API:", err);
            setMessages(prev => [...prev, { id: Date.now().toString(), role: MessageRole.ASSISTANT, content: `❌ Erro: ${err.message}`, timestamp: new Date() }]);
        } finally {
            setIsThinking(false);
            if (guardContext.status === 'PROCESSANDO') {
                setGuardContext(prev => ({ ...prev, status: 'IDLE' }));
            }
        }
    }



    const handleSendMessage = async (e: React.FormEvent) => {
        e.preventDefault();
        if ((!input.trim() && !selectedImage)) return;

        // --- DEBUG: RESET DATA ---
        if (input === '/reset') {
            if (!confirm('ATENÇÃO: Isso apagará TODOS os seus dados (Planos, Aulas, Turmas, Histórico). Deseja continuar?')) return;

            setIsThinking(true);
            try {
                // 1. Supabase Cleanup
                await supabase.from('generated_contents').delete().eq('user_id', userId);
                await supabase.from('lessons').delete().eq('user_id', userId);
                await supabase.from('classes').delete().eq('user_id', userId); // Cascades to students
                await supabase.from('term_plans').delete().eq('user_id', userId);
                // await supabase.from('authorized_users').update({ usage_count: 0 }).eq('id', userId); // Optional: Reset Quota

                // 2. Local Cleanup
                localStorage.removeItem(`profeplan_chat_${userId}`);
                localStorage.removeItem('profeplan_history_buffer');

                alert('Dados limpos com sucesso! A página será recarregada.');
                window.location.reload();
            } catch (e: any) {
                alert('Erro ao limpar dados: ' + e.message);
            } finally {
                setIsThinking(false);
            }
            return;
        }

        // --- ESTADO 1: AGUARDANDO CONFIRMAÇÃO ---
        if (guardContext.status === 'AGUARDANDO_CONFIRMACAO') {
            if (analisarPositivo(input)) {
                await handleConfirm(input);
            } else {
                await handleReject(input);
            }
            return;
        }

        // --- ESTADO 2: BUSCA ANTES DE AÇÃO ---
        const currentMsg = input;

        // Verifica gatilhos apenas no modo Chat
        const keywords = ['aula', 'plano', 'bimestre', 'trimestre', 'atividade', 'material'];
        const shouldGuard = activeMode === ToolMode.CHAT && keywords.some(k => currentMsg.toLowerCase().includes(k));

        if (shouldGuard) {
            const found = searchLocalPlans(currentMsg, termPlans);

            if (found) {
                // Adiciona input do usuário
                const userMsg: Message = { id: Date.now().toString(), role: MessageRole.USER, content: currentMsg, timestamp: new Date() };
                setMessages(prev => [...prev, userMsg]);
                setInput('');
                setSelectedImage(null);

                setIsThinking(true);

                setTimeout(() => {
                    setIsThinking(false);
                    const botMsg: Message = {
                        id: Date.now().toString(),
                        role: MessageRole.ASSISTANT,
                        content: `🔎 **Gatilho de Segurança**: Encontrei um planejamento relevante nos seus arquivos.\n\n` +
                            `📄 **${found.subject} - ${found.grade}** (${found.period}º ${found.regime})\n` +
                            `É a partir deste plano que devo gerar o conteúdo?`,
                        timestamp: new Date()
                    };
                    setMessages(prev => [...prev, botMsg]);
                    setGuardContext({
                        status: 'AGUARDANDO_CONFIRMACAO',
                        foundPlan: found,
                        originalIntent: currentMsg
                    });
                }, 600);

                return;
            }
        }

        // --- ESTADO 3: FLUXO NORMAL ---
        const userMsg: Message = { id: Date.now().toString(), role: MessageRole.USER, content: currentMsg, timestamp: new Date() };
        setMessages(prev => [...prev, userMsg]);
        setInput('');
        setSelectedImage(null);
        setIsThinking(true);

        await processAiResponse(currentMsg);
    };



    // --- COCKPIT HANDLERS ---

    // Triggered by the 3 Center Buttons
    const handleQuickAction = async (actionType: 'plan' | 'material' | 'enem') => {
        if (!selectedLesson) {
            // Simple alert or toast could go here. For now, using a temporary assistant message is safer/easier to see.
            setMessages(prev => [...prev, {
                id: Date.now().toString(),
                role: MessageRole.ASSISTANT,
                content: "⚠️ **Atenção**: Por favor, selecione uma **Aula** na lista à direita antes de executar uma ação.",
                timestamp: new Date()
            }]);
            return;
        }

        const actionPrompt = input.trim(); // The "Observações"
        let promptBase = '';
        let targetMode = activeMode;

        const lessonContext = `[AULA SELECIONADA]: ${selectedLesson.number} - ${selectedLesson.title}\n${selectedLesson.content ? `[CONTEÚDO ORIGINAL]: ${selectedLesson.content.slice(0, 500)}...` : ''}`;
        const planContext = termPlans.find(p => p.id === selectedTermPlanId);
        const globalContext = planContext ? `[PLANEJAMENTO]: ${planContext.subject} (${planContext.grade}) - ${planContext.period}º ${planContext.regime}` : '';
        const userObs = actionPrompt ? `[OBSERVAÇÕES DO PROFESSOR]: ${actionPrompt}` : '';

        // Define intent based on button
        switch (actionType) {
            case 'plan':
                promptBase = `🎯 **AÇÃO: PLANEJAR AULA**\n${globalContext}\n${lessonContext}\n${userObs}\n\nOBJETIVO: Gerar o roteiro detalhado desta aula (Objetivos, Metodologia, Cronograma, Recursos).`;
                // activeMode remains PLANNING or similar
                break;
            case 'material':
                promptBase = `📚 **AÇÃO: MATERIAL DO ALUNO**\n${globalContext}\n${lessonContext}\n${userObs}\n\nOBJETIVO: Criar material didático de apoio (folha de leitura, exercícios de fixação) para o estudante.`;
                targetMode = ToolMode.ACTIVITIES; // Switch mode context internally if needed, or just prompt engineering
                break;
            case 'enem':
                promptBase = `🎓 **AÇÃO: BUSCA ENEM/SAEB**\n${globalContext}\n${lessonContext}\n${userObs}\n\nOBJETIVO: Encontrar/Criar questões alinhadas a esta aula seguindo a matriz de referência.`;
                targetMode = ToolMode.ENEM_BANK;
                break;
        }

        // Execute
        const userMsg: Message = { id: Date.now().toString(), role: MessageRole.USER, content: `[${actionType.toUpperCase()}] ${selectedLesson.title}`, timestamp: new Date() };
        setMessages(prev => [...prev, userMsg]);
        setInput(''); // Clear observations
        setIsThinking(true);

        await processAiResponse(promptBase, `Action: ${actionType} - ${selectedLesson.title}`);
    };




    // --- RENDER ---
    // --- RENDER ---

    // Check if we should use Cockpit (Planning/Activities/Enem) or Clean Chat (Assistant/Home)
    const isSimulationMode = activeMode === ToolMode.SIMULATION;
    const isPlanningCockpit = [ToolMode.PLANNING, ToolMode.ACTIVITIES, ToolMode.ENEM_BANK].includes(activeMode);

    // 1. CLEAN CHAT (Assistant/Home)
    if (!isSimulationMode && !isPlanningCockpit) {
        // --- CLEAN CHAT UI (For Assistant/Home) ---
        return (
            <div className="flex-1 flex flex-col h-full relative bg-slate-50/50">
                <div className="flex-1 overflow-y-auto px-4 md:px-10 py-4 custom-scrollbar space-y-4 scroll-smooth">
                    {messages.length === 0 && (
                        <div className="flex flex-col items-center justify-center h-full opacity-30 select-none pointer-events-none">
                            <div className="w-20 h-20 bg-indigo-100 rounded-full flex items-center justify-center mb-6 animate-in zoom-in duration-500">
                                <Bot size={40} className="text-indigo-500" />
                            </div>
                            <h2 className="text-2xl font-bold text-slate-700 mb-2">Olá, Professor(a)</h2>
                            <p className="text-sm font-medium text-slate-400 text-center max-w-md leading-relaxed">
                                Sou seu assistente pedagógico. Posso ajudar com dúvidas rápidas, ideias de projetos ou correções.
                                <br /><span className="text-xs uppercase tracking-wide opacity-70 mt-2 block">Para planos completos, use o menu "Plano de Aula".</span>
                            </p>
                        </div>
                    )}
                    {messages.map((msg) => (
                        <div key={msg.id} className={`flex gap-4 ${msg.role === MessageRole.USER ? 'flex-row-reverse' : ''} animate-in fade-in slide-in-from-bottom-2 duration-300`}>
                            <div className={`w-10 h-10 rounded-2xl flex items-center justify-center shrink-0 shadow-lg ${msg.role === MessageRole.USER ? 'bg-indigo-600 text-white' : 'bg-white text-emerald-600 border border-emerald-100'}`}>
                                {msg.role === MessageRole.USER ? <User size={18} /> : <Bot size={18} />}
                            </div>
                            <div className={`max-w-[85%] p-4 rounded-[2rem] shadow-sm text-sm leading-relaxed whitespace-pre-wrap ${msg.role === MessageRole.USER ? 'bg-indigo-600 text-white rounded-tr-none' : 'bg-white border border-slate-100 text-slate-700 rounded-tl-none'}`}>
                                {msg.content}
                            </div>
                        </div>
                    ))}
                    {isThinking && (
                        <div className="flex gap-4 animate-pulse">
                            <div className="w-10 h-10 rounded-2xl bg-white border border-emerald-100 flex items-center justify-center shrink-0 shadow-sm">
                                <Loader2 className="w-5 h-5 animate-spin text-emerald-500" />
                            </div>
                            <div className="p-4 rounded-[2rem] bg-white/50 border border-slate-100 text-xs font-bold text-slate-400 uppercase tracking-widest flex items-center gap-2">Gemini está pensando...</div>
                        </div>
                    )}
                    <div ref={messagesEndRef} />
                </div>

                {/* Clean Input Area */}
                <div className="p-3 md:p-4 pb-[calc(1rem+env(safe-area-inset-bottom))] bg-white/80 backdrop-blur-md border-t border-slate-100 z-10 sticky bottom-0">
                    <form onSubmit={handleSendMessage} className="max-w-4xl mx-auto relative group">
                        <div className="relative flex items-end gap-2 bg-white rounded-[2rem] p-2 shadow-lg border border-slate-100 focus-within:ring-2 focus-within:ring-blue-100 transition-all">
                            <textarea
                                value={input}
                                onChange={(e) => setInput(e.target.value)}
                                onKeyDown={(e) => {
                                    if (e.key === 'Enter' && !e.shiftKey) {
                                        e.preventDefault();
                                        handleSendMessage(e);
                                    }
                                }}
                                placeholder="Digite sua dúvida ou solicitação pedagógica..."
                                className="flex-1 bg-transparent border-none focus:ring-0 text-slate-700 placeholder:text-slate-400 font-medium py-3 max-h-32 resize-none custom-scrollbar text-base md:text-sm"
                                rows={1}
                            />
                            <button type="submit" disabled={!input.trim() || isThinking} className="p-3 bg-indigo-600 text-white rounded-full hover:bg-indigo-700 disabled:opacity-50 transition-all active:scale-95">
                                {isThinking ? <Loader2 className="animate-spin" size={20} /> : <Send size={20} />}
                            </button>
                        </div>
                    </form>
                    {messages.length > 0 && (
                        <button onClick={handleClearChat} className="absolute top-4 right-4 text-[9px] font-bold text-slate-300 hover:text-red-400 uppercase tracking-widest flex items-center gap-1">
                            <Trash2 size={12} /> Limpar
                        </button>
                    )}
                </div>
            </div>
        );
    }

    // 2. SIMULATION MODE (Factory of Assessments)
    if (isSimulationMode) {
        return (
            <div className="flex flex-col h-[100dvh] bg-slate-50 relative overflow-hidden">
                {/* Top: Sim History (Placeholder) */}
                <div className="h-20 bg-white border-b border-slate-200 flex items-center px-6 gap-4">
                    <div className="flex items-center gap-2 opacity-50 pr-4 border-r border-slate-200">
                        <FileText size={20} className="text-slate-400" />
                        <span className="text-[10px] font-black uppercase text-slate-400 tracking-widest">Recentes</span>
                    </div>
                    {/* Placeholder Carousel */}
                    <div className="flex gap-2 overflow-x-auto opacity-50">
                        <span className="text-xs text-slate-400 italic">Histórico de simulados em breve...</span>
                    </div>
                </div>

                <div className="flex-1 flex overflow-hidden">
                    {/* CENTER: Intelligence & Results */}
                    <div className="flex-1 flex flex-col relative">
                        {/* Search Control */}
                        <div className="p-6 bg-white border-b border-slate-200 z-10 shadow-sm">
                            <div className="flex gap-4 mb-4">
                                <button onClick={() => setSimMode('manual')} className={`px-4 py-2 rounded-lg text-xs font-bold uppercase tracking-wide transition-all ${simMode === 'manual' ? 'bg-indigo-600 text-white shadow-md' : 'bg-slate-100 text-slate-500 hover:bg-slate-200'}`}>
                                    Busca Manual e BNCC
                                </button>
                                <button onClick={() => setSimMode('mirror')} className={`px-4 py-2 rounded-lg text-xs font-bold uppercase tracking-wide transition-all ${simMode === 'mirror' ? 'bg-indigo-600 text-white shadow-md' : 'bg-slate-100 text-slate-500 hover:bg-slate-200'}`}>
                                    Modo Espelho (Via Plano)
                                </button>
                            </div>

                            <div className="flex gap-2">
                                <div className="relative flex-1">
                                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
                                    <input
                                        type="text"
                                        value={simSearchQuery}
                                        onChange={(e) => setSimSearchQuery(e.target.value)}
                                        onKeyDown={(e) => e.key === 'Enter' && handleSimSearch()}
                                        placeholder={simMode === 'mirror' ? "Selecione um plano acima para espelhar..." : "Digite o tema, habilidade ou ano (ex: Equação 1º Grau)..."}
                                        className="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium outline-none focus:ring-2 focus:ring-indigo-100"
                                        disabled={simMode === 'mirror'}
                                    />
                                </div>
                                {simMode === 'manual' ? (
                                    <button onClick={handleSimSearch} disabled={simLoading} className="px-6 py-3 bg-indigo-600 text-white rounded-xl font-bold shadow-md hover:bg-indigo-700 disabled:opacity-50">
                                        {simLoading ? <Loader2 className="animate-spin" /> : 'Buscar'}
                                    </button>
                                ) : (
                                    <button onClick={handleMirrorSearch} disabled={simLoading || !selectedTermPlanId} className="px-6 py-3 bg-indigo-600 text-white rounded-xl font-bold shadow-md hover:bg-indigo-700 disabled:opacity-50 flex items-center gap-2">
                                        {simLoading ? <Loader2 className="animate-spin" /> : <><Wand2 size={18} /> Espelhar</>}
                                    </button>
                                )}
                            </div>
                        </div>

                        {/* Results Grid */}
                        <div className="flex-1 overflow-y-auto p-6 bg-slate-50/50">
                            {simSearchResults.length === 0 ? (
                                <div className="h-full flex flex-col items-center justify-center opacity-30">
                                    <Search size={48} className="mb-4 text-slate-300" />
                                    <p className="font-medium text-slate-400">Realize uma busca para ver questões.</p>
                                </div>
                            ) : (
                                <div className="grid grid-cols-1 xl:grid-cols-2 gap-4">
                                    {simSearchResults.map((q) => (
                                        <div key={q.id} className="bg-white p-4 rounded-xl border border-slate-200 hover:border-indigo-300 transition-all shadow-sm group">
                                            <div className="flex justify-between items-start mb-2">
                                                <span className="text-[10px] font-black uppercase text-indigo-500 bg-indigo-50 px-2 py-1 rounded">{q.metadata?.disciplina || 'Geral'}</span>
                                                <span className="text-[10px] font-bold text-slate-400">{q.metadata?.ano || 'N/A'} • {q.metadata?.origem || 'Banco'}</span>
                                            </div>
                                            <p className="text-sm text-slate-700 mb-4 line-clamp-3">{q.content}</p>
                                            <button
                                                onClick={() => handleAddToCart(q)}
                                                className="w-full py-2 bg-slate-50 hover:bg-indigo-50 text-slate-600 hover:text-indigo-600 rounded-lg text-xs font-bold uppercase tracking-wide flex items-center justify-center gap-2 transition-colors"
                                            >
                                                <CheckCircle2 size={14} /> Adicionar
                                            </button>
                                        </div>
                                    ))}
                                </div>
                            )}
                        </div>

                        {/* Footer Controls */}
                        <div className="p-4 bg-white border-t border-slate-200 flex gap-4 items-center">
                            <textarea
                                value={simObservations}
                                onChange={(e) => setSimObservations(e.target.value)}
                                placeholder="Cabeçalho e Instruções (ex: Escola Profeplan, Valor 10pts...)"
                                className="flex-1 h-14 py-2 px-3 bg-slate-50 rounded-lg text-xs border border-slate-200 resize-none outline-none focus:ring-1 focus:ring-indigo-200 custom-scrollbar"
                            />
                            <div className="flex gap-2">
                                <button onClick={() => handleSimAction('balance')} className="px-3 py-2 bg-amber-50 text-amber-700 hover:bg-amber-100 rounded-lg text-[10px] font-black uppercase tracking-wider flex flex-col items-center gap-1 min-w-[4.5rem] transition-colors">
                                    <ArrowUpDown size={14} /> Equilibrar
                                </button>
                                <button onClick={() => handleSimAction('export_word')} className="px-3 py-2 bg-blue-50 text-blue-700 hover:bg-blue-100 rounded-lg text-[10px] font-black uppercase tracking-wider flex flex-col items-center gap-1 min-w-[4.5rem] transition-colors">
                                    <Download size={14} /> Word
                                </button>
                                <button onClick={() => handleSimAction('generate_ab')} className="px-3 py-2 bg-indigo-50 text-indigo-700 hover:bg-indigo-100 rounded-lg text-[10px] font-black uppercase tracking-wider flex flex-col items-center gap-1 min-w-[4.5rem] transition-colors" title="Gerar Prova A e B (Embaralhada)">
                                    <RefreshCw size={14} /> Versão A/B
                                </button>
                            </div>
                        </div>

                    </div>

                    {/* RIGHT: Selection Cart */}
                    <div className="w-80 border-l border-slate-200 bg-white h-full overflow-hidden flex flex-col shadow-xl z-20">
                        <div className="p-4 border-b border-slate-100 bg-slate-50 flex justify-between items-center">
                            <h3 className="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Minha Seleção</h3>
                            <span className="bg-indigo-100 text-indigo-700 text-[10px] font-bold px-2 py-0.5 rounded-full">{simCart.length} itens</span>
                        </div>
                        <div className="flex-1 overflow-y-auto custom-scrollbar p-2 space-y-2">
                            {simCart.length === 0 ? (
                                <div className="p-6 text-center opacity-40">
                                    <FileText size={32} className="mx-auto mb-2 text-slate-300" />
                                    <p className="text-xs text-slate-400">Adicione questões para montar o simulado.</p>
                                </div>
                            ) : (
                                simCart.map((q, idx) => (
                                    <div key={q.id} className="bg-slate-50 border border-slate-200 p-3 rounded-lg group animate-in slide-in-from-right-2">
                                        <div className="flex justify-between items-start">
                                            <span className="text-[10px] font-bold text-slate-500">#{idx + 1}</span>
                                            <button onClick={() => handleRemoveFromCart(q.id)} className="text-slate-300 hover:text-red-400"><X size={14} /></button>
                                        </div>
                                        <p className="text-xs text-slate-700 mt-1 line-clamp-2">{q.content}</p>
                                    </div>
                                ))
                            )}
                        </div>
                        <div className="p-4 border-t border-slate-100">
                            <div className="text-[10px] font-bold text-slate-400 text-center uppercase tracking-wider">Arraste para reordenar (Em breve)</div>
                        </div>
                    </div>
                </div>
            </div>
        );
    }

    // 3. PLANNING COCKPIT (Default)
    return (
        <div className="flex flex-col h-full bg-slate-50 relative overflow-hidden">

            {/* 1. TOP HEADER: Term Plan Selector (Carousel) */}
            <div className="h-20 min-h-[5rem] bg-white border-b border-slate-200 shadow-sm flex items-center px-4 md:px-6 gap-3 overflow-x-auto custom-scrollbar whitespace-nowrap z-20">
                <div className="flex items-center gap-1 opacity-50 pr-4 border-r border-slate-200">
                    <LayoutList size={18} className="text-slate-400" />
                    <span className="text-[10px] font-black uppercase text-slate-400 tracking-widest hidden md:inline">Planejamentos</span>
                </div>
                {termPlans.length === 0 ? (
                    <span className="text-xs text-slate-400 italic">Nenhum planejamento encontrado. Crie um em "Planejamento Trimestral".</span>
                ) : (
                    termPlans.sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime()).map(plan => (
                        <button
                            key={plan.id}
                            onClick={() => setSelectedTermPlanId(plan.id)}
                            className={`flex flex-col items-start justify-center px-4 py-2 rounded-xl border transition-all active:scale-95 shrink-0 w-56 ${selectedTermPlanId === plan.id
                                ? 'bg-indigo-600 border-indigo-600 text-white shadow-md ring-2 ring-indigo-200 ring-offset-1'
                                : 'bg-white border-slate-200 text-slate-600 hover:border-indigo-300 hover:bg-slate-50'
                                }`}
                        >
                            <span className="text-[10px] uppercase tracking-wider font-bold opacity-80">{plan.subject}</span>
                            <span className="text-xs font-bold truncate w-full">{plan.grade} - {plan.period}º {plan.regime}</span>
                        </button>
                    ))
                )}
            </div>

            {/* MAIN WORKSPACE (T-Shape) - Mobile Stack / Desktop Row */}
            <div className="flex-1 flex flex-col md:flex-row overflow-hidden">

                {/* 1. LEFT COLUMN: Lesson Selector */}
                <div className="w-full md:w-60 border-r border-slate-200 bg-white h-auto max-h-48 md:max-h-full md:h-full overflow-hidden flex flex-col shadow-xl z-20 shrink-0">
                    <div className="p-3 border-b border-slate-100 bg-slate-50">
                        <div className="flex justify-between items-center mb-2">
                            <h3 className="text-[10px] font-black uppercase tracking-[0.2em] text-slate-400">Aulas</h3>
                            <span className="bg-indigo-100 text-indigo-700 text-[10px] font-bold px-2 py-0.5 rounded-full">
                                {parsedLessons.length}
                            </span>
                        </div>

                        {/* Progress Bar */}
                        {parsedLessons.length > 0 && (
                            <div className="w-full h-1 bg-slate-200 rounded-full overflow-hidden">
                                <div
                                    className="h-full bg-emerald-500 transition-all duration-500"
                                    style={{ width: `${(Object.keys(lessonTracking).length / parsedLessons.length) * 100}%` }}
                                ></div>
                            </div>
                        )}
                        <p className="text-[9px] text-slate-400 text-right mt-1">
                            {Object.keys(lessonTracking).length} preparadas
                        </p>
                    </div>

                    <div className="flex-1 overflow-y-auto custom-scrollbar p-2 space-y-1">
                        {!selectedTermPlanId ? (
                            <div className="p-4 text-center">
                                <span className="text-xs text-slate-400">Selecione um plano no topo.</span>
                            </div>
                        ) : parsedLessons.length === 0 ? (
                            <div className="p-4 text-center">
                                <span className="text-xs text-slate-400">Nenhuma aula identificada neste plano.</span>
                            </div>
                        ) : (
                            parsedLessons.map(lesson => {
                                const isPrepared = lessonTracking[lesson.number] === 'prepared';
                                const isNext = !isPrepared && (!parsedLessons.find(l => l.number < lesson.number && !lessonTracking[l.number]));

                                return (
                                    <button
                                        key={lesson.number}
                                        onClick={() => setSelectedLesson(lesson)}
                                        className={`w-full text-left p-2 rounded-lg text-xs transition-all border group relative ${selectedLesson?.number === lesson.number
                                            ? 'bg-indigo-50 border-indigo-200 text-indigo-800 font-bold shadow-sm'
                                            : isNext
                                                ? 'bg-white border-indigo-300 text-slate-700 ring-1 ring-indigo-100'
                                                : 'bg-white border-transparent text-slate-500 hover:bg-slate-50 hover:border-slate-200 hover:text-slate-700'
                                            }`}
                                    >
                                        {isNext && (
                                            <span className="absolute -top-1 -right-1 flex h-2 w-2">
                                                <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-indigo-400 opacity-75"></span>
                                                <span className="relative inline-flex rounded-full h-2 w-2 bg-indigo-500"></span>
                                            </span>
                                        )}

                                        <div className="flex items-center gap-2 mb-1">
                                            {isPrepared ? (
                                                <div className="w-4 h-4 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center shrink-0">
                                                    <CheckCircle2 size={10} strokeWidth={3} />
                                                </div>
                                            ) : (
                                                <div className={`w-4 h-4 rounded-full border-2 flex items-center justify-center text-[9px] font-black shrink-0 ${selectedLesson?.number === lesson.number
                                                    ? 'border-indigo-300 bg-white text-indigo-600'
                                                    : 'border-slate-200 bg-slate-50 text-slate-300 group-hover:border-indigo-200'
                                                    }`}>
                                                    {lesson.number}
                                                </div>
                                            )}
                                            <p className={`truncate leading-tight ${isPrepared ? 'text-slate-400 line-through decoration-slate-300' : ''}`}>
                                                {lesson.title}
                                            </p>
                                        </div>
                                    </button>
                                );
                            })
                        )}
                    </div>
                </div>

                {/* MOBILE ACTIONS BAR (Only Visible on Mobile) */}
                <div className="md:hidden p-3 border-b border-slate-200 bg-white flex items-center gap-2 overflow-x-auto whitespace-nowrap scrollbar-hide shrink-0 z-30">
                    <button
                        onClick={() => handleQuickAction('plan')}
                        className="flex-1 min-w-[120px] bg-indigo-50 border border-indigo-100 text-indigo-700 py-2 px-3 rounded-lg flex items-center justify-center gap-2 active:scale-95 transition-all shadow-sm"
                    >
                        <Book size={16} />
                        <span className="text-[10px] font-black uppercase tracking-wide">Planejar</span>
                    </button>
                    <button
                        onClick={() => handleQuickAction('material')}
                        className="flex-1 min-w-[120px] bg-emerald-50 border border-emerald-100 text-emerald-700 py-2 px-3 rounded-lg flex items-center justify-center gap-2 active:scale-95 transition-all shadow-sm"
                    >
                        <FileText size={16} />
                        <span className="text-[10px] font-black uppercase tracking-wide">Material</span>
                    </button>
                    <button
                        onClick={() => handleQuickAction('enem')}
                        className="flex-1 min-w-[120px] bg-amber-50 border border-amber-100 text-amber-700 py-2 px-3 rounded-lg flex items-center justify-center gap-2 active:scale-95 transition-all shadow-sm"
                    >
                        <Search size={16} />
                        <span className="text-[10px] font-black uppercase tracking-wide">Questões</span>
                    </button>
                </div>

                {/* 2. CENTER: Chat Output (Maximized) */}
                <div className="flex-1 flex flex-col relative min-w-0">

                    {/* Chat Output (Scrollable) */}
                    <div className="flex-1 overflow-y-auto px-4 md:px-8 py-6 custom-scrollbar space-y-6 bg-slate-50/50">
                        {messages.length === 0 ? (
                            <div className="flex flex-col items-center justify-center h-full opacity-40 select-none">
                                <Bot size={48} className="mb-4 text-slate-300" />
                                <p className="text-xs font-black uppercase tracking-widest text-slate-400 text-center">
                                    Selecione uma Aula à esquerda<br />e escolha uma Ação à direita.
                                </p>
                            </div>
                        ) : (
                            messages.map((msg) => (
                                <div key={msg.id} className={`flex gap-3 ${msg.role === MessageRole.USER ? 'flex-row-reverse' : ''} animate-in fade-in slide-in-from-bottom-2 duration-300`}>
                                    <div className={`w-8 h-8 rounded-lg flex items-center justify-center shrink-0 shadow-sm ${msg.role === MessageRole.USER ? 'bg-indigo-600 text-white' : 'bg-white text-emerald-600 border border-emerald-100'}`}>
                                        {msg.role === MessageRole.USER ? <User size={14} /> : <Bot size={14} />}
                                    </div>
                                    <div className={`max-w-[90%] flex flex-col items-start`}>
                                        <div className={`p-4 rounded-xl shadow-sm text-sm leading-relaxed whitespace-pre-wrap ${msg.role === MessageRole.USER ? 'bg-indigo-600 text-white rounded-tr-none' : 'bg-white border border-slate-100 text-slate-700 rounded-tl-none'}`}>
                                            {msg.content}
                                        </div>

                                        {/* Assistant Message Actions Toolbar */}
                                        {msg.role === MessageRole.ASSISTANT && !msg.content.startsWith('❌') && !msg.content.startsWith('✅') && (
                                            <div className="flex items-center gap-2 mt-2 ml-2">
                                                <button
                                                    onClick={() => handleExportDocx(msg.content)}
                                                    className="flex items-center gap-1.5 px-3 py-1.5 bg-indigo-600 text-white hover:bg-indigo-700 rounded-lg text-[10px] font-bold uppercase tracking-wide transition-all shadow-sm shadow-indigo-200"
                                                >
                                                    <Download size={12} /> Salvar e Exportar
                                                </button>
                                                <button
                                                    onClick={() => navigator.clipboard.writeText(msg.content)}
                                                    className="flex items-center gap-1.5 px-3 py-1.5 bg-white border border-slate-200 text-slate-500 hover:text-slate-700 hover:bg-slate-50 rounded-lg text-[10px] font-bold uppercase tracking-wide transition-all"
                                                >
                                                    <Copy size={12} /> Copiar
                                                </button>
                                            </div>
                                        )}
                                    </div>
                                </div>
                            ))
                        )}
                        {isThinking && (
                            <div className="flex gap-4 animate-pulse">
                                <div className="w-8 h-8 rounded-lg bg-white border border-emerald-100 flex items-center justify-center shrink-0">
                                    <Loader2 className="w-4 h-4 animate-spin text-emerald-500" />
                                </div>
                                <div className="text-xs font-bold text-slate-400 uppercase tracking-widest py-2">
                                    Processando...
                                </div>
                            </div>
                        )}
                        <div ref={messagesEndRef} />
                    </div>

                    {/* Bottom Input Area (Standard Chat) */}
                    <div className="p-4 bg-white border-t border-slate-200 z-10 sticky bottom-0">
                        <form onSubmit={handleSendMessage} className="max-w-4xl mx-auto relative group">
                            <div className="relative flex items-end gap-2 bg-slate-50 rounded-2xl p-2 shadow-sm border border-slate-200 focus-within:ring-2 focus-within:ring-indigo-100 transition-all">
                                <textarea
                                    value={input}
                                    onChange={(e) => setInput(e.target.value)}
                                    onKeyDown={(e) => {
                                        if (e.key === 'Enter' && !e.shiftKey) {
                                            e.preventDefault();
                                            handleSendMessage(e);
                                        }
                                    }}
                                    placeholder="Peça ajustes ao assistente (ex: 'Reescreva com exemplos mais simples')..."
                                    className="flex-1 bg-transparent border-none focus:ring-0 text-slate-700 placeholder:text-slate-400 font-medium py-3 max-h-32 resize-none custom-scrollbar text-sm"
                                    rows={1}
                                />
                                <button type="submit" disabled={!input.trim() || isThinking} className="p-3 bg-indigo-600 text-white rounded-xl hover:bg-indigo-700 disabled:opacity-50 transition-all active:scale-95 shadow-md shadow-indigo-200">
                                    {isThinking ? <Loader2 className="animate-spin" size={18} /> : <Send size={18} />}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>


            </div>

        </div>
    );
};

export default PlanningManager;
