import React, { useState } from 'react';
import { supabase } from '../services/supabaseClient';
import { X, Upload, Loader2, Save, CheckSquare, Square, FileText, GraduationCap } from 'lucide-react';
import { parseClassListFromText } from '../services/ai/AiUtilityService';

interface ClassBatchImportModalProps {
    isOpen: boolean;
    onClose: () => void;
    onSuccess: () => void;
    schoolId: string;
    userId: string; // The supervisor creating the class
}

interface ParsedStudent {
    name: string;
    needsPdi: boolean;
}

const ClassBatchImportModal: React.FC<ClassBatchImportModalProps> = ({ isOpen, onClose, onSuccess, schoolId, userId }) => {
    const [step, setStep] = useState<'upload' | 'review' | 'saving'>('upload');
    const [className, setClassName] = useState('');
    const [subject, setSubject] = useState('');
    const [modalStudents, setModalStudents] = useState<ParsedStudent[]>([]);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');

    const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (!file) return;

        setLoading(true);
        setError('');

        try {
            let text = '';
            if (file.type === 'application/pdf') {
                const { extractTextFromPdf } = await import('../services/pdfService');
                text = await extractTextFromPdf(file);
            } else {
                text = await file.text();
            }

            const parsed = await parseClassListFromText(text);

            if (parsed.className && !className) setClassName(parsed.className);
            if (parsed.subject && !subject) setSubject(parsed.subject);

            setModalStudents(parsed.students.map((s: any) => ({ name: typeof s === 'object' ? s.name || 'Sem Nome' : s, needsPdi: false })));
            setStep('review');
        } catch (err: any) {
            console.error(err);
            setError('Erro ao ler arquivo: ' + err.message);
        } finally {
            setLoading(false);
        }
    };

    const togglePdi = (index: number) => {
        const updated = [...modalStudents];
        updated[index].needsPdi = !updated[index].needsPdi;
        setModalStudents(updated);
    };

    const handleConfirmImport = async () => {
        if (!className || modalStudents.length === 0) {
            setError('Nome da turma e lista de alunos são obrigatórios.');
            return;
        }

        setStep('saving');
        setError('');

        try {
            const { data: classData, error: classError } = await supabase
                .from('classes')
                .insert([{
                    user_id: userId,
                    school_id: schoolId,
                    name: className,
                    subject: subject || 'Geral',
                    grade_level: 'Fundamental/Médio' // Default for now
                }])
                .select()
                .single();

            if (classError) throw classError;
            const classId = classData.id;

            // 2. Process Students
            for (const student of modalStudents) {
                // A. Check/Create Master Student (School Student)
                // Try to find by name in this school mainly to avoid duplicates if possible, 
                // but for massive imports we might just strictly create or get.
                // For simplicity/speed, we'll try to UPSERT based on school_id + name? 
                // No, Supabase doesn't support complex unique constraints easily without setup.
                // We will just INSERT for now. Duplicate names in a school are possible.

                const pdiPayload = student.needsPdi ? {
                    deficiencies: ['Outros'], // Placeholder tag
                    needs_adaptation: true
                } : {};

                const { data: schoolStudentData, error: ssError } = await supabase
                    .from('school_students')
                    .insert([{
                        school_id: schoolId,
                        name: student.name,
                        pdi_data: pdiPayload,
                        created_by: userId
                    }])
                    .select()
                    .single();

                if (ssError) throw ssError;

                // B. Link to Class (Local Student Table)
                const { error: sError } = await supabase
                    .from('students')
                    .insert([{
                        class_id: classId,
                        name: student.name,
                        school_student_id: schoolStudentData.id,
                        needs_adaptation: student.needsPdi // Legacy field support
                    }]);

                if (sError) throw sError;
            }

            onSuccess();
            onClose();

        } catch (err: any) {
            console.error(err);
            setError('Erro ao salvar turma: ' + err.message);
            setStep('review');
        }
    };

    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 bg-slate-950/80 backdrop-blur-sm z-[9999] flex items-center justify-center p-4">
            <div className="bg-white rounded-[2.5rem] w-full max-w-4xl shadow-2xl relative flex flex-col max-h-[90vh] overflow-hidden">

                {/* Header */}
                <div className="p-8 border-b border-slate-100 flex items-center justify-between bg-slate-50">
                    <div>
                        <h2 className="text-2xl font-black text-slate-900 uppercase italic tracking-tighter">Importação de Turma</h2>
                        <p className="text-xs font-bold text-slate-400 uppercase tracking-widest mt-1">Criação em Lote (Supervisor)</p>
                    </div>
                    <button onClick={onClose} className="p-2 hover:bg-slate-200 rounded-full text-slate-400 transition-colors">
                        <X size={24} />
                    </button>
                </div>

                {/* Content */}
                <div className="flex-1 overflow-y-auto p-8">
                    {step === 'upload' && (
                        <div className="flex flex-col items-center justify-center h-full space-y-8 py-10">
                            <div className="w-24 h-24 bg-blue-50 rounded-3xl flex items-center justify-center mb-2">
                                <Upload size={40} className="text-blue-600" />
                            </div>
                            <div className="text-center max-w-md">
                                <h3 className="text-xl font-black text-slate-900 mb-2">Faça Upload da Lista</h3>
                                <p className="text-sm text-slate-500">Envie um PDF com a lista de alunos (chamada) ou um arquivo de texto.</p>
                            </div>

                            <label className="cursor-pointer bg-blue-600 hover:bg-blue-700 text-white px-8 py-4 rounded-2xl font-black uppercase tracking-widest shadow-xl shadow-blue-200 transition-all active:scale-95 flex items-center gap-3">
                                {loading ? <Loader2 className="animate-spin" /> : <FileText />}
                                Selecionar Arquivo
                                <input type="file" className="hidden" accept=".pdf,.txt,.csv" onChange={handleFileUpload} />
                            </label>

                            {error && (
                                <p className="text-red-500 font-bold text-xs bg-red-50 px-4 py-2 rounded-lg">{error}</p>
                            )}
                        </div>
                    )}

                    {(step === 'review' || step === 'saving') && (
                        <div className="space-y-6">
                            {/* Class Details */}
                            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                                <div>
                                    <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-1 block">Nome da Turma</label>
                                    <input
                                        type="text"
                                        value={className}
                                        onChange={e => setClassName(e.target.value)}
                                        className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 font-bold text-slate-900 outline-none focus:ring-2 focus:ring-blue-100"
                                        placeholder="Ex: 1º Ano A"
                                    />
                                </div>
                                <div>
                                    <label className="text-[10px] font-black text-slate-400 uppercase tracking-widest ml-1 mb-1 block">Disciplina</label>
                                    <input
                                        type="text"
                                        value={subject}
                                        onChange={e => setSubject(e.target.value)}
                                        className="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 font-bold text-slate-900 outline-none focus:ring-2 focus:ring-blue-100"
                                        placeholder="Ex: Matemática"
                                    />
                                </div>
                            </div>

                            {/* Student List */}
                            <div className="space-y-2">
                                <div className="flex items-center justify-between">
                                    <h3 className="text-sm font-black text-slate-900 uppercase tracking-wide">
                                        Alunos Identificados ({modalStudents.length})
                                    </h3>
                                    <p className="text-[10px] text-purple-600 font-bold uppercase tracking-wider bg-purple-50 px-2 py-1 rounded">
                                        Marque quem possui PDI
                                    </p>
                                </div>

                                <div className="border border-slate-100 rounded-2xl overflow-hidden max-h-[300px] overflow-y-auto bg-slate-50/50">
                                    <table className="w-full text-left">
                                        <thead className="bg-slate-100 border-b border-slate-200">
                                            <tr>
                                                <th className="px-6 py-3 text-[10px] font-black text-slate-400 uppercase tracking-widest w-16">#</th>
                                                <th className="px-6 py-3 text-[10px] font-black text-slate-400 uppercase tracking-widest">Nome do Aluno</th>
                                                <th className="px-6 py-3 text-[10px] font-black text-slate-400 uppercase tracking-widest text-right">É PDI?</th>
                                            </tr>
                                        </thead>
                                        <tbody className="divide-y divide-slate-100">
                                            {modalStudents.map((student, idx) => (
                                                <tr key={idx} className="hover:bg-white transition-colors">
                                                    <td className="px-6 py-3 text-xs font-bold text-slate-400">{idx + 1}</td>
                                                    <td className="px-6 py-3 text-sm font-bold text-slate-700">{student.name}</td>
                                                    <td className="px-6 py-3 text-right">
                                                        <button
                                                            onClick={() => togglePdi(idx)}
                                                            className={`p-2 rounded-lg transition-all ${student.needsPdi ? 'bg-purple-100 text-purple-600' : 'text-slate-300 hover:bg-slate-200'}`}
                                                        >
                                                            {student.needsPdi ? <CheckSquare size={20} /> : <Square size={20} />}
                                                        </button>
                                                    </td>
                                                </tr>
                                            ))}
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    )}
                </div>

                {/* Footer */}
                {(step === 'review' || step === 'saving') && (
                    <div className="p-6 border-t border-slate-100 bg-slate-50 flex justify-end gap-3">
                        <button
                            onClick={onClose}
                            className="px-6 py-3 text-slate-500 font-bold text-xs uppercase tracking-widest hover:bg-slate-200 rounded-xl transition-colors"
                        >
                            Cancelar
                        </button>
                        <button
                            onClick={handleConfirmImport}
                            disabled={step === 'saving'}
                            className="px-8 py-3 bg-blue-600 text-white rounded-xl font-black text-xs uppercase tracking-widest hover:bg-blue-700 transition-all shadow-xl shadow-blue-200 active:scale-95 flex items-center gap-2 disabled:opacity-50"
                        >
                            {step === 'saving' ? <Loader2 className="animate-spin" /> : <Save size={18} />}
                            {step === 'saving' ? 'Salvando...' : 'Criar Turma e Alunos'}
                        </button>
                    </div>
                )}
            </div>
        </div>
    );
};

export default ClassBatchImportModal;
