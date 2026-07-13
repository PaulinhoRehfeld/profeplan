import React, { useState } from 'react';
import { X, BrainCircuit, Loader2, Save } from 'lucide-react';
import { Student } from '../../types';

interface StudentPdiDrawerProps {
  isOpen: boolean;
  student: Student | null;
  onClose: () => void;
  onSave: (updatedStudent: Student) => Promise<void>;
}

const StudentPdiDrawer: React.FC<StudentPdiDrawerProps> = ({
  isOpen,
  student,
  onClose,
  onSave,
}) => {
  const [editingStudent, setEditingStudent] = useState<Student | null>(student);
  const [isSaving, setIsSaving] = useState(false);

  // Update local state when prop changes
  React.useEffect(() => {
    setEditingStudent(student);
  }, [student]);

  if (!isOpen || !editingStudent) return null;

  const handleSave = async () => {
    setIsSaving(true);
    try {
      await onSave(editingStudent);
    } finally {
      setIsSaving(false);
    }
  };

  const toggleDeficiency = (tag: string) => {
    const current = editingStudent.deficiencies || [];
    const updated = current.includes(tag) ? current.filter((t) => t !== tag) : [...current, tag];
    setEditingStudent({ ...editingStudent, deficiencies: updated });
  };

  const AVAILABLE_TAGS = [
    'TDAH',
    'Autismo',
    'Dislexia',
    'Baixa Visão',
    'Deficiência Auditiva',
    'Superdotação',
    'Discalculia',
    'Ansiedade',
    'Mobilidade Reduzida',
  ];

  return (
    <div className="w-full md:w-96 border-l border-slate-100 bg-white md:h-auto overflow-y-auto animate-in slide-in-from-right duration-300 p-8 shadow-2xl relative z-20">
      <div className="flex items-center justify-between mb-8">
        <h3 className="text-sm font-black text-slate-900 uppercase tracking-tight">
          Memória Pedagógica
        </h3>
        <button onClick={onClose} className="p-2 hover:bg-slate-50 rounded-lg text-slate-400">
          <X size={18} />
        </button>
      </div>

      <div className="space-y-8">
        <div className="p-4 bg-slate-50 rounded-2xl border border-slate-100">
          <h4 className="text-lg font-black text-slate-900 mb-1">{editingStudent.name}</h4>
          <p className="text-[10px] font-bold text-slate-400 uppercase tracking-widest">
            Perfil Individual do Aluno
          </p>
        </div>

        {/* Needs Adaptation Switch */}
        <div className="flex items-center justify-between p-4 bg-purple-50 rounded-2xl border border-purple-100">
          <div className="flex items-center gap-3">
            <div
              className={`w-10 h-10 rounded-xl flex items-center justify-center ${editingStudent.needs_adaptation ? 'bg-purple-600 text-white' : 'bg-white text-purple-300'}`}
            >
              <BrainCircuit size={20} />
            </div>
            <div>
              <p className="text-xs font-black text-purple-900 uppercase tracking-tight">
                Necessita Adaptação?
              </p>
              <p className="text-[9px] font-bold text-purple-400 uppercase tracking-widest">
                Ativa recursos de IA (PDI/DUA)
              </p>
            </div>
          </div>
          <button
            onClick={() =>
              setEditingStudent({
                ...editingStudent,
                needs_adaptation: !editingStudent.needs_adaptation,
              })
            }
            className={`w-12 h-6 rounded-full transition-colors relative ${editingStudent.needs_adaptation ? 'bg-purple-600' : 'bg-slate-200'}`}
          >
            <div
              className={`absolute top-1 left-1 w-4 h-4 bg-white rounded-full transition-transform ${editingStudent.needs_adaptation ? 'translate-x-6' : ''}`}
            ></div>
          </button>
        </div>

        {/* Tags */}
        <div>
          <label className="text-[9px] font-black text-slate-400 uppercase tracking-[0.3em] mb-3 block">
            Diagnósticos / Tags
          </label>
          <div className="flex flex-wrap gap-2">
            {AVAILABLE_TAGS.map((tag) => (
              <button
                key={tag}
                onClick={() => toggleDeficiency(tag)}
                className={`px-3 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all ${
                  editingStudent.deficiencies?.includes(tag)
                    ? 'bg-slate-900 text-white shadow-lg shadow-slate-200'
                    : 'bg-slate-50 text-slate-400 hover:bg-slate-100'
                }`}
              >
                {tag}
              </button>
            ))}
          </div>
        </div>

        {/* Observations */}
        <div>
          <label className="text-[9px] font-black text-slate-400 uppercase tracking-[0.3em] mb-3 block">
            Observações Pedagógicas
          </label>
          <p className="text-[10px] text-slate-400 mb-2">
            Detalhe o que funciona melhor para este aluno.
          </p>
          <textarea
            value={editingStudent.pedagogical_observations || ''}
            onChange={(e) =>
              setEditingStudent({ ...editingStudent, pedagogical_observations: e.target.value })
            }
            placeholder="Ex: Aluno responde bem a estímulos visuais, evitar textos longos sem quebra..."
            className="w-full h-32 px-5 py-4 bg-slate-50 border border-slate-100 rounded-2xl text-xs font-medium outline-none focus:ring-2 focus:ring-blue-100 focus:bg-white transition-all resize-none"
          ></textarea>
        </div>

        <button
          onClick={handleSave}
          disabled={isSaving}
          className="w-full py-4 bg-blue-600 text-white rounded-2xl font-black text-xs uppercase tracking-widest shadow-xl shadow-blue-200 hover:bg-blue-700 active:scale-95 transition-all flex items-center justify-center gap-2"
        >
          {isSaving ? <Loader2 size={18} className="animate-spin" /> : <Save size={18} />}
          Salvar Alterações
        </button>
      </div>
    </div>
  );
};

export default StudentPdiDrawer;
