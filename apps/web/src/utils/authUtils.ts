import { supabase } from '../services/supabaseClient';

const delay = (ms: number) => new Promise((resolve) => setTimeout(resolve, ms));

// Uma tentativa de resolver o uid — extraído pra permitir o retry curto abaixo.
// Loga o `error` de getUser()/getSession() (antes descartado em silêncio), já que
// um relato real em produção mostrou "Sessão expirada" disparando segundos depois
// de um SIGNED_IN confirmado, sem nenhum código no app limpando a sessão nesse meio
// tempo — sem esse log não dá pra saber se é erro de rede, CORS, ou outra causa.
const tryResolveAuthUid = async (): Promise<string | null> => {
    const { data: userData, error: userError } = await supabase.auth.getUser();
    if (userData?.user?.id) return userData.user.id;
    if (userError) {
        console.warn('[resolveAuthUid] getUser() sem usuário:', userError);
    }

    // Fallback: sessão local (getSession não valida server-side, mas o auto-refresh
    // do client — persistSession + autoRefreshToken em supabaseClient.ts — já cuida da
    // renovação em background com lock interno seguro para concorrência).
    // NUNCA chamar supabase.auth.refreshSession() manualmente aqui: ver commit 66f38e96
    // (2026-06-24) — chamadas concorrentes de refreshSession() rotacionam o refresh token,
    // a 2ª chamada usa o token já rotacionado, falha com "refresh token already used" e o
    // supabase-js limpa a sessão inteira (SIGNED_OUT em cascata).
    const { data: sessionData, error: sessionError } = await supabase.auth.getSession();
    if (sessionData?.session?.user?.id) return sessionData.session.user.id;
    if (sessionError) {
        console.warn('[resolveAuthUid] getSession() sem sessão:', sessionError);
    }

    return null;
};

// Resolve o auth.uid() real. Compartilhado entre módulos que precisam gravar/ler no
// Supabase sem cair no Ghost ID (userId local desatualizado ≠ id real da linha em
// profiles/RLS). Tenta uma vez, e se ambas as chamadas vierem vazias, espera 400ms e
// tenta de novo antes de desistir — cobre uma possível corrida de tempo logo após o
// evento SIGNED_IN (sessão ainda propagando para o storage/cliente).
export const resolveAuthUid = async (): Promise<string> => {
    const firstAttempt = await tryResolveAuthUid();
    if (firstAttempt) return firstAttempt;

    await delay(400);
    const secondAttempt = await tryResolveAuthUid();
    if (secondAttempt) return secondAttempt;

    throw new Error('Sessão expirada. Faça login novamente.');
};

// Fonte única de verdade das chaves de sessão no localStorage. Antes, cada um dos
// 4 pontos de logout (AppLayout, AppRouter/VerifyEmailRoute, useProfeplanAuth x2,
// useAppBootstrap) limpava sua própria lista manualmente — o que já causou drift
// real: 'profeplan_active_school' só era limpo no listener SIGNED_OUT, não nos
// outros 3 caminhos (achado #19 da auditoria de 2026-07-10).
const SESSION_STORAGE_KEYS = [
    'profeplan_session',
    'supabase_user_id',
    'supabase.auth.token',
    'profeplan_active_school',
];

/**
 * Limpa todas as chaves de sessão do localStorage. Chamar em todo caminho de
 * logout (clique manual, listener SIGNED_OUT, token inválido) para evitar que
 * um novo caminho esqueça uma chave — mesma causa raiz do achado #13 (escola
 * ativa herdada de um usuário anterior por falta de limpeza consistente).
 */
export const clearLocalSession = (): void => {
    for (const key of SESSION_STORAGE_KEYS) {
        try {
            localStorage.removeItem(key);
        } catch {
            // noop — ex: storage indisponível (modo privado, quota excedida)
        }
    }
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
