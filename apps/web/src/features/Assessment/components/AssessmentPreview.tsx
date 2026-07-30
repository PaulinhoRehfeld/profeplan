import React from 'react';
import { Loader2, Save, Printer, FileText, X } from 'lucide-react';
import { Assessment } from '../../../types';

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
  onExportWord,
}) => {
  // We can keep the rendering logic simple here.
  // The "Metrics" sidebar logic remains in the parent (Manager) or we can move it here if we want
  // to strictly couple sidebar content with this view.
  // For now, parent handles sidebar to avoid prop drilling `setSidebarContent`.

  return (
    <div className="w-full px-4 py-6 md:px-8 md:py-8">
      <div className="mx-auto w-full max-w-5xl space-y-6">
        <div className="flex items-start justify-between gap-4">
          <div>
            <p className="text-xs font-semibold uppercase tracking-wide text-blue-700">
              Avaliação pronta
            </p>
            <h1 className="mt-1 text-2xl font-bold tracking-tight text-slate-950 md:text-3xl">
              {assessment.title}
            </h1>
            <p className="mt-2 text-sm text-slate-600">
              {assessment.className} • {assessment.subject}
            </p>
          </div>
          <button
            type="button"
            onClick={onClose}
            aria-label="Fechar prévia e voltar à configuração"
            className="ui-focus-ring min-h-11 min-w-11 rounded-lg p-3 text-slate-600 hover:bg-slate-100"
          >
            <X size={20} />
          </button>
        </div>

        <div className="space-y-4">
          {assessment.questions.map((q, index) => (
            <div
              key={q.id}
              className="rounded-2xl border border-slate-200 bg-white p-4 shadow-sm md:p-6"
            >
              <div className="flex items-start gap-4">
                <div className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-blue-600 text-base font-bold text-white">
                  {index + 1}
                </div>
                <div className="flex-1">
                  <div className="mb-4 flex flex-wrap items-center gap-2">
                    <span
                      className={`rounded-full px-2.5 py-1 text-xs font-medium ${
                        q.type === 'objective'
                          ? 'bg-green-100 text-green-700'
                          : 'bg-purple-100 text-purple-700'
                      }`}
                    >
                      {q.type === 'objective' ? 'Objetiva' : 'Dissertativa'}
                    </span>
                    <span className="text-xs font-bold text-slate-400">{q.maxPoints} pontos</span>
                  </div>
                  <p className="mb-5 text-base leading-7 text-slate-900">{q.question}</p>

                  {q.type === 'objective' && q.options && (
                    <div className="space-y-3">
                      {q.options.map((opt, i) => (
                        <div
                          key={i}
                          className={`p-4 rounded-xl border-2 transition-all ${
                            opt.startsWith(q.correctAnswer || '')
                              ? 'border-emerald-300 bg-emerald-50 font-medium text-emerald-900'
                              : 'border-slate-200 bg-slate-50 text-slate-700'
                          }`}
                        >
                          <span className="text-sm">{opt}</span>
                        </div>
                      ))}
                    </div>
                  )}

                  {q.type === 'dissertative' && q.rubric && (
                    <div className="rounded-xl border border-blue-200 bg-blue-50 p-4">
                      <p className="mb-2 text-xs font-semibold uppercase tracking-wide text-blue-700">
                        Rubrica de Correção
                      </p>
                      <p className="text-xs text-indigo-900 leading-relaxed font-medium">
                        {q.rubric}
                      </p>
                    </div>
                  )}
                </div>
              </div>
            </div>
          ))}
        </div>

        {/* ACTION BAR — visível em todas as telas */}
        <div className="sticky bottom-3 grid grid-cols-1 gap-3 rounded-2xl border border-slate-200 bg-white/95 p-3 shadow-lg backdrop-blur md:grid-cols-[1fr_auto_auto]">
          <button
            type="button"
            onClick={onSave}
            disabled={isSaving}
            aria-busy={isSaving}
            className="ui-focus-ring flex min-h-11 w-full items-center justify-center gap-2 rounded-lg bg-blue-600 px-5 text-sm font-semibold text-white hover:bg-blue-700 disabled:cursor-not-allowed disabled:opacity-50"
          >
            {isSaving ? <Loader2 className="animate-spin" /> : <Save size={18} />}
            {isSaving ? 'Salvando...' : 'Salvar Avaliação'}
          </button>

          <button
            type="button"
            onClick={onPrint}
            className="ui-focus-ring flex min-h-11 items-center justify-center gap-2 rounded-lg border border-slate-300 bg-white px-4 text-sm font-semibold text-slate-700 hover:bg-slate-50"
          >
            <Printer size={16} /> Imprimir
          </button>
          <button
            type="button"
            onClick={onExportWord}
            className="ui-focus-ring flex min-h-11 items-center justify-center gap-2 rounded-lg border border-slate-300 bg-white px-4 text-sm font-semibold text-slate-700 hover:bg-slate-50"
          >
            <FileText size={16} /> Baixar Word
          </button>
        </div>
      </div>
    </div>
  );
};

export default AssessmentPreview;
