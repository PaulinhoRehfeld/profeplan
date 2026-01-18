import React, { useState, useRef, useEffect } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import LandingPage from './pages/LandingPage';
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
import VerifyEmail from './pages/VerifyEmail'; // NOVO: Bloqueio de Email
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
import { getUserProfile, UserProfile, isAdmin } from './services/userService';
import { supabase } from './services/supabaseClient';
import SubscriptionModal from './components/SubscriptionModal';
import { Lock, Zap } from 'lucide-react'; // Added Lock, Zap imports
// import PresentationModal from './components/PresentationModal'; // REMOVIDO

// Tipos e Serviços
import { ToolMode, UserSettings, UserSession } from './types';
import { INITIAL_GREETING } from './constants';



// --- PAYWALL COMPONENT ---
// PaywallGuard removed as per user request (unrestricted access)

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

  // Listener para Deep Links (OAuth no Mobile)
  useEffect(() => {
    import('@capacitor/app').then(({ App }) => {
      App.addListener('appUrlOpen', (data) => {
        // Extrai o hash da URL (ex: com.profeplan.app://login-callback#access_token=...)
        // O Supabase envia os tokens no fragmento (#)
        const url = new URL(data.url);

        // 1. Handle Stripe Callbacks (Query Params)
        // URL Format: com.profeplan.app://stripe-callback?session_id=...&success=true
        if (url.searchParams.get('success') === 'true') {
          // Not using 'alert' generally but for quick feedback it is fine.
          // Ideally we would set a toast state.
          // For now, let's just log or maybe set a query param to trigger a toast if we had one.
          // But actually default android alert is synchronous and blocking.
          // Let's use a console log and maybe a simple native dialog if possible, or just let the user see the credits update.
          // Given the user asked for "redirect", just returning to the app is the main thing.
          // But I will add a simple alert for feedback as requested in my mental model.
          alert('✅ Pagamento processado! Seus créditos serão atualizados em instantes.');
        }

        const hash = url.hash.substring(1); // remove o #
        const params = new URLSearchParams(hash);

        const access_token = params.get('access_token');
        const refresh_token = params.get('refresh_token');

        if (access_token && refresh_token) {
          // Define a sessão manualmente usando os tokens recebidos
          // Precisamos da instância do supabase aqui. Vamos importar do services se não tiver.
          // Mas App.tsx não importa 'supabase' diretamente. Vamos adicionar o import.
          import('./services/supabaseClient').then(({ supabase }) => {
            supabase.auth.setSession({
              access_token,
              refresh_token,
            }).then(({ data, error }) => {
              if (!error && data.session) {
                // A sessão será atualizada e capturada pelo onAuthStateChange se houver, 
                // ou podemos forçar um reload ou update de estado.
                // Como o App.tsx lê do localStorage no inicio, e o LoginScreen salva...
                // Precisamos garantir que o estado 'session' seja atualizado.

                // Busca o profile e atualiza o estado
                getUserProfile(data.session.user.id).then(profile => {
                  const newSession: UserSession = {
                    id: data.session!.user.id,
                    email: data.session!.user.email || '',
                    role: profile?.is_admin ? 'ADMIN' : 'TEACHER', // Use profile role or default
                    accessLevel: (profile?.tier as any) || 'BASICO',
                    isLoggedIn: true,
                    isEmailConfirmed: !!data.session!.user.email_confirmed_at // Check confirmation from session
                  };
                  setSession(newSession);
                  setUserProfile(profile);
                  localStorage.setItem('profeplan_session', JSON.stringify(newSession));
                });
              }
            });
          });
        }
      });
    });
  }, []);

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

  const [isSubscriptionOpen, setIsSubscriptionOpen] = useState(false);





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
    <BrowserRouter>
      <Routes>
        <Route path="/" element={!session?.isLoggedIn ? <LandingPage /> : <Navigate to="/app" replace />} />
        <Route path="/landing" element={<LandingPage />} />
        <Route path="/login" element={!session?.isLoggedIn ? <LoginScreen onLogin={setSession} /> : <Navigate to="/app" replace />} />
        <Route path="/signup" element={!session?.isLoggedIn ? <LoginScreen onLogin={setSession} initialMode="signup" /> : <Navigate to="/app" replace />} />
        <Route path="/app" element={
          session?.isLoggedIn ? (
            // SECURITY CHECK: Email must be confirmed
            !session.isEmailConfirmed ? (
              <VerifyEmail userEmail={session.email} onLogout={() => {
                setSession(null);
                localStorage.removeItem('profeplan_session');
              }} />
            ) : (
              <GlobalPlanningProvider>
                <div className="app-container flex h-screen bg-slate-50 overflow-hidden font-sans">
                  <Sidebar
                    activeMode={activeMode} setActiveMode={setActiveMode}
                    onOpenSettings={() => setIsSettingsOpen(true)}
                    isOpen={isMobileNavOpen} onClose={() => setIsMobileNavOpen(false)}
                    userRole={session.role} isDesktopExpanded={isLeftNavExpanded}
                    onToggleDesktopExpand={() => setIsLeftNavExpanded(prev => !prev)}
                    userProfile={userProfile}
                    onOpenSubscription={() => setIsSubscriptionOpen(true)}
                    onLogout={async () => {
                      await supabase.auth.signOut();
                      setSession(null);
                      localStorage.removeItem('profeplan_session');
                      localStorage.removeItem('supabase_user_id'); // Optional: clear exact keys if any
                    }}
                  />

                  <main className={`main-content flex-1 flex flex-col relative h-full transition-all duration-300 ${isLeftNavExpanded ? 'lg:ml-64' : 'lg:ml-20'}`}>
                    <header className="h-16 bg-white/90 backdrop-blur-xl border-b border-slate-100 flex items-center justify-between px-4 md:px-6 z-50 sticky top-0 shadow-sm">
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
                        <div className="flex-1 overflow-hidden h-full w-full bg-slate-50">
                          <DriveExplorer userId={session.id} userEmail={session.email} settings={settings} />
                        </div>
                      ) : activeMode === ToolMode.ADMIN ? (
                        // Protect Admin Route
                        isAdmin(userProfile) ? (
                          <div className="flex-1 overflow-y-auto px-4 md:px-20 py-10">
                            <AdminPanel />
                          </div>
                        ) : (
                          <div className="flex-1 flex items-center justify-center flex-col text-slate-400">
                            <Lock size={48} className="mb-4 text-slate-300" />
                            <p>Acesso Restrito</p>
                          </div>
                        )
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
                        // --- CORE TOOLS (PLANNING, ETC) WITH PAYWALL CHECK ---
                        // --- CORE TOOLS (PLANNING, ETC) - ABERTO (SEM BLOQUEIO) ---
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

                  <aside className={`h-screen bg-white border-l border-slate-100 flex-col shrink-0 lg:flex lg:w-64 p-6 space-y-6 overflow-y-auto ${activeMode === ToolMode.QUARTERLY_PLANNING ? 'hidden' : 'hidden lg:flex'}`}>
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

                  <SubscriptionModal
                    isOpen={isSubscriptionOpen}
                    onClose={() => setIsSubscriptionOpen(false)}
                    userProfile={userProfile}
                  />
                </div >
              </GlobalPlanningProvider>
            )
          ) : <Navigate to="/login" replace />
        } />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </BrowserRouter>
  );
};

export default App;