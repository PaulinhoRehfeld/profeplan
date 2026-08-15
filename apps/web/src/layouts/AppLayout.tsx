import React from 'react';
import { MainLayout } from './MainLayout';
import { FeatureRenderer } from '../components/FeatureRenderer';
import { useUIStore } from '../stores/useUIStore';
import { useProfeplanAuth } from '../hooks/useProfeplanAuth';
import { useProfeplanSettings } from '../hooks/useProfeplanSettings';
import { supabase } from '../services/supabaseClient';
import { clearLocalSession } from '../utils/authUtils';

const PURCHASE_INTENT_STORAGE_KEY = 'profeplan:purchase-intent';
const PURCHASE_INTENT_TTL_MS = 24 * 60 * 60 * 1000;

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

  React.useEffect(() => {
    if (!session?.isLoggedIn || !userProfile?.id) return;

    const stored = localStorage.getItem(PURCHASE_INTENT_STORAGE_KEY);
    if (!stored) return;

    try {
      const intent = JSON.parse(stored) as { plan?: unknown; createdAt?: unknown };
      const validPlan = intent.plan === 'silver' || intent.plan === 'gold';
      const createdAt = typeof intent.createdAt === 'number' ? intent.createdAt : 0;
      const stillValid = Date.now() - createdAt <= PURCHASE_INTENT_TTL_MS;

      if (validPlan && stillValid) {
        setIsSubscriptionOpen(true);
      }
    } catch {
      // Invalid/stale intent is discarded below.
    } finally {
      localStorage.removeItem(PURCHASE_INTENT_STORAGE_KEY);
    }
  }, [session?.isLoggedIn, userProfile?.id, setIsSubscriptionOpen]);

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
