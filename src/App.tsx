import React, { useState, useEffect, Suspense } from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { Loader2 } from 'lucide-react';

// Hooks & Services
import { useProfeplanAuth } from './hooks/useProfeplanAuth';
import { useProfeplanSettings } from './hooks/useProfeplanSettings';
import { runDiagnostics } from './services/diagnosticService';
import { ToolMode } from './types';

// Components & Layouts
import { MainLayout } from './layouts/MainLayout';
import { FeatureRenderer } from './components/FeatureRenderer';
import ErrorBoundary from './components/ErrorBoundary';
import { ReloadPrompt } from './components/ReloadPrompt';
import LoginScreen from './components/LoginScreen';
import { GlobalPlanningProvider } from './contexts/GlobalPlanningContext';

// Lazy Pages
const LandingPage = React.lazy(() => import('./pages/LandingPage'));
const PrivacyPolicy = React.lazy(() => import('./pages/PrivacyPolicy'));
const TermsOfService = React.lazy(() => import('./pages/TermsOfService'));
const VerifyEmail = React.lazy(() => import('./pages/VerifyEmail'));
const UserProfileSetup = React.lazy(() => import('./pages/UserProfileSetup'));

const PageLoader = () => (
  <div className="flex items-center justify-center h-full w-full bg-slate-50 text-slate-400">
    <Loader2 className="animate-spin mr-2" />
    <span className="text-sm font-medium">Carregando...</span>
  </div>
);

const App: React.FC = () => {
  // 1. BUSINESS LOGIC (Hooks)
  const { session, setSession, userProfile, loading, refreshProfile } = useProfeplanAuth();
  const { settings, setSettings } = useProfeplanSettings();

  // 2. UI STATE (Orchestration)
  const [activeMode, setActiveMode] = useState<ToolMode>(ToolMode.CHAT);
  const [isMobileNavOpen, setIsMobileNavOpen] = useState(false);
  const [isLeftNavExpanded, setIsLeftNavExpanded] = useState(true);
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const [isSubscriptionOpen, setIsSubscriptionOpen] = useState(false);
  const [customSidebar, setCustomSidebar] = useState<React.ReactNode | null>(null);

  // Feature specific states (can be moved to contexts later if needed)
  const [availableClasses] = useState<any[]>([]); // Future: useClasses()
  const [selectedClassId] = useState<string>('');
  const [quarter] = useState('');
  const [enemArea] = useState('Ciências Humanas');

  // 3. EFFECTS
  useEffect(() => {
    setCustomSidebar(null);
  }, [activeMode]);

  useEffect(() => {
    // Expose Diagnostics
    (window as any).runDebug = async () => {
      console.log("🔍 Running System Diagnostics...");
      const results = await runDiagnostics();
      console.table(results);
      return results;
    };
  }, []);

  if (loading) return <PageLoader />;

  return (
    <ErrorBoundary>
      <BrowserRouter>
        <ReloadPrompt />
        <Suspense fallback={<PageLoader />}>
          <Routes>
            {/* PUBLIC ROUTES */}
            <Route path="/" element={!session?.isLoggedIn ? <LandingPage /> : <Navigate to="/app" replace />} />
            <Route path="/landing" element={<LandingPage />} />
            <Route path="/privacy" element={<PrivacyPolicy />} />
            <Route path="/terms" element={<TermsOfService />} />
            <Route path="/login" element={!session?.isLoggedIn ? <LoginScreen onLogin={setSession} /> : <Navigate to="/app" replace />} />
            <Route path="/signup" element={!session?.isLoggedIn ? <LoginScreen onLogin={setSession} initialMode="signup" /> : <Navigate to="/app" replace />} />

            {/* PROTECTED ROUTES */}
            <Route path="/profile-setup" element={session?.isLoggedIn ? <UserProfileSetup /> : <Navigate to="/login" />} />

            <Route path="/app" element={
              session?.isLoggedIn ? (
                !session.isEmailConfirmed ? (
                  <VerifyEmail userEmail={session.email} onLogout={() => {
                    // Quick Local Logout
                    setSession(null);
                    localStorage.clear();
                    window.location.href = '/';
                  }} />
                ) : (
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
                        // Full logout logic is handled inside Sidebar/MainLayout or here?
                        // Original had it inline. Let's replicate simple effective logout.
                        setSession(null);
                        localStorage.clear();
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
                )
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