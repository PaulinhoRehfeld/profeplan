# ADR-063 — Fronteira de C.3 entre ingestão, extração e segmentação

**Status:** proposto neste Draft PR; sem efeito canônico antes de integração humana

**Data:** 15 de agosto de 2026

## Contexto

C.2 foi encerrado com staging temporário, integridade, revisão humana e handoff read-only. Os mapas
anteriores ainda distribuíam cartografia editorial, manifesto de páginas, descrição de imagens e
chunks entre C.2 e C.3 de modo incompatível com a implementação integrada. Também não existia uma
autoridade explícita para a execução de extração nem uma separação suficiente entre observação
física do documento e segmentação semântica.

A autorização de C.1 é temporal e revogável. Portanto, um handoff histórico de C.2 é evidência
necessária, mas não pode ser tratado como autorização permanente para ler bytes ou finalizar uma
extração.

## Decisão

1. C.3 terá contrato, identidade, lifecycle, receipts, events e versão próprios. Seu
   `EXTRACTION_CONTRACT_VERSION` não altera `INGESTION_CONTRACT_VERSION = 1.0.0`.
2. C.2 termina em `IngestionHandoffEvidence`; não interpreta páginas e não inicia C.3.
3. C.3 revalida `purpose=extraction` no instante de claim, leitura/retomada e finalização. Um
   estado durável `AUTHORIZED` é proibido.
4. A leitura do artefato usa nova porta provider-neutral, estreita e read-only. O locator de C.2
   permanece opaco. `service_role` é canal técnico, não autoridade de negócio.
5. O baseline de C.3 é extração textual nativa sobre fixtures sintéticas. OCR é exceção governada
   posterior e não integra o baseline.
6. C.3 possui texto, páginas, ordem, marcadores e relações físicas observadas, proveniência,
   cobertura, métricas e decisões de validação.
7. Imagens recebem marcadores e localizadores observados; descrições semânticas geradas não são
   requisito do baseline. Tabelas preservam relações físicas observadas quando o adapter as expõe.
8. C.4 possui chunks/segmentos, confirmação da hierarquia editorial, classificação estrutural,
   pedagógica, curricular e BNCC.
9. O handoff para C.4 é snapshot read-only versionado. C.4 não muta registros de C.3.
10. C.3 será entregue em C.3.1–C.3.8, cada um com autorização, DoR, testes, revisão, merge e
    checkpoint próprios.

## Lifecycle de referência

O fluxo candidato para cristalização em C.3.1 é:

`REQUESTED → READY → EXTRACTING → VALIDATING → PENDING_REVIEW → VALIDATED_FOR_SEGMENTATION`.

Saídas controladas: `REQUIRES_ALTERNATE_EXTRACTION`, `BLOCKED_AUTHORIZATION`, `REJECTED`,
`FAILED` e `CANCELLED`.

## Consequências

- o handoff de C.2 não sofre bump nem mutação informal;
- revogação ou expiração entre efeitos produz bloqueio explícito, sem avanço silencioso;
- extração pode evoluir de forma provider-neutral sem acoplar contrato a Supabase Storage, parser
  ou OCR específicos;
- cartografia observável e interpretação semântica deixam de ser colapsadas;
- qualidade média não compensa ausência de página, autorização inválida ou proveniência quebrada;
- esta ADR não cria schema, migration, adapter, parser, OCR, recurso hospedado ou produção.

## Alternativas rejeitadas

### Reutilizar C.2 como executor

Rejeitada porque mistura ingestão com extração, amplia autoridade de um lote encerrado e transforma
handoff histórico em autorização implícita.

### Persistir `AUTHORIZED` no lifecycle de extração

Rejeitada porque autorização é uma condição temporal e revogável, não um fato permanente do run.

### Criar chunks e hierarquia editorial confirmada em C.3

Rejeitada porque confunde observação física com segmentação e classificação, que pertencem a C.4.

### Incluir OCR e descrições visuais no baseline

Rejeitada porque amplia dependências, risco, custo e superfície de dados antes de existir evidência
de insuficiência da camada textual nativa.

## Governança

Esta ADR somente se torna canônica após revisão e merge humanos. A integração documental não abre
C.3.1. Qualquer implementação exige nova inspeção da `main`, Definition of Ready e autorização
específica.
