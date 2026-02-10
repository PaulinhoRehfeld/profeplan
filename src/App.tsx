import React, { useState, useEffect, Suspense } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { Loader2 } from 'lucide-react';

// Hooks & Services
import { useProfeplanAuth } from './hooks/useProfeplanAuth';
import { useProfeplanSettings } from './hooks/useProfeplanSettings';
import { useActiveSchool } from './hooks/useActiveSchool';
import { runDiagnostics } from './services/diagnosticService';
import { ToolMode, UserSettings, UserProfile } from './types';

// Components & Layouts
import { MainLayout } from './layouts/MainLayout';
import { FeatureRenderer } from './components/FeatureRenderer';
import ErrorBoundary from './components/ErrorBoundary';
import { ReloadPrompt } from './components/ReloadPrompt';
import LoginScreen from './components/LoginScreen';
import SchoolSelectorScreen from './components/SchoolSelectorScreen';
import { GlobalPlanningProvider } from './contexts/GlobalPlanningContext';
import { PdiOfficialLayout } from './features/PDI/Official/PdiOfficialLayout';

// Lazy Pages
const LandingPage = React.lazy(() => import('./pages/LandingPage'));
const PrivacyPolicy = React.lazy(() => import('./pages/PrivacyPolicy'));
const TermsOfService = React.lazy(() => import('./pages/TermsOfService'));
const VerifyEmail = React.lazy(() => import('./pages/VerifyEmail'));
const UserProfileSetup = React.lazy(() => import('./pages/UserProfileSetup'));

const PageLoader = () => (
  <div className="flex flex-col items-center justify-center h-screen w-screen bg-slate-50 text-slate-400 p-6">
    <div className="flex items-center mb-4">
      <Loader2 className="animate-spin mr-2 text-blue-500" />
      <span className="text-sm font-medium text-slate-600">Preparando seu Workspace...</span>
    </div>
    <div className="flex flex-col gap-2 items-center">
      <p className="text-[10px] text-slate-400 font-bold uppercase tracking-widest">PROFEPLAN v3.9.1</p>
      <button
        onClick={() => {
          localStorage.removeItem('profeplan_session');
          window.location.reload();
        }}
        className="text-[9px] uppercase tracking-widest font-black text-blue-500 hover:text-blue-600 transition-colors mt-4 bg-white px-6 py-2 rounded-full border border-slate-200 shadow-sm"
      >
        Tentar Reinício Limpo
      </button>
    </div>
  </div>
);

