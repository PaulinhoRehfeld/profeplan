import { supabase } from '../services/supabaseClient';

// Resolve o auth.uid() real — getUser() valida server-side e renova o token automaticamente.
// Compartilhado entre módulos que precisam gravar/ler no Supabase sem cair no Ghost ID
// (userId local desatualizado ≠ id real da linha em profiles/RLS).
export const resolveAuthUid = async (): Promise<string> => {
    // 1. Tenta getUser (validação server-side com token atual)
    const { data: { user } } = await supabase.auth.getUser();
    if (user?.id) return user.id;

    // 2. Fallback: sessão local (getSession não valida server-side, mas o auto-refresh
    // do client — persistSession + autoRefreshToken em supabaseClient.ts — já cuida da
    // renovação em background com lock interno seguro para concorrência).
    // NUNCA chamar supabase.auth.refreshSession() manualmente aqui: ver commit 66f38e96
    // (2026-06-24) — chamadas concorrentes de refreshSession() rotacionam o refresh token,
    // a 2ª chamada usa o token já rotacionado, falha com "refresh token already used" e o
    // supabase-js limpa a sessão inteira (SIGNED_OUT em cascata).
    const { data: { session } } = await supabase.auth.getSession();
    if (session?.user?.id) return session.user.id;

    throw new Error('Sessão expirada. Faça login novamente.');
};

const RETRYABLE_AUTH_STATUSES = new Set([502, 503, 504]);

/**
 * Distingue falha transitória de rede/gateway (retryável) de token realmente
 * inválido. Usado tanto no login (LoginScreen) quanto na checagem de sessão
 * ativa (useAppBootstrap) para não forçar logout indevido sob instabilidade.
 */
export const isRetryableAuthError = (err: any): boolean => {
    const status = Number(err?.status);
    if (RETRYABLE_AUTH_STATUSES.has(status)) return true;

    const name = String(err?.name || '');
    if (name.includes('AuthRetryableFetchError')) return true;

    const message = String(err?.message || '').toLowerCase();
    return (
        message.includes('gateway timeout') ||
        message.includes('failed to fetch') ||
        message.includes('network') ||
        message.includes('timeout')
    );
};

/**
 * Detects the appropriate role based on the user's institutional email pattern.
 * Standards for Minas Gerais (MG) Education Department:
 * - *.pedagogico@educacao.mg.gov.br -> manager
 * - escola.*@educacao.mg.gov.br -> manager
 * - direcao.*@educacao.mg.gov.br -> manager
 */
export const getRoleByEmail = (email: string): 'teacher' | 'manager' => {
    const lowerEmail = email.trim().toLowerCase();

    // MG Education Patterns for Managers
    const isManagerPattern =
        lowerEmail.endsWith('.pedagogico@educacao.mg.gov.br') ||
        lowerEmail.startsWith('escola.') && lowerEmail.endsWith('@educacao.mg.gov.br') ||
        lowerEmail.startsWith('direcao.') && lowerEmail.endsWith('@educacao.mg.gov.br');

    return isManagerPattern ? 'manager' : 'teacher';
};
