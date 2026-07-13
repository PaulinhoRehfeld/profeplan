import React, { useState } from 'react';
import { X, User, Settings, Shield, CreditCard, LogOut } from 'lucide-react';
import { UserSettings } from '../types';

// Subcomponents
import { ProfileTab } from './Settings/Tabs/ProfileTab';
import { ManagerProfileTab } from './Settings/Tabs/ManagerProfileTab';
import { SecurityTab } from './Settings/Tabs/SecurityTab';
import { SubscriptionTab } from './Settings/Tabs/SubscriptionTab';

interface SettingsModalProps {
  isOpen: boolean;
  onClose: () => void;
  settings: UserSettings;
  setSettings: (settings: UserSettings) => void;
  userEmail: string;
  userProfile: any | null;
  onRefreshProfile?: () => Promise<void>;
}

const SettingsModal: React.FC<SettingsModalProps> = ({
  isOpen,
  onClose,
  settings,
  setSettings,
  userEmail,
  userProfile,
  onRefreshProfile,
}) => {
  const [activeTab, setActiveTab] = useState<'profile' | 'security' | 'subscription'>('profile');

  if (!isOpen) return null;

  // Handler to refresh parent and close
  const handleSaveSuccess = async () => {
    if (onRefreshProfile) await onRefreshProfile();
    // We can close or just show success.
    // Logic in ProfileTab calls onClose() after save, so we might just need to refresh here.
    // Actually ProfileTab calls onSaveSuccess THEN onClose.
    // So this function is just for refreshing.
  };

  return (
    <div className="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-[100] flex items-center justify-center p-4">
      <div className="bg-white w-full max-w-4xl rounded-3xl shadow-2xl overflow-hidden flex h-[85vh]">
        {/* Sidebar Navigation */}
        <aside className="w-64 bg-slate-50 border-r border-slate-100 flex flex-col">
          <div className="p-6 border-b border-slate-100/50">
            <div className="flex items-center gap-2 text-slate-800">
              <Settings className="w-5 h-5 text-indigo-600" />
              <h2 className="font-bold tracking-tight">Configurações</h2>
            </div>
          </div>

          <nav className="flex-1 p-4 space-y-1 overflow-y-auto">
            <button
              onClick={() => setActiveTab('profile')}
              className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-bold transition-all ${
                activeTab === 'profile'
                  ? 'bg-white text-indigo-600 shadow-sm ring-1 ring-slate-100'
                  : 'text-slate-500 hover:bg-slate-100 hover:text-slate-700'
              }`}
            >
              <User className="w-4 h-4" />
              Perfil e Preferências
            </button>

            <button
              onClick={() => setActiveTab('subscription')}
              className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-bold transition-all ${
                activeTab === 'subscription'
                  ? 'bg-white text-indigo-600 shadow-sm ring-1 ring-slate-100'
                  : 'text-slate-500 hover:bg-slate-100 hover:text-slate-700'
              }`}
            >
              <CreditCard className="w-4 h-4" />
              Assinatura e Acesso
            </button>

            <button
              onClick={() => setActiveTab('security')}
              className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl text-sm font-bold transition-all ${
                activeTab === 'security'
                  ? 'bg-white text-indigo-600 shadow-sm ring-1 ring-slate-100'
                  : 'text-slate-500 hover:bg-slate-100 hover:text-slate-700'
              }`}
            >
              <Shield className="w-4 h-4" />
              Segurança
            </button>
          </nav>

          <div className="p-4 border-t border-slate-100">
            <button
              onClick={onClose}
              className="w-full flex items-center gap-2 px-4 py-3 text-slate-400 hover:text-slate-600 hover:bg-slate-100 rounded-xl text-xs font-bold uppercase tracking-wider transition-all"
            >
              <LogOut className="w-4 h-4" />
              Fechar
            </button>
          </div>
        </aside>

        {/* Main Content Area */}
        <main className="flex-1 flex flex-col bg-white overflow-hidden relative">
          {/* Header Mobile Only (if needed) - Keeping it clean desktop first */}
          <div className="absolute top-4 right-4 z-10 md:hidden">
            <button onClick={onClose} className="p-2 bg-slate-100 rounded-full">
              <X className="w-5 h-5 text-slate-500" />
            </button>
          </div>

          <div className="flex-1 overflow-y-auto p-8 md:p-12">
            <div className="max-w-2xl mx-auto">
              {activeTab === 'profile' && (
                <div className="animate-in slide-in-from-right-4 duration-300">
                  <h3 className="text-2xl font-bold text-slate-800 mb-6">
                    {userProfile?.role === 'manager' ? '🏫 Gestão Escolar' : 'Perfil Profissional'}
                  </h3>

                  {/* ROTEAMENTO: Manager vs Teacher */}
                  {userProfile?.role === 'manager' ? (
                    <ManagerProfileTab
                      userProfile={userProfile}
                      onSaveSuccess={async () => {
                        if (onRefreshProfile) await onRefreshProfile();
                      }}
                      onClose={onClose}
                    />
                  ) : (
                    <ProfileTab
                      userProfile={userProfile}
                      initialSettings={settings}
                      setSettings={setSettings}
                      onSaveSuccess={async () => {
                        if (onRefreshProfile) await onRefreshProfile();
                      }}
                      onClose={onClose}
                    />
                  )}
                </div>
              )}

              {activeTab === 'security' && (
                <div className="animate-in slide-in-from-right-4 duration-300">
                  <h3 className="text-2xl font-bold text-slate-800 mb-6">Segurança</h3>
                  <SecurityTab userEmail={userEmail} />
                </div>
              )}

              {activeTab === 'subscription' && (
                <div className="animate-in slide-in-from-right-4 duration-300">
                  <h3 className="text-2xl font-bold text-slate-800 mb-6">Assinatura</h3>
                  <SubscriptionTab userProfile={userProfile} onRefreshProfile={onRefreshProfile} />
                </div>
              )}
            </div>
          </div>
        </main>
      </div>
    </div>
  );
};

export default SettingsModal;
