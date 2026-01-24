import React, { useState } from 'react';
import { PdiService, PdiRecordType } from '../services/PdiService';
import { AlertCircle, Save, Loader2, X, CheckCircle2 } from 'lucide-react';

interface QuickPdiLogProps {
    studentId: string; // The centralized school_student_id
    studentName: string;
    onClose: () => void;
    onSuccess: () => void;
}

const QuickPdiLog: React.FC<QuickPdiLogProps> = ({ studentId, studentName, onClose, onSuccess }) => {
    const [description, setDescription] = useState('');
    const [type, setType] = useState<PdiRecordType>('OCCURRENCE'); // Default to OCCURRENCE
    const [loading, setLoading] = useState(false);

    const handleSave = async () => {
        if (!description.trim()) return;

        setLoading(true);
        try {
            await PdiService.logEvent(
                studentId,
                type,
                type === 'OCCURRENCE' ? 'Ocorrência Comportamental' : 'Observação Pedagógica',
                { description },
                type === 'OCCURRENCE' ? 'Bloco VII' : 'Bloco V'
            );
            onSuccess();
        } catch (error) {
            console.error('Failed to log PDI event:', error);
            alert('Erro ao salvar registro.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="fixed inset-0 bg-slate-950/60 backdrop-blur-sm z-[100] flex items-center justify-center p-4">
            <div className="bg-white p-6 rounded-2xl w-full max-w-md shadow-2xl relative">
                <button onClick={onClose} className="absolute top-4 right-4 text-slate-400 hover:text-slate-600">
                    <X size={20} />
                </button>

                <h3 className="text-lg font-black text-slate-800 mb-1 uppercase italic tracking-tight">Registro Rápido</h3>
                <p className="text-sm font-bold text-slate-400 uppercase tracking-wide mb-6">Para: {studentName}</p>

                <div className="flex bg-slate-100 p-1 rounded-xl mb-4">
                    <button
                        onClick={() => setType('OCCURRENCE')}
                        className={`flex-1 py-2 rounded-lg text-xs font-black uppercase tracking-widest transition-all ${type === 'OCCURRENCE' ? 'bg-white text-red-600 shadow-sm' : 'text-slate-400 hover:text-slate-600'
                            }`}
                    >
                        Ocorrência
                    </button>
                    <button
                        onClick={() => setType('OBSERVATION')}
                        className={`flex-1 py-2 rounded-lg text-xs font-black uppercase tracking-widest transition-all ${type === 'OBSERVATION' ? 'bg-white text-blue-600 shadow-sm' : 'text-slate-400 hover:text-slate-600'
                            }`}
                    >
                        Observação
                    </button>
                </div>

                <textarea
                    className="w-full h-32 bg-slate-50 border border-slate-200 rounded-xl p-4 text-sm font-medium text-slate-700 outline-none focus:ring-2 focus:ring-blue-100 resize-none mb-4"
                    placeholder={type === 'OCCURRENCE' ? "Descreva o comportamento..." : "Descreva a observação..."}
                    value={description}
                    onChange={e => setDescription(e.target.value)}
                ></textarea>

                <button
                    onClick={handleSave}
                    disabled={loading || !description.trim()}
                    className="w-full py-3 bg-slate-900 text-white rounded-xl font-black text-xs uppercase tracking-widest hover:bg-slate-800 transition-all flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                    {loading ? <Loader2 className="animate-spin" size={16} /> : <Save size={16} />}
                    Salvar no PDI
                </button>
            </div>
        </div>
    );
};

export default QuickPdiLog;
