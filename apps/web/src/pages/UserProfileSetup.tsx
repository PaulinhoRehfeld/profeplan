import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import SchoolSelector, { School } from '../components/SchoolSelector';
import { ProfileService } from '../services/ProfileService';
import { getUserProfile } from '../services/ProfileService'; // Use the robust service with Bypass
import { UserProfile } from '../types';
import { Loader2, Trash2, Building2 } from 'lucide-react';
import { supabase } from '../services/supabaseClient';

const UserProfileSetup: React.FC = () => {
    const [profile, setProfile] = useState<UserProfile | null>(null);
    const [loading, setLoading] = useState(true);
    const [toast, setToast] = useState<{ show: boolean, msg: string }>({ show: false, msg: '' });

    const loadProfile = async () => {
        setLoading(true);
        // Get current user ID from supabase session directly to be sure
        const { data: { session } } = await supabase.auth.getSession();

        if (session?.user?.id) {
            const data = await getUserProfile(session.user.id);
            setProfile(data);
        } else {
            // Fallback or retry?
            const data = await getUserProfile('test-supervisor-id'); // Try bypass ID if session missing (shouldn't happen if logged in)
            if (data) setProfile(data);
        }
        setLoading(false);
    };

    useEffect(() => {
        loadProfile();
    }, []);

    const navigate = useNavigate();

    const handleSchoolSelect = async (school: School) => {
        try {
            await ProfileService.linkSchool(school.id);
            showToast(`Escola ${school.name} vinculada com sucesso!`);
            await loadProfile();
            // Redirect back to dashboard after short delay or immediately
            setTimeout(() => navigate('/school-dashboard'), 1000);
        } catch (error) {
            showToast('Erro ao vincular escola.');
        }
    };

    const handleUnlink = async () => {
        try {
            await ProfileService.unlinkSchool();
            showToast('Escola desvinculada.');
            await loadProfile();
        } catch (error) {
            showToast('Erro ao desvincular escola.');
        }
    };

    const showToast = (msg: string) => {
        setToast({ show: true, msg });
        setTimeout(() => setToast({ show: false, msg: '' }), 3000);
    };

    return (
        <div className="min-h-screen bg-slate-50 p-6 md:p-12 font-sans overflow-auto">
            <div className="max-w-2xl mx-auto">
                <header className="mb-8">
                    <h1 className="text-3xl font-black text-slate-900 uppercase italic tracking-tighter">Meu Perfil</h1>
                    <p className="text-sm font-bold text-slate-400 uppercase tracking-widest mt-1">Gerencie seus dados e vínculos</p>
                </header>

                <div className="bg-white rounded-[2rem] shadow-sm border border-slate-100 p-8">
                    <h2 className="text-lg font-black text-slate-800 uppercase italic tracking-tight mb-6 flex items-center gap-2">
                        <Building2 className="text-blue-600" />
                        Dados do Educador
                    </h2>

                    {loading ? (
                        <div className="flex justify-center p-8">
                            <Loader2 className="animate-spin text-blue-500" size={32} />
                        </div>
                    ) : profile ? (
                        <div className="space-y-8">
                            <div className="p-4 bg-slate-50 rounded-2xl border border-slate-100">
                                <p className="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-1">Email Cadastrado</p>
                                <p className="font-bold text-slate-700">{profile.email}</p>
                            </div>

                            <div className="pt-6 border-t border-slate-100">
                                <p className="text-[10px] font-black text-slate-400 uppercase tracking-widest mb-4">Escola Vinculada</p>

                                {profile.school ? (
                                    <div className="bg-blue-50 p-6 rounded-2xl border border-blue-100 relative group">
                                        <div className="pr-12">
                                            <p className="font-black text-blue-900 text-lg uppercase italic">{profile.school.name}</p>
                                            <p className="text-xs font-bold text-blue-600 uppercase tracking-wide mt-1">{profile.school.city}</p>
                                        </div>
                                        <button
                                            onClick={handleUnlink}
                                            className="absolute top-4 right-4 p-2 bg-white text-red-500 rounded-xl shadow-sm hover:bg-red-50 transition-colors"
                                            title="Desvincular"
                                        >
                                            <Trash2 size={18} />
                                        </button>
                                    </div>
                                ) : (
                                    <div className="bg-yellow-50 p-4 rounded-2xl border border-yellow-100 mb-6">
                                        <p className="text-yellow-800 text-xs font-bold uppercase tracking-wide flex items-center gap-2">
                                            ⚠️ Você ainda não vinculou nenhuma escola.
                                        </p>
                                    </div>
                                )}
                            </div>

                            {!profile.school && (
                                <div className="animate-in slide-in-from-bottom-4 duration-500">
                                    <SchoolSelector onSelect={handleSchoolSelect} />
                                </div>
                            )}
                        </div>
                    ) : (
                        <div className="text-center py-8">
                            <p className="text-slate-400 font-bold">Usuário não autenticado ou erro ao carregar perfil.</p>
                        </div>
                    )}
                </div>
            </div>

            {toast.show && (
                <div className="fixed bottom-6 right-6 bg-slate-900 text-white px-6 py-4 rounded-xl shadow-2xl z-50 animate-in slide-in-from-bottom-10 fade-in duration-300">
                    <p className="text-xs font-black uppercase tracking-widest">{toast.msg}</p>
                </div>
            )}
        </div>
    );
};

export default UserProfileSetup;
