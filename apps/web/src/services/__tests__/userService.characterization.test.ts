/**
 * TESTES DE CARACTERIZAÇÃO — userService.ts
 * ------------------------------------------------------------------
 * Estes testes NÃO validam o comportamento "ideal". Eles FIXAM o
 * comportamento ATUAL do userService antes da refatoração, servindo
 * como rede de segurança (golden master). Se um destes testes quebrar
 * durante a refatoração, significa que o comportamento mudou — o que,
 * numa refatoração pura, é proibido.
 *
 * Cobre as funções que serão movidas para módulos coesos na Fase 1:
 *   - checkUsageQuota   → credits/quota
 *   - incrementUserUsage→ credits/quota
 *   - getUserProfile    → profile/profileRepository
 *   - updateUserProfile → profile/profileRepository
 *
 * Ver docs/REFACTORING_METHODOLOGY.md.
 */
import { beforeEach, describe, expect, it, vi } from 'vitest';

// --- Mock do cliente Supabase (auth + from + rpc) ---
vi.mock('../supabaseClient', () => ({
  supabase: {
    from: vi.fn(),
    rpc: vi.fn(),
    auth: {
      getSession: vi.fn(),
      getUser: vi.fn(),
      refreshSession: vi.fn(),
    },
  },
}));

import { supabase } from '../supabaseClient';
import {
  checkUsageQuota,
  incrementUserUsage,
  getUserProfile,
  updateUserProfile,
} from '../ProfileService';

const mocked = supabase as unknown as {
  from: ReturnType<typeof vi.fn>;
  rpc: ReturnType<typeof vi.fn>;
  auth: {
    getSession: ReturnType<typeof vi.fn>;
    getUser: ReturnType<typeof vi.fn>;
    refreshSession: ReturnType<typeof vi.fn>;
  };
};

/**
 * Cria um query builder "thenable" que resolve sempre para `result`.
 * Métodos de construção (select/eq/...) retornam o próprio builder;
 * métodos terminais (maybeSingle/single/order) e o await direto
 * resolvem para `result`.
 */
const createQuery = (result: { data: unknown; error: unknown }) => {
  const q: any = {};
  for (const m of ['select', 'eq', 'insert', 'update', 'upsert', 'is']) {
    q[m] = vi.fn(() => q);
  }
  q.maybeSingle = vi.fn().mockResolvedValue(result);
  q.single = vi.fn().mockResolvedValue(result);
  q.order = vi.fn().mockResolvedValue(result);
  // torna o builder awaitable (ex.: update().eq().select() sem terminal)
  q.then = (resolve: (v: unknown) => unknown) => resolve(result);
  return q;
};

const session = (user: { id: string; email?: string } | null) => ({
  data: { session: user ? { user } : null },
  error: null,
});

beforeEach(() => {
  mocked.from.mockReset();
  mocked.rpc.mockReset();
  mocked.auth.getSession.mockReset();
  mocked.auth.getUser.mockReset();
  mocked.auth.refreshSession.mockReset();
  vi.spyOn(console, 'log').mockImplementation(() => {});
  vi.spyOn(console, 'warn').mockImplementation(() => {});
  vi.spyOn(console, 'error').mockImplementation(() => {});
});

// ──────────────────────────────────────────────────────────────────
// checkUsageQuota — regra de créditos (lógica de "dinheiro": prioridade)
// ──────────────────────────────────────────────────────────────────
describe('checkUsageQuota (caracterização)', () => {
  it('perfil pré-carregado is_unlimited → allowed, sem tocar no banco', async () => {
    const r = await checkUsageQuota('u1', { is_unlimited: true } as any);
    expect(r).toEqual({ allowed: true });
    expect(mocked.from).not.toHaveBeenCalled();
  });

  it('perfil pré-carregado tier GOLD → allowed', async () => {
    const r = await checkUsageQuota('u1', { tier: 'GOLD' } as any);
    expect(r.allowed).toBe(true);
  });

  it('perfil FREE com créditos > 0 → allowed', async () => {
    const r = await checkUsageQuota('u1', { tier: 'FREE', credits: 5 } as any);
    expect(r.allowed).toBe(true);
  });

  it('perfil FREE com créditos <= 0 → bloqueado com mensagem de créditos', async () => {
    const r = await checkUsageQuota('u1', { tier: 'FREE', credits: 0 } as any);
    expect(r.allowed).toBe(false);
    expect(r.message).toContain('Créditos insuficientes');
  });

  it('perfil null + sessão ativa (não admin) → allowed (fix anti-falso-negativo)', async () => {
    // getUserProfile retornará null; checkUsageQuota vê sessão ativa e libera.
    mocked.auth.getSession.mockResolvedValue(session({ id: 'u1', email: 'teacher@test.com' }));
    mocked.auth.getUser.mockResolvedValue({ data: { user: null }, error: null });
    mocked.from.mockReturnValue(createQuery({ data: null, error: null }));

    const r = await checkUsageQuota('u1');
    expect(r).toEqual({ allowed: true });
  });

  it('perfil null + sessão de admin hardcoded → allowed (bypass admin)', async () => {
    mocked.auth.getSession.mockResolvedValue(session({ id: 'u1', email: 'suporte@wrtech-ai.com' }));
    mocked.auth.getUser.mockResolvedValue({ data: { user: null }, error: null });
    mocked.from.mockReturnValue(createQuery({ data: null, error: null }));

    const r = await checkUsageQuota('u1');
    expect(r.allowed).toBe(true);
  });

  it('perfil null + SEM sessão → bloqueado com mensagem de sessão expirada', async () => {
    mocked.auth.getSession.mockResolvedValue(session(null));
    mocked.auth.getUser.mockResolvedValue({ data: { user: null }, error: null });
    mocked.from.mockReturnValue(createQuery({ data: null, error: null }));

    const r = await checkUsageQuota('u1');
    expect(r.allowed).toBe(false);
    expect(r.message).toContain('sessão expirou');
  });
});

