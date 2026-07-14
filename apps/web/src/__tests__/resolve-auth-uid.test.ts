import { describe, expect, it, vi, beforeEach } from 'vitest';

// Regressão: commit a2988bbb reintroduziu supabase.auth.refreshSession() manual dentro
// de resolveAuthUid(), o exato padrão que o commit 66f38e96 (2026-06-24) removeu por
// causar rotação concorrente de refresh token -> "refresh token already used" -> SIGNED_OUT.
// Este teste garante que refreshSession() nunca é chamado a partir de resolveAuthUid.

const getUserMock = vi.fn();
const getSessionMock = vi.fn();
const refreshSessionMock = vi.fn();
const insertedClassRows: any[] = [];
const insertedLessonRows: any[] = [];

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
      if (table === 'lessons') {
        return {
          insert: (rows: any[]) => {
            insertedLessonRows.push(...rows);
            return Promise.resolve({ data: rows, error: null });
          },
        };
      }
      // students (ou qualquer outra tabela usada em saveClassStructure)
      return { insert: () => Promise.resolve({ error: null }) };
    },
  },
}));

describe('resolveAuthUid (via saveLessonToMemory)', () => {
  beforeEach(() => {
    vi.resetModules();
    getUserMock.mockReset();
    getSessionMock.mockReset();
    refreshSessionMock.mockReset();
    insertedClassRows.length = 0;
    insertedLessonRows.length = 0;
  });

  it('usa getSession quando getUser não retorna usuário, sem chamar refreshSession manualmente', async () => {
    getUserMock.mockResolvedValue({ data: { user: null } });
    getSessionMock.mockResolvedValue({ data: { session: { user: { id: 'user-123' } } } });

    const { saveLessonToMemory } = await import('../services/supabaseService');

    await saveLessonToMemory('fallback-id', 'Tópico', 'Conteúdo', {});

    expect(refreshSessionMock).not.toHaveBeenCalled();
    expect(getSessionMock).toHaveBeenCalled();
    expect(insertedLessonRows[0]).toMatchObject({ user_id: 'user-123' });
  });

  it('cai pro userId recebido (não lança) quando não há usuário nem sessão', async () => {
    getUserMock.mockResolvedValue({ data: { user: null } });
    getSessionMock.mockResolvedValue({ data: { session: null } });

    const { saveLessonToMemory } = await import('../services/supabaseService');

    await expect(
      saveLessonToMemory('fallback-id', 'Tópico', 'Conteúdo', {})
    ).resolves.toMatchObject({ error: null });

    expect(insertedLessonRows[0]).toMatchObject({ user_id: 'fallback-id' });
    expect(refreshSessionMock).not.toHaveBeenCalled();
  });
});

describe('saveClassStructure (regressão 2026-07-14 — não re-checa sessão antes de gravar)', () => {
  beforeEach(() => {
    vi.resetModules();
    getUserMock.mockReset();
    getSessionMock.mockReset();
    refreshSessionMock.mockReset();
    insertedClassRows.length = 0;
    insertedLessonRows.length = 0;
  });

  // Produção (2026-07-14): o INSERT em classes era rejeitado por RLS ("new row
  // violates row-level security policy") mesmo com resolveAuthUid() caindo pro
  // userId de fallback correto — a causa nunca foi "qual user_id usar", e sim a
  // própria chamada extra a getUser()/getSession() antes de gravar, que só essa
  // tela fazia (outras telas gravam usando direto o userId da sessão e nunca
  // reproduziram o bug). saveClassStructure agora não chama getUser()/getSession()
  // em nenhum caminho — usa userId diretamente.
  it('grava usando o userId recebido sem chamar getUser()/getSession()', async () => {
    const { saveClassStructure } = await import('../services/supabaseService');

    await saveClassStructure('session-user-id', {
      className: 'Turma X',
      subject: 'Matemática',
      students: [],
    });

    expect(getUserMock).not.toHaveBeenCalled();
    expect(getSessionMock).not.toHaveBeenCalled();
    expect(insertedClassRows[0]).toMatchObject({ user_id: 'session-user-id' });
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
