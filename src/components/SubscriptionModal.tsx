
import React, { useState } from 'react';
import { X, Check, CreditCard, Zap, Crown, ShieldCheck } from 'lucide-react';
import { createCheckoutSession } from '../services/stripeService';
import type { UserProfile } from '../types';

// Replace these with your actual Stripe Price IDs (starting with price_...)
// You can find these inside the Products: 
// SILVER (Credits): prod_TkuQ7BqvkRoU3N
// GOLD (Subscription): prod_TkuTMOoQHPPY6V
const PAYMENT_LINKS = {
    SILVER_LINK: 'https://buy.stripe.com/7sY5kD88Gb5z3aA4qLfbq05',
    GOLD_LINK: 'https://buy.stripe.com/00w00j3Sq7TnaD25uPfbq04'
};

interface SubscriptionModalProps {
    isOpen: boolean;
    onClose: () => void;
    userProfile: UserProfile | null;
}

const SubscriptionModal: React.FC<SubscriptionModalProps> = ({ isOpen, onClose, userProfile }) => {
    const [loading, setLoading] = useState<string | null>(null);
    const [error, setError] = useState('');

    if (!isOpen) return null;

    const handlePurchase = async (planType: 'gold' | 'silver') => {
        if (!userProfile) return;
        setLoading(planType);
        setError('');

        try {
            const link = planType === 'gold' ? PAYMENT_LINKS.GOLD_LINK : PAYMENT_LINKS.SILVER_LINK;
            // Construct dynamic URL with client_reference_id (userId) and prefilled_email
            const paymentUrl = `${link}?client_reference_id=${userProfile.id}&prefilled_email=${userProfile.email}`;

            // Redirect to Stripe
            window.location.href = paymentUrl;

        } catch (err: any) {
            setError(err.message || 'Erro ao iniciar pagamento');
            setLoading(null);
        }
    };

    return (
        <div className="fixed inset-0 bg-slate-900/80 backdrop-blur-sm z-[100] flex items-center justify-center p-4">
            <div className="bg-white rounded-3xl w-full max-w-4xl max-h-[90vh] overflow-y-auto shadow-2xl animate-in fade-in zoom-in duration-300">
                <div className="p-6 border-b border-slate-100 flex justify-between items-center sticky top-0 bg-white z-10">
                    <div>
                        <h2 className="text-2xl font-black text-slate-900 tracking-tight">Planos & Créditos</h2>
                        <p className="text-slate-500 font-medium text-sm">Escolha a melhor opção para sua jornada pedagógica</p>
                    </div>
                    <button onClick={onClose} className="p-2 hover:bg-slate-100 rounded-full transition-colors">
                        <X className="w-6 h-6 text-slate-400" />
                    </button>
                </div>

                <div className="p-6 md:p-10 grid grid-cols-1 md:grid-cols-3 gap-6">
                    {/* FREE / CURRENT */}
                    <div className="border border-slate-200 rounded-2xl p-6 flex flex-col items-center text-center relative overflow-hidden">
                        <div className="absolute top-0 w-full h-1 bg-slate-300"></div>
                        <h3 className="font-black text-slate-400 uppercase tracking-widest text-sm mb-4">Atual</h3>
                        <div className="mb-4 p-4 bg-slate-50 rounded-full">
                            <ShieldCheck className="w-8 h-8 text-slate-400" />
                        </div>
                        <h4 className="text-xl font-bold text-slate-700 mb-2">Básico</h4>
                        <p className="text-slate-500 text-sm mb-6 flex-1">Plano de entrada para conhecer a plataforma.</p>
                        <ul className="text-left space-y-3 mb-8 w-full">
                            <li className="flex items-center gap-2 text-sm text-slate-600"><Check size={16} className="text-green-500" /> 10 Créditos Iniciais</li>
                            <li className="flex items-center gap-2 text-sm text-slate-600"><Check size={16} className="text-green-500" /> Acesso ao Chat</li>
                        </ul>
                        <button disabled className="w-full py-3 bg-slate-100 text-slate-400 font-bold rounded-xl cursor-not-allowed">
                            Plano Atual
                        </button>
                    </div>

                    {/* CREDITS PACKS */}
                    <div className="border border-blue-200 bg-blue-50/30 rounded-2xl p-6 flex flex-col items-center text-center relative overflow-hidden">
                        <div className="absolute top-0 w-full h-1 bg-blue-500"></div>
                        <div className="absolute top-3 right-3 bg-blue-100 text-blue-600 text-[10px] font-bold px-2 py-1 rounded-full uppercase">Flexível</div>
                        <h3 className="font-black text-blue-500 uppercase tracking-widest text-sm mb-4">Pacote de Créditos</h3>
                        <div className="mb-4 p-4 bg-blue-100 rounded-full">
                            <Zap className="w-8 h-8 text-blue-600" />
                        </div>
                        <h4 className="text-xl font-bold text-slate-900 mb-2">Profeplan Silver</h4>
                        <p className="text-slate-500 text-sm mb-6 flex-1">Flexibilidade e produtividade sob medida.</p>

                        <div className="w-full space-y-3">
                            <button
                                onClick={() => handlePurchase('silver')}
                                disabled={!!loading}
                                className="w-full py-3 bg-white border border-blue-200 hover:border-blue-500 hover:shadow-md text-slate-700 font-bold rounded-xl transition-all flex items-center justify-between px-4"
                            >
                                <span>40 Créditos</span>
                                <span className="text-blue-600">R$ 30,00</span>
                            </button>
                        </div>
                        {loading === 'silver' && (
                            <p className="text-xs text-blue-500 font-bold mt-2 animate-pulse">Redirecionando...</p>
                        )}
                    </div>

                    {/* GOLD */}
                    <div className="border border-amber-500 bg-amber-50 rounded-2xl p-6 flex flex-col items-center text-center relative overflow-hidden transform md:-translate-y-4 shadow-xl">
                        <div className="absolute top-0 w-full h-1 bg-gradient-to-r from-amber-400 to-amber-600"></div>
                        <div className="absolute top-3 right-3 bg-amber-100 text-amber-700 text-[10px] font-bold px-2 py-1 rounded-full uppercase flex items-center gap-1">
                            <Crown size={10} /> Recomendado
                        </div>
                        <h3 className="font-black text-amber-600 uppercase tracking-widest text-sm mb-4">Assinatura</h3>
                        <div className="mb-4 p-4 bg-gradient-to-br from-amber-400 to-amber-600 rounded-full shadow-lg shadow-amber-500/30">
                            <Crown className="w-8 h-8 text-white" />
                        </div>
                        <h4 className="text-xl font-bold text-slate-900 mb-2">Profeplan Gold</h4>
                        <p className="text-amber-800/70 text-sm mb-6 flex-1">Produtividade sem limites. IA Ilimitada.</p>
                        <ul className="text-left space-y-3 mb-8 w-full">
                            <li className="flex items-center gap-2 text-sm text-slate-700"><Check size={16} className="text-amber-500" /> <b>Gerações Ilimitadas</b></li>
                            <li className="flex items-center gap-2 text-sm text-slate-700"><Check size={16} className="text-amber-500" /> Tutoria Personalizada</li>
                            <li className="flex items-center gap-2 text-sm text-slate-700"><Check size={16} className="text-amber-500" /> Acesso Antecipado a Features</li>
                        </ul>
                        <button
                            onClick={() => handlePurchase('gold')}
                            disabled={!!loading}
                            className="w-full py-4 bg-gradient-to-r from-amber-500 to-amber-600 hover:from-amber-400 hover:to-amber-500 text-white font-black rounded-xl shadow-xl shadow-amber-600/20 transition-all transform active:scale-[0.98]"
                        >
                            {loading === 'gold' ? 'Processando...' : 'Assinar Agora - R$ 50/mês'}
                        </button>
                        <p className="text-[10px] text-amber-700/60 mt-3 font-medium">Cancele quando quiser.</p>
                    </div>
                </div>

                {error && (
                    <div className="px-6 pb-6">
                        <div className="p-4 bg-red-50 text-red-500 rounded-xl text-sm font-bold text-center border border-red-100">
                            {error}
                        </div>
                    </div>
                )}
            </div>
        </div>
    );
};

export default SubscriptionModal;
