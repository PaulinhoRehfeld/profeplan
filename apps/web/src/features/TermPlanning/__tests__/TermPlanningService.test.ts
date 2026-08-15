import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import { saveTermPlan, fetchTermPlans } from '../TermPlanningService';
import type { TermPlan } from '../../../types';

// Mock Supabase client
const upsertMock = vi.fn();
const selectMock = vi.fn();
const singleMock = vi.fn();
const rpcMock = vi.fn();
const fromMock = vi.fn();

const selectChain = (...args: any[]) => {
  selectMock(...args);
  return { single: singleMock };
};

vi.mock('../../../services/supabaseClient', () => ({
  supabase: {
    from: (table: string) => fromMock(table),
    rpc: (...args: any[]) => rpcMock(...args),
  },
}));

const configureFromMock = () => {
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
};

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
    userId: 'user-1',
    generatedText: '# Planejamento',
    lessons: [
      {
        number: 1,
        description: 'Descrição',
        title: 'Aula 1',
        objectives: ['Objetivo 1'],
        bncc: ['EF09HI01'],
      },
    ],
  };

  beforeEach(() => {
    vi.resetAllMocks();
    configureFromMock();
    vi.stubEnv('VITE_GOVERNED_TERM_PLAN_SAVE', 'false');

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

  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('mantém o caminho legado por padrão e salva no localStorage mesmo se Supabase falhar', async () => {
    singleMock.mockRejectedValueOnce(new Error('supabase indisponível'));

    const result = await saveTermPlan(basePlan, userId);

    expect(result.userId).toBe(userId);
    expect(rpcMock).not.toHaveBeenCalled();

    const stored = JSON.parse(
      localStorage.getItem(`profeplan_term_plans:${userId}`) || '[]'
    ) as TermPlan[];
    expect(stored).toHaveLength(1);
    expect(stored[0].id).toBe('plan-1');
    expect(stored[0].lessons?.length).toBe(1);
  });

  it('usa exclusivamente o RPC governado para plano gerado quando o piloto está habilitado', async () => {
    vi.stubEnv('VITE_GOVERNED_TERM_PLAN_SAVE', 'true');
    rpcMock.mockResolvedValueOnce({
      data: {
        saved: true,
        outcome: 'APPLIED',
        reason: 'CHARGED',
        charged: true,
        balance_after: 1,
        operation_id: 'server-derived-operation',
        plan_id: 'plan-1',
      },
      error: null,
    });

    const result = await saveTermPlan(basePlan, userId);

    expect(result.id).toBe('plan-1');
    expect(rpcMock).toHaveBeenCalledWith(
      'credit_save_term_plan',
      expect.objectContaining({
        p_plan_id: 'plan-1',
        p_subject: 'História',
        p_generated_text: '# Planejamento',
      })
    );
    expect(upsertMock).not.toHaveBeenCalled();

    const stored = JSON.parse(
      localStorage.getItem(`profeplan_term_plans:${userId}`) || '[]'
    ) as TermPlan[];
    expect(stored).toHaveLength(1);
    expect(
      localStorage.getItem(`profeplan_term_plan_governed_draft:${userId}:plan-1`)
    ).toBeNull();
  });

  it('preserva rascunho local e não marca como salvo quando o RPC rejeita por falta de crédito', async () => {
    vi.stubEnv('VITE_GOVERNED_TERM_PLAN_SAVE', 'true');
    rpcMock.mockResolvedValueOnce({
      data: {
        saved: false,
        outcome: 'REJECTED',
        reason: 'INSUFFICIENT_CREDITS',
        charged: false,
        balance_after: 0,
      },
      error: null,
    });

    await expect(saveTermPlan(basePlan, userId)).rejects.toThrow('Créditos insuficientes');

    expect(localStorage.getItem(`profeplan_term_plans:${userId}`)).toBeNull();
    const draft = JSON.parse(
      localStorage.getItem(`profeplan_term_plan_governed_draft:${userId}:plan-1`) || '{}'
    ) as TermPlan;
    expect(draft.id).toBe('plan-1');
    expect(draft.generatedText).toBe('# Planejamento');
  });

  it('mantém plano sem conteúdo gerado no caminho legado mesmo com o piloto habilitado', async () => {
    vi.stubEnv('VITE_GOVERNED_TERM_PLAN_SAVE', 'true');
    singleMock.mockResolvedValueOnce({ data: { id: 'plan-1' }, error: null });

    await saveTermPlan({ ...basePlan, generatedText: '' }, userId);

    expect(rpcMock).not.toHaveBeenCalled();
    expect(upsertMock).toHaveBeenCalledTimes(1);
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
