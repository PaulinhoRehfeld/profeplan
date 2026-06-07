import React from 'react';
import { useFieldArray, useFormContext } from 'react-hook-form';
import { PDIProfileData as PdiData } from '../../../../types/pdi-schema';
import { GraduationCap, Plus, Trash2 } from 'lucide-react';

interface SectionProps {
    onSave: () => void;
}

export const Section7TeacherEval: React.FC<SectionProps> = ({ onSave }) => {
    const { register, control, formState: { errors } } = useFormContext<PdiData>();
    const { fields, append, remove } = useFieldArray({
        control,
        name: "teacher_evaluations"
    });

    return (
        <div className="space-y-8 animate-in fade-in duration-500">
            <div className="flex items-center justify-between border-b border-slate-100 pb-4">
                <div className="flex items-center gap-3">
                    <div className="w-10 h-10 bg-emerald-50 rounded-full flex items-center justify-center text-emerald-600">
                        <GraduationCap className="w-5 h-5" />
                    </div>
                    <div>
                        <h2 className="text-xl font-bold text-slate-900">X. Avaliação do Professor</h2>
                        <p className="text-sm text-slate-500">Parecer Descritivo por Área/Bimestre</p>
                    </div>
                </div>
                <button
                    onClick={() => append({ bimester: "1", subject: "", autonomy_level: "MUITO_SUPORTE", diagnosis: "" })}
                    className="flex items-center gap-2 px-4 py-2 bg-emerald-600 text-white rounded-lg text-xs font-bold uppercase transition hover:bg-emerald-700"
                >
                    <Plus className="w-4 h-4" /> Adicionar Avaliação
                </button>
            </div>

            {fields.length === 0 ? (
                <div className="text-center py-12 bg-slate-50 rounded-xl border border-dashed border-slate-200">
                    <GraduationCap className="w-12 h-12 text-slate-300 mx-auto mb-3" />
                    <p className="text-slate-500 font-medium">Nenhuma avaliação registrada.</p>
                    <p className="text-xs text-slate-400 mt-1">Clique em "Adicionar Avaliação" para começar.</p>
                </div>
            ) : (
                <div className="space-y-6">
                    {fields.map((field, index) => (
                        <div key={field.id} className="bg-white border border-slate-200 rounded-xl p-6 shadow-sm relative group hover:border-emerald-200 transition-all">
                            <button
                                onClick={() => remove(index)}
                                className="absolute top-4 right-4 text-slate-300 hover:text-red-500 transition-colors opacity-0 group-hover:opacity-100 p-2"
                                title="Remover"
                            >
                                <Trash2 className="w-4 h-4" />
                            </button>

                            <div className="grid grid-cols-1 md:grid-cols-12 gap-4 mb-4">
                                <div className="md:col-span-2 space-y-1">
                                    <label className="text-[10px] font-black uppercase text-slate-400 tracking-wider">Bimestre</label>
                                    <select
                                        {...register(`teacher_evaluations.${index}.bimester`, { onBlur: onSave })}
                                        className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-lg text-sm font-bold text-slate-700"
                                    >
                                        <option value="1">1º Bimestre</option>
                                        <option value="2">2º Bimestre</option>
                                        <option value="3">3º Bimestre</option>
                                        <option value="4">4º Bimestre</option>
                                    </select>
                                </div>

                                <div className="md:col-span-6 space-y-1">
                                    <label className="text-[10px] font-black uppercase text-slate-400 tracking-wider">Componente Curricular (Matéria)</label>
                                    <input
                                        {...register(`teacher_evaluations.${index}.subject`, { onBlur: onSave })}
                                        placeholder="Ex: Matemática"
                                        className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-lg text-sm font-bold text-slate-700 placeholder:font-normal"
                                    />
                                </div>

                                <div className="md:col-span-4 space-y-1">
                                    <label className="text-[10px] font-black uppercase text-slate-400 tracking-wider">Nível de Autonomia</label>
                                    <select
                                        {...register(`teacher_evaluations.${index}.autonomy_level`, { onBlur: onSave })}
                                        className="w-full px-3 py-2 bg-slate-50 border border-slate-200 rounded-lg text-sm font-bold text-slate-700"
                                    >
                                        <option value="MUITO_SUPORTE">Requer Muito Suporte</option>
                                        <option value="POUCO_SUPORTE">Requer Pouco Suporte</option>
                                        <option value="POUCO_SUPORTE">Requer Algum Suporte</option>
                                        <option value="ALTA_COMPREENSAO">Alta Compreensão</option>
                                        <option value="POUCA_COMPREENSAO">Pouca Compreensão</option>
                                    </select>
                                </div>
                            </div>

                            <div className="space-y-1">
                                <label className="text-[10px] font-black uppercase text-slate-400 tracking-wider">Parecer Descritivo / Diagnóstico</label>
                                <textarea
                                    {...register(`teacher_evaluations.${index}.diagnosis`, { onBlur: onSave })}
                                    rows={4}
                                    className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-lg text-sm text-slate-700 resize-none focus:ring-2 focus:ring-emerald-500 outline-none"
                                    placeholder="Descreva o desenvolvimento do aluno, dificuldades observadas e estratégias utilizadas..."
                                />
                            </div>
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
};
