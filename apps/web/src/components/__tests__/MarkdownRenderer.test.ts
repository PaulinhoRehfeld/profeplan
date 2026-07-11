import { describe, expect, it } from 'vitest';
import { formatMarkdownToHTML } from '../MarkdownRenderer';

describe('formatMarkdownToHTML (segurança)', () => {
  it('escapa tags HTML embutidas no texto livre (XSS armazenado)', () => {
    const html = formatMarkdownToHTML('Observação: <img src=x onerror=alert(1)>');
    expect(html).not.toContain('<img');
    expect(html).toContain('&lt;img src=x onerror=alert(1)&gt;');
  });

  it('escapa script tags', () => {
    const html = formatMarkdownToHTML('<script>alert(1)</script>');
    expect(html).not.toContain('<script>');
    expect(html).toContain('&lt;script&gt;');
  });

  it('ainda formata markdown normalmente após escapar', () => {
    const html = formatMarkdownToHTML('**negrito** e *itálico*');
    expect(html).toContain('<strong>negrito</strong>');
    expect(html).toContain('<em>itálico</em>');
  });

  it('mantém limpeza de metadados internos', () => {
    const html = formatMarkdownToHTML('[PROFESSOR: Maria] Conteúdo normal');
    expect(html).not.toContain('PROFESSOR');
    expect(html).toContain('Conteúdo normal');
  });
});
