import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { supabase } from '../services/supabaseClient';

// Define the shape of our Term Plan Data
export interface TermPlan {
    id: string; // Made mandatory for list keying
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
    generatedText: string; // Made mandatory
    created_at: string;
}

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
            // Fetch from Supabase 'generated_contents' where type is 'trimestral'
            // We need to parse the content JSON back to objects if they are stored as JSON strings
            // OR if they are basic records, we might need to map them.
            // Assuming for now that TermPlanningManager saves them as 'trimestral' type.

            const { data: session } = await supabase.auth.getSession();
            if (!session.session?.user) return;

            const { data, error } = await supabase
                .from('generated_contents')
                .select('*')
                .eq('user_id', session.session.user.id)
                .eq('type', 'trimestral')
                .order('created_at', { ascending: false });

            if (error) throw error;

            if (data) {
                // Map DB content to TermPlan
                // Caution: 'content' in generated_contents is string (likely JSON or text).
                // If TermManager saves the JSON object stringified in 'content', we parse it.
                const plans: TermPlan[] = data.map(item => {
                    let parsedContent: any = {};
                    try {
                        parsedContent = typeof item.content === 'string' && item.content.startsWith('{')
                            ? JSON.parse(item.content)
                            : { generatedText: item.content }; // Fallback if plain text
                    } catch (e) {
                        parsedContent = { generatedText: item.content };
                    }

                    return {
                        id: item.id,
                        created_at: item.created_at,
                        subject: parsedContent.subject || item.title || 'Sem disciplina', // Fallback
                        grade: parsedContent.grade || 'Geral',
                        period: parsedContent.period || 1,
                        regime: parsedContent.regime || 'Trimestre',
                        generatedText: parsedContent.generatedText || item.content,
                        ...parsedContent // Spread other fields like reserves, gradingGrid if they exist
                    } as TermPlan;
                });
                setTermPlans(plans);
            }
        } catch (error) {
            console.error('Error fetching term plans:', error);
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
