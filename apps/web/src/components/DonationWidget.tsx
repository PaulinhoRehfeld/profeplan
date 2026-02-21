import React, { useState, useEffect } from 'react';
import { Copy, Check, Sparkles, QrCode } from 'lucide-react';

export default function DonationWidget({ isExpanded = true }: { isExpanded?: boolean }) {
    const [copied, setCopied] = useState(false);
    const [messageIndex, setMessageIndex] = useState(0);

    // Textos rotativos
    const messages = [
        {
            title: "Apoie o PROFEPLAN 💙",
            text: "Se esta ferramenta está poupando o seu tempo, ajude a manter o projeto vivo! Sua doação cobre os custos da Inteligência Artificial e mantém o app 100% gratuito."
        },
        {
            title: "Gostando do PROFEPLAN?",
            text: "Considere fazer uma doação! Seu apoio nos ajuda a pagar os servidores, criar novas funcionalidades e manter o sistema sempre gratuito para todos."
        },
        {
            title: "Valorize seu tempo! ⏱️",
            text: "O PROFEPLAN ajudou a adiantar seu planejamento? Contribua com qualquer valor para apoiar o desenvolvimento e garantir que continuemos sem anúncios."
        }
    ];

    // Define qual mensagem mostrar baseado no dia do mês
    useEffect(() => {
        const today = new Date().getDate();
        setMessageIndex(today % messages.length);
    }, []);

    // Função para copiar a chave PIX (só números para evitar erro no banco)
    const pixKey = "33999989922";
    const displayPix = "(33) 99998-9922";

    const handleCopyPix = () => {
        navigator.clipboard.writeText(pixKey);
        setCopied(true);
        setTimeout(() => setCopied(false), 2000); // Volta ao normal após 2 segundos
    };

    const currentMessage = messages[messageIndex];

    if (!isExpanded) {
        return (
            <div className="flex flex-col items-center gap-2 my-4">
                <button
                    onClick={handleCopyPix}
                    className={`p-2 rounded-xl transition-all shadow-lg active:scale-95 ${copied ? 'bg-green-500 text-white' : 'bg-blue-600 text-white hover:bg-blue-500'
                        }`}
                    title="Copiar Chave PIX"
                >
                    {copied ? <Check size={18} /> : <Copy size={18} />}
                </button>
            </div>
        );
    }

    return (
        <div className="bg-white border-2 border-slate-100 rounded-3xl p-5 flex flex-col items-center text-center shadow-sm w-full mx-auto my-4 animate-in fade-in slide-in-from-bottom-2 duration-500 group">
            {/* Header com Ícone e Título */}
            <div className="flex items-center gap-2 mb-3">
                <Sparkles size={14} className="text-blue-600" />
                <h4 className="font-black text-slate-900 text-[10px] uppercase tracking-[0.15em] italic">
                    {currentMessage.title}
                </h4>
            </div>

            <p className="text-slate-500 text-[11px] leading-relaxed mb-6 font-medium px-1">
                {currentMessage.text.split('. ').map((part, i, arr) => (
                    <span key={i}>
                        {part}{i !== arr.length - 1 ? '.' : ''}
                        <br />
                    </span>
                ))}
            </p>

            {/* QR Code Container (Estreito) */}
            <div className="bg-white p-2 rounded-2xl shadow-sm border border-slate-100 mb-6 w-28 h-28 flex items-center justify-center relative group/qr">
                <img
                    src="/donation-qr-code.png"
                    alt="PIX"
                    className="w-full h-full object-contain"
                    onError={(e) => {
                        (e.target as HTMLImageElement).style.display = 'none';
                        const parent = (e.target as HTMLElement).parentElement;
                        if (parent) {
                            const fallback = parent.querySelector('.qr-fallback');
                            if (fallback) fallback.classList.remove('hidden');
                        }
                    }}
                />
                <div className="qr-fallback hidden inset-0 flex flex-col items-center justify-center text-slate-300">
                    <QrCode size={32} />
                    <span className="text-[8px] font-black uppercase mt-1">PIX Disponível</span>
                </div>
            </div>

            {/* Chave PIX (Vertical / Compacta) */}
            <div
                onClick={handleCopyPix}
                className="w-full bg-slate-50 border border-slate-200 rounded-2xl p-4 flex flex-col items-center gap-3 cursor-pointer hover:bg-white hover:border-blue-400 transition-all active:scale-95 group/pix"
            >
                <div className="flex flex-col items-center">
                    <span className="text-[9px] font-black text-slate-400 uppercase tracking-widest mb-1 group-hover/pix:text-blue-600 transition-colors">Chave Celular</span>
                    <span className="text-xs font-black text-slate-900 tracking-tight">{displayPix}</span>
                </div>

                <div className={`w-full py-2.5 rounded-xl flex items-center justify-center gap-2 transition-all ${copied ? 'bg-green-500 text-white shadow-lg shadow-green-200' : 'bg-blue-600 text-white shadow-lg shadow-blue-100'}`}>
                    {copied ? <Check size={14} /> : <Copy size={14} />}
                    <span className="text-[11px] font-black uppercase tracking-tighter">
                        {copied ? 'Copiado!' : 'Copiar Chave'}
                    </span>
                </div>
            </div>
        </div>
    );
}
