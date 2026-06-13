import React, { useState, useEffect } from 'react';
import { Shield, Plus, Search } from 'lucide-react';
import { getAllUsers, updateUserProfileAdmin } from '../../services/ProfileService';
import { UserProfile } from '../../types';
import { supabase } from '../../services/supabaseClient';
import { FeedbackReport } from '../../features/Admin/FeedbackReport';

// Subcomponents
import { UserList } from './components/UserList';
import { CreateUserModal } from './components/CreateUserModal';
import { AddCreditsModal } from './components/AddCreditsModal';
import { RagIngestionWidget } from './components/RagIngestionWidget';

export const AdminPanel: React.FC = () => {
    // === STATE ===
    const [users, setUsers] = useState<UserProfile[]>([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [editingUser, setEditingUser] = useState<UserProfile | null>(null);

    // UI Tabs
    const [activeTab, setActiveTab] = useState<'users' | 'feedback'>('users');

    // Modals
    const [isAddModalOpen, setIsAddModalOpen] = useState(false);
    const [isCreditModalOpen, setIsCreditModalOpen] = useState(false);
    const [creditUser, setCreditUser] = useState<UserProfile | null>(null);

    // School Data for CreateUserModal
    const [allSchools, setAllSchools] = useState<{ id: string, name: string, city?: string }[]>([]);
    const [cities, setCities] = useState<string[]>([]);

    useEffect(() => {
        loadUsers();
        loadSchools();
    }, []);

    // === DATA LOADERS ===
    const loadSchools = async () => {
        setLoading(true);
        try {
            let allRows: any[] = [];
            let from = 0;
            const step = 1000;
            let more = true;

            while (more) {
                const { data, error } = await supabase
                    .from('schools')
                    .select('id, name, city')
                    .order('name')
                    .range(from, from + step - 1);

                if (error) throw error;
                if (data) {
                    allRows = [...allRows, ...data];
                    if (data.length < step) more = false;
                    else from += step;
                } else more = false;
            }

            setAllSchools(allRows);
            const uniqueCities = [...new Set(allRows.map(s => s.city).filter(Boolean))] as string[];
            setCities(uniqueCities.sort());
        } catch (err) {
            console.error('[AdminPanel] Error loading schools:', err);
            alert('Erro ao carregar lista de escolas.');
        } finally {
            setLoading(false);
        }
    };

    const loadUsers = async () => {
        setLoading(true);
        const { data, error } = await getAllUsers();
        if (data) setUsers(data as UserProfile[]);
        if (error) console.error('[AdminPanel] Error loading users:', error);
        setLoading(false);
    };

    // === ACTIONS ===
    const handleUpdateUser = async (id: string, updates: Partial<UserProfile>) => {
        const { error } = await updateUserProfileAdmin(id, updates);
        if (error) alert('Falha ao atualizar: ' + error.message);
        else {
            loadUsers();
            setEditingUser(null);
        }
    };

    const handleDeleteUser = async (user: UserProfile) => {
        if (!confirm(`Tem certeza que deseja EXCLUIR o usuário ${user.email}? Essa ação é irreversível.`)) return;
        try {
            // 1. Delete profile data
            const { error: profileError } = await supabase.from('profiles').delete().eq('id', user.id);
            if (profileError) throw new Error('Erro ao deletar perfil: ' + profileError.message);

            // 2. Delete from authorized_users (legacy allowlist)
            await supabase.from('authorized_users').delete().eq('id', user.id);

            // M-2: NOTE — deleting from 'authorized_users' does NOT remove the Supabase Auth user.
            // The user will still be able to log in until their Auth entry is removed.
            // To fully delete a user, a server-side Edge Function with the service_role key is required.
            // TODO: Call /api/delete-user Edge Function here when implemented.
            console.warn('[AdminPanel] ⚠️ Auth user NOT deleted from Supabase Auth. Profile data removed only.');

            alert('Dados do usuário removidos. Nota: o login do usuário ainda existe no sistema de autenticação e deve ser removido pelo Supabase Dashboard.');
            loadUsers();
        } catch (e: any) {
            alert(e.message);
        }
    };

    return (
        <div className="flex flex-col h-full bg-slate-50 overflow-hidden">
            {/* Header Tabs */}
            <div className="h-16 bg-white border-b border-slate-200 flex items-center justify-between px-4 md:px-8 shadow-sm">
                <div className="flex items-center gap-6">
                    <div className="flex items-center gap-3">
                        <div className="p-2 bg-indigo-100 rounded-lg text-indigo-700">
                            <Shield size={24} />
                        </div>
                        <div>
                            <h1 className="text-lg font-bold text-slate-800">Painel Administrativo</h1>
                            <p className="text-xs text-slate-500">Gestão e Relatórios</p>
                        </div>
                    </div>

                    <nav className="flex bg-slate-100 p-1 rounded-lg">
                        <button
                            onClick={() => setActiveTab('users')}
                            className={`px-4 py-1.5 rounded-md text-xs font-bold uppercase tracking-wide transition-all ${activeTab === 'users' ? 'bg-white text-indigo-700 shadow-sm' : 'text-slate-500 hover:text-slate-700'}`}
                        >
                            Usuários
                        </button>
                        <button
                            onClick={() => setActiveTab('feedback')}
                            className={`px-4 py-1.5 rounded-md text-xs font-bold uppercase tracking-wide transition-all ${activeTab === 'feedback' ? 'bg-white text-emerald-700 shadow-sm' : 'text-slate-500 hover:text-slate-700'}`}
                        >
                            Relatório IA
                        </button>
                    </nav>
                </div>

                {activeTab === 'users' && (
                    <button
                        onClick={() => setIsAddModalOpen(true)}
                        className="flex-1 md:flex-none flex items-center gap-2 px-4 py-2 bg-indigo-600 text-white rounded-lg text-sm font-bold hover:bg-indigo-700 transition"
                    >
                        <Plus size={16} /> <span className="hidden md:inline">Novo Usuário</span>
                    </button>
                )}
            </div>

            {/* Content */}
            <div className="p-4 md:p-8 overflow-y-auto flex-1">
                {activeTab === 'feedback' ? (
                    <FeedbackReport />
                ) : (
                    <>
                        {/* Search */}
                        <div className="max-w-md mb-6 relative">
                            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
                            <input
                                type="text"
                                placeholder="Buscar por e-mail..."
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                                className="w-full pl-10 pr-4 py-2 bg-white border border-slate-200 rounded-lg text-sm focus:ring-2 focus:ring-indigo-100 outline-none"
                            />
                        </div>

                        {/* RAG Widget */}
                        <RagIngestionWidget />

                        {/* Users Table */}
                        <UserList
                            users={users}
                            loading={loading}
                            searchTerm={searchTerm}
                            editingUser={editingUser}
                            setEditingUser={setEditingUser}
                            onUpdateUser={handleUpdateUser}
                            onDeleteUser={handleDeleteUser}
                            onAddCredits={(u) => { setCreditUser(u); setIsCreditModalOpen(true); }}
                        />
                    </>
                )}
            </div>

            {/* Modals */}
            <CreateUserModal
                isOpen={isAddModalOpen}
                onClose={() => setIsAddModalOpen(false)}
                onUserCreated={() => { loadUsers(); }}
                allSchools={allSchools}
                cities={cities}
            />

            <AddCreditsModal
                isOpen={isCreditModalOpen}
                user={creditUser}
                onClose={() => { setIsCreditModalOpen(false); setCreditUser(null); }}
                onCreditsAdded={() => { loadUsers(); setIsCreditModalOpen(false); setCreditUser(null); }}
            />
        </div>
    );
};
