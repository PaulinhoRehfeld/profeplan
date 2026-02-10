import { useState, useEffect } from 'react';
import { TeacherSchoolLink } from '../types';
import { supabase } from '../services/supabaseClient';

export interface ActiveSchool {
    id: string;
    name: string;
    inep_code: string;
    city?: string;
}
    };
}

const STORAGE_KEY = 'profeplan_active_school';

export const useActiveSchool = (userId: string | undefined) => {
    const [activeSchool, setActiveSchoolState] = useState<ActiveSchool | null>(() => {
        // Tentar carregar do localStorage na inicialização
        if (!userId) return null;
        const stored = localStorage.getItem(STORAGE_KEY);
        if (stored) {
            try {
                const parsed = JSON.parse(stored);
                // Validar se pertence ao mesmo userId
                if (parsed.userId === userId) {
                    return parsed.school;
                }
            } catch (err) {
                console.error('[useActiveSchool] Failed to parse stored school:', err);
            }
        }
        return null;
    });

    const [availableSchools, setAvailableSchools] = useState<ActiveSchool[]>([]);
    const [loading, setLoading] = useState(false);

    // Carregar escolas vinculadas ao professor
    useEffect(() => {
        const loadSchools = async () => {
            if (!userId) {
                setAvailableSchools([]);
                return;
            }

            setLoading(true);
            try {
                const { data, error } = await supabase
                    .from('teacher_schools')
                    .select(`
                        id,
                        school_id,
                        started_at,
                        ended_at,
                        schools (
                            id,
                            name,
                            inep_code,
                            city
                        )
                    `)
                    .eq('teacher_id', userId)
                    .is('ended_at', null) // Apenas vínculos ativos
                    .order('started_at', { ascending: false });

                if (error) {
                    console.error('[useActiveSchool] Failed to load schools:', error);
                    return;
                }

                const schools = (data || [])
                    .filter(link => link.schools)
                    .map(link => {
                        const school = link.schools as any; // Supabase retorna objeto, não array
                        return {
                            id: school.id,
                            name: school.name,
                            inep_code: school.inep_code,
                            city: school.city
                        };
                    });


                setAvailableSchools(schools);

                // Se houver apenas 1 escola e não há escola ativa definida, setar automaticamente
                if (schools.length === 1 && !activeSchool) {
                    setActiveSchool(schools[0]);
                }
            } catch (err) {
                console.error('[useActiveSchool] Exception loading schools:', err);
            } finally {
                setLoading(false);
            }
        };

        loadSchools();
    }, [userId]);

    const setActiveSchool = (school: ActiveSchool | null) => {
        setActiveSchoolState(school);

        if (school && userId) {
            // Persistir no localStorage
            localStorage.setItem(STORAGE_KEY, JSON.stringify({
                userId,
                school
            }));
        } else {
            localStorage.removeItem(STORAGE_KEY);
        }
    };

    const clearActiveSchool = () => {
        setActiveSchool(null);
    };

    return {
        activeSchool,
        availableSchools,
        loading,
        setActiveSchool,
        clearActiveSchool,
        needsSelection: availableSchools.length > 1 && !activeSchool
    };
};
