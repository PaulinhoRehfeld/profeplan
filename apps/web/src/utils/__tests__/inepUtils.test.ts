import { describe, expect, it } from 'vitest';
import { normalizeInepCode } from '../inepUtils';

// Regressão (2026-07-14): normalizeInepCode tentava converter todo código pra
// um único formato (6 dígitos, removendo prefixo estadual "31"), assumindo
// uma tabela `schools` pré-populada de referência. Mudança de arquitetura:
// schools agora começa vazia e cresce sob demanda (find-or-create) — sem uma
// tabela fixa pra normalizar contra, converter formato só arrisca buscar/criar
// pelo código errado. Agora só limpa e valida o tamanho (6 ou 8 dígitos), sem
// transformar um no outro.

describe('normalizeInepCode (aceita 6 ou 8 dígitos, sem transformar formato)', () => {
  it('mantém um código de 8 dígitos como está (não remove mais o prefixo "31")', () => {
    const result = normalizeInepCode('31023299');
    expect(result.isValid).toBe(true);
    expect(result.normalized).toBe('31023299');
  });

  it('mantém um código de 6 dígitos como está', () => {
    const result = normalizeInepCode('374709');
    expect(result.isValid).toBe(true);
    expect(result.normalized).toBe('374709');
  });

  it('aceita separadores/espaços e limpa antes de validar', () => {
    const result = normalizeInepCode(' 31.023.299 ');
    expect(result.isValid).toBe(true);
    expect(result.normalized).toBe('31023299');
  });

  it('rejeita string vazia', () => {
    const result = normalizeInepCode('');
    expect(result.isValid).toBe(false);
  });

  it('rejeita 5 dígitos (não completa mais com zero à esquerda)', () => {
    const result = normalizeInepCode('23299');
    expect(result.isValid).toBe(false);
  });

  it('rejeita 7 dígitos (sem interpretação segura)', () => {
    const result = normalizeInepCode('1234567');
    expect(result.isValid).toBe(false);
  });
});
