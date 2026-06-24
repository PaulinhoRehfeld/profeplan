/**
 * TESTES DE CARACTERIZAÇÃO — PdiDocumentService (Fase 2)
 * ------------------------------------------------------------------
 * FIXAM o comportamento ATUAL dos métodos de escrita/leitura de registros de PDI
 * antes da refatoração do god file (1223 LOC). Cobrem em especial logEvent e
 * logEventForClass, onde corrigimos a resolução de school_id e a lentidão.
 *
 * Ver docs/REFACTORING_METHODOLOGY.md.
 */
import { beforeEach, describe, expect, it, vi } from 'vitest';

vi.mock('../../supabaseClient', () => ({
  supabase: { from: vi.fn() },
}));
vi.mock('../../ProfileService', () => ({
  ProfileService: { getProfile: vi.fn() },
  checkUsageQuota: vi.fn(),
}));
vi.mock('../../ai/AiCore', () => ({ createSimpleCompletion: vi.fn() }));
vi.mock('../../sessionService', () => ({ getAuthHeaders: vi.fn().mockResolvedValue({}) }));

import { supabase } from '../../supabaseClient';
import { ProfileService } from '../../ProfileService';
import { PdiDocumentService } from '../PdiDocumentService';

const mockedFrom = (supabase as unknown as { from: ReturnType<typeof vi.fn> }).from;
const mockedGetProfile = (ProfileService as unknown as { getProfile: ReturnType<typeof vi.fn> }).getProfile;

const createQuery = (result: { data: unknown; error: unknown }) => {
  const q: any = {};
  for (const m of ['select', 'eq', 'insert', 'update', 'upsert', 'is']) {
    q[m] = vi.fn(() => q);
  }
  q.maybeSingle = vi.fn().mockResolvedValue(result);
  q.single = vi.fn().mockResolvedValue(result);
  q.order = vi.fn().mockResolvedValue(result);
  q.then = (resolve: (v: unknown) => unknown) => resolve(result);
  return q;
};

beforeEach(() => {
  mockedFrom.mockReset();
  mockedGetProfile.mockReset();
  vi.spyOn(console, 'log').mockImplementation(() => {});
  vi.spyOn(console, 'warn').mockImplementation(() => {});
  vi.spyOn(console, 'error').mockImplementation(() => {});
});

describe('getStudentTimeline (caracterização)', () => {
  it('retorna registros em ordem de data quando há sucesso', async () => {
    const records = [{ id: 'r1' }, { id: 'r2' }];
    mockedFrom.mockReturnValue(createQuery({ data: records, error: null }));

    const result = await PdiDocumentService.getStudentTimeline('s1');

    expect(mockedFrom).toHaveBeenCalledWith('pdi_records');
    expect(result).toEqual(records);
  });

  it('retorna [] quando há erro', async () => {
    mockedFrom.mockReturnValue(createQuery({ data: null, error: { message: 'boom' } }));
    const result = await PdiDocumentService.getStudentTimeline('s1');
    expect(result).toEqual([]);
  });
});

describe('logEvent (caracterização)', () => {
  it('com schoolId e teacherId override: insere sem buscar profile', async () => {
    const record = { id: 'rec1', student_id: 's1' };
    const pdiQuery = createQuery({ data: record, error: null });
    mockedFrom.mockImplementation((t: string) => (t === 'pdi_records' ? pdiQuery : createQuery({ data: null, error: null })));

    const result = await PdiDocumentService.logEvent(
      's1', 'EVALUATION', 'Prova', {}, undefined, 'school1', 'class1', 'teacher1'
    );

    expect(mockedGetProfile).not.toHaveBeenCalled();
    expect(result).toEqual(record);
    const insertArg = pdiQuery.insert.mock.calls[0][0] as Record<string, unknown>;
    expect(insertArg.school_id).toBe('school1');
    expect(insertArg.teacher_id).toBe('teacher1');
    expect(insertArg.student_id).toBe('s1');
  });

  it('sem overrides e sem escola resolvível: retorna null', async () => {
    mockedGetProfile.mockResolvedValue({ id: 't1' }); // sem active_school_id/school_id
    mockedFrom.mockReturnValue(createQuery({ data: null, error: null }));

    const result = await PdiDocumentService.logEvent('s1', 'EVALUATION', 'Prova', {});

    expect(mockedGetProfile).toHaveBeenCalled();
    expect(result).toBeNull();
  });
});

describe('logEventForClass (caracterização)', () => {
  it('sem school_id resolvível: retorna [] (automação ignorada)', async () => {
    mockedGetProfile.mockResolvedValue({ id: 't1' }); // sem escola
    mockedFrom.mockImplementation((t: string) => {
      if (t === 'classes') return createQuery({ data: null, error: null });
      if (t === 'students') return createQuery({ data: [{ id: 's1' }], error: null });
      return createQuery({ data: null, error: null });
    });

    const result = await PdiDocumentService.logEventForClass('class1', 'EVALUATION', 'Prova', {});
    expect(result).toEqual([]);
  });

  it('com escola no profile: registra para cada aluno da turma', async () => {
    mockedGetProfile.mockResolvedValue({ id: 't1', active_school_id: 'school1' });
    mockedFrom.mockImplementation((t: string) => {
      if (t === 'students') return createQuery({ data: [{ id: 's1' }, { id: 's2' }], error: null });
      if (t === 'pdi_records') return createQuery({ data: { id: 'rec' }, error: null });
      return createQuery({ data: null, error: null });
    });

    const result = await PdiDocumentService.logEventForClass('class1', 'EVALUATION', 'Prova', {});
    expect(result).toHaveLength(2);
  });
});
