import React, { useState, useRef, useEffect, Suspense } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import {
  Send, Bot, User, Menu, X,
  Image as ImageIcon, Database,
  PenTool, BrainCircuit, Loader2, Sparkle,
  RefreshCcw, Info, FileText, Download, Copy, Check, Cloud,
  Mic, MicOff, Square, Key, Crown, AlertCircle, ExternalLink, Lock, Zap
} from 'lucide-react';

// Eager Imports (Critical Path)
import Sidebar from './components/Sidebar';
import LoginScreen from './components/LoginScreen';
// import SettingsModal from './components/SettingsModal'; // Now Lazy
import { getUserProfile, isAdmin, checkAndRewardReferrer } from './services/userService';
import { UserProfile, ToolMode, UserSettings, UserSession } from './types';
import { supabase } from './services/supabaseClient';
import { INITIAL_GREETING } from './constants';
import { GlobalPlanningProvider } from './contexts/GlobalPlanningContext';
import { runDiagnostics } from './services/diagnosticService';
import { getRoleByEmail } from './utils/authUtils';

// Lazy Imports (Code Splitting)
const LandingPage = React.lazy(() => import('./pages/LandingPage'));
const PrivacyPolicy = React.lazy(() => import('./pages/PrivacyPolicy'));
const TermsOfService = React.lazy(() => import('./pages/TermsOfService'));
const VerifyEmail = React.lazy(() => import('./pages/VerifyEmail'));
const UserProfileSetup = React.lazy(() => import('./pages/UserProfileSetup'));
const SchoolDashboard = React.lazy(() => import('./pages/SchoolDashboard'));

const DriveExplorer = React.lazy(() => import('./components/DriveExplorer'));
const AdminPanel = React.lazy(() => import('./components/Admin/AdminPanel').then(module => ({ default: module.AdminPanel }))); // Named export handling if needed, checking imports... AdminPanel was named import in original: `import { AdminPanel } from ...`
const HistoryList = React.lazy(() => import('./components/HistoryList'));
const ClassManager = React.lazy(() => import('./components/ClassManager'));
const PresentationCreator = React.lazy(() => import('./components/PresentationCreator'));
const SettingsModal = React.lazy(() => import('./components/SettingsModal'));
const SubscriptionModal = React.lazy(() => import('./components/SubscriptionModal'));

// Feature Modules
const AssessmentManager = React.lazy(() => import('./features/Assessment/AssessmentManager'));
const PlanningManager = React.lazy(() => import('./features/Planning/PlanningManager'));
const PDIManager = React.lazy(() => import('./features/PDI/PDIManager'));
const TermPlanningManager = React.lazy(() => import('./features/TermPlanning/TermPlanningManager'));

// Loading Fallback
import { ReloadPrompt } from './components/ReloadPrompt';

