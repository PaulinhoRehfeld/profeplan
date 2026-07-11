import React, { Suspense } from 'react';
import { createBrowserRouter, Navigate } from 'react-router-dom';
import { RootLayout } from '../layouts/RootLayout';
import { AppLayout } from '../layouts/AppLayout';
import { AppErrorPage } from '../components/AppErrorPage';
import { useProfeplanAuth } from '../hooks/useProfeplanAuth';
import { supabase } from '../services/supabaseClient';
import { isAdmin } from '../services/ProfileService';
import { clearLocalSession } from '../utils/authUtils';

// Lazy Pages
const LandingPage = React.lazy(() => import('../pages/LandingPage'));
const PrivacyPolicy = React.lazy(() => import('../pages/PrivacyPolicy'));
const TermsOfService = React.lazy(() => import('../pages/TermsOfService'));
const VerifyEmail = React.lazy(() => import('../pages/VerifyEmail'));
const UserProfileSetup = React.lazy(() => import('../pages/UserProfileSetup'));
const LoginScreen = React.lazy(() => import('../components/LoginScreen'));
const SchoolSelectorScreenWrapper = React.lazy(() => import('../components/SchoolSelectorScreenWrapper'));
const ComparativoPage = React.lazy(() => import('../pages/ComparativoPage'));

// Features
const PdiOfficialLayout = React.lazy(() => import('../features/PDI/Official/PdiOfficialLayout').then(m => ({ default: m.PdiOfficialLayout })));
const SimulationAdminPanel = React.lazy(() => import('../features/SimulationFactory').then(m => ({ default: m.AdminPanel })));

const PageLoader: React.FC = () => (
  <div className="min-h-screen flex items-center justify-center bg-gray-50 dark:bg-gray-900">
    <div className="w-8 h-8 border-4 border-blue-600 border-t-transparent rounded-full animate-spin" />
  </div>
);

const LoginRoute: React.FC<{ initialMode?: 'login' | 'signup' }> = ({ initialMode }) => {
  const { setSession } = useProfeplanAuth();
  return (
    <Suspense fallback={<PageLoader />}>
      <LoginScreen onLogin={(session) => setSession(session)} initialMode={initialMode} />
    </Suspense>
  );
};

const VerifyEmailRoute: React.FC = () => {
  const { session, setSession, setUserProfile } = useProfeplanAuth();

  const handleLogout = async () => {
    clearLocalSession();
    setSession(null);
    setUserProfile(null);
    await supabase.auth.signOut();
  };

  return (
    <Suspense fallback={<PageLoader />}>
      <VerifyEmail userEmail={session?.email || ''} onLogout={handleLogout} />
    </Suspense>
  );
};

const SimulationAdminRoute: React.FC = () => {
  const { session, userProfile } = useProfeplanAuth();
  return (
    <Suspense fallback={<PageLoader />}>
      <SimulationAdminPanel userId={session?.id || ''} isAdmin={isAdmin(userProfile)} />
    </Suspense>
  );
};

// A-4: Dedicated admin guard — blocks non-admins from ALL /admin/* routes
const AdminGuard: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { userProfile, loading } = useProfeplanAuth();
  if (loading) return <PageLoader />;
  if (!isAdmin(userProfile)) return <Navigate to="/app" replace />;
  return <>{children}</>;
};

export const router = createBrowserRouter([
  {
    path: '/',
    element: <RootLayout />,
    errorElement: <AppErrorPage />, // Global Error Boundary
    children: [
      // Public / Auth Routes
      { path: 'landing', element: <Suspense fallback={<PageLoader />}><LandingPage /></Suspense> },
      { path: 'privacy', element: <Suspense fallback={<PageLoader />}><PrivacyPolicy /></Suspense> },
      { path: 'terms', element: <Suspense fallback={<PageLoader />}><TermsOfService /></Suspense> },
      { path: 'verify-email', element: <VerifyEmailRoute /> },
      { path: 'login', element: <LoginRoute /> },
      { path: 'signup', element: <LoginRoute initialMode="signup" /> },
      { path: 'road', element: <Suspense fallback={<PageLoader />}><ComparativoPage /></Suspense> },

      // Protected Core Routes
      { path: 'profile-setup', element: <Suspense fallback={<PageLoader />}><UserProfileSetup /></Suspense> },
      { path: 'select-school', element: <Suspense fallback={<PageLoader />}><SchoolSelectorScreenWrapper /></Suspense> },

      // PDI Routes
      { path: 'pdi/official/:studentId', element: <Suspense fallback={<PageLoader />}><PdiOfficialLayout /></Suspense> },

      // Admin Routes (all protected by AdminGuard)
      {
        path: 'admin',
        children: [
          { path: 'simulations', element: <AdminGuard><SimulationAdminRoute /></AdminGuard> },
        ]
      },

      // The Main App Dashboard
      {
        path: 'app',
        element: <AppLayout />,
      }
    ]
  }
]);
