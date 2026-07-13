import React from 'react';
import { UseFormRegister, FieldValues, Path } from 'react-hook-form';
import { PDI_QUESTIONS, PDIAnswer } from '../../../types/pdi-schema';

interface PDICheckboxGroupProps<T extends FieldValues> {
  // Mode A: Schema Questions (Radio Groups)
  sectionKey?: 'psychomotor' | 'cognitive';
  register?: UseFormRegister<T>;

  // Mode B: Generic Multi-Select (Simple Checkboxes)
  label?: string;
  options?: string[];
  selected?: string[];
  onChange?: (selected: string[]) => void;

  // Shared / Misc
  data?: any;
  manualOverride?: boolean;
  isRadioMode?: boolean;
  fieldMap?: Record<string, string>;
  watch?: any;
  setValue?: any;
  section?: string;
}

export const PDICheckboxGroup = <T extends FieldValues>(props: PDICheckboxGroupProps<T>) => {
  // MODE B: Generic Multi-Select (e.g. Diagnósticos)
  if (props.options && props.onChange && props.selected) {
    const toggleOption = (option: string) => {
      const current = props.selected || [];
      if (current.includes(option)) {
        props.onChange?.(current.filter((item) => item !== option));
      } else {
        props.onChange?.([...current, option]);
      }
    };

    return (
      <div className="bg-slate-50 p-4 rounded-xl border border-slate-200">
        {props.label && <p className="font-bold text-slate-800 text-sm mb-3">{props.label}</p>}
        <div className="flex flex-wrap gap-2">
          {props.options.map((option) => {
            const isSelected = props.selected?.includes(option);
            return (
              <button
                key={option}
                type="button"
                onClick={() => toggleOption(option)}
                className={`
                                    px-3 py-2 rounded-lg border text-xs font-bold uppercase tracking-wide transition-all
                                    ${
                                      isSelected
                                        ? 'bg-indigo-600 text-white border-indigo-600 shadow-md shadow-indigo-200'
                                        : 'bg-white text-slate-500 border-slate-200 hover:border-indigo-300 hover:text-indigo-600'
                                    }
                                `}
              >
                {option}
              </button>
            );
          })}
        </div>
      </div>
    );
  }

  // MODE A: Schema Questions (PDI Answers)
  if (props.sectionKey && props.register) {
    const questions = PDI_QUESTIONS[props.sectionKey];
    if (!questions) return null; // Safety check

    return (
      <div className="space-y-8">
        {Object.entries(questions).map(([key, label]) => (
          <div key={key} className="bg-slate-50 p-4 rounded-xl border border-slate-200">
            <p className="font-bold text-slate-800 text-sm mb-3">{label}</p>
            <div className="flex flex-wrap gap-2">
              {[
                {
                  value: PDIAnswer.APRESENTA,
                  label: 'Apresenta',
                  color: 'bg-emerald-100 text-emerald-700 border-emerald-200',
                },
                {
                  value: PDIAnswer.COM_AJUDA,
                  label: 'Com Ajuda',
                  color: 'bg-blue-100 text-blue-700 border-blue-200',
                },
                {
                  value: PDIAnswer.NAO_APRESENTA,
                  label: 'Não Apresenta',
                  color: 'bg-red-100 text-red-700 border-red-200',
                },
                {
                  value: PDIAnswer.NAO_OBSERVADO,
                  label: 'Não Observado',
                  color: 'bg-slate-100 text-slate-600 border-slate-200',
                },
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
                    {...props.register!(`${props.sectionKey}.${key}` as Path<T>)}
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
  }

  return null;
};
