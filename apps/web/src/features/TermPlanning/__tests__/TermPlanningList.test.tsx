import React from 'react';
import { cleanup, fireEvent, render, screen, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom/vitest';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import type { TermPlan } from '../../../types';
import TermPlanningList from '../TermPlanningList';

const refreshTermPlans = vi.fn();
const updateCurrentPlan = vi.fn();
let termPlans: TermPlan[] = [];

vi.mock('../../../contexts/GlobalPlanningContext', () => ({
  useGlobalPlanning: () => ({
    termPlans,
    refreshTermPlans,
    updateCurrentPlan,
  }),
}));

const savedPlan: TermPlan = {
  id: 'term-plan-1',
  created_at: '2026-07-16T12:00:00.000Z',
  period: 2,
  regime: 'Trimestre',
  subject: 'História',
  grade: '8º ano',
  level: 'Ensino Fundamental',
  workloadWeekly: 2,
  reserves: { monthlyExam: true, termExam: true, recovery: false },
  totalClasses: 24,
  gradingGrid: { vistos: 5, trabalhos: 5, monthlyExam: 10, termExam: 10, others: 0 },
  stateBase: 'Minas Gerais',
  educationSphere: 'Estadual',
  generatedText: '# Planejamento',
  lessons: [],
};

describe('TermPlanningList', () => {
  beforeEach(() => {
    termPlans = [];
    refreshTermPlans.mockReset().mockResolvedValue(undefined);
    updateCurrentPlan.mockReset();
  });

  afterEach(cleanup);

  it('carrega os planejamentos do usuário e orienta o primeiro uso', async () => {
    render(<TermPlanningList userId="teacher-1" />);

    expect(screen.getByRole('status')).toHaveTextContent('Nenhum planejamento trimestral salvo');
    await waitFor(() => expect(refreshTermPlans).toHaveBeenCalledWith('teacher-1'));
  });

  it('exibe um planejamento salvo com nome acessível', () => {
    termPlans = [savedPlan];
    render(<TermPlanningList userId="teacher-1" />);

    expect(
      screen.getByRole('button', {
        name: 'Abrir 2º Trimestre de História, 8º ano',
      })
    ).toBeInTheDocument();
    expect(screen.getByText('Nenhuma aula definida')).toBeInTheDocument();
  });

  it('preserva atualização do plano atual e callback de abertura', () => {
    const onOpenPlan = vi.fn();
    termPlans = [savedPlan];
    render(<TermPlanningList userId="teacher-1" onOpenPlan={onOpenPlan} />);

    fireEvent.click(screen.getByRole('button', { name: /Abrir 2º Trimestre de História/i }));

    expect(updateCurrentPlan).toHaveBeenCalledWith(savedPlan);
    expect(onOpenPlan).toHaveBeenCalledWith(savedPlan);
  });
});
