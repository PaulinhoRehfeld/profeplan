import { describe, it, expect, vi, beforeEach } from 'vitest';
import { saveTermPlan, fetchTermPlans } from '../TermPlanningService';
import type { TermPlan } from '../../../types';

// Mock Supabase client
const upsertMock = vi.fn();
const selectMock = vi.fn();
const singleMock = vi.fn();
const fromMock = vi.fn();

const selectChain = (...args: any[]) => {
  selectMock(...args);
  return { single: singleMock };
};

vi.mock('../../../services/supabaseClient', () => ({
  supabase: {
    from: (table: string) => fromMock(table),
  },
}));

// Helper to stub supabase.from().upsert/select/single and .select/eq/order for fetch
fromMock.mockImplementation((table: string) => {
  if (table === 'term_plans') {
    return {
      upsert: (...args: any[]) => {
        upsertMock(...args);
        return { select: selectChain };
      },
      select: (...args: any[]) => {
        selectMock(table, ...args);
        return {
          eq: () => ({
            order: () => ({
              then: () => {},
            }),
          }),
        } as any;
      },
    } as any;
  }
  if (table === 'generated_contents') {
    return {
      select: (...args: any[]) => {
        selectMock(table, ...args);
        return {
          eq: () => ({
            eq: () => ({
              order: () => ({
                then: () => {},
              }),
            }),
          }),
        } as any;
      },
    } as any;
  }
  return {} as any;
});

describe('TermPlanningService - saveTermPlan & fetchTermPlans', () => {
  const userId = 'user-1';
  const basePlan: TermPlan = {
    id: 'plan-1',
    created_at: new Date().toISOString(),
    period: 1,
    regime: 'Trimestre',
    subject: 'História',
    grade: '1º Ano',
    level: 'Ensino Médio',
    workloadWeekly: 2,
    reserves: { monthlyExam: true, termExam: true, recovery: false },
    totalClasses: 24,
    gradingGrid: { vistos: 5, trabalhos: 5, monthlyExam: 10, termExam: 10, others: 0 },
    stateBase: 'Minas Gerais',
    educationSphere: 'Estadual',
    generatedText: '# Planejamento',
    lessons: [
      {
        title: 'Aula 1',
        objectives: ['Objetivo 1'],
        bncc: ['EF09HI01'],
      },
    ],
  };

  beforeEach(() => {
    vi.resetAllMocks();
    // Mock básico de localStorage para ambiente node
    (globalThis as any).localStorage = {
      store: {} as Record<string, string>,
      getItem(key: string) {
        return this.store[key] ?? null;
      },
      setItem(key: string, value: string) {
        this.store[key] = value;
      },
      removeItem(key: string) {
        delete this.store[key];
      },
      clear() {
        this.store = {};
      },
    };
    (globalThis as any).localStorage.clear();
  });

  it('salva TermPlan em localStorage (mesmo se Supabase falhar)', async () => {
    singleMock.mockRejectedValueOnce(new Error('supabase indisponível'));

    const result = await saveTermPlan(basePlan, userId);

    expect(result.userId).toBe(userId);

    const stored = JSON.parse(
      localStorage.getItem('profeplan_term_plans') || '[]',
    ) as TermPlan[];
    expect(stored).toHaveLength(1);
    expect(stored[0].id).toBe('plan-1');
    expect(stored[0].lessons?.length).toBe(1);

    // Mesmo com erro de Supabase, não deve quebrar.
  });

  it('mergeia planos vindos de term_plans com fallback vazio quando Supabase retorna erro', async () => {
    // Simula erro em select de term_plans
    fromMock.mockImplementationOnce(() => ({
      select: () => ({
        eq: () => ({
          order: () => ({ data: null, error: { message: 'erro' } }),
        }),
      }),
    }));

    const plans = await fetchTermPlans(userId);
    expect(Array.isArray(plans)).toBe(true);
  });
});

