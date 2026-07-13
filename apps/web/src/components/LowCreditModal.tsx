import React, { useState } from 'react';
import { Gift, Phone, Check, X, Smartphone, Loader2 } from 'lucide-react';
import { registerPhone } from '../services/ProfileService';

interface LowCreditModalProps {
  isOpen: boolean;
  onClose: () => void;
  currentCredits: number;
  userId: string;
  userPhone?: string; // If present, implies we might just show a warning or nothing
  onSuccess: () => void; // Trigger credit refresh
}

export const LowCreditModal: React.FC<LowCreditModalProps> = ({
  isOpen,
  onClose,
  currentCredits,
  userId,
  userPhone,
  onSuccess,
}) => {
  // Se o usuário já tem telefone, este modal serve apenas como aviso (ou nem deveria abrir, mas tratamos aqui)
  const [inputValue, setInputValue] = useState('');
  const [loading, setLoading] = useState(false);
  const [msg, setMsg] = useState<{ type: 'success' | 'error'; text: string } | null>(null);

  // Se já tem telefone, talvez não queiramos mostrar o input de cadastro.
  // Mas conforme o pedido, vamos focar em remover a indicação de amigo.
  // Se userPhone existir, o input ficaria estranho pedindo telefone de novo?
  // Vamos assumir que se o modal abriu e tem userPhone, é apenas um aviso de créditos.
  const isPhoneRegistered = !!userPhone;

  if (!isOpen) return null;

  const handleSubmit = async () => {
    if (!inputValue.trim()) return;
    setLoading(true);
    setMsg(null);

    try {
      const res = await registerPhone(userId, inputValue);
      if (res.success) {
        setMsg({ type: 'success', text: res.message || 'Sucesso! Créditos adicionados.' });
        onSuccess();
        // Fecha após sucesso
        setTimeout(() => {
          onClose();
        }, 2000);
      } else {
        setMsg({ type: 'error', text: res.message || 'Erro ao salvar.' });
      }
    } catch (error: any) {
      setMsg({ type: 'error', text: 'Erro inesperado: ' + error.message });
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-300">
      <div className="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden relative animate-in zoom-in-95 duration-300">
        {/* Close Button - Garantido que existe e funciona */}
        <button
          onClick={onClose}
          className="absolute top-4 right-4 p-2 bg-slate-100 rounded-full text-slate-400 hover:bg-slate-200 hover:text-slate-600 transition-colors z-10"
          title="Fechar"
        >
          <X size={20} />
        </button>

        {/* Header with Gradient */}
        <div className="p-6 text-white text-center relative overflow-hidden bg-gradient-to-br from-indigo-500 to-purple-600">
          <div className="absolute top-[-50%] left-[-50%] w-[200%] h-[200%] bg-white/10 rotate-12 pointer-events-none"></div>

          <div className="relative z-10 flex flex-col items-center">
            <div className="w-16 h-16 bg-white/20 rounded-full flex items-center justify-center mb-3 backdrop-blur-md shadow-inner">
              <Smartphone size={32} />
            </div>
            <h2 className="text-xl font-black uppercase tracking-tight mb-1">
              {currentCredits > 0
                ? `Apenas ${currentCredits} Créditos Restantes!`
                : 'Seus créditos acabaram!'}
            </h2>

            {!isPhoneRegistered && (
              <p className="text-xs font-medium text-white/90 max-w-[80%] leading-relaxed">
                Não pare agora! Cadastre seu celular e ganhe 10 créditos instantâneos como cortesia.
              </p>
            )}
            {isPhoneRegistered && (
              <p className="text-xs font-medium text-white/90 max-w-[80%] leading-relaxed">
                Entre em contato com o suporte para adquirir mais créditos.
              </p>
            )}
          </div>
        </div>

        {/* Body */}
        <div className="p-6 bg-slate-50">
          {msg && (
            <div
              className={`mb-4 p-3 rounded-lg text-xs font-bold text-center animate-in slide-in-from-top-2 ${msg.type === 'success' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}`}
            >
              {msg.text}
            </div>
          )}

          {!isPhoneRegistered ? (
            <div className="space-y-4">
              <div>
                <label className="block text-[10px] font-black uppercase tracking-widest text-slate-400 mb-1.5 ml-1">
                  Seu Número de Celular (WhatsApp)
                </label>
                <div className="relative">
                  <div className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400">
                    <Phone size={16} />
                  </div>
                  <input
                    type="tel"
                    value={inputValue}
                    onChange={(e) => setInputValue(e.target.value)}
                    placeholder="(XX) 99999-9999"
                    className="w-full pl-10 pr-4 py-3 rounded-xl border border-slate-200 bg-white text-sm font-bold text-slate-700 focus:ring-2 focus:ring-indigo-100 outline-none transition-all shadow-sm"
                  />
                </div>
              </div>

              <button
                onClick={handleSubmit}
                disabled={loading || !inputValue}
                className="w-full py-3.5 rounded-xl text-white text-sm font-black uppercase tracking-widest shadow-lg flex items-center justify-center gap-2 transition-all active:scale-[0.98] disabled:opacity-50 disabled:cursor-not-allowed bg-indigo-600 hover:bg-indigo-700 shadow-indigo-200"
              >
                {loading ? <Loader2 className="animate-spin" size={18} /> : <Gift size={18} />}
                Resgatar 10 Créditos
              </button>
            </div>
          ) : (
            <div className="text-center text-slate-500 text-sm">
              <p className="mb-4">Você já aproveitou o bônus de cadastro de telefone.</p>
              <button
                onClick={onClose}
                className="px-6 py-2 bg-slate-200 hover:bg-slate-300 text-slate-700 font-bold rounded-lg transition-colors"
              >
                Entendi
              </button>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};
