import React from 'react';
import { MainLayout } from './MainLayout';
import { FeatureRenderer } from '../components/FeatureRenderer';
import { useUIStore } from '../stores/useUIStore';
import { useProfeplanAuth } from '../hooks/useProfeplanAuth';
import { useProfeplanSettings } from '../hooks/useProfeplanSettings';
import { supabase } from '../services/supabaseClient';
import { clearLocalSession } from '../utils/authUtils';

export const AppLayout: React.FC = () => {
  const { session, userProfile, refreshProfile, setSession } = useProfeplanAuth();
  const { settings, setSettings } = useProfeplanSettings();

  // Zustand States
  const activeMode = useUIStore((s) => s.activeMode);
  const setActiveMode = useUIStore((s) => s.setActiveMode);
  const isMobileNavOpen = useUIStore((s) => s.isMobileNavOpen);
  const setIsMobileNavOpen = useUIStore((s) => s.setIsMobileNavOpen);
  const isLeftNavExpanded = useUIStore((s) => s.isLeftNavExpanded);
  const setIsLeftNavExpanded = useUIStore((s) => s.setIsLeftNavExpanded);
  const customSidebar = useUIStore((s) => s.customSidebar);
  const setCustomSidebar = useUIStore((s) => s.setCustomSidebar);
  const isSettingsOpen = useUIStore((s) => s.isSettingsOpen);
  const setIsSettingsOpen = useUIStore((s) => s.setIsSettingsOpen);
  const isSubscriptionOpen = useUIStore((s) => s.isSubscriptionOpen);
  const setIsSubscriptionOpen = useUIStore((s) => s.setIsSubscriptionOpen);

  const handleLogout = async () => {
    console.log('[AppLayout] 🚪 Initiating targeted logout...');
    clearLocalSession();
    setSession(null);
    await supabase.auth.signOut();
    window.location.href = '/';
  };

  return (
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
      onLogout={handleLogout}
    >
      <FeatureRenderer
        activeMode={activeMode}
        setActiveMode={setActiveMode}
        session={session}
        userProfile={userProfile}
        settings={settings}
        setCustomSidebar={setCustomSidebar}
        setIsSettingsOpen={setIsSettingsOpen}
        availableClasses={[]}
        selectedClassId={''}
        quarter={''}
        enemArea={'Ciências Humanas'}
      />
    </MainLayout>
  );
};
