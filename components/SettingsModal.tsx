
import React from 'react';
import { X, User, BookOpen, Settings, Zap, CheckCircle } from 'lucide-react';
import { UserSettings } from '../types';

interface SettingsModalProps {
  isOpen: boolean;
  onClose: () => void;
  settings: UserSettings;
  setSettings: (settings: UserSettings) => void;
  // --- NOVAS PROPS CONFORME ROTEIRO ---
  onConnectDrive: () => void;
  isDriveConnected: boolean;
}

const SettingsModal: React.FC<SettingsModalProps> = ({ 
  isOpen, 
  onClose, 
  settings, 
  setSettings, 
  onConnectDrive, 
  isDriveConnected 
}) => {
  if (!isOpen) return null;

  const handleChange = (field: keyof UserSettings, value: string) => {
    setSettings({ ...settings, [field]: value });
  };

  return (
    <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-[100] flex items-center justify-center p-4">
      <div className="bg-white w-full max-w-2xl rounded-3xl shadow-2xl overflow-hidden flex flex-col max-h-[90vh]">
        {/* Header do Modal */}
        <div className="p-6 border-b border-slate-100 flex items-center justify-between bg-slate-50">
          <div className="flex items-center gap-3">
            <Settings className="w-5 h-5 text-blue-600" />
            <h2 className="text-xl font-bold text-slate-800 tracking-tight">Configurações do Sistema</h2>
          </div>
          <button onClick={onClose} className="p-2 hover:bg-slate-200 rounded-full transition-colors">
            <X className="w-5 h-5 text-slate-500" />
          </button>
        </div>

        <div className="flex-1 overflow-y-auto p-8 space-y-8">
          {/* Seção 1: Perfil Profissional */}
          <section className="space-y-4">
            <div className="flex items-center gap-2 text-blue-600 font-bold text-[10px] uppercase tracking-[0.15em]">
              <User className="w-4 h-4" /> Perfil Profissional
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
              <div className="space-y-1.5">
                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Nome de Exibição</label>
                <input 
                  type="text" value={settings.userName} 
                  onChange={(e) => handleChange('userName', e.target.value)}
                  className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                  placeholder="Ex: Prof. Ricardo Silva"
                />
              </div>
              <div className="space-y-1.5">
                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Escola / Instituição</label>
                <input 
                  type="text" value={settings.institution} 
                  onChange={(e) => handleChange('institution', e.target.value)}
                  className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                  placeholder="Nome da Escola"
                />
              </div>
            </div>
          </section>

          {/* Seção 2: Inteligência e Metodologia */}
          <section className="space-y-4">
            <div className="flex items-center gap-2 text-blue-600 font-bold text-[10px] uppercase tracking-[0.15em]">
              <BookOpen className="w-4 h-4" /> Preferências de IA
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
              <div className="space-y-1.5">
                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Metodologia Padrão</label>
                <select 
                  value={settings.favoriteMethodology} 
                  onChange={(e) => handleChange('favoriteMethodology', e.target.value)}
                  className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 outline-none text-sm font-bold appearance-none cursor-pointer"
                >
                  <option value="Gamification">Gamificação</option>
                  <option value="Inverted Classroom">Sala Invertida</option>
                  <option value="Problem Based">ABP (Problemas)</option>
                  <option value="Traditional">Tradicional</option>
                </select>
              </div>
              <div className="space-y-1.5">
                <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Tom de Escrita</label>
                <select 
                  value={settings.toneOfVoice} 
                  onChange={(e) => handleChange('toneOfVoice', e.target.value as any)}
                  className="w-full px-5 py-3 bg-slate-50 border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 outline-none text-sm font-bold appearance-none cursor-pointer"
                >
                  <option value="Prático e Inspiracional">Prático e Inspiracional</option>
                  <option value="Técnico e Formal">Técnico e Formal</option>
                </select>
              </div>
            </div>
          </section>

          {/* Seção 3: Google Drive (Ecossistema Cloud) */}
          <section className="space-y-4">
            <div className="flex items-center gap-2 text-blue-600 font-bold text-[10px] uppercase tracking-[0.15em]">
              <Zap className="w-4 h-4" /> Ecossistema Cloud
            </div>
            <div className="bg-slate-50 border border-slate-200 rounded-[2rem] p-6 shadow-sm">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 bg-white rounded-xl border border-slate-100 flex items-center justify-center shadow-sm">
                    {/* Ícone do Google Drive conforme solicitado */}
                    <svg className="w-6 h-6" viewBox="0 0 24 24">
                        <path fill="#0066DA" d="M7.71 3.5L4.6 9l5.45 9.47L13.14 13L7.71 3.5z" />
                        <path fill="#00AC47" d="M18.91 13H7.07l-2.47 4.47l2.47 4.53h11.84l2.47-4.53L18.91 13z" />
                        <path fill="#FFBA00" d="M16.29 3.5H7.71L13.14 13l5.45-9.5z" />
                    </svg>
                  </div>
                  <div>
                    <h4 className="font-bold text-slate-900 text-sm">Google Drive</h4>
                    <p className="text-[10px] text-slate-500 font-medium">Sincronização para exportação automática</p>
                  </div>
                </div>

                {/* BOTÃO FUNCIONAL CONFORME ROTEIRO */}
                <button 
                  onClick={onConnectDrive}
                  className={`px-6 py-2.5 rounded-xl font-black text-[10px] uppercase tracking-widest transition-all duration-300 active:scale-95 ${
                    isDriveConnected 
                    ? 'bg-emerald-50 text-emerald-600 border border-emerald-200 shadow-inner cursor-default' 
                    : 'bg-blue-600 text-white hover:bg-blue-700 hover:shadow-lg hover:-translate-y-0.5'
                  }`}
                >
                  {isDriveConnected ? (
                    <span className="flex items-center gap-2">
                      <span className="w-2 h-2 bg-emerald-500 rounded-full animate-pulse" />
                      Conectado ✓
                    </span>
                  ) : (
                    'Conectar'
                  )}
                </button>
              </div>
            </div>
          </section>
        </div>

        {/* Footer do Modal */}
        <div className="p-6 border-t border-slate-100 bg-slate-50 flex justify-end gap-3">
          <button 
            onClick={onClose}
            className="px-8 py-3 bg-slate-900 text-white rounded-2xl font-black text-[11px] uppercase tracking-widest shadow-xl shadow-slate-900/20 hover:bg-slate-800 transition-all active:scale-95"
          >
            Confirmar Alterações
          </button>
        </div>
      </div>
    </div>
  );
};

export default SettingsModal;
