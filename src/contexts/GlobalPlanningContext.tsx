import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { supabase } from '../services/supabaseClient';
import { fetchTermPlans as serviceFetchTermPlans } from '../features/TermPlanning/TermPlanningService';

import { TermPlan } from '../types';
export type { TermPlan };

interface GlobalPlanningContextType {
    currentPlan: TermPlan | null;
    termPlans: TermPlan[];
    updateCurrentPlan: (plan: TermPlan) => void;
    refreshTermPlans: () => Promise<void>;
    clearPlan: () => void;
}

const GlobalPlanningContext = createContext<GlobalPlanningContextType | undefined>(undefined);

export const GlobalPlanningProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
    const [currentPlan, setCurrentPlan] = useState<TermPlan | null>(() => {
        try {
            const saved = localStorage.getItem('profeplan_current_term_plan');
            return saved ? JSON.parse(saved) : null;
        } catch { return null; }
    });

    const [termPlans, setTermPlans] = useState<TermPlan[]>([]);

    useEffect(() => {
        if (currentPlan) {
            localStorage.setItem('profeplan_current_term_plan', JSON.stringify(currentPlan));
        } else {
            localStorage.removeItem('profeplan_current_term_plan');
        }
    }, [currentPlan]);

    // Initial fetch
    useEffect(() => {
        refreshTermPlans();
    }, []);



    const refreshTermPlans = async () => {
        try {
            const { data: session } = await supabase.auth.getSession();
            if (!session.session?.user) return;

            console.log('[GlobalContext] Calling serviceFetchTermPlans for user:', session.session.user.id);
            const plans = await serviceFetchTermPlans(session.session.user.id);
            console.log('[GlobalContext] Received plans:', plans?.length);
            setTermPlans(plans);

        } catch (error: any) {
            console.error('Error fetching term plans:', error);
            console.error('Error details:', JSON.stringify(error, Object.getOwnPropertyNames(error)));
        }
    };

    const updateCurrentPlan = (plan: TermPlan) => {
        setCurrentPlan(plan);
    };

    const clearPlan = () => {
        setCurrentPlan(null);
    };

    return (
        <GlobalPlanningContext.Provider value={{ currentPlan, termPlans, updateCurrentPlan, refreshTermPlans, clearPlan }}>
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
