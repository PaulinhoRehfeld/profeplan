/**
 * Utilitário para validar códigos INEP de escolas
 *
 * Histórico: até 2026-07-13 esta função tentava normalizar todo código pra um
 * formato único de 6 dígitos (removendo o prefixo estadual "31" de códigos de
 * 8 dígitos, completando códigos de 5 dígitos com zero à esquerda), porque a
 * tabela `schools` era pré-populada com as escolas de MG nesse formato.
 *
 * Mudança de arquitetura (2026-07-14): `schools` não é mais pré-populada —
 * começa vazia e cresce sob demanda (find-or-create) conforme cada professor
 * informa sua escola. Sem uma tabela de referência fixa pra normalizar contra,
 * forçar conversão de formato só arrisca criar/buscar pelo código errado (ex:
 * completar "23299" pra "023299" faria reconcileTeacherByInep() não achar uma
 * escola que já existe como "23299"). Esta função agora só limpa o código
 * (remove espaços/caracteres não-numéricos) e valida o tamanho — sem
 * transformar 6↔8 dígitos entre si. O que o professor digitar é o que vira
 * o identificador da escola.
 */

export const normalizeInepCode = (
  input: string
): {
  normalized: string;
  isValid: boolean;
  error?: string;
} => {
  // Remove espaços e caracteres não-numéricos
  const cleaned = input.trim().replace(/\D/g, '');

  if (!cleaned) {
    return { normalized: '', isValid: false, error: 'Código INEP vazio' };
  }

  // Aceita 6 dígitos (código interno SEE-MG) ou 8 dígitos (INEP federal
  // completo, com prefixo estadual) — sem converter um no outro.
  if (cleaned.length === 6 || cleaned.length === 8) {
    return { normalized: cleaned, isValid: true };
  }

  return {
    normalized: cleaned,
    isValid: false,
    error: `INEP deve ter 6 ou 8 dígitos (recebido: ${cleaned.length} dígito(s))`,
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
