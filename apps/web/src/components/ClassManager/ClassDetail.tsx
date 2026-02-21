import React, { useState } from 'react';
import { X, Search, Settings, AlertTriangle } from 'lucide-react';
import { Class, Student } from '../../types';
import StudentPdiDrawer from './StudentPdiDrawer';
import QuickPdiLog from '../QuickPdiLog';

interface ClassDetailProps {
    selectedClass: Class;
    onClose: () => void;
    onUpdateStudent: (updatedStudent: Student) => Promise<void>;
}

const ClassDetail: React.FC<ClassDetailProps> = ({
    selectedClass,
    onClose,
    onUpdateStudent
}) => {
    const [searchTerm, setSearchTerm] = useState('');
    const [isDrawerOpen, setIsDrawerOpen] = useState(false);
    const [editingStudent, setEditingStudent] = useState<Student | null>(null);
    const [quickLogStudent, setQuickLogStudent] = useState<{ id: string, name: string } | null>(null);

    const filteredStudents = selectedClass.students?.filter(student =>
        student.name.toLowerCase().includes(searchTerm.toLowerCase())
    ) || [];

    const openStudentDrawer = (student: Student) => {
        setEditingStudent({ ...student, deficiencies: student.deficiencies || [] });
        setIsDrawerOpen(true);
    };

    const handleSaveStudent = async (updatedStudent: Student) => {
        await onUpdateStudent(updatedStudent);
        setIsDrawerOpen(false);
    };

    return (
        <div className="space-y-8 animate-in fade-in slide-in-from-right-4 duration-500 relative">
            <div className="flex items-center gap-4">
                <button
                    onClick={onClose}
                    className="p-3 hover:bg-slate-100 rounded-2xl transition-colors"
                >
                    <X size={20} />
                </button>
                <div>
                    <h2 className="text-2xl font-black text-slate-900 tracking-tight uppercase italic">{selectedClass.name}</h2>
                    <p className="text-xs font-bold text-slate-400 uppercase tracking-widest mt-1">{selectedClass.subject} • {selectedClass.students?.length || 0} Alunos</p>
                </div>
            </div>

            <div className="bg-white border border-slate-100 rounded-[2.5rem] shadow-sm overflow-hidden flex flex-col md:flex-row">
                <div className="flex-1">
                    <div className="p-8 border-b border-slate-50 bg-slate-50/50 flex items-center justify-between">
                        <h3 className="font-black text-[10px] uppercase tracking-[0.2em] text-slate-400 italic">Lista de Chamada Digital</h3>

                        <div className="relative">
                            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" size={14} />
                            <input
                                type="text"
                                placeholder="Buscar aluno..."
                                value={searchTerm}
                                onChange={(e) => setSearchTerm(e.target.value)}
                                className="pl-9 pr-4 py-2 bg-white border border-slate-200 rounded-xl text-xs font-bold outline-none focus:ring-2 focus:ring-blue-100 w-48"
                            />
                        </div>
                    </div>

                    <div className="overflow-x-auto pb-4 max-h-[600px] overflow-y-auto">
                        <table className="w-full text-left min-w-[600px]">
                            <thead>
                                <tr className="border-b border-slate-50 sticky top-0 bg-white z-10 shadow-sm">
                                    <th className="px-10 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">#</th>
                                    <th className="px-10 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest">Nome do Aluno</th>
                                    <th className="px-10 py-5 text-[10px] font-black text-slate-400 uppercase tracking-widest text-right">Ações</th>
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-slate-50">
                                {filteredStudents.length > 0 ? (
                                    filteredStudents.map((student, index) => (
                                        <tr key={student.id || index} className={`hover:bg-slate-50 transition-colors group ${student.needs_adaptation ? 'bg-purple-50/30' : ''}`}>
                                            <td className="px-10 py-5 text-sm font-black text-slate-300 italic">{(index + 1).toString().padStart(2, '0')}</td>
                                            <td className="px-10 py-5">
                                                <div className="flex items-center gap-2">
                                                    <span className={`text-sm font-bold ${student.needs_adaptation ? 'text-purple-700' : 'text-slate-700'}`}>
                                                        {student.name}
                                                    </span>
                                                    {student.needs_adaptation && (
                                                        <span className="w-2 h-2 bg-purple-500 rounded-full animate-pulse" title="Necessita Adaptação"></span>
                                                    )}
                                                </div>
                                                {student.deficiencies && student.deficiencies.length > 0 && (
                                                    <div className="flex gap-1 mt-1 flex-wrap">
                                                        {student.deficiencies.map(def => (
                                                            <span key={def} className="text-[9px] px-1.5 py-0.5 bg-slate-100 text-slate-500 rounded uppercase font-bold tracking-wider">{def}</span>
                                                        ))}
                                                    </div>
                                                )}
                                            </td>
                                            <td className="px-10 py-5 text-right flex items-center justify-end gap-2">
                                                <button
                                                    onClick={() => setQuickLogStudent({ id: student.id, name: student.name })}
                                                    className="p-2 text-yellow-500 hover:bg-yellow-50 rounded-xl transition-colors relative group/btn"
                                                    title="Registro Rápido (Ocorrência)"
                                                >
                                                    <AlertTriangle size={18} />
                                                    <span className="absolute right-full mr-2 top-1/2 -translate-y-1/2 px-2 py-1 bg-slate-800 text-white text-[9px] font-bold uppercase rounded opacity-0 group-hover/btn:opacity-100 transition-opacity whitespace-nowrap">
                                                        Registrar Ocorrência
                                                    </span>
                                                </button>
                                                <button
                                                    onClick={() => openStudentDrawer(student)}
                                                    className="p-2 text-slate-400 hover:text-blue-600 transition-colors relative group/btn"
                                                    title="Perfil Pedagógico"
                                                >
                                                    <Settings size={18} />
                                                    <span className="absolute right-full mr-2 top-1/2 -translate-y-1/2 px-2 py-1 bg-slate-800 text-white text-[9px] font-bold uppercase rounded opacity-0 group-hover/btn:opacity-100 transition-opacity whitespace-nowrap">
                                                        Editar Perfil
                                                    </span>
                                                </button>
                                            </td>
                                        </tr>
                                    ))
                                ) : (
                                    <tr>
                                        <td colSpan={3} className="px-10 py-10 text-center text-slate-400 text-sm">
                                            Nenhum aluno encontrado para "{searchTerm}".
                                        </td>
                                    </tr>
                                )}
                            </tbody>
                        </table>
                    </div>
                </div>

                {/* Side Drawer for PDI Editing */}
                <StudentPdiDrawer
                    isOpen={isDrawerOpen}
                    student={editingStudent}
                    onClose={() => setIsDrawerOpen(false)}
                    onSave={handleSaveStudent}
                />
            </div>

            {/* Quick Log Modal */}
            {quickLogStudent && (
                <div className="fixed inset-0 bg-slate-950/80 backdrop-blur-sm z-[9999] flex items-center justify-center p-4">
                    <div className="bg-white rounded-[2rem] p-6 w-full max-w-md shadow-2xl relative">
                        <button
                            onClick={() => setQuickLogStudent(null)}
                            className="absolute top-4 right-4 p-2 hover:bg-slate-50 rounded-full"
                        >
                            <X size={20} className="text-slate-400" />
                        </button>
                        <QuickPdiLog
                            studentId={quickLogStudent.id}
                            studentName={quickLogStudent.name}
                            onClose={() => setQuickLogStudent(null)}
                        />
                    </div>
                </div>
            )}
        </div>
    );
};

export default ClassDetail;
