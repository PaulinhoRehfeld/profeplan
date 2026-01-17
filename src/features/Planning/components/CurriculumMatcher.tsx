import React, { useState, useEffect } from 'react';
import { supabase } from '../../../services/supabaseClient';
import { Search, ChevronDown, ChevronUp, Plus, Loader2, BookOpen, Filter } from 'lucide-react';

interface CurriculumItem {
    id: string;
    disciplina: string;
    periodo: string; // Renamed from bimestre
    habilidade: string;
    objeto_conhecimento: string;
}

interface EnemQuestion {
    id: number;
    content: string;
    metadata: any;
    similarity: number;
}

interface CurriculumMatcherProps {
    onAddContent: (content: string) => void;
}

export const CurriculumMatcher: React.FC<CurriculumMatcherProps> = ({ onAddContent }) => {
    // Filters
    const [disciplines, setDisciplines] = useState<string[]>([]);
    const [periods, setPeriods] = useState<string[]>([]); // Renamed from bimesters

    const [selectedDiscipline, setSelectedDiscipline] = useState<string>('');
    const [selectedPeriod, setSelectedPeriod] = useState<string>(''); // Renamed from selectedBimester

    // Data
    const [curriculumItems, setCurriculumItems] = useState<CurriculumItem[]>([]);
    const [isLoadingFilters, setIsLoadingFilters] = useState(false);
    const [isLoadingItems, setIsLoadingItems] = useState(false);

    // Matching
    const [expandedItemId, setExpandedItemId] = useState<string | null>(null);
    const [matchingQuestions, setMatchingQuestions] = useState<Record<string, EnemQuestion[]>>({});
    const [isLoadingMatch, setIsLoadingMatch] = useState<string | null>(null);

    // Initial Load - Disciplines
    useEffect(() => {
        loadDisciplines();
    }, []);

    // Load Periods when Discipline changes
    useEffect(() => {
        if (selectedDiscipline) {
            loadPeriods(selectedDiscipline);
        } else {
            setPeriods([]);
            setSelectedPeriod('');
        }
    }, [selectedDiscipline]);

    // Load Items when both selected
    useEffect(() => {
        if (selectedDiscipline && selectedPeriod) {
            loadCurriculumItems();
        } else {
            setCurriculumItems([]);
        }
    }, [selectedDiscipline, selectedPeriod]);

    const loadDisciplines = async () => {
        setIsLoadingFilters(true);
        const { data } = await supabase
            .from('curriculos_mg')
            .select('disciplina');

        if (data) {
            const unique = Array.from(new Set(data.map(d => d.disciplina))).sort();
            setDisciplines(unique);
        }
        setIsLoadingFilters(false);
    };

    const loadPeriods = async (discipline: string) => {
        setIsLoadingFilters(true);
        // Dynamically fetch periods for the selected discipline
        const { data } = await supabase
            .from('curriculos_mg')
            .select('periodo')
            .eq('disciplina', discipline);

        if (data) {
            // Remove duplicates and sort
            const unique = Array.from(new Set(data.map(d => d.periodo))).sort();
            setPeriods(unique);
            // Reset selected period when discipline changes
            setSelectedPeriod('');
        }
        setIsLoadingFilters(false);
    };

    const loadCurriculumItems = async () => {
        setIsLoadingItems(true);
        const { data } = await supabase
            .from('curriculos_mg')
            .select('*')
            .eq('disciplina', selectedDiscipline)
            .eq('periodo', selectedPeriod) // Use 'periodo' column
            .limit(50);

        if (data) {
            setCurriculumItems(data);
        }
        setIsLoadingItems(false);
    };

    const handleMatch = async (itemId: string) => {
        if (matchingQuestions[itemId]) {
            setExpandedItemId(itemId);
            return;
        }

        setIsLoadingMatch(itemId);
        try {
            const { data, error } = await supabase.rpc('match_curriculo_enem', {
                curriculo_id: itemId,
                match_threshold: 0.7,
                match_count: 5
            });

            if (data) {
                setMatchingQuestions(prev => ({ ...prev, [itemId]: data }));
                setExpandedItemId(itemId);
            }
        } catch (e) {
            console.error(e);
        } finally {
            setIsLoadingMatch(null);
        }
    };

    const toggleExpand = (itemId: string) => {
        if (expandedItemId === itemId) {
            setExpandedItemId(null);
        } else {
            if (matchingQuestions[itemId]) {
                setExpandedItemId(itemId);
            }
        }
    };

    return (
        <div className="flex flex-col h-full bg-slate-50 overflow-hidden">
            {/* Header / Filters */}
            <div className="p-4 bg-white border-b border-slate-200 shadow-sm z-10 space-y-4">
                <div className="flex items-center gap-2 mb-2">
                    <div className="bg-indigo-100 text-indigo-600 p-2 rounded-lg">
                        <BookOpen size={20} />
                    </div>
                    <div>
                        <h2 className="text-sm font-bold text-slate-800">Currículo & Questões</h2>
                        <p className="text-xs text-slate-500">Conecte habilidades do currículo a questões do ENEM</p>
                    </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div className="relative">
                        <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1 block">Disciplina</label>
                        <select
                            className="w-full text-sm p-2 rounded-lg border border-slate-200 bg-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 outline-none transition-all"
                            value={selectedDiscipline}
                            onChange={e => setSelectedDiscipline(e.target.value)}
                            disabled={isLoadingFilters}
                        >
                            <option value="">Selecione a disciplina...</option>
                            {disciplines.map(d => <option key={d} value={d}>{d}</option>)}
                        </select>
                    </div>
                    <div className="relative">
                        <label className="text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-1 block">Período</label>
                        <select
                            className="w-full text-sm p-2 rounded-lg border border-slate-200 bg-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 outline-none transition-all"
                            value={selectedPeriod}
                            onChange={e => setSelectedPeriod(e.target.value)}
                            disabled={!selectedDiscipline || isLoadingFilters}
                        >
                            <option value="">Selecione o período...</option>
                            {periods.map(p => <option key={p} value={p}>{p}</option>)}
                        </select>
                    </div>
                </div>
            </div>

            {/* List Content */}
            <div className="flex-1 overflow-y-auto custom-scrollbar p-4 space-y-4">
                {!selectedDiscipline || !selectedPeriod ? (
                    <div className="flex flex-col items-center justify-center h-40 text-slate-400 opacity-60">
                        <Filter size={40} className="mb-2" />
                        <span className="text-xs">Utilize os filtros acima para buscar habilidades.</span>
                    </div>
                ) : isLoadingItems ? (
                    <div className="flex justify-center p-8">
                        <Loader2 className="animate-spin text-indigo-500" />
                    </div>
                ) : curriculumItems.length === 0 ? (
                    <div className="text-center p-8 text-slate-400 text-xs">Nenhuma habilidade encontrada para este filtro.</div>
                ) : (
                    curriculumItems.map(item => (
                        <div key={item.id} className={`bg-white rounded-xl border transition-all ${expandedItemId === item.id ? 'border-indigo-500 shadow-md ring-1 ring-indigo-200' : 'border-slate-200 hover:border-indigo-300'}`}>
                            <div className="p-4">
                                <span className="inline-block px-2 py-0.5 rounded-full bg-slate-100 text-slate-600 text-[10px] font-bold uppercase tracking-wide mb-2">
                                    {item.habilidade}
                                </span>
                                <h3 className="text-sm font-semibold text-slate-800 mb-2">{item.objeto_conhecimento}</h3>

                                <div className="flex items-center justify-between mt-3">
                                    {matchingQuestions[item.id] ? (
                                        <button
                                            onClick={() => toggleExpand(item.id)}
                                            className="text-xs font-bold text-indigo-600 flex items-center gap-1 hover:underline"
                                        >
                                            {expandedItemId === item.id ? 'Ocultar Questões' : 'Ver Questões Encontradas'}
                                            {expandedItemId === item.id ? <ChevronUp size={14} /> : <ChevronDown size={14} />}
                                        </button>
                                    ) : (
                                        <button
                                            onClick={() => handleMatch(item.id)}
                                            disabled={isLoadingMatch === item.id}
                                            className="bg-indigo-50 text-indigo-700 px-3 py-1.5 rounded-lg text-xs font-bold flex items-center gap-2 hover:bg-indigo-100 transition-colors disabled:opacity-50"
                                        >
                                            {isLoadingMatch === item.id ? <Loader2 size={12} className="animate-spin" /> : <Search size={12} />}
                                            Buscar Questões
                                        </button>
                                    )}
                                </div>
                            </div>

                            {/* Accordion Content (Questions) */}
                            {expandedItemId === item.id && matchingQuestions[item.id] && (
                                <div className="bg-slate-50 border-t border-slate-100 p-4 rounded-b-xl space-y-3 animate-in slide-in-from-top-2 duration-200">
                                    {matchingQuestions[item.id].length === 0 ? (
                                        <p className="text-xs text-slate-500 italic">Nenhuma questão relevante encontrada no banco de dados.</p>
                                    ) : (
                                        matchingQuestions[item.id].map(q => (
                                            <div key={q.id} className="bg-white p-3 rounded-lg border border-slate-200 shadow-sm group">
                                                <div className="flex justify-between items-start mb-2">
                                                    <span className="text-[9px] bg-emerald-50 text-emerald-700 px-2 py-0.5 rounded font-bold border border-emerald-100">
                                                        Match: {Math.round(q.similarity * 100)}%
                                                    </span>
                                                    <button
                                                        onClick={() => onAddContent(`Questão ENEM (${q.id}): ${q.content}`)}
                                                        className="opacity-0 group-hover:opacity-100 transition-opacity bg-indigo-600 text-white p-1 rounded hover:bg-indigo-700"
                                                        title="Adicionar ao Planejamento"
                                                    >
                                                        <Plus size={14} />
                                                    </button>
                                                </div>
                                                <p className="text-xs text-slate-700 leading-relaxed overflow-hidden text-ellipsis line-clamp-4 group-hover:line-clamp-none transition-all">
                                                    {q.content}
                                                </p>
                                            </div>
                                        ))
                                    )}
                                </div>
                            )}
                        </div>
                    ))
                )}
            </div>
        </div>
    );
};
