import React, { useState } from 'react';
import { Gift, Phone, Users, Check, X, Smartphone, Mail, ArrowRight, Loader2, Send } from 'lucide-react';
import { registerPhone, addReferral } from '../services/userService';

interface LowCreditModalProps {
    isOpen: boolean;
    onClose: () => void;
    currentCredits: number;
    userId: string;
    userPhone?: string; // If present, skip phone step
    onSuccess: () => void; // Trigger credit refresh
}

export const LowCreditModal: React.FC<LowCreditModalProps> = ({ isOpen, onClose, currentCredits, userId, userPhone, onSuccess }) => {
    const [step, setStep] = useState<'phone' | 'referral'>(userPhone ? 'referral' : 'phone');
    const [inputValue, setInputValue] = useState('');
    const [loading, setLoading] = useState(false);
    const [msg, setMsg] = useState<{ type: 'success' | 'error', text: string } | null>(null);

    if (!isOpen) return null;

    const handleSubmit = async () => {
        if (!inputValue.trim()) return;
        setLoading(true);
        setMsg(null);

        try {
            if (step === 'phone') {
                const res = await registerPhone(userId, inputValue);
                if (res.success) {
                    setMsg({ type: 'success', text: res.message || 'Sucesso!' });
                    onSuccess();
                    // Wait 2s then move to referral
                    setTimeout(() => {
                        setStep('referral');
                        setInputValue('');
                        setMsg(null);
                    }, 2000);
                } else {
                    setMsg({ type: 'error', text: res.message || 'Erro ao salvar.' });
                }
            } else {
                // Referral
                const res = await addReferral(userId, inputValue);
                if (res.success) {
                    setMsg({ type: 'success', text: res.message || 'Indicação enviada!' });
                    onSuccess(); // Maybe not needed for referral but nice to refresh
                    setTimeout(() => {
                        onClose();
                    }, 2500);
                } else {
                    setMsg({ type: 'error', text: res.message || 'Erro ao enviar.' });
                }
            }
        } catch (error: any) {
            setMsg({ type: 'error', text: 'Erro inesperado: ' + error.message });
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-300">
            <div className="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden relative animate-in zoom-in-95 duration-300">
                {/* Close Button */}
                <button
                    onClick={onClose}
                    className="absolute top-4 right-4 p-1 text-slate-300 hover:text-slate-500 transition-colors"
                >
                    <X size={20} />
                </button>

                {/* Header with Gradient */}
                <div className={`p-6 text-white text-center relative overflow-hidden ${step === 'phone' ? 'bg-gradient-to-br from-indigo-500 to-purple-600' : 'bg-gradient-to-br from-emerald-500 to-teal-600'}`}>
                    <div className="absolute top-[-50%] left-[-50%] w-[200%] h-[200%] bg-white/10 rotate-12 pointer-events-none"></div>

                    <div className="relative z-10 flex flex-col items-center">
                        <div className="w-16 h-16 bg-white/20 rounded-full flex items-center justify-center mb-3 backdrop-blur-md shadow-inner">
                            {step === 'phone' ? <Smartphone size={32} /> : <Users size={32} />}
                        </div>
                        <h2 className="text-xl font-black uppercase tracking-tight mb-1">
                            {currentCredits > 0 ? `Apenas ${currentCredits} Créditos Restantes!` : 'Seus créditos acabaram!'}
                        </h2>
                        <p className="text-xs font-medium text-white/90 max-w-[80%] leading-relaxed">
                            {step === 'phone'
                                ? 'Não pare agora! Cadastre seu celular e ganhe 10 créditos instantâneos como cortesia.'
                                : 'Ajude um colega e ganhe mais! Indique o Profeplan e ganhe +10 créditos quando ele se cadastrar.'}
                        </p>
                    </div>
                </div>

                {/* Body */}
                <div className="p-6 bg-slate-50">
                    {msg && (
                        <div className={`mb-4 p-3 rounded-lg text-xs font-bold text-center animate-in slide-in-from-top-2 ${msg.type === 'success' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}`}>
                            {msg.text}
                        </div>
                    )}

                    <div className="space-y-4">
                        <div>
                            <label className="block text-[10px] font-black uppercase tracking-widest text-slate-400 mb-1.5 ml-1">
                                {step === 'phone' ? 'Seu Número de Celular (WhatsApp/PIX)' : 'E-mail do Colega (Professor)'}
                            </label>
                            <div className="relative">
                                <div className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">
                                    {step === 'phone' ? <Phone size={16} /> : <Mail size={16} />}
                                </div>
                                <input
                                    type={step === 'phone' ? 'tel' : 'email'}
                                    value={inputValue}
                                    onChange={(e) => setInputValue(e.target.value)}
                                    placeholder={step === 'phone' ? '(XX) 99999-9999' : 'colega@escola.com'}
                                    className="w-full pl-10 pr-4 py-3 rounded-xl border border-slate-200 bg-white text-sm font-bold text-slate-700 focus:ring-2 focus:ring-indigo-100 outline-none transition-all shadow-sm"
                                />
                            </div>
                        </div>

                        <button
                            onClick={handleSubmit}
                            disabled={loading || !inputValue}
                            className={`w-full py-3.5 rounded-xl text-white text-sm font-black uppercase tracking-widest shadow-lg flex items-center justify-center gap-2 transition-all active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed ${step === 'phone'
                                ? 'bg-indigo-600 hover:bg-indigo-700 shadow-indigo-200'
                                : 'bg-emerald-600 hover:bg-emerald-700 shadow-emerald-200'
                                }`}
                        >
                            {loading ? <Loader2 className="animate-spin" size={18} /> : ((step === 'phone' ? <Gift size={18} /> : <Send size={18} />))}
                            {step === 'phone' ? 'Resgatar 10 Créditos' : 'Indicar e Ganhar +10'}
                        </button>

                        {step === 'phone' && (
                            <button
                                onClick={() => setStep('referral')}
                                className="w-full text-center text-[10px] font-bold text-slate-400 hover:text-indigo-600 transition-colors uppercase tracking-wider"
                            >
                                Já cadastrei, quero indicar um amigo <ArrowRight size={10} className="inline ml-0.5" />
                            </button>
                        )}
                    </div>
                </div>
            </div>
        </div>
    );
};
