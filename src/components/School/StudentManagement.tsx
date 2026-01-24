import React, { useState } from 'react';
import { Plus, Users, Trash2, Edit2 } from 'lucide-react';

interface Student {
    id: string;
    name: string;
    student_code?: string;
    serie?: string;
    special_needs?: string;
}

interface StudentManagementProps {
    schoolId: string;
    students: Student[];
    onRefresh: () => void;
}

export const StudentManagement: React.FC<StudentManagementProps> = ({ schoolId, students, onRefresh }) => {
    const [isAddingStudent, setIsAddingStudent] = useState(false);
    const [newStudentName, setNewStudentName] = useState('');
    const [newStudentCode, setNewStudentCode] = useState('');
    const [newStudentSerie, setNewStudentSerie] = useState('');
    const [newStudentNeeds, setNewStudentNeeds] = useState('');
    const [isSubmitting, setIsSubmitting] = useState(false);

    const handleCreateStudent = async () => {
        if (!newStudentName.trim()) {
            alert('Digite o nome do aluno');
            return;
        }

        setIsSubmitting(true);
        try {
            const { createStudent } = await import('../../services/studentService');
            const result = await createStudent({
                name: newStudentName,
                student_code: newStudentCode || undefined,
                current_school_id: schoolId,
                serie: newStudentSerie || undefined,
                special_needs: newStudentNeeds || undefined
            });

            if (result.success) {
                alert('Aluno cadastrado com sucesso!');
                setIsAddingStudent(false);
                setNewStudentName('');
                setNewStudentCode('');
                setNewStudentSerie('');
                setNewStudentNeeds('');
                onRefresh();
            } else {
                alert('Erro ao cadastrar aluno: ' + result.error);
            }
        } catch (error: any) {
            alert('Erro: ' + error.message);
        } finally {
            setIsSubmitting(false);
        }
    };

    const handleDeleteStudent = async (studentId: string, studentName: string) => {
        if (!confirm(`Tem certeza que deseja excluir o aluno ${studentName}?`)) {
            return;
        }

        try {
            const { deleteStudent } = await import('../../services/studentService');
            const result = await deleteStudent(studentId);

            if (result.success) {
                alert('Aluno excluído com sucesso!');
                onRefresh();
            } else {
                alert('Erro ao excluir aluno: ' + result.error);
            }
        } catch (error: any) {
            alert('Erro: ' + error.message);
        }
    };

    return (
        <div className="space-y-6">
            {/* Header */}
            <div className="flex items-center justify-between">
                <h2 className="text-lg font-bold text-slate-800">Alunos</h2>
                <button
                    onClick={() => setIsAddingStudent(true)}
                    className="flex items-center gap-2 px-4 py-2 bg-green-600 text-white rounded-lg text-sm font-bold hover:bg-green-700 transition"
                >
                    <Plus size={16} />
                    Adicionar Aluno
                </button>
            </div>

            {/* Students Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                {students.length === 0 ? (
                    <div className="col-span-full bg-white rounded-xl shadow-sm border border-slate-200 p-12 text-center">
                        <Users className="w-12 h-12 text-slate-300 mx-auto mb-4" />
                        <p className="text-slate-400 text-sm">
                            Nenhum aluno cadastrado ainda.
                            <br />
                            Clique em "Adicionar Aluno" para começar.
                        </p>
                    </div>
                ) : (
                    students.map((student) => (
                        <div
                            key={student.id}
                            className="bg-white rounded-xl shadow-sm border border-slate-200 p-6 hover:shadow-md transition"
                        >
                            <div className="flex items-start justify-between mb-4">
                                <div className="flex-1">
                                    <h3 className="text-lg font-bold text-slate-800">{student.name}</h3>
                                    {student.student_code && (
                                        <p className="text-sm text-slate-500">Código: {student.student_code}</p>
                                    )}
                                </div>
                                <div className="p-2 bg-green-100 rounded-lg">
                                    <Users className="w-5 h-5 text-green-600" />
                                </div>
                            </div>

                            <div className="space-y-2 text-sm text-slate-600 mb-4">
                                {student.serie && (
                                    <p className="flex items-center gap-2">
                                        <span className="w-2 h-2 bg-green-400 rounded-full"></span>
                                        Série: {student.serie}
                                    </p>
                                )}
                                {student.special_needs && (
                                    <p className="flex items-center gap-2">
                                        <span className="w-2 h-2 bg-amber-400 rounded-full"></span>
                                        <span className="text-xs">{student.special_needs}</span>
                                    </p>
                                )}
                            </div>

                            <div className="flex gap-2 pt-4 border-t border-slate-100">
                                <button
                                    onClick={() => handleDeleteStudent(student.id, student.name)}
                                    className="flex items-center gap-1 text-sm text-red-600 hover:text-red-700 font-bold"
                                >
                                    <Trash2 size={14} />
                                    Excluir
                                </button>
                            </div>
                        </div>
                    ))
                )}
            </div>

            {/* Add Student Modal */}
            {isAddingStudent && (
                <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
                    <div className="bg-white rounded-xl shadow-xl max-w-md w-full p-6">
                        <h3 className="text-lg font-bold text-slate-800 mb-4">Adicionar Aluno</h3>

                        <div className="space-y-4">
                            <div>
                                <label className="block text-sm font-bold text-slate-700 mb-1">Nome Completo *</label>
                                <input
                                    type="text"
                                    placeholder="Ex: Maria Santos"
                                    value={newStudentName}
                                    onChange={(e) => setNewStudentName(e.target.value)}
                                    className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-bold text-slate-700 mb-1">Código do Aluno (opcional)</label>
                                <input
                                    type="text"
                                    placeholder="Auto-gerado se vazio"
                                    value={newStudentCode}
                                    onChange={(e) => setNewStudentCode(e.target.value)}
                                    className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-bold text-slate-700 mb-1">Série/Ano (opcional)</label>
                                <input
                                    type="text"
                                    placeholder="Ex: 3º Ano"
                                    value={newStudentSerie}
                                    onChange={(e) => setNewStudentSerie(e.target.value)}
                                    className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent"
                                />
                            </div>

                            <div>
                                <label className="block text-sm font-bold text-slate-700 mb-1">Necessidades Especiais (opcional)</label>
                                <textarea
                                    placeholder="Ex: Dislexia, TDAH, etc."
                                    value={newStudentNeeds}
                                    onChange={(e) => setNewStudentNeeds(e.target.value)}
                                    rows={3}
                                    className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent resize-none"
                                />
                            </div>
                        </div>

                        <div className="flex gap-3 mt-6">
                            <button
                                onClick={() => {
                                    setIsAddingStudent(false);
                                    setNewStudentName('');
                                    setNewStudentCode('');
                                    setNewStudentSerie('');
                                    setNewStudentNeeds('');
                                }}
                                disabled={isSubmitting}
                                className="flex-1 px-4 py-2 border border-slate-300 text-slate-700 rounded-lg font-bold hover:bg-slate-50 transition disabled:opacity-50"
                            >
                                Cancelar
                            </button>
                            <button
                                onClick={handleCreateStudent}
                                disabled={isSubmitting}
                                className="flex-1 px-4 py-2 bg-green-600 text-white rounded-lg font-bold hover:bg-green-700 transition disabled:opacity-50"
                            >
                                {isSubmitting ? 'Cadastrando...' : 'Cadastrar'}
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default StudentManagement;
