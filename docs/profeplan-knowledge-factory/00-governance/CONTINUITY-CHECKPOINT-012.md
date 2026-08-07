# CONTINUITY CHECKPOINT 012 — Definição documental do Lote 3B

Data: 7 de agosto de 2026.

## Status

**Definição documental do Lote 3B concluída — aguardando aprovação humana. Nenhum adapter foi implementado. Produção não foi acessada.**

## Base

Repositório:

`PaulinhoRehfeld/profeplan`

Base da definição:

`main` em `82b5dce90d2cb7437922dfc27062b1f16aa0c0a6`

Lote 3A já integrado e validado em Supabase descartável.

## Objetivo do Lote 3B

Criar adapters Supabase em pacote próprio para as cinco portas do domínio, sem contaminar `@profeplan/knowledge-factory` com infraestrutura.

## Documentos criados nesta definição

- `12-delivery/LOT-3B-DEFINITION.md`;
- `12-delivery/LOT-3B-ADAPTER-MAP.md`;
- `12-delivery/LOT-3B-TRANSACTION-STRATEGY.md`;
- `12-delivery/LOT-3B-ERROR-STRATEGY.md`;
- `12-delivery/LOT-3B-OBSERVABILITY-STRATEGY.md`;
- `12-delivery/LOT-3B-TEST-STRATEGY.md`;
- `12-delivery/FIRST-LOT-3B-PR.md`;
- `12-delivery/LOT-3B-RISK-REGISTER.md`;
- `12-delivery/LOT-3B-PRODUCTION-BOUNDARY.md`;
- `00-governance/ADR-040-046-LOT-3B.md`.

## Inspeção concluída

Foi confirmado:

1. as cinco portas abstratas do Lote 2 continuam intactas;
2. `api/` é a superfície server-side efetivamente publicada pelo Vercel no produto atual;
3. existe `api/_lib/supabaseAdmin.ts` com client privilegiado server-side;
4. o novo pacote não deve importar `api/`;
5. não foi encontrada Unit of Work canônica;
6. testes web existentes usam mocks de client Supabase;
7. o Lote 3A oferece Supabase descartável real no GitHub Actions;
8. `@profeplan/logger` possui JSON/correlation, mas também filesystem síncrono e acoplamento Node;
9. `@supabase/supabase-js` já existe no monorepo;
10. produção continua não necessária para desenvolver/testar 3B.

## Arquitetura proposta

Novo pacote:

`packages/knowledge-factory-supabase/`

Workspace:

`@profeplan/knowledge-factory-supabase`

O pacote receberá clients por injeção e não lerá env.

### System context

Para corpus global e auditoria, com client privilegiado criado server-side no composition root.

### Requester context

Para operações privadas sujeitas a RLS, sobretudo OPP.

## Gaps encontrados

### GAP-3B-01

`CurriculumRepository.findActivePackageByState(state)` é ambíguo porque o banco define unicidade por `(state, stage)`.

Adapter curricular fica bloqueado até decisão de contrato.

### GAP-3B-02

Componente + primeira versão/current version exige atomicidade multi-tabela.

Escrita de componente fica bloqueada até RPC/função transacional ou fronteira equivalente aprovada.

### GAP-3B-03

OPP + evento de transição exige atomicidade.

Transições via adapter ficam bloqueadas até fronteira transacional e requester client aprovados.

### GAP-3B-04

KnowledgeSourceRepository não expõe gravação de SourceVersion/Segment/PermissionEvent.

O adapter não inventará ingestão fora da porta.

## ADRs propostas

- ADR-040 — client injection no pacote de adapters;
- ADR-041 — separação system/requester;
- ADR-042 — sem pseudo-transações;
- ADR-043 — tradução de erros;
- ADR-044 — observabilidade injetada;
- ADR-045 — primeiro PR somente AuditRepository;
- ADR-046 — currículo ativo deve incluir `stage` antes do adapter.

Ainda não estão aprovadas nem consolidadas no Decision Log.

## Primeiro PR proposto

Branch futura:

`feat/knowledge-factory-supabase-audit-adapter`

Título:

`feat(knowledge-factory): add Supabase audit repository adapter`

Escopo:

- criar o pacote de adapters;
- implementar somente AuditRepository;
- mapper;
- erro sanitizado;
- logger injetado;
- system context injetado;
- unit tests;
- integração no Supabase descartável;
- ajuste mínimo no CI se necessário.

Não inclui API, produção, migration nova ou segunda porta.

## Ready for Code proposto

Somente:

`US-013.2 — persistence adapter slice`

Esse status só entra em vigor após aprovação humana deste marco documental.

## Produção

Permanece bloqueada e independente do Lote 3B.

Não houve:

- conexão ao Supabase hospedado;
- leitura de project ref;
- uso de service role real;
- snapshot de produção;
- aplicação de migration.

## Nexus

Permanece deliberadamente adiado para etapa final.

## Próximo passo

1. revisão humana desta definição;
2. aprovação/rejeição das ADRs 040–046;
3. se aprovado, consolidar ADRs no Decision Log;
4. integrar PR documental;
5. somente depois autorizar o primeiro PR 3B.

## Próximo fork

**Ainda não realizar fork.**

O momento recomendado será após aprovação e merge da definição documental do Lote 3B, antes de iniciar `feat/knowledge-factory-supabase-audit-adapter`.