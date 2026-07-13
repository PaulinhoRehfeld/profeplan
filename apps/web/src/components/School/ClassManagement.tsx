import React, { useState, useEffect } from 'react';
import {
  Plus,
  Upload,
  BookOpen,
  Users,
  ChevronRight,
  Edit2,
  Trash2,
  ArrowRightLeft,
  X,
  Save,
  AlertTriangle,
} from 'lucide-react';
import { Class } from '../../types';
import { StudentPDIProfile } from './PDI/StudentPDIProfile';

// Local extension for ClassManagement-specific needs
interface LocalClass extends Class {
  student_count?: number;
  students?: any[];
}

interface ClassManagementProps {
  schoolId: string;
  userId: string;
  classes: LocalClass[];
  onRefresh: () => void;
}

export const ClassManagement: React.FC<ClassManagementProps> = ({
  schoolId,
  userId,
  classes,
  onRefresh,
}) => {
  const [selectedClass, setSelectedClass] = useState<Class | null>(null);
  const [isAddingClass, setIsAddingClass] = useState(false);

  // Edit/Merge State
  const [editingClass, setEditingClass] = useState<Class | null>(null);
  const [isEditModalOpen, setIsEditModalOpen] = useState(false);
  const [mergeTargetId, setMergeTargetId] = useState<string>('');
  const [activeEditTab, setActiveEditTab] = useState<'details' | 'merge'>('details');

  // Form State
  const [formData, setFormData] = useState({
    name: '',
    grade: '',
    shift: 'Matutino',
    room: '',
    year: new Date().getFullYear(),
  });

  const [isSubmitting, setIsSubmitting] = useState(false);

  // Refresh class details when needed
  useEffect(() => {
    if (selectedClass) {
      loadClassDetails(selectedClass.id);
    }
  }, [selectedClass?.id]);

  const loadClassDetails = async (classId: string) => {
    const { getClassDetails } = await import('../../services/supabaseService');
    const { data } = await getClassDetails(classId);
    if (data) {
      setSelectedClass((prev) => ({ ...prev!, students: data.students }));
    }
  };

  // --- Actions ---

  const openEditModal = (cls: Class, e: React.MouseEvent) => {
    e.stopPropagation();
    setEditingClass(cls);
    setFormData({
      name: cls.name,
      grade: cls.grade || '',
      shift: cls.shift || 'Matutino',
      room: cls.room || '',
      year: cls.year || new Date().getFullYear(),
    });
    setMergeTargetId('');
    setActiveEditTab('details');
    setIsEditModalOpen(true);
  };

  const handleCreateClass = async () => {
    if (!formData.name.trim()) return alert('Nome da turma é obrigatório');

    setIsSubmitting(true);
    try {
      const { createClass } = await import('../../services/classService');
      const result = await createClass({
        school_id: schoolId,
        name: formData.name,
        grade: formData.grade || undefined,
        shift: formData.shift,
        room: formData.room || undefined,
        year: formData.year,
      });

      if (result.success) {
        alert('Turma criada!');
        setIsAddingClass(false);
        resetForm();
        onRefresh();
      } else {
        alert('Erro: ' + result.error);
      }
    } catch (e: any) {
      alert('Erro: ' + e.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleUpdateClass = async () => {
    if (!editingClass) return;
    setIsSubmitting(true);
    try {
      const { updateClass } = await import('../../services/classService');
      const result = await updateClass(editingClass.id, {
        name: formData.name,
        grade: formData.grade || undefined,
        shift: formData.shift,
        room: formData.room || undefined,
        year: formData.year,
      });

      if (result.success) {
        alert('Turma atualizada!');
        setIsEditModalOpen(false);
        onRefresh();
      } else {
        alert('Erro: ' + result.error);
      }
    } catch (e: any) {
      alert('Erro: ' + e.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleMergeClasses = async () => {
    if (!editingClass || !mergeTargetId) return alert('Selecione uma turma de destino');

    if (
      !confirm(
        `Tem certeza? Todos os alunos de "${editingClass.name}" serão movidos para a turma de destino, e "${editingClass.name}" será excluída.`
      )
    )
      return;

    setIsSubmitting(true);
    try {
      const { mergeClasses } = await import('../../services/classService');
      const result = await mergeClasses(editingClass.id, mergeTargetId); // Source, Target

      if (result.success) {
        alert(result.message || 'Turmas unificadas com sucesso!');
        setIsEditModalOpen(false);
        onRefresh();
      } else {
        alert('Erro na unificação: ' + result.error);
      }
    } catch (e: any) {
      alert('Erro: ' + e.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleDeleteClass = async () => {
    if (!editingClass) return;

    // Prevent delete if has students (safety check, though DB might allow if cascade isn't set, better to warn)
    if ((editingClass as any).student_count && (editingClass as any).student_count > 0) {
      return alert(
        'Não é possível excluir uma turma com alunos. Remova os alunos ou use a opção "Unificar" primeiro.'
      );
    }

    if (!confirm(`Excluir a turma "${editingClass.name}" permanentemente?`)) return;

    setIsSubmitting(true);
    try {
      const { deleteClass } = await import('../../services/classService');
      const result = await deleteClass(editingClass.id);

      if (result.success) {
        alert('Turma excluída.');
        setIsEditModalOpen(false);
        onRefresh();
      } else {
        alert('Erro: ' + result.error);
      }
    } catch (e: any) {
      alert('Erro: ' + e.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  const resetForm = () => {
    setFormData({
      name: '',
      grade: '',
      shift: 'Matutino',
      room: '',
      year: new Date().getFullYear(),
    });
  };

  // --- Sub-components (Student List Logic remains mostly same but compacted) ---
  // [Previously existing logic for Student Management inside Class View handles adding students]
  // Putting it here briefly for full component context

  // ... (Student logic from previous file)
  const [isAddingStudent, setIsAddingStudent] = useState(false);
  const [newStudentName, setNewStudentName] = useState('');
  const [newStudentCode, setNewStudentCode] = useState('');
  const [editingStudent, setEditingStudent] = useState<any | null>(null);

  const handleAddStudent = async () => {
    if (!newStudentName.trim()) return alert('Nome é obrigatório');
    try {
      const { addStudentToClass } = await import('../../services/supabaseService');
      await addStudentToClass(selectedClass!.id, newStudentName, newStudentCode, schoolId);
      alert('Aluno adicionado!');
      setIsAddingStudent(false);
      setNewStudentName('');
      setNewStudentCode('');
      loadClassDetails(selectedClass!.id); // reload
    } catch (e: any) {
      alert('Erro: ' + e.message);
    }
  };

  const handleTogglePdi = async (studentId: string, currentDeficiencies: string[], tag: string) => {
    const hasTag = currentDeficiencies?.includes(tag);
    const newDeficiencies = hasTag
      ? currentDeficiencies.filter((d) => d !== tag)
      : [...(currentDeficiencies || []), tag];

    // Optimistic UI update
    if (selectedClass) {
      const updatedStudents = selectedClass.students?.map((s: any) =>
        s.id === studentId ? { ...s, deficiencies: newDeficiencies } : s
      );
      setSelectedClass({ ...selectedClass, students: updatedStudents });
    }

    const { updateStudent } = await import('../../services/supabaseService');
    await updateStudent(studentId, { deficiencies: newDeficiencies });
  };

  // --- RENDER ---

  if (selectedClass) {
    // ... (Code for Detailed Class View - Same as existing but compacted)
    // Returning simpler version for brevity, assuming previous logic holds
    return (
      <div className="space-y-6 animate-in fade-in slide-in-from-right-4 duration-300">
        <div className="flex items-center gap-4 mb-6">
          <button
            onClick={() => setSelectedClass(null)}
            className="p-2 hover:bg-slate-100 rounded-full transition-colors"
          >
            <ChevronRight className="rotate-180" />
          </button>
          <div>
            <h2 className="text-xl font-bold text-slate-800">{selectedClass.name}</h2>
            <p className="text-sm text-slate-500">
              {selectedClass.students?.length || 0} Alunos •{' '}
              {selectedClass.shift || 'Turno não def.'}
            </p>
          </div>
          <div className="ml-auto flex gap-2">
            <button
              onClick={(e) => {
                setSelectedClass(null);
                openEditModal(selectedClass, e);
              }}
              className="bg-slate-100 text-slate-700 px-3 py-2 rounded-lg text-sm font-bold hover:bg-slate-200"
            >
              <Edit2 size={16} />
            </button>
            <button
              onClick={() => setIsAddingStudent(true)}
              className="bg-blue-600 text-white px-4 py-2 rounded-lg text-sm font-bold hover:bg-blue-700 flex items-center gap-2"
            >
              <Plus size={16} /> Adicionar Aluno
            </button>
          </div>
        </div>

        {/* Students Table */}
        <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
          <table className="w-full text-left">
            <thead className="bg-slate-50 border-b border-slate-200">
              <tr>
                <th className="px-6 py-3 text-xs font-bold text-slate-500 uppercase">Cód.</th>
                <th className="px-6 py-3 text-xs font-bold text-slate-500 uppercase">Nome</th>
                <th className="px-6 py-3 text-xs font-bold text-slate-500 uppercase text-right">
                  Ações
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-100">
              {selectedClass.students?.map((student: any) => (
                <tr key={student.id} className="hover:bg-slate-50">
                  <td className="px-6 py-4 text-xs font-mono text-slate-400">
                    {student.student_code || '-'}
                  </td>
                  <td className="px-6 py-4 font-bold text-slate-700">
                    {student.name}
                    {/* Look in pdi_data.deficiencies as fallback */}
                    {(student.deficiencies?.length > 0 ||
                      student.pdi_data?.deficiencies?.length > 0) && (
                      <span className="ml-2 px-2 py-0.5 bg-purple-100 text-purple-700 text-[10px] font-bold rounded">
                        PDI
                      </span>
                    )}
                  </td>
                  <td className="px-6 py-4 text-right">
                    <button
                      onClick={() => {
                        // Open student profile editor
                        setEditingStudent(student);
                      }}
                      className="px-3 py-1.5 bg-slate-100 hover:bg-slate-200 text-slate-700 text-xs font-bold rounded-lg transition flex items-center gap-1 ml-auto"
                    >
                      <Edit2 size={12} /> Editar
                    </button>
                  </td>
                </tr>
              ))}
              {(!selectedClass.students || selectedClass.students.length === 0) && (
                <tr>
                  <td colSpan={3} className="px-6 py-8 text-center text-slate-400">
                    Nenhum aluno.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>

        {/* Add Student Modal */}
        {isAddingStudent && (
          <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-[50] p-4">
            <div className="bg-white rounded-xl shadow-xl max-w-sm w-full p-6">
              <h3 className="font-bold text-lg mb-4">Novo Aluno</h3>
              <input
                className="w-full border p-2 rounded mb-2"
                placeholder="Nome"
                value={newStudentName}
                onChange={(e) => setNewStudentName(e.target.value)}
              />
              <input
                className="w-full border p-2 rounded mb-4"
                placeholder="Código"
                value={newStudentCode}
                onChange={(e) => setNewStudentCode(e.target.value)}
              />
              <div className="flex gap-2">
                <button
                  onClick={() => setIsAddingStudent(false)}
                  className="flex-1 py-2 border rounded"
                >
                  Cancelar
                </button>
                <button
                  onClick={handleAddStudent}
                  className="flex-1 py-2 bg-blue-600 text-white rounded"
                >
                  Salvar
                </button>
              </div>
            </div>
          </div>
        )}

        {/* Edit Student PDI Profile Modal */}
        {editingStudent && (
          <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-[60] p-4 backdrop-blur-sm">
            <div className="bg-white rounded-xl shadow-2xl w-full max-w-5xl h-[90vh] overflow-hidden flex flex-col relative">
              {/* Close button handled inside component or via overlay click if implemented, 
                                but component has its own header. wrapping in relative div.
                            */}
              <StudentPDIProfile
                studentId={editingStudent.id}
                onClose={() => {
                  setEditingStudent(null);
                  // Refresh the list to show any name changes or updates
                  loadClassDetails(selectedClass.id);
                }}
              />
            </div>
          </div>
        )}
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <h2 className="text-lg font-bold text-slate-800">Turmas</h2>
        <button
          onClick={() => {
            resetForm();
            setIsAddingClass(true);
          }}
          className="flex items-center gap-2 px-4 py-2 bg-purple-600 text-white rounded-lg text-sm font-bold hover:bg-purple-700 transition"
        >
          <Plus size={16} /> Nova Turma
        </button>
      </div>

      {/* Classes List */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {classes.length === 0 ? (
          <div className="col-span-full bg-white rounded-xl shadow-sm border border-slate-200 p-12 text-center">
            <BookOpen className="w-12 h-12 text-slate-300 mx-auto mb-4" />
            <p className="text-slate-400 text-sm">Nenhuma turma cadastrada.</p>
          </div>
        ) : (
          classes.map((classItem) => (
            <div
              key={classItem.id}
              className="bg-white rounded-xl shadow-sm border border-slate-200 p-6 hover:shadow-md transition cursor-pointer relative group"
              onClick={() => setSelectedClass(classItem)}
            >
              <div className="absolute top-4 right-4 opacity-0 group-hover:opacity-100 transition-opacity">
                <button
                  onClick={(e) => openEditModal(classItem, e)}
                  className="p-2 bg-slate-100 hover:bg-slate-200 text-slate-600 rounded-lg"
                >
                  <Edit2 size={16} />
                </button>
              </div>

              <div className="flex items-start justify-between mb-4">
                <div>
                  <h3 className="text-lg font-bold text-slate-800">{classItem.name}</h3>
                  <p className="text-sm text-slate-500">{classItem.grade || 'Série não def.'}</p>
                </div>
                <div className="p-2 bg-purple-100 rounded-lg">
                  <BookOpen className="w-5 h-5 text-purple-600" />
                </div>
              </div>
              <div className="space-y-2 text-sm text-slate-600">
                <p className="flex items-center gap-2">
                  <span className="w-2 h-2 bg-purple-400 rounded-full"></span>{' '}
                  {classItem.shift || 'Turno não def.'}
                </p>
                <p className="flex items-center gap-2">
                  <span className="w-2 h-2 bg-purple-400 rounded-full"></span> Sala{' '}
                  {classItem.room || '-'}
                </p>
              </div>
              <div className="mt-4 pt-4 border-t border-slate-100 flex items-center gap-2 text-sm text-slate-500">
                <Users size={16} /> {(classItem as any).student_count || 0} alunos
              </div>
            </div>
          ))
        )}
      </div>

      {/* ADD / EDIT MODAL */}
      {(isAddingClass || isEditModalOpen) && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4 backdrop-blur-sm">
          <div className="bg-white rounded-xl shadow-xl max-w-lg w-full overflow-hidden">
            <div className="px-6 py-4 border-b border-slate-100 flex justify-between items-center bg-slate-50">
              <h3 className="text-lg font-bold text-slate-800">
                {isEditModalOpen ? 'Gerenciar Turma' : 'Nova Turma'}
              </h3>
              <button
                onClick={() => {
                  setIsAddingClass(false);
                  setIsEditModalOpen(false);
                }}
                className="text-slate-400 hover:text-slate-600"
              >
                <X size={20} />
              </button>
            </div>

            {/* Edit Tabs (Only if Editing) */}
            {isEditModalOpen && (
              <div className="flex border-b border-slate-100">
                <button
                  onClick={() => setActiveEditTab('details')}
                  className={`flex-1 py-3 text-sm font-bold border-b-2 transition ${activeEditTab === 'details' ? 'border-purple-600 text-purple-700' : 'border-transparent text-slate-500 hover:bg-slate-50'}`}
                >
                  Detalhes
                </button>
                <button
                  onClick={() => setActiveEditTab('merge')}
                  className={`flex-1 py-3 text-sm font-bold border-b-2 transition ${activeEditTab === 'merge' ? 'border-amber-500 text-amber-700' : 'border-transparent text-slate-500 hover:bg-slate-50'}`}
                >
                  Unificar / Mesclar
                </button>
              </div>
            )}

            <div className="p-6">
              {/* TAB: DETAILS */}
              {(activeEditTab === 'details' || isAddingClass) && (
                <div className="space-y-4">
                  <div className="grid grid-cols-2 gap-4">
                    <div className="space-y-1">
                      <label className="text-xs font-bold text-slate-500 uppercase">Nome *</label>
                      <input
                        type="text"
                        value={formData.name}
                        onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                        className="w-full border p-2 rounded-lg"
                        placeholder="Ex: 3º A"
                      />
                    </div>
                    <div className="space-y-1">
                      <label className="text-xs font-bold text-slate-500 uppercase">Série</label>
                      <input
                        type="text"
                        value={formData.grade}
                        onChange={(e) => setFormData({ ...formData, grade: e.target.value })}
                        className="w-full border p-2 rounded-lg"
                        placeholder="Ex: 3º Ano"
                      />
                    </div>
                  </div>
                  <div className="grid grid-cols-2 gap-4">
                    <div className="space-y-1">
                      <label className="text-xs font-bold text-slate-500 uppercase">Turno</label>
                      <select
                        value={formData.shift}
                        onChange={(e) => setFormData({ ...formData, shift: e.target.value })}
                        className="w-full border p-2 rounded-lg bg-white"
                      >
                        <option>Matutino</option>
                        <option>Vespertino</option>
                        <option>Noturno</option>
                        <option>Integral</option>
                      </select>
                    </div>
                    <div className="space-y-1">
                      <label className="text-xs font-bold text-slate-500 uppercase">Sala</label>
                      <input
                        type="text"
                        value={formData.room}
                        onChange={(e) => setFormData({ ...formData, room: e.target.value })}
                        className="w-full border p-2 rounded-lg"
                        placeholder="101"
                      />
                    </div>
                  </div>

                  <div className="flex gap-3 mt-6 pt-4 border-t border-slate-100">
                    {isEditModalOpen && (
                      <button
                        onClick={handleDeleteClass}
                        type="button"
                        className="px-4 py-2 text-red-600 font-bold hover:bg-red-50 rounded-lg flex items-center gap-2 mr-auto"
                      >
                        <Trash2 size={16} /> Excluir
                      </button>
                    )}
                    <button
                      onClick={() => {
                        setIsAddingClass(false);
                        setIsEditModalOpen(false);
                      }}
                      className="px-4 py-2 text-slate-600 hover:bg-slate-100 rounded-lg font-bold"
                    >
                      Cancelar
                    </button>
                    <button
                      onClick={isEditModalOpen ? handleUpdateClass : handleCreateClass}
                      disabled={isSubmitting}
                      className="px-6 py-2 bg-purple-600 text-white rounded-lg font-bold hover:bg-purple-700"
                    >
                      {isSubmitting ? 'Salvando...' : 'Salvar'}
                    </button>
                  </div>
                </div>
              )}

              {/* TAB: MERGE */}
              {activeEditTab === 'merge' && isEditModalOpen && editingClass && (
                <div className="space-y-4 animate-in fade-in slide-in-from-right-2">
                  <div className="bg-amber-50 border border-amber-200 rounded-lg p-4 flex items-start gap-3">
                    <AlertTriangle className="text-amber-600 shrink-0 mt-0.5" size={20} />
                    <div>
                      <h4 className="font-bold text-amber-800 text-sm">
                        Atenção: Ação Irreversível
                      </h4>
                      <p className="text-xs text-amber-700 mt-1">
                        Esta ação moverá <strong>todos os alunos</strong> de{' '}
                        <u>{editingClass.name}</u> para a turma destino. A turma{' '}
                        <u>{editingClass.name}</u> será apagada permanentemente.
                      </p>
                    </div>
                  </div>

                  <div className="flex items-center gap-4 justify-center py-4 text-slate-400">
                    <div className="text-center">
                      <div className="font-bold text-slate-800 text-lg">{editingClass.name}</div>
                      <div className="text-xs">Origem</div>
                    </div>
                    <ArrowRightLeft className="text-slate-300" />
                    <div className="text-center w-40">
                      <select
                        value={mergeTargetId}
                        onChange={(e) => setMergeTargetId(e.target.value)}
                        className="w-full p-2 border border-blue-300 rounded font-bold text-blue-800 text-center outline-none focus:ring-2 focus:ring-blue-500"
                      >
                        <option value="">Selecione...</option>
                        {classes
                          .filter((c) => c.id !== editingClass.id)
                          .map((c) => (
                            <option key={c.id} value={c.id}>
                              {c.name}
                            </option>
                          ))}
                      </select>
                      <div className="text-xs mt-1 text-slate-500">Destino</div>
                    </div>
                  </div>

                  <div className="flex justify-end gap-3 mt-6 pt-4 border-t border-slate-100">
                    <button
                      onClick={() => setIsEditModalOpen(false)}
                      className="px-4 py-2 text-slate-600 hover:bg-slate-100 rounded-lg font-bold"
                    >
                      Cancelar
                    </button>
                    <button
                      onClick={handleMergeClasses}
                      disabled={!mergeTargetId || isSubmitting}
                      className="px-6 py-2 bg-amber-600 text-white rounded-lg font-bold hover:bg-amber-700 disabled:opacity-50 flex items-center gap-2"
                    >
                      <ArrowRightLeft size={16} /> Unificar Turmas
                    </button>
                  </div>
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ClassManagement;
