import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import type { Assessment } from '../../../types';

const mocks = vi.hoisted(() => ({
  rpc: vi.fn(),
  from: vi.fn(),
  generatedInsert: vi.fn(),
  lessonInsert: vi.fn(),
  logEventForClass: vi.fn(),
}));

vi.mock('../../../services/supabaseClient', () => ({
  supabase: {
    rpc: mocks.rpc,
    from: mocks.from,
  },
}));

vi.mock('../../../services/pdi/PdiDocumentService', () => ({
  PdiDocumentService: {
    logEventForClass: mocks.logEventForClass,
  },
}));

import { saveAssessment } from '../AssessmentService';

const assessment: Assessment = {
  id: 'assessment_1786765000000',
  title: 'Avaliação de Sociologia',
  classId: 'class-1',
  className: '3º A',
  subject: 'Sociologia',
  questions: [
    {
      id: 'q1',
      type: 'objective',
      question: 'Questão 1',
      options: ['A) A', 'B) B', 'C) C', 'D) D', 'E) E'],
      correctAnswer: 'A',
      maxPoints: 10,
    },
  ],
  createdAt: '2026-08-15T10:00:00.000Z',
  totalPoints: 10,
  academicPeriod: '2º Trimestre (P1)',
};

const configureFromMock = () => {
  mocks.generatedInsert.mockResolvedValue({ error: null });
  mocks.lessonInsert.mockResolvedValue({ error: null });
  mocks.from.mockImplementation((table: string) => {
    if (table === 'generated_contents') return { insert: mocks.generatedInsert };
    if (table === 'lessons') return { insert: mocks.lessonInsert };
    return {};
  });
};

const flushBackground = async () => {
  await Promise.resolve();
  await Promise.resolve();
};

describe('AssessmentService - governed consumer save', () => {
  beforeEach(() => {
    vi.resetAllMocks();
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'false');
    configureFromMock();
    mocks.logEventForClass.mockResolvedValue(undefined);

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
  });

  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('preserva local-first e insert direto legado com a flag OFF', async () => {
    await expect(saveAssessment('user-4b', assessment)).resolves.toBe(true);
    await flushBackground();

    expect(mocks.rpc).not.toHaveBeenCalled();
    expect(mocks.from).toHaveBeenCalledWith('generated_contents');
    expect(mocks.generatedInsert).toHaveBeenCalledWith(
      expect.objectContaining({
        user_id: 'user-4b',
        type: 'avaliacao',
        folder: 'AVALIAÇÕES',
        title: assessment.title,
      })
    );

    const local = JSON.parse(
      localStorage.getItem('profeplan_assessments:user-4b') || '[]'
    ) as Assessment[];
    expect(local).toEqual([assessment]);
  });

  it('usa assessment.id como artifact_id e não faz write legado com a flag ON', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');
    mocks.rpc.mockResolvedValueOnce({
      data: { saved: true, outcome: 'APPLIED', charged: true, reason: 'CHARGED' },
      error: null,
    });

    await expect(saveAssessment('user-4b', assessment)).resolves.toBe(true);

    expect(mocks.rpc).toHaveBeenCalledWith('credit_save_generated_content', {
      p_artifact_id: assessment.id,
      p_type: 'avaliacao',
      p_folder: 'AVALIAÇÕES',
      p_title: assessment.title,
      p_content: expect.stringContaining('# Avaliação de Sociologia'),
      p_created_at: assessment.createdAt,
    });
    expect(mocks.generatedInsert).not.toHaveBeenCalled();
  });

  it('preserva a mesma identidade em retry e edição do mesmo Assessment', async () => {
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

    await saveAssessment('user-4b', assessment);
    await saveAssessment('user-4b', { ...assessment, title: 'Avaliação de Sociologia — revisada' });

    expect(mocks.rpc).toHaveBeenCalledTimes(2);
    expect(mocks.rpc.mock.calls[0][1].p_artifact_id).toBe(assessment.id);
    expect(mocks.rpc.mock.calls[1][1].p_artifact_id).toBe(assessment.id);
  });

  it('não confirma Save local nem memória auxiliar quando há insuficiência', async () => {
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

    await expect(saveAssessment('user-4b', assessment)).rejects.toThrow('Créditos insuficientes');

    expect(localStorage.getItem('profeplan_assessments:user-4b')).toBeNull();
    expect(mocks.lessonInsert).not.toHaveBeenCalled();
    expect(mocks.logEventForClass).not.toHaveBeenCalled();
  });

  it('não cai silenciosamente para generated_contents direto quando o RPC falha', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');
    mocks.rpc.mockResolvedValueOnce({ data: null, error: { message: 'rpc unavailable' } });

    await expect(saveAssessment('user-4b', assessment)).rejects.toMatchObject({
      message: 'rpc unavailable',
    });

    expect(mocks.generatedInsert).not.toHaveBeenCalled();
    expect(localStorage.getItem('profeplan_assessments:user-4b')).toBeNull();
  });

  it('aceita Gold/NO_CHARGE como Save canônico sem caminho alternativo', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');
    mocks.rpc.mockResolvedValueOnce({
      data: { saved: true, outcome: 'NO_CHARGE', charged: false, reason: 'GOLD_UNLIMITED' },
      error: null,
    });

    await expect(saveAssessment('user-4b', assessment)).resolves.toBe(true);
    expect(mocks.generatedInsert).not.toHaveBeenCalled();
  });

  it('falha da memória auxiliar não invalida um Save canônico já commitado', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');
    mocks.rpc.mockResolvedValueOnce({
      data: { saved: true, outcome: 'APPLIED', charged: true, reason: 'CHARGED' },
      error: null,
    });
    mocks.lessonInsert.mockRejectedValueOnce(new Error('lessons unavailable'));
    mocks.logEventForClass.mockRejectedValueOnce(new Error('pdi unavailable'));

    await expect(saveAssessment('user-4b', assessment)).resolves.toBe(true);

    const local = JSON.parse(
      localStorage.getItem('profeplan_assessments:user-4b') || '[]'
    ) as Assessment[];
    expect(local).toEqual([assessment]);
    expect(mocks.rpc).toHaveBeenCalledTimes(1);
  });
});
