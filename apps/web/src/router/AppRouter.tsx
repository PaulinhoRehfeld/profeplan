import React from 'react';
import { createBrowserRouter } from 'react-router-dom';
import { RootLayout } from '../layouts/RootLayout';
import { AppLayout } from '../layouts/AppLayout';
import { AppErrorPage } from '../components/AppErrorPage';

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
      { path: 'verify-email', element: <VerifyEmail /> },
      { path: 'login', element: <LoginScreen /> },
      { path: 'signup', element: <LoginScreen initialMode="signup" /> },
      
      // Protected Core Routes
      { path: 'profile-setup', element: <UserProfileSetup /> },
      { path: 'select-school', element: <SchoolSelectorScreenWrapper /> }, 
      
      // Features
      { path: 'pdi/official/:studentId', element: <PdiOfficialLayout /> },
      { path: 'admin/simulations', element: <SimulationAdminPanel userId="" isAdmin={true} /> }, // Will fix props internally later

      // The Main App Dashboard
      {
        path: 'app',
        element: <AppLayout />,
      }
    ]
  }
]);
