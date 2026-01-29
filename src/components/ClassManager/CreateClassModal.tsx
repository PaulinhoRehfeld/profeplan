import React, { useState } from 'react';
import { Loader2, Plus, X, Link as LinkIcon, Save } from 'lucide-react';
import SchoolStudentSelector from '../SchoolStudentSelector';

interface CreateClassModalProps {
    onClose: () => void;
    onSave: (data: { name: string, subject: string, students: string[] }) => Promise<void>;
}

const CreateClassModal: React.FC<CreateClassModalProps> = ({ onClose, onSave }) => {
    const [manualName, setManualName] = useState('');
    const [manualSubject, setManualSubject] = useState('');
    const [manualStudents, setManualStudents] = useState('');
    const [isSavingManual, setIsSavingManual] = useState(false);
    const [isSchoolImportOpen, setIsSchoolImportOpen] = useState(false);
    const [error, setError] = useState('');

    const handleManualCreate = async () => {
        if (!manualName || !manualSubject) {
            setError('Nome da turma e disciplina são obrigatórios.');
            return;
        }

        const studentList = manualStudents
            .split(/\n|,/) // Split by newline or comma
            .map(s => s.trim())
            .filter(s => s.length > 0);

        if (studentList.length === 0) {
            setError('Adicione pelo menos um aluno.');
            return;
        }

        setIsSavingManual(true);
        setError('');

        try {
            await onSave({
                name: manualName,
                subject: manualSubject,
                students: studentList
            });
            onClose();
        } catch (err: any) {
            console.error(err);
            setError('Erro ao criar turma: ' + err.message);
        } finally {
            setIsSavingManual(false);
        }
    };

    return (
        <div className="fixed inset-0 bg-slate-950/80 backdrop-blur-sm z-[9999] flex items-center justify-center p-4 overflow-y-auto" onClick={onClose}>
            <div className="bg-white rounded-[2rem] w-full max-w-lg p-8 shadow-2xl relative" onClick={e => e.stopPropagation()}>
                <button onClick={onClose} className="absolute top-6 right-6 p-2 hover:bg-slate-50 rounded-full text-slate-400 transition-colors">
                    <X size={20} />
                </button>

                <h3 className="text-xl font-black text-slate-900 uppercase italic mb-6">Nova Turma Manual</h3>

                <div className="space-y-4">
                    {/* SCHOOL IMPORT BUTTON */}
                    <div className="mb-4">
                        <button
                            onClick={() => setIsSchoolImportOpen(true)}
                            className="w-full py-3 bg-indigo-50 border-2 border-dashed border-indigo-200 text-indigo-700 rounded-xl font-black text-xs uppercase tracking-widest hover:bg-indigo-100 transition-all flex items-center justify-center gap-2"
                        >
                            <LinkIcon size={16} /> Importar da Escola
                        </button>
                        <p className="text-[9px] text-center text-indigo-400 mt-2 font-bold uppercase tracking-wide">Busque alunos já cadastrados na sua instituição</p>
                    </div>

                    <div className="relative flex py-2 items-center">
                        <div className="flex-grow border-t border-slate-100"></div>
                        <span className="flex-shrink-0 mx-4 text-xs font-bold text-slate-300 uppercase">OU Digite Manualmente</span>
                        <div className="flex-grow border-t border-slate-100"></div>
                    </div>

                    {error && (
                        <div className="p-3 bg-red-50 text-red-600 text-xs rounded-lg font-bold border border-red-100">
                            {error}
                        </div>
                    )}

                    <div>
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-1 block">Nome da Turma</label>
                        <input
                            type="text"
                            value={manualName}
                            onChange={e => setManualName(e.target.value)}
                            placeholder="Ex: 3º Ano B - Ensino Médio"
                            className="w-full bg-slate-50 border border-slate-100 rounded-xl px-4 py-3 font-bold text-slate-900 outline-none focus:border-blue-500 transition-colors"
                        />
                    </div>
                    <div>
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-1 block">Disciplina</label>
                        <input
                            type="text"
                            value={manualSubject}
                            onChange={e => setManualSubject(e.target.value)}
                            placeholder="Ex: História"
                            className="w-full bg-slate-50 border border-slate-100 rounded-xl px-4 py-3 font-bold text-slate-900 outline-none focus:border-blue-500 transition-colors"
                        />
                    </div>
                    <div>
                        <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-1 block">Lista de Alunos</label>
                        <p className="text-[10px] text-slate-400 mb-2">Cole os nomes abaixo (um por linha ou separados por vírgula).</p>
                        <textarea
                            value={manualStudents}
                            onChange={e => setManualStudents(e.target.value)}
                            placeholder="João da Silva&#10;Maria Oliveira&#10;Pedro Santos..."
                            className="w-full h-40 bg-slate-50 border border-slate-100 rounded-xl px-4 py-3 font-medium text-slate-900 outline-none focus:border-blue-500 transition-colors resize-none text-sm"
                        ></textarea>
                    </div>

                    <button
                        onClick={handleManualCreate}
                        disabled={isSavingManual}
                        className="w-full py-4 bg-blue-600 hover:bg-blue-700 text-white rounded-xl font-black text-xs uppercase tracking-widest shadow-lg shadow-blue-200 transition-all flex items-center justify-center gap-2 mt-4"
                    >
                        {isSavingManual ? <Loader2 className="animate-spin" size={18} /> : <Save size={18} />}
                        Salvar Turma
                    </button>
                </div>
            </div>

            {/* SCHOOL IMPORT MODAL OVERLAY */}
            {isSchoolImportOpen && (
                <div className="fixed inset-0 bg-slate-950/80 backdrop-blur-sm z-[10000] flex items-center justify-center p-4">
                    <div className="w-full max-w-lg h-[600px] bg-white rounded-3xl overflow-hidden relative" onClick={e => e.stopPropagation()}>
                        <SchoolStudentSelector
                            onCancel={() => setIsSchoolImportOpen(false)}
                            onImport={(students) => {
                                const currentText = manualStudents ? manualStudents + '\n' : '';
                                setManualStudents(currentText + students.join('\n'));
                                setIsSchoolImportOpen(false);
                            }}
                        />
                    </div>
                </div>
            )}
        </div>
    );
};

export default CreateClassModal;
