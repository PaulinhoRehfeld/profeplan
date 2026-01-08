import React, { useState, useRef, useEffect } from 'react';
import {
  Send, Bot, User, Menu, X,
  Image as ImageIcon, Database,
  PenTool, BrainCircuit, Loader2, Sparkle,
  RefreshCcw, Info, FileText, Download, Copy, Check, Cloud,
  Mic, MicOff, Square, Key, Crown, AlertCircle, ExternalLink
} from 'lucide-react';

// Componentes Locais
import Sidebar from './components/Sidebar';
import SettingsModal from './components/SettingsModal';
import LoginScreen from './components/LoginScreen';
import DriveExplorer from './components/DriveExplorer';
import MarkdownRenderer from './components/MarkdownRenderer';
// import AdminDashboard from './components/AdminDashboard'; // REMOVE
import { AdminPanel } from './components/Admin/AdminPanel';
import HistoryList from './components/HistoryList';
import ClassManager from './components/ClassManager';
import AssessmentManager from './features/Assessment/AssessmentManager';
import PlanningManager from './features/Planning/PlanningManager';
import PresentationCreator from './components/PresentationCreator';
import PDIManager from './features/PDI/PDIManager'; // NOVO: Renomeado de InclusionWorkbench
import TermPlanningManager from './features/TermPlanning/TermPlanningManager'; // NOVO: Agente Coordenador
import { GlobalPlanningProvider } from './contexts/GlobalPlanningContext'; // NOVO: Contexto Global
import { getUserProfile, UserProfile } from './services/userService';
// import PresentationModal from './components/PresentationModal'; // REMOVIDO

// Tipos e Serviços
import { ToolMode, UserSettings, UserSession } from './types';
import { INITIAL_GREETING } from './constants';

