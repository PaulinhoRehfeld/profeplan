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

import { generatePresentationJSON } from '../../../services/ai/AiPresentationService';

const generatedPayload = {
  title: 'Apresentação gerada',
  subtitle: 'Subtítulo',
  theme: 'Moderno',
  slides: [
    {
      order: 1,
      type: 'capa',
      title: 'Introdução',
      contentBulletPoints: ['Ponto 1'],
      imageSearchQuery: 'imagem educativa',
      speakerNotes: 'Apresente o tema.',
    },
  ],
};

describe('AiPresentationService - governed consumer generation', () => {
  beforeEach(() => {
    vi.resetAllMocks();
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'false');
    mocks.checkUsageQuota.mockResolvedValue({ allowed: true });
    mocks.incrementUserUsage.mockResolvedValue(undefined);
    mocks.create.mockResolvedValue({
      choices: [
        {
          message: {
            content: JSON.stringify(generatedPayload),
          },
        },
      ],
    });
  });

  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('preserva check e incremento legado com a flag OFF', async () => {
    const result = await generatePresentationJSON('Sociologia', '', 8, 'Moderno', true, 'user-4c');

    expect(mocks.checkUsageQuota).toHaveBeenCalledWith('user-4c');
    expect(mocks.incrementUserUsage).toHaveBeenCalledWith('user-4c', 'generate');
    expect(result.artifactId).toEqual(expect.any(String));
    expect(result.artifactId.length).toBeGreaterThan(0);
  });

  it('trata geração como NON_BILLABLE com a flag ON e ainda cria identidade estável', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');

    const result = await generatePresentationJSON('Sociologia', '', 8, 'Moderno', true, 'user-4c');

    expect(mocks.create).toHaveBeenCalledTimes(1);
    expect(mocks.checkUsageQuota).not.toHaveBeenCalled();
    expect(mocks.incrementUserUsage).not.toHaveBeenCalled();
    expect(result.artifactId).toEqual(expect.any(String));
    expect(result.artifactId.length).toBeGreaterThan(0);
  });

  it('atribui nova identidade a uma nova geração, sem pedir artifactId ao modelo', async () => {
    const first = await generatePresentationJSON('Tema 1', '', 5, 'Moderno', false);
    const second = await generatePresentationJSON('Tema 2', '', 5, 'Moderno', false);

    expect(first.artifactId).not.toBe(second.artifactId);
    expect(generatedPayload).not.toHaveProperty('artifactId');
  });
});
