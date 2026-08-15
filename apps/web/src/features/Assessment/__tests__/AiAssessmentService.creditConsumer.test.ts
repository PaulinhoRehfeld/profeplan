import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

const mocks = vi.hoisted(() => ({
  create: vi.fn(),
  checkUsageQuota: vi.fn(),
  incrementUserUsage: vi.fn(),
}));

vi.mock('../../../services/ai/AiCore', () => ({
  GENERATION_MODELS: ['test-model'],
  getGenAIClient: () => ({
    chat: {
      completions: {
        create: mocks.create,
      },
    },
  }),
}));

vi.mock('../../../services/ProfileService', () => ({
  checkUsageQuota: mocks.checkUsageQuota,
  incrementUserUsage: mocks.incrementUserUsage,
}));

import { generateAssessmentWithContext } from '../../../services/ai/AiAssessmentService';

describe('AiAssessmentService - governed consumer generation', () => {
  beforeEach(() => {
    vi.resetAllMocks();
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'false');
    mocks.checkUsageQuota.mockResolvedValue({ allowed: true });
    mocks.incrementUserUsage.mockResolvedValue(undefined);
    mocks.create.mockResolvedValue({
      choices: [
        {
          message: {
            content: JSON.stringify({ title: 'Avaliação gerada', questions: [] }),
          },
        },
      ],
    });
  });

  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('preserva check e incremento legado com a flag OFF', async () => {
    await generateAssessmentWithContext(
      '3º A',
      'Sociologia',
      [],
      '',
      '2º Trimestre',
      5,
      2,
      0,
      'Médio',
      undefined,
      'user-4b'
    );

    expect(mocks.checkUsageQuota).toHaveBeenCalledWith('user-4b');
    expect(mocks.incrementUserUsage).toHaveBeenCalledWith('user-4b', 'generate');
  });

  it('trata geração como NON_BILLABLE com a flag ON', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');

    await generateAssessmentWithContext(
      '3º A',
      'Sociologia',
      [],
      '',
      '2º Trimestre',
      5,
      2,
      0,
      'Médio',
      undefined,
      'user-4b'
    );

    expect(mocks.create).toHaveBeenCalledTimes(1);
    expect(mocks.checkUsageQuota).not.toHaveBeenCalled();
    expect(mocks.incrementUserUsage).not.toHaveBeenCalled();
  });
});
