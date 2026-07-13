import React, { useState, useEffect } from 'react';
import { Printer, FileText, Save, Loader2, Target, HelpCircle } from 'lucide-react';
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
        <div className="space-y-6 animate-in slide-in-from-right-4 duration-500">
          <div className="bg-gradient-to-br from-indigo-50 to-purple-50 border border-indigo-100 rounded-[2.5rem] p-6 shadow-lg">
            <h3 className="text-[10px] font-black text-indigo-400 uppercase tracking-[0.2em] mb-6 italic">
              Centro de Comando
            </h3>

            <div className="space-y-3">
              <button
                onClick={() => setShowPrintView(true)}
                className="w-full bg-indigo-600 text-white px-6 py-4 rounded-2xl font-black text-xs uppercase tracking-widest flex items-center justify-center gap-3 hover:bg-indigo-700 transition-all shadow-lg hover:shadow-indigo-200 active:scale-95 group"
              >
                <Printer size={18} className="group-hover:rotate-12 transition-transform" />
                Imprimir Prova
              </button>

              <button
                onClick={handleExportWord}
                className="w-full bg-white text-indigo-700 px-6 py-4 rounded-2xl font-black text-xs uppercase tracking-widest flex items-center justify-center gap-3 hover:bg-indigo-50 border border-indigo-100 transition-all shadow-sm active:scale-95 group"
              >
                <FileText size={18} className="group-hover:-translate-y-0.5 transition-transform" />
                Exportar Word
              </button>

              <button
                onClick={handleSave}
                disabled={isSaving}
                className="w-full bg-purple-600 text-white px-6 py-4 rounded-2xl font-black text-xs uppercase tracking-widest flex items-center justify-center gap-3 hover:bg-purple-700 transition-all shadow-lg hover:shadow-purple-200 active:scale-95 group disabled:opacity-50"
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

          <div className="bg-slate-900 rounded-[2.5rem] p-6 shadow-xl text-white relative overflow-hidden group">
            <div className="absolute top-0 right-0 w-32 h-32 bg-purple-500/10 blur-3xl group-hover:bg-purple-500/20 transition-all"></div>

            <h3 className="text-[9px] font-black text-slate-400 uppercase tracking-[0.2em] mb-4 flex items-center gap-2">
              <Target size={12} className="text-purple-400" /> Métricas
            </h3>

            <div className="grid grid-cols-2 gap-4">
              <div className="bg-white/5 p-3 rounded-2xl border border-white/10">
                <p className="text-[9px] text-slate-400 uppercase tracking-widest mb-1">Questões</p>
                <p className="text-xl font-black">{generatedAssessment.questions.length}</p>
              </div>
              <div className="bg-white/5 p-3 rounded-2xl border border-white/10">
                <p className="text-[9px] text-slate-400 uppercase tracking-widest mb-1">Pontos</p>
                <p className="text-xl font-black text-purple-400">
                  {generatedAssessment.totalPoints}
                </p>
              </div>
              <div className="bg-white/5 p-3 rounded-2xl border border-white/10 col-span-2 flex justify-between items-center px-4">
                <span className="text-[9px] text-slate-400 uppercase tracking-widest">
                  Objetivas
                </span>
                <span className="font-bold text-green-400">
                  {generatedAssessment.questions.filter((q) => q.type === 'objective').length}
                </span>
              </div>
              <div className="bg-white/5 p-3 rounded-2xl border border-white/10 col-span-2 flex justify-between items-center px-4">
                <span className="text-[9px] text-slate-400 uppercase tracking-widest">
                  Dissertativas
                </span>
                <span className="font-bold text-purple-400">
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
    <div className="flex flex-col h-full bg-slate-50">
      <div className="flex items-center justify-between px-4 md:px-8 py-3 bg-white border-b border-slate-200">
        <div className="flex items-center gap-2 text-slate-700">
          <Target size={18} className="text-purple-500" />
          <span className="text-xs font-black uppercase tracking-widest">
            Montagem de Avaliações Contextualizadas
          </span>
        </div>
      </div>
      <div className="flex-1">
        <AssessmentSetup userId={userId} onAssessmentGenerated={setGeneratedAssessment} />
      </div>
    </div>
  );
};

export default AssessmentManager;
