import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';

// Define the shape of our Term Plan Data
export interface TermPlan {
    id?: string;
    period: number;
    regime: 'Bimestre' | 'Trimestre';
    subject: string;
    grade: string;
    level: 'Ensino Fundamental' | 'Ensino Médio';
    workloadWeekly: number;
    reserves: {
        monthlyExam: boolean;
        bimonthlyExam: boolean;
        recovery: boolean;
    };
    totalClasses: number;
    gradingGrid: {
        vistos: number;
        trabalhos: number;
        monthlyExam: number;
        bimonthlyExam: number;
        others: number;
    };
    stateBase?: string;
    educationSphere?: string;
    generatedText?: string;
}

interface GlobalPlanningContextType {
    currentPlan: TermPlan | null;
    updateCurrentPlan: (plan: TermPlan) => void;
    clearPlan: () => void;
}

const GlobalPlanningContext = createContext<GlobalPlanningContextType | undefined>(undefined);

export const GlobalPlanningProvider: React.FC<{ children: ReactNode }> = ({ children }) => {
    const [currentPlan, setCurrentPlan] = useState<TermPlan | null>(() => {
        const saved = localStorage.getItem('profeplan_current_term_plan');
        return saved ? JSON.parse(saved) : null;
    });

    useEffect(() => {
        if (currentPlan) {
            localStorage.setItem('profeplan_current_term_plan', JSON.stringify(currentPlan));
        } else {
            localStorage.removeItem('profeplan_current_term_plan');
        }
    }, [currentPlan]);

    const updateCurrentPlan = (plan: TermPlan) => {
        setCurrentPlan(plan);
    };

    const clearPlan = () => {
        setCurrentPlan(null);
    };

    return (
        <GlobalPlanningContext.Provider value={{ currentPlan, updateCurrentPlan, clearPlan }}>
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