const App: React.FC = () => {
  // 1. BUSINESS LOGIC (Hooks)
  const { session, setSession, userProfile, loading, refreshProfile } = useProfeplanAuth();
  console.log('[App] Render State - Session:', !!session, 'Loading:', loading);
  const { settings, setSettings } = useProfeplanSettings();
  const {
    activeSchool,
    availableSchools,
    loading: schoolsLoading,
    setActiveSchool,
    needsSelection
  } = useActiveSchool(session?.userId);

  // 2. UI STATE (Orchestration)
  const [activeMode, setActiveMode] = useState<ToolMode>(ToolMode.CHAT);
  const [isMobileNavOpen, setIsMobileNavOpen] = useState(false);
  const [isLeftNavExpanded, setIsLeftNavExpanded] = useState(true);
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const [isSubscriptionOpen, setIsSubscriptionOpen] = useState(false);
  const [customSidebar, setCustomSidebar] = useState<React.ReactNode | null>(null);
  const [retryCount, setRetryCount] = useState(0);

  // Feature specific states (can be moved to contexts later if needed)
  const [availableClasses] = useState<any[]>([]); // Future: useClasses()
  const [selectedClassId] = useState<string>('');
  const [quarter] = useState('');
  const [enemArea] = useState('Ciências Humanas');

  // 3. EFFECTS
  const [showEmergencyReset, setShowEmergencyReset] = useState(false);

  useEffect(() => {
    // Safety Timeout: Force stop loading after 10s and run diagnostics
    if (loading) {
      const timer = setTimeout(async () => {
        console.warn("[App] 🚨 Loader Timeout reached (10s). Running auto-diagnostics...");
        try {
          const results = await runDiagnostics();
          console.table(results);
          setShowEmergencyReset(true);
        } catch (err) {
          console.error("[App] Auto-diagnostic failed:", err);
          setShowEmergencyReset(true);
        }
      }, 10000);
      return () => clearTimeout(timer);
    }
  }, [loading]);

  useEffect(() => {
    // HYDRATION: Sync settings with userProfile (Source of Truth)
    if (userProfile && !loading) {
      console.log("[App] 🔄 [HYDRATION] Initializing Sync from DB Profile...");

      const isDefault = (val: string | undefined | null) =>
        !val || val === 'Professor(a)' || val === 'seu.nome@educacao.mg.gov.br' || val === '1234567-8';

      const updatedSettings = { ...settings };
      let changed = false;

      const syncField = (dbVal: any, localField: keyof UserSettings, label: string) => {
        if (!dbVal) return;

        // Priority: If DB has a REAL value and Local has a DEFAULT value, DB wins.
        const localVal = settings[localField] as string;
        const dbIsReal = !isDefault(dbVal);
        const localIsDefault = isDefault(localVal);

        if (dbIsReal && (localIsDefault || (dbVal !== localVal))) {
          console.log(`[App] 📥 [SYNC] Updating ${label}: '${localVal}' -> '${dbVal}'`);
          (updatedSettings as any)[localField] = dbVal;
          changed = true;
        }
      };

      syncField(userProfile.full_name, 'userName', 'Nome');
      syncField(userProfile.email, 'institutionalEmail', 'Email');
      syncField(userProfile.masp, 'masp', 'MASP');
      syncField(userProfile.city, 'city', 'Cidade');
      syncField(userProfile.inep_code, 'schoolCode', 'INEP');
      syncField(userProfile.school_name, 'institution', 'Escola');

      // Pedagogical Sync
      const pedagogicalFields = [
        'favorite_methodology', 'teaching_style', 'assessment_focus',
        'tone_of_voice', 'header_text', 'footer_text', 'logo_base64'
      ];

      pedagogicalFields.forEach(field => {
        const camelField = field.replace(/_([a-z])/g, g => g[1].toUpperCase()) as keyof UserSettings;
        const dbVal = userProfile[field as keyof UserProfile];
        if (dbVal && dbVal !== settings[camelField]) {
          (updatedSettings as any)[camelField] = dbVal;
          changed = true;
        }
      });

      if (changed) {
        console.log("[App] ✅ [SYNC] Applying data to local state & storage.");
        setSettings(updatedSettings);
        localStorage.setItem('profeplan_settings', JSON.stringify(updatedSettings));
      } else {
        console.log("[App] ℹ️ [SYNC] Local state is already optimized.");
      }
    }
  }, [userProfile, loading]);

  useEffect(() => {
    setCustomSidebar(null);
  }, [activeMode]);

  useEffect(() => {
    // 5. AUTO-RETRY Profile if missing but session exists
    // Limit to 3 retries to avoid 403 flooding (as seen in logs)
    if (!loading && session?.isLoggedIn && !userProfile && retryCount < 3) {
      const timer = setTimeout(() => {
        console.warn(`[App] ⚠️ Session active but profile missing. Retrying sync (${retryCount + 1}/3)...`);
        setRetryCount(prev => prev + 1);
        refreshProfile();
      }, 3000);
      return () => clearTimeout(timer);
    }
  }, [loading, session?.isLoggedIn, !!userProfile, retryCount]);

  useEffect(() => {
    // Expose Diagnostics
    (window as any).runDebug = async () => {
      console.log("🔍 Running System Diagnostics...");
      const results = await runDiagnostics();
      console.table(results);
      return results;
    };
  }, []);

  if (loading && !showEmergencyReset) return <PageLoader />;

  if (showEmergencyReset && loading) {
    return (
      <div className="flex flex-col items-center justify-center h-screen w-screen bg-slate-950 text-white p-6 text-center">
        <Loader2 className="animate-spin w-12 h-12 text-blue-500 mb-6" />
        <h2 className="text-2xl font-black mb-2 tracking-tighter italic">PROFEPLAN v3.9.1</h2>
        <p className="text-slate-400 text-sm mb-8 max-w-md">
          O carregamento está demorando mais que o esperado.
          Isso pode ser um problema temporário de conexão ou cache.
        </p>
        <div className="flex flex-col gap-3">
          <button
            onClick={() => {
              localStorage.removeItem('profeplan_session');
              localStorage.removeItem('supabase_user_id');
              window.location.reload();
            }}
            className="bg-blue-600 hover:bg-blue-500 text-white font-black px-8 py-4 rounded-2xl shadow-xl transition-all active:scale-95 flex items-center gap-2 justify-center"
          >
            Sair e Tentar de Novo
          </button>
          <p className="text-[10px] text-slate-500 font-bold uppercase tracking-widest">
            Suas configurações serão preservadas.
          </p>
        </div>
      </div>
    );
  }

  return (
    <ErrorBoundary>
      <BrowserRouter>
        <ReloadPrompt />
        <Suspense fallback={<PageLoader />}>
          <Routes>
            {/* PUBLIC ROUTES */}
            <Route
              path="/"
              element={
                !session?.isLoggedIn ? (
                  <LandingPage />
                ) : needsSelection ? (
                  <Navigate to="/select-school" replace />
                ) : (
                  <Navigate to="/app" replace />
                )
              }
            />
            <Route path="/landing" element={<LandingPage />} />
            <Route path="/privacy" element={<PrivacyPolicy />} />
            <Route path="/terms" element={<TermsOfService />} />
            <Route
              path="/login"
              element={
                !session?.isLoggedIn ? (
                  <LoginScreen onLogin={setSession} />
                ) : needsSelection ? (
                  <Navigate to="/select-school" replace />
                ) : (
                  <Navigate to="/app" replace />
                )
              }
            />
            <Route
              path="/signup"
              element={
                !session?.isLoggedIn ? (
                  <LoginScreen onLogin={setSession} initialMode="signup" />
                ) : needsSelection ? (
                  <Navigate to="/select-school" replace />
                ) : (
                  <Navigate to="/app" replace />
                )
              }
            />

            {/* PROTECTED ROUTES */}
            <Route path="/profile-setup" element={session?.isLoggedIn ? <UserProfileSetup /> : <Navigate to="/login" />} />

            {/* SCHOOL SELECTION ROUTE */}
            <Route
              path="/select-school"
              element={
                session?.isLoggedIn ? (
                  <SchoolSelectorScreen
                    availableSchools={availableSchools}
                    onSelectSchool={setActiveSchool}
                    loading={schoolsLoading}
                  />
                ) : (
                  <Navigate to="/login" />
                )
              }
            />

            {/* NEW PDI ROUTES */}
            <Route path="/pdi/official/:studentId" element={<PdiOfficialLayout />} />

            <Route path="/app" element={
              session?.isLoggedIn ? (
                <GlobalPlanningProvider>
                  <MainLayout
                    session={session}
                    userProfile={userProfile}
                    settings={settings}
                    setSettings={setSettings}
                    activeMode={activeMode}
                    setActiveMode={setActiveMode}
                    isMobileNavOpen={isMobileNavOpen}
                    setIsMobileNavOpen={setIsMobileNavOpen}
                    isLeftNavExpanded={isLeftNavExpanded}
                    setIsLeftNavExpanded={setIsLeftNavExpanded}
                    customSidebar={customSidebar}
                    isSettingsOpen={isSettingsOpen}
                    setIsSettingsOpen={setIsSettingsOpen}
                    isSubscriptionOpen={isSubscriptionOpen}
                    setIsSubscriptionOpen={setIsSubscriptionOpen}
                    onRefreshProfile={refreshProfile}
                    onLogout={async () => {
                      console.log("[App] 🚪 Initiating targeted logout...");
                      localStorage.removeItem('profeplan_session');
                      localStorage.removeItem('supabase_user_id');
                      setSession(null);
                      const { supabase } = await import('./services/supabaseClient');
                      await supabase.auth.signOut();
                      window.location.href = '/';
                    }}
                  >
                    <FeatureRenderer
                      activeMode={activeMode}
                      setActiveMode={setActiveMode}
                      session={session}
                      userProfile={userProfile}
                      settings={settings}
                      setCustomSidebar={setCustomSidebar}
                      setIsSettingsOpen={setIsSettingsOpen}
                      availableClasses={availableClasses}
                      selectedClassId={selectedClassId}
                      quarter={quarter}
                      enemArea={enemArea}
                    />
                  </MainLayout>
                </GlobalPlanningProvider>
              ) : <Navigate to="/login" replace />
            } />

            {/* FALLBACK */}
            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </Suspense>
      </BrowserRouter>
    </ErrorBoundary>
  );
};

export default App;