# C.3.3 — estado corrente da fronteira de leitura e extração textual nativa

**Data:** 18 de agosto de 2026.

Este documento é uma reconciliação corrente de implementação, não um checkpoint de governança.
A execução continua sob `RISK-PROPORTIONAL-EXECUTION-GOVERNANCE.md`.

## Estado integrado

### Primeira fatia — leitura read-only e integridade

- PR nº 103 — integrado;
- squash canônico: `2426e8a1395aa77bba84c681e170c585b5809ecb`;
- porta read-only provider-neutral do artefato;
- locator C.2 permanece opaco ao domínio C.3;
- checkpoint de autorização `artifact_read`;
- revalidação de identidade, retenção, tamanho e SHA-256;
- erros governados para autorização, indisponibilidade, expiração, identidade, tamanho, digest e falha de leitura;
- testes somente com bytes sintéticos;
- nenhum parser, PDF real, Storage hospedado, secret ou produção.

Gates materiais antes da integração:

- CI Pipeline nº 613 — `success`;
- Knowledge Factory C.2.6 Closure CI nº 9 — `success`.

### Segunda fatia — contrato de extração textual nativa

- PR nº 104 — integrado;
- squash canônico: `f81f353530470f192b87a1f25caa8cb7ba214593`;
- `NativeTextExtractorPort` parser-neutral;
- saída limitada a páginas físicas ordenadas, texto e elementos observados;
- método `native_text` identificado por nome e versão;
- logical locators obrigatórios e únicos por página;
- ausência de texto nativo produz `native_text_unavailable` e não inicia OCR;
- erros do parser futuro não podem escapar sem classificação governada;
- nenhum parser concreto ou nova dependência foi introduzido.

Gate material antes da integração:

- CI Pipeline nº 616 — `success`.

O C.2.6 autoacionado no PR nº 104 foi classificado como regressão suplementar, não bloqueante, porque essa segunda fatia opera somente sobre `VerifiedExtractionArtifactRead` já produzido pela fronteira integrada no PR nº 103 e não altera C.2, banco, Storage, handoff ou leitura do artefato.

## Fronteira material atual

O trabalho parser-neutral de C.3.3 está concluído até o ponto em que é necessária uma implementação concreta de parser PDF para transformar bytes PDF sintéticos em páginas/texto reais do parser.

A introdução de uma nova dependência de parser é **Nível B** e exige decisão material agrupada antes de ser adicionada ao repositório.

O candidato técnico inicial é o PDF.js distribuído oficialmente como `pdfjs-dist`, sujeito à decisão explícita da fronteira Nível B e à prova em fixtures PDF sintéticas.

## O que a autorização do parser não autoriza

Mesmo após eventual autorização do parser, permanecem fora de escopo:

- PDF/livro/PNLD real;
- conteúdo protegido real;
- OCR ou modelo multimodal;
- Storage/Supabase hospedado novo;
- persistência incremental de páginas C.3.4;
- embeddings, chunks ou C.4;
- secrets;
- produção;
- dados pessoais ou sensíveis.

## Próxima sequência após autorização Nível B do parser

1. adicionar a dependência de parser aprovada;
2. implementar adapter `NativeTextExtractorPort`;
3. criar PDFs inteiramente sintéticos para texto simples, página vazia, múltiplas páginas, colunas e texto problemático;
4. provar extração determinística ou `native_text_unavailable`/erro governado;
5. executar CI principal e gate específico C.3.3;
6. somente depois avaliar o primeiro ensaio com PDF real juridicamente autorizado, em uma fronteira Nível B independente.

Não há necessidade de checkpoint intermediário entre essas ações técnicas.
