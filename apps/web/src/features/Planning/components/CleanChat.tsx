
import React from 'react';
import { Bot, User, Loader2, Send, Trash2, CalendarRange, LayoutDashboard, Users, BookOpen, Save, Download } from 'lucide-react';
import { Message, MessageRole } from '../../../types';
import { QuestionSearchWidget } from '../../../components/QuestionFinder/QuestionSearchWidget';

interface CleanChatProps {
    messages: Message[];
    isThinking: boolean;
    input: string;
    setInput: (val: string) => void;
    handleSendMessage: (e: React.FormEvent) => void;
    handleClearChat: () => void;
    messagesEndRef: React.RefObject<HTMLDivElement | null>;
    onSave?: (content: string) => void;
    onExport?: (content: string) => void;
}

export const CleanChat: React.FC<CleanChatProps> = ({
    messages, isThinking, input, setInput, handleSendMessage, handleClearChat, messagesEndRef, onSave, onExport
}) => {
    return (
        <div className="flex-1 flex flex-col h-full relative bg-slate-50/50">
            <div className="flex-1 overflow-y-auto px-4 md:px-10 py-4 custom-scrollbar space-y-4 scroll-smooth">
                {messages.length === 0 && (
                    <div className="flex flex-col items-center justify-center h-full opacity-30 select-none pointer-events-none">
                        <div className="w-20 h-20 bg-indigo-100 rounded-full flex items-center justify-center mb-6 animate-in zoom-in duration-500">
                            <Bot size={40} className="text-indigo-500" />
                        </div>
                        <h2 className="text-2xl font-bold text-slate-700 mb-2">Olá, Professor(a)</h2>
                        <p className="text-sm font-medium text-slate-400 text-center max-w-md leading-relaxed mb-6">
                            Sou seu assistente pedagógico. Posso ajudar com dúvidas rápidas, ideias de projetos ou correções.
                            <br /><span className="text-xs uppercase tracking-wide opacity-70 mt-2 block">Para planos completos, use o menu "Plano de Aula".</span>
                        </p>

                        <div className="grid grid-cols-1 md:grid-cols-2 gap-3 max-w-xl w-full pointer-events-auto">
                            <button
                                type="button"
                                onClick={() => setInput('Quero planejar uma sequência de aulas para este trimestre. Por onde começo?')}
                                className="flex items-center gap-3 px-4 py-3 rounded-2xl bg-white shadow-sm border border-slate-200 hover:border-indigo-200 hover:shadow-md transition-all text-left"
                            >
                                <div className="w-9 h-9 rounded-xl bg-indigo-50 flex items-center justify-center text-indigo-600">
                                    <CalendarRange size={18} />
                                </div>
                                <div>
                                    <p className="text-xs font-black uppercase tracking-[0.2em] text-slate-500">Planejamento Trimestral</p>
                                    <p className="text-xs text-slate-500">Me ajude a organizar o trimestre.</p>
                                </div>
                            </button>

                            <button
                                type="button"
                                onClick={() => setInput('Quero criar um plano de aula completo para a próxima aula. O que você precisa saber de mim?')}
                                className="flex items-center gap-3 px-4 py-3 rounded-2xl bg-white shadow-sm border border-slate-200 hover:border-indigo-200 hover:shadow-md transition-all text-left"
                            >
                                <div className="w-9 h-9 rounded-xl bg-slate-900 flex items-center justify-center text-white">
                                    <LayoutDashboard size={18} />
                                </div>
                                <div>
                                    <p className="text-xs font-black uppercase tracking-[0.2em] text-slate-500">Plano de Aula</p>
                                    <p className="text-xs text-slate-500">Quero montar um plano de aula agora.</p>
                                </div>
                            </button>

                            <button
                                type="button"
                                onClick={() => setInput('Tenho dúvidas sobre como alinhar minhas aulas à BNCC/CRMG. Pode me orientar?')}
                                className="flex items-center gap-3 px-4 py-3 rounded-2xl bg-white shadow-sm border border-slate-200 hover:border-indigo-200 hover:shadow-md transition-all text-left"
                            >
                                <div className="w-9 h-9 rounded-xl bg-emerald-50 flex items-center justify-center text-emerald-600">
                                    <BookOpen size={18} />
                                </div>
                                <div>
                                    <p className="text-xs font-black uppercase tracking-[0.2em] text-slate-500">BNCC / CRMG</p>
                                    <p className="text-xs text-slate-500">Dúvidas sobre currículo e habilidades.</p>
                                </div>
                            </button>

                            <button
                                type="button"
                                onClick={() => setInput('Quero organizar melhor minhas turmas e alunos no PROFEPLAN. Por onde começo?')}
                                className="flex items-center gap-3 px-4 py-3 rounded-2xl bg-white shadow-sm border border-slate-200 hover:border-indigo-200 hover:shadow-md transition-all text-left"
                            >
                                <div className="w-9 h-9 rounded-xl bg-sky-50 flex items-center justify-center text-sky-600">
                                    <Users size={18} />
                                </div>
                                <div>
                                    <p className="text-xs font-black uppercase tracking-[0.2em] text-slate-500">Minhas Turmas</p>
                                    <p className="text-xs text-slate-500">Me ajude a organizar turmas e alunos.</p>
                                </div>
                            </button>
                        </div>
                    </div>
                )}
                {messages.map((msg) => (
                    <div key={msg.id} className={`flex gap-4 ${msg.role === MessageRole.USER ? 'flex-row-reverse' : ''} animate-in fade-in slide-in-from-bottom-2 duration-300`}>
                        <div className={`w-10 h-10 rounded-2xl flex items-center justify-center shrink-0 shadow-lg ${msg.role === MessageRole.USER ? 'bg-indigo-600 text-white' : 'bg-white text-emerald-600 border border-emerald-100'}`}>
                            {msg.role === MessageRole.USER ? <User size={18} /> : <Bot size={18} />}
                        </div>
                        <div className={`max-w-[85%] p-4 rounded-[2rem] shadow-sm text-sm leading-relaxed whitespace-pre-wrap ${msg.role === MessageRole.USER ? 'bg-indigo-600 text-white rounded-tr-none' : 'bg-white border border-slate-100 text-slate-700 rounded-tl-none'}`}>
                            {msg.content}
                            {msg.role === MessageRole.ASSISTANT && msg.content.length > 80 && (
                                <div className="flex gap-2 mt-3 pt-3 border-t border-slate-100">
                                    {onSave && (
                                        <button
                                            onClick={() => onSave(msg.content)}
                                            className="flex items-center gap-1.5 px-3 py-1.5 text-[10px] font-black uppercase tracking-widest text-emerald-600 bg-emerald-50 hover:bg-emerald-100 rounded-xl transition-colors"
                                        >
                                            <Save size={12} /> Salvar
                                        </button>
                                    )}
                                    {onExport && (
                                        <button
                                            onClick={() => onExport(msg.content)}
                                            className="flex items-center gap-1.5 px-3 py-1.5 text-[10px] font-black uppercase tracking-widest text-indigo-600 bg-indigo-50 hover:bg-indigo-100 rounded-xl transition-colors"
                                        >
                                            <Download size={12} /> Baixar DOCX
                                        </button>
                                    )}
                                </div>
                            )}
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

            {/* --- WIDGET DE BUSCA (BETA) --- */}
            <div className="px-4 pb-10">
                <QuestionSearchWidget />
            </div>
        </div>
    );
};
