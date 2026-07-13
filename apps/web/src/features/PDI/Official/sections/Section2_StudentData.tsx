import React from 'react';
import { useFormContext } from 'react-hook-form';
import { PDIProfileData } from '../../../../types/pdi-schema';
import { UserCircle } from 'lucide-react';

interface SectionProps {
  onSave: () => void;
}

export const Section2StudentData: React.FC<SectionProps> = ({ onSave }) => {
  const {
    register,
    formState: { errors },
  } = useFormContext<PDIProfileData>();

  return (
    <div className="space-y-8 animate-in fade-in duration-500">
      <div className="flex items-center gap-3 border-b border-slate-100 pb-4">
        <div className="w-10 h-10 bg-indigo-50 rounded-full flex items-center justify-center text-indigo-600">
          <UserCircle className="w-5 h-5" />
        </div>
        <div>
          <h2 className="text-xl font-bold text-slate-900">II. Dados do Estudante</h2>
          <p className="text-sm text-slate-500">Identificação e Escolaridade</p>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="md:col-span-2 space-y-2">
          <label className="block text-xs font-bold uppercase text-slate-500 tracking-wider">
            Nome do Estudante <span className="text-red-500">*</span>
          </label>
          <input
            {...register('student_data.name', { onBlur: onSave })}
            type="text"
            className={`w-full px-4 py-3 bg-slate-50 border rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none transition-all font-medium text-slate-700 ${errors.student_data?.name ? 'border-red-300 focus:ring-red-200' : 'border-slate-200'}`}
            placeholder="Nome social ou civil completo"
          />
          {errors.student_data?.name && (
            <span className="text-xs text-red-500 font-bold">
              {errors.student_data.name.message}
            </span>
          )}
        </div>

        <div className="space-y-2">
          <label className="block text-xs font-bold uppercase text-slate-500 tracking-wider">
            Data de Nascimento
          </label>
          <input
            {...register('student_data.dob', { onBlur: onSave })}
            type="date"
            className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none transition-all font-medium text-slate-700"
          />
        </div>

        <div className="space-y-2">
          <label className="block text-xs font-bold uppercase text-slate-500 tracking-wider">
            Idade (Anos)
          </label>
          <input
            {...register('student_data.age', { valueAsNumber: true, onBlur: onSave })}
            type="number"
            className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none transition-all font-medium text-slate-700"
            placeholder="Ex: 12"
          />
        </div>

        <div className="space-y-2">
          <label className="block text-xs font-bold uppercase text-slate-500 tracking-wider">
            Ano de Escolaridade
          </label>
          <select
            {...register('student_data.school_year', { onBlur: onSave })}
            className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none transition-all font-medium text-slate-700 appearance-none cursor-pointer"
          >
            <option value="">Selecione...</option>
            <option value="1º Ano EF">1º Ano EF</option>
            <option value="2º Ano EF">2º Ano EF</option>
            <option value="3º Ano EF">3º Ano EF</option>
            <option value="4º Ano EF">4º Ano EF</option>
            <option value="5º Ano EF">5º Ano EF</option>
            <option value="6º Ano EF">6º Ano EF</option>
            <option value="7º Ano EF">7º Ano EF</option>
            <option value="8º Ano EF">8º Ano EF</option>
            <option value="9º Ano EF">9º Ano EF</option>
            <option value="1º Ano EM">1º Ano EM</option>
            <option value="2º Ano EM">2º Ano EM</option>
            <option value="3º Ano EM">3º Ano EM</option>
          </select>
        </div>

        <div className="space-y-2">
          <label className="block text-xs font-bold uppercase text-slate-500 tracking-wider">
            Turma
          </label>
          <input
            {...register('student_data.class_name', { onBlur: onSave })}
            type="text"
            className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none transition-all font-medium text-slate-700"
            placeholder="Ex: 601"
          />
        </div>

        <div className="space-y-2">
          <label className="block text-xs font-bold uppercase text-slate-500 tracking-wider">
            Turno
          </label>
          <select
            {...register('student_data.shift', { onBlur: onSave })}
            className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none transition-all font-medium text-slate-700 appearance-none cursor-pointer"
          >
            <option value="">Selecione...</option>
            <option value="Matutino">Matutino</option>
            <option value="Vespertino">Vespertino</option>
            <option value="Noturno">Noturno</option>
            <option value="Integral">Integral</option>
          </select>
        </div>

        <div className="md:col-span-2 space-y-2">
          <label className="block text-xs font-bold uppercase text-slate-500 tracking-wider">
            Professor(a) de Referência / Regente
          </label>
          <input
            {...register('student_data.teacher_name', { onBlur: onSave })}
            type="text"
            className="w-full px-4 py-3 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-indigo-500 outline-none transition-all font-medium text-slate-700"
            placeholder="Nome do professor responsável pelo PDI"
          />
        </div>
      </div>
    </div>
  );
};