const PageLoader = () => (
  <div className="flex items-center justify-center h-full w-full bg-slate-50 text-slate-400">
    <Loader2 className="animate-spin mr-2" />
    <span className="text-sm font-medium">Carregando...</span>
  </div>
);


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
      // ASYNC SESSION INITIALIZATION
      const initSession = async () => {
        let profileData = null;
        try {
          profileData = await getUserProfile(session.id);
        } catch (e) { console.warn("Primary fetch failed, attempting healing..."); }

        // SELF-HEALING: If ID invalid/mismatch (DbRole=null), try by Email
        if (!profileData && session.email) {
          console.warn(`[App] Profile not found for ID ${session.id}. Attempting recovery by email...`);
          try {
            const { getProfileByEmail } = await import('./services/userService');
            const { data: recoveredProfile } = await getProfileByEmail(session.email);

            if (recoveredProfile) {
              console.log(`[App] 🩹 SESSION HEALED! ID Mismatch detected.`);
              console.log(`Old ID: ${session.id} -> New ID: ${recoveredProfile.id}`);

              // Patch Session
              session.id = recoveredProfile.id;
              profileData = recoveredProfile;

              // Update Storage immediately
              localStorage.setItem('profeplan_session', JSON.stringify(session));
              localStorage.setItem('supabase_user_id', recoveredProfile.id);
            }
          } catch (err) {
            console.error("Healing failed:", err);
          }
        }

        if (profileData) {
          console.log('[App] Profile loaded:', profileData);
          setUserProfile(profileData);

          // AUTO-CORRECT SESSION ROLE FROM PROFILE
          const derivedRole = profileData.role === 'manager'
            ? 'SCHOOL_MANAGER'
            : (profileData.is_admin ? 'ADMIN' : 'TEACHER');

          if (session.role !== derivedRole) {
            console.log(`[App] Correcting Session Role: ${session.role} -> ${derivedRole}`);
            const newSession = { ...session, role: derivedRole };
            setSession(newSession);
            localStorage.setItem('profeplan_session', JSON.stringify(newSession));
          }

          // Auto-redirect School Manager
          if (profileData.role === 'manager') {
            setActiveMode(ToolMode.SCHOOL_MANAGER);
          }
        } else {
          console.error('[App] Failed to load user profile (Fatal)');
        }
      };

      initSession();
    }
  }, [session?.id]);

  // Listener para mudanças de autenticação (Web e Mobile)
  useEffect(() => {
    // 1. Setup Auth State Listener (handles OAuth callbacks automatically)
    const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, session) => {
      console.log('[App] Auth State Change:', event, session?.user?.email);

      if (event === 'SIGNED_IN' && session) {
        // Busca o profile
        let profile = await getUserProfile(session.user.id);

        // Se não existe profile, cria um automaticamente
        if (!profile) {
          console.log('[App] Profile not found, creating default profile...');

          const { error: insertError } = await supabase.from('profiles').insert({
            id: session.user.id,
            email: session.user.email,
            role: getRoleByEmail(session.user.email || ''),
            tier: 'SILVER',
            credits: 10,
            is_unlimited: false,
            is_admin: false,
            allowed_features: ['all']
          });

          if (insertError) {
            console.error('[App] Failed to create profile:', insertError);
          } else {
            console.log('[App] Profile created successfully');
            // Check for referral reward
            await checkAndRewardReferrer(session.user.email);
            // Busca novamente o profile recém criado
            profile = await getUserProfile(session.user.id);
            console.log('[App] Profile reloaded after creation:', profile);
          }
        } else {
          console.log('[App] Profile found:', profile);
        }

        const newSession: UserSession = {
          id: session.user.id,
          email: session.user.email || '',
          role: profile?.is_admin ? 'ADMIN' : (profile?.role === 'manager' ? 'SCHOOL_MANAGER' : 'TEACHER'),
          accessLevel: (profile?.tier as any) || 'BASICO',
          isLoggedIn: true,
          isEmailConfirmed: !!session.user.email_confirmed_at
        };

        console.log('[App] Updating session after auth state change:', newSession);
        setSession(newSession);
        setUserProfile(profile);
        localStorage.setItem('profeplan_session', JSON.stringify(newSession));
        localStorage.setItem('supabase_user_id', session.user.id);
      } else if (event === 'SIGNED_OUT') {
        console.log('[App] User signed out');
        setSession(null);
        setUserProfile(null);
        localStorage.removeItem('profeplan_session');
        localStorage.removeItem('supabase_user_id');
      }
    });

    // 2. Listener para Deep Links (OAuth no Mobile - Capacitor)
    import('@capacitor/app').then(({ App }) => {
      App.addListener('appUrlOpen', (data) => {
        const url = new URL(data.url);

        // Handle Stripe Callbacks
        if (url.searchParams.get('success') === 'true') {
          alert('✅ Pagamento processado! Seus créditos serão atualizados em instantes.');
        }

        // Handle OAuth Deep Links (Capacitor)
        const hash = url.hash.substring(1);
        const params = new URLSearchParams(hash);
        const access_token = params.get('access_token');
        const refresh_token = params.get('refresh_token');

        if (access_token && refresh_token) {
          supabase.auth.setSession({ access_token, refresh_token });
          // onAuthStateChange listener acima cuidará do resto
        }
      });
    }).catch(() => {
      // Capacitor não disponível (web), ignorar
    });

    return () => {
      subscription.unsubscribe();
    };
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

  // DIAGNOSTICS EXPOSURE
  useEffect(() => {
    (window as any).runDebug = async () => {
      console.log("🔍 Iniciando Diagnóstico de Sistema...");
      const results = await runDiagnostics();
      console.table(results);
      return results;
    };
    // Auto-run on mount if in production to catch early issues silently
    if (import.meta.env.PROD) {
      console.log("System Ready. Type 'await runDebug()' to check connections.");
    }
  }, []);

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





  const mapModeToType = (mode: ToolMode): 'plano' | 'aula' | 'avaliacao' | 'documento' | 'trimestral' | 'enem' | 'chat' => {
    switch (mode) {
      case ToolMode.PLANNING: return 'plano';
      case ToolMode.QUARTERLY_PLANNING: return 'trimestral';
      case ToolMode.ACTIVITIES: return 'aula';
      case ToolMode.SIMULATION: return 'avaliacao';
      case ToolMode.ENEM_BANK: return 'enem';
      case ToolMode.SPECIALIST: return 'chat'; // Reuses chat interface but with different prompts
      default: return 'documento';
    }
  };



  return (
    <BrowserRouter>
      <ReloadPrompt />
      <Suspense fallback={<PageLoader />}>
        <Routes>
          <Route path="/" element={!session?.isLoggedIn ? <LandingPage /> : <Navigate to="/app" replace />} />
          <Route path="/landing" element={<LandingPage />} />
          <Route path="/privacy" element={<PrivacyPolicy />} />
          <Route path="/terms" element={<TermsOfService />} />
          <Route path="/login" element={!session?.isLoggedIn ? <LoginScreen onLogin={setSession} /> : <Navigate to="/app" replace />} />
          <Route path="/signup" element={!session?.isLoggedIn ? <LoginScreen onLogin={setSession} initialMode="signup" /> : <Navigate to="/app" replace />} />

          {/* Protected Feature Routes */}
          <Route path="/profile-setup" element={session?.isLoggedIn ? <UserProfileSetup /> : <Navigate to="/login" />} />

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
                        console.log('[App] Logout initiated');
                        try {
                          await supabase.auth.signOut();
                        } catch (err) {
                          console.error("Logout error:", err);
                        }
                        setSession(null);
                        setUserProfile(null);
                        localStorage.clear();
                        console.log('[App] Logout complete, reloading...');
                        window.location.href = '/login';
                      }}
                    />

                    <main className={`main-content flex-1 flex flex-col relative h-full transition-all duration-300 ${isLeftNavExpanded ? 'lg:ml-64' : 'lg:ml-20'}`}>
                      <header className="h-16 bg-white/90 backdrop-blur-xl border-b border-slate-100 flex items-center justify-between px-4 md:px-6 z-50 sticky top-0 shadow-sm">
                        <div className="flex items-center gap-4">
                          <button onClick={() => setIsMobileNavOpen(true)} className="lg:hidden p-2 text-slate-500"><Menu size={24} /></button>
                          <div className="flex flex-col">
                            <h2 className="font-black text-slate-900 tracking-tighter uppercase italic text-lg leading-none">PROFEPLAN V3.2</h2>
                            <div className="flex items-center gap-2 mt-1">
                              <span className="w-1.5 h-1.5 bg-emerald-500 rounded-full animate-pulse"></span>
                              <span className="text-[9px] font-black text-slate-400 uppercase tracking-widest">{String(activeMode).toUpperCase()}</span>
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
                        <Suspense fallback={<PageLoader />}>
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

                          ) : activeMode === ToolMode.SCHOOL_MANAGER ? (
                            // School Manager Dashboard - Force render even if profile is null (fallback)
                            <SchoolDashboard userProfile={userProfile || { id: session.id, role: 'manager', email: session.email, school_name: 'Minha Escola', school_id: '' } as any} />

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
                        </Suspense>
                      </div>
                    </main>

                    <aside className={`h-screen bg-white border-l border-slate-100 shrink-0 lg:flex lg:flex-col lg:w-64 p-6 space-y-6 overflow-y-auto ${activeMode === ToolMode.QUARTERLY_PLANNING ? 'hidden' : 'hidden lg:flex'}`}>
                      {customSidebar ? (
                        // Renderiza a Sidebar Customizada (Injetada pelos componentes filhos)
                        <div className="animate-in fade-in slide-in-from-right-10 duration-500">
                          {customSidebar}
                        </div>
                      ) : (
                        <div>
                          <h3 className="font-black text-[10px] uppercase tracking-[0.2em] text-slate-400 italic mb-8">PROFEPLAN V3.2</h3>
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

                    <Suspense fallback={null}>
                      <SettingsModal
                        isOpen={isSettingsOpen} onClose={() => setIsSettingsOpen(false)}
                        settings={settings} setSettings={setSettings}
                        userEmail={session.email}
                        userProfile={userProfile}
                        onRefreshProfile={async () => {
                          if (session?.id) {
                            const profileData = await getUserProfile(session.id);
                            if (profileData) {
                              setUserProfile(profileData);
                              // Manually trigger session update to reflect role change
                              const derivedRole = profileData.role === 'manager'
                                ? 'SCHOOL_MANAGER'
                                : (profileData.is_admin ? 'ADMIN' : 'TEACHER');

                              if (session.role !== derivedRole) {
                                const newSession = { ...session, role: derivedRole };
                                setSession(newSession);
                                localStorage.setItem('profeplan_session', JSON.stringify(newSession));

                                // Auto-redirect School Manager
                                if (profileData.role === 'manager') {
                                  setActiveMode(ToolMode.SCHOOL_MANAGER);
                                } else {
                                  setActiveMode(ToolMode.CHAT); // Fallback to chat for teachers
                                }
                              }
                            }
                          }
                        }}
                      />

                      <SubscriptionModal
                        isOpen={isSubscriptionOpen}
                        onClose={() => setIsSubscriptionOpen(false)}
                        userProfile={userProfile}
                      />
                    </Suspense>
                  </div >
                </GlobalPlanningProvider>
              )
            ) : <Navigate to="/login" replace />
          } />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </Suspense>
    </BrowserRouter>
  );
};

export default App;