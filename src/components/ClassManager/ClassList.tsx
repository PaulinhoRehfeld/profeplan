import React from 'react';
import { Users, Trash2, ChevronRight } from 'lucide-react';
import { Class } from '../../types';

interface ClassListProps {
    classes: Class[];
    loading: boolean;
    searchTerm: string;
    onSelectClass: (id: string) => void;
    onDeleteClass: (id: string) => void;
}

const ClassList: React.FC<ClassListProps> = ({
    classes,
    loading,
    searchTerm,
    onSelectClass,
    onDeleteClass
}) => {
    const filteredClasses = classes.filter(c =>
        c.name.toLowerCase().includes(searchTerm.toLowerCase())
    );

    if (loading) return null; // Parent handles loading spinner usually, or we can add here

    return (
        <div className="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-8">
            {filteredClasses.map((cls) => (
                <div
                    key={cls.id}
                    className="group bg-white border border-slate-100 rounded-[2.5rem] p-8 shadow-sm hover:shadow-2xl hover:border-blue-100 transition-all duration-500 relative overflow-hidden cursor-pointer"
                    onClick={() => onSelectClass(cls.id)}
                >
                    <div className="absolute top-0 right-0 w-32 h-32 bg-blue-50/50 blur-3xl rounded-full -mr-16 -mt-16 group-hover:bg-blue-100 transition-colors"></div>

                    <div className="flex items-start justify-between mb-6 relative z-10">
                        <div className="w-14 h-14 bg-gradient-to-br from-slate-900 to-slate-800 rounded-2xl flex items-center justify-center text-white shadow-xl shadow-slate-100 group-hover:scale-110 transition-transform">
                            <Users size={24} />
                        </div>
                        <button
                            onClick={(e) => { e.stopPropagation(); onDeleteClass(cls.id); }}
                            className="p-3 text-slate-300 hover:text-red-500 hover:bg-red-50 rounded-xl transition-colors shrink-0"
                        >
                            <Trash2 size={18} />
                        </button>
                    </div>

                    <h3 className="font-black text-slate-900 text-xl mb-1 uppercase italic line-clamp-1 tracking-tighter">
                        {cls.name}
                    </h3>
                    <p className="text-[10px] font-black text-blue-600 uppercase tracking-[0.2em] mb-4">{cls.subject || 'Sem Disciplina'}</p>

                    {/* Informações Adicionais */}
                    <div className="flex flex-wrap gap-2 mb-6">
                        {cls.grade && (
                            <span className="px-3 py-1 bg-purple-50 text-purple-700 text-[9px] font-black uppercase tracking-wider rounded-full">
                                📚 {cls.grade}
                            </span>
                        )}
                        {cls.shift && (
                            <span className="px-3 py-1 bg-orange-50 text-orange-700 text-[9px] font-black uppercase tracking-wider rounded-full">
                                🕐 {cls.shift}
                            </span>
                        )}
                        {cls.year && (
                            <span className="px-3 py-1 bg-green-50 text-green-700 text-[9px] font-black uppercase tracking-wider rounded-full">
                                📅 {cls.year}
                            </span>
                        )}
                        {cls.room && (
                            <span className="px-3 py-1 bg-indigo-50 text-indigo-700 text-[9px] font-black uppercase tracking-wider rounded-full">
                                🚪 Sala {cls.room}
                            </span>
                        )}
                    </div>

                    <div className="flex items-center justify-between pt-6 border-t border-slate-50 relative z-10">
                        <div className="flex flex-col">
                            <p className="text-[9px] font-black text-slate-400 uppercase tracking-widest">Estudantes</p>
                            <p className="text-lg font-black text-slate-900 italic">{(cls as any).students?.[0]?.count || ((cls as any).students?.length || 0)}</p>
                        </div>
                        <button
                            className="px-6 py-3 bg-slate-50 text-slate-900 rounded-xl font-black text-[10px] uppercase tracking-widest hover:bg-blue-600 hover:text-white transition-all flex items-center gap-2 group/btn"
                        >
                            Ver Alunos <ChevronRight size={14} className="group-hover/btn:translate-x-1 transition-transform" />
                        </button>
                    </div>
                </div>
            ))}
        </div>
    );
};

export default ClassList;
