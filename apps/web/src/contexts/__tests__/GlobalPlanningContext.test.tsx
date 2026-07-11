import React from 'react';
import { render, waitFor } from '@testing-library/react';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { GlobalPlanningProvider, useGlobalPlanning } from '../GlobalPlanningContext';
import type { TermPlan } from '../../types';

const getSessionMock = vi.fn();

vi.mock('../../services/supabaseClient', () => ({
  supabase: {
    auth: {
      getSession: () => getSessionMock(),
      onAuthStateChange: vi.fn(() => ({
        data: { subscription: { unsubscribe: vi.fn() } },
      })),
    },
  },
}));

const serviceFetchTermPlansMock = vi.fn();

vi.mock('../../features/TermPlanning/TermPlanningService', () => ({
  fetchTermPlans: (...args: any[]) => serviceFetchTermPlansMock(...args),
}));

describe('GlobalPlanningContext - refreshTermPlans -> termPlans', () => {
  beforeEach(() => {
    vi.resetAllMocks();
    localStorage.clear();
    (globalThis as any).__lastPlanningContext = undefined;
  });

  it('resolve userId via sessao e hidrata termPlans com resultado do service', async () => {
    const userId = 'user-ctx-1';

    getSessionMock.mockResolvedValue({
      data: {
        session: {
          user: { id: userId },
        },
      },
    });

    const plansFromService: TermPlan[] = [
      {
        id: 'plan-ctx-1',
        created_at: new Date().toISOString(),
        period: 1,
        regime: 'Trimestre',
        subject: 'Geografia',
        grade: '8 Ano',
        level: 'Ensino Fundamental',
        workloadWeekly: 2,
        reserves: { monthlyExam: true, termExam: true, recovery: false },
        totalClasses: 24,
        gradingGrid: { vistos: 5, trabalhos: 5, monthlyExam: 10, termExam: 10, others: 0 },
        stateBase: 'Minas Gerais',
        educationSphere: 'Estadual',
        generatedText: '# Planejamento Geografia',
        lessons: [],
      },
    ];

    serviceFetchTermPlansMock.mockResolvedValue(plansFromService);

    const TestConsumer: React.FC = () => {
      const ctx = useGlobalPlanning();
      (globalThis as any).__lastPlanningContext = ctx;
      return null;
    };

    render(
      <GlobalPlanningProvider>
        <TestConsumer />
      </GlobalPlanningProvider>,
    );

    await waitFor(() => {
      const ctx = (globalThis as any).__lastPlanningContext as ReturnType<typeof useGlobalPlanning>;
      expect(serviceFetchTermPlansMock).toHaveBeenCalledWith(userId);
      expect(ctx.termPlans).toHaveLength(1);
      expect(ctx.termPlans[0].subject).toBe('Geografia');
    });
  });

  it('regressão — refreshTermPlans mantém a mesma referência entre renders (evita loop infinito de useEffect)', async () => {
    // TermPlanningList.tsx/PlanningManager.tsx colocam refreshTermPlans em deps de
    // useEffect. Sem useCallback, cada chamada (que atualiza termPlans) recriava a
    // função, o que disparava o efeito de novo, para sempre — reproduzido em
    // produção como um loop de "Calling serviceFetchTermPlans" sem parar.
    const userId = 'user-ctx-stability';
    getSessionMock.mockResolvedValue({ data: { session: { user: { id: userId } } } });
    serviceFetchTermPlansMock.mockResolvedValue([]);

    const seenRefs: Array<() => Promise<void>> = [];
    const TestConsumer: React.FC = () => {
      const ctx = useGlobalPlanning();
      seenRefs.push(ctx.refreshTermPlans as any);
      return null;
    };

    render(
      <GlobalPlanningProvider>
        <TestConsumer />
      </GlobalPlanningProvider>,
    );

    await waitFor(() => expect(serviceFetchTermPlansMock).toHaveBeenCalledWith(userId));

    const stableRef = seenRefs[0];
    // Dispara refreshTermPlans manualmente (o que atualiza termPlans e força um
    // re-render do provider) e confirma que a referência exposta não muda.
    await stableRef(undefined as any);
    await waitFor(() => {
      expect(seenRefs[seenRefs.length - 1]).toBe(stableRef);
    });
  });
});
