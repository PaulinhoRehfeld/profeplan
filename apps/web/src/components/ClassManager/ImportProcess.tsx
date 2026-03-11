import React, { useState, useEffect } from 'react';
import { Loader2 } from 'lucide-react';
import { parseClassListFromText } from '../../services/ai/AiUtilityService';

interface ImportProcessProps {
    file: File;
    onCancel: () => void;
    onComplete: (data: { className: string, subject: string, students: string[] }) => Promise<void>;
}

const ImportProcess: React.FC<ImportProcessProps> = ({ file, onCancel, onComplete }) => {
    const [step, setStep] = useState<'uploading' | 'parsing' | 'confirming'>('uploading');
    const [tempData, setTempData] = useState<{ className: string, subject: string, students: string[] } | null>(null);
    const [error, setError] = useState('');

    useEffect(() => {
        if (file) {
            processFile(file);
        }
    }, [file]);

    const processFile = async (f: File) => {
        if (f.type !== 'application/pdf') {
            setError('Por favor, selecione um arquivo PDF.');
            return;
        }

        setStep('parsing'); // "Lendo PDF..." or "Gemini..." - let's map UI
        // Actually step 'uploading' shows "Lendo PDF", 'parsing' shows "Gemini processando"
        // Let's stick to 'uploading' for text extraction, 'parsing' for AI.

        setStep('uploading');
        setError('');

        try {
            const { extractTextFromPdf } = await import('../../services/pdfService');
            const text = await extractTextFromPdf(f);

            setStep('parsing');
            const parsedData = await parseClassListFromText(text);

            setTempData(parsedData);
            setStep('confirming');
        } catch (err: any) {
            console.error(err);
            setError(err.message || 'Erro ao processar PDF.');
            // Stay in error state
        }
    };

    const handleConfirm = async () => {
        if (!tempData) return;
        setStep('parsing'); // Reuse parsing state for "saving" spinner look (or create new 'saving' state)
        try {
            await onComplete(tempData);
        } catch (err: any) {
            setError('Erro ao salvar: ' + err.message);
            setStep('confirming');
        }
    };

    return (
        <div className="bg-blue-600 rounded-[2.5rem] p-10 text-white shadow-2xl relative overflow-hidden animate-in zoom-in-95 duration-300">
            <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 blur-3xl -mr-32 -mt-32"></div>

            {step === 'uploading' || step === 'parsing' ? (
                <div className="flex flex-col items-center text-center py-10">
                    <Loader2 className="w-16 h-16 animate-spin mb-6 text-blue-200" />
                    <h3 className="text-xl font-black uppercase italic tracking-tight">
                        {step === 'uploading' ? 'Lendo PDF da Lista...' : 'Gemini processando alunos...'}
                    </h3>
                    <p className="text-blue-200 text-[10px] font-bold uppercase tracking-[0.3em] mt-3">Extraindo inteligência pedagógica</p>
                </div>
            ) : (
                <div className="space-y-6">
                    <div className="flex items-center justify-between">
                        <div>
                            <h3 className="text-2xl font-black uppercase italic tracking-tight">Turma Encontrada!</h3>
                            <p className="text-blue-100 text-sm font-bold mt-1">
                                Encontramos <span className="text-white font-black">{tempData?.students.length} alunos</span> na turma <span className="text-white font-black">{tempData?.className}</span> ({tempData?.subject}).
                            </p>
                        </div>
                        <div className="flex gap-4">
                            <button
                                onClick={onCancel}
                                className="px-6 py-3 bg-white/10 hover:bg-white/20 rounded-xl font-black text-[10px] uppercase tracking-widest transition-colors"
                            >
                                Cancelar
                            </button>
                            <button
                                onClick={handleConfirm}
                                className="px-8 py-3 bg-white text-blue-600 rounded-xl font-black text-[10px] uppercase tracking-widest hover:scale-105 transition-all shadow-lg active:scale-95"
                            >
                                Confirmar e Salvar
                            </button>
                        </div>
                    </div>

                    <div className="bg-white/10 rounded-2xl p-6 max-h-48 overflow-y-auto custom-scrollbar border border-white/10">
                        <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
                            {tempData?.students.map((student, i) => (
                                <div key={i} className="text-[10px] font-bold uppercase tracking-tight text-blue-100 flex items-center gap-2">
                                    <div className="w-1.5 h-1.5 bg-blue-300 rounded-full"></div> {typeof student === 'object' ? (student as any).name || 'Aluno Sem Nome' : student}
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
            )}

            {error && (
                <div className="mt-4 p-4 bg-red-500/20 text-white rounded-xl text-center font-bold text-xs border border-white/10">
                    {error}
                    <button onClick={onCancel} className="block w-full mt-2 text-[10px] underline">Tentar novamente</button>
                </div>
            )}
        </div>
    );
};

export default ImportProcess;
