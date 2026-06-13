import React from 'react';
import { createBrowserRouter, Navigate } from 'react-router-dom';
import { RootLayout } from '../layouts/RootLayout';
import { AppLayout } from '../layouts/AppLayout';
import { AppErrorPage } from '../components/AppErrorPage';
import { useProfeplanAuth } from '../hooks/useProfeplanAuth';
import { supabase } from '../services/supabaseClient';
import { isAdmin } from '../services/ProfileService';

// Lazy Pages
const LandingPage = React.lazy(() => import('../pages/LandingPage'));
const PrivacyPolicy = React.lazy(() => import('../pages/PrivacyPolicy'));
const TermsOfService = React.lazy(() => import('../pages/TermsOfService'));
const VerifyEmail = React.lazy(() => import('../pages/VerifyEmail'));
const UserProfileSetup = React.lazy(() => import('../pages/UserProfileSetup'));
const LoginScreen = React.lazy(() => import('../components/LoginScreen'));
const SchoolSelectorScreenWrapper = React.lazy(() => import('../components/SchoolSelectorScreenWrapper'));

// Features
const PdiOfficialLayout = React.lazy(() => import('../features/PDI/Official/PdiOfficialLayout').then(m => ({ default: m.PdiOfficialLayout })));
const SimulationAdminPanel = React.lazy(() => import('../features/SimulationFactory').then(m => ({ default: m.AdminPanel })));

const LoginRoute: React.FC<{ initialMode?: 'login' | 'signup' }> = ({ initialMode }) => {
  const { setSession } = useProfeplanAuth();
  return <LoginScreen onLogin={(session) => setSession(session)} initialMode={initialMode} />;
};

const VerifyEmailRoute: React.FC = () => {
  const { session, setSession, setUserProfile } = useProfeplanAuth();

  const handleLogout = async () => {
    localStorage.removeItem('profeplan_session');
    localStorage.removeItem('supabase_user_id');
    setSession(null);
    setUserProfile(null);
    await supabase.auth.signOut();
  };

  return <VerifyEmail userEmail={session?.email || ''} onLogout={handleLogout} />;
};

const SimulationAdminRoute: React.FC = () => {
  const { session, userProfile } = useProfeplanAuth();
  return <SimulationAdminPanel userId={session?.id || ''} isAdmin={isAdmin(userProfile)} />;
};

// A-4: Dedicated admin guard — blocks non-admins from ALL /admin/* routes
const AdminGuard: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const { userProfile, loading } = useProfeplanAuth();
  if (loading) return null;
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
      { path: 'landing', element: <LandingPage /> },
      { path: 'privacy', element: <PrivacyPolicy /> },
      { path: 'terms', element: <TermsOfService /> },
      { path: 'verify-email', element: <VerifyEmailRoute /> },
      { path: 'login', element: <LoginRoute /> },
      { path: 'signup', element: <LoginRoute initialMode="signup" /> },
      
      // Protected Core Routes
      { path: 'profile-setup', element: <UserProfileSetup /> },
      { path: 'select-school', element: <SchoolSelectorScreenWrapper /> }, 
      
      // PDI Routes
      { path: 'pdi/official/:studentId', element: <PdiOfficialLayout /> },

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
