import React from 'react';
import { X, FileText, Calendar, CheckCircle } from 'lucide-react';

interface AdaptationDetailsModalProps {
  isOpen: boolean;
  onClose: () => void;
  studentName: string;
  content: string;
  date?: string;
}

export const AdaptationDetailsModal: React.FC<AdaptationDetailsModalProps> = ({
  isOpen,
  onClose,
  studentName,
  content,
  date,
}) => {
  if (!isOpen) return null;

  // Simple markdown-to-html-like rendering for basic structure
  // Replacing headers and lists for better visual representation if markdown
  const renderContent = (text: string) => {
    return text.split('\n').map((line, i) => {
      if (line.startsWith('# '))
        return (
          <h1 key={i} className="text-xl font-bold text-slate-800 mt-4 mb-2">
            {line.replace('# ', '')}
          </h1>
        );
      if (line.startsWith('## '))
        return (
          <h2 key={i} className="text-lg font-bold text-indigo-700 mt-4 mb-2">
            {line.replace('## ', '')}
          </h2>
        );
      if (line.startsWith('### '))
        return (
          <h3 key={i} className="text-md font-bold text-slate-700 mt-3 mb-1">
            {line.replace('### ', '')}
          </h3>
        );
      if (line.startsWith('- '))
        return (
          <li key={i} className="ml-4 mb-1 text-slate-600 list-disc">
            {line.replace('- ', '')}
          </li>
        );
      if (line.trim() === '') return <div key={i} className="h-2"></div>;
      return (
        <p key={i} className="mb-1 text-slate-600 leading-relaxed">
          {line}
        </p>
      );
    });
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/50 backdrop-blur-sm p-4 animate-in fade-in duration-200">
      <div className="bg-white rounded-2xl shadow-2xl w-full max-w-3xl max-h-[85vh] flex flex-col overflow-hidden animate-in zoom-in-95 duration-200">
        {/* Header */}
        <div className="bg-white border-b border-slate-200 p-6 flex justify-between items-start sticky top-0 z-10">
          <div>
            <div className="flex items-center gap-2 mb-1">
              <span className="px-2 py-0.5 rounded-md bg-indigo-50 text-indigo-700 text-[10px] font-black uppercase tracking-wider border border-indigo-100">
                Adaptação Curricular
              </span>
              {date && (
                <span className="flex items-center gap-1 text-xs text-slate-400 font-medium">
                  <Calendar size={12} /> {date}
                </span>
              )}
            </div>
            <h2 className="text-2xl font-black text-slate-800">{studentName}</h2>
          </div>
          <button
            onClick={onClose}
            className="p-2 rounded-full hover:bg-slate-100 text-slate-400 hover:text-slate-600 transition-colors"
          >
            <X size={20} />
          </button>
        </div>

        {/* Content */}
        <div className="flex-1 overflow-y-auto p-8 bg-slate-50/50">
          <div className="bg-white p-8 rounded-xl border border-slate-100 shadow-sm prose prose-slate max-w-none">
            {renderContent(content)}
          </div>
        </div>

        {/* Footer */}
        <div className="p-4 bg-white border-t border-slate-200 flex justify-end">
          <button
            onClick={onClose}
            className="px-6 py-2.5 bg-slate-800 hover:bg-slate-900 text-white rounded-lg text-sm font-bold transition-all shadow-lg shadow-slate-200"
          >
            Fechar Visualização
          </button>
        </div>
      </div>
    </div>
  );
};
