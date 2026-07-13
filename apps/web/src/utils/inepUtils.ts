/**
 * Utilitário para normalizar códigos INEP de Minas Gerais
 *
 * INEP federal completo = 8 dígitos (ex: 31184381, prefixo "31" = código do
 * estado de MG no Censo Escolar).
 * Código interno da SEE-MG = 6 dígitos (ex: 184381), usado inclusive no
 * e-mail institucional (escola.184381@educacao.mg.gov.br).
 *
 * IMPORTANTE (corrigido em 2026-07-13): a tabela `schools` do banco armazena
 * o código SEM o prefixo "31" — confirmado com dados reais de produção
 * (ex: id/inep_code = '374709', nunca '31374709'). Uma versão anterior desta
 * função normalizava para 8 dígitos com prefixo, o que nunca batia com a
 * tabela real — o vínculo de escola por INEP em reconcileTeacherByInep()
 * silenciosamente nunca encontrava a escola para NENHUM professor. Esta
 * função agora normaliza para o formato de 6 dígitos (sem prefixo estadual),
 * que é o que a tabela realmente usa.
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

    // 8 dígitos começando com "31" (formato federal completo) → remove o
    // prefixo estadual, já que a tabela schools guarda só os 6 dígitos.
    if (cleaned.length === 8 && cleaned.startsWith('31')) {
        return { normalized: cleaned.slice(2), isValid: true };
    }

    // 6 dígitos → já é o formato usado pela tabela schools
    if (cleaned.length === 6) {
        return { normalized: cleaned, isValid: true };
    }

    // 5 dígitos → completa com zero à esquerda (ex: "23299" → "023299")
    if (cleaned.length === 5) {
        return { normalized: `0${cleaned}`, isValid: true };
    }

    // Formato inválido — 7 dígitos ou 8 dígitos sem prefixo "31" não têm uma
    // interpretação segura (arriscaria vincular a escola errada por engano).
    return {
        normalized: cleaned,
        isValid: false,
        error: `INEP deve ter 5 ou 6 dígitos (código interno da SEE-MG) ou 8 dígitos com prefixo 31 (recebido: ${cleaned.length} dígito(s))`
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
