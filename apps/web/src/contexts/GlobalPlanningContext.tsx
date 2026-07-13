import React, {
  createContext,
  useContext,
  useState,
  useEffect,
  useCallback,
  ReactNode,
} from 'react';
import { supabase } from '../services/supabaseClient';
import { fetchTermPlans as serviceFetchTermPlans } from '../features/TermPlanning/TermPlanningService';

import { TermPlan } from '../types';
export type { TermPlan };

interface GlobalPlanningContextType {
  currentPlan: TermPlan | null;
  termPlans: TermPlan[];
  updateCurrentPlan: (plan: TermPlan) => void;
  refreshTermPlans: (userId?: string) => Promise<void>;
  clearPlan: () => void;
}

const GlobalPlanningContext = createContext<GlobalPlanningContextType | undefined>(undefined);

export const GlobalPlanningProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
  const [currentPlan, setCurrentPlan] = useState<TermPlan | null>(() => {
    try {
      const saved = localStorage.getItem('profeplan_current_term_plan');
      return saved ? JSON.parse(saved) : null;
    } catch {
      return null;
    }
  });

  const [termPlans, setTermPlans] = useState<TermPlan[]>([]);

  useEffect(() => {
    if (currentPlan) {
      localStorage.setItem('profeplan_current_term_plan', JSON.stringify(currentPlan));
    } else {
      localStorage.removeItem('profeplan_current_term_plan');
    }
  }, [currentPlan]);

  // M-6: Listen for auth state to get a valid userId before fetching.
  // This avoids the blank-flash from fetching with no user on mount.
  useEffect(() => {
    let cancelled = false;

    const bootstrap = async () => {
      const {
        data: { session },
      } = await supabase.auth.getSession();
      if (!cancelled && session?.user?.id) {
        refreshTermPlans(session.user.id).catch((err) =>
          console.error('Critical: Initial plan fetch failed', err)
        );
      }
    };

    bootstrap();

    const {
      data: { subscription },
    } = supabase.auth.onAuthStateChange((event, session) => {
      if (event === 'SIGNED_IN' && session?.user?.id) {
        refreshTermPlans(session.user.id).catch(console.error);
      } else if (event === 'SIGNED_OUT') {
        setTermPlans([]);
        setCurrentPlan(null);
      }
    });

    return () => {
      cancelled = true;
      subscription.unsubscribe();
    };
  }, []);

  // useCallback com deps estáveis (setTermPlans nunca muda) — sem isso, esta função
  // era recriada a cada render do provider. Consumidores que a colocam em deps de
  // useEffect (TermPlanningList.tsx, PlanningManager.tsx) entravam em loop infinito:
  // efeito chama refreshTermPlans → setTermPlans atualiza estado → provider
  // re-renderiza → nova referência da função → efeito dispara de novo, para sempre.
  const refreshTermPlans = useCallback(async (userId?: string) => {
    try {
      let targetUserId = userId;

      // If no explicit ID, try session
      if (!targetUserId) {
        const {
          data: { session },
        } = await supabase.auth.getSession();
        if (session?.user) {
          targetUserId = session.user.id;
        }
      }

      if (!targetUserId) {
        console.warn('[GlobalContext] Cannot refresh plans: No User ID found.');
        return;
      }

      console.log('[GlobalContext] Calling serviceFetchTermPlans for user:', targetUserId);
      const plans = await serviceFetchTermPlans(targetUserId);
      console.log('[GlobalContext] Received plans:', plans?.length);
      setTermPlans(plans);
    } catch (error: any) {
      console.error('Error fetching term plans:', error);
      console.error('Error details:', JSON.stringify(error, Object.getOwnPropertyNames(error)));
    }
  }, []);

  const updateCurrentPlan = useCallback((plan: TermPlan) => {
    setCurrentPlan(plan);
  }, []);

  const clearPlan = useCallback(() => {
    setCurrentPlan(null);
  }, []);

  return (
    <GlobalPlanningContext.Provider
      value={{ currentPlan, termPlans, updateCurrentPlan, refreshTermPlans, clearPlan }}
    >
      {children}
    </GlobalPlanningContext.Provider>
  );
};

export const useGlobalPlanning = () => {
  const context = useContext(GlobalPlanningContext);
  if (!context) {
    throw new Error('useGlobalPlanning must be used within a GlobalPlanningProvider');
  }
  return context;
};
