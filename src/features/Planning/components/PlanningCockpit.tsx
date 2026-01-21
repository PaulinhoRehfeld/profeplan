import React, { useRef, useEffect, useState } from 'react';
import { LayoutList, Book, FileText, Search, CheckCircle2, User, Bot, Download, Copy, Loader2, Send, Database, MessageSquare, Save, Lock, Menu, X } from 'lucide-react';
import { Message, MessageRole, ToolMode } from '../../../types';
import { TermPlan } from '../../../contexts/GlobalPlanningContext';
import { CurriculumMatcher } from './CurriculumMatcher';
import { LowCreditModal } from '../../../components/LowCreditModal';
import { getUserProfile, UserProfile } from '../../../services/userService';

interface PlanningCockpitProps {
    termPlans: TermPlan[];
    selectedTermPlanId: string;
    setSelectedTermPlanId: (id: string) => void;
    parsedLessons: any[];
    lessonTracking: Record<number, string>;
    selectedLesson: any;
    setSelectedLesson: (lesson: any) => void;
    handleQuickAction: (action: 'plan' | 'material' | 'enem') => void;
    messages: Message[];
    handleExportDocx: (content: string) => void;
    handleSavePlan: (content: string) => Promise<boolean>;
    isThinking: boolean;
    input: string;
    setInput: (val: string | ((prev: string) => string)) => void;
    handleSendMessage: (e: React.FormEvent, overrideInput?: string) => void;
    messagesEndRef: React.RefObject<HTMLDivElement>;
    userId: string; // NEW Prop
}