const App: React.FC = () => {
  const [session, setSession] = useState<UserSession | null>(() => {
    try {
      const saved = localStorage.getItem('profeplan_session');
      return saved ? JSON.parse(saved) : null;
    } catch (e) {
      return null;
    }
  });

  const [userProfile, setUserProfile] = useState<UserProfile | null>(null);

  useEffect(() => {
    if (session?.id) {
      getUserProfile(session.id).then(setUserProfile);
    }
  }, [session?.id]);

  const [settings, setSettings] = useState<UserSettings>(() => {
    try {
      const saved = localStorage.getItem('profeplan_settings');
      return saved ? JSON.parse(saved) : {
        userName: 'Professor(a)',
        institution: '',
        network: 'Estadual',
        stateUF: 'MG',
        favoriteMethodology: 'Gamification',
        toneOfVoice: 'Prático e Inspiracional',
        detailLevel: 'Completo',
        theme: 'light'
      };
    } catch (e) {
      return {
        userName: 'Professor(a)',
        institution: '',
        network: 'Estadual',
        stateUF: 'MG',
        favoriteMethodology: 'Gamification',
        toneOfVoice: 'Prático e Inspiracional',
        detailLevel: 'Completo',
        theme: 'light'
      };
    }
  });

  useEffect(() => {
    localStorage.setItem('profeplan_settings', JSON.stringify(settings));
  }, [settings]);

  const [activeMode, setActiveMode] = useState<ToolMode>(ToolMode.CHAT);
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const [isMobileNavOpen, setIsMobileNavOpen] = useState(false);
  const [error, setError] = useState('');
  const [isLeftNavExpanded, setIsLeftNavExpanded] = useState(true);

  // Estados específicos para os novos modos
  const [quarter, setQuarter] = useState('');
  const [enemArea, setEnemArea] = useState('Ciências Humanas');

  // Turmas
  const [availableClasses, setAvailableClasses] = useState<any[]>([]);
  const [selectedClassId, setSelectedClassId] = useState<string>('');

  // Sidebar Dinâmica (Command Center)
  const [customSidebar, setCustomSidebar] = useState<React.ReactNode | null>(null);

  // Limpa a sidebar customizada ao mudar de modo
  useEffect(() => {
    setCustomSidebar(null);
  }, [activeMode]);


  // Limpa a sidebar customizada ao mudar de modo
  useEffect(() => {
    setCustomSidebar(null);
  }, [activeMode]);




  if (!session || !session.isLoggedIn) {
    return <LoginScreen onLogin={setSession} />;
  }



  const mapModeToType = (mode: ToolMode): 'plano' | 'aula' | 'avaliacao' | 'documento' | 'trimestral' | 'enem' => {
    switch (mode) {
      case ToolMode.PLANNING: return 'plano';
      case ToolMode.QUARTERLY_PLANNING: return 'trimestral';
      case ToolMode.ACTIVITIES: return 'aula';
      case ToolMode.SIMULATION: return 'avaliacao';
      case ToolMode.ENEM_BANK: return 'enem';
      default: return 'documento';
    }
  };



  return (
    <GlobalPlanningProvider>
      <div className="app-container flex h-screen bg-slate-50 overflow-hidden font-sans">
        <Sidebar
          activeMode={activeMode} setActiveMode={setActiveMode}
          onOpenSettings={() => setIsSettingsOpen(true)}
          isOpen={isMobileNavOpen} onClose={() => setIsMobileNavOpen(false)}
          userRole={session.role} isDesktopExpanded={isLeftNavExpanded}
          onToggleDesktopExpand={() => setIsLeftNavExpanded(prev => !prev)}
          userProfile={userProfile}
        />

        <main className={`main-content flex-1 flex flex-col relative h-full transition-all duration-300 ${isLeftNavExpanded ? 'lg:ml-64' : 'lg:ml-20'}`}>
          <header className="h-20 bg-white/90 backdrop-blur-xl border-b border-slate-100 flex items-center justify-between px-4 md:px-10 z-50 sticky top-0 shadow-sm">
            <div className="flex items-center gap-4">
              <button onClick={() => setIsMobileNavOpen(true)} className="lg:hidden p-2 text-slate-500"><Menu size={24} /></button>
              <div className="flex flex-col">
                <h2 className="font-black text-slate-900 tracking-tighter uppercase italic text-lg leading-none">PROFEPLAN v1.0</h2>
                <div className="flex items-center gap-2 mt-1">
                  <span className="w-1.5 h-1.5 bg-emerald-500 rounded-full animate-pulse"></span>
                  <span className="text-[9px] font-black text-slate-400 uppercase tracking-widest">{activeMode}</span>
                </div>
              </div>
            </div>
            <div className="flex items-center gap-4">
              <div className="h-8 w-px bg-slate-100 mx-2"></div>
              <div className="flex items-center gap-3">
                <div className="text-right hidden sm:block">
                  <p className="text-[10px] font-black text-slate-400 uppercase tracking-widest">Workspace de</p>
                  <p className="text-xs font-black text-slate-900">{settings.userName}</p>
                </div>
                <div className="w-10 h-10 bg-slate-900 rounded-2xl flex items-center justify-center text-white font-black text-sm shadow-xl shadow-slate-200">
                  {settings.userName.charAt(0)}
                </div>
              </div>
            </div>
          </header>

          <div className="layout-wrapper flex-1 overflow-hidden relative flex flex-col bg-white">
            {/* Mobile Grid Adjustment: Ensure children components use responsive grids if not handled internally */}
            {activeMode === ToolMode.FILES ? (
              <div className="flex-1 overflow-y-auto px-4 md:px-20 py-10 custom-scrollbar">
                <DriveExplorer userId={session.id} userEmail={session.email} settings={settings} />
              </div>
            ) : activeMode === ToolMode.ADMIN ? (
              <div className="flex-1 overflow-y-auto px-4 md:px-20 py-10">
                <AdminPanel />
              </div>
            ) : activeMode === ToolMode.HISTORY ? (
              <div className="flex-1 overflow-y-auto px-4 md:px-20 py-10 custom-scrollbar">
                <HistoryList
                  userId={session.id}
                  onSelectLesson={(content) => {
                    const storageKey = `profeplan_chat_${session.email}`;
                    const saved = JSON.parse(localStorage.getItem(storageKey) || '[]');
                    saved.push({
                      id: Date.now().toString(),
                      role: 'model', // Hardcoded to avoid importing MessageRole if removing imports
                      content: content,
                      timestamp: new Date()
                    });
                    localStorage.setItem(storageKey, JSON.stringify(saved));
                    setActiveMode(ToolMode.CHAT);
                  }}
                />
              </div>
            ) : activeMode === ToolMode.CLASSES ? (
              <div className="flex-1 overflow-y-auto px-4 md:px-20 py-10 custom-scrollbar">
                <ClassManager userId={session.id} />
              </div>
            ) : activeMode === ToolMode.PRESENTATIONS ? (
              <div className="flex-1 overflow-y-auto px-4 md:px-20 py-10 custom-scrollbar">
                <PresentationCreator userId={session.id} setSidebarContent={setCustomSidebar} />
              </div>
            ) : activeMode === ToolMode.INCLUSION ? (
              <div className="flex-1 overflow-hidden h-full">
                <PDIManager userId={session.id} setSidebarContent={setCustomSidebar} />
              </div>
            ) : activeMode === ToolMode.ASSESSMENT ? (
              <div className="flex-1 overflow-y-auto px-4 md:px-20 py-10 custom-scrollbar">
                <AssessmentManager userId={session.id} settings={settings} setSidebarContent={setCustomSidebar} />
              </div>
            ) : activeMode === ToolMode.QUARTERLY_PLANNING ? (
              <div className="flex-1 overflow-y-auto px-4 md:px-20 py-10 custom-scrollbar bg-slate-50/50">
                <TermPlanningManager userId={session.id} settings={settings} setSidebarContent={setCustomSidebar} />
              </div>
            ) : (
              <PlanningManager
                userId={session.id}
                activeMode={activeMode}
                availableClasses={availableClasses}
                settings={settings}
                selectedClassId={selectedClassId}
                quarter={quarter}
                enemArea={enemArea}
                setSidebarContent={setCustomSidebar}
              />
            )}
          </div>
        </main>

        <aside className={`h-screen bg-white border-l border-slate-100 flex-col shrink-0 lg:flex lg:w-72 p-10 space-y-10 overflow-y-auto ${activeMode === ToolMode.QUARTERLY_PLANNING ? 'hidden' : 'hidden lg:flex'}`}>
          {customSidebar ? (
            // Renderiza a Sidebar Customizada (Injetada pelos componentes filhos)
            <div className="animate-in fade-in slide-in-from-right-10 duration-500">
              {customSidebar}
            </div>
          ) : (
            <div>
              <h3 className="font-black text-[10px] uppercase tracking-[0.2em] text-slate-400 italic mb-8">PROFEPLAN V1.0</h3>
              <p className="text-xs text-slate-500 font-medium">Selecione uma ferramenta no menu ou comece uma conversa para planejar sua aula.</p>
            </div>
          )}

          <div className="pt-10 border-t border-slate-100 mt-auto">
            <div className="bg-gradient-to-br from-slate-950 to-slate-900 p-8 rounded-[2.5rem] text-white shadow-2xl relative overflow-hidden group">
              <div className="absolute top-0 right-0 w-24 h-24 bg-blue-600/10 blur-3xl group-hover:bg-blue-600/20 transition-all"></div>
              <p className="text-[9px] font-black uppercase tracking-[0.3em] text-blue-400 mb-3 flex items-center gap-2">
                <Crown size={12} /> Licença Ativa
              </p>
              <p className="font-black text-lg tracking-tighter italic mb-4 uppercase">{session.accessLevel} ACCOUNT</p>

              {/* Quota Usage / Credits */}
              {userProfile && (
                <div className="mb-4">
                  <div className="flex justify-between text-[10px] font-bold text-blue-200 mb-1">
                    <span>{userProfile.tier === 'GOLD' || userProfile.is_unlimited ? 'PLANO' : 'CRÉDITOS'}</span>
                    <span>{userProfile.tier === 'GOLD' || userProfile.is_unlimited ? 'ILIMITADO' : `${userProfile.credits} Restantes`}</span>
                  </div>
                  {!(userProfile.tier === 'GOLD' || userProfile.is_unlimited) && (
                    <div className="w-full h-2 bg-blue-900/50 rounded-full overflow-hidden">
                      {/* Assuming 50 as a visual max for the bar if credits > 0 */}
                      <div
                        className="h-full bg-blue-400 transition-all duration-500"
                        style={{ width: `${Math.min((userProfile.credits / 50) * 100, 100)}%` }}
                      ></div>
                    </div>
                  )}
                </div>
              )}

              <div className="bg-white/5 p-3 rounded-xl border border-white/10 text-[9px] font-bold text-slate-400 uppercase tracking-widest text-center">
                Sincronizado com Supabase
              </div>
            </div>
          </div>
        </aside>

        <SettingsModal
          isOpen={isSettingsOpen} onClose={() => setIsSettingsOpen(false)}
          settings={settings} setSettings={setSettings}
          userEmail={session.email}
        />
      </div >
    </GlobalPlanningProvider>
  );
};

export default App;