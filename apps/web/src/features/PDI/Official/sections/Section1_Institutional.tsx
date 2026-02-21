import React from 'react';
import { useFormContext } from 'react-hook-form';
import { PDIProfileData } from '../../../../types/pdi-schema';
import { Building2 } from 'lucide-react';

interface SectionProps {
    onSave: () => void;
}

export const Section1Institutional: React.FC<SectionProps> = ({ onSave }) => {
    const { register } = useFormContext<PDIProfileData>();

    // We can trigger onSave onBlur of the container or individual fields. 
    // Usually section level save button or auto-save on blur is best.
    // For now, let's just bind to onBlur of inputs.

    return (
        <div className="space-y-8 animate-in fade-in duration-500">
            <div className="flex items-center gap-3 border-b border-slate-100 pb-4">
                <div className="w-10 h-10 bg-blue-50 rounded-full flex items-center justify-center text-blue-600">
                    <Building2 className="w-5 h-5" />
                </div>
                <div>
                    <h2 className="text-xl font-bold text-slate-900">I. Dados Institucionais</h2>
                    <p className="text-sm text-slate-500">Informações da Escola e Superintendência</p>
                </div>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div className="space-y-2">
                    <label className="block text-xs font-bold uppercase text-slate-500 tracking-wider">Nome da Escola</label>
                    <input
                        {...register('institutional.school_name', { onBlur: onSave })}
                        type="text"
                        className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none transition-all font-medium text-slate-700"
                        placeholder="Ex: Escola Estadual..."
                    />
                </div>

                <div className="space-y-2">
                    <label className="block text-xs font-bold uppercase text-slate-500 tracking-wider">Código INEP</label>
                    <input
                        {...register('institutional.school_inep', { onBlur: onSave })}
                        type="text"
                        className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none transition-all font-medium text-slate-700"
                        placeholder="Ex: 3100..."
                    />
                </div>

                <div className="space-y-2">
                    <label className="block text-xs font-bold uppercase text-slate-500 tracking-wider">SRE (Superintendência)</label>
                    <input
                        {...register('institutional.sre', { onBlur: onSave })}
                        type="text"
                        className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none transition-all font-medium text-slate-700"
                        placeholder="Ex: Metropolitana A"
                    />
                </div>

                <div className="space-y-2">
                    <label className="block text-xs font-bold uppercase text-slate-500 tracking-wider">Município</label>
                    <input
                        {...register('institutional.city', { onBlur: onSave })}
                        type="text"
                        className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none transition-all font-medium text-slate-700"
                        placeholder="Ex: Belo Horizonte"
                    />
                </div>
            </div>

            <div className="bg-blue-50 border border-blue-100 rounded-lg p-4 flex gap-3 items-start">
                <span className="text-blue-500 text-lg">💡</span>
                <p className="text-xs text-blue-700 leading-relaxed">
                    Certifique-se de que os dados institucionais estejam corretos, pois eles aparecerão no cabeçalho de todos os relatórios oficiais gerados.
                </p>
            </div>
        </div>
    );
};
