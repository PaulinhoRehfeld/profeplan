import { describe, expect, it } from 'vitest';
import { normalizeInepCode } from '../inepUtils';

// Regressão (2026-07-13): normalizeInepCode normalizava para 8 dígitos com
// prefixo estadual "31", mas a tabela `schools` real armazena o código sem
// esse prefixo (6 dígitos) — confirmado com dados reais de produção
// (id/inep_code = '374709', nunca '31374709'). O vínculo de escola por INEP
// nunca encontrava nenhuma escola por causa desse descompasso de formato.

describe('normalizeInepCode (regressão — formato real da tabela schools)', () => {
  it('remove o prefixo "31" de um código federal de 8 dígitos', () => {
    const result = normalizeInepCode('31023299');
    expect(result.isValid).toBe(true);
    expect(result.normalized).toBe('023299');
  });

  it('mantém um código de 6 dígitos como está', () => {
    const result = normalizeInepCode('374709');
    expect(result.isValid).toBe(true);
    expect(result.normalized).toBe('374709');
  });

  it('completa um código de 5 dígitos com zero à esquerda', () => {
    const result = normalizeInepCode('23299');
    expect(result.isValid).toBe(true);
    expect(result.normalized).toBe('023299');
  });

  it('aceita separadores/espaços e limpa antes de normalizar', () => {
    const result = normalizeInepCode(' 31.023.299 ');
    expect(result.isValid).toBe(true);
    expect(result.normalized).toBe('023299');
  });

  it('rejeita string vazia', () => {
    const result = normalizeInepCode('');
    expect(result.isValid).toBe(false);
  });

  it('rejeita 8 dígitos sem o prefixo "31" (sem interpretação segura)', () => {
    const result = normalizeInepCode('12345678');
    expect(result.isValid).toBe(false);
  });

  it('rejeita 7 dígitos (sem interpretação segura)', () => {
    const result = normalizeInepCode('1234567');
    expect(result.isValid).toBe(false);
  });
});
