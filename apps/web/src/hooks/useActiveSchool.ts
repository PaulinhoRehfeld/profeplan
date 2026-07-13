import { useState, useEffect } from 'react';
import { TeacherSchoolLink } from '../types';
import { supabase } from '../services/supabaseClient';
import { resolveAuthUid } from '../utils/authUtils';

export interface ActiveSchool {
    id: string;
    name: string;
    inep_code: string;
    city?: string;
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

    // Reseta a escola ativa em memória sempre que o userId muda (logout ou troca
    // de usuário na mesma aba, sem reload de página). Sem isso, o state React
    // deste hook (montado uma única vez em RootLayout) sobrevive à navegação SPA
    // e um novo login herda a escola ativa do usuário anterior (achado #13 da
    // auditoria de 2026-07-10) — o guard `parsed.userId === userId` do useState
    // inicial só roda no mount, não quando userId muda depois.
    useEffect(() => {
        if (!userId) {
            setActiveSchoolState(null);
            return;
        }
        const stored = localStorage.getItem(STORAGE_KEY);
        if (!stored) return;
        try {
            const parsed = JSON.parse(stored);
            if (parsed.userId !== userId) {
                setActiveSchoolState(null);
            }
        } catch {
            setActiveSchoolState(null);
        }
    }, [userId]);

    // Carregar escolas vinculadas ao professor
    useEffect(() => {
        const loadSchools = async () => {
            if (!userId) {
                setAvailableSchools([]);
                return;
            }

            setLoading(true);
            try {
                // Usa auth.uid() real — evita ghost UUID no RLS (mesmo padrão de getClasses).
                // Sem isso, um userId local desatualizado faz esta query retornar 0 vínculos
                // mesmo quando o professor tem escola vinculada de verdade, deixando
                // availableSchools vazio e a escola ativa nunca sendo resolvida.
                let authUid: string;
                try {
                    authUid = await resolveAuthUid();
                } catch {
                    authUid = userId;
                }

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
                    .eq('teacher_id', authUid)
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

            // Persistir no perfil (profiles.active_school_id) — antes esta função só
            // gravava estado local/localStorage, então a escolha feita aqui (tela
            // /select-school, ou o auto-select de escola única abaixo) nunca chegava
            // ao campo que ClassManager e outras telas realmente leem, deixando
            // "school: null" mesmo depois do professor "escolher" a escola.
            supabase.rpc('set_my_active_school', { p_school_id: school.id }).then(({ error }) => {
                if (error) {
                    console.error('[useActiveSchool] Failed to persist active_school_id:', error);
                }
            });
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
