import React, { useState, useEffect } from 'react';
import { Loader2 } from 'lucide-react';
import { UserProfile, getAllUsers, updateUserProfileAdmin, addUserCredits } from '../../services/userService';
import { Shield, Plus, Edit, Check, X, Search, Coins, Crown, Trash2, Upload, FileText, Database } from 'lucide-react';
import { supabase } from '../../services/supabaseClient';
import { ingestFiles, clearExistingSource } from '../../services/ingestionService';

export const AdminPanel: React.FC = () => {
    const [users, setUsers] = useState<UserProfile[]>([]);
    const [loading, setLoading] = useState(true);
    const [searchTerm, setSearchTerm] = useState('');
    const [editingUser, setEditingUser] = useState<UserProfile | null>(null);
    const [isAddModalOpen, setIsAddModalOpen] = useState(false);

    // Add User Form State
    const [newUserEmail, setNewUserEmail] = useState('');
    const [newUserPass, setNewUserPass] = useState('123456');
    const [newUserTier, setNewUserTier] = useState<'SILVER' | 'GOLD'>('SILVER');
    const [newUserCredits, setNewUserCredits] = useState(10);

    // Add Credits Modal State
    const [isCreditModalOpen, setIsCreditModalOpen] = useState(false);
    const [creditUser, setCreditUser] = useState<UserProfile | null>(null);
    const [creditAmount, setCreditAmount] = useState(10);

    // Database Update State
    const [isUpdatingDb, setIsUpdatingDb] = useState(false);
    const [updateProgress, setUpdateProgress] = useState(0);
    const [updateStatus, setUpdateStatus] = useState('');
    const fileInputRef = React.useRef<HTMLInputElement>(null);

    useEffect(() => {
        loadUsers();
    }, []);

    const loadUsers = async () => {
        setLoading(true);
        const { data } = await getAllUsers();
        if (data) setUsers(data as UserProfile[]);
        setLoading(false);
    };

    const handleUpdateUser = async (id: string, updates: Partial<UserProfile>) => {
        const { error } = await updateUserProfileAdmin(id, updates);
        if (error) alert('Falha ao atualizar: ' + error.message);
        else {
            loadUsers();
            setEditingUser(null);
        }
    };

    const handleCreateUser = async () => {
        if (!newUserEmail || !newUserPass) return alert('Preencha E-mail e Senha');

        try {
            // 1. Insert into custom auth table (authorized_users)
            // This bypasses Supabase Auth rate limits and matches LoginScreen logic
            const { data: authUser, error: authError } = await supabase
                .from('authorized_users')
                .insert({
                    email: newUserEmail,
                    access_key: newUserPass, // Using password input as access_key
                    role: 'TEACHER' // Default role
                })
                .select()
                .single();

            if (authError) throw new Error('Erro ao criar login: ' + authError.message);
            if (!authUser) throw new Error('Erro ao obter ID do usuário criado.');

            // 2. Insert into profiles with the same ID
            const { error: profileError } = await supabase.from('profiles').insert({
                id: authUser.id,
                email: newUserEmail,
                tier: newUserTier,
                credits: newUserCredits,
                is_unlimited: newUserTier === 'GOLD',
                is_admin: false,
                allowed_features: ['all']
            });

            if (profileError) {
                console.error("Erro ao criar perfil:", profileError);
                throw new Error('Login criado, mas perfil falhou: ' + profileError.message);
            }

            alert('Usuário criado com sucesso! Use a senha informada como Chave de Acesso.');
            setIsAddModalOpen(false);

            // Clear Form
            setNewUserEmail('');
            setNewUserPass('123456');
            setNewUserCredits(10);

            loadUsers();
        } catch (e: any) {
            alert('Erro: ' + e.message);
        }
    };
    const handleIncrementCredits = async () => {
        if (!creditUser) return;
        const res = await addUserCredits(creditUser.id, creditAmount);
        if (res.error) {
            alert('Erro ao adicionar créditos: ' + res.error.message);
        } else {
            alert('Créditos adicionados com sucesso!');
            setIsCreditModalOpen(false);
            setCreditUser(null);
            setCreditAmount(10);
            loadUsers();
        }
    };

    const handleDeleteUser = async (user: UserProfile) => {
        if (!confirm(`Tem certeza que deseja EXCLUIR o usuário ${user.email}? Essa ação é irreversível.`)) return;

        try {
            // 1. Delete from profiles
            const { error: profileError } = await supabase.from('profiles').delete().eq('id', user.id);
            if (profileError) console.error("Erro ao deletar perfil:", profileError); // Continue to delete login

            // 2. Delete from authorized_users (Login)
            const { error: authError } = await supabase.from('authorized_users').delete().eq('id', user.id);
            if (authError) throw new Error("Erro ao deletar login: " + authError.message);

            alert('Usuário excluído com sucesso.');
            loadUsers();
        } catch (e: any) {
            alert(e.message);
        }
    };

    const handleFileSelect = async (e: React.ChangeEvent<HTMLInputElement>) => {
        const files = e.target.files;
        if (!files || files.length === 0) return;

        if (!confirm(`Deseja processar ${files.length} arquivos para o Banco de Dados?\nIsso pode levar alguns minutos.`)) {
            if (fileInputRef.current) fileInputRef.current.value = '';
            return;
        }

        setIsUpdatingDb(true);
        setUpdateProgress(0);
        setUpdateStatus('Iniciando...');

        try {
            const fileArray = Array.from(files);
            const filenames = fileArray.map(f => f.name);

            // 1. Limpar versões antigas
            setUpdateStatus('Limpando versões anteriores...');
            await clearExistingSource(filenames);

            // 2. Ingerir
            await ingestFiles(fileArray, (current, total, msg) => {
                setUpdateProgress((current / total) * 100);
                setUpdateStatus(msg);
            });

            alert('Banco de Dados Atualizado com Sucesso!');
        } catch (error: any) {
            console.error(error);
            alert('Falha na atualização: ' + error.message);
        } finally {
            setIsUpdatingDb(false);
            setUpdateStatus('');
            if (fileInputRef.current) fileInputRef.current.value = '';
        }
    };

    const triggerFileInput = () => {
        fileInputRef.current?.click();
    };

    const filteredUsers = users.filter(u => u.email?.toLowerCase().includes(searchTerm.toLowerCase()));

    return (
        <div className="flex flex-col h-full bg-slate-50 overflow-hidden">
            {/* Header */}
            <div className="h-16 bg-white border-b border-slate-200 flex items-center justify-between px-8 shadow-sm">
                <div className="flex items-center gap-3">
                    <div className="p-2 bg-indigo-100 rounded-lg text-indigo-700">
                        <Shield size={24} />
                    </div>
                    <div>
                        <h1 className="text-lg font-bold text-slate-800">Painel Administrativo</h1>
                        <p className="text-xs text-slate-500">Gestão de Usuários e Créditos</p>
                    </div>
                </div>
                <button
                    onClick={() => setIsAddModalOpen(true)}
                    className="flex items-center gap-2 px-4 py-2 bg-indigo-600 text-white rounded-lg text-sm font-bold hover:bg-indigo-700 transition"
                >
                    <Plus size={16} /> Novo Usuário
                </button>
            </div>

            {/* Content */}
            <div className="p-8 overflow-y-auto">
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

                {/* Database Update Section */}
                <div className="mb-8 bg-indigo-50 border border-indigo-100 rounded-xl p-6 flex flex-col md:flex-row items-center justify-between gap-4">
                    <div>
                        <h3 className="font-bold text-indigo-900 flex items-center gap-2">
                            <Database size={20} />
                            Atualização de Currículo (RAG)
                        </h3>
                        <p className="text-sm text-indigo-700 mt-1">
                            Carregue novos arquivos Markdown (.md) para atualizar o conhecimento da IA.
                            O sistema detecta automaticamente mudanças nos arquivos.
                        </p>
                    </div>

                    <div className="flex flex-col items-end gap-2">
                        <input
                            type="file"
                            multiple
                            accept=".md"
                            ref={fileInputRef}
                            className="hidden"
                            onChange={handleFileSelect}
                        />
                        <button
                            onClick={triggerFileInput}
                            disabled={isUpdatingDb}
                            className="flex items-center gap-2 px-5 py-2.5 bg-indigo-600 text-white rounded-lg font-bold shadow-md hover:bg-indigo-700 disabled:opacity-50 transition"
                        >
                            {isUpdatingDb ? <Loader2 className="animate-spin" size={20} /> : <Upload size={20} />}
                            {isUpdatingDb ? 'Processando...' : 'Atualizar Banco de Dados'}
                        </button>
                        {isUpdatingDb && (
                            <div className="w-full max-w-[200px]">
                                <div className="h-2 bg-indigo-200 rounded-full overflow-hidden">
                                    <div className="h-full bg-indigo-600 transition-all duration-300" style={{ width: `${updateProgress}%` }}></div>
                                </div>
                                <p className="text-[10px] text-indigo-600 text-right mt-1 font-mono">{updateStatus}</p>
                            </div>
                        )}
                    </div>
                </div>

                {/* Table */}
                <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
                    <table className="w-full text-left border-collapse">
                        <thead className="bg-slate-50 border-b border-slate-200 text-xs uppercase text-slate-500 font-bold">
                            <tr>
                                <th className="px-6 py-4">Usuário</th>
                                <th className="px-6 py-4">Nível (Tier)</th>
                                <th className="px-6 py-4">Saldo de Créditos</th>
                                <th className="px-6 py-4 text-center">Ações</th>
                            </tr>
                        </thead>
                        <tbody className="text-sm divide-y divide-slate-100">
                            {loading ? (
                                <tr><td colSpan={4} className="px-6 py-8 text-center text-slate-400">Carregando...</td></tr>
                            ) : filteredUsers.length === 0 ? (
                                <tr><td colSpan={4} className="px-6 py-8 text-center text-slate-400">Nenhum usuário encontrado.</td></tr>
                            ) : (
                                filteredUsers.map(user => (
                                    <tr key={user.id} className="hover:bg-slate-50 transition">
                                        <td className="px-6 py-4 font-medium text-slate-700">
                                            {user.email}
                                            {user.is_admin && <span className="ml-2 px-2 py-0.5 bg-purple-100 text-purple-700 text-[10px] rounded-full uppercase font-bold">Admin</span>}
                                        </td>
                                        <td className="px-6 py-4">
                                            {editingUser?.id === user.id ? (
                                                <select
                                                    className="border rounded px-2 py-1 text-xs"
                                                    value={editingUser.tier}
                                                    onChange={(e) => setEditingUser({ ...editingUser, tier: e.target.value as any })}
                                                >
                                                    <option value="SILVER">SILVER</option>
                                                    <option value="GOLD">GOLD</option>
                                                </select>
                                            ) : (
                                                <span className={`inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wide ${user.tier === 'GOLD' || user.is_unlimited ? 'bg-amber-100 text-amber-700' : 'bg-slate-100 text-slate-600'}`}>
                                                    {user.tier === 'GOLD' || user.is_unlimited ? <Crown size={12} /> : null}
                                                    {user.tier || 'SILVER'}
                                                </span>
                                            )}
                                        </td>
                                        <td className="px-6 py-4 font-mono font-bold text-slate-600">
                                            {editingUser?.id === user.id ? (
                                                <input
                                                    type="number"
                                                    className="w-20 border rounded px-2 py-1 text-xs"
                                                    value={editingUser.credits}
                                                    onChange={(e) => setEditingUser({ ...editingUser, credits: parseInt(e.target.value) })}
                                                />
                                            ) : (
                                                user.is_unlimited ? '∞ (Ilimitado)' : `${user.credits} CR`
                                            )}
                                        </td>
                                        <td className="px-6 py-4 text-center">
                                            {editingUser?.id === user.id ? (
                                                <div className="flex items-center justify-center gap-2">
                                                    <button onClick={() => handleUpdateUser(user.id, { tier: editingUser.tier, credits: editingUser.credits, is_unlimited: editingUser.tier === 'GOLD' })} className="p-1.5 bg-green-100 text-green-700 rounded hover:bg-green-200"><Check size={16} /></button>
                                                    <button onClick={() => setEditingUser(null)} className="p-1.5 bg-red-100 text-red-700 rounded hover:bg-red-200"><X size={16} /></button>
                                                </div>
                                            ) : (
                                                <div className="flex items-center gap-1">
                                                    <button onClick={() => setEditingUser(user)} className="p-1.5 text-slate-400 hover:text-indigo-600 hover:bg-indigo-50 rounded transition" title="Editar">
                                                        <Edit size={16} />
                                                    </button>
                                                    {!user.is_admin && (
                                                        <button onClick={() => handleDeleteUser(user)} className="p-1.5 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded transition" title="Excluir">
                                                            <Trash2 size={16} />
                                                        </button>
                                                    )}

                                                    <button
                                                        onClick={() => {
                                                            setCreditUser(user);
                                                            setIsCreditModalOpen(true);
                                                        }}
                                                        className="p-1.5 text-slate-400 hover:text-amber-600 hover:bg-amber-50 rounded transition"
                                                        title="Adicionar Créditos"
                                                    >
                                                        <Coins size={16} />
                                                    </button>
                                                </div>
                                            )}
                                        </td>
                                    </tr>
                                ))
                            )}
                        </tbody>
                    </table>
                </div>
            </div>

            {/* Add User Modal */}
            {isAddModalOpen && (
                <div className="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4 backdrop-blur-sm">
                    <div className="bg-white rounded-2xl shadow-2xl w-full max-w-md p-6 animate-in zoom-in-95 duration-200">
                        <h2 className="text-xl font-bold text-slate-800 mb-4">Adicionar Novo Usuário</h2>
                        <div className="space-y-4">
                            <div>
                                <label className="block text-xs font-bold text-slate-500 uppercase mb-1">E-mail</label>
                                <input type="email" value={newUserEmail} onChange={e => setNewUserEmail(e.target.value)} className="w-full px-4 py-2 border rounded-lg" />
                            </div>
                            <div>
                                <label className="block text-xs font-bold text-slate-500 uppercase mb-1">Senha Inicial</label>
                                <input type="text" value={newUserPass} onChange={e => setNewUserPass(e.target.value)} className="w-full px-4 py-2 border rounded-lg" />
                            </div>
                            <div className="grid grid-cols-2 gap-4">
                                <div>
                                    <label className="block text-xs font-bold text-slate-500 uppercase mb-1">Nível</label>
                                    <select value={newUserTier} onChange={(e: any) => setNewUserTier(e.target.value)} className="w-full px-4 py-2 border rounded-lg">
                                        <option value="SILVER">SILVER</option>
                                        <option value="GOLD">GOLD</option>
                                    </select>
                                </div>
                                <div>
                                    <label className="block text-xs font-bold text-slate-500 uppercase mb-1">Créditos Iniciais</label>
                                    <input type="number" disabled={newUserTier === 'GOLD'} value={newUserCredits} onChange={e => setNewUserCredits(parseInt(e.target.value))} className="w-full px-4 py-2 border rounded-lg disabled:opacity-50" />
                                </div>
                            </div>
                        </div>
                        <div className="flex gap-3 mt-8">
                            <button onClick={() => setIsAddModalOpen(false)} className="flex-1 py-3 bg-slate-100 text-slate-600 font-bold rounded-xl hover:bg-slate-200">Cancelar</button>
                            <button onClick={handleCreateUser} className="flex-1 py-3 bg-indigo-600 text-white font-bold rounded-xl hover:bg-indigo-700">Criar Usuário</button>
                        </div>
                    </div>
                </div>
            )}

            {/* Add Credits Modal */}
            {isCreditModalOpen && creditUser && (
                <div className="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4 backdrop-blur-sm">
                    <div className="bg-white rounded-2xl shadow-2xl w-full max-w-sm p-6 animate-in zoom-in-95 duration-200">
                        <div className="bg-amber-100 w-12 h-12 rounded-full flex items-center justify-center mb-4 mx-auto text-amber-600">
                            <Coins size={24} />
                        </div>
                        <h2 className="text-xl font-bold text-slate-800 mb-2 text-center">Adicionar Créditos</h2>
                        <p className="text-sm text-slate-500 text-center mb-6">
                            Para: <span className="font-bold text-slate-700">{creditUser.email}</span>
                            <br />
                            Saldo Atual: {creditUser.credits}
                        </p>

                        <div className="space-y-4">
                            <div>
                                <label className="block text-xs font-bold text-slate-500 uppercase mb-1">Quantidade a Adicionar</label>
                                <input
                                    type="number"
                                    min="1"
                                    value={creditAmount}
                                    onChange={e => setCreditAmount(parseInt(e.target.value))}
                                    className="w-full px-4 py-3 border border-slate-300 rounded-xl text-center text-lg font-bold text-indigo-700 focus:ring-2 focus:ring-amber-200 outline-none"
                                />
                            </div>

                            <div className="grid grid-cols-4 gap-2">
                                {[10, 50, 100, 500].map(v => (
                                    <button
                                        key={v}
                                        onClick={() => setCreditAmount(v)}
                                        className={`py-1 rounded-lg text-xs font-bold transition-colors ${creditAmount === v ? 'bg-indigo-600 text-white' : 'bg-slate-100 text-slate-600 hover:bg-slate-200'}`}
                                    >
                                        +{v}
                                    </button>
                                ))}
                            </div>
                        </div>

                        <div className="flex gap-3 mt-8">
                            <button onClick={() => setIsCreditModalOpen(false)} className="flex-1 py-3 bg-slate-100 text-slate-600 font-bold rounded-xl hover:bg-slate-200">Cancelar</button>
                            <button onClick={handleIncrementCredits} className="flex-1 py-3 bg-amber-500 text-white font-bold rounded-xl hover:bg-amber-600 shadow-lg shadow-amber-200">Confirmar</button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};
