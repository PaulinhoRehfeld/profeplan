import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import type { PresentationScript } from '../../../services/ai/AiPresentationService';

const mocks = vi.hoisted(() => ({
  rpc: vi.fn(),
  saveGeneratedContent: vi.fn(),
  saveLessonToMemory: vi.fn(),
}));

vi.mock('../../../services/supabaseClient', () => ({
  supabase: {
    rpc: mocks.rpc,
  },
}));

vi.mock('../../../services/databaseService', () => ({
  saveGeneratedContent: mocks.saveGeneratedContent,
}));

vi.mock('../../../services/supabaseService', () => ({
  saveLessonToMemory: mocks.saveLessonToMemory,
}));

import { savePresentation } from '../PresentationService';

const presentation: PresentationScript = {
  artifactId: 'presentation-artifact-4c',
  title: 'Sociologia e desigualdade',
  subtitle: 'Leitura social do Brasil',
  theme: 'Moderno',
  slides: [
    {
      order: 1,
      type: 'capa',
      title: 'Desigualdade social',
      contentBulletPoints: ['Estratificação', 'Renda', 'Oportunidades'],
      imageSearchQuery: 'desigualdade social Brasil',
      speakerNotes: 'Apresente o problema social.',
    },
    {
      order: 2,
      type: 'infografico',
      title: 'Distribuição de renda',
      infographicDescription: 'Comparação entre grupos de renda.',
      imageSearchQuery: 'distribuição de renda Brasil gráfico',
      speakerNotes: 'Explique a concentração de renda.',
    },
  ],
};

describe('PresentationService - governed consumer save', () => {
  beforeEach(() => {
    vi.resetAllMocks();
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'false');
    mocks.saveLessonToMemory.mockResolvedValue({ data: null, error: null });
    mocks.saveGeneratedContent.mockResolvedValue({ id: 'legacy-generated-id' });
  });

  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('preserva lessons + generated_contents legado com a flag OFF', async () => {
    await expect(savePresentation('user-4c', presentation)).resolves.toBe(true);

    expect(mocks.rpc).not.toHaveBeenCalled();
    expect(mocks.saveLessonToMemory).toHaveBeenCalledTimes(1);
    expect(mocks.saveGeneratedContent).toHaveBeenCalledWith(
      'user-4c',
      'apresentacao',
      'APRESENTAÇÕES',
      presentation.title,
      expect.stringContaining('## Desigualdade social')
    );
  });

  it('usa artifactId como p_artifact_id e não faz write legado com a flag ON', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');
    mocks.rpc.mockResolvedValueOnce({
      data: { saved: true, outcome: 'APPLIED', charged: true, reason: 'CHARGED' },
      error: null,
    });

    await expect(savePresentation('user-4c', presentation)).resolves.toBe(true);

    expect(mocks.rpc).toHaveBeenCalledWith('credit_save_generated_content', {
      p_artifact_id: presentation.artifactId,
      p_type: 'apresentacao',
      p_folder: 'APRESENTAÇÕES',
      p_title: presentation.title,
      p_content: expect.stringContaining('Comparação entre grupos de renda.'),
    });
    expect(mocks.saveGeneratedContent).not.toHaveBeenCalled();
  });

  it('preserva a mesma identidade em retry e edição da mesma apresentação', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');
    mocks.rpc
      .mockResolvedValueOnce({
        data: { saved: true, outcome: 'APPLIED', charged: true, reason: 'CHARGED' },
        error: null,
      })
      .mockResolvedValueOnce({
        data: {
          saved: true,
          outcome: 'NO_CHARGE',
          charged: false,
          reason: 'EXISTING_ARTIFACT_EDIT',
        },
        error: null,
      });

    await savePresentation('user-4c', presentation);
    await savePresentation('user-4c', { ...presentation, title: 'Sociologia e desigualdade — revisada' });

    expect(mocks.rpc).toHaveBeenCalledTimes(2);
    expect(mocks.rpc.mock.calls[0][1].p_artifact_id).toBe(presentation.artifactId);
    expect(mocks.rpc.mock.calls[1][1].p_artifact_id).toBe(presentation.artifactId);
  });

  it('não confirma memória auxiliar nem write legado quando há insuficiência', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');
    mocks.rpc.mockResolvedValueOnce({
      data: {
        saved: false,
        outcome: 'REJECTED',
        charged: false,
        reason: 'INSUFFICIENT_CREDITS',
      },
      error: null,
    });

    await expect(savePresentation('user-4c', presentation)).rejects.toThrow(
      'Créditos insuficientes'
    );

    expect(mocks.saveLessonToMemory).not.toHaveBeenCalled();
    expect(mocks.saveGeneratedContent).not.toHaveBeenCalled();
  });

  it('não cai silenciosamente para generated_contents direto quando o RPC falha', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');
    mocks.rpc.mockResolvedValueOnce({ data: null, error: { message: 'rpc unavailable' } });

    await expect(savePresentation('user-4c', presentation)).rejects.toMatchObject({
      message: 'rpc unavailable',
    });

    expect(mocks.saveGeneratedContent).not.toHaveBeenCalled();
    expect(mocks.saveLessonToMemory).not.toHaveBeenCalled();
  });

  it('reutiliza o mesmo artifactId ao tentar novamente após falha do RPC', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');
    mocks.rpc
      .mockResolvedValueOnce({ data: null, error: { message: 'rpc unavailable' } })
      .mockResolvedValueOnce({
        data: { saved: true, outcome: 'APPLIED', charged: true, reason: 'CHARGED' },
        error: null,
      });

    await expect(savePresentation('user-4c', presentation)).rejects.toMatchObject({
      message: 'rpc unavailable',
    });
    await expect(savePresentation('user-4c', presentation)).resolves.toBe(true);

    expect(mocks.rpc).toHaveBeenCalledTimes(2);
    expect(mocks.rpc.mock.calls[0][1].p_artifact_id).toBe(presentation.artifactId);
    expect(mocks.rpc.mock.calls[1][1].p_artifact_id).toBe(presentation.artifactId);
    expect(mocks.saveGeneratedContent).not.toHaveBeenCalled();
  });

  it('aceita Gold/NO_CHARGE como Save canônico', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');
    mocks.rpc.mockResolvedValueOnce({
      data: { saved: true, outcome: 'NO_CHARGE', charged: false, reason: 'GOLD_UNLIMITED' },
      error: null,
    });

    await expect(savePresentation('user-4c', presentation)).resolves.toBe(true);
    expect(mocks.saveGeneratedContent).not.toHaveBeenCalled();
    expect(mocks.saveLessonToMemory).toHaveBeenCalledTimes(1);
  });

  it('falha da memória auxiliar não invalida um Save canônico já commitado', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');
    mocks.rpc.mockResolvedValueOnce({
      data: { saved: true, outcome: 'APPLIED', charged: true, reason: 'CHARGED' },
      error: null,
    });
    mocks.saveLessonToMemory.mockRejectedValueOnce(new Error('lessons unavailable'));

    await expect(savePresentation('user-4c', presentation)).resolves.toBe(true);

    expect(mocks.rpc).toHaveBeenCalledTimes(1);
    expect(mocks.saveGeneratedContent).not.toHaveBeenCalled();
  });
});
