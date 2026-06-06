import React, { useEffect } from 'react';
import { useGlobalPlanning } from '../../contexts/GlobalPlanningContext';
import { Calendar, BookOpen, Clock, ArrowRight } from 'lucide-react';
import type { TermPlan } from '../../types';

interface TermPlanningListProps {
  userId?: string;
  onOpenPlan?: (plan: TermPlan) => void;
}

const TermPlanningList: React.FC<TermPlanningListProps> = ({ userId, onOpenPlan }) => {
  const { termPlans, updateCurrentPlan, refreshTermPlans } = useGlobalPlanning();

  useEffect(() => {
    refreshTermPlans(userId).catch((err) => {
      console.error('Erro ao carregar planejamentos:', err);
    });
  }, [userId, refreshTermPlans]);

  const handleOpenPlan = (plan: TermPlan) => {
    updateCurrentPlan(plan);
    if (onOpenPlan) {
      onOpenPlan(plan);
    }
  };

  if (!termPlans.length) {
    return (
      <div className="bg-white rounded-3xl border border-slate-100 p-6 text-center text-slate-400 text-sm">
        Nenhum planejamento trimestral encontrado ainda. Salve um plano para vê-lo aqui.
      </div>
    );
  }

  return (
    <div className="bg-white rounded-3xl border border-slate-100 p-4 md:p-6 space-y-4">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-3 text-blue-600">
          <BookOpen className="w-5 h-5" />
          <div>
            <h2 className="text-xs font-black uppercase tracking-[0.2em]">Meus Planejamentos Trimestrais</h2>
            <p className="text-[11px] text-slate-500 font-medium">
              Reabra e edite planejamentos já salvos com um clique.
            </p>
          </div>
        </div>
        <span className="text-[11px] font-bold text-slate-400 uppercase tracking-[0.2em]">
          {termPlans.length} plano{termPlans.length > 1 ? 's' : ''}
        </span>
      </div>

      <div className="divide-y divide-slate-100">
        {termPlans.map((plan) => {
          const periodLabel = `${plan.period}º ${plan.regime}`;
          const lessonsCount = plan.lessons?.length ?? 0;
          const createdAt = plan.created_at
            ? new Date(plan.created_at).toLocaleDateString('pt-BR')
            : '';

          return (
            <button
              key={plan.id}
              onClick={() => handleOpenPlan(plan)}
              className="w-full text-left py-3 px-3 rounded-2xl hover:bg-slate-50 flex items-center justify-between gap-4 transition-colors"
            >
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-blue-50 flex items-center justify-center text-blue-600">
                  <Calendar className="w-5 h-5" />
                </div>
                <div className="space-y-0.5">
                  <p className="text-sm font-black text-slate-800 truncate">
                    {periodLabel} · {plan.subject} ({plan.grade})
                  </p>
                  <div className="flex flex-wrap items-center gap-2 text-[11px] text-slate-500 font-semibold uppercase tracking-[0.12em]">
                    <span className="flex items-center gap-1">
                      <Clock className="w-3 h-3" />
                      {lessonsCount
                        ? `${lessonsCount} aula${lessonsCount > 1 ? 's' : ''}`
                        : '0 aulas definidas'}
                    </span>
                    {createdAt && (
                      <span className="px-2 py-0.5 rounded-full bg-slate-100 text-slate-500">
                        Atualizado em {createdAt}
                      </span>
                    )}
                  </div>
                </div>
              </div>
              <div className="flex items-center gap-2 text-[11px] font-black text-blue-600 uppercase tracking-[0.18em]">
                Abrir
                <ArrowRight className="w-4 h-4" />
              </div>
            </button>
          );
        })}
      </div>
    </div>
  );
};

export default TermPlanningList;

