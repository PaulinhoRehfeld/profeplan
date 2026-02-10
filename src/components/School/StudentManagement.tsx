import React, { useState, useEffect } from 'react';
import { Plus, Users, Trash2, Edit2, Search, Filter, AlertTriangle, Save, X, ArrowRightLeft, ClipboardList } from 'lucide-react';
import { supabase } from '../../services/supabaseClient';
import { createStudent, updateStudent, archiveStudent } from '../../services/studentService';
import { StudentPDIProfile } from './PDI/StudentPDIProfile';

// Constants
const PDI_OPTIONS = [
    'TDAH', 'TOD', 'DISLEXIA', 'DISCALCULIA', 'TEA',
    'PARAPLEGIA', 'SURDO', 'CEGO', 'VISÃO MONOCULAR',
    'DEFICIÊNCIA INTELECTUAL', 'ALTAS HABILIDADES'
];

const DELETION_REASONS = [
    'Transferência de Escola',
    'Evasão Escolar',
    'Duplicidade de Registro',
    'Outro'
];

// Garantir que o tipo Student definido localmente seja utilizado corretamente
interface Student {
    id: string; // TEXT
    name: string;
    student_code?: string;
    class_id?: string;
    pdi_needs?: string[];
    deficiencies?: string[];
    observations?: string;
    pedagogical_observations?: string;
}

interface ClassItem {
    id: string;
    name: string;
    year: number;
}

interface StudentManagementProps {
    schoolId: string;
    students: Student[];
    onRefresh: () => void;
}

