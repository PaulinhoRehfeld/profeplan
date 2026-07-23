import React, { Suspense } from 'react';
import { Outlet, Navigate, useLocation } from 'react-router-dom';
import { Loader2 } from 'lucide-react';
import { useProfeplanAuth } from '../hooks/useProfeplanAuth';
import { useProfeplanSettings } from '../hooks/useProfeplanSettings';
import { useActiveSchool } from '../hooks/useActiveSchool';
import { useAppBootstrap } from '../hooks/useAppBootstrap';
import { ReloadPrompt } from '../components/ReloadPrompt';
import { OfflineIndicator } from '../features/SimulationFactory';
import { AppProviders } from '../providers/AppProviders';

const PageLoader = () => (
  <div className="flex flex-col items-center justify-center h-screen w-screen bg-slate-50 text-slate-400 p-6">
    <div className="flex items-center mb-4">
      <Loader2 className="animate-spin mr-2 text-blue-500" />
      <span className="text-sm font-medium text-slate-600">Carregando...</span>
    </div>
  </div>
);

const EmergencyResetScreen = () => (
  <div className="flex flex-col items-center justify-center h-screen w-screen bg-slate-950 text-white p-6 text-center">
    <Loader2 className="animate-spin w-12 h-12 text-blue-500 mb-6" />
    <h2 className="text-2xl font-black mb-2 tracking-tighter italic">PROFEPLAN v5</h2>
    <p className="text-slate-400 text-sm mb-8 max-w-md">
      O carregamento está demorando mais que o esperado.
    </p>
    <button
      onClick={async () => {
        localStorage.clear();
        sessionStorage.clear();
        if ('serviceWorker' in navigator) {
          const regs = await navigator.serviceWorker.getRegistrations();
          for (const r of regs) await r.unregister();
        }
        window.location.reload();
      }}
      className="bg-blue-600 hover:bg-blue-500 text-white font-black px-8 py-4 rounded-2xl shadow-xl"
    >
      Realizar Limpeza Completa
    </button>
  </div>
);

// This layout decides what to render globally (Auth walls)
export const RootLayout: React.FC = () => {
  const { session, userProfile, loading, refreshProfile } = useProfeplanAuth();
  const { settings, setSettings } = useProfeplanSettings();
  const userId = (session as any)?.userId || (session as any)?.user_id || (session as any)?.id;
  const { needsSelection } = useActiveSchool(userId);
  const location = useLocation();

  const { showEmergencyReset } = useAppBootstrap({
    loading,
    session,
    userProfile,
    settings,
    setSettings,
    refreshProfile,
  });

  if (loading && !showEmergencyReset) return <PageLoader />;
  if (showEmergencyReset && loading) return <EmergencyResetScreen />;

  const isPublicRoute = [
    '/landing',
    '/login',
    '/signup',
    '/privacy',
    '/terms',
    '/verify-email',
    '/road',
  ].includes(location.pathname);
  const isRootRoute = location.pathname === '/';

  if (isRootRoute) {
    if (!session?.isLoggedIn) return <Navigate to="/login" replace />;
    if (needsSelection) return <Navigate to="/select-school" replace />;
    return <Navigate to="/app" replace />;
  }

  // Auth Guard (Redirect unauthenticated users to login)
  if (!session?.isLoggedIn && !isPublicRoute) {
    return <Navigate to="/login" replace />;
  }

  // Logged-in Guard (Redirect authenticated users away from public auth routes)
  if (session?.isLoggedIn && ['/login', '/signup', '/landing'].includes(location.pathname)) {
    if (needsSelection) return <Navigate to="/select-school" replace />;
    return <Navigate to="/app" replace />;
  }

  // School Guard
  if (
    session?.isLoggedIn &&
    needsSelection &&
    !['/select-school', '/profile-setup'].includes(location.pathname)
  ) {
    return <Navigate to="/select-school" replace />;
  }

  return (
    <AppProviders>
      <ReloadPrompt />
      <OfflineIndicator />
      <Suspense fallback={<PageLoader />}>
        <Outlet />
      </Suspense>
    </AppProviders>
  );
};
