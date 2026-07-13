import { beforeEach, describe, expect, it, vi } from 'vitest';

vi.mock('../supabaseClient', () => ({
  supabase: {
    from: vi.fn(),
  },
}));

import { supabase } from '../supabaseClient';
import { getTeachersBySchool } from '../teacherService';

const createQuery = (result: { data: unknown; error: unknown }) => {
  const query = {
    select: vi.fn().mockReturnThis(),
    eq: vi.fn().mockReturnThis(),
    order: vi.fn().mockResolvedValue(result),
  };

  return query;
};

describe('teacherService', () => {
  const mockedSupabase = supabase as unknown as { from: ReturnType<typeof vi.fn> };

  beforeEach(() => {
    mockedSupabase.from.mockReset();
  });

  it('getTeachersBySchool returns teachers', async () => {
    const result = { data: [{ id: '1', full_name: 'Ana' }], error: null };
    const query = createQuery(result);
    mockedSupabase.from.mockReturnValue(query);

    const teachers = await getTeachersBySchool('school-123');

    expect(mockedSupabase.from).toHaveBeenCalledWith('profiles');
    expect(query.eq).toHaveBeenCalledWith('school_id', 'school-123');
    expect(query.eq).toHaveBeenCalledWith('role', 'teacher');
    expect(query.order).toHaveBeenCalledWith('full_name');
    expect(teachers).toEqual(result.data);
  });
});
