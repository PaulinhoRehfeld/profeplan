import React, { useState, useEffect } from 'react';
import { Copy, Check } from 'lucide-react';

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
        <div className="bg-blue-600/10 border border-blue-500/20 rounded-2xl p-4 flex flex-col items-center text-center shadow-xl w-full mx-auto my-4 animate-in fade-in slide-in-from-bottom-4 duration-500">
            {/* Texto Rotativo */}
            <h4 className="font-black text-blue-400 text-xs mb-2 uppercase tracking-tight">{currentMessage.title}</h4>
            <p className="text-slate-400 text-[10px] leading-relaxed mb-4 font-medium">
                {currentMessage.text}
            </p>

            {/* QR Code */}
            <div className="bg-white p-2 rounded-xl shadow-inner border border-white/10 mb-4 w-28 h-28 flex items-center justify-center overflow-hidden">
                <img
                    src="/donation-qr-code.png"
                    alt="QR Code PIX Itaú"
                    className="w-full h-full object-contain"
                />
            </div>

            {/* Área da Chave PIX Copiável */}
            <div className="w-full bg-slate-900/50 border border-white/5 rounded-xl p-2 flex items-center justify-between shadow-lg">
                <div className="flex flex-col items-start pl-1">
                    <span className="text-[8px] font-black text-slate-500 uppercase tracking-widest leading-none mb-1">Chave PIX (Celular)</span>
                    <span className="text-xs font-bold text-white leading-none">{displayPix}</span>
                </div>

                <button
                    onClick={handleCopyPix}
                    className={`p-1.5 rounded-lg transition-all active:scale-90 ${copied ? 'bg-green-500 text-white' : 'bg-blue-600 text-white hover:bg-blue-500'
                        }`}
                    title="Copiar PIX"
                >
                    {copied ? <Check size={14} /> : <Copy size={14} />}
                </button>
            </div>

            {copied && (
                <span className="text-green-500 text-[8px] mt-2 font-black uppercase tracking-tighter animate-pulse">
                    Chave copiada!
                </span>
            )}
        </div>
    );
}