export const StudentManagement: React.FC<StudentManagementProps> = ({ schoolId, students, onRefresh }) => {
    // Mode State
    const [searchTerm, setSearchTerm] = useState('');

    // Modal States
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [isDeleteModalOpen, setIsDeleteModalOpen] = useState(false);
    const [editingStudent, setEditingStudent] = useState<Student | null>(null);
    const [studentToDelete, setStudentToDelete] = useState<Student | null>(null);

    // PDI Modal State
    const [pdiStudentId, setPdiStudentId] = useState<string | null>(null);

    // Form States
    const [formData, setFormData] = useState({
        name: '',
        student_code: '',
        class_id: '',
        pdi_needs: [] as string[],
        observations: ''
    });

    // Deletion Form
    const [deletionReason, setDeletionReason] = useState(DELETION_REASONS[0]);
    const [deletionDetails, setDeletionDetails] = useState('');

    // Data
    const [availableClasses, setAvailableClasses] = useState<ClassItem[]>([]);
    const [loading, setLoading] = useState(false);

    // Load Classes on mount
    useEffect(() => {
        loadClasses();
    }, [schoolId]);

    const loadClasses = async () => {
        const { data } = await supabase
            .from('classes')
            .select('id, name, year')
            .eq('school_id', schoolId)
            .order('year')
            .order('name');
        if (data) setAvailableClasses(data);
    };

    // Filtered Students
    const filteredStudents = students.filter(s =>
        s.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        s.student_code?.includes(searchTerm)
    );

    // Handlers
    const handleOpenModal = (student?: Student) => {
        if (student) {
            setEditingStudent(student);
            setFormData({
                name: student.name,
                student_code: student.student_code || '',
                class_id: student.class_id || '',
                // Fallback to legacy fields if new ones are empty
                pdi_needs: student.pdi_needs || student.deficiencies || [],
                observations: student.observations || student.pedagogical_observations || ''
            });
        } else {
            setEditingStudent(null); // Create mode
            setFormData({
                name: '',
                student_code: '',
                class_id: '',
                pdi_needs: [],
                observations: ''
            });
        }
        setIsModalOpen(true);
    };

    const handleSave = async () => {
        if (!formData.name.trim()) return alert('Nome é obrigatório');

        setLoading(true);
        try {
            const payload = {
                name: formData.name,
                student_code: formData.student_code,
                class_id: formData.class_id || undefined,
                // Save to BOTH new and legacy columns to ensure data sticks regardless of which one Supabase uses
                pdi_needs: formData.pdi_needs,
                deficiencies: formData.pdi_needs,
                observations: formData.observations,
                pedagogical_observations: formData.observations,
                current_school_id: schoolId
            };

            const result = editingStudent
                ? await updateStudent(editingStudent.id, payload)
                : await createStudent(payload);

            if (result.success) {
                alert(editingStudent ? 'Aluno atualizado!' : 'Aluno criado!');
                setIsModalOpen(false);
                onRefresh();
            } else {
                alert('Erro: ' + result.error);
            }
        } catch (error: any) {
            alert('Erro: ' + error.message);
        } finally {
            setLoading(false);
        }
    };

    const handleDeleteClick = (student: Student) => {
        setStudentToDelete(student);
        setDeletionReason(DELETION_REASONS[0]);
        setDeletionDetails('');
        setIsDeleteModalOpen(true);
    };

    const confirmDelete = async () => {
        if (!studentToDelete) return;

        if (deletionReason === 'Outro' && !deletionDetails.trim()) {
            alert('Por favor, descreva o motivo da exclusão.');
            return;
        }

        setLoading(true);
        try {
            const result = await archiveStudent(studentToDelete.id, deletionReason, deletionDetails);

            if (result.success) {
                alert('Aluno movido para o arquivo de excluídos com sucesso.');
                setIsDeleteModalOpen(false);
                setStudentToDelete(null);
                onRefresh();
            } else {
                alert('Erro ao excluir: ' + result.error);
            }
        } catch (error: any) {
            alert('Erro: ' + error.message);
        } finally {
            setLoading(false);
        }
    };

    const togglePDI = (need: string) => {
        setFormData(prev => {
            const exists = prev.pdi_needs.includes(need);
            return {
                ...prev,
                pdi_needs: exists
                    ? prev.pdi_needs.filter(n => n !== need)
                    : [...prev.pdi_needs, need]
            };
        });
    };

    // Helper to get class name
    const getClassName = (id?: string) => {
        if (!id) return '-';
        return availableClasses.find(c => c.id === id)?.name || 'Turma desconhecida';
    };

    return (
        <div className="space-y-6">
            {/* Header / Controls */}
            <div className="flex flex-col md:flex-row justify-between items-center gap-4 bg-white p-4 rounded-xl shadow-sm border border-slate-200">
                <div className="relative w-full md:w-96">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-slate-400" size={20} />
                    <input
                        type="text"
                        placeholder="Buscar por nome ou código..."
                        value={searchTerm}
                        onChange={e => setSearchTerm(e.target.value)}
                        className="w-full pl-10 pr-4 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-slate-400 outline-none"
                    />
                </div>
                <button
                    onClick={() => handleOpenModal()}
                    className="flex items-center gap-2 px-6 py-2 bg-green-600 text-white rounded-lg font-bold hover:bg-green-700 transition w-full md:w-auto justify-center"
                >
                    <Plus size={20} />
                    Novo Aluno
                </button>
            </div>

            {/* List View (Table) */}
            <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
                <table className="w-full text-left">
                    <thead className="bg-slate-50 border-b border-slate-200">
                        <tr>
                            <th className="px-6 py-4 font-bold text-slate-700">Nome Completo</th>
                            <th className="px-6 py-4 font-bold text-slate-700">Código</th>
                            <th className="px-6 py-4 font-bold text-slate-700">Turma</th>
                            <th className="px-6 py-4 font-bold text-slate-700 text-right">Ações</th>
                        </tr>
                    </thead>
                    <tbody className="divide-y divide-slate-100">
                        {filteredStudents.length === 0 ? (
                            <tr>
                                <td colSpan={4} className="px-6 py-12 text-center text-slate-500">
                                    Nenhum aluno encontrado.
                                </td>
                            </tr>
                        ) : (
                            filteredStudents.map(student => (
                                <tr key={student.id} className="hover:bg-slate-50 transition">
                                    <td className="px-6 py-4">
                                        <div className="font-bold text-slate-800">{student.name}</div>
                                        {student.pdi_needs && student.pdi_needs.length > 0 && (
                                            <div className="flex flex-wrap gap-1 mt-1">
                                                {student.pdi_needs.slice(0, 3).map(pdi => (
                                                    <span key={pdi} className="px-2 py-0.5 bg-amber-100 text-amber-800 text-[10px] font-bold rounded-full border border-amber-200">
                                                        {pdi}
                                                    </span>
                                                ))}
                                                {student.pdi_needs.length > 3 && (
                                                    <span className="text-[10px] text-slate-500 font-medium">+{student.pdi_needs.length - 3}</span>
                                                )}
                                            </div>
                                        )}
                                    </td>
                                    <td className="px-6 py-4 font-mono text-sm text-slate-600">
                                        {student.student_code || '-'}
                                    </td>
                                    <td className="px-6 py-4 text-sm text-slate-600">
                                        {getClassName(student.class_id)}
                                    </td>
                                    <td className="px-6 py-4 text-right space-x-2">
                                        <button
                                            onClick={() => setPdiStudentId(student.id)}
                                            className="inline-flex items-center justify-center p-2 text-indigo-600 hover:bg-indigo-50 rounded-lg transition"
                                            title="Prontuário PDI"
                                        >
                                            <span className="font-bold text-xs mr-1">PDI</span>
                                            <ClipboardList size={16} />
                                        </button>
                                        <button
                                            onClick={() => handleOpenModal(student)}
                                            className="inline-flex items-center justify-center p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition"
                                            title="Editar"
                                        >
                                            <Edit2 size={18} />
                                        </button>
                                        <button
                                            onClick={() => handleDeleteClick(student)}
                                            className="inline-flex items-center justify-center p-2 text-red-600 hover:bg-red-50 rounded-lg transition"
                                            title="Excluir"
                                        >
                                            <Trash2 size={18} />
                                        </button>
                                    </td>
                                </tr>
                            ))
                        )}
                    </tbody>
                </table>
            </div>

            {/* EDIT/CREATE MODAL */}
            {isModalOpen && (
                <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4 backdrop-blur-sm overflow-y-auto">
                    <div className="bg-white rounded-2xl shadow-2xl w-full max-w-2xl my-8 flex flex-col max-h-[90vh]">
                        {/* Modal Header */}
                        <div className="px-6 py-4 border-b border-slate-100 flex justify-between items-center sticky top-0 bg-white rounded-t-2xl z-10">
                            <h3 className="text-xl font-bold text-slate-800">
                                {editingStudent ? 'Editar Aluno' : 'Novo Aluno'}
                            </h3>
                            <button onClick={() => setIsModalOpen(false)} className="text-slate-400 hover:text-slate-600">
                                <X size={24} />
                            </button>
                        </div>

                        {/* Modal Content - Scrollable */}
                        <div className="p-6 space-y-6 overflow-y-auto">
                            {/* Basic Info */}
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div className="space-y-1">
                                    <label className="text-xs font-bold text-slate-500 uppercase">Nome Completo</label>
                                    <input
                                        type="text"
                                        value={formData.name}
                                        onChange={e => setFormData({ ...formData, name: e.target.value })}
                                        className="w-full px-3 py-2 border border-slate-300 rounded-lg font-medium focus:ring-2 focus:ring-green-500 outline-none"
                                        placeholder="Nome do Aluno"
                                    />
                                </div>
                                <div className="space-y-1">
                                    <label className="text-xs font-bold text-slate-500 uppercase">Código / Matrícula</label>
                                    <input
                                        type="text"
                                        value={formData.student_code}
                                        onChange={e => setFormData({ ...formData, student_code: e.target.value })}
                                        className="w-full px-3 py-2 border border-slate-300 rounded-lg font-mono text-sm focus:ring-2 focus:ring-green-500 outline-none"
                                        placeholder="Automático se vazio"
                                    />
                                </div>
                            </div>

                            {/* Class / Transfer */}
                            <div className="bg-slate-50 p-4 rounded-xl border border-slate-100">
                                <div className="flex items-center justify-between mb-2">
                                    <label className="text-xs font-bold text-slate-500 uppercase flex items-center gap-2">
                                        <Users size={14} /> Turma / Transferência
                                    </label>
                                    {editingStudent && formData.class_id && (
                                        <span className="text-[10px] bg-blue-100 text-blue-700 px-2 py-0.5 rounded font-bold">
                                            Transferência Rápida
                                        </span>
                                    )}
                                </div>
                                <select
                                    value={formData.class_id}
                                    onChange={e => setFormData({ ...formData, class_id: e.target.value })}
                                    className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-green-500 outline-none bg-white"
                                >
                                    <option value="">Selecione uma turma...</option>
                                    {/* Show all classes if no class selected, otherwise prioritize same year */}
                                    {availableClasses.map(cls => (
                                        <option key={cls.id} value={cls.id}>
                                            {cls.name} ({cls.year}º Ano)
                                        </option>
                                    ))}
                                </select>
                                <p className="text-xs text-slate-400 mt-1">
                                    Selecione a turma para vincular ou transferir o aluno.
                                </p>
                            </div>

                            {/* PDI Section */}
                            <div>
                                <label className="text-xs font-bold text-slate-500 uppercase flex items-center gap-2 mb-2">
                                    <AlertTriangle size={14} className="text-amber-500" />
                                    Necessidades Especiais (PDI)
                                </label>
                                <div className="grid grid-cols-2 md:grid-cols-3 gap-2">
                                    {PDI_OPTIONS.map(option => (
                                        <button
                                            key={option}
                                            onClick={() => togglePDI(option)}
                                            className={`text-left px-3 py-2 rounded-lg text-xs font-bold transition border ${formData.pdi_needs.includes(option)
                                                ? 'bg-amber-100 text-amber-800 border-amber-200'
                                                : 'bg-white text-slate-600 border-slate-200 hover:bg-slate-50'
                                                }`}
                                        >
                                            {formData.pdi_needs.includes(option) ? '✓ ' : ''}{option}
                                        </button>
                                    ))}
                                </div>
                            </div>

                            {/* Observations */}
                            <div className="space-y-1">
                                <label className="text-xs font-bold text-slate-500 uppercase">Observações Pedagógicas</label>
                                <textarea
                                    value={formData.observations}
                                    onChange={e => setFormData({ ...formData, observations: e.target.value })}
                                    rows={4}
                                    className="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-green-500 outline-none resize-none text-sm"
                                    placeholder="Informações importantes para os professores..."
                                />
                            </div>
                        </div>

                        {/* Footer */}
                        <div className="px-6 py-4 border-t border-slate-100 bg-slate-50 rounded-b-2xl flex justify-end gap-3 sticky bottom-0">
                            <button
                                onClick={() => setIsModalOpen(false)}
                                className="px-4 py-2 text-slate-600 font-bold hover:bg-slate-200 rounded-lg transition"
                            >
                                Cancelar
                            </button>
                            <button
                                onClick={handleSave}
                                disabled={loading}
                                className="px-6 py-2 bg-green-600 text-white font-bold rounded-lg hover:bg-green-700 transition flex items-center gap-2 disabled:opacity-50"
                            >
                                {loading ? 'Salvando...' : <><Save size={18} /> Salvar Aluno</>}
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* DELETE REASON MODAL */}
            {isDeleteModalOpen && studentToDelete && (
                <div className="fixed inset-0 bg-black/60 z-[60] flex items-center justify-center p-4 backdrop-blur-sm">
                    <div className="bg-white rounded-xl shadow-2xl w-full max-w-md p-6 animate-in fade-in zoom-in duration-200">
                        <div className="flex items-center gap-3 mb-4 text-red-600">
                            <div className="p-3 bg-red-100 rounded-full">
                                <Trash2 size={24} />
                            </div>
                            <h3 className="text-xl font-bold text-slate-800">Excluir Aluno</h3>
                        </div>

                        <p className="text-slate-600 mb-6">
                            Você está prestes a remover <strong>{studentToDelete.name}</strong>.
                            <br />Esta ação moverá o aluno para o arquivo morto.
                        </p>

                        <div className="space-y-4 mb-6">
                            <div>
                                <label className="block text-xs font-bold text-slate-500 uppercase mb-1">Motivo da Exclusão</label>
                                <select
                                    value={deletionReason}
                                    onChange={e => setDeletionReason(e.target.value)}
                                    className="w-full px-3 py-2 border border-slate-300 rounded-lg font-medium outline-none focus:ring-2 focus:ring-red-500"
                                >
                                    {DELETION_REASONS.map(r => (
                                        <option key={r} value={r}>{r}</option>
                                    ))}
                                </select>
                            </div>

                            {/* Show details only if 'Outro' */}
                            {deletionReason === 'Outro' && (
                                <div>
                                    <label className="block text-xs font-bold text-slate-500 uppercase mb-1">Detalhes</label>
                                    <textarea
                                        value={deletionDetails}
                                        onChange={e => setDeletionDetails(e.target.value)}
                                        placeholder="Descreva o motivo..."
                                        className="w-full px-3 py-2 border border-slate-300 rounded-lg text-sm resize-none outline-none focus:ring-2 focus:ring-red-500"
                                        rows={2}
                                    />
                                </div>
                            )}
                        </div>

                        <div className="flex justify-end gap-3">
                            <button
                                onClick={() => setIsDeleteModalOpen(false)}
                                className="px-4 py-2 text-slate-600 font-bold hover:bg-slate-100 rounded-lg transition"
                            >
                                Cancelar
                            </button>
                            <button
                                onClick={confirmDelete}
                                disabled={loading}
                                className="px-4 py-2 bg-red-600 text-white font-bold rounded-lg hover:bg-red-700 transition"
                            >
                                {loading ? 'Excluindo...' : 'Confirmar Exclusão'}
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* PDI Integration Modal */}
            {pdiStudentId && (
                <div className="fixed inset-0 z-[100] bg-slate-900/50 backdrop-blur-sm flex items-center justify-center p-4">
                    <div className="bg-white rounded-2xl shadow-2xl w-full max-w-5xl max-h-[90vh] overflow-hidden flex flex-col animate-in fade-in zoom-in duration-200">
                        <StudentPDIProfile
                            studentId={pdiStudentId}
                            onClose={() => setPdiStudentId(null)}
                        />
                    </div>
                </div>
            )}
        </div>
    );
};

export default StudentManagement;
