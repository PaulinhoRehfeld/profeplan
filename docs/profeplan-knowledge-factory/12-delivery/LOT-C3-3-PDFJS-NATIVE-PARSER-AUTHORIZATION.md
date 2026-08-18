# C.3.3 — autorização material do parser textual nativo PDF.js

**Data:** 18 de agosto de 2026

## Autorização

Foi autorizada a introdução de `pdfjs-dist` como parser textual nativo do C.3.3, exclusivamente em branch/PR técnico, usando apenas PDFs sintéticos e infraestrutura descartável.

A autorização inclui:

- declaração explícita de `pdfjs-dist` no pacote `@profeplan/knowledge-factory`;
- adapter concreto do `NativeTextExtractorPort` já integrado;
- fixtures PDF inteiramente sintéticas e reproduzíveis;
- testes de extração textual por página;
- correções necessárias aos próprios gates;
- merge técnico quando os gates materiais estiverem satisfeitos.

## Escopo negativo

Permanece fora desta autorização:

- OCR;
- PDF/livro/conteúdo real;
- Supabase/Storage hospedado;
- produção;
- secrets;
- dados pessoais ou sensíveis;
- persistência de páginas extraídas;
- chunks, embeddings ou C.4.

## Observação de dependência

`pdfjs-dist` já está presente no monorepo por uso do `apps/web`; esta fronteira passa a declarar a dependência diretamente em `@profeplan/knowledge-factory` e a utilizá-la através de adapter isolado, sem expor PDF.js ao contrato parser-neutral.
