import React from 'react';
import { Mail, RefreshCw, LogOut, ShieldAlert } from 'lucide-react';

interface VerifyEmailProps {
    userEmail: string;
    onLogout: () => void;
}

const VerifyEmail: React.FC<VerifyEmailProps> = ({ userEmail, onLogout }) => {
    return (
        <div className="min-h-screen bg-slate-50 flex flex-col items-center justify-center p-4">
            <div className="bg-white max-w-md w-full rounded-2xl shadow-xl p-8 text-center animate-in fade-in zoom-in duration-500">

                <div className="w-20 h-20 bg-amber-100 rounded-full flex items-center justify-center mx-auto mb-6">
                    <Mail size={40} className="text-amber-600" />
                </div>

                <h1 className="text-2xl font-black text-slate-800 mb-2">Verifique seu Email</h1>

                <p className="text-slate-600 mb-6 leading-relaxed">
                    Para garantir a segurança da sua conta, precisamos que você confirme seu endereço de email.
                </p>

                <div className="bg-blue-50 border border-blue-100 rounded-xl p-4 mb-8">
                    <p className="text-xs text-blue-600 uppercase font-bold tracking-wider mb-1">Enviamos um link para</p>
                    <p className="text-lg font-bold text-blue-900 break-all">{userEmail}</p>
                </div>

                <div className="space-y-3">
                    <button
                        onClick={() => window.location.reload()}
                        className="w-full py-3 bg-blue-600 hover:bg-blue-500 text-white font-bold rounded-xl shadow-lg shadow-blue-500/20 transition-all flex items-center justify-center gap-2"
                    >
                        <RefreshCw size={18} />
                        Já confirmei meu email
                    </button>

                    <button
                        onClick={onLogout}
                        className="w-full py-3 bg-white border-2 border-slate-200 hover:bg-slate-50 text-slate-600 font-bold rounded-xl transition-all flex items-center justify-center gap-2"
                    >
                        <LogOut size={18} />
                        Sair / Trocar Email
                    </button>
                </div>

                <p className="text-xs text-slate-400 mt-8">
                    Não recebeu? Verifique sua caixa de Spam ou Lixo Eletrônico.
                </p>
            </div>
        </div>
    );
};

export default VerifyEmail;
