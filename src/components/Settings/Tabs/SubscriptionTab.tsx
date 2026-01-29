import React, { useState } from 'react';
import { Users, Shield, User, Crown, Loader2, Zap } from 'lucide-react';
import { updateUserRole } from '../../../services/userService';

interface SubscriptionTabProps {
    userProfile: any;
    onRefreshProfile?: () => Promise<void>;
}

export const SubscriptionTab: React.FC<SubscriptionTabProps> = ({ userProfile, onRefreshProfile }) => {
    const [roleChangeLoading, setRoleChangeLoading] = useState(false);

    const handleToggleRole = async () => {
        if (!userProfile?.id) return;

        setRoleChangeLoading(true);
        try {
            const newRole = userProfile.role === 'manager' ? 'teacher' : 'manager';
            const { error } = await updateUserRole(userProfile.id, newRole);

            if (error) throw error;

            if (onRefreshProfile) {
                await onRefreshProfile();
            }

            alert(`Status alterado para ${newRole === 'manager' ? 'Gestor' : 'Professor'} com sucesso!`);

        } catch (err: any) {
            alert('Erro ao alterar status: ' + err.message);
        } finally {
            setRoleChangeLoading(false);
        }
    };

    return (
        <div className="space-y-8 animate-in fade-in duration-500">
            {/* Status de Login e Workspace */}
            <section className="space-y-4">
                <div className="flex items-center gap-2 text-indigo-600 font-bold text-[10px] uppercase tracking-[0.15em]">
                    <Users className="w-4 h-4" /> Status de Login e Workspace
                </div>
                <div className="bg-indigo-50 border border-indigo-100 rounded-3xl p-6">
                    <div className="flex items-center justify-between gap-4">
                        <div className="space-y-1">
                            <h4 className="font-bold text-slate-900 text-sm">Nível de Acesso</h4>
                            <div className="flex items-center gap-2">
                                <p className="text-xs text-slate-500">
                                    Seu perfil atual é:
                                </p>
                                <span className={`px-2 py-0.5 rounded text-[10px] font-black uppercase tracking-widest ${userProfile?.role === 'manager' ? 'bg-slate-900 text-white' :
                                    (userProfile?.role === 'admin' || userProfile?.is_admin) ? 'bg-red-600 text-white' :
                                        'bg-indigo-100 text-indigo-700'
                                    }`}>
                                    {userProfile?.role === 'manager' ? 'Gestor Escolar' :
                                        (userProfile?.role === 'admin' || userProfile?.is_admin) ? 'ADMINISTRADOR' : 'Professor'}
                                </span>
                            </div>
                        </div>

                        {/* Visual Indicator Only */}
                        <div className={`w-10 h-10 rounded-full flex items-center justify-center ${userProfile?.role === 'manager' ? 'bg-slate-900 text-white' :
                            (userProfile?.role === 'admin' || userProfile?.is_admin) ? 'bg-red-600 text-white' :
                                'bg-indigo-100 text-indigo-600'
                            }`}>
                            {userProfile?.role === 'manager' ? <Shield className="w-5 h-5" /> :
                                (userProfile?.role === 'admin' || userProfile?.is_admin) ? <Crown className="w-5 h-5" /> : <User className="w-5 h-5" />}
                        </div>
                    </div>
                </div>
            </section>

            {/* Placeholder for actual Subscription Upgrade Buttons if they existed */}
            {/* 
             <section className="space-y-4">
                 <div className="flex items-center gap-2 text-amber-600 font-bold text-[10px] uppercase tracking-[0.15em]">
                     <Zap className="w-4 h-4" /> Assinatura
                 </div>
                 <div className="bg-amber-50 border border-amber-100 rounded-3xl p-6 text-center">
                    <p className="text-amber-800 text-sm font-bold">Planos e Créditos</p>
                    <p className="text-xs text-amber-600 mt-2">Gerenciamento de assinatura em breve.</p>
                 </div>
             </section>
             */}
        </div>
    );
};
