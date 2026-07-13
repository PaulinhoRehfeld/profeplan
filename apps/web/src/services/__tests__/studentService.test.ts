import { beforeEach, describe, expect, it, vi } from 'vitest';

vi.mock('../supabaseClient', () => ({
  supabase: {
    from: vi.fn(),
  },
}));

import { supabase } from '../supabaseClient';
import { createStudent, getStudentsBySchool, getStudentInclusionSnapshot } from '../studentService';

const createQuery = (result: { data: unknown; error: unknown }) => {
  const query = {
    select: vi.fn().mockReturnThis(),
    eq: vi.fn().mockReturnThis(),
    order: vi.fn().mockResolvedValue(result),
    insert: vi.fn().mockReturnThis(),
    single: vi.fn().mockResolvedValue(result),
  };

  return query;
};

describe('studentService', () => {
  const mockedSupabase = supabase as unknown as { from: ReturnType<typeof vi.fn> };

  beforeEach(() => {
    mockedSupabase.from.mockReset();
  });

  it('getStudentsBySchool returns students', async () => {
    const result = { data: [{ id: '1', name: 'Ana' }], error: null };
    const query = createQuery(result);
    mockedSupabase.from.mockReturnValue(query);

    const students = await getStudentsBySchool('school-123');

    expect(mockedSupabase.from).toHaveBeenCalledWith('students');
    expect(query.eq).toHaveBeenCalledWith('current_school_id', 'school-123');
    expect(query.order).toHaveBeenCalledWith('name');
    expect(students).toEqual(result.data);
  });

  it('createStudent maps school_id to current_school_id', async () => {
    const result = { data: { id: '1', name: 'Ana' }, error: null };
    const query = createQuery(result);
    mockedSupabase.from.mockReturnValue(query);

    const response = await createStudent({
      name: 'Ana',
      school_id: 'school-123',
      current_school_id: '',
    });

    expect(response.success).toBe(true);
    const insertArg = query.insert.mock.calls[0][0][0] as Record<string, unknown>;
    expect(insertArg.school_id).toBeUndefined();
    expect(insertArg.current_school_id).toBe('school-123');
  });

  it('getStudentInclusionSnapshot consolidates inclusion fields correctly', () => {
    const student = {
      id: '1',
      name: 'Ana',
      needs_adaptation: true,
      deficiencies: ['TDAH'],
      pdi_needs: ['Dislexia'],
      pedagogical_observations: 'Precisa de tempo estendido nas avaliações.',
      observations: 'Observação antiga.',
    } as any;

    const snapshot = getStudentInclusionSnapshot(student);

    expect(snapshot.needsAdaptation).toBe(true);
    // Prioriza deficiencies se existir, caso contrário usa pdi_needs
    expect(snapshot.deficiencies).toEqual(['TDAH']);
    // Prioriza pedagogical_observations se existir, caso contrário observations
    expect(snapshot.observations).toBe('Precisa de tempo estendido nas avaliações.');
  });
});
