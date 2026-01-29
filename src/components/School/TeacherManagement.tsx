import React, { useState, useEffect } from 'react';
import { Plus, GraduationCap, Mail, Users, Trash2, Clock, CheckCircle, Check } from 'lucide-react';

interface Teacher {
    id: string;
    email: string;
    full_name: string;
    masp?: string;
    created_at: string;
}

interface PendingTeacher {
    id: string;
    email_institucional: string;
    masp: string;
    full_name: string;
    status: 'pending' | 'matched' | 'expired';
    created_at: string;
}

interface TeacherManagementProps {
    schoolId: string;
    teachers: Teacher[];
    onRefresh: () => void;
}

export const TeacherManagement: React.FC<TeacherManagementProps> = ({ schoolId, teachers, onRefresh }) => {
    const [pendingTeachers, setPendingTeachers] = useState<PendingTeacher[]>([]);
    const [isAddingTeacher, setIsAddingTeacher] = useState(false);
    const [newTeacherEmail, setNewTeacherEmail] = useState('');
    const [newTeacherName, setNewTeacherName] = useState('');
    const [newTeacherMasp, setNewTeacherMasp] = useState('');
    const [isSubmitting, setIsSubmitting] = useState(false);

    useEffect(() => {
        loadPendingTeachers();
    }, [schoolId]);

    const loadPendingTeachers = async () => {
        try {
            const { getPendingTeachersBySchool } = await import('../../services/teacherService');
            const data = await getPendingTeachersBySchool(schoolId);
            setPendingTeachers(data);
        } catch (error) {
            console.error('Error loading pending teachers:', error);
        }
    };

    const handleCreatePendingTeacher = async () => {
        if (!newTeacherEmail.trim() || !newTeacherName.trim() || !newTeacherMasp.trim()) {
            alert('Preencha todos os campos obrigatórios');
            return;
        }

        // Validate email format
        if (!newTeacherEmail.endsWith('@educacao.mg.gov.br')) {
            alert('Email deve ser institucional (@educacao.mg.gov.br)');
            return;
        }

        setIsSubmitting(true);
        try {
            const { createPendingTeacher } = await import('../../services/teacherService');
            const result = await createPendingTeacher({
                email_institucional: newTeacherEmail,
                full_name: newTeacherName,
                masp: newTeacherMasp,
                school_id: schoolId
            });

            if (result.success) {
                alert('Professor pré-cadastrado com sucesso! Ele será vinculado automaticamente quando fizer login.');
                setIsAddingTeacher(false);
                setNewTeacherEmail('');
                setNewTeacherName('');
                setNewTeacherMasp('');
                loadPendingTeachers();
                onRefresh();
            } else {
                alert('Erro ao cadastrar professor: ' + result.error);
            }
        } catch (error: any) {
            alert('Erro: ' + error.message);
        } finally {
            setIsSubmitting(false);
        }
    };

    const handleDeletePending = async (pendingId: string, name: string) => {
        if (!confirm(`Tem certeza que deseja remover o pré-cadastro de ${name}?`)) {
            return;
        }

        try {
            const { deletePendingTeacher } = await import('../../services/teacherService');
            const result = await deletePendingTeacher(pendingId);

            if (result.success) {
                alert('Professor removido com sucesso!');
                loadPendingTeachers();
            } else {
                alert('Erro ao remover professor: ' + result.error);
            }
        } catch (error: any) {
            alert('Erro: ' + error.message);
        }
    };

    return (
        <div className="space-y-6">
            {/* Header */}
            <div className="flex items-center justify-between">
                <h2 className="text-lg font-bold text-slate-800">Professores</h2>
                <button
                    onClick={() => setIsAddingTeacher(true)}
                    className="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg text-sm font-bold hover:bg-blue-700 transition"
                >
                    <Plus size={16} />
                    Cadastrar Professor
                </button>
            </div>

            {/* Pending Teachers Section */}
            {pendingTeachers.filter(t => t.status === 'pending').length > 0 && (
                <div>
                    <h3 className="text-md font-bold text-slate-700 mb-3 flex items-center gap-2">
                        <Clock size={18} className="text-amber-500" />
                        Aguardando Primeiro Login ({pendingTeachers.filter(t => t.status === 'pending').length})
                    </h3>
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                        {pendingTeachers
                            .filter(t => t.status === 'pending')
                            .map((pending) => (
                                <div
                                    key={pending.id}
                                    className="bg-amber-50 rounded-xl shadow-sm border border-amber-200 p-6 hover:shadow-md transition"
                                >
                                    <div className="flex items-start justify-between mb-4">
                                        <div className="flex-1">
                                            <div className="flex items-center gap-2 mb-1">
                                                <h3 className="text-lg font-bold text-slate-800">{pending.full_name}</h3>
                                                <span className="px-2 py-0.5 bg-amber-200 text-amber-800 text-xs font-bold rounded">
                                                    PENDENTE
                                                </span>
                                            </div>
                                            <p className="text-sm text-slate-500">MASP: {pending.masp}</p>
                                        </div>
                                        <div className="p-2 bg-amber-200 rounded-lg">
                                            <Clock className="w-5 h-5 text-amber-700" />
                                        </div>
                                    </div>

                                    <div className="space-y-2 text-sm text-slate-600 mb-4">
                                        <p className="flex items-center gap-2">
                                            <Mail size={14} className="text-slate-400" />
                                            {pending.email_institucional}
                                        </p>
                                        <p className="text-xs text-slate-500">
                                            Cadastrado em {new Date(pending.created_at).toLocaleDateString('pt-BR')}
                                        </p>
                                    </div>

                                    <div className="flex items-center gap-2 pt-4 mt-2 border-t border-amber-200">
                                        <button
                                            onClick={() => handleDeletePending(pending.id, pending.full_name)}
                                            className="flex-1 flex items-center justify-center gap-1.5 px-3 py-2 text-sm text-red-600 hover:text-red-700 hover:bg-red-50 font-bold rounded-lg border border-transparent hover:border-red-200 transition"
                                        >
                                            <Trash2 size={16} />
                                            Remover
                                        </button>
                                        <button
                                            onClick={async () => {
                                                if (!confirm(`Confirmar aprovação de ${pending.full_name}?`)) return;
                                                try {
                                                    const { approveTeacher } = await import('../../services/teacherService');
                                                    const result = await approveTeacher(pending.id);
                                                    if (result.success) {
                                                        alert(result.message);
                                                        loadPendingTeachers();
                                                        onRefresh();
                                                    } else {
                                                        alert('Erro: ' + result.error);
                                                    }
                                                } catch (err: any) {
                                                    alert('Erro: ' + err.message);
                                                }
                                            }}
                                            className="flex-1 flex items-center justify-center gap-1.5 px-3 py-2 text-sm text-green-700 bg-green-100 hover:bg-green-200 font-bold rounded-lg border border-green-200 transition"
                                        >
                                            <Check size={16} />
                                            Aprovar
                                        </button>
                                    </div>
                                </div>
                            ))}
                    </div>
                </div >
            )}

            {/* Active Teachers Section */}
            <div>
                <h3 className="text-md font-bold text-slate-700 mb-3 flex items-center gap-2">
                    <CheckCircle size={18} className="text-green-500" />
                    Professores Ativos ({teachers.length})
                </h3>
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                    {teachers.length === 0 ? (
                        <div className="col-span-full bg-white rounded-xl shadow-sm border border-slate-200 p-12 text-center">
                            <GraduationCap className="w-12 h-12 text-slate-300 mx-auto mb-4" />
                            <p className="text-slate-400 text-sm">
                                Nenhum professor ativo ainda.
                            </p>
                        </div>
                    ) : (
                        teachers.map((teacher) => (
                            <div
                                key={teacher.id}
                                className="bg-white rounded-xl shadow-sm border border-slate-200 p-6 hover:shadow-md transition"
                            >
                                <div className="flex items-start justify-between mb-4">
                                    <div className="flex-1">
                                        <div className="flex items-center gap-2 mb-1">
                                            <h3 className="text-lg font-bold text-slate-800">{teacher.full_name || 'Sem nome'}</h3>
                                            <span className="px-2 py-0.5 bg-green-200 text-green-800 text-xs font-bold rounded">
                                                ATIVO
                                            </span>
                                        </div>
                                        {teacher.masp && (
                                            <p className="text-sm text-slate-500">MASP: {teacher.masp}</p>
                                        )}
                                    </div>
                                    <div className="p-2 bg-green-100 rounded-lg">
                                        <GraduationCap className="w-5 h-5 text-green-600" />
                                    </div>
                                </div>

                                <div className="space-y-2 text-sm text-slate-600">
                                    <p className="flex items-center gap-2">
                                        <Mail size={14} className="text-slate-400" />
                                        {teacher.email}
                                    </p>
                                    <p className="text-xs text-slate-500">
                                        Cadastrado em {new Date(teacher.created_at).toLocaleDateString('pt-BR')}
                                    </p>
                                </div>
                            </div>
                        ))
                    )}
                </div>
            </div>

            {/* Add Teacher Modal */}
            {
                isAddingTeacher && (
                    <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
                        <div className="bg-white rounded-xl shadow-xl max-w-md w-full p-6">
                            <h3 className="text-lg font-bold text-slate-800 mb-2">Cadastrar Professor</h3>
                            <p className="text-sm text-slate-600 mb-4">
                                O professor será vinculado automaticamente quando fizer login com esses dados.
                            </p>

                            <div className="space-y-4">
                                <div>
                                    <label className="block text-sm font-bold text-slate-700 mb-1">Nome Completo *</label>
                                    <input
                                        type="text"
                                        placeholder="Ex: João da Silva"
                                        value={newTeacherName}
                                        onChange={(e) => setNewTeacherName(e.target.value)}
                                        className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                    />
                                </div>

                                <div>
                                    <label className="block text-sm font-bold text-slate-700 mb-1">Email Institucional *</label>
                                    <input
                                        type="email"
                                        placeholder="nome@educacao.mg.gov.br"
                                        value={newTeacherEmail}
                                        onChange={(e) => setNewTeacherEmail(e.target.value)}
                                        className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                    />
                                    <p className="text-xs text-slate-500 mt-1">Deve terminar com @educacao.mg.gov.br</p>
                                </div>

                                <div>
                                    <label className="block text-sm font-bold text-slate-700 mb-1">MASP *</label>
                                    <input
                                        type="text"
                                        placeholder="Ex: 1234567"
                                        value={newTeacherMasp}
                                        onChange={(e) => setNewTeacherMasp(e.target.value)}
                                        className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                                    />
                                </div>
                            </div>

                            <div className="flex gap-3 mt-6">
                                <button
                                    onClick={() => {
                                        setIsAddingTeacher(false);
                                        setNewTeacherEmail('');
                                        setNewTeacherName('');
                                        setNewTeacherMasp('');
                                    }}
                                    disabled={isSubmitting}
                                    className="flex-1 px-4 py-2 border border-slate-300 text-slate-700 rounded-lg font-bold hover:bg-slate-50 transition disabled:opacity-50"
                                >
                                    Cancelar
                                </button>
                                <button
                                    onClick={handleCreatePendingTeacher}
                                    disabled={isSubmitting}
                                    className="flex-1 px-4 py-2 bg-blue-600 text-white rounded-lg font-bold hover:bg-blue-700 transition disabled:opacity-50"
                                >
                                    {isSubmitting ? 'Cadastrando...' : 'Cadastrar'}
                                </button>
                            </div>
                        </div>
                    </div>
                )
            }
        </div >
    );
};

export default TeacherManagement;
