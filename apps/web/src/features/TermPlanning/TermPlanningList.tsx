import React, { useEffect } from 'react';
import { ArrowRight, BookOpen, Calendar, Clock } from 'lucide-react';
import { useGlobalPlanning } from '../../contexts/GlobalPlanningContext';
import { Card, Feedback } from '../../components/ui';
import type { TermPlan } from '../../types';

interface TermPlanningListProps {
  userId?: string;
  onOpenPlan?: (plan: TermPlan) => void;
}

const TermPlanningList: React.FC<TermPlanningListProps> = ({ userId, onOpenPlan }) => {
  const { termPlans, updateCurrentPlan, refreshTermPlans } = useGlobalPlanning();

  useEffect(() => {
    refreshTermPlans(userId).catch((error) => {
      console.error('Erro ao carregar planejamentos:', error);
    });
  }, [userId, refreshTermPlans]);

  const handleOpenPlan = (plan: TermPlan) => {
    updateCurrentPlan(plan);
    onOpenPlan?.(plan);
  };

  if (!termPlans.length) {
    return (
      <Feedback
        variant="empty"
        title="Nenhum planejamento trimestral salvo"
        description="Preencha os dados abaixo, gere seu primeiro planejamento e salve para encontrá-lo aqui."
      />
    );
  }

  return (
    <Card as="section" aria-labelledby="saved-term-plans-title" className="p-5 sm:p-6">
      <div className="flex flex-col gap-3 border-b border-slate-200 pb-4 sm:flex-row sm:items-start sm:justify-between">
        <div className="flex items-start gap-3">
          <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-blue-50 text-blue-700">
            <BookOpen aria-hidden="true" className="h-5 w-5" />
          </span>
          <div>
            <h2 id="saved-term-plans-title" className="text-lg font-semibold text-slate-950">
              Planejamentos salvos
            </h2>
            <p className="mt-1 text-sm leading-5 text-slate-600">
              Abra um planejamento para revisar, editar ou gerar uma nova versão.
            </p>
          </div>
        </div>
        <span className="w-fit rounded-full bg-slate-100 px-3 py-1 text-sm font-medium text-slate-700">
          {termPlans.length} plano{termPlans.length > 1 ? 's' : ''}
        </span>
      </div>

      <ul className="mt-2 divide-y divide-slate-200" aria-label="Planejamentos trimestrais salvos">
        {termPlans.map((plan) => {
          const periodLabel = `${plan.period}º ${plan.regime}`;
          const lessonsCount = plan.lessons?.length ?? 0;
          const createdAt = plan.created_at
            ? new Date(plan.created_at).toLocaleDateString('pt-BR')
            : '';
          const accessibleName = `Abrir ${periodLabel} de ${plan.subject}, ${plan.grade}`;

          return (
            <li key={plan.id}>
              <button
                type="button"
                onClick={() => handleOpenPlan(plan)}
                className="ui-focus-ring ui-reduce-motion group flex min-h-16 w-full items-center justify-between gap-4 rounded-lg px-2 py-4 text-left transition-colors hover:bg-blue-50/60 sm:px-3"
                aria-label={accessibleName}
              >
                <span className="flex min-w-0 items-start gap-3">
                  <span className="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-blue-50 text-blue-700">
                    <Calendar aria-hidden="true" className="h-5 w-5" />
                  </span>
                  <span className="min-w-0">
                    <span className="block truncate text-base font-semibold text-slate-900">
                      {periodLabel} · {plan.subject} ({plan.grade})
                    </span>
                    <span className="mt-1 flex flex-wrap items-center gap-x-3 gap-y-1 text-sm text-slate-600">
                      <span className="inline-flex items-center gap-1.5">
                        <Clock aria-hidden="true" className="h-4 w-4" />
                        {lessonsCount
                          ? `${lessonsCount} aula${lessonsCount > 1 ? 's' : ''}`
                          : 'Nenhuma aula definida'}
                      </span>
                      {createdAt && <span>Atualizado em {createdAt}</span>}
                    </span>
                  </span>
                </span>
                <span className="inline-flex shrink-0 items-center gap-1 text-sm font-semibold text-blue-700">
                  <span className="hidden sm:inline">Abrir</span>
                  <ArrowRight
                    aria-hidden="true"
                    className="h-5 w-5 transition-transform group-hover:translate-x-0.5 ui-reduce-motion"
                  />
                </span>
              </button>
            </li>
          );
        })}
      </ul>
    </Card>
  );
};

export default TermPlanningList;
