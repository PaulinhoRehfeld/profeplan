import React from 'react';
import { UseFormRegister, FieldValues, Path } from 'react-hook-form';
import { PDI_QUESTIONS, PDIAnswer } from '../../../types/pdi-schema';

interface SectionProps<T extends FieldValues> {
    sectionKey: 'psychomotor' | 'cognitive';
    register: UseFormRegister<T>;
    data: any; // Current form values for conditional styling if needed
}

export const PDICheckboxGroup = <T extends FieldValues>({ sectionKey, register }: SectionProps<T>) => {
    const questions = PDI_QUESTIONS[sectionKey];

    return (
        <div className="space-y-8">
            {Object.entries(questions).map(([key, label]) => (
                <div key={key} className="bg-slate-50 p-4 rounded-xl border border-slate-200">
                    <p className="font-bold text-slate-800 text-sm mb-3">{label}</p>
                    <div className="flex flex-wrap gap-2">
                        {[
                            { value: PDIAnswer.APRESENTA, label: 'Apresenta', color: 'bg-emerald-100 text-emerald-700 border-emerald-200' },
                            { value: PDIAnswer.COM_AJUDA, label: 'Com Ajuda', color: 'bg-blue-100 text-blue-700 border-blue-200' },
                            { value: PDIAnswer.NAO_APRESENTA, label: 'Não Apresenta', color: 'bg-red-100 text-red-700 border-red-200' },
                            { value: PDIAnswer.NAO_OBSERVADO, label: 'Não Observado', color: 'bg-slate-100 text-slate-600 border-slate-200' }
                        ].map((option) => (
                            <label
                                key={option.value}
                                className={`
                                    flex items-center gap-2 px-3 py-2 rounded-lg border cursor-pointer hover:opacity-80 transition-all
                                    has-[:checked]:ring-2 has-[:checked]:ring-offset-1 has-[:checked]:ring-indigo-500
                                    ${option.color}
                                `}
                            >
                                <input
                                    type="radio"
                                    value={option.value}
                                    {...register(`${sectionKey}.${key}` as Path<T>)}
                                    className="accent-indigo-600 w-4 h-4 cursor-pointer"
                                />
                                <span className="text-xs font-bold uppercase tracking-wide">{option.label}</span>
                            </label>
                        ))}
                    </div>
                </div>
            ))}
        </div>
    );
};
