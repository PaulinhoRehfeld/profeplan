
import React, { useState, useEffect, useRef } from 'react';
import { useGlobalPlanning } from '../../contexts/GlobalPlanningContext';
import { generateGeminiContent } from '../../services/geminiService';
import { Message, MessageRole, ToolMode } from '../../types';
import { PlanFolder, savePlan } from './PlanningService';
import { Loader2 } from 'lucide-react';
import { supabase } from '../../services/supabaseClient';

// --- NEW SUB-COMPONENTS ---
import { SimulationWorkspace } from './components/SimulationWorkspace';
import { PlanningCockpit } from './components/PlanningCockpit';
import { CleanChat } from './components/CleanChat';

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
    setSidebarContent
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
        refreshTermPlans();
        if (appSettings) setLocalSettings(appSettings);
    }, [appSettings, refreshTermPlans]);

    useEffect(() => {
        if (selectedTermPlanId) {
            const plan = termPlans.find(p => p.id === selectedTermPlanId);
            if (plan) {
                parseTermPlan(plan.generatedText);
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
    const parseTermPlan = (text: string) => {
        const lines = text.split('\n');
        const lessons: Lesson[] = [];
        let currentLesson: Partial<Lesson> | null = null;

        lines.forEach(line => {
            const match = line.match(/^(Aula|Semana)\s+(\d+)[:|-](.*)/i);
            if (match) {
                if (currentLesson) lessons.push(currentLesson as Lesson);
                currentLesson = {
                    number: parseInt(match[2]),
                    title: match[3].trim(),
                    description: '',
                    objectives: [],
                    bncc: []
                };
            } else if (currentLesson) {
                if (line.trim().startsWith('-')) {
                    currentLesson.description += line.trim() + '\n';
                }
            }
        });
        if (currentLesson) lessons.push(currentLesson as Lesson);
        setParsedLessons(lessons);
    };

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
            // Context Builder
            const selectedPlan = termPlans.find(p => p.id === selectedTermPlanId);
            let context = `Você é um assistente pedagógico especialista.`;

            if (selectedPlan) {
                context += `\nContexto do Plano Trimestral: ${selectedPlan.grade} - ${selectedPlan.subject}.`;
            }
            if (selectedLesson) {
                context += `\nFoco Atual: Aula ${selectedLesson.number}: ${selectedLesson.title}.\nDescrição: ${selectedLesson.description}`;
            }

            const response = await generateGeminiContent(input, [], context, userId);
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

    const handleExportDocx = async (content: string) => {
        try {
            await exportToDocx(content, `Aula_${selectedLesson?.number || 'Geral'}_${new Date().toISOString().split('T')[0]}`, {
                schoolName: localSettings?.schoolName || 'Escola Profeplan',
                teacherName: localSettings?.teacherName || 'Professor(a)',
                userName: localSettings?.userName
            });
            alert('Download iniciado!');
        } catch (e) {
            console.error(e);
            alert('Erro ao exportar.');
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
                isThinking={isThinking}
                input={input}
                setInput={setInput}
                handleSendMessage={handleSendMessage}
                messagesEndRef={messagesEndRef}
            />
        );
    }

    // Default Fallback (Clean Chat)
    return (
        <CleanChat
            messages={messages}
            isThinking={isThinking}
            input={input}
            setInput={setInput}
            handleSendMessage={handleSendMessage}
            handleClearChat={handleClearChat}
            messagesEndRef={messagesEndRef}
        />
    );
};

export default PlanningManager;
