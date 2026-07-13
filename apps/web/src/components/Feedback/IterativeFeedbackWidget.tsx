import React, { useState } from 'react';
import {
  MessageCircle,
  Send,
  CheckCircle2,
  XCircle,
  Sparkles,
  Loader2,
  Settings,
} from 'lucide-react';

interface IterativeFeedbackWidgetProps {
  isVisible: boolean;
  onClose: () => void;
  onRegeneratePlan: (feedback: string) => Promise<void>;
  onSaveFeedbackAsDefault: (feedback: string) => Promise<void>;
  isRegenerating?: boolean;
  latestGeneration?: string;
}

/**
 * ITERATIVE FEEDBACK WIDGET V2.0
 *
 * Fluxo completo conforme especificação do usuário:
 * 1. Professor escreve observações
 * 2. Sistema regenera plano baseado nas observações
 * 3. Pergunta: "As alterações atendem as solicitações?" (SIM/NÃO)
 *    - NÃO: Loop de volta para novas observações
 *    - SIM: Pergunta: "Utilizar esta mudança como padrão?" (SIM/NÃO) + SALVAR
 */
export const IterativeFeedbackWidget: React.FC<IterativeFeedbackWidgetProps> = ({
  isVisible,
  onClose,
  onRegeneratePlan,
  onSaveFeedbackAsDefault,
  isRegenerating = false,
  latestGeneration,
}) => {
  // Estados do fluxo iterativo
  const [currentStep, setCurrentStep] = useState<'feedback' | 'confirmation' | 'preference'>(
    'feedback'
  );
  const [feedback, setFeedback] = useState('');
  const [accumulatedFeedback, setAccumulatedFeedback] = useState<string[]>([]);
  const [isSaving, setIsSaving] = useState(false);

  if (!isVisible) return null;

  // STEP 1: Coletar Feedback
  const handleSubmitFeedback = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!feedback.trim()) return;

    // Adicionar ao histórico de feedback
    setAccumulatedFeedback((prev) => [...prev, feedback]);

    // Regenerar plano
    await onRegeneratePlan(feedback);

    // Após regenerar, ir para confirmação
    setCurrentStep('confirmation');
    setFeedback(''); // Limpar input
  };

  // STEP 2: Confirmação - As alterações atendem?
  const handleConfirmationYes = () => {
    // SIM: Ir para pergunta de preferência
    setCurrentStep('preference');
  };

  const handleConfirmationNo = () => {
    // NÃO: Voltar para feedback (loop)
    setCurrentStep('feedback');
    // Manter histórico de feedback para contexto
  };

  // STEP 3: Preferência - Usar como padrão?
  const handleSaveAsDefault = async (saveAsDefault: boolean) => {
    setIsSaving(true);
    try {
      if (saveAsDefault) {
        // Salvar último feedback como padrão nas preferências
        const lastFeedback = accumulatedFeedback[accumulatedFeedback.length - 1];
        await onSaveFeedbackAsDefault(lastFeedback);
      }
      // Sempre salvar o plano final
      // (isso será feito pelo componente pai)

      // Reset e fechar
      setCurrentStep('feedback');
      setAccumulatedFeedback([]);
      onClose();
    } catch (error) {
      console.error('Erro ao salvar:', error);
    } finally {
      setIsSaving(false);
    }
  };

  return (
    <div className="fixed bottom-24 right-6 md:right-10 z-50 animate-in slide-in-from-bottom-5 duration-300 flex flex-col items-end">
      <div className="bg-white rounded-2xl p-6 shadow-2xl border-2 border-indigo-200 max-w-md w-full relative overflow-hidden">
        {/* Header decorativo */}
        <div className="absolute top-0 left-0 w-full h-2 bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500"></div>

        {/* STEP 1: FEEDBACK INPUT */}
        {currentStep === 'feedback' && !isRegenerating && (
          <div>
            <div className="flex items-start gap-3 mb-4">
              <div className="w-10 h-10 rounded-full bg-indigo-100 flex items-center justify-center shrink-0">
                <Sparkles size={20} className="text-indigo-600" />
              </div>
              <div className="flex-1">
                <h4 className="font-bold text-slate-800 text-base mb-1">
                  Existem ajustes a serem feitos, professor?
                </h4>
                <p className="text-xs text-slate-500 leading-relaxed">
                  Digite suas observações e eu refarei o plano imediatamente.
                </p>
              </div>
            </div>

            {/* Histórico de feedbacks anteriores (se houver) */}
            {accumulatedFeedback.length > 0 && (
              <div className="mb-4 p-3 bg-slate-50 rounded-lg border border-slate-200">
                <p className="text-xs font-bold text-slate-600 mb-2">Observações anteriores:</p>
                {accumulatedFeedback.map((fb, idx) => (
                  <p key={idx} className="text-xs text-slate-600 mb-1">
                    {idx + 1}. {fb}
                  </p>
                ))}
              </div>
            )}

            <form onSubmit={handleSubmitFeedback}>
              <textarea
                value={feedback}
                onChange={(e) => setFeedback(e.target.value)}
                placeholder="Ex: 'Mude a metodologia para gamificação' ou 'Adicione mais atividades práticas'"
                className="w-full bg-slate-50 border-2 border-slate-200 rounded-xl p-4 text-sm focus:ring-2 focus:ring-indigo-300 focus:border-indigo-400 outline-none resize-none h-32"
                autoFocus
              />
              <div className="flex justify-between items-center mt-3">
                <button
                  type="button"
                  onClick={onClose}
                  className="text-xs text-slate-400 hover:text-slate-600 underline"
                >
                  Fechar
                </button>
                <button
                  type="submit"
                  disabled={!feedback.trim()}
                  className="px-6 py-3 bg-indigo-600 text-white rounded-xl text-sm font-bold hover:bg-indigo-700 disabled:opacity-50 disabled:cursor-not-allowed transition-all flex items-center gap-2 shadow-lg shadow-indigo-200"
                >
                  <Send size={16} />
                  Regenerar Plano
                </button>
              </div>
            </form>
          </div>
        )}

        {/* LOADING: Regenerando */}
        {isRegenerating && (
          <div className="flex flex-col items-center justify-center py-8 text-center">
            <Loader2 className="animate-spin text-indigo-500 mb-4" size={40} />
            <h4 className="font-bold text-slate-700 text-base mb-2">Regenerando plano...</h4>
            <p className="text-xs text-slate-500 max-w-xs">
              Acatando suas observações: "
              <span className="font-semibold text-indigo-600">
                {accumulatedFeedback[accumulatedFeedback.length - 1]}
              </span>
              "
            </p>
          </div>
        )}

        {/* STEP 2: CONFIRMAÇÃO - As alterações atendem? */}
        {currentStep === 'confirmation' && !isRegenerating && (
          <div>
            <div className="flex items-start gap-3 mb-4">
              <div className="w-10 h-10 rounded-full bg-green-100 flex items-center justify-center shrink-0">
                <CheckCircle2 size={20} className="text-green-600" />
              </div>
              <div className="flex-1">
                <h4 className="font-bold text-slate-800 text-base mb-1">
                  As alterações atendem as solicitações?
                </h4>
                <p className="text-xs text-slate-500 leading-relaxed">
                  Revise o plano regenerado e confirme se está adequado.
                </p>
              </div>
            </div>

            {/* Preview do último feedback */}
            <div className="mb-4 p-3 bg-indigo-50 rounded-lg border border-indigo-200">
              <p className="text-xs font-bold text-indigo-700 mb-1">Sua última solicitação:</p>
              <p className="text-xs text-slate-700">
                "{accumulatedFeedback[accumulatedFeedback.length - 1]}"
              </p>
            </div>

            <div className="flex gap-3">
              <button
                onClick={handleConfirmationNo}
                className="flex-1 px-4 py-3 bg-red-100 text-red-700 rounded-xl text-sm font-bold hover:bg-red-200 transition-all flex items-center justify-center gap-2 border-2 border-red-300"
              >
                <XCircle size={18} />
                NÃO
                <span className="block text-[10px] font-normal text-red-600">
                  Precisa ajustar mais
                </span>
              </button>
              <button
                onClick={handleConfirmationYes}
                className="flex-1 px-4 py-3 bg-green-600 text-white rounded-xl text-sm font-bold hover:bg-green-700 transition-all flex items-center justify-center gap-2 shadow-lg shadow-green-200"
              >
                <CheckCircle2 size={18} />
                SIM
                <span className="block text-[10px] font-normal text-green-100">Está perfeito!</span>
              </button>
            </div>
          </div>
        )}

        {/* STEP 3: PREFERÊNCIA - Usar como padrão? */}
        {currentStep === 'preference' && !isSaving && (
          <div>
            <div className="flex items-start gap-3 mb-4">
              <div className="w-10 h-10 rounded-full bg-purple-100 flex items-center justify-center shrink-0">
                <Settings size={20} className="text-purple-600" />
              </div>
              <div className="flex-1">
                <h4 className="font-bold text-slate-800 text-base mb-1">
                  Utilizar esta mudança como padrão para os novos planos?
                </h4>
                <p className="text-xs text-slate-500 leading-relaxed">
                  Se escolher SIM, futuros planos seguirão automaticamente este ajuste.
                </p>
              </div>
            </div>

            {/* Preview da mudança que será salva */}
            <div className="mb-4 p-3 bg-purple-50 rounded-lg border border-purple-200">
              <p className="text-xs font-bold text-purple-700 mb-1">Ajuste que será aplicado:</p>
              <p className="text-xs text-slate-700">
                "{accumulatedFeedback[accumulatedFeedback.length - 1]}"
              </p>
            </div>

            <div className="space-y-3">
              <div className="grid grid-cols-2 gap-3">
                <button
                  onClick={() => handleSaveAsDefault(false)}
                  className="px-4 py-3 bg-slate-100 text-slate-700 rounded-xl text-sm font-bold hover:bg-slate-200 transition-all border-2 border-slate-300"
                >
                  NÃO
                  <span className="block text-[10px] font-normal text-slate-600">
                    Apenas este plano
                  </span>
                </button>
                <button
                  onClick={() => handleSaveAsDefault(true)}
                  className="px-4 py-3 bg-purple-600 text-white rounded-xl text-sm font-bold hover:bg-purple-700 transition-all shadow-lg shadow-purple-200"
                >
                  SIM
                  <span className="block text-[10px] font-normal text-purple-100">
                    Usar como padrão
                  </span>
                </button>
              </div>

              <button
                onClick={() => handleSaveAsDefault(false)}
                className="w-full px-6 py-4 bg-gradient-to-r from-indigo-600 to-purple-600 text-white rounded-xl text-base font-black uppercase tracking-wide hover:from-indigo-700 hover:to-purple-700 transition-all shadow-xl"
              >
                💾 SALVAR PLANO
              </button>
            </div>
          </div>
        )}

        {/* Loading de salvamento */}
        {isSaving && (
          <div className="flex flex-col items-center justify-center py-8">
            <Loader2 className="animate-spin text-purple-500 mb-3" size={36} />
            <p className="text-sm font-bold text-slate-700">Salvando...</p>
          </div>
        )}
      </div>
    </div>
  );
};
