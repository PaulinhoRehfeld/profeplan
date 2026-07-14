import { describe, expect, it, vi, beforeEach } from 'vitest';

// Regressão: commit a2988bbb reintroduziu supabase.auth.refreshSession() manual dentro
// de resolveAuthUid(), o exato padrão que o commit 66f38e96 (2026-06-24) removeu por
// causar rotação concorrente de refresh token -> "refresh token already used" -> SIGNED_OUT.
// Este teste garante que refreshSession() nunca é chamado a partir de resolveAuthUid.

const getUserMock = vi.fn();
const getSessionMock = vi.fn();
const refreshSessionMock = vi.fn();
const insertedClassRows: any[] = [];

vi.mock('../services/supabaseClient', () => ({
  supabase: {
    auth: {
      getUser: (...args: unknown[]) => getUserMock(...args),
      getSession: (...args: unknown[]) => getSessionMock(...args),
      refreshSession: (...args: unknown[]) => refreshSessionMock(...args),
    },
    from: (table: string) => {
      if (table === 'classes') {
        return {
          insert: (rows: any[]) => {
            insertedClassRows.push(...rows);
            return {
              select: () => ({
                single: () => Promise.resolve({ data: { id: 'class-1' }, error: null }),
              }),
            };
          },
        };
      }
      // students (ou qualquer outra tabela usada em saveClassStructure)
      return { insert: () => Promise.resolve({ error: null }) };
    },
  },
}));

describe('resolveAuthUid (via saveClassStructure)', () => {
  beforeEach(() => {
    vi.resetModules();
    getUserMock.mockReset();
    getSessionMock.mockReset();
    refreshSessionMock.mockReset();
    insertedClassRows.length = 0;
  });

  it('usa getSession quando getUser não retorna usuário, sem chamar refreshSession manualmente', async () => {
    getUserMock.mockResolvedValue({ data: { user: null } });
    getSessionMock.mockResolvedValue({ data: { session: { user: { id: 'user-123' } } } });

    const { saveClassStructure } = await import('../services/supabaseService');

    // Não nos importa o resultado do insert em si (sem mock da tabela), só que
    // resolveAuthUid resolveu o uid via getSession sem tocar refreshSession.
    await saveClassStructure('fallback-id', {
      className: 'Turma X',
      subject: 'Matemática',
      students: [],
    }).catch(() => {});

    expect(refreshSessionMock).not.toHaveBeenCalled();
    expect(getSessionMock).toHaveBeenCalled();
  });

  it('cai pro userId recebido (não lança "Sessão expirada") quando não há usuário nem sessão', async () => {
    // Regressão 2026-07-14: resolveAuthUid() sem fallback fazia "Criar Turma"/importação
    // de PDF falhar inteiro ("Sessão expirada") mesmo com o userId correto já disponível,
    // numa corrida de tempo logo após SIGNED_IN. saveClassStructure agora cai pro userId
    // recebido nesse caso, igual getClasses() já fazia.
    getUserMock.mockResolvedValue({ data: { user: null } });
    getSessionMock.mockResolvedValue({ data: { session: null } });

    const { saveClassStructure } = await import('../services/supabaseService');

    await expect(
      saveClassStructure('fallback-id', {
        className: 'Turma X',
        subject: 'Matemática',
        students: [],
      })
    ).resolves.toMatchObject({ id: 'class-1' });

    expect(insertedClassRows[0]).toMatchObject({ user_id: 'fallback-id' });
    expect(refreshSessionMock).not.toHaveBeenCalled();
  });
});

describe('ClassManager is401 detection (regressão de UI)', () => {
  // Réplica da condição em ClassManager.tsx — cobre a mensagem que resolveAuthUid lança,
  // que antes do fix não era reconhecida e vazava para a tela como "Erro ao salvar: ...".
  const is401 = (err: any) =>
    err?.status === 401 ||
    err?.message?.includes('401') ||
    err?.message?.includes('row-level security') ||
    err?.message?.includes('Sessão expirada');

  it('reconhece o erro de sessão expirada lançado por resolveAuthUid', () => {
    const err = new Error('Sessão expirada. Faça login novamente.');
    expect(is401(err)).toBe(true);
  });
});
