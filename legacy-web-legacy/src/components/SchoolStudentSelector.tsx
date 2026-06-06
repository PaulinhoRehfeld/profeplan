import React, { useState, useEffect } from 'react';
import { supabase } from '../services/supabaseClient';
import { ProfileService } from '../services/ProfileService';
import { Search, Loader2, X, CheckCircle2, User } from 'lucide-react';

interface SchoolStudent {
    id: string;
    name: string;
    birth_date?: string;
    school_id: string;
}

interface SchoolStudentSelectorProps {
    onImport: (selectedStudents: string[]) => void;
    onCancel: () => void;
}

const SchoolStudentSelector: React.FC<SchoolStudentSelectorProps> = ({ onImport, onCancel }) => {
    const [searchTerm, setSearchTerm] = useState('');
    const [students, setStudents] = useState<SchoolStudent[]>([]);
    const [loading, setLoading] = useState(false);
    const [selectedIds, setSelectedIds] = useState<Set<string>>(new Set());
    const [userSchoolId, setUserSchoolId] = useState<string | null>(null);

    useEffect(() => {
        const checkSchool = async () => {
            const profile = await ProfileService.getProfile();
            if (profile?.school_id) {
                setUserSchoolId(profile.school_id);
            }
        };
        checkSchool();
    }, []);

    const searchStudents = async (term: string) => {
        if (!userSchoolId) return;

        setLoading(true);
        try {
            let query = supabase
                .from('school_students')
                .select('id, name, birth_date, school_id')
                .eq('school_id', userSchoolId)
                .order('name');

            if (term.length >= 2) {
                query = query.ilike('name', `%${term}%`);
            } else {
                query = query.limit(20);
            }

            const { data, error } = await query;

            if (error) throw error;
            setStudents(data || []);
        } catch (error) {
            console.error('Error fetching school students:', error);
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        if (userSchoolId) {
            const delayDebounceFn = setTimeout(() => {
                searchStudents(searchTerm);
            }, 500);
            return () => clearTimeout(delayDebounceFn);
        }
    }, [searchTerm, userSchoolId]);

    const toggleSelection = (id: string) => {
        const newSet = new Set(selectedIds);
        if (newSet.has(id)) {
            newSet.delete(id);
        } else {
            newSet.add(id);
        }
        setSelectedIds(newSet);
    };

    const handleImport = () => {
        const selectedNames = students
            .filter(s => selectedIds.has(s.id))
            .map(s => s.name);
        onImport(selectedNames);
    };

    if (!userSchoolId) {
        return (
            <div className="flex flex-col items-center justify-center p-8 text-center h-full">
                <div className="p-4 bg-yellow-50 rounded-full mb-4">
                    <User className="text-yellow-600" size={32} />
                </div>
                <p className="text-slate-600 font-medium mb-4">Você precisa estar vinculado a uma escola para importar alunos.</p>
                <button
                    onClick={onCancel}
                    className="px-6 py-2 border border-slate-200 rounded-xl text-slate-500 hover:bg-slate-50 font-bold text-sm uppercase"
                >
                    Fechar
                </button>
            </div>
        );
    }

    return (
        <div className="bg-white rounded-3xl overflow-hidden h-full flex flex-col shadow-2xl">
            <div className="p-6 border-b border-slate-100 flex justify-between items-center bg-white sticky top-0 z-10">
                <div>
                    <h3 className="text-lg font-black text-slate-800 uppercase italic tracking-tight">Buscar Aluno</h3>
                    <p className="text-xs text-slate-400 font-bold uppercase tracking-widest">Base da Escola</p>
                </div>
                <button onClick={onCancel} className="p-2 hover:bg-slate-50 rounded-full text-slate-400"><X size={20} /></button>
            </div>

            <div className="p-4 bg-slate-50 border-b border-slate-100">
                <div className="relative">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" size={18} />
                    <input
                        type="text"
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        placeholder="Nome do aluno..."
                        className="w-full pl-10 pr-4 py-3 bg-white border border-slate-200 rounded-xl text-sm font-bold outline-none focus:ring-2 focus:ring-blue-100 transition-all"
                    />
                </div>
            </div>

            <div className="flex-1 overflow-y-auto p-4 custom-scrollbar">
                {loading && (
                    <div className="flex justify-center p-8">
                        <Loader2 className="animate-spin text-blue-500" size={24} />
                    </div>
                )}

                {!loading && students.length === 0 && (
                    <div className="text-center py-12">
                        <p className="text-slate-400 text-sm font-medium">Nenhum aluno encontrado.</p>
                    </div>
                )}

                <div className="space-y-2">
                    {students.map(student => {
                        const isSelected = selectedIds.has(student.id);
                        return (
                            <button
                                key={student.id}
                                onClick={() => toggleSelection(student.id)}
                                className={`w-full flex items-center p-3 rounded-xl border transition-all ${isSelected
                                        ? 'bg-blue-50 border-blue-200 shadow-sm'
                                        : 'bg-white border-slate-100 hover:bg-slate-50'
                                    }`}
                            >
                                <div className={`w-5 h-5 rounded-full border flex items-center justify-center mr-3 transition-colors ${isSelected ? 'bg-blue-500 border-blue-500' : 'border-slate-300'
                                    }`}>
                                    {isSelected && <CheckCircle2 size={14} className="text-white" />}
                                </div>
                                <div className="text-left">
                                    <h2 className={`text-sm font-bold ${isSelected ? 'text-blue-900' : 'text-slate-700'}`}>{student.name}</h2>
                                    {student.birth_date && <p className="text-xs text-slate-400 font-medium">Nasc: {new Date(student.birth_date).toLocaleDateString('pt-BR')}</p>}
                                </div>
                            </button>
                        );
                    })}
                </div>
            </div>

            <div className="p-4 border-t border-slate-100 bg-white grid grid-cols-2 gap-3">
                <button
                    onClick={onCancel}
                    className="py-3 rounded-xl font-black text-xs uppercase tracking-widest text-slate-500 hover:bg-slate-50 transition-colors"
                >
                    Cancelar
                </button>
                <button
                    onClick={handleImport}
                    disabled={selectedIds.size === 0}
                    className="py-3 bg-blue-600 disabled:bg-slate-300 disabled:cursor-not-allowed text-white rounded-xl font-black text-xs uppercase tracking-widest hover:bg-blue-700 transition-colors shadow-lg shadow-blue-200 disabled:shadow-none"
                >
                    Importar ({selectedIds.size})
                </button>
            </div>
        </div>
    );
};

export default SchoolStudentSelector;
