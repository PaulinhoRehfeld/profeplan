/**
 * Utilitário para normalizar códigos INEP de Minas Gerais
 * 
 * INEP completo = 8 dígitos (ex: 31184381)
 * Documentos oficiais MG = 6 dígitos (ex: 184381)
 * 
 * Esta função adiciona automaticamente o prefixo "31" quando necessário
 */

export const normalizeInepCode = (input: string): {
    normalized: string;
    isValid: boolean;
    error?: string
} => {
    // Remove espaços e caracteres não-numéricos
    const cleaned = input.trim().replace(/\D/g, '');

    // Vazio
    if (!cleaned) {
        return { normalized: '', isValid: false, error: 'Código INEP vazio' };
    }

    // 6 dígitos (formato padrão MG) → Usa como está
    if (cleaned.length === 6) {
        return { normalized: cleaned, isValid: true };
    }

    // 5 dígitos → Adiciona zero à esquerda
    if (cleaned.length === 5) {
        return { normalized: `0${cleaned}`, isValid: true };
    }

    // 8 dígitos (com prefixo 31) → Remove prefixo para compatibilidade
    if (cleaned.length === 8 && cleaned.startsWith('31')) {
        return { normalized: cleaned.slice(2), isValid: true }; // Remove "31"
    }

    // 8 dígitos (outro prefixo) → Mantém como está
    if (cleaned.length === 8) {
        return { normalized: cleaned, isValid: true };
    }

    // Formato inválido
    return {
        normalized: cleaned,
        isValid: false,
        error: `INEP deve ter 5, 6 ou 8 dígitos (recebido: ${cleaned.length})`
    };
};

/**
 * Formata INEP para exibição (com espaços para legibilidade)
 * Exemplo: 31184381 → 31 184381
 */
export const formatInepDisplay = (inep: string): string => {
    const cleaned = inep.replace(/\D/g, '');
    if (cleaned.length === 8) {
        return `${cleaned.slice(0, 2)} ${cleaned.slice(2)}`;
    }
    return cleaned;
};
