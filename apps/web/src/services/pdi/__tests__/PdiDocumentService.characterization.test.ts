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

// ──────────────────────────────────────────────────────────────────
// getOrCreatePdi — cria apenas quando não existe
// ──────────────────────────────────────────────────────────────────
describe('getOrCreatePdi (caracterização)', () => {
  it('retorna o existente quando já há PDI para o ano', async () => {
    const existing = { id: 'pdi1', student_id: 's1', year: 2025 };
    mockedFrom.mockReturnValue(createQuery({ data: existing, error: null }));

    const result = await PdiDocumentService.getOrCreatePdi('s1', 2025);

    expect(result).toEqual({ data: existing, error: null });
    // Não deve chamar insert
    const q = mockedFrom.mock.results[0].value;
    expect(q.insert).not.toHaveBeenCalled();
  });

  it('cria novo PDI quando não existe', async () => {
    const created = { id: 'pdi2', student_id: 's1', year: 2025, status: 'em_andamento' };
    mockedFrom.mockImplementation(() => {
      let callCount = 0;
      const q: any = {};
      for (const m of ['select', 'eq', 'insert', 'update', 'upsert']) q[m] = vi.fn(() => q);
      q.maybeSingle = vi.fn().mockImplementation(() => {
        callCount++;
        // Primeira chamada (select existing) → null; segunda (after insert) → created
        return Promise.resolve(callCount === 1 ? { data: null, error: null } : { data: created, error: null });
      });
      q.single = vi.fn().mockResolvedValue({ data: created, error: null });
      return q;
    });

    const result = await PdiDocumentService.getOrCreatePdi('s1', 2025);

    expect(result.error).toBeNull();
    expect(result.data).toMatchObject({ status: 'em_andamento' });
  });

  it('retorna error quando fetch falha', async () => {
    const err = { message: 'db error' };
    mockedFrom.mockReturnValue(createQuery({ data: null, error: err }));

    const result = await PdiDocumentService.getOrCreatePdi('s1', 2025);

    expect(result).toEqual({ data: null, error: err });
  });
});

// ──────────────────────────────────────────────────────────────────
// addBlock9Adaptation — upsert idempotente por lesson_id
// ──────────────────────────────────────────────────────────────────
describe('addBlock9Adaptation (caracterização)', () => {
  const makeAdaptation = (lessonId: string) => ({
    lesson_id: lessonId,
    lesson_title: 'Aula X',
    subject: 'Matemática',
    habilidades_bncc: [],
    adaptacao_metodologica: 'adaptação',
    recursos_adaptados: [],
    objetivos_adaptados: [],
    estrategias_ensino: [],
  });

  it('adiciona ao array quando lesson_id não existe', async () => {
    const existing: unknown[] = [];
    const q = createQuery({ data: { block_9_content: existing }, error: null });
    mockedFrom.mockReturnValue(q);

    const result = await PdiDocumentService.addBlock9Adaptation('pdi1', makeAdaptation('l1'));

    expect(result.error).toBeNull();
    expect(result.data.lesson_id).toBe('l1');
    expect(result.data.generated_by_ai).toBe(true);
  });

  it('substitui entrada existente com mesmo lesson_id (idempotente)', async () => {
    const existing = [{ ...makeAdaptation('l1'), generated_at: '2025-01-01', generated_by_ai: true }];
    const q = createQuery({ data: { block_9_content: existing }, error: null });
    mockedFrom.mockReturnValue(q);

    const result = await PdiDocumentService.addBlock9Adaptation('pdi1', makeAdaptation('l1'));

    expect(result.error).toBeNull();
    expect(result.data.lesson_id).toBe('l1');
    // O update foi chamado com array de tamanho 1 (substituição, não append)
    const updateCall = q.update.mock.calls[0]?.[0] as any;
    expect(updateCall?.block_9_content).toHaveLength(1);
  });

  it('retorna data mesmo se fetch falha (fail-soft)', async () => {
    const q = createQuery({ data: null, error: { message: 'err' } });
    mockedFrom.mockReturnValue(q);

    const result = await PdiDocumentService.addBlock9Adaptation('pdi1', makeAdaptation('l1'));

    expect(result.error).toBeNull();
    expect(result.data.lesson_id).toBe('l1');
  });
});

// ──────────────────────────────────────────────────────────────────
// mapToCompatibility + calculateCompleteness — funções puras
// ──────────────────────────────────────────────────────────────────
describe('mapToCompatibility (caracterização)', () => {
  it('usa school_students.name como student_name quando disponível', () => {
    const raw = {
      id: 'p1',
      updated_at: '2025-06-01',
      school_students: { name: 'João' },
      content_data: { student_data: { name: 'João' } },
    };
    const result = PdiDocumentService.mapToCompatibility(raw as any);
    expect(result.student_name).toBe('João');
    expect(result.last_updated).toBe('2025-06-01');
  });

  it('blocks_completed.block_1_8 é true quando student_data.name está preenchido', () => {
    const raw = {
      id: 'p1',
      content_data: { student_data: { name: 'Maria' } },
    };
    const result = PdiDocumentService.mapToCompatibility(raw as any);
    expect(result.blocks_completed?.block_1_8).toBe(true);
  });
});

describe('calculateCompleteness (caracterização)', () => {
  it('100% quando todas as seções estão preenchidas', () => {
    const pdi = {
      content_data: {
        institutional: { school_name: 'Escola' },
        student_data: { name: 'João' },
        clinical_health: { a: 1, b: 2, c: 3 },
        psychomotor: { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6 },
        cognitive: { a: 1, b: 2, c: 3, d: 4, e: 5, f: 6 },
        communication: { a: 1 },
      },
    } as any;
    const result = PdiDocumentService.calculateCompleteness(pdi);
    expect(result.overall_percentage).toBe(100);
    expect(result.missing_sections).toHaveLength(0);
  });

  it('0% quando conteúdo está vazio', () => {
    const result = PdiDocumentService.calculateCompleteness({ content_data: {} } as any);
    expect(result.overall_percentage).toBe(0);
    expect(result.missing_sections).toHaveLength(6);
  });
});
