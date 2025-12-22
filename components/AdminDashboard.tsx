
import React, { useState } from 'react';
import { Users, FolderOpen, ShieldAlert, CheckCircle2, Cloud, ExternalLink, HardDrive, Search } from 'lucide-react';

const AdminDashboard: React.FC = () => {
  const [driveFolderId, setDriveFolderId] = useState('1A2b3C4d5E6f7G8h9I0j');
  
  const mockUsers = [
    { id: 1, name: 'Ana Souza', email: 'ana.souza@escola.edu', level: 'PREMIUM', status: 'Ativo' },
    { id: 2, name: 'Carlos Lima', email: 'c.lima@escola.edu', level: 'PRO', status: 'Ativo' },
    { id: 3, name: 'Beatriz Silva', email: 'bia@escola.edu', level: 'BASICO', status: 'Pendente' },
    { id: 4, name: 'Ricardo Oliveira', email: 'admin@profeplan.com', level: 'PREMIUM', status: 'Ativo' },
  ];

  return (
    <div className="space-y-8 animate-in fade-in duration-500">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-slate-800">Painel do Administrador</h1>
          <p className="text-slate-500 text-sm">Controle de acessos e base de conhecimento central.</p>
        </div>
        <div className="flex items-center gap-2 bg-amber-50 border border-amber-200 px-4 py-2 rounded-xl">
          <ShieldAlert className="w-5 h-5 text-amber-600" />
          <span className="text-xs font-bold text-amber-700">MODO ROOT ATIVO</span>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Gestão Google Drive */}
        <div className="lg:col-span-2 space-y-6">
          <div className="bg-white p-6 rounded-3xl border border-slate-200 shadow-sm">
            <div className="flex items-center justify-between mb-6">
              <div className="flex items-center gap-3">
                <div className="p-2 bg-blue-50 text-blue-600 rounded-lg">
                  <Cloud className="w-6 h-6" />
                </div>
                <h3 className="font-bold text-slate-800">Repositório de Base (RAG)</h3>
              </div>
              <span className="text-[10px] font-bold bg-green-100 text-green-700 px-2 py-1 rounded-full uppercase">Sincronizado</span>
            </div>

            <p className="text-sm text-slate-600 mb-6">
              Configure o ID da pasta do Google Drive que contém os PDFs, documentos e planos de referência da sua instituição. 
              O PROFEPLAN usará esses arquivos como verdade absoluta.
            </p>

            <div className="flex gap-2">
              <div className="flex-1 relative">
                <FolderOpen className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                <input 
                  type="text" 
                  value={driveFolderId}
                  onChange={(e) => setDriveFolderId(e.target.value)}
                  className="w-full bg-slate-50 border border-slate-200 rounded-xl py-3 pl-10 pr-4 text-sm outline-none focus:ring-2 focus:ring-blue-500"
                />
              </div>
              <button className="bg-slate-900 text-white px-6 py-3 rounded-xl font-bold text-sm hover:bg-slate-800 transition-colors">
                Atualizar
              </button>
            </div>

            <div className="mt-6 grid grid-cols-3 gap-4">
              <div className="p-4 bg-slate-50 rounded-2xl border border-slate-100 text-center">
                <p className="text-[10px] font-bold text-slate-400 uppercase mb-1">Arquivos</p>
                <p className="text-xl font-bold text-slate-800">124</p>
              </div>
              <div className="p-4 bg-slate-50 rounded-2xl border border-slate-100 text-center">
                <p className="text-[10px] font-bold text-slate-400 uppercase mb-1">Indexação</p>
                <p className="text-xl font-bold text-blue-600">100%</p>
              </div>
              <div className="p-4 bg-slate-50 rounded-2xl border border-slate-100 text-center">
                <p className="text-[10px] font-bold text-slate-400 uppercase mb-1">Última Sync</p>
                <p className="text-sm font-bold text-slate-800 mt-1">15m atrás</p>
              </div>
            </div>
          </div>

          {/* Lista de Usuários */}
          <div className="bg-white rounded-3xl border border-slate-200 shadow-sm overflow-hidden">
            <div className="p-6 border-b border-slate-100 flex items-center justify-between">
              <div className="flex items-center gap-3">
                <Users className="w-5 h-5 text-slate-400" />
                <h3 className="font-bold text-slate-800">Gestão de Professores</h3>
              </div>
              <div className="relative">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                <input type="text" placeholder="Buscar..." className="bg-slate-50 border border-slate-200 rounded-lg py-1.5 pl-9 pr-4 text-xs outline-none" />
              </div>
            </div>
            <div className="overflow-x-auto">
              <table className="w-full text-left">
                <thead className="bg-slate-50 text-[10px] font-bold text-slate-400 uppercase tracking-widest">
                  <tr>
                    <th className="px-6 py-4">Usuário</th>
                    <th className="px-6 py-4">Nível</th>
                    <th className="px-6 py-4">Status</th>
                    <th className="px-6 py-4 text-right">Ações</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100">
                  {mockUsers.map(user => (
                    <tr key={user.id} className="hover:bg-slate-50 transition-colors">
                      <td className="px-6 py-4">
                        <p className="text-sm font-bold text-slate-800">{user.name}</p>
                        <p className="text-xs text-slate-500">{user.email}</p>
                      </td>
                      <td className="px-6 py-4">
                        <span className={`text-[10px] font-bold px-2 py-1 rounded-full ${
                          user.level === 'PREMIUM' ? 'bg-purple-100 text-purple-700' :
                          user.level === 'PRO' ? 'bg-blue-100 text-blue-700' : 'bg-slate-100 text-slate-600'
                        }`}>
                          {user.level}
                        </span>
                      </td>
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-2">
                          <div className={`w-1.5 h-1.5 rounded-full ${user.status === 'Ativo' ? 'bg-green-500' : 'bg-amber-500'}`}></div>
                          <span className="text-xs text-slate-600">{user.status}</span>
                        </div>
                      </td>
                      <td className="px-6 py-4 text-right">
                        <button className="text-xs font-bold text-blue-600 hover:underline">Editar</button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>
        </div>

        {/* Estatísticas de Uso */}
        <div className="space-y-6">
          <div className="bg-slate-900 rounded-3xl p-6 text-white">
            <h3 className="font-bold text-lg mb-4">Uso Global</h3>
            <div className="space-y-4">
              <div>
                <div className="flex justify-between text-xs mb-1">
                  <span className="text-slate-400">Tokens Gemini Consumidos</span>
                  <span className="text-blue-400 font-bold">78%</span>
                </div>
                <div className="w-full h-2 bg-white/10 rounded-full overflow-hidden">
                  <div className="bg-blue-500 h-full w-[78%]"></div>
                </div>
              </div>
              <div>
                <div className="flex justify-between text-xs mb-1">
                  <span className="text-slate-400">Armazenamento Base</span>
                  <span className="text-emerald-400 font-bold">12 GB</span>
                </div>
                <div className="w-full h-2 bg-white/10 rounded-full overflow-hidden">
                  <div className="bg-emerald-500 h-full w-[45%]"></div>
                </div>
              </div>
            </div>
          </div>

          <div className="bg-white p-6 rounded-3xl border border-slate-200 shadow-sm">
             <h3 className="font-bold text-slate-800 mb-4">Logs de Atividade</h3>
             <div className="space-y-4">
               {[1,2,3].map(i => (
                 <div key={i} className="flex gap-3 text-xs">
                   <div className="w-1 h-8 bg-blue-100 rounded-full"></div>
                   <div>
                     <p className="font-bold text-slate-700">Novo usuário cadastrado</p>
                     <p className="text-slate-400">há 2 horas por Sistema</p>
                   </div>
                 </div>
               ))}
             </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default AdminDashboard;
