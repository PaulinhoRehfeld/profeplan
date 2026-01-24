import React, { useState } from 'react';
import { Plus, Upload, BookOpen, Users, ChevronRight } from 'lucide-react';

interface Class {
    id: string;
    name: string;
    grade?: string;
    year: number;
    shift?: string;
    room?: string;
}

interface ClassManagementProps {
    schoolId: string;
    classes: Class[];
    onRefresh: () => void;
}

export const ClassManagement: React.FC<ClassManagementProps> = ({ schoolId, classes, onRefresh }) => {
    const [selectedClass, setSelectedClass] = useState<Class | null>(null);
    const [isAddingClass, setIsAddingClass] = useState(false);
    const [newClassName, setNewClassName] = useState('');
    const [newClassGrade, setNewClassGrade] = useState('');
    const [newClassShift, setNewClassShift] = useState('Matutino');
    const [newClassRoom, setNewClassRoom] = useState('');
    const [isSubmitting, setIsSubmitting] = useState(false);

    const handleCreateClass = async () => {
        if (!newClassName.trim()) {
            alert('Digite o nome da turma');
            return;
        }

        setIsSubmitting(true);
        try {
            const { createClass } = await import('../../services/classService');
            const result = await createClass({
                school_id: schoolId,
                name: newClassName,
                grade: newClassGrade || undefined,
                shift: newClassShift,
                room: newClassRoom || undefined
            });

            if (result.success) {
                alert('Turma criada com sucesso!');
                setIsAddingClass(false);
                setNewClassName('');
                setNewClassGrade('');
                setNewClassShift('Matutino');
                setNewClassRoom('');
                onRefresh();
            } else {
                alert('Erro ao criar turma: ' + result.error);
            }
        } catch (error: any) {
            alert('Erro: ' + error.message);
        } finally {
            setIsSubmitting(false);
        }
    };

    return (
        <div className="space-y-6">
            {/* Header */}
            <div className="flex items-center justify-between">
                <h2 className="text-lg font-bold text-slate-800">Turmas</h2>
                <button
                    onClick={() => setIsAddingClass(true)}
                    className="flex items-center gap-2 px-4 py-2 bg-purple-600 text-white rounded-lg text-sm font-bold hover:bg-purple-700 transition"
                >
                    <Plus size={16} />
                    Nova Turma
                </button>
            </div>

            {/* Classes List */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {classes.length === 0 ? (
                    <div className="col-span-full bg-white rounded-xl shadow-sm border border-slate-200 p-12 text-center">
                        <BookOpen className="w-12 h-12 text-slate-300 mx-auto mb-4" />
                        <p className="text-slate-400 text-sm">
                            Nenhuma turma cadastrada ainda.
                            <br />
                            Clique em "Nova Turma" para começar.
                        </p>
                    </div>
                ) : (
                    classes.map((classItem) => (
                        <div
                            key={classItem.id}
                            className="bg-white rounded-xl shadow-sm border border-slate-200 p-6 hover:shadow-md transition cursor-pointer"
                            onClick={() => setSelectedClass(classItem)}
                        >
                            <div className="flex items-start justify-between mb-4">
                                <div>
                                    <h3 className="text-lg font-bold text-slate-800">{classItem.name}</h3>
                                    {classItem.grade && (
                                        <p className="text-sm text-slate-500">{classItem.grade}</p>
                                    )}
                                </div>
                                <div className="p-2 bg-purple-100 rounded-lg">
                                    <BookOpen className="w-5 h-5 text-purple-600" />
                                </div>
                            </div>

                            <div className="space-y-2 text-sm text-slate-600">
                                {classItem.shift && (
                                    <p className="flex items-center gap-2">
                                        <span className="w-2 h-2 bg-purple-400 rounded-full"></span>
                                        {classItem.shift}
                                    </p>
                                )}
                                {classItem.room && (
                                    <p className="flex items-center gap-2">
                                        <span className="w-2 h-2 bg-purple-400 rounded-full"></span>
                                        Sala {classItem.room}
                                    </p>
                                )}
                                <p className="flex items-center gap-2">
                                    <span className="w-2 h-2 bg-purple-400 rounded-full"></span>
                                    Ano: {classItem.year}
                                </p>
                            </div>

                            <div className="mt-4 pt-4 border-t border-slate-100 flex items-center justify-between">
                                <div className="flex items-center gap-2 text-sm text-slate-500">
                                    <Users size={16} />
                                    <span>0 alunos</span>
                                </div>
                                <button
                                    className="flex items-center gap-1 text-sm text-purple-600 font-bold hover:text-purple-700"
                                    onClick={(e) => {
                                        e.stopPropagation();
                                        // TODO: Open PDF import modal
                                    }}
                                >
                                    <Upload size={14} />
                                    Importar
                                </button>
                            </div>
                        </div>
                    ))
                )}
            </div>

            {/* Add Class Modal */}
            {isAddingClass && (
                <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
                    <div className="bg-white rounded-xl shadow-xl max-w-md w-full p-6">
                        <h3 className="text-lg font-bold text-slate-800 mb-4">Nova Turma</h3>

                        <div className="space-y-4">
                            <div>
                                <label className="block text-sm font-bold text-slate-700 mb-1">Nome da Turma *</label>
                                <input
                                    type="text"
                                    placeholder="Ex: 3º Ano A"
                                    value={newClassName}
                                    onChange={(e) => setNewClassName(e.target.value)}
                                    className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-bold text-slate-700 mb-1">Série/Ano</label>
                                <input
                                    type="text"
                                    placeholder="Ex: 3º Ano"
                                    value={newClassGrade}
                                    onChange={(e) => setNewClassGrade(e.target.value)}
                                    className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-bold text-slate-700 mb-1">Turno</label>
                                <select
                                    value={newClassShift}
                                    onChange={(e) => setNewClassShift(e.target.value)}
                                    className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                >
                                    <option value="Matutino">Matutino</option>
                                    <option value="Vespertino">Vespertino</option>
                                    <option value="Noturno">Noturno</option>
                                    <option value="Integral">Integral</option>
                                </select>
                            </div>

                            <div>
                                <label className="block text-sm font-bold text-slate-700 mb-1">Sala</label>
                                <input
                                    type="text"
                                    placeholder="Ex: 101"
                                    value={newClassRoom}
                                    onChange={(e) => setNewClassRoom(e.target.value)}
                                    className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                                />
                            </div>
                        </div>

                        <div className="flex gap-3 mt-6">
                            <button
                                onClick={() => {
                                    setIsAddingClass(false);
                                    setNewClassName('');
                                    setNewClassGrade('');
                                    setNewClassRoom('');
                                }}
                                disabled={isSubmitting}
                                className="flex-1 px-4 py-2 border border-slate-300 text-slate-700 rounded-lg font-bold hover:bg-slate-50 transition disabled:opacity-50"
                            >
                                Cancelar
                            </button>
                            <button
                                onClick={handleCreateClass}
                                disabled={isSubmitting}
                                className="flex-1 px-4 py-2 bg-purple-600 text-white rounded-lg font-bold hover:bg-purple-700 transition disabled:opacity-50"
                            >
                                {isSubmitting ? 'Criando...' : 'Criar Turma'}
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default ClassManagement;
