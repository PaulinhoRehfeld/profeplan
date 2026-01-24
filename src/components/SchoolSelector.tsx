import React, { useState, useEffect } from 'react';
import { supabase } from '../services/supabaseClient';
import { Search, Loader2, X, Check } from 'lucide-react';

export interface School {
    id: string;
    name: string;
    city: string;
    sre: string;
}

interface SchoolSelectorProps {
    onSelect: (school: School) => void;
}

const SchoolSelector: React.FC<SchoolSelectorProps> = ({ onSelect }) => {
    const [searchTerm, setSearchTerm] = useState('');
    const [results, setResults] = useState<School[]>([]);
    const [loading, setLoading] = useState(false);
    const [selectedSchool, setSelectedSchool] = useState<School | null>(null);

    const searchSchools = async (term: string) => {
        if (term.length < 3) {
            setResults([]);
            return;
        }

        console.log(`[SchoolSelector] Searching for: "${term}"`);
        setLoading(true);
        try {
            // Using 'or' to search in name OR city
            const { data, error } = await supabase
                .from('schools')
                .select('id, name, city, sre')
                .or(`name.ilike.%${term}%,city.ilike.%${term}%`)
                .limit(10);

            if (error) {
                console.error('[SchoolSelector] DB Error:', error);
                throw error;
            }

            console.log(`[SchoolSelector] Found ${data?.length} results:`, data);
            setResults(data || []);
        } catch (error) {
            console.error('Erro ao buscar escolas:', error);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        const delayDebounceFn = setTimeout(() => {
            if (searchTerm) {
                searchSchools(searchTerm);
            }
        }, 500);

        return () => clearTimeout(delayDebounceFn);
    }, [searchTerm]);

    const handleSelect = (school: School) => {
        setSelectedSchool(school);
        setSearchTerm('');
        setResults([]);
        onSelect(school);
    };

    return (
        <div className="p-4 bg-white rounded-2xl border border-slate-100 shadow-sm">
            <h3 className="text-lg font-black text-slate-700 mb-4 uppercase italic tracking-tight">Vincular Escola</h3>

            {selectedSchool ? (
                <div className="bg-green-50 border border-green-200 p-4 rounded-xl flex justify-between items-center animate-in fade-in">
                    <div>
                        <p className="font-bold text-green-800 text-sm uppercase">{selectedSchool.name}</p>
                        <p className="text-xs text-green-600 font-medium">{selectedSchool.city} - {selectedSchool.sre}</p>
                    </div>
                    <button
                        onClick={() => setSelectedSchool(null)}
                        className="p-2 text-green-700 hover:bg-green-100 rounded-lg transition-colors"
                    >
                        <X size={18} />
                    </button>
                </div>
            ) : (
                <div className="relative">
                    <div className="relative">
                        <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
                        <input
                            type="text"
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                            placeholder="Digite o nome da escola..."
                            className="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-100 rounded-xl text-sm font-medium outline-none focus:ring-2 focus:ring-blue-100 transition-all"
                        />
                        {loading && (
                            <div className="absolute right-3 top-1/2 -translate-y-1/2">
                                <Loader2 className="animate-spin text-blue-500" size={18} />
                            </div>
                        )}
                    </div>

                    {searchTerm.length > 0 && searchTerm.length < 3 && (
                        <p className="text-xs text-slate-400 mt-2 pl-2">Digite pelo menos 3 letras...</p>
                    )}

                    {results.length > 0 && (
                        <div className="absolute top-full left-0 right-0 mt-2 bg-white border border-slate-100 rounded-xl shadow-xl z-50 max-h-60 overflow-y-auto">
                            {results.map((school) => (
                                <button
                                    key={school.id}
                                    onClick={() => handleSelect(school)}
                                    className="w-full text-left p-3 hover:bg-slate-50 border-b border-slate-50 last:border-0 transition-colors"
                                >
                                    <p className="text-sm font-bold text-slate-700">{school.name}</p>
                                    <p className="text-xs text-slate-400">{school.city} | {school.sre}</p>
                                </button>
                            ))}
                        </div>
                    )}
                </div>
            )}
        </div>
    );
};

export default SchoolSelector;