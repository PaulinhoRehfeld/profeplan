import React, { useState, useEffect } from 'react';
import { Printer, FileText, Save, Loader2, Target } from 'lucide-react';
import { exportAssessmentToDocx } from '../../services/exportService';
import PrintableEvaluation from '../../components/PrintableEvaluation';
import type { Assessment } from '../../types';
import { saveAssessment } from './AssessmentService';
import { useToast } from '../../contexts/ToastContext';
// Import SubComponents
import AssessmentSetup from './components/AssessmentSetup';
import AssessmentPreview from './components/AssessmentPreview';

interface AssessmentManagerProps {
  userId: string;
  settings?: any;
  setSidebarContent?: (content: React.ReactNode) => void;
}

const AssessmentManager: React.FC<AssessmentManagerProps> = ({
  userId,
  settings,
  setSidebarContent,
}) => {
  // Global State
  const [generatedAssessment, setGeneratedAssessment] = useState<Assessment | null>(null);
  const [showPrintView, setShowPrintView] = useState(false);
  const [isSaving, setIsSaving] = useState(false);
  const { showToast } = useToast();

  /* SIDEBAR EFFECT */
  useEffect(() => {
    if (!setSidebarContent) return;

    if (generatedAssessment && !showPrintView) {
      setSidebarContent(
        <div className="space-y-4">
          <div className="rounded-2xl border border-slate-200 bg-white p-5 shadow-sm">
            <h3 className="mb-4 text-sm font-semibold text-slate-900">Ações da avaliação</h3>

            <div className="space-y-3">
              <button
                onClick={() => setShowPrintView(true)}
                className="ui-focus-ring flex min-h-11 w-full items-center justify-center gap-2 rounded-lg bg-blue-600 px-4 text-sm font-semibold text-white transition-colors hover:bg-blue-700"
              >
                <Printer size={18} className="group-hover:rotate-12 transition-transform" />
                Imprimir Prova
              </button>

              <button
                onClick={handleExportWord}
                className="ui-focus-ring flex min-h-11 w-full items-center justify-center gap-2 rounded-lg border border-slate-300 bg-white px-4 text-sm font-semibold text-slate-700 transition-colors hover:bg-slate-50"
              >
                <FileText size={18} className="group-hover:-translate-y-0.5 transition-transform" />
                Exportar Word
              </button>

              <button
                onClick={handleSave}
                disabled={isSaving}
                aria-busy={isSaving}
                className="ui-focus-ring flex min-h-11 w-full items-center justify-center gap-2 rounded-lg border border-slate-300 bg-white px-4 text-sm font-semibold text-slate-700 transition-colors hover:bg-slate-50 disabled:cursor-not-allowed disabled:opacity-50"
              >
                {isSaving ? (
                  <Loader2 className="animate-spin" />
                ) : (
                  <Save size={18} className="group-hover:scale-110 transition-transform" />
                )}
                {isSaving ? 'Salvando...' : 'Salvar Avaliação'}
              </button>
            </div>
          </div>

          <div className="rounded-2xl border border-slate-200 bg-slate-50 p-5">
            <h3 className="mb-4 flex items-center gap-2 text-sm font-semibold text-slate-900">
              <Target size={16} className="text-blue-600" /> Resumo
            </h3>

            <div className="grid grid-cols-2 gap-4">
              <div className="rounded-lg border border-slate-200 bg-white p-3">
                <p className="mb-1 text-xs text-slate-500">Questões</p>
                <p className="text-xl font-bold text-slate-900">
                  {generatedAssessment.questions.length}
                </p>
              </div>
              <div className="rounded-lg border border-slate-200 bg-white p-3">
                <p className="mb-1 text-xs text-slate-500">Pontos</p>
                <p className="text-xl font-bold text-slate-900">
                  {generatedAssessment.totalPoints}
                </p>
              </div>
              <div className="col-span-2 flex items-center justify-between rounded-lg border border-slate-200 bg-white p-3">
                <span className="text-xs text-slate-600">Objetivas</span>
                <span className="font-semibold text-emerald-700">
                  {generatedAssessment.questions.filter((q) => q.type === 'objective').length}
                </span>
              </div>
              <div className="col-span-2 flex items-center justify-between rounded-lg border border-slate-200 bg-white p-3">
                <span className="text-xs text-slate-600">Dissertativas</span>
                <span className="font-semibold text-blue-700">
                  {generatedAssessment.questions.filter((q) => q.type === 'dissertative').length}
                </span>
              </div>
            </div>
          </div>
        </div>
      );
    } else {
      setSidebarContent(null);
    }

    return () => {
      setSidebarContent(null);
    };
  }, [generatedAssessment, showPrintView, setSidebarContent, isSaving]);

  const handleSave = async () => {
    if (!generatedAssessment) return;
    setIsSaving(true);

    try {
      // Usa o novo Service Local-First
      await saveAssessment(userId, generatedAssessment);
      showToast('success', 'Avaliação salva com sucesso em “Meus Arquivos”.');
    } catch (error: any) {
      console.error('Erro ao salvar:', error);
      showToast(
        'error',
        error.message ? `Erro ao salvar: ${error.message}` : 'Erro ao salvar avaliação.'
      );
    } finally {
      setIsSaving(false);
    }
  };

  const handleExportWord = async () => {
    if (!generatedAssessment) return;
    try {
      await exportAssessmentToDocx(generatedAssessment, settings);
    } catch (error) {
      console.error('Erro ao exportar Word:', error);
      showToast('error', 'Erro ao exportar para Word.');
    }
  };

  // 1. Print View
  if (showPrintView && generatedAssessment) {
    return (
      <>
        <button
          onClick={() => setShowPrintView(false)}
          className="no-print fixed top-10 left-10 z-[200] px-6 py-3 bg-white text-slate-900 rounded-2xl font-black text-xs uppercase tracking-widest shadow-xl hover:bg-slate-100 transition-all"
        >
          ← Voltar para Edição
        </button>
        <PrintableEvaluation
          assessment={generatedAssessment}
          schoolName={settings?.institution || 'Sua Escola'}
          logoBase64={settings?.logoBase64}
        />
      </>
    );
  }

  // 2. Preview (Result) View
  if (generatedAssessment) {
    return (
      <AssessmentPreview
        assessment={generatedAssessment}
        isSaving={isSaving}
        onClose={() => {
          setGeneratedAssessment(null);
          if (setSidebarContent) setSidebarContent(null);
        }}
        onSave={handleSave}
        onPrint={() => setShowPrintView(true)}
        onExportWord={handleExportWord}
      />
    );
  }

  // 3. Setup (Form) View
  return (
    <div className="flex h-full flex-col bg-slate-50">
      <div className="flex items-center justify-between border-b border-slate-200 bg-white px-4 py-4 md:px-8">
        <div className="flex items-center gap-2 text-slate-700">
          <Target size={18} className="text-purple-500" />
          <span className="text-sm font-semibold">Criar avaliação</span>
        </div>
      </div>
      <div className="flex-1">
        <AssessmentSetup userId={userId} onAssessmentGenerated={setGeneratedAssessment} />
      </div>
    </div>
  );
};

export default AssessmentManager;
