import React, { useState, useEffect, useRef } from 'react';
import { Building2, ChevronDown, Check } from 'lucide-react';
import { School } from '../types';
import { supabase } from '../services/supabaseClient';

interface SchoolSwitcherProps {
    userProfile: any;
    onSchoolChange?: () => void;
}

export const SchoolSwitcher: React.FC<SchoolSwitcherProps> = ({ userProfile, onSchoolChange }) => {
    const [schools, setSchools] = useState<School[]>([]);
    const [activeSchool, setActiveSchool] = useState<School | null>(null);
    const [isOpen, setIsOpen] = useState(false);
    const [loading, setLoading] = useState(true);
    const dropdownRef = useRef<HTMLDivElement>(null);

    // Fechar dropdown ao clicar fora
    useEffect(() => {
        const handleClickOutside = (event: MouseEvent) => {
            if (dropdownRef.current && !dropdownRef.current.contains(event.target as Node)) {
                setIsOpen(false);
            }
        };

        document.addEventListener('mousedown', handleClickOutside);
        return () => document.removeEventListener('mousedown', handleClickOutside);
    }, []);

    // Carregar escolas vinculadas ao professor
    useEffect(() => {
        const loadSchools = async () => {
            if (!userProfile?.id || userProfile.role !== 'teacher') {
                setLoading(false);
                return;
            }

            try {
                // Buscar escolas vinculadas via teacher_schools
                const { data: links, error } = await supabase
                    .from('teacher_schools')
                    .select(`
                        school_id,
                        schools (
                            id,
                            name,
                            inep_code
                        )
                    `)
                    .eq('teacher_id', userProfile.id)
                    .is('ended_at', null);

                if (error) throw error;

                const schoolList = links
                    ?.flatMap(link => link.schools ? [link.schools as unknown as School] : []) || [];

                setSchools(schoolList);

                // Definir escola ativa
                const activeSchoolId = userProfile.active_school_id;
                const active = schoolList?.find(s => s.id === activeSchoolId) || schoolList?.[0] || null;
                setActiveSchool(active);
            } catch (err) {
                console.error('[SchoolSwitcher] Error loading schools:', err);
            } finally {
                setLoading(false);
            }
        };

        loadSchools();
    }, [userProfile]);

    const handleSwitchSchool = async (school: School) => {
        try {
            // Atualizar active_school_id no perfil
            const { error } = await supabase
                .from('profiles')
                .update({ active_school_id: school.id })
                .eq('id', userProfile.id);

            if (error) throw error;

            setActiveSchool(school);
            setIsOpen(false);

            // Notificar mudança e recarregar página
            if (onSchoolChange) {
                onSchoolChange();
            } else {
                window.location.reload();
            }
        } catch (err) {
            console.error('[SchoolSwitcher] Error switching school:', err);
            alert('Erro ao trocar de escola. Tente novamente.');
        }
    };

    // Não mostrar se não for professor ou tiver apenas 1 escola
    if (loading || userProfile?.role !== 'teacher' || schools.length <= 1) {
        return null;
    }

    return (
        <div className="relative" ref={dropdownRef}>
            {/* Botão Atual */}
            <button
                onClick={() => setIsOpen(!isOpen)}
                className="flex items-center gap-2 px-3 py-2 bg-indigo-50 hover:bg-indigo-100 border border-indigo-200 rounded-xl transition-all group"
            >
                <Building2 className="w-4 h-4 text-indigo-600" />
                <div className="text-left hidden sm:block">
                    <p className="text-[8px] font-bold text-indigo-400 uppercase tracking-wider">Escola Ativa</p>
                    <p className="text-xs font-bold text-indigo-900 truncate max-w-[120px]">
                        {activeSchool?.name || 'Selecione'}
                    </p>
                </div>
                <ChevronDown className={`w-4 h-4 text-indigo-600 transition-transform ${isOpen ? 'rotate-180' : ''}`} />
            </button>

            {/* Dropdown */}
            {isOpen && (
                <div className="absolute top-full right-0 mt-2 w-72 bg-white border border-slate-200 rounded-2xl shadow-2xl overflow-hidden z-[100] animate-in fade-in slide-in-from-top-2 duration-200">
                    <div className="p-3 bg-indigo-50 border-b border-indigo-100">
                        <p className="text-[10px] font-black text-indigo-600 uppercase tracking-widest">
                            Minhas Escolas ({schools.length})
                        </p>
                    </div>
                    <div className="max-h-64 overflow-y-auto">
                        {schools.map((school) => (
                            <button
                                key={school.id}
                                onClick={() => handleSwitchSchool(school)}
                                className={`w-full px-4 py-3 text-left hover:bg-slate-50 transition-colors flex items-center justify-between group ${school.id === activeSchool?.id ? 'bg-indigo-50' : ''
                                    }`}
                            >
                                <div className="flex-1">
                                    <p className="text-sm font-bold text-slate-900 group-hover:text-indigo-600">
                                        {school.name}
                                    </p>
                                    <p className="text-xs text-slate-500 mt-0.5">
                                        INEP: {school.inep_code}
                                    </p>
                                </div>
                                {school.id === activeSchool?.id && (
                                    <div className="flex items-center gap-2">
                                        <span className="text-[9px] font-bold text-indigo-600 uppercase tracking-wider bg-indigo-100 px-2 py-1 rounded-full">
                                            Ativa
                                        </span>
                                        <Check className="w-5 h-5 text-indigo-600" />
                                    </div>
                                )}
                            </button>
                        ))}
                    </div>
                </div>
            )}
        </div>
    );
};
