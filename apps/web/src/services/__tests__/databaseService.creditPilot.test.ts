import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

const mocks = vi.hoisted(() => ({
  from: vi.fn(),
  insert: vi.fn(),
  select: vi.fn(),
}));

vi.mock('../supabaseClient', () => ({
  supabase: {
    from: mocks.from,
  },
}));

import { saveGeneratedContent } from '../databaseService';

describe('databaseService - governed TermPlan mirror suppression', () => {
  beforeEach(() => {
    vi.resetAllMocks();
    vi.stubEnv('VITE_GOVERNED_TERM_PLAN_SAVE', 'false');
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'false');

    mocks.select.mockResolvedValue({
      data: [{ id: 'generated-1' }],
      error: null,
    });
    mocks.insert.mockReturnValue({ select: mocks.select });
    mocks.from.mockReturnValue({ insert: mocks.insert });
  });

  afterEach(() => {
    vi.unstubAllEnvs();
  });

  it('preserva generated_contents no caminho legado', async () => {
    await saveGeneratedContent('user-1', 'trimestral', 'TermPlans', 'Plano', '# conteúdo');

    expect(mocks.from).toHaveBeenCalledWith('generated_contents');
    expect(mocks.insert).toHaveBeenCalledTimes(1);
  });

  it('não cria escrita derivada fora da transação quando o piloto está ativo', async () => {
    vi.stubEnv('VITE_GOVERNED_TERM_PLAN_SAVE', 'true');

    const result = await saveGeneratedContent(
      'user-1',
      'trimestral',
      'TermPlans',
      'Plano',
      '# conteúdo'
    );

    expect(result).toBeNull();
    expect(mocks.from).not.toHaveBeenCalled();
    expect(mocks.insert).not.toHaveBeenCalled();
  });

  it('também suprime o mirror quando o cutover global de consumidores está ativo', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_CONSUMERS', 'true');

    const result = await saveGeneratedContent(
      'user-1',
      'trimestral',
      'TermPlans',
      'Plano',
      '# conteúdo'
    );

    expect(result).toBeNull();
    expect(mocks.from).not.toHaveBeenCalled();
    expect(mocks.insert).not.toHaveBeenCalled();
  });

  it('não interfere em outros tipos de conteúdo com o piloto ativo', async () => {
    vi.stubEnv('VITE_GOVERNED_TERM_PLAN_SAVE', 'true');

    await saveGeneratedContent('user-1', 'assessment', 'Assessments', 'Avaliação', '# conteúdo');

    expect(mocks.from).toHaveBeenCalledWith('generated_contents');
  });
});
