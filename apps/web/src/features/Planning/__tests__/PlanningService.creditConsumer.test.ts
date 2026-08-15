import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

const mocks = vi.hoisted(() => ({
  rpc: vi.fn(),
  from: vi.fn(),
  checkUsageQuota: vi.fn(),
  incrementUserUsage: vi.fn(),
  logEventForClass: vi.fn(),
}));

vi.mock('../../../services/supabaseClient', () => ({
  supabase: {
    rpc: mocks.rpc,
    from: mocks.from,
  },
}));

vi.mock('../../../services/ProfileService', () => ({
  checkUsageQuota: mocks.checkUsageQuota,
  incrementUserUsage: mocks.incrementUserUsage,
}));

vi.mock('../../../services/pdi/PdiDocumentService', () => ({
  PdiDocumentService: {
    logEventForClass: mocks.logEventForClass,
  },
}));

import { PlanFolder, savePlan } from '../PlanningService';

const configureFromMock = () => {
  mocks.from.mockImplementation((table: string) => {
    if (table === 'generated_contents') {
      return {
        insert: vi.fn().mockResolvedValue({ error: null }),
      };
    }
    if (table === 'lessons') {
      return {
        insert: vi.fn().mockResolvedValue({ error: null }),
      };
    }
    return {};
  });
};

const basePlan = {
  type: 'material' as const,
  title: 'Material de História',
  content: 'Conteúdo canônico',
  createdAt: '2026-08-15T02:30:00.000Z',
};

describe('PlanningService - governed consumer save', () => {
  beforeEach(() => {
    vi.resetAllMocks();
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'false');
    configureFromMock();
    mocks.checkUsageQuota.mockResolvedValue({ allowed: true });
    mocks.incrementUserUsage.mockResolvedValue(undefined);

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

  it('preserva quota, insert direto e débito legado com a flag OFF', async () => {
    await savePlan('user-4a', basePlan, PlanFolder.MATERIAL_ALUNO);

    expect(mocks.checkUsageQuota).toHaveBeenCalledWith('user-4a', undefined);
    expect(mocks.rpc).not.toHaveBeenCalled();
    expect(mocks.from).toHaveBeenCalledWith('generated_contents');
    expect(mocks.incrementUserUsage).toHaveBeenCalledWith('user-4a', 'document');
  });

  it('usa somente o RPC governado e não debita pelo helper legado com a flag ON', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');
    mocks.rpc.mockResolvedValueOnce({
      data: { saved: true, outcome: 'APPLIED', charged: true, reason: 'CHARGED' },
      error: null,
    });

    const saved = await savePlan('user-4a', basePlan, PlanFolder.MATERIAL_ALUNO);

    expect(saved.synced).toBe(true);
    expect(mocks.checkUsageQuota).not.toHaveBeenCalled();
    expect(mocks.incrementUserUsage).not.toHaveBeenCalled();
    expect(mocks.rpc).toHaveBeenCalledWith(
      'credit_save_generated_content',
      expect.objectContaining({
        p_artifact_id: saved.id,
        p_type: 'material',
        p_folder: PlanFolder.MATERIAL_ALUNO,
        p_title: basePlan.title,
        p_content: basePlan.content,
      })
    );
  });

  it('reutiliza o mesmo artifact_id após timeout e retry exato', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');
    mocks.rpc
      .mockResolvedValueOnce({ data: null, error: { message: 'timeout' } })
      .mockResolvedValueOnce({
        data: {
          saved: true,
          outcome: 'NO_CHARGE',
          charged: false,
          reason: 'EXISTING_ARTIFACT_EDIT',
        },
        error: null,
      });

    await expect(
      savePlan('user-4a', basePlan, PlanFolder.MATERIAL_ALUNO)
    ).rejects.toMatchObject({ message: 'timeout' });

    const firstArtifactId = mocks.rpc.mock.calls[0][1].p_artifact_id as string;
    expect(firstArtifactId).toBeTruthy();

    const saved = await savePlan('user-4a', basePlan, PlanFolder.MATERIAL_ALUNO);
    const secondArtifactId = mocks.rpc.mock.calls[1][1].p_artifact_id as string;

    expect(secondArtifactId).toBe(firstArtifactId);
    expect(saved.id).toBe(firstArtifactId);

    const drafts = JSON.parse(
      localStorage.getItem('profeplan_history_buffer:user-4a') || '[]'
    ) as Array<{ id: string; synced: boolean }>;
    expect(drafts).toHaveLength(1);
    expect(drafts[0]).toEqual(expect.objectContaining({ id: firstArtifactId, synced: true }));
  });

  it('preserva draft não sincronizado quando o RPC rejeita por falta de saldo', async () => {
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

    await expect(
      savePlan('user-4a', basePlan, PlanFolder.MATERIAL_ALUNO)
    ).rejects.toThrow('Créditos insuficientes');

    const drafts = JSON.parse(
      localStorage.getItem('profeplan_history_buffer:user-4a') || '[]'
    ) as Array<{ id: string; synced: boolean }>;
    expect(drafts).toHaveLength(1);
    expect(drafts[0].synced).toBe(false);
    expect(mocks.incrementUserUsage).not.toHaveBeenCalled();
  });
});
