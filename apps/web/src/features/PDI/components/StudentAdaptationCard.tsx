import React from 'react';
import { Loader2, Sparkles, CheckCircle2, RefreshCw, Download } from 'lucide-react';
import { Student, StudentAdaptation } from '../../../types';

interface StudentAdaptationCardProps {
  student: Student;
  adaptation?: StudentAdaptation;
  isGenerating: boolean;
  hasLessonSelected: boolean;
  onGenerate: (student: Student) => void;
  onValidate: (studentId: string, content: string) => void;
  onDownload: (student: Student, content: string) => void;
}

const StudentAdaptationCard: React.FC<StudentAdaptationCardProps> = ({
  student,
  adaptation,
  isGenerating,
  hasLessonSelected,
  onGenerate,
  onValidate,
  onDownload,
}) => {
  return (
    <div className="bg-white rounded-[2rem] shadow-sm border border-slate-100 overflow-hidden hover:shadow-lg transition-all duration-300">
      <div className="bg-slate-50 border-b border-slate-100 p-4 md:p-6 flex flex-col sm:flex-row justify-between items-start gap-4">
        <div>
          <h3 className="text-lg font-black text-slate-900 flex items-center gap-2">
            {student.name}{' '}
            <span className="text-teal-600 animate-pulse text-xs bg-teal-50 px-2 py-1 rounded-full">
              PDI ATIVO
            </span>
          </h3>
          <div className="flex gap-2 mt-2">
            {student.deficiencies?.map((tag) => (
              <span
                key={tag}
                className="text-[9px] font-black uppercase tracking-wider bg-slate-200 text-slate-600 px-2 py-1 rounded"
              >
                {tag}
              </span>
            ))}
          </div>
          {student.pedagogical_observations && (
            <p className="text-[10px] text-slate-400 mt-2 italic bg-yellow-50 p-2 rounded-lg border border-yellow-100 line-clamp-2">
              "{student.pedagogical_observations}"
            </p>
          )}
        </div>
        {!adaptation && (
          <button
            onClick={() => onGenerate(student)}
            disabled={isGenerating || !hasLessonSelected}
            className="bg-teal-600 text-white w-full sm:w-auto px-6 py-3 rounded-xl text-xs font-black uppercase tracking-widest flex items-center justify-center gap-2 hover:bg-teal-700 disabled:opacity-50 transition-all shadow-lg shadow-teal-200"
          >
            {isGenerating ? <Loader2 size={14} className="animate-spin" /> : <Sparkles size={14} />}
            Gerar Adaptação
          </button>
        )}
      </div>

      {adaptation && (
        <div className="p-6">
          <div className="bg-teal-50/30 p-4 rounded-2xl border border-teal-50 text-sm text-slate-700 whitespace-pre-wrap font-medium">
            {adaptation.adaptedContent}
          </div>

          <div className="flex flex-col sm:flex-row items-center justify-between mt-6 pt-4 border-t border-slate-50 gap-4">
            <div className="flex items-center gap-2">
              <label
                className={`w-full sm:w-auto flex items-center justify-center gap-2 cursor-pointer px-6 py-3 rounded-xl border transition-all ${adaptation.status === 'validated' ? 'bg-green-50 border-green-200 text-green-700' : 'bg-white border-slate-200 hover:bg-slate-50'}`}
              >
                <input
                  type="checkbox"
                  className="hidden"
                  checked={adaptation.status === 'validated'}
                  onChange={() => onValidate(student.id, adaptation.adaptedContent)}
                  disabled={adaptation.status === 'validated'}
                />
                {adaptation.status === 'validated' ? (
                  <CheckCircle2 size={16} />
                ) : (
                  <div className="w-4 h-4 border-2 border-slate-300 rounded-full"></div>
                )}
                <span className="text-[10px] font-black uppercase tracking-widest">
                  {adaptation.status === 'validated'
                    ? 'Validado para Relatório'
                    : 'Validar Adaptação'}
                </span>
              </label>
            </div>
            <div className="flex gap-2">
              <button
                onClick={() => onGenerate(student)}
                className="p-2 text-slate-400 hover:text-teal-600 hover:bg-teal-50 rounded-lg transition-colors"
                title="Regerar"
              >
                <RefreshCw size={16} />
              </button>
              {adaptation.status === 'validated' && (
                <button
                  onClick={() => onDownload(student, adaptation.adaptedContent)}
                  className="px-4 py-2 bg-indigo-50 text-indigo-700 hover:bg-indigo-100 rounded-lg text-[10px] font-black uppercase tracking-widest flex items-center gap-2 transition-colors border border-indigo-200"
                  title="Baixar DOCX Individual"
                >
                  <Download size={14} /> Baixar
                </button>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default StudentAdaptationCard;
