import React, { useState } from 'react';
import { supabase } from '../../../services/supabaseClient';

interface CreateUserModalProps {
    isOpen: boolean;
    onClose: () => void;
    onUserCreated: () => void;
    // Data for dropdowns
    allSchools: { id: string, name: string, city?: string }[];
    cities: string[];
}

export const CreateUserModal: React.FC<CreateUserModalProps> = ({
    isOpen,
    onClose,
    onUserCreated,
    allSchools,
    cities
}) => {
    // Form State
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('123456');
    const [role, setRole] = useState<'TEACHER' | 'SCHOOL_MANAGER' | 'ADMIN'>('TEACHER');
    const [schoolId, setSchoolId] = useState('');
    const [tier, setTier] = useState<'SILVER' | 'GOLD'>('SILVER');
    const [credits, setCredits] = useState(10);

    // Filter Logic
    const [selectedCity, setSelectedCity] = useState('');
    const [schoolSearchText, setSchoolSearchText] = useState('');
    const [filteredSchools, setFilteredSchools] = useState<{ id: string, name: string }[]>([]);

    if (!isOpen) return null;

    const handleCreateUser = async () => {
        if (!email || !password) return alert('Preencha E-mail e Senha');

        try {
            // Map UI Role to Database Role Profile
            // DB Roles: 'teacher', 'manager', 'admin'
            let dbRole = 'teacher';
            if (role === 'SCHOOL_MANAGER') {
                dbRole = 'manager';
                if (!schoolId) return alert('Selecione uma Escola para o Gestor.');
            }
            if (role === 'ADMIN') dbRole = 'admin';

            // SOLUÇÃO DEFINITIVA: Criar no Supabase Auth com configurações corretas
            const { data: authData, error: authError } = await supabase.auth.signUp({
                email: email,
                password: password,
                options: {
                    emailRedirectTo: window.location.origin,
                    data: {
                        full_name: '',
                        role: dbRole
                    }
                }
            });

            // Tratamento melhorado de erros
            if (authError) {
                console.error('Auth Error Details:', authError);

                if (authError.message.includes('already registered')) {
                    throw new Error('Este email já está cadastrado. Use outro email ou faça login.');
                } else if (authError.message.includes('Database error')) {
                    throw new Error('Erro no banco de dados. Verifique se o email já existe ou contate o suporte.');
                } else {
                    throw new Error('Erro ao criar usuário: ' + authError.message);
                }
            }
            if (!authData.user) throw new Error('Erro: usuário não foi criado.');

            const userId = authData.user.id;

            // 2. Atualizar/Criar perfil com role e school corretos
            const { error: profileError } = await supabase.from('profiles')
                .upsert({
                    id: userId,
                    email: email,
                    role: dbRole,
                    tier: tier,
                    credits: credits,
                    is_unlimited: tier === 'GOLD',
                    is_admin: role === 'ADMIN',
                    school_id: (role === 'SCHOOL_MANAGER' || role === 'TEACHER') ? schoolId : null,
                    allowed_features: ['all']
                }, {
                    onConflict: 'id'
                });

            if (profileError) {
                console.error("Erro ao atualizar perfil:", profileError);
                throw new Error('Usuário criado, mas perfil falhou: ' + profileError.message);
            }

            // 3. OPCIONAL: Também salvar em authorized_users para compatibilidade com login VIP
            await supabase.from('authorized_users').upsert({
                id: userId,
                email: email,
                access_key: password,
                role: dbRole
            }, {
                onConflict: 'id'
            });

            alert('Usuário criado com sucesso! Use a senha informada como Chave de Acesso.');
            resetForm();
            onUserCreated();

        } catch (e: any) {
            alert('Erro: ' + e.message);
        }
    };

    const resetForm = () => {
        setEmail('');
        setPassword('123456');
        setRole('TEACHER');
        setSchoolId('');
        setSelectedCity('');
        setSchoolSearchText('');
        setFilteredSchools([]);
        setCredits(10);
    };

    return (
        <div className="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4 backdrop-blur-sm">
            <div className="bg-white rounded-2xl shadow-2xl w-full max-w-md p-6 animate-in zoom-in-95 duration-200 max-h-[90vh] overflow-y-auto">
                <h2 className="text-xl font-bold text-slate-800 mb-4">Adicionar Novo Usuário</h2>
                <div className="space-y-4">
                    <div>
                        <label className="block text-xs font-bold text-slate-500 uppercase mb-1">E-mail</label>
                        <input type="email" value={email} onChange={e => setEmail(e.target.value)} className="w-full px-4 py-2 border rounded-lg" />
                    </div>
                    <div>
                        <label className="block text-xs font-bold text-slate-500 uppercase mb-1">Senha Inicial</label>
                        <input type="text" value={password} onChange={e => setPassword(e.target.value)} className="w-full px-4 py-2 border rounded-lg" />
                    </div>
                    <div className="grid grid-cols-2 gap-4">
                        <div>
                            <label className="block text-xs font-bold text-slate-500 uppercase mb-1">Função</label>
                            <select value={role} onChange={(e: any) => setRole(e.target.value)} className="w-full px-4 py-2 border rounded-lg">
                                <option value="TEACHER">Professor</option>
                                <option value="SCHOOL_MANAGER">Gestor Escolar</option>
                                <option value="ADMIN">Admin Sistema</option>
                            </select>
                        </div>
                        <div>
                            <label className="block text-xs font-bold text-slate-500 uppercase mb-1">Nível</label>
                            <select value={tier} onChange={(e: any) => setTier(e.target.value)} className="w-full px-4 py-2 border rounded-lg">
                                <option value="SILVER">SILVER</option>
                                <option value="GOLD">GOLD</option>
                            </select>
                        </div>
                    </div>
                    {(role === 'SCHOOL_MANAGER' || role === 'TEACHER') && (
                        <>
                            {/* Option 1: Filter by City */}
                            <div>
                                <label className="block text-xs font-bold text-slate-500 uppercase mb-1">
                                    Opção 1: Filtrar por Cidade
                                </label>
                                <input
                                    list="cities-list"
                                    type="text"
                                    placeholder="Digite ou selecione a cidade..."
                                    value={selectedCity}
                                    onChange={(e) => {
                                        const city = e.target.value;
                                        setSelectedCity(city);
                                        setSchoolId('');
                                        setSchoolSearchText(''); // Reset text search
                                        if (city) {
                                            const filtered = allSchools
                                                .filter(s => s.city?.trim().toLowerCase() === city.trim().toLowerCase())
                                                .map(s => ({ id: s.id, name: s.name }));
                                            setFilteredSchools(filtered);
                                        } else {
                                            setFilteredSchools([]);
                                        }
                                    }}
                                    className="w-full px-4 py-2 border rounded-lg bg-amber-50 border-amber-200"
                                />
                                <datalist id="cities-list">
                                    {cities.map(city => (
                                        <option key={city} value={city} />
                                    ))}
                                </datalist>
                            </div>

                            {/* OR Divider */}
                            <div className="text-center text-sm font-bold text-slate-400 py-1">OU</div>

                            {/* Option 2: Text Search */}
                            <div>
                                <label className="block text-xs font-bold text-slate-500 uppercase mb-1">
                                    Opção 2: Buscar por Nome da Escola
                                </label>
                                <input
                                    type="text"
                                    placeholder="Digite o nome da escola..."
                                    value={schoolSearchText}
                                    onChange={(e) => {
                                        const searchText = e.target.value;
                                        setSchoolSearchText(searchText);
                                        setSelectedCity(''); // Reset city filter
                                        setSchoolId('');

                                        if (searchText.length >= 3) {
                                            const filtered = allSchools
                                                .filter(s => s.name.toLowerCase().includes(searchText.toLowerCase()))
                                                .map(s => ({ id: s.id, name: s.name }))
                                                .slice(0, 100); // Limit to 100 results
                                            setFilteredSchools(filtered);
                                        } else {
                                            setFilteredSchools([]);
                                        }
                                    }}
                                    className="w-full px-4 py-2 border rounded-lg bg-green-50 border-green-200"
                                />
                                {schoolSearchText.length > 0 && schoolSearchText.length < 3 && (
                                    <p className="text-xs text-amber-600 mt-1">Digite pelo menos 3 caracteres</p>
                                )}
                            </div>

                            {/* School Dropdown (appears when filtered) */}
                            {(selectedCity || schoolSearchText.length >= 3) && filteredSchools.length > 0 && (
                                <div>
                                    <label className="block text-xs font-bold text-slate-500 uppercase mb-1">
                                        {selectedCity ? `Escolas em ${selectedCity}` : `Resultados da Busca`}
                                    </label>
                                    <select
                                        value={schoolId}
                                        onChange={(e) => setSchoolId(e.target.value)}
                                        className="w-full px-4 py-2 border rounded-lg bg-blue-50 border-blue-200"
                                    >
                                        <option value="">Selecione uma Escola...</option>
                                        {filteredSchools.map(s => (
                                            <option key={s.id} value={s.id}>{s.name}</option>
                                        ))}
                                    </select>
                                    <p className="text-xs text-slate-500 mt-1">
                                        {filteredSchools.length} escola(s) encontrada(s)
                                    </p>
                                </div>
                            )}

                            {(selectedCity || schoolSearchText.length >= 3) && filteredSchools.length === 0 && (
                                <div className="p-3 bg-yellow-50 border border-yellow-200 rounded-lg text-sm text-yellow-800">
                                    Nenhuma escola encontrada. Tente outro filtro.
                                </div>
                            )}
                        </>
                    )}
                    <div>
                        <label className="block text-xs font-bold text-slate-500 uppercase mb-1">Créditos Iniciais</label>
                        <input type="number" disabled={tier === 'GOLD'} value={credits} onChange={e => setCredits(parseInt(e.target.value))} className="w-full px-4 py-2 border rounded-lg disabled:opacity-50" />
                    </div>
                </div>
                <div className="flex gap-3 mt-8">
                    <button onClick={onClose} className="flex-1 py-3 bg-slate-100 text-slate-600 font-bold rounded-xl hover:bg-slate-200">Cancelar</button>
                    <button onClick={handleCreateUser} className="flex-1 py-3 bg-indigo-600 text-white font-bold rounded-xl hover:bg-indigo-700">Criar Usuário</button>
                </div>
            </div>
        </div>
    );
};
