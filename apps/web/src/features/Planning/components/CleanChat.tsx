
import React from 'react';
import { Bot, User, Loader2, Send, Trash2 } from 'lucide-react';
import { Message, MessageRole } from '../../../types';
import { QuestionSearchWidget } from '../../../components/QuestionFinder/QuestionSearchWidget';

interface CleanChatProps {
    messages: Message[];
    isThinking: boolean;
    input: string;
    setInput: (val: string) => void;
    handleSendMessage: (e: React.FormEvent) => void;
    handleClearChat: () => void;
    messagesEndRef: React.RefObject<HTMLDivElement>;
}

export const CleanChat: React.FC<CleanChatProps> = ({
    messages, isThinking, input, setInput, handleSendMessage, handleClearChat, messagesEndRef
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

            {/* --- WIDGET DE BUSCA (BETA) --- */}
            <div className="px-4 pb-10">
                <QuestionSearchWidget />
            </div>
        </div>
    );
};
