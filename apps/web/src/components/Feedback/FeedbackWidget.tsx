import React, { useState, useEffect, useRef } from 'react';
import { MessageCircle, Send, X, Loader2, Sparkles, AlertCircle } from 'lucide-react';

interface FeedbackWidgetProps {
  isVisible: boolean;
  onClose: () => void;
  onSubmitFeedback: (feedback: string) => Promise<void>;
  isRegenerating?: boolean;
}

export const FeedbackWidget: React.FC<FeedbackWidgetProps> = ({
  isVisible,
  onClose,
  onSubmitFeedback,
  isRegenerating = false,
}) => {
  const [feedback, setFeedback] = useState('');
  const inputRef = useRef<HTMLTextAreaElement>(null);
  const [hasSubmitted, setHasSubmitted] = useState(false);

  useEffect(() => {
    if (isVisible && inputRef.current) {
      // Focus delay to ensure animation doesn't cut lag
      setTimeout(() => inputRef.current?.focus(), 100);
      setHasSubmitted(false);
      setFeedback('');
    }
  }, [isVisible]);

  if (!isVisible) return null;

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!feedback.trim()) return;

    setHasSubmitted(true); // Optimistic UI
    await onSubmitFeedback(feedback);
    setFeedback('');
    // We don't close immediately; we let the parent handle the "Regenerating" state
  };

  return (
    <div className="fixed bottom-24 right-6 md:right-10 z-50 animate-in slide-in-from-bottom-5 duration-300 flex flex-col items-end">
      {/* Balloon Prompt */}
      <div className="bg-white rounded-2xl p-4 shadow-2xl border border-indigo-100 max-w-sm w-full mb-3 relative overflow-hidden">
        {/* Decorative Gradients */}
        <div className="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-indigo-500 via-purple-500 to-pink-500"></div>
        <div className="absolute -bottom-6 -right-6 w-24 h-24 bg-indigo-50 rounded-full blur-xl"></div>

        {/* Content */}
        {!isRegenerating ? (
          <>
            <div className="flex items-start gap-3 mb-3">
              <div className="w-8 h-8 rounded-full bg-indigo-100 flex items-center justify-center shrink-0">
                <Sparkles size={16} className="text-indigo-600" />
              </div>
              <div>
                <h4 className="font-bold text-slate-800 text-sm">
                  Existem ajustes a serem feitos, professor?
                </h4>
                <p className="text-xs text-slate-500 leading-relaxed mt-1">
                  Analise o conteúdo. Se algo não estiver como deseja, me diga e eu refarei agora
                  mesmo.
                </p>
              </div>
              <button
                onClick={onClose}
                className="text-slate-300 hover:text-slate-500 transition-colors -mt-1 -mr-2"
              >
                <X size={16} />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="relative">
              <textarea
                ref={inputRef}
                value={feedback}
                onChange={(e) => setFeedback(e.target.value)}
                placeholder="Ex: 'Mude a metodologia para...'"
                className="w-full bg-slate-50 border border-slate-200 rounded-xl p-3 text-sm focus:ring-2 focus:ring-indigo-100 focus:border-indigo-300 outline-none resize-none h-24 custom-scrollbar"
                onKeyDown={(e) => {
                  if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    handleSubmit(e);
                  }
                }}
              />
              <div className="flex justify-end mt-2">
                <button
                  type="submit"
                  disabled={!feedback.trim()}
                  className="px-4 py-2 bg-indigo-600 text-white rounded-lg text-xs font-bold uppercase tracking-wide hover:bg-indigo-700 disabled:opacity-50 disabled:cursor-not-allowed transition-all flex items-center gap-2"
                >
                  <Send size={12} />
                  Solicitar Ajuste
                </button>
              </div>
            </form>
          </>
        ) : (
          <div className="flex flex-col items-center justify-center py-4 text-center">
            <Loader2 className="animate-spin text-indigo-500 mb-2" size={32} />
            <h4 className="font-bold text-slate-700 text-sm">Regenerando contéudo...</h4>
            <p className="text-xs text-slate-400">Acatando suas observações: "{feedback}"</p>
          </div>
        )}
      </div>
    </div>
  );
};