// ──────────────────────────────────────────────────────────────────
// incrementUserUsage — dedução de crédito
// ──────────────────────────────────────────────────────────────────
describe('incrementUserUsage (caracterização)', () => {
  it('tipo de tarefa NÃO pago → não busca perfil nem deduz', async () => {
    await incrementUserUsage('u1', 'unknown');
    expect(mocked.from).not.toHaveBeenCalled();
  });

  it('tarefa paga + perfil unlimited → não deduz', async () => {
    mocked.auth.getSession.mockResolvedValue(session({ id: 'u1', email: 'teacher@test.com' }));
    const profile = { id: 'u1', is_unlimited: true, credits: 9999 };
    mocked.from.mockReturnValue(createQuery({ data: profile, error: null }));

    await incrementUserUsage('u1', 'generate');

    // Não deve ter havido chamada de update (apenas a leitura do perfil)
    const calls = mocked.from.mock.results.map(r => r.value);
    const anyUpdate = calls.some((q: any) => q.update.mock.calls.length > 0);
    expect(anyUpdate).toBe(false);
  });

  it('tarefa paga + créditos > 0 → deduz 1 crédito via update', async () => {
    mocked.auth.getSession.mockResolvedValue(session({ id: 'u1', email: 'teacher@test.com' }));
    const profile = { id: 'u1', is_unlimited: false, tier: 'FREE', credits: 5 };
    const q = createQuery({ data: profile, error: null });
    mocked.from.mockReturnValue(q);

    await incrementUserUsage('u1', 'generate');

    expect(q.update).toHaveBeenCalledWith({ credits: 4 });
  });
});

// ──────────────────────────────────────────────────────────────────
// getUserProfile — leitura de perfil
// ──────────────────────────────────────────────────────────────────
describe('getUserProfile (caracterização)', () => {
  it('perfil existente (sem school_id) → retorna dados do banco', async () => {
    mocked.auth.getSession.mockResolvedValue(session({ id: 'u1', email: 'teacher@test.com' }));
    const profile = { id: 'u1', full_name: 'Maria', tier: 'GOLD', credits: 10 };
    mocked.from.mockReturnValue(createQuery({ data: profile, error: null }));

    const result = await getUserProfile('u1', 'teacher@test.com');

    expect(result).toMatchObject({ id: 'u1', full_name: 'Maria', tier: 'GOLD' });
  });

  it('perfil inexistente e sem sessão → retorna null', async () => {
    mocked.auth.getSession.mockResolvedValue(session(null));
    mocked.auth.getUser.mockResolvedValue({ data: { user: null }, error: null });
    mocked.from.mockReturnValue(createQuery({ data: null, error: null }));

    const result = await getUserProfile('u1');
    expect(result).toBeNull();
  });
});

// ──────────────────────────────────────────────────────────────────
// updateUserProfile — gravação via RPC com fallback
// ──────────────────────────────────────────────────────────────────
describe('updateUserProfile (caracterização)', () => {
  it('RPC update_my_profile com sucesso → success:true', async () => {
    mocked.rpc.mockResolvedValue({ data: { id: 'u1' }, error: null });

    const r = await updateUserProfile('u1', { userName: 'Novo Nome' });

    expect(mocked.rpc).toHaveBeenCalledWith('update_my_profile', expect.any(Object));
    expect(r.success).toBe(true);
  });

  it('RPC ausente (PGRST202) → cai no caminho legado de update', async () => {
    mocked.rpc.mockResolvedValue({ data: null, error: { code: 'PGRST202', message: 'Could not find the function' } });
    mocked.auth.getUser.mockResolvedValue({ data: { user: { id: 'u1' } }, error: null });
    mocked.from.mockReturnValue(createQuery({ data: [{ id: 'u1' }], error: null }));

    const r = await updateUserProfile('u1', { userName: 'Novo Nome' });

    expect(mocked.from).toHaveBeenCalledWith('profiles');
    expect(r.success).toBe(true);
  });
});
