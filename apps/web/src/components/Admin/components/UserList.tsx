import React from 'react';
import { Crown, Check, X, Edit, Trash2, Coins } from 'lucide-react';
import { UserProfile } from '../../../types';
import { isGovernedCreditProducerEnabled } from '../../../services/credits/creditProducerFlags';

interface UserListProps {
  users: UserProfile[];
  loading: boolean;
  searchTerm: string;
  editingUser: UserProfile | null;
  setEditingUser: (u: UserProfile | null) => void;
  onUpdateUser: (id: string, updates: Partial<UserProfile>) => Promise<void>;
  onDeleteUser: (user: UserProfile) => Promise<void>;
  onAddCredits: (user: UserProfile) => void;
}

export const UserList: React.FC<UserListProps> = ({
  users,
  loading,
  searchTerm,
  editingUser,
  setEditingUser,
  onUpdateUser,
  onDeleteUser,
  onAddCredits,
}) => {
  const governed = isGovernedCreditProducerEnabled();
  const filteredUsers = users.filter((u) =>
    u.email?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const buildProfileUpdate = (user: UserProfile): Partial<UserProfile> => ({
    tier: user.tier,
    is_unlimited: user.tier === 'GOLD',
    ...(governed ? {} : { credits: user.credits }),
  });

  return (
    <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden overflow-x-auto">
      <table className="w-full text-left border-collapse min-w-[600px]">
        <thead className="bg-slate-50 border-b border-slate-200 text-xs uppercase text-slate-500 font-bold">
          <tr>
            <th className="px-3 md:px-6 py-4">Usuário</th>
            <th className="px-3 md:px-6 py-4">Escola</th>
            <th className="px-3 md:px-6 py-4">Nível (Tier)</th>
            <th className="px-3 md:px-6 py-4">Saldo de Créditos</th>
            <th className="px-3 md:px-6 py-4 text-center">Ações</th>
          </tr>
        </thead>
        <tbody className="text-sm divide-y divide-slate-100">
          {loading ? (
            <tr>
              <td colSpan={5} className="px-6 py-8 text-center text-slate-400">
                Carregando...
              </td>
            </tr>
          ) : filteredUsers.length === 0 ? (
            <tr>
              <td colSpan={5} className="px-6 py-8 text-center text-slate-400">
                Nenhum usuário encontrado.
              </td>
            </tr>
          ) : (
            filteredUsers.map((user) => (
              <tr key={user.id} className="hover:bg-slate-50 transition">
                <td className="px-3 md:px-6 py-4 font-medium text-slate-700">
                  {user.email}
                  {user.is_admin && (
                    <span className="ml-2 px-2 py-0.5 bg-purple-100 text-purple-700 text-[10px] rounded-full uppercase font-bold">
                      Admin
                    </span>
                  )}
                  {user.role === 'manager' && (
                    <span className="ml-2 px-2 py-0.5 bg-blue-100 text-blue-700 text-[10px] rounded-full uppercase font-bold">
                      Gestor
                    </span>
                  )}
                  {user.role === 'teacher' && (
                    <span className="ml-2 px-2 py-0.5 bg-slate-100 text-slate-600 text-[10px] rounded-full uppercase font-bold">
                      Professor
                    </span>
                  )}
                </td>
                <td className="px-3 md:px-6 py-4">
                  <span className="text-xs text-slate-600 font-medium">
                    {user.school_name || user.school?.name || (user.role === 'admin' ? 'N/A' : '-')}
                  </span>
                </td>
                <td className="px-3 md:px-6 py-4">
                  {editingUser?.id === user.id ? (
                    <select
                      className="border rounded px-2 py-1 text-xs"
                      value={editingUser.tier}
                      onChange={(e) =>
                        setEditingUser({ ...editingUser, tier: e.target.value as any })
                      }
                    >
                      <option value="SILVER">SILVER</option>
                      <option value="GOLD">GOLD</option>
                    </select>
                  ) : (
                    <span
                      className={`inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[10px] font-bold uppercase tracking-wide ${user.tier === 'GOLD' || user.is_unlimited ? 'bg-amber-100 text-amber-700' : 'bg-slate-100 text-slate-600'}`}
                    >
                      {user.tier === 'GOLD' || user.is_unlimited ? <Crown size={12} /> : null}
                      {user.tier || 'SILVER'}
                    </span>
                  )}
                </td>
                <td className="px-3 md:px-6 py-4 font-mono font-bold text-slate-600">
                  {governed ? (
                    <span className="font-sans text-xs font-semibold text-indigo-700">
                      Ledger governado
                    </span>
                  ) : editingUser?.id === user.id ? (
                    <input
                      type="number"
                      className="w-20 border rounded px-2 py-1 text-xs"
                      value={editingUser.credits}
                      onChange={(e) => {
                        const val = e.target.value;
                        setEditingUser({
                          ...editingUser,
                          credits: val === '' ? 0 : parseInt(val, 10),
                        });
                      }}
                    />
                  ) : user.is_unlimited ? (
                    '∞ (Ilimitado)'
                  ) : (
                    `${user.credits} CR`
                  )}
                </td>
                <td className="px-3 md:px-6 py-4 text-center">
                  {editingUser?.id === user.id ? (
                    <div className="flex items-center justify-center gap-2">
                      <button
                        onClick={() =>
                          onUpdateUser(user.id, buildProfileUpdate(editingUser))
                        }
                        className="p-1.5 bg-green-100 text-green-700 rounded hover:bg-green-200"
                      >
                        <Check size={16} />
                      </button>
                      <button
                        onClick={() => setEditingUser(null)}
                        className="p-1.5 bg-red-100 text-red-700 rounded hover:bg-red-200"
                      >
                        <X size={16} />
                      </button>
                    </div>
                  ) : (
                    <div className="flex items-center gap-1">
                      <button
                        onClick={() => setEditingUser(user)}
                        className="p-1.5 text-slate-400 hover:text-indigo-600 hover:bg-indigo-50 rounded transition"
                        title="Editar"
                      >
                        <Edit size={16} />
                      </button>
                      {!user.is_admin && (
                        <button
                          onClick={() => onDeleteUser(user)}
                          className="p-1.5 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded transition"
                          title="Excluir"
                        >
                          <Trash2 size={16} />
                        </button>
                      )}

                      <button
                        onClick={() => onAddCredits(user)}
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
  );
};
