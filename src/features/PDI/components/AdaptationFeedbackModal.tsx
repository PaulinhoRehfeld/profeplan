
import React, { useState } from 'react';
import { Star, CheckCircle2, AlertCircle } from 'lucide-react';

interface AdaptationFeedbackModalProps {
    isOpen: boolean;
    onClose: () => void;
    onSave: (feedback: any) => void;
    studentName: string;
    lessonTopic: string;
}

export const AdaptationFeedbackModal: React.FC<AdaptationFeedbackModalProps> = ({
    isOpen, onClose, onSave, studentName, lessonTopic
}) => {
    const [skill, setSkill] = useState('');
    const [development, setDevelopment] = useState<'PLENAMENTE' | 'PARCIALMENTE' | 'NAO_DESENVOLVIDA' | ''>('');
    const [support, setSupport] = useState<'NENHUM' | 'POUCO' | 'MUITO' | ''>('');

    if (!isOpen) return null;

    const handleSubmit = () => {
        if (!skill || !development || !support) {
            alert("Preencha todos os campos da avaliação.");
            return;
        }
        onSave({
            skill,
            development_level: development,
            support_level: support,
            feedback_date: new Date().toISOString()
        });
        onClose();
    };

    return (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/50 backdrop-blur-sm p-4 animate-in fade-in duration-200">
            <div className="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden animate-in zoom-in-95 duration-200">
                <div className="bg-gradient-to-r from-indigo-600 to-indigo-700 p-6 text-white">
                    <h3 className="font-black text-lg flex items-center gap-2">
                        <Star className="text-yellow-400 fill-yellow-400" size={20} />
                        Avaliação da Atividade
                    </h3>
                    <p className="text-indigo-200 text-xs font-medium mt-1">
                        Adaptação: {lessonTopic} • Aluno: {studentName}
                    </p>
                </div>

                <div className="p-6 space-y-6">
                    {/* Skill Input */}
                    <div>
                        <label className="block text-xs font-bold uppercase text-slate-400 tracking-wider mb-2">
                            Qual habilidade específica foi trabalhada?
                        </label>
                        <input
                            type="text"
                            value={skill}
                            onChange={(e) => setSkill(e.target.value)}
                            placeholder="Ex: Leitura de palavras simples, Soma com reserva..."
                            className="w-full p-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-semibold text-slate-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition-all"
                            autoFocus
                        />
                    </div>

                    {/* Development Level */}
                    <div>
                        <label className="block text-xs font-bold uppercase text-slate-400 tracking-wider mb-3">
                            A habilidade foi desenvolvida?
                        </label>
                        <div className="grid grid-cols-1 gap-2">
                            {[
                                { val: 'PLENAMENTE', label: 'Plenamente Desenvolvida', color: 'border-emerald-200 bg-emerald-50 text-emerald-700' },
                                { val: 'PARCIALMENTE', label: 'Parcialmente Desenvolvida', color: 'border-yellow-200 bg-yellow-50 text-yellow-700' },
                                { val: 'NAO_DESENVOLVIDA', label: 'Não Desenvolvida', color: 'border-red-200 bg-red-50 text-red-700' },
                            ].map((opt) => (
                                <label
                                    key={opt.val}
                                    className={`flex items-center gap-3 p-3 rounded-xl border cursor-pointer transition-all hover:scale-[1.02] ${development === opt.val ? `ring-2 ring-offset-1 ring-indigo-500 ${opt.color}` : 'border-slate-100 hover:bg-slate-50'}`}
                                >
                                    <input
                                        type="radio"
                                        name="dev_level"
                                        value={opt.val}
                                        checked={development === opt.val}
                                        onChange={(e) => setDevelopment(e.target.value as any)}
                                        className="w-4 h-4 accent-indigo-600"
                                    />
                                    <span className="text-sm font-bold">{opt.label}</span>
                                </label>
                            ))}
                        </div>
                    </div>

                    {/* Support Level */}
                    <div>
                        <label className="block text-xs font-bold uppercase text-slate-400 tracking-wider mb-3">
                            Nível de suporte oferecido
                        </label>
                        <div className="grid grid-cols-3 gap-2">
                            {[
                                { val: 'NENHUM', label: 'Nenhum' },
                                { val: 'POUCO', label: 'Pouco' },
                                { val: 'MUITO', label: 'Muito' },
                            ].map((opt) => (
                                <label
                                    key={opt.val}
                                    className={`flex flex-col items-center justify-center gap-1 p-3 rounded-xl border cursor-pointer transition-all hover:bg-slate-50 ${support === opt.val ? 'bg-indigo-50 border-indigo-200 text-indigo-700 ring-1 ring-indigo-500' : 'border-slate-100 text-slate-600'}`}
                                >
                                    <input
                                        type="radio"
                                        name="support_level"
                                        value={opt.val}
                                        checked={support === opt.val}
                                        onChange={(e) => setSupport(e.target.value as any)}
                                        className="sr-only"
                                    />
                                    <span className={`text-xs font-bold ${support === opt.val ? 'text-indigo-700' : 'text-slate-400'}`}>{opt.label}</span>
                                    {support === opt.val && <CheckCircle2 size={14} />}
                                </label>
                            ))}
                        </div>
                    </div>
                </div>

                <div className="p-4 bg-slate-50 border-t border-slate-100 flex justify-end gap-2">
                    <button
                        onClick={onClose}
                        className="px-4 py-2 text-xs font-bold uppercase text-slate-400 hover:text-slate-600 transition-colors"
                    >
                        Pular Avaliação
                    </button>
                    <button
                        onClick={handleSubmit}
                        disabled={!skill || !development || !support}
                        className="px-6 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-lg text-xs font-bold uppercase tracking-wider shadow-lg shadow-indigo-200 disabled:opacity-50 disabled:shadow-none transition-all hover:scale-105"
                    >
                        Salvar Avaliação
                    </button>
                </div>
            </div>
        </div>
    );
};
