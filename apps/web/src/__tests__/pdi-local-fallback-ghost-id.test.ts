import { describe, expect, it, vi, beforeEach } from 'vitest';

// Regressão: tanto ClassManager quanto usePDIManager usam `session.id` como `userId` para o
// fallback local. Esse `session.id` pode ser um Ghost ID desatualizado em relação ao
// auth.uid() real (ver feedback_ghost_id_pattern). Depois de um logout/login que resolve um
// `session.id` diferente do que estava ativo quando a turma foi salva só localmente (ex:
// durante uma sessão expirada), a turma "some" da tela mesmo sem ter sido apagada, porque a
// busca no localStorage passa a usar uma chave diferente da que foi usada para salvar.
// getLocalClassesForUser tenta os dois IDs (o resolvido via auth.getUser() e o bruto
// recebido) para cobrir esse caso.

const getUserMock = vi.fn();

vi.mock('../services/supabaseClient', () => ({
  supabase: {
    auth: {
      getUser: (...args: unknown[]) => getUserMock(...args),
    },
  },
}));

describe('getLocalClassesForUser (fallback local sob Ghost ID)', () => {
  beforeEach(() => {
    vi.resetModules();
    getUserMock.mockReset();
    localStorage.clear();
  });

  it('encontra a turma salva sob o Ghost ID mesmo quando o auth.uid() atual é outro', async () => {
    const ghostUserId = 'ghost-uuid-antigo';
    const realUserId = 'real-uuid-atual';

    const { saveClassToLocal } = await import('../services/localStorageService');
    saveClassToLocal(ghostUserId, {
      className: '1º EM REG 7',
      subject: 'Filosofia',
      students: ['Aluno A'],
    });

    getUserMock.mockResolvedValue({ data: { user: { id: realUserId } } });
    const { getLocalClassesForUser } = await import('../services/localStorageService');

    const result = await getLocalClassesForUser(ghostUserId);
    expect(result).toHaveLength(1);
    expect(result[0].name).toBe('1º EM REG 7');
  });

  it('prioriza o auth.uid() resolvido quando a turma já está salva sob o ID correto', async () => {
    const realUserId = 'real-uuid-atual';

    const { saveClassToLocal } = await import('../services/localStorageService');
    saveClassToLocal(realUserId, {
      className: 'Turma Atual',
      subject: 'Sociologia',
      students: ['Aluno B'],
    });

    getUserMock.mockResolvedValue({ data: { user: { id: realUserId } } });
    const { getLocalClassesForUser } = await import('../services/localStorageService');

    const result = await getLocalClassesForUser('qualquer-id-bruto-passado-como-prop');
    expect(result).toHaveLength(1);
    expect(result[0].name).toBe('Turma Atual');
  });

  it('retorna vazio quando não há dado sob nenhum dos dois IDs', async () => {
    getUserMock.mockResolvedValue({ data: { user: { id: 'real-uuid-atual' } } });
    const { getLocalClassesForUser } = await import('../services/localStorageService');

    const result = await getLocalClassesForUser('outro-id-sem-dado');
    expect(result).toEqual([]);
  });
});
