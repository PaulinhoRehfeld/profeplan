import React, { useEffect, useState } from 'react';
import { feedbackService } from '../../services/feedbackService';
import { Download, MessageSquare, AlertTriangle } from 'lucide-react';
import { exportToDocx } from '../../services/exportService';

export const FeedbackReport: React.FC = () => {
  const [feedbacks, setFeedbacks] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    loadFeedbacks();
  }, []);

  const loadFeedbacks = async () => {
    try {
      const data = await feedbackService.getFeedbacks();
      setFeedbacks(data || []);
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  const handleExport = () => {
    const content = `
# RELATÓRIO DE MELHORIA CONTÍNUA (FEEDBACKS)

${feedbacks
  .map(
    (f) => `
## ${new Date(f.created_at).toLocaleDateString()} - ${f.feature}
**Contexto:** ${f.original_content_summary}
**Feedback do Professor:**
"${f.feedback_text}"
---------------------------------------------------
`
  )
  .join('\n')}
        `;
    exportToDocx(content, 'Relatorio_Feedbacks_Melhoria', { userName: 'Admin' });
  };

  if (loading) return <div className="p-10 text-center">Carregando dados...</div>;

  return (
    <div className="p-6 max-w-6xl mx-auto space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-black text-slate-800 uppercase tracking-tight">
            Relatório de Aprimoramento
          </h1>
          <p className="text-slate-500 text-sm">
            Baseado nas observações dos professores (Loop de Feedback)
          </p>
        </div>
        <button
          onClick={handleExport}
          className="px-4 py-2 bg-emerald-600 text-white rounded-lg font-bold flex items-center gap-2 hover:bg-emerald-700 transition-all"
        >
          <Download size={16} /> Exportar Relatório
        </button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {feedbacks.map((item) => (
          <div
            key={item.id}
            className="bg-white p-4 rounded-xl border border-slate-200 shadow-sm hover:shadow-md transition-all"
          >
            <div className="flex items-start justify-between mb-3">
              <span
                className={`px-2 py-1 rounded text-[10px] font-bold uppercase tracking-wide ${item.feature === 'term_planning' ? 'bg-blue-100 text-blue-700' : 'bg-amber-100 text-amber-700'}`}
              >
                {item.feature === 'term_planning' ? 'Planejamento Trimestral' : 'Plano de Aula'}
              </span>
              <span className="text-xs text-slate-400 font-mono">
                {new Date(item.created_at).toLocaleDateString()}
              </span>
            </div>

            <div className="mb-3">
              <p className="text-xs font-bold text-slate-400 uppercase mb-1">Contexto</p>
              <p className="text-xs text-slate-600 truncate" title={item.original_content_summary}>
                {item.original_content_summary || 'N/A'}
              </p>
            </div>

            <div>
              <div className="flex items-center gap-2 mb-1">
                <MessageSquare size={14} className="text-indigo-500" />
                <p className="text-xs font-bold text-indigo-900 uppercase">
                  Solicitação de Ajuste (Feedback)
                </p>
              </div>
              <div className="bg-slate-50 p-3 rounded-lg border border-slate-100 text-sm text-slate-700 italic">
                "{item.feedback_text}"
              </div>
            </div>
          </div>
        ))}

        {feedbacks.length === 0 && (
          <div className="col-span-full p-10 text-center bg-slate-50 rounded-2xl border border-dashed border-slate-300 text-slate-400">
            <AlertTriangle className="mx-auto mb-2 opacity-50" />
            Nenhum feedback registrado ainda.
          </div>
        )}
      </div>
    </div>
  );
};
