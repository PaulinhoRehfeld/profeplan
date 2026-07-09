/**
 * Utilitário para normalizar códigos INEP de Minas Gerais
 * 
 * INEP completo = 8 dígitos (ex: 31184381)
 * Documentos oficiais MG = 6 dígitos (ex: 184381)
 * 
 * Esta função normaliza SEMPRE para 8 dígitos (formato completo com prefixo "31")
 * que é o formato usado na tabela schools do banco de dados.
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

    // 8 dígitos → Já está no formato completo, usa como está
    if (cleaned.length === 8) {
        return { normalized: cleaned, isValid: true };
    }

    // 6 dígitos (formato MG sem prefixo) → Adiciona prefixo "31"
    if (cleaned.length === 6) {
        return { normalized: `31${cleaned}`, isValid: true };
    }

    // 5 dígitos → Adiciona zero à esquerda e prefixo "31"
    if (cleaned.length === 5) {
        return { normalized: `310${cleaned}`, isValid: true };
    }

    // 7 dígitos → Adiciona prefixo "31" (remove o primeiro dígito se for 1)
    if (cleaned.length === 7) {
        // Provavelmente é um código de 8 dígitos sem o primeiro "3"
        return { normalized: `3${cleaned}`, isValid: true };
    }

    // Formato inválido
    return {
        normalized: cleaned,
        isValid: false,
        error: `INEP deve ter 5, 6, 7 ou 8 dígitos (recebido: ${cleaned.length})`
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
