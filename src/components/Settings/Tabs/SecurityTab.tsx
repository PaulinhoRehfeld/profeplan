import React, { useState } from 'react';
import { Shield, Loader2, AlertCircle, CheckCircle2 } from 'lucide-react';
import { supabase } from '../../../services/supabaseClient';

interface SecurityTabProps {
    userEmail: string;
}

export const SecurityTab: React.FC<SecurityTabProps> = ({ userEmail }) => {
    const [newPassword, setNewPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const [passwordChangeLoading, setPasswordChangeLoading] = useState(false);
    const [passwordChangeError, setPasswordChangeError] = useState('');
    const [passwordChangeSuccess, setPasswordChangeSuccess] = useState(false);

    const handleChangePassword = async () => {
        setPasswordChangeLoading(true);
        setPasswordChangeError('');
        setPasswordChangeSuccess(false);

        if (!newPassword.trim()) {
            setPasswordChangeError('A nova senha não pode ser vazia.');
            setPasswordChangeLoading(false);
            return;
        }

        if (newPassword !== confirmPassword) {
            setPasswordChangeError('As senhas não coincidem.');
            setPasswordChangeLoading(false);
            return;
        }

        try {
            const { error } = await supabase
                .from('authorized_users')
                .update({ access_key: newPassword })
                .eq('email', userEmail);

            if (error) throw error;

            setPasswordChangeSuccess(true);
            setNewPassword('');
            setConfirmPassword('');
            setTimeout(() => setPasswordChangeSuccess(false), 3000);
        } catch (err: any) {
            setPasswordChangeError('Erro ao atualizar senha: ' + err.message);
        } finally {
            setPasswordChangeLoading(false);
        }
    };

    return (
        <section className="space-y-4 animate-in fade-in duration-500">
            <div className="flex items-center gap-2 text-blue-600 font-bold text-[10px] uppercase tracking-[0.15em]">
                <Shield className="w-4 h-4" /> Segurança da Conta
            </div>
            <div className="bg-slate-50 border border-slate-200 rounded-2xl p-6 space-y-4">
                <h4 className="font-bold text-slate-900">Alterar Chave de Acesso</h4>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div className="space-y-1.5">
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Nova Senha</label>
                        <input
                            type="password"
                            value={newPassword}
                            onChange={(e) => setNewPassword(e.target.value)}
                            className="w-full px-5 py-3 bg-white border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                            placeholder="••••••••"
                        />
                    </div>
                    <div className="space-y-1.5">
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Confirmar Senha</label>
                        <input
                            type="password"
                            value={confirmPassword}
                            onChange={(e) => setConfirmPassword(e.target.value)}
                            className="w-full px-5 py-3 bg-white border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                            placeholder="••••••••"
                        />
                    </div>
                </div>

                {passwordChangeError && (
                    <div className="flex items-start gap-3 p-3 bg-red-500/10 border border-red-500/20 rounded-xl">
                        <AlertCircle className="w-4 h-4 text-red-400 shrink-0 mt-0.5" />
                        <p className="text-red-400 text-xs font-bold leading-tight">{passwordChangeError}</p>
                    </div>
                )}
                {passwordChangeSuccess && (
                    <div className="flex items-start gap-3 p-3 bg-emerald-500/10 border border-emerald-500/20 rounded-xl">
                        <CheckCircle2 className="w-4 h-4 text-emerald-400 shrink-0 mt-0.5" />
                        <p className="text-emerald-400 text-xs font-bold leading-tight">Senha alterada com sucesso!</p>
                    </div>
                )}

                <button
                    onClick={handleChangePassword}
                    disabled={passwordChangeLoading || !newPassword.trim() || !confirmPassword.trim()}
                    className="w-full px-6 py-3 bg-blue-600 text-white rounded-xl font-black text-[10px] uppercase tracking-widest transition-all hover:bg-blue-700 flex items-center justify-center gap-2 disabled:opacity-50"
                >
                    {passwordChangeLoading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Shield className="w-4 h-4" />}
                    {passwordChangeLoading ? 'Alterando...' : 'Alterar Senha'}
                </button>
            </div>
        </section>
    );
};
