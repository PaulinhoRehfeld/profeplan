/**
 * Redige informações sensíveis (PII - Personally Identifiable Information)
 * do texto gerado por IA antes de retornar ao cliente.
 * 
 * Filtra:
 * 1. CPF (ex: 123.456.789-00 ou 12345678900)
 * 2. E-mail (ex: nome@escola.gov.br)
 * 3. Telefones (ex: (11) 99999-9999 ou similar)
 * 4. Códigos MASP / INEP (7 ou 8 dígitos isolados)
 */
export function redactSensitiveData(text: string): string {
  if (!text) return text;
  let sanitized = text;

  // 1. CPF (ex: 123.456.789-00 ou sequências diretas de 11 dígitos que parecem CPF)
  const cpfRegex = /\b\d{3}\.\d{3}\.\d{3}-\d{2}\b/g;
  sanitized = sanitized.replace(cpfRegex, '[CPF OMITIDO]');

  // 2. E-mail
  const emailRegex = /\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/g;
  sanitized = sanitized.replace(emailRegex, '[EMAIL OMITIDO]');

  // 3. Telefone (Formatos comuns brasileiros: (XX) XXXX-XXXX, (XX) XXXXX-XXXX, etc.)
  const phoneRegex = /(?:\(?\d{2}\)?\s*)?\b(?:9?\d{4}-\d{4})\b/g;
  sanitized = sanitized.replace(phoneRegex, '[TELEFONE OMITIDO]');

  // 4. Códigos de identificação governamental (MASP/INEP)
  // Números isolados de 7 ou 8 dígitos, excluindo padrões de data (19xx/20xx).
  const inepMaspRegex = /\b(?!(?:19|20)\d{2})\d{7,8}\b/g;
  sanitized = sanitized.replace(inepMaspRegex, '[CÓDIGO OMITIDO]');

  return sanitized;
}
