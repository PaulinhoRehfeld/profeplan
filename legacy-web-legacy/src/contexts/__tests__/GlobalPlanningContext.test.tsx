import React from 'react';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { act } from 'react';
import { GlobalPlanningProvider, useGlobalPlanning } from '../GlobalPlanningContext';
import type { TermPlan } from '../../types';

// Mock do supabase para controle de sessão
const getSessionMock = vi.fn();

vi.mock('../../services/supabaseClient', () => ({
  supabase: {
    auth: {
      getSession: () => getSessionMock(),
    },
  },
}));

// Mock do service de fetch de planos
const serviceFetchTermPlansMock = vi.fn();

vi.mock('../../features/TermPlanning/TermPlanningService', () => ({
  fetchTermPlans: (...args: any[]) => serviceFetchTermPlansMock(...args),
}));

describe('GlobalPlanningContext - refreshTermPlans → termPlans', () => {
  beforeEach(() => {
    vi.resetAllMocks();
  });

  it('resolve userId via sessão e hidrata termPlans com resultado do service', async () => {
    const userId = 'user-ctx-1';

    // Sessão simulada
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
        grade: '8º Ano',
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

    serviceFetchTermPlansMock.mockResolvedValueOnce(plansFromService);

    const TestConsumer: React.FC = () => {
      const ctx = useGlobalPlanning();
      (globalThis as any).__lastPlanningContext = ctx;
      return null;
    };



    const { render } = require('@testing-library/react');

    render(
      <GlobalPlanningProvider>
        <TestConsumer />
      </GlobalPlanningProvider>
    );

    const ctx = (globalThis as any).__lastPlanningContext as ReturnType<typeof useGlobalPlanning>;

    expect(ctx.termPlans).toEqual([]);

    await act(async () => {
      await ctx.refreshTermPlans();
    });

    expect(serviceFetchTermPlansMock).toHaveBeenCalledWith(userId);
    expect(ctx.termPlans).toHaveLength(1);
    expect(ctx.termPlans[0].subject).toBe('Geografia');
  });
});

