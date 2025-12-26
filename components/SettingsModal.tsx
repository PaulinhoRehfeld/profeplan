
import React, { useState, useRef } from 'react';
import { X, User, BookOpen, Settings, Zap, Key, Info, Shield, CheckCircle2, AlertCircle, Loader2, Image as ImageIcon, FileText, Trash2 } from 'lucide-react';
import { UserSettings } from '../types';
import { supabase } from '../services/supabaseClient';

interface SettingsModalProps {
  isOpen: boolean;
  onClose: () => void;
  settings: UserSettings;
  setSettings: (settings: UserSettings) => void;
  onConnectDrive: () => void;
  isDriveConnected: boolean;
  isGeminiApiKeySelected: boolean;
  onSelectGeminiApiKey: () => void;
  userEmail: string;
}

const SettingsModal: React.FC<SettingsModalProps> = ({ 
  isOpen, 
  onClose, 
  settings, 
  setSettings,
  onConnectDrive,
  isDriveConnected,
  isGeminiApiKeySelected,
  onSelectGeminiApiKey,
  userEmail
}) => {
  const [newPassword, setNewPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [passwordChangeLoading, setPasswordChangeLoading] = useState(false);
  const [passwordChangeError, setPasswordChangeError] = useState('');
  const [passwordChangeSuccess, setPasswordChangeSuccess] = useState(false);
  const logoInputRef = useRef<HTMLInputElement>(null);

  if (!isOpen) return null;

  const handleChange = (field: keyof UserSettings, value: string) => {
    setSettings({ ...settings, [field]: value });
  };

  const handleLogoUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setSettings({ ...settings, logoBase64: reader.result as string });
      };
      reader.readAsDataURL(file);
    }
  };

  const handleChangePassword = async () => {
    setPasswordChangeLoading(true);
    setPasswordChangeError('');
    setPasswordChangeSuccess(false);

    if (!newPassword.trim()) {
      setPasswordChangeError('A nova senha não pode ser vazia.');
      setPasswordChangeLoading(false);
      return;
    }

    if (newPassword !== confirmPassword) {
      setPasswordChangeError('As senhas não coincidem.');
      setPasswordChangeLoading(false);
      return;
    }

    try {
      const { error } = await supabase
        .from('authorized_users')
        .update({ access_key: newPassword })
        .eq('email', userEmail);

      if (error) throw error;

      setPasswordChangeSuccess(true);
      setNewPassword('');
      setConfirmPassword('');
      setTimeout(() => setPasswordChangeSuccess(false), 3000);
    } catch (err: any) {
      setPasswordChangeError('Erro ao atualizar senha: ' + err.message);
    } finally {
      setPasswordChangeLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-[100] flex items-center justify-center p-4">
      <div className="bg-white w-full max-w-2xl rounded-3xl shadow-2xl overflow-hidden flex flex-col max-h-[90vh]">
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
          {/* Perfil Profissional */}
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

          {/* NOVO: Personalização de Documentos */}
          <section className="space-y-4">
            <div className="flex items-center gap-2 text-blue-600 font-bold text-[10px] uppercase tracking-[0.15em]">
              <FileText className="w-4 h-4" /> Personalização de Documentos (Exportação)
            </div>
            <div className="bg-slate-50 border border-slate-200 rounded-3xl p-6 space-y-6">
              <div className="flex flex-col md:flex-row gap-6">
                <div className="space-y-2">
                  <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Logo da Instituição</label>
                  <div 
                    onClick={() => logoInputRef.current?.click()}
                    className="w-32 h-32 bg-white border-2 border-dashed border-slate-200 rounded-2xl flex flex-col items-center justify-center cursor-pointer hover:border-blue-400 hover:bg-blue-50 transition-all relative group overflow-hidden"
                  >
                    {settings.logoBase64 ? (
                      <>
                        <img src={settings.logoBase64} alt="Logo" className="w-full h-full object-contain p-2" />
                        <div className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 flex items-center justify-center transition-opacity">
                          <ImageIcon className="text-white w-6 h-6" />
                        </div>
                      </>
                    ) : (
                      <>
                        <ImageIcon className="w-8 h-8 text-slate-300 mb-2" />
                        <span className="text-[8px] font-black text-slate-400 uppercase text-center px-2">Subir Logo (PNG/JPG)</span>
                      </>
                    )}
                  </div>
                  <input type="file" ref={logoInputRef} className="hidden" accept="image/*" onChange={handleLogoUpload} />
                  {settings.logoBase64 && (
                    <button 
                      onClick={() => setSettings({...settings, logoBase64: undefined})}
                      className="text-[9px] font-bold text-red-500 flex items-center gap-1 mt-1 hover:underline"
                    >
                      <Trash2 className="w-3 h-3" /> Remover Logo
                    </button>
                  )}
                </div>

                <div className="flex-1 space-y-4">
                  <div className="space-y-1.5">
                    <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Cabeçalho Personalizado</label>
                    <textarea 
                      value={settings.headerText || ''} 
                      onChange={(e) => handleChange('headerText', e.target.value)}
                      placeholder="Ex: Secretaria de Estado de Educação de MG&#10;Escola Estadual Machado de Assis"
                      className="w-full px-5 py-3 bg-white border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-xs font-bold transition-all min-h-[80px]"
                    />
                  </div>
                  <div className="space-y-1.5">
                    <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Rodapé Personalizado</label>
                    <input 
                      type="text" 
                      value={settings.footerText || ''} 
                      onChange={(e) => handleChange('footerText', e.target.value)}
                      placeholder="Ex: Av. Brasil, 1000 - Centro | (31) 3333-4444"
                      className="w-full px-5 py-3 bg-white border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-xs font-bold transition-all"
                    />
                  </div>
                </div>
              </div>
            </div>
          </section>

          {/* Segurança da Conta */}
          <section className="space-y-4">
            <div className="flex items-center gap-2 text-blue-600 font-bold text-[10px] uppercase tracking-[0.15em]">
              <Shield className="w-4 h-4" /> Segurança da Conta
            </div>
            <div className="bg-slate-50 border border-slate-200 rounded-2xl p-6 space-y-4">
              <h4 className="font-bold text-slate-900">Alterar Chave de Acesso</h4>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Nova Senha</label>
                  <input 
                    type="password" 
                    value={newPassword}
                    onChange={(e) => setNewPassword(e.target.value)}
                    className="w-full px-5 py-3 bg-white border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                    placeholder="••••••••"
                  />
                </div>
                <div className="space-y-1.5">
                  <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1">Confirmar Senha</label>
                  <input 
                    type="password" 
                    value={confirmPassword}
                    onChange={(e) => setConfirmPassword(e.target.value)}
                    className="w-full px-5 py-3 bg-white border border-slate-200 rounded-2xl focus:ring-4 focus:ring-blue-100 focus:border-blue-500 outline-none text-sm font-bold transition-all"
                    placeholder="••••••••"
                  />
                </div>
              </div>

              {passwordChangeError && (
                <div className="flex items-start gap-3 p-3 bg-red-500/10 border border-red-500/20 rounded-xl">
                  <AlertCircle className="w-4 h-4 text-red-400 shrink-0 mt-0.5" />
                  <p className="text-red-400 text-xs font-bold leading-tight">{passwordChangeError}</p>
                </div>
              )}
              {passwordChangeSuccess && (
                <div className="flex items-start gap-3 p-3 bg-emerald-500/10 border border-emerald-500/20 rounded-xl">
                  <CheckCircle2 className="w-4 h-4 text-emerald-400 shrink-0 mt-0.5" />
                  <p className="text-emerald-400 text-xs font-bold leading-tight">Senha alterada com sucesso!</p>
                </div>
              )}

              <button 
                onClick={handleChangePassword}
                disabled={passwordChangeLoading || !newPassword.trim() || !confirmPassword.trim()}
                className="w-full px-6 py-3 bg-blue-600 text-white rounded-xl font-black text-[10px] uppercase tracking-widest transition-all hover:bg-blue-700 flex items-center justify-center gap-2 disabled:opacity-50"
              >
                {passwordChangeLoading ? <Loader2 className="w-4 h-4 animate-spin" /> : <Shield className="w-4 h-4" />}
                {passwordChangeLoading ? 'Alterando...' : 'Alterar Senha'}
              </button>
            </div>
          </section>

          {/* Inteligência e Metodologia */}
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

          {/* Ecossistema Cloud */}
          <section className="space-y-4">
            <div className="flex items-center gap-2 text-blue-600 font-bold text-[10px] uppercase tracking-[0.15em]">
              <Zap className="w-4 h-4" /> Ecossistema Cloud
            </div>
            <div className="bg-slate-50 border border-slate-200 rounded-2xl p-6">
              <div className="flex items-center justify-between mb-2">
                <div className="flex items-center gap-4">
                  <div className="w-12 h-12 bg-white rounded-xl border border-slate-200 flex items-center justify-center shadow-sm">
                    <svg className="w-6 h-6" viewBox="0 0 24 24">
                        <path fill="#0066DA" d="M7.71 3.5L4.6 9l5.45 9.47L13.14 13L7.71 3.5z" />
                        <path fill="#00AC47" d="M18.91 13H7.07l-2.47 4.47l2.47 4.53h11.84l2.47-4.53L18.91 13z" />
                        <path fill="#FFBA00" d="M16.29 3.5H7.71L13.14 13l5.45-9.5z" />
                    </svg>
                  </div>
                  <div>
                    <h4 className="font-bold text-slate-900">Google Drive</h4>
                    <p className="text-xs text-slate-500">Sincronização para exportação automática</p>
                  </div>
                </div>
                <button 
                  onClick={onConnectDrive}
                  className={`px-6 py-2.5 rounded-xl font-black text-[10px] uppercase tracking-widest transition-all ${
                    isDriveConnected ? 'bg-emerald-50 text-emerald-600 border border-emerald-200 cursor-default' : 'bg-blue-600 text-white hover:bg-blue-700'
                  }`}
                >
                  {isDriveConnected ? 'Conectado ✓' : 'Conectar'}
                </button>
              </div>
            </div>
          </section>
        </div>

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
