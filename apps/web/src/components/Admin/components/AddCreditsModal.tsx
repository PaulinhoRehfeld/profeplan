import React, { useState } from 'react';
import { Coins } from 'lucide-react';
import { UserProfile } from '../../../types';
import { addUserCredits } from '../../../services/ProfileService';

interface AddCreditsModalProps {
  isOpen: boolean;
  user: UserProfile | null;
  onClose: () => void;
  onCreditsAdded: () => void;
}

export const AddCreditsModal: React.FC<AddCreditsModalProps> = ({
  isOpen,
  user,
  onClose,
  onCreditsAdded,
}) => {
  const [creditAmount, setCreditAmount] = useState(10);

  if (!isOpen || !user) return null;

  const handleIncrementCredits = async () => {
    if (!user) return;
    const res = await addUserCredits(user.id, creditAmount);
    if (res.error) {
      alert('Erro ao adicionar créditos: ' + res.error.message);
    } else {
      alert('Créditos adicionados com sucesso!');
      setCreditAmount(10);
      onCreditsAdded();
    }
  };

  return (
    <div className="fixed inset-0 z-50 bg-black/50 flex items-center justify-center p-4 backdrop-blur-sm">
      <div className="bg-white rounded-2xl shadow-2xl w-full max-w-sm p-6 animate-in zoom-in-95 duration-200">
        <div className="bg-amber-100 w-12 h-12 rounded-full flex items-center justify-center mb-4 mx-auto text-amber-600">
          <Coins size={24} />
        </div>
        <h2 className="text-xl font-bold text-slate-800 mb-2 text-center">Adicionar Créditos</h2>
        <p className="text-sm text-slate-500 text-center mb-6">
          Para: <span className="font-bold text-slate-700">{user.email}</span>
          <br />
          Saldo Atual: {user.credits}
        </p>

        <div className="space-y-4">
          <div>
            <label className="block text-xs font-bold text-slate-500 uppercase mb-1">
              Quantidade a Adicionar
            </label>
            <input
              type="number"
              min="1"
              value={creditAmount}
              onChange={(e) => {
                const val = e.target.value;
                setCreditAmount(val === '' ? 0 : parseInt(val, 10));
              }}
              className="w-full px-4 py-3 border border-slate-300 rounded-xl text-center text-lg font-bold text-indigo-700 focus:ring-2 focus:ring-amber-200 outline-none"
            />
          </div>

          <div className="grid grid-cols-4 gap-2">
            {[10, 50, 100, 500].map((v) => (
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
          <button
            onClick={onClose}
            className="flex-1 py-3 bg-slate-100 text-slate-600 font-bold rounded-xl hover:bg-slate-200"
          >
            Cancelar
          </button>
          <button
            onClick={handleIncrementCredits}
            className="flex-1 py-3 bg-amber-500 text-white font-bold rounded-xl hover:bg-amber-600 shadow-lg shadow-amber-200"
          >
            Confirmar
          </button>
        </div>
      </div>
    </div>
  );
};
