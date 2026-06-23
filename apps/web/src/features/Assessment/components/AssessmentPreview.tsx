import React, { useState } from 'react';
import { Loader2, Save, Printer, FileText, Check, X } from 'lucide-react';
import { Assessment, AssessmentQuestion } from '../../../types';

interface AssessmentPreviewProps {
    assessment: Assessment;
    isSaving: boolean;
    onClose: () => void;
    onSave: () => void;
    onPrint: () => void;
    onExportWord: () => void;
}

const AssessmentPreview: React.FC<AssessmentPreviewProps> = ({
    assessment,
    isSaving,
    onClose,
    onSave,
    onPrint,
    onExportWord
}) => {

    // We can keep the rendering logic simple here.
    // The "Metrics" sidebar logic remains in the parent (Manager) or we can move it here if we want 
    // to strictly couple sidebar content with this view. 
    // For now, parent handles sidebar to avoid prop drilling `setSidebarContent`.

    return (
        <div className="flex w-full animate-in fade-in slide-in-from-right-4 duration-500">
            <div className="w-full max-w-5xl mx-auto space-y-8">
                <div className="flex items-center justify-between">
                    <div>
                        <h2 className="text-3xl font-black text-slate-900 tracking-tight uppercase italic">{assessment.title}</h2>
                        <p className="text-xs font-bold text-slate-400 uppercase tracking-widest mt-1">
                            {assessment.className} • {assessment.subject}
                        </p>
                    </div>
                    <button
                        onClick={onClose}
                        className="p-3 hover:bg-slate-100 rounded-2xl transition-colors"
                    >
                        <X size={20} />
                    </button>
                </div>

                <div className="space-y-6">
                    {assessment.questions.map((q, index) => (
                        <div key={q.id} className="bg-white border border-slate-100 rounded-[2.5rem] p-10 shadow-sm transition-all hover:shadow-md">
                            <div className="flex items-start gap-6">
                                <div className="w-14 h-14 bg-gradient-to-br from-blue-600 to-indigo-700 rounded-2xl flex items-center justify-center text-white font-black text-xl shrink-0 shadow-lg shadow-blue-100">
                                    {index + 1}
                                </div>
                                <div className="flex-1">
                                    <div className="flex items-center gap-3 mb-5">
                                        <span className={`px-4 py-1.5 rounded-full text-[10px] font-black uppercase tracking-widest ${q.type === 'objective' ? 'bg-green-100 text-green-700' : 'bg-purple-100 text-purple-700'
                                            }`}>
                                            {q.type === 'objective' ? 'Objetiva' : 'Dissertativa'}
                                        </span>
                                        <span className="text-xs font-bold text-slate-400">{q.maxPoints} pontos</span>
                                    </div>
                                    <p className="text-base font-medium text-slate-900 mb-6 leading-relaxed">{q.question}</p>

                                    {q.type === 'objective' && q.options && (
                                        <div className="space-y-3">
                                            {q.options.map((opt, i) => (
                                                <div
                                                    key={i}
                                                    className={`p-4 rounded-xl border-2 transition-all ${opt.startsWith(q.correctAnswer || '')
                                                        ? 'border-green-200 bg-green-50 font-bold text-green-800'
                                                        : 'border-transparent bg-slate-50 text-slate-600 hover:border-slate-100'
                                                        }`}
                                                >
                                                    <span className="text-sm">{opt}</span>
                                                </div>
                                            ))}
                                        </div>
                                    )}

                                    {q.type === 'dissertative' && q.rubric && (
                                        <div className="p-6 bg-indigo-50 border border-indigo-100 rounded-2xl">
                                            <p className="text-[10px] font-black text-indigo-600 uppercase tracking-widest mb-3">Rubrica de Correção</p>
                                            <p className="text-xs text-indigo-900 leading-relaxed font-medium">{q.rubric}</p>
                                        </div>
                                    )}
                                </div>
                            </div>
                        </div>
                    ))}
                </div>

                {/* ACTION BAR — visível em todas as telas */}
                <div className="grid grid-cols-1 gap-3 pt-4 pb-10">
                    <button
                        onClick={onSave}
                        disabled={isSaving}
                        className="w-full bg-purple-600 text-white px-6 py-4 rounded-2xl font-black text-xs uppercase tracking-widest flex items-center justify-center gap-3 active:scale-95 transition-all shadow-lg disabled:opacity-50"
                    >
                        {isSaving ? <Loader2 className="animate-spin" /> : <Save size={18} />}
                        {isSaving ? 'Salvando...' : 'Salvar Avaliação'}
                    </button>

                    <div className="grid grid-cols-2 gap-3">
                        <button
                            onClick={onPrint}
                            className="w-full bg-indigo-100 text-indigo-700 px-4 py-3 rounded-xl font-black text-[10px] uppercase tracking-widest flex items-center justify-center gap-2 active:scale-95 transition-all"
                        >
                            <Printer size={16} /> Imprimir
                        </button>
                        <button
                            onClick={onExportWord}
                            className="w-full bg-blue-100 text-blue-700 px-4 py-3 rounded-xl font-black text-[10px] uppercase tracking-widest flex items-center justify-center gap-2 active:scale-95 transition-all"
                        >
                            <FileText size={16} /> Baixar Word
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
};

export default AssessmentPreview;
