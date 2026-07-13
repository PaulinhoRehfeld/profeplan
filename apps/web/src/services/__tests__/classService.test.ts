import { beforeEach, describe, expect, it, vi } from 'vitest';

vi.mock('../supabaseClient', () => ({
  supabase: {
    from: vi.fn(),
  },
}));

import { supabase } from '../supabaseClient';
import { createClass, getClassesBySchool } from '../classService';

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

describe('classService', () => {
  const mockedSupabase = supabase as unknown as { from: ReturnType<typeof vi.fn> };

  beforeEach(() => {
    mockedSupabase.from.mockReset();
  });

  it('getClassesBySchool returns classes', async () => {
    const result = { data: [{ id: '1', name: '3A' }], error: null };
    const query = createQuery(result);
    mockedSupabase.from.mockReturnValue(query);

    const classes = await getClassesBySchool('school-123');

    expect(mockedSupabase.from).toHaveBeenCalledWith('classes');
    expect(query.eq).toHaveBeenCalledWith('school_id', 'school-123');
    expect(query.order).toHaveBeenCalledWith('name');
    expect(classes).toEqual(result.data);
  });

  it('createClass returns success on insert', async () => {
    const result = { data: { id: '1', name: '3A' }, error: null };
    const query = createQuery(result);
    mockedSupabase.from.mockReturnValue(query);

    const response = await createClass({
      name: '3A',
      school_id: 'school-123',
      year: 2025,
    });

    expect(response.success).toBe(true);
    expect(query.insert).toHaveBeenCalled();
  });
});
