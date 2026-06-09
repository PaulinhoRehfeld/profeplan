import { useState, useEffect } from 'react';
import { runDiagnostics } from '../services/diagnosticService';
import { supabase } from '../services/supabaseClient';
import { UserSettings, UserProfile } from '../types';

interface UseAppBootstrapProps {
  loading: boolean;
  session: any;
  userProfile: UserProfile | null;
  settings: UserSettings;
  setSettings: (settings: UserSettings) => void;
  refreshProfile: () => void;
}

export function useAppBootstrap({
  loading,
  session,
  userProfile,
  settings,
  setSettings,
  refreshProfile,
}: UseAppBootstrapProps) {
  const [showEmergencyReset, setShowEmergencyReset] = useState(false);
  const [retryCount, setRetryCount] = useState(0);

  // 1. NUCLEAR RESET MANUAL (force_reset)
  useEffect(() => {
    const urlParams = new URLSearchParams(window.location.search);
    const forceReset = urlParams.has('force_reset') || urlParams.has('reset');
    if (!forceReset) return;

    const runReset = async () => {
      console.warn("[AppBootstrap] ☢️ EMERGENCY NUCLEAR RESET MANUAL (force_reset)");
      try {
        if ('serviceWorker' in navigator) {
          const registrations = await navigator.serviceWorker.getRegistrations();
          for (const registration of registrations) {
            await registration.unregister();
          }
        }
        if ('caches' in window) {
          const cacheNames = await caches.keys();
          await Promise.all(cacheNames.map(name => caches.delete(name)));
        }
        localStorage.clear();
        sessionStorage.clear();
        window.location.href = window.location.origin + window.location.pathname + '?v=' + Date.now();
      } catch (err) {
        console.error("[AppBootstrap] Nuclear reset failed:", err);
        window.location.reload();
      }
    };
    runReset();
  }, []);

  // 2. SAFETY TIMEOUT & OBSERVABILITY
  useEffect(() => {
    if (loading) {
      const timer = setTimeout(async () => {
        console.warn("[AppBootstrap] 🚨 Loader Timeout reached (10s). Running auto-diagnostics...");
        try {
          const results = await runDiagnostics();
          console.table(results);
          
          // Observability: Log to Supabase (fire and forget)
          if (session?.user?.id || session?.userId) {
             supabase.from('system_logs').insert({
               event_type: 'nuclear_reset_trigger',
               user_id: session?.user?.id || session?.userId || null,
               route: window.location.pathname,
               details: { results, message: 'Loader timeout 10s' }
             }).then(() => console.log('Log sent to observability.')).catch(e => console.error(e));
          }
          
          setShowEmergencyReset(true);
        } catch (err) {
          console.error("[AppBootstrap] Auto-diagnostic failed:", err);
          setShowEmergencyReset(true);
        }
      }, 10000);
      return () => clearTimeout(timer);
    }
  }, [loading, session]);

  // 3. HYDRATION: Sync settings with userProfile
  useEffect(() => {
    if (userProfile && !loading) {
      console.log("[AppBootstrap] 🔄 [HYDRATION] Initializing Sync from DB Profile...");

      const isDefault = (val: string | undefined | null) =>
        !val || val === 'Professor(a)' || val === 'seu.nome@educacao.mg.gov.br' || val === '1234567-8';

      const updatedSettings = { ...settings };
      let changed = false;

      const syncField = (dbVal: any, localField: keyof UserSettings, label: string) => {
        if (!dbVal) return;
        const localVal = settings[localField] as string;
        const dbIsReal = !isDefault(dbVal);
        const localIsDefault = isDefault(localVal);

        if (dbIsReal && (localIsDefault || (dbVal !== localVal))) {
          console.log(`[AppBootstrap] 📥 [SYNC] Updating ${label}: '${localVal}' -> '${dbVal}'`);
          (updatedSettings as any)[localField] = dbVal;
          changed = true;
        }
      };

      syncField(userProfile.full_name, 'userName', 'Nome');
      syncField(userProfile.email, 'institutionalEmail', 'Email');
      syncField(userProfile.masp, 'masp', 'MASP');
      syncField(userProfile.city, 'city', 'Cidade');
      syncField((userProfile as any).inep_code, 'schoolCode', 'INEP');
      syncField(userProfile.school_name, 'institution', 'Escola');

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
        console.log("[AppBootstrap] ✅ [SYNC] Applying data to local state & storage.");
        setSettings(updatedSettings);
        localStorage.setItem('profeplan_settings', JSON.stringify(updatedSettings));
      } else {
        console.log("[AppBootstrap] ℹ️ [SYNC] Local state is already optimized.");
      }
    }
  }, [userProfile, loading]);

  // 4. AUTO-RETRY Profile
  useEffect(() => {
    if (!loading && session?.isLoggedIn && !userProfile && retryCount < 3) {
      const timer = setTimeout(() => {
        console.warn(`[AppBootstrap] ⚠️ Session active but profile missing. Retrying sync (${retryCount + 1}/3)...`);
        setRetryCount(prev => prev + 1);
        refreshProfile();
      }, 3000);
      return () => clearTimeout(timer);
    }
  }, [loading, session?.isLoggedIn, !!userProfile, retryCount]);

  return { showEmergencyReset };
}
