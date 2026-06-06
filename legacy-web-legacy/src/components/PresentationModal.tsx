
import React, { useState } from 'react';
import { X, Copy, Check, ExternalLink } from 'lucide-react';
import MarkdownRenderer from './MarkdownRenderer';

interface PresentationModalProps {
    isOpen: boolean;
    onClose: () => void;
    title: string;
    content: string; // Markdown base (Prezi / roteiro)
    subtitle?: string;
    showPreziInvite?: boolean;
}

const PresentationModal: React.FC<PresentationModalProps> = ({
    isOpen,
    onClose,
    title,
    content,
    subtitle,
    showPreziInvite = false
}) => {
    const [copied, setCopied] = useState(false);

    if (!isOpen) return null;

    const handleCopy = () => {
        navigator.clipboard.writeText(content);
        setCopied(true);
        setTimeout(() => setCopied(false), 2000);
    };

    return (
        <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-[100] flex items-center justify-center p-4 animate-in fade-in duration-200">
            <div className="bg-white w-full max-w-4xl h-[85vh] rounded-[2rem] shadow-2xl flex flex-col overflow-hidden animate-in zoom-in-95 duration-200">
                {/* Header */}
                <div className="p-6 border-b border-slate-100 flex items-center justify-between bg-white z-10">
                    <div>
                        <h2 className="text-xl font-black text-slate-900 uppercase tracking-tight italic">
                            Roteiro para Apresentação
                        </h2>
                        <p className="text-xs font-bold text-slate-400 uppercase tracking-widest mt-1">
                            {subtitle || 'Base para Prezi, Canva & PPTX'}
                        </p>
                    </div>
                    <button
                        onClick={onClose}
                        className="p-2 hover:bg-slate-100 rounded-full transition-colors text-slate-400 hover:text-slate-600"
                    >
                        <X size={24} />
                    </button>
                </div>

                {/* Content */}
                <div className="flex-1 overflow-y-auto p-6 bg-slate-50 custom-scrollbar">
                    <div className="max-w-3xl mx-auto space-y-4">
                        {showPreziInvite && (
                            <div className="bg-indigo-50 border border-indigo-100 rounded-2xl p-4 flex items-start gap-3">
                                <div className="mt-0.5">
                                    <ExternalLink size={18} className="text-indigo-500" />
                                </div>
                                <div>
                                    <p className="text-[11px] font-black text-indigo-700 uppercase tracking-widest mb-1">
                                        Convite para o Prezi
                                    </p>
                                    <p className="text-xs text-indigo-800 leading-relaxed">
                                        Se ainda não tiver conta no Prezi, cadastre-se usando este convite antes de colar o roteiro:
                                    </p>
                                    <a
                                        href="https://prezi.com/signup/?referral_token=7RUZ6-emB3FN"
                                        target="_blank"
                                        rel="noopener noreferrer"
                                        className="mt-2 inline-flex items-center gap-2 px-3 py-1.5 rounded-full bg-indigo-600 text-white text-[11px] font-black uppercase tracking-widest hover:bg-indigo-700 transition-colors"
                                    >
                                        Abrir convite do Prezi
                                    </a>
                                </div>
                            </div>
                        )}

                    <div className="bg-white p-8 rounded-3xl shadow-sm border border-slate-100">
                        <MarkdownRenderer content={content} />
                    </div>
                    </div>
                </div>

                {/* Footer Actions */}
                <div className="p-6 border-t border-slate-100 bg-white flex items-center justify-end gap-4 z-10">
                    <button
                        onClick={handleCopy}
                        className="flex items-center gap-2 px-6 py-4 bg-blue-50 text-blue-700 rounded-2xl font-black uppercase text-xs tracking-widest hover:bg-blue-100 transition-all active:scale-95 border border-blue-100"
                    >
                        {copied ? <Check size={18} /> : <Copy size={18} />}
                        {copied ? 'Copiado!' : 'Copiar Roteiro'}
                    </button>

                    <button
                        onClick={onClose}
                        className="px-8 py-4 bg-slate-900 text-white rounded-2xl font-black uppercase text-xs tracking-widest hover:bg-slate-800 transition-all active:scale-95 shadow-lg shadow-slate-200"
                    >
                        Fechar
                    </button>
                </div>
            </div>
        </div>
    );
};

export default PresentationModal;
