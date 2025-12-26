
import React, { useState, useEffect } from 'react';
import { UserPlus, Trash2, Mail, ShieldAlert, Loader2, CheckCircle2, AlertCircle } from 'lucide-react';
import { supabase } from '../services/supabaseClient';

const AdminDashboard: React.FC = () => {
  const [emails, setEmails] = useState<any[]>([]);
  const [newEmail, setNewEmail] = useState('');
  const [newRole, setNewRole] = useState('PRO');
  const [loading, setLoading] = useState(true);
  const [actionLoading, setActionLoading] = useState(false);
  const [error, setError] = useState(''); // Novo estado para mensagens de erro

  const fetchUsers = async () => {
    setLoading(true);
    setError(''); // Limpa erro ao buscar
    try {
      const { data, error } = await supabase
        .from('authorized_users')
        .select('*')
        .order('created_at', { ascending: false });
      
      if (error) throw error;
      if (data) setEmails(data);
    } catch (err: any) {
      console.error("Erro ao listar usuários:", JSON.stringify(err, null, 2));
      if (err.message.includes('policy') || err.message.includes('row-level security')) {
        setError('Erro de Segurança: A Política de Segurança de Linha (RLS) está ativa na tabela \'authorized_users\' do Supabase. Para gerenciar usuários, você precisa desativar o RLS para esta tabela no seu projeto Supabase, ou adicionar uma política que permita a leitura.');
      } else if (err.message.includes('supabaseKey') || err.message.includes('API key')) {
        setError('Erro de Configuração: Chave de API do Supabase ausente ou inválida. Verifique suas variáveis de ambiente.');
      } else {
        setError('Erro ao listar usuários: ' + err.message);
      }
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { 
    fetchUsers(); 
  }, []);

  const handleAddUser = async (e: React.FormEvent) => {
    e.preventDefault();
    setActionLoading(true);
    setError(''); // Limpa erro anterior
    try {
      const { error } = await supabase
        .from('authorized_users')
        .insert([{ email: newEmail.toLowerCase().trim(), role: newRole }]);
      
      if (error) throw error;
      
      setNewEmail('');
      fetchUsers(); // Re-busca a lista para atualizar a UI
    } catch (err: any) {
      console.error("Erro ao adicionar usuário:", JSON.stringify(err, null, 2));
      if (err.message.includes('policy') || err.message.includes('row-level security')) {
        setError('Erro de Segurança: A Política de Segurança de Linha (RLS) está ativa na tabela \'authorized_users\' do Supabase. Para gerenciar usuários, você precisa desativar o RLS para esta tabela no seu projeto Supabase, ou adicionar uma política que permita a inserção.');
      } else if (err.code === '23505') { // Código de erro para violação de unique constraint (e-mail já existe)
        setError('Este e-mail já está autorizado.');
      } else if (err.message.includes('supabaseKey') || err.message.includes('API key')) {
        setError('Erro de Configuração: Chave de API do Supabase ausente ou inválida. Verifique suas variáveis de ambiente.');
      } else {
        setError('Erro ao autorizar e-mail: ' + err.message);
      }
    } finally {
      setActionLoading(false);
    }
  };

  const handleRemoveUser = async (id: string) => {
    if (!confirm("Deseja revogar permanentemente o acesso deste usuário?")) return;
    
    setActionLoading(true);
    setError(''); // Limpa erro anterior
    try {
      const { error } = await supabase
        .from('authorized_users')
        .delete()
        .eq('id', id);
        
      if (error) throw error;
      fetchUsers(); // Re-busca a lista para atualizar a UI
    } catch (err: any) {
      console.error("Erro ao remover usuário:", JSON.stringify(err, null, 2));
      if (err.message.includes('policy') || err.message.includes('row-level security')) {
        setError('Erro de Segurança: A Política de Segurança de Linha (RLS) está ativa na tabela \'authorized_users\' do Supabase. Para gerenciar usuários, você precisa desativar o RLS para esta tabela no seu projeto Supabase, ou adicionar uma política que permita a exclusão.');
      } else if (err.message.includes('supabaseKey') || err.message.includes('API key')) {
        setError('Erro de Configuração: Chave de API do Supabase ausente ou inválida. Verifique suas variáveis de ambiente.');
      } else {
        setError('Erro ao remover acesso: ' + err.message);
      }
    } finally {
      setActionLoading(false);
    }
  };

  return (
    <div className="max-w-5xl mx-auto space-y-8 animate-in fade-in duration-500 pb-20">
      <header className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h2 className="text-3xl font-black text-slate-900 italic uppercase tracking-tighter">Gestão de Autorizações</h2>
          <p className="text-slate-500 text-sm font-medium">Controle centralizado de e-mails autorizados para o PROFEPLAN</p>
        </div>
        <div className="flex items-center gap-3 bg-amber-50 border border-amber-200 px-5 py-3 rounded-2xl shadow-sm">
          <div className="w-2 h-2 bg-amber-500 rounded-full animate-pulse" />
          <span className="text-[10px] font-black text-amber-700 uppercase tracking-widest">Acesso Root Ativo</span>
        </div>
      </header>

      {error && ( // Exibe o erro na interface
        <div className="flex items-start gap-3 p-4 bg-red-500/10 border border-red-500/20 rounded-2xl animate-in slide-in-from-top-2">
          <AlertCircle className="w-5 h-5 text-red-400 shrink-0 mt-0.5" />
          <p className="text-red-400 text-xs font-bold leading-tight">{error}</p>
        </div>
      )}

      {/* Formulário de Cadastro */}
      <form onSubmit={handleAddUser} className="bg-white p-8 rounded-[2.5rem] border border-slate-200 shadow-xl flex flex-col md:flex-row gap-5 items-end transition-all hover:shadow-2xl">
        <div className="flex-1 w-full space-y-2">
          <label className="text-[10px] font-black uppercase text-slate-400 ml-2 tracking-widest">E-mail do Professor / Gestor</label>
          <div className="relative">
            <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-300" />
            <input 
              type="email" 
              value={newEmail}
              onChange={(e) => setNewEmail(e.target.value)}
              placeholder="ex: professor@escola.mg.gov.br"
              className="w-full bg-slate-50 pl-12 pr-6 py-4 rounded-2xl text-sm border-2 border-transparent focus:border-blue-500 outline-none transition-all font-bold"
              required
            />
          </div>
        </div>
        <div className="w-full md:w-56 space-y-2">
          <label className="text-[10px] font-black uppercase text-slate-400 ml-2 tracking-widest">Nível de Licença</label>
          <select 
            value={newRole}
            onChange={(e) => setNewRole(e.target.value)}
            className="w-full bg-slate-50 p-4 rounded-2xl text-sm border-2 border-transparent focus:border-blue-500 outline-none font-black text-slate-700 cursor-pointer"
          >
            <option value="BASICO">LICENÇA BÁSICA</option>
            <option value="PRO">LICENÇA PRO</option>
            <option value="ADMIN">ADMINISTRADOR</option>
          </select>
        </div>
        <button 
          type="submit" 
          disabled={actionLoading}
          className="w-full md:w-auto bg-slate-900 text-white p-4 px-8 rounded-2xl hover:bg-blue-600 transition-all shadow-xl active:scale-95 disabled:opacity-50"
        >
          {actionLoading ? <Loader2 className="animate-spin" /> : <UserPlus size={24} className="mx-auto" />}
        </button>
      </form>

      {/* Tabela de Usuários */}
      <div className="bg-white rounded-[3rem] border border-slate-200 shadow-2xl overflow-hidden">
        {loading ? (
          <div className="p-24 flex flex-col items-center justify-center gap-5 text-center">
            <Loader2 className="w-10 h-10 text-blue-500 animate-spin" />
            <p className="text-[10px] font-black uppercase text-slate-400 tracking-[0.3em]">Sincronizando com Supabase Cloud...</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left">
              <thead>
                <tr className="bg-slate-50/80 text-[11px] font-black text-slate-400 uppercase tracking-[0.2em]">
                  <th className="px-12 py-8">Docente Autorizado</th>
                  <th className="px-12 py-8">Nível de Acesso</th>
                  <th className="px-12 py-8">Data Autorização</th>
                  <th className="px-12 py-8 text-right">Ação</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-50">
                {emails.length === 0 ? (
                  <tr>
                    <td colSpan={4} className="p-20 text-center text-slate-400 italic font-medium">Nenhum professor autorizado ainda.</td>
                  </tr>
                ) : (
                  emails.map((user) => (
                    <tr key={user.id} className="hover:bg-slate-50/50 transition-colors group">
                      <td className="p-8">
                        <div className="flex items-center gap-4">
                          <div className="w-12 h-12 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center group-hover:bg-blue-600 group-hover:text-white transition-all shadow-sm">
                            <Mail size={20} />
                          </div>
                          <div>
                            <p className="font-black text-slate-800 tracking-tight">{user.email}</p>
                            <p className="text-[10px] font-bold text-slate-400 uppercase">Verificado via Cloud</p>
                          </div>
                        </div>
                      </td>
                      <td className="p-8">
                        <span className={`px-4 py-1.5 rounded-full text-[10px] font-black uppercase tracking-tighter border shadow-sm ${
                          user.role === 'ADMIN' ? 'bg-purple-50 text-purple-600 border-purple-100' : 
                          user.role === 'PRO' ? 'bg-blue-50 text-blue-600 border-blue-100' : 'bg-slate-50 text-slate-500 border-slate-100'
                        }`}>
                          {user.role}
                        </span>
                      </td>
                      <td className="p-8 text-sm font-bold text-slate-500">
                        {new Date(user.created_at).toLocaleDateString('pt-BR')}
                      </td>
                      <td className="p-8 text-right">
                        <button 
                          onClick={() => handleRemoveUser(user.id)}
                          disabled={actionLoading}
                          className="p-4 text-slate-300 hover:text-red-500 hover:bg-red-50 rounded-2xl transition-all active:scale-90"
                        >
                          <Trash2 size={20} />
                        </button>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        )}
      </div>
    </div>
  );
};

export default AdminDashboard;