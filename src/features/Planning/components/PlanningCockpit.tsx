
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
    const [activeTab, setActiveTab] = useState<'chat' | 'curriculum'>('chat');

    const handleAddQuestionToInput = (content: string) => {
        setInput((prev) => {
            const newContent = `[ADICIONAR AO PLANO]:\n${content}`;
            return prev ? `${prev}\n\n${newContent}` : newContent;
        });
        // Optional: Switch back to chat to show it's added?
        // setActiveTab('chat'); 
    };

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
                        onClick={() => setActiveTab('curriculum')}
                        className={`flex-1 min-w-[120px] border py-2 px-3 rounded-lg flex items-center justify-center gap-2 active:scale-95 transition-all shadow-sm ${activeTab === 'curriculum'
                                ? 'bg-indigo-600 text-white border-indigo-600'
                                : 'bg-amber-50 border-amber-100 text-amber-700'
                            }`}
                    >
                        <Search size={16} />
                        <span className="text-[10px] font-black uppercase tracking-wide">Questões</span>
                    </button>
                </div>

                {/* 2. CENTER: Chat Output vs Curriculum Matcher */}
                <div className="flex-1 flex flex-col relative min-w-0">

                    {/* TABS (Desktop mainly, but also visible on mobile top of chat area) */}
                    <div className="flex border-b border-slate-200 bg-white">
                        <button
                            onClick={() => setActiveTab('chat')}
                            className={`flex-1 py-3 text-xs font-bold uppercase tracking-wider flex items-center justify-center gap-2 border-b-2 transition-all ${activeTab === 'chat'
                                    ? 'border-indigo-600 text-indigo-600 bg-indigo-50'
                                    : 'border-transparent text-slate-400 hover:text-slate-600 hover:bg-slate-50'
                                }`}
                        >
                            <MessageSquare size={16} />
                            Chat & Planejamento
                        </button>
                        <button
                            onClick={() => setActiveTab('curriculum')}
                            className={`flex-1 py-3 text-xs font-bold uppercase tracking-wider flex items-center justify-center gap-2 border-b-2 transition-all ${activeTab === 'curriculum'
                                    ? 'border-emerald-500 text-emerald-600 bg-emerald-50'
                                    : 'border-transparent text-slate-400 hover:text-slate-600 hover:bg-slate-50'
                                }`}
                        >
                            <Database size={16} />
                            Banco de Questões
                        </button>
                    </div>

                    {activeTab === 'chat' ? (
                        <>
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
                        </>
                    ) : (
                        <CurriculumMatcher onAddContent={handleAddQuestionToInput} />
                    )}
                </div>
            </div>
        </div>
    );
};
