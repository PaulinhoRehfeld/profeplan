
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
