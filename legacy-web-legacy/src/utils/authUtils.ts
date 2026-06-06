
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
