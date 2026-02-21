import React from 'react';
import { useFormContext } from 'react-hook-form';
import { PdiData } from '../../../../types/pdi-schema';

interface ChecklistItem {
    key: string; // The key within the specific section object (e.g. 'body_schema')
    label: string;
}

interface ChecklistGridProps {
    sectionKey: keyof PdiData; // e.g. 'psychomotor', 'cognitive'
    items: ChecklistItem[];
    onSave: () => void;
}

const OPTIONS = [
    { value: 'APRESENTA', label: 'Apresenta' },
    { value: 'COM_AJUDA', label: 'Com Ajuda' },
    { value: 'NAO_APRESENTA', label: 'Não Apresenta' },
    { value: 'NAO_OBSERVADO', label: 'Não Observado' },
];

export const ChecklistGrid: React.FC<ChecklistGridProps> = ({ sectionKey, items, onSave }) => {
    const { register } = useFormContext<PdiData>();

    return (
        <div className="overflow-x-auto">
            <table className="w-full text-sm text-left">
                <thead className="bg-slate-50 text-slate-500 font-bold uppercase text-xs">
                    <tr>
                        <th className="px-4 py-3 rounded-tl-lg">Habilidade / Aspecto</th>
                        {OPTIONS.map(opt => (
                            <th key={opt.value} className="px-2 py-3 text-center w-24">
                                {opt.label}
                            </th>
                        ))}
                    </tr>
                </thead>
                <tbody className="divide-y divide-slate-100">
                    {items.map((item) => (
                        <tr key={item.key} className="hover:bg-slate-50/50 transition-colors">
                            <td className="px-4 py-3 font-medium text-slate-700">
                                {item.label}
                            </td>
                            {OPTIONS.map((opt) => (
                                <td key={opt.value} className="px-2 py-3 text-center">
                                    <div className="flex justify-center">
                                        <input
                                            {...register(`${sectionKey}.${item.key}` as any, { onBlur: onSave })}
                                            type="radio"
                                            value={opt.value}
                                            className="w-4 h-4 text-blue-600 border-slate-300 focus:ring-blue-500 cursor-pointer"
                                        />
                                    </div>
                                </td>
                            ))}
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
};