export const PlanningCockpit: React.FC<PlanningCockpitProps> = ({
    termPlans, selectedTermPlanId, setSelectedTermPlanId,
    parsedLessons, lessonTracking, selectedLesson, setSelectedLesson,
    handleQuickAction, messages, handleExportDocx, handleSavePlan, isThinking, input, setInput, handleSendMessage, messagesEndRef,
    userId
}) => {
    const [observations, setObservations] = useState('');
    const [userProfile, setUserProfile] = useState<UserProfile | null>(null);
    const [showLowCreditModal, setShowLowCreditModal] = useState(false);
    const hasShownWarning = useRef<number | null>(null); // Track last level shown to avoid spam

    useEffect(() => {
        refreshProfile();
    }, [userId]);

    const refreshProfile = async () => {
        if (!userId) return;
        const profile = await getUserProfile(userId);
        if (profile) {
            setUserProfile(profile);
            checkCreditWarning(profile.credits);
        }
    };

    const checkCreditWarning = (credits: number) => {
        // Trigger on 4, 3, 2, 1
        if (credits <= 4 && credits > 0) {
            // Only show if we haven't shown for this level or lower in this session
            // actually just show once per session or per credit drop?
            // Requirement says "repeat with 3, 2 and 1".
            // So if current is 3, and last shown was 4 (or null), show.
            // If last shown was 3, don't show.
            if (hasShownWarning.current !== credits) {
                setShowLowCreditModal(true);
                hasShownWarning.current = credits;
            }
        }
    };

    // Material do Aluno Sates
    const [showMaterialOptions, setShowMaterialOptions] = useState(false);
    const [materialType, setMaterialType] = useState<'resumo' | 'teorico' | 'exercicios' | null>(null);
    const [materialInstructions, setMaterialInstructions] = useState('');

    // Assessment States
    const [showAssessmentOptions, setShowAssessmentOptions] = useState(false);
    const [enemCount, setEnemCount] = useState(1);
    const [objectiveCount, setObjectiveCount] = useState(2);
    const [dissertativeCount, setDissertativeCount] = useState(1);
    const [difficulty, setDifficulty] = useState<'Fácil' | 'Médio' | 'Difícil'>('Médio');

    // Message ID -> Saved State Mapping
    const [savedMessages, setSavedMessages] = useState<Record<string, boolean>>({});
    const [isSaving, setIsSaving] = useState<Record<string, boolean>>({});

    // Mobile Menu State
    const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(true);

    const handleActionClick = (action: 'plan' | 'material' | 'enem') => {
        if (!selectedLesson) return alert('Selecione uma aula primeiro!');

        if (action === 'material') {
            setShowMaterialOptions(true);
            setShowAssessmentOptions(false);
            return;
        }

        if (action === 'enem') {
            setShowAssessmentOptions(true);
            setShowMaterialOptions(false);
            return;
        }

        // Auto-close menu on mobile
        setIsMobileMenuOpen(false);

        // Reset Options if switching to plan
        setShowMaterialOptions(false);
        setShowAssessmentOptions(false);
        setMaterialType(null);

        let prompt = '';
        if (action === 'plan') prompt = `[AÇÃO: PLANO DE AULA DETALHADO]\nCrie um plano de aula completo para a Aula ${selectedLesson.number}: ${selectedLesson.title}.\nDescrição Original: ${selectedLesson.description}`;

        if (observations.trim()) {
            prompt += `\n\n[OBSERVAÇÕES DO PROFESSOR]:\n${observations}`;
        }

        if (observations.trim()) {
            prompt += `\n\n[OBSERVAÇÕES DO PROFESSOR]:\n${observations}`;
        }

        // Pass prompt directly, bypassing state delay
        triggerSend(prompt);
    };

    const handleAssessmentGenerate = () => {
        if (!selectedLesson) return;

        let prompt = `[AÇÃO: LISTA DE EXERCÍCIOS]\n[TYPE: EXERCISES]\nCrie uma lista de exercícios sobre o tema: ${selectedLesson.title}.`;

        prompt += `\n\n[CONFIGURAÇÃO DA PROVA]:
- Questões Estilo ENEM (Banco de Dados): ${enemCount}
- Questões Objetivas Contextuais (IA): ${objectiveCount}
- Questões Discursivas/Subjetivas: ${dissertativeCount}
- Nível de Dificuldade: ${difficulty}`;

        if (observations.trim()) {
            prompt += `\n\n[OBSERVAÇÕES ADICIONAIS]:\n${observations}`;
        }

        if (observations.trim()) {
            prompt += `\n\n[OBSERVAÇÕES ADICIONAIS]:\n${observations}`;
        }

        triggerSend(prompt);

        // Reset UI
        setShowAssessmentOptions(false);
        setObservations('');
    };

    const handleMaterialGenerate = () => {
        if (!selectedLesson) return;
        if (!materialType) return alert('Selecione o tipo de material!');

        let typeLabel = '';
        if (materialType === 'resumo') typeLabel = 'RESUMO EM TÓPICOS';
        if (materialType === 'teorico') typeLabel = 'TEXTO TEÓRICO COMPLETO';
        if (materialType === 'exercicios') typeLabel = 'LISTA DE EXERCÍCIOS DE FIXAÇÃO';

        let prompt = `[AÇÃO: MATERIAL DIDÁTICO - ${typeLabel}]\n[TYPE: MATERIAL]\nCrie um material didático para a Aula ${selectedLesson.number}: ${selectedLesson.title}.`;

        if (materialInstructions.trim()) {
            prompt += `\n\n[DETALHES DA OPÇÃO SELECIONADA]:\n${materialInstructions}`;
        }

        if (materialInstructions.trim()) {
            prompt += `\n\n[DETALHES DA OPÇÃO SELECIONADA]:\n${materialInstructions}`;
        }

        triggerSend(prompt);

        // Reset UI
        setShowMaterialOptions(false);
        setMaterialType(null);
        setMaterialInstructions('');
    };

    const triggerSend = (prompt?: string) => {
        setTimeout(() => {
            const syntheticEvent = { preventDefault: () => { } } as React.FormEvent;
            handleSendMessage(syntheticEvent, prompt);
            setObservations('');
        }, 100);
    };

    const onSaveMessage = async (msgId: string, content: string) => {
        setIsSaving(prev => ({ ...prev, [msgId]: true }));
        const success = await handleSavePlan(content);
        if (success) {
            setSavedMessages(prev => ({ ...prev, [msgId]: true }));
        }
        setIsSaving(prev => ({ ...prev, [msgId]: false }));
    };

    return (
        <div className="flex flex-col lg:flex-row bg-slate-50 h-full relative overflow-hidden">

            {/* 1. LEFT SIDEBAR: WIZARD CONTROLS (Mobile: Overlay / Desktop: Left 35%) */}
            <div className={`
                fixed inset-0 z-50 bg-white flex flex-col transition-transform duration-300 shadow-2xl
                lg:relative lg:translate-x-0 lg:w-96 lg:shadow-xl lg:z-20
                ${isMobileMenuOpen ? 'translate-x-0' : '-translate-x-full'}
            `}>

                {/* A. Plan Selector (Dropdown) */}
                <div className="p-4 lg:p-6 border-b border-slate-100 space-y-3 bg-slate-50/50 relative">
                    {/* Mobile Close Button */}
                    <button
                        onClick={() => setIsMobileMenuOpen(false)}
                        className="absolute top-4 right-4 p-2 text-slate-400 hover:text-slate-600 lg:hidden"
                    >
                        <X size={20} />
                    </button>

                    <div className="flex items-center gap-2 text-slate-400 mb-1">
                        <LayoutList size={14} />
                        <span className="text-[10px] font-black uppercase tracking-widest">Selecione o Planejamento</span>
                    </div>

                    <select
                        value={selectedTermPlanId}
                        onChange={(e) => setSelectedTermPlanId(e.target.value)}
                        className="w-full p-3 rounded-xl border border-slate-200 bg-white text-sm font-bold text-slate-700 focus:ring-2 focus:ring-indigo-100 outline-none shadow-sm cursor-pointer hover:border-indigo-300 transition-all"
                    >
                        <option value="">Selecione um plano...</option>
                        {termPlans.map(plan => (
                            <option key={plan.id} value={plan.id}>
                                {plan.subject} - {plan.grade} ({plan.period}º {plan.regime})
                            </option>
                        ))}
                    </select>

                    <div className="flex justify-between items-center px-1">
                        <span className="text-[10px] font-bold text-slate-400 uppercase">Aulas Mapeadas</span>
                        <span className="bg-emerald-100 text-emerald-700 text-[10px] font-bold px-2 py-0.5 rounded-full">
                            {parsedLessons.length > 0 ? `${Object.keys(lessonTracking).length}/${parsedLessons.length} Geradas` : '0/0'}
                        </span>
                    </div>
                </div>

                {/* B. Lesson List Box */}
                <div className="flex-1 overflow-y-auto custom-scrollbar p-3 space-y-1 bg-slate-50/30">
                    {!selectedTermPlanId ? (
                        <div className="h-full flex flex-col items-center justify-center text-slate-400 p-8 text-center opacity-60">
                            <Book size={32} className="mb-2" strokeWidth={1.5} />
                            <p className="text-xs font-medium">Selecione um planejamento acima para ver as aulas.</p>
                        </div>
                    ) : parsedLessons.length === 0 ? (
                        <div className="h-full flex flex-col items-center justify-center text-slate-400 text-center">
                            <p className="text-xs">Nenhuma aula encontrada neste plano.</p>
                        </div>
                    ) : (
                        parsedLessons.map(lesson => {
                            const isPrepared = lessonTracking[lesson.number] === 'prepared';
                            return (
                                <button
                                    key={lesson.number}
                                    onClick={() => setSelectedLesson(lesson)}
                                    className={`w-full text-left p-3 rounded-xl text-xs transition-all border group relative flex items-start gap-3 ${selectedLesson?.number === lesson.number
                                        ? 'bg-indigo-600 border-indigo-600 text-white shadow-lg shadow-indigo-200 scale-[1.02]'
                                        : 'bg-white border-slate-200 text-slate-600 hover:border-indigo-300 hover:shadow-sm'
                                        }`}
                                >
                                    <div className={`w-5 h-5 rounded-md flex items-center justify-center text-[10px] font-black shrink-0 mt-0.5 ${selectedLesson?.number === lesson.number ? 'bg-white/20 text-white' : 'bg-slate-100 text-slate-400'
                                        }`}>
                                        {lesson.number}
                                    </div>
                                    <div className="flex-1 min-w-0">
                                        <p className={`font-bold leading-snug truncate ${isPrepared && selectedLesson?.number !== lesson.number ? 'line-through text-slate-400 decoration-slate-300 decoration-2' : ''}`}>
                                            {lesson.title}
                                        </p>
                                        {selectedLesson?.number === lesson.number && (
                                            <p className="text-[10px] opacity-80 mt-1 line-clamp-2 leading-relaxed font-medium">
                                                {lesson.description}
                                            </p>
                                        )}
                                    </div>
                                    {isPrepared && (
                                        <CheckCircle2 size={14} className={selectedLesson?.number === lesson.number ? 'text-white' : 'text-emerald-500'} />
                                    )}
                                </button>
                            );
                        })
                    )}
                </div>

                {/* C. Action Buttons or Material Wizard */}
                <div className="p-4 border-t border-slate-200 bg-white space-y-3">
                    {showMaterialOptions ? (
                        <div className="animate-in slide-in-from-right-4 duration-300">
                            <div className="flex items-center justify-between mb-2">
                                <p className="text-[10px] font-black uppercase tracking-widest text-indigo-600">Configurar Material</p>
                                <button onClick={() => setShowMaterialOptions(false)} className="text-slate-400 hover:text-red-500 text-[10px] font-bold">CANCELAR</button>
                            </div>

                            <div className="grid grid-cols-1 gap-2 mb-3">
                                {[
                                    { id: 'resumo', label: 'Resumo em Tópicos' },
                                    { id: 'teorico', label: 'Texto Teórico' },
                                    { id: 'exercicios', label: 'Exercícios' }
                                ].map(opt => (
                                    <button
                                        key={opt.id}
                                        onClick={() => setMaterialType(opt.id as any)}
                                        className={`p-3 rounded-lg border text-xs font-bold text-left transition-all ${materialType === opt.id
                                            ? 'bg-indigo-50 border-indigo-500 text-indigo-700'
                                            : 'bg-white border-slate-200 text-slate-600 hover:bg-slate-50'
                                            }`}
                                    >
                                        {opt.label}
                                    </button>
                                ))}
                            </div>

                            <div className="mb-3">
                                <p className="text-[9px] font-black uppercase tracking-widest text-slate-400 mb-1">Detalhes da Opção Selecionada</p>
                                <textarea
                                    value={materialInstructions}
                                    onChange={(e) => setMaterialInstructions(e.target.value)}
                                    placeholder="Ex: Incluir analogias simples..."
                                    className="w-full p-2 rounded-lg border border-slate-200 bg-slate-50 text-xs h-16 resize-none focus:bg-white focus:ring-2 ring-indigo-100 outline-none"
                                />
                            </div>

                            <button
                                onClick={handleMaterialGenerate}
                                disabled={!materialType}
                                className="w-full py-3 bg-indigo-600 text-white rounded-xl text-xs font-black uppercase tracking-widest hover:bg-indigo-700 disabled:opacity-50 transition-all"
                            >
                                Gerar Material
                            </button>
                        </div>
                    ) : showAssessmentOptions ? (
                        <div className="animate-in slide-in-from-right-4 duration-300">
                            <div className="flex items-center justify-between mb-2">
                                <p className="text-[10px] font-black uppercase tracking-widest text-amber-600">Configurar Exercícios</p>
                                <button onClick={() => setShowAssessmentOptions(false)} className="text-slate-400 hover:text-red-500 text-[10px] font-bold">CANCELAR</button>
                            </div>

                            <div className="space-y-4 mb-4">
                                <div>
                                    <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1">Questões ENEM ({enemCount})</label>
                                    <input
                                        type="range" min="0" max="10" step="1"
                                        value={enemCount}
                                        onChange={(e) => setEnemCount(Number(e.target.value))}
                                        className="w-full accent-amber-500"
                                    />
                                </div>
                                <div>
                                    <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1">Questões Objetivas ({objectiveCount})</label>
                                    <input
                                        type="range" min="0" max="10" step="1"
                                        value={objectiveCount}
                                        onChange={(e) => setObjectiveCount(Number(e.target.value))}
                                        className="w-full accent-amber-500"
                                    />
                                </div>
                                <div>
                                    <label className="text-[10px] font-bold text-slate-500 uppercase block mb-1">Questões Discursivas ({dissertativeCount})</label>
                                    <input
                                        type="range" min="0" max="5" step="1"
                                        value={dissertativeCount}
                                        onChange={(e) => setDissertativeCount(Number(e.target.value))}
                                        className="w-full accent-amber-500"
                                    />
                                </div>
                                <div>
                                    <label className="text-[10px] font-bold text-slate-500 uppercase block mb-2">Dificuldade</label>
                                    <div className="flex gap-2">
                                        {['Fácil', 'Médio', 'Difícil'].map(d => (
                                            <button
                                                key={d}
                                                onClick={() => setDifficulty(d as any)}
                                                className={`flex-1 py-2 rounded-lg text-[10px] font-black uppercase transition-all ${difficulty === d
                                                    ? 'bg-amber-100 text-amber-700 border border-amber-200'
                                                    : 'bg-slate-50 text-slate-400 border border-slate-100 hover:bg-white'
                                                    }`}
                                            >
                                                {d}
                                            </button>
                                        ))}
                                    </div>
                                </div>
                            </div>

                            <button
                                onClick={handleAssessmentGenerate}
                                className="w-full py-3 bg-amber-500 text-white rounded-xl text-xs font-black uppercase tracking-widest hover:bg-amber-600 transition-all shadow-sm shadow-amber-200"
                            >
                                Gerar Exercícios
                            </button>
                        </div>
                    ) : (
                        <>
                            <p className="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-2 px-1">O que deseja criar?</p>
                            <div className="grid grid-cols-1 gap-2">
                                <button
                                    onClick={() => handleActionClick('plan')}
                                    disabled={!selectedLesson || isThinking}
                                    className="flex items-center gap-3 p-3 rounded-xl border border-slate-200 bg-white hover:bg-indigo-50 hover:border-indigo-200 hover:text-indigo-700 transition-all group disabled:opacity-50 disabled:cursor-not-allowed justify-start text-left"
                                >
                                    <div className="w-8 h-8 rounded-lg bg-indigo-100 text-indigo-600 flex items-center justify-center group-hover:bg-indigo-600 group-hover:text-white transition-colors">
                                        <Book size={16} strokeWidth={2.5} />
                                    </div>
                                    <div>
                                        <span className="block text-xs font-black uppercase tracking-wide">Plano de Aula</span>
                                        <span className="text-[10px] text-slate-400 font-medium">Metodologia e objetivos</span>
                                    </div>
                                </button>

                                <button
                                    onClick={() => handleActionClick('material')}
                                    disabled={!selectedLesson || isThinking}
                                    className="flex items-center gap-3 p-3 rounded-xl border border-slate-200 bg-white hover:bg-emerald-50 hover:border-emerald-200 hover:text-emerald-700 transition-all group disabled:opacity-50 disabled:cursor-not-allowed justify-start text-left"
                                >
                                    <div className="w-8 h-8 rounded-lg bg-emerald-100 text-emerald-600 flex items-center justify-center group-hover:bg-emerald-600 group-hover:text-white transition-colors">
                                        <FileText size={16} strokeWidth={2.5} />
                                    </div>
                                    <div>
                                        <span className="block text-xs font-black uppercase tracking-wide">Material do Aluno</span>
                                        <span className="text-[10px] text-slate-400 font-medium">Resumos e fixação</span>
                                    </div>
                                </button>

                                <button
                                    onClick={() => handleActionClick('enem')}
                                    disabled={!selectedLesson || isThinking}
                                    className="flex items-center gap-3 p-3 rounded-xl border border-slate-200 bg-white hover:bg-amber-50 hover:border-amber-200 hover:text-amber-700 transition-all group disabled:opacity-50 disabled:cursor-not-allowed justify-start text-left"
                                >
                                    <div className="w-8 h-8 rounded-lg bg-amber-100 text-amber-600 flex items-center justify-center group-hover:bg-amber-600 group-hover:text-white transition-colors">
                                        <CheckCircle2 size={16} strokeWidth={2.5} />
                                    </div>
                                    <div>
                                        <span className="block text-xs font-black uppercase tracking-wide">Exercícios</span>
                                        <span className="text-[10px] text-slate-400 font-medium">Lista de fixação</span>
                                    </div>
                                </button>
                            </div>
                        </>
                    )}
                </div>

                {/* D. Observation Input (Hidden if Wizard visible to save space) */}
                {!showMaterialOptions && !showAssessmentOptions && (
                    <div className="p-4 border-t border-slate-200 bg-slate-50 hidden lg:block">
                        <p className="text-[10px] font-black uppercase tracking-widest text-slate-400 mb-2 flex items-center gap-2">
                            <MessageSquare size={10} /> Observações Específicas
                        </p>
                        <textarea
                            value={observations}
                            onChange={(e) => setObservations(e.target.value)}
                            placeholder="Ex: Focar em exemplos práticos do cotidiano..."
                            className="w-full p-3 rounded-xl border border-slate-200 bg-white text-xs font-medium text-slate-600 focus:ring-2 focus:ring-indigo-100 outline-none resize-none h-20"
                        />
                    </div>
                )}
            </div>

            {/* 2. RIGHT CONTENT: OUTPUT & CHAT (Mobile: Full Screen / Desktop: Flex 1) */}
            <div className="flex-1 flex flex-col h-full bg-slate-50 border-l border-slate-200 relative w-full">

                {/* Header for Chat Area */}
                <div className="h-14 bg-white border-b border-slate-200 flex items-center px-4 lg:px-6 justify-between shrink-0">
                    <div className="flex items-center gap-2 text-indigo-600">
                        {/* Mobile Menu Toggle */}
                        <button
                            onClick={() => setIsMobileMenuOpen(true)}
                            className="lg:hidden p-1 mr-1 text-slate-500 hover:text-indigo-600 transition-colors"
                        >
                            <Menu size={20} />
                        </button>
                        <Bot size={18} />
                        <span className="text-xs font-black uppercase tracking-widest">Assistente Pedagógico</span>
                    </div>
                </div>

                {/* Chat Output (Scrollable) */}
                <div className="flex-1 overflow-y-auto px-6 py-6 custom-scrollbar space-y-6">
                    {messages.length === 0 ? (
                        <div className="flex flex-col items-center justify-center h-full opacity-40 select-none">
                            <div className="w-20 h-20 bg-slate-200/50 rounded-full flex items-center justify-center mb-4">
                                <LayoutList size={32} className="text-slate-400" />
                            </div>
                            <h3 className="text-sm font-black uppercase tracking-widest text-slate-500 mb-2">Área de Trabalho</h3>
                            <p className="text-xs text-slate-400 text-center max-w-xs leading-relaxed">
                                Selecione um planejamento e uma aula à esquerda para começar a gerar seus documentos pedagógicos.
                            </p>
                        </div>
                    ) : (
                        messages.map((msg) => (
                            <div key={msg.id} className={`flex gap-4 ${msg.role === MessageRole.USER ? 'flex-row-reverse' : ''} animate-in fade-in slide-in-from-bottom-4 duration-500`}>
                                <div className={`w-10 h-10 rounded-xl flex items-center justify-center shrink-0 shadow-sm ${msg.role === MessageRole.USER ? 'bg-indigo-600 text-white' : 'bg-white text-emerald-600 border border-emerald-100'}`}>
                                    {msg.role === MessageRole.USER ? <User size={16} /> : <Bot size={16} />}
                                </div>
                                <div className={`max-w-[85%] flex flex-col items-start`}>
                                    <div className={`p-5 rounded-2xl shadow-sm text-sm leading-relaxed whitespace-pre-wrap ${msg.role === MessageRole.USER ? 'bg-indigo-600 text-white rounded-tr-none' : 'bg-white border border-slate-100 text-slate-700 rounded-tl-none'}`}>
                                        {msg.content}
                                    </div>

                                    {/* ACTIONS BAR (BELOW CONTENT) */}
                                    {msg.role === MessageRole.ASSISTANT && !msg.content.startsWith('❌') && !msg.content.startsWith('✅') && (
                                        <div className="flex items-center gap-2 mt-3 w-full animate-in fade-in duration-300">

                                            {/* 1. SAVE BUTTON */}
                                            <button
                                                onClick={() => onSaveMessage(msg.id, msg.content)}
                                                disabled={savedMessages[msg.id] || isSaving[msg.id]}
                                                className={`flex items-center gap-2 px-4 py-2 rounded-lg text-[10px] font-black uppercase tracking-widest transition-all shadow-sm ${savedMessages[msg.id]
                                                    ? 'bg-green-100 text-green-700 border border-green-200 cursor-default'
                                                    : 'bg-indigo-600 text-white hover:bg-indigo-700 hover:shadow-indigo-200'
                                                    }`}
                                            >
                                                {isSaving[msg.id] ? <Loader2 size={14} className="animate-spin" /> : <Save size={14} />}
                                                {savedMessages[msg.id] ? 'Salvo' : 'Salvar'}
                                            </button>

                                            {/* 2. EXPORT DOCX (LOCKED UNTIL SAVED) */}
                                            <button
                                                onClick={() => handleExportDocx(msg.content)}
                                                disabled={!savedMessages[msg.id]}
                                                className={`flex items-center gap-2 px-4 py-2 rounded-lg text-[10px] font-black uppercase tracking-widest transition-all shadow-sm border ${savedMessages[msg.id]
                                                    ? 'bg-white border-blue-200 text-blue-700 hover:bg-blue-50 cursor-pointer'
                                                    : 'bg-slate-100 border-slate-200 text-slate-400 cursor-not-allowed opacity-70'
                                                    }`}
                                                title={!savedMessages[msg.id] ? "Salve o documento primeiro para exportar" : "Exportar para Word"}
                                            >
                                                {!savedMessages[msg.id] ? <Lock size={12} /> : <Download size={14} />}
                                                Salvar em Word
                                            </button>

                                            <div className="h-4 w-px bg-slate-200 mx-2"></div>

                                            <button
                                                onClick={() => navigator.clipboard.writeText(msg.content)}
                                                className="flex items-center gap-1.5 px-3 py-1.5 text-slate-400 hover:text-slate-600 text-[10px] font-bold uppercase tracking-wide transition-all"
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
                            <div className="w-10 h-10 rounded-xl bg-white border border-emerald-100 flex items-center justify-center shrink-0">
                                <Loader2 className="w-5 h-5 animate-spin text-emerald-500" />
                            </div>
                            <div className="text-xs font-bold text-slate-400 uppercase tracking-widest py-3">
                                Gerando conteúdo...
                            </div>
                        </div>
                    )}
                    <div ref={messagesEndRef} />
                </div>
            </div>
            {userProfile && (
                <LowCreditModal
                    isOpen={showLowCreditModal}
                    onClose={() => setShowLowCreditModal(false)}
                    currentCredits={userProfile.credits}
                    userId={userId}
                    userPhone={userProfile.phone}
                    onSuccess={() => {
                        refreshProfile();
                    }}
                />
            )}
        </div>
    );
};
