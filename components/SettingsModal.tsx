
import React from 'react';
import { X, User, BookOpen, Settings, Zap, Globe, Monitor } from 'lucide-react';
import { UserSettings } from '../types';

interface SettingsModalProps {
  isOpen: boolean;
  onClose: () => void;
  settings: UserSettings;
  setSettings: (settings: UserSettings) => void;
}

const SettingsModal: React.FC<SettingsModalProps> = ({ isOpen, onClose, settings, setSettings }) => {
  if (!isOpen) return null;

  const handleChange = (field: keyof UserSettings, value: string) => {
    setSettings({ ...settings, [field]: value });
  };

  return (
    <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-[100] flex items-center justify-center p-4">
      <div className="bg-white w-full max-w-2xl rounded-3xl shadow-2xl overflow-hidden flex flex-col max-h-[90vh]">
        <div className="p-6 border-b border-slate-100 flex items-center justify-between bg-slate-50">
          <div className="flex items-center gap-3">
            <Settings className="w-5 h-5 text-blue-600" />
            <h2 className="text-xl font-bold text-slate-800">Configurações do Perfil</h2>
          </div>
          <button onClick={onClose} className="p-2 hover:bg-slate-200 rounded-full transition-colors">
            <X className="w-5 h-5 text-slate-500" />
          </button>
        </div>

        <div className="flex-1 overflow-y-auto p-8 space-y-8">
          {/* Perfil Profissional */}
          <section className="space-y-4">
            <div className="flex items-center gap-2 text-blue-600 font-bold text-xs uppercase tracking-widest">
              <User className="w-4 h-4" /> Perfil Profissional
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-1">
                <label className="text-xs font-semibold text-slate-500">Nome do Professor</label>
                <input 
                  type="text" value={settings.userName} 
                  onChange={(e) => handleChange('userName', e.target.value)}
                  className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none text-sm"
                  placeholder="Ex: Prof. Ricardo Silva"
                />
              </div>
              <div className="space-y-1">
                <label className="text-xs font-semibold text-slate-500">Escola/Instituição Padrão</label>
                <input 
                  type="text" value={settings.institution} 
                  onChange={(e) => handleChange('institution', e.target.value)}
                  className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none text-sm"
                  placeholder="Nome da Escola"
                />
              </div>
              <div className="space-y-1">
                <label className="text-xs font-semibold text-slate-500">Rede de Ensino</label>
                <select 
                  value={settings.network} 
                  onChange={(e) => handleChange('network', e.target.value as any)}
                  className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none text-sm"
                >
                  <option value="">Selecione...</option>
                  <option value="Estadual">Rede Estadual</option>
                  <option value="Municipal">Rede Municipal</option>
                  <option value="Privada">Rede Privada</option>
                </select>
              </div>
              <div className="space-y-1">
                <label className="text-xs font-semibold text-slate-500">Estado (UF) para Currículo</label>
                <input 
                  type="text" value={settings.stateUF} 
                  onChange={(e) => handleChange('stateUF', e.target.value)}
                  className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none text-sm"
                  placeholder="Ex: SP, RJ, RS..."
                />
              </div>
            </div>
          </section>

          {/* Preferências Pedagógicas */}
          <section className="space-y-4">
            <div className="flex items-center gap-2 text-blue-600 font-bold text-xs uppercase tracking-widest">
              <BookOpen className="w-4 h-4" /> Inteligência Pedagógica
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div className="space-y-1">
                <label className="text-xs font-semibold text-slate-500">Metodologia Favorita</label>
                <select 
                  value={settings.favoriteMethodology} 
                  onChange={(e) => handleChange('favoriteMethodology', e.target.value)}
                  className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none text-sm"
                >
                  <option value="Tradicional">Tradicional</option>
                  <option value="Gamificação">Gamificação</option>
                  <option value="Sala de Aula Invertida">Sala de Aula Invertida</option>
                  <option value="Aprendizagem Baseada em Problemas (ABP)">ABP</option>
                  <option value="Ensino Híbrido">Ensino Híbrido</option>
                </select>
              </div>
              <div className="space-y-1">
                <label className="text-xs font-semibold text-slate-500">Tom de Voz da IA</label>
                <select 
                  value={settings.toneOfVoice} 
                  onChange={(e) => handleChange('toneOfVoice', e.target.value as any)}
                  className="w-full px-4 py-2 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none text-sm"
                >
                  <option value="Técnico e Formal">Técnico e Formal</option>
                  <option value="Prático e Inspiracional">Prático e Inspiracional</option>
                </select>
              </div>
            </div>
          </section>

          {/* Sistema */}
          <section className="space-y-4">
            <div className="flex items-center gap-2 text-blue-600 font-bold text-xs uppercase tracking-widest">
              <Zap className="w-4 h-4" /> Sistema e Integrações
            </div>
            <div className="bg-slate-50 p-4 rounded-2xl border border-slate-100 flex items-center justify-between">
              <div className="flex items-center gap-3">
                <div className="p-2 bg-white rounded-lg shadow-sm">
                  <Globe className="w-4 h-4 text-blue-500" />
                </div>
                <div>
                  <p className="text-sm font-bold text-slate-700">Google Drive</p>
                  <p className="text-[10px] text-slate-500">Sincronização para exportação automática</p>
                </div>
              </div>
              <button className="px-3 py-1.5 bg-blue-600 text-white text-[10px] font-bold rounded-lg hover:bg-blue-700 transition-all">
                CONECTAR
              </button>
            </div>
          </section>
        </div>

        <div className="p-6 border-t border-slate-100 bg-slate-50 flex justify-end gap-3">
          <button 
            onClick={onClose}
            className="px-6 py-2 bg-blue-600 text-white rounded-xl font-bold text-sm shadow-lg shadow-blue-500/30 hover:bg-blue-700 transition-all"
          >
            Salvar Alterações
          </button>
        </div>
      </div>
    </div>
  );
};

export default SettingsModal;
