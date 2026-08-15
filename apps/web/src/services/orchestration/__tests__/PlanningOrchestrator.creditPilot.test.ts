import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

const mocks = vi.hoisted(() => ({
  executeWithCreditCheck: vi.fn(),
  generateTermPlan: vi.fn(),
  publish: vi.fn(),
}));

vi.mock('../../credit', () => ({
  creditManager: {
    executeWithCreditCheck: mocks.executeWithCreditCheck,
  },
}));

vi.mock('../../ai/AiPlanningService', () => ({
  generateTermPlan: mocks.generateTermPlan,
}));

vi.mock('../EventBus', () => ({
  eventBus: {
    publish: mocks.publish,
  },
}));

import { executeTermPlanning } from '../PlanningOrchestrator';
import type { PlanningIntent } from '../../PlanningAuthorityService';

const intent: PlanningIntent = {
  subject: 'História',
  grade: '1º Ano EM',
  level: 'Ensino Médio',
  period: 1,
  regime: 'Trimestre',
  teacherName: 'Professor',
  stateBase: 'Minas Gerais',
  educationSphere: 'Estadual',
  totalClasses: 24,
  reserves: {},
  userId: 'user-1',
};

describe('PlanningOrchestrator - Lote 1.3B.3 pilot gate', () => {
  beforeEach(() => {
    vi.resetAllMocks();
    vi.stubEnv('VITE_GOVERNED_TERM_PLAN_SAVE', 'false');
    mocks.generateTermPlan.mockResolvedValue('# Plano gerado');
    mocks.executeWithCreditCheck.mockImplementation(
      async (_userId: string, fn: () => Promise<string>) => fn()
    );
  });

  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('preserva o CreditManager legado quando o piloto está desligado', async () => {
    const result = await executeTermPlanning(intent);

    expect(result).toBe('# Plano gerado');
    expect(mocks.executeWithCreditCheck).toHaveBeenCalledTimes(1);
    expect(mocks.executeWithCreditCheck).toHaveBeenCalledWith(
      'user-1',
      expect.any(Function),
      'term_plan'
    );
    expect(mocks.generateTermPlan).toHaveBeenCalledTimes(1);
  });

  it('gera sem check/débito legado quando o piloto governado está habilitado', async () => {
    vi.stubEnv('VITE_GOVERNED_TERM_PLAN_SAVE', 'true');

    const result = await executeTermPlanning(intent);

    expect(result).toBe('# Plano gerado');
    expect(mocks.executeWithCreditCheck).not.toHaveBeenCalled();
    expect(mocks.generateTermPlan).toHaveBeenCalledTimes(1);
    expect(mocks.publish).toHaveBeenCalledWith(
      'planning:generated',
      expect.objectContaining({ userId: 'user-1', text: '# Plano gerado' })
    );
  });
});
