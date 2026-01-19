
import React, { useRef, useEffect, useState } from 'react';
import { LayoutList, Book, FileText, Search, CheckCircle2, User, Bot, Download, Copy, Loader2, Send, Database, MessageSquare } from 'lucide-react';
import { Message, MessageRole, ToolMode } from '../../../types';
import { TermPlan } from '../../../contexts/GlobalPlanningContext';
import { CurriculumMatcher } from './CurriculumMatcher';

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
    isThinking: boolean;
    input: string;
    setInput: (val: string | ((prev: string) => string)) => void;
    handleSendMessage: (e: React.FormEvent) => void;
    messagesEndRef: React.RefObject<HTMLDivElement>;
}

export const PlanningCockpit: React.FC<PlanningCockpitProps> = ({
    termPlans, selectedTermPlanId, setSelectedTermPlanId,
    parsedLessons, lessonTracking, selectedLesson, setSelectedLesson,
    handleQuickAction, messages, handleExportDocx, isThinking, input, setInput, handleSendMessage, messagesEndRef
}) => {
    const [observations, setObservations] = useState('');

    const handleActionClick = (action: 'plan' | 'material' | 'enem') => {
        if (!selectedLesson) return alert('Selecione uma aula primeiro!');

        let prompt = '';
        if (action === 'plan') prompt = `[AÇÃO: PLANO DE AULA DETALHADO]\nCrie um plano de aula completo para a Aula ${selectedLesson.number}: ${selectedLesson.title}.\nDescrição Original: ${selectedLesson.description}`;
        if (action === 'material') prompt = `[AÇÃO: MATERIAL DIDÁTICO]\nCrie um roteiro de estudo/material de apoio para o aluno sobre o tema: ${selectedLesson.title}.`;
        if (action === 'enem') prompt = `[AÇÃO: QUESTÕES DE PROVA]\nCrie 3 questões inéditas estilo ENEM/SAEB sobre o tema: ${selectedLesson.title}, com gabarito e comentários.`;

        if (observations.trim()) {
            prompt += `\n\n[OBSERVAÇÕES DO PROFESSOR]:\n${observations}`;
        }

        // We need to inject this into the parent's handler
        // Since handleSendMessage expects a FormEvent, we'll manually set input and call it
        // OR better: we can construct a synthetic event or just call setInput and let the user press send?
        // No, the user wants buttons to trigger.
        // We need to expose a direct send method from parent or simulate it.
        // For now, let's use a workaround: setInput(prompt) then wait a tick and submit? 
        // Or update parent to accept text.
        // Let's assume we can setInput and then the user confirms or we auto-send.
        // Ideally we should auto-send.

        // Let's update the input state and trigger the logic.
        setInput(prompt);

        // This is a bit hacky because handleSendMessage takes an event. 
        // We will execute a timeout to submit it if possible, or key off a change.
        // Actually, let's just create a synthetic event.
        setTimeout(() => {
            const syntheticEvent = { preventDefault: () => { } } as React.FormEvent;
            handleSendMessage(syntheticEvent);
            setObservations(''); // Clear observations after sending
        }, 100);
    };

    return (
        <div className="flex bg-slate-50 h-full relative overflow-hidden">

            {/* 1. LEFT SIDEBAR: WIZARD CONTROLS (35% Width) */}
            <div className="w-96 flex flex-col border-r border-slate-200 bg-white shadow-xl z-20 shrink-0">

                {/* A. Plan Selector (Dropdown) */}
                <div className="p-6 border-b border-slate-100 space-y-3 bg-slate-50/50">
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

                {/* C. Action Buttons */}
                <div className="p-4 border-t border-slate-200 bg-white space-y-3">
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
                                <span className="block text-xs font-black uppercase tracking-wide">Avaliação</span>
                                <span className="text-[10px] text-slate-400 font-medium">Questões e gabarito</span>
                            </div>
                        </button>
                    </div>
                </div>

                {/* D. Observation Input */}
                <div className="p-4 border-t border-slate-200 bg-slate-50">
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
            </div>

            {/* 2. RIGHT CONTENT: OUTPUT & CHAT (Flex 1) */}
            <div className="flex-1 flex flex-col h-full bg-slate-50 border-l border-slate-200 relative">

                {/* Header for Chat Area */}
                <div className="h-14 bg-white border-b border-slate-200 flex items-center px-6 justify-between shrink-0">
                    <div className="flex items-center gap-2 text-indigo-600">
                        <Bot size={18} />
                        <span className="text-xs font-black uppercase tracking-widest">Assistente Pedagógico</span>
                    </div>
                    {/* Clear Chat Button could go here */}
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

                                    {/* Assistant Message Actions Toolbar */}
                                    {msg.role === MessageRole.ASSISTANT && !msg.content.startsWith('❌') && !msg.content.startsWith('✅') && (
                                        <div className="flex items-center gap-2 mt-2 ml-2 opacity-0 group-hover:opacity-100 transition-opacity">
                                            <button
                                                onClick={() => handleExportDocx(msg.content)}
                                                className="flex items-center gap-1.5 px-3 py-1.5 bg-white border border-slate-200 text-slate-500 hover:text-indigo-600 hover:border-indigo-200 rounded-lg text-[10px] font-bold uppercase tracking-wide transition-all shadow-sm"
                                            >
                                                <Download size={12} /> Exportar DOCX
                                            </button>
                                            <button
                                                onClick={() => navigator.clipboard.writeText(msg.content)}
                                                className="flex items-center gap-1.5 px-3 py-1.5 bg-white border border-slate-200 text-slate-500 hover:text-slate-700 rounded-lg text-[10px] font-bold uppercase tracking-wide transition-all shadow-sm"
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
        </div>
    );
};
