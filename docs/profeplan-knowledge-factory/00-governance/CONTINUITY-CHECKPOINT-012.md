# CONTINUITY CHECKPOINT 012 — Definição documental do Lote 3B aprovada

Data: 7 de agosto de 2026.

## Status

**Definição documental do Lote 3B aprovada integralmente por decisão humana. ADR-040 a ADR-047 aprovadas. GAP-3B-01 a GAP-3B-05 reconhecidos e mantidos como restrições arquitetônicas. Nenhum adapter foi implementado. Produção não foi acessada.**

## Base

Repositório:

`PaulinhoRehfeld/profeplan`

Base original da definição:

`main` em `82b5dce90d2cb7437922dfc27062b1f16aa0c0a6`

Lote 3A já integrado e validado em Supabase descartável.

## Objetivo aprovado do Lote 3B

Criar adapters Supabase em pacote próprio para as portas do domínio, sem contaminar `@profeplan/knowledge-factory` com infraestrutura e sem ampliar escopo por conveniência técnica.

## Documentos canônicos

- `12-delivery/LOT-3B-DEFINITION.md` — arquitetura geral, dependências, contexts, gaps, ordem e primeiro PR;
- `09-data/LOT-3B-ADAPTER-MAP.md` — porta → tabela → operação → client;
- `09-data/LOT-3B-TRANSACTION-STRATEGY.md` — atomicidade e futuras RPCs;
- `11-testing/LOT-3B-TEST-STRATEGY.md` — unitários, integração descartável e isolamento;
- `12-delivery/LOT-3B-RISK-REGISTER.md` — riscos e gates;
- `12-delivery/LOT-3B-PRODUCTION-BOUNDARY.md` — separação entre 3B e produção;
- `00-governance/LOT-3B-ARCHITECTURE-DECISIONS.md` — ADRs 040–047 aprovadas;
- `00-governance/DECISION-LOG.md` — decisões consolidadas.

## Inspeção confirmada

1. as cinco portas abstratas do Lote 2 continuam intactas;
2. `api/` é a superfície server-side efetivamente publicada pelo Vercel no produto atual;
3. existe `api/_lib/supabaseAdmin.ts` com client privilegiado server-side;
4. o novo pacote não deve importar `api/`;
5. não foi encontrada Unit of Work canônica;
6. há padrão de test double Supabase em testes de caracterização do frontend, utilizável apenas como referência;
7. o Lote 3A oferece Supabase descartável real no GitHub Actions;
8. `@profeplan/logger` possui JSON/correlation, mas também filesystem síncrono e acoplamento Node;
9. `@supabase/supabase-js` já existe no monorepo;
10. produção continua desnecessária para desenvolver e testar o 3B.

## Arquitetura aprovada

Novo pacote:

`packages/knowledge-factory-supabase/`

Workspace:

`@profeplan/knowledge-factory-supabase`

O pacote receberá clients por injeção e não lerá env.

### SYSTEM context

Para corpus global e auditoria, com client privilegiado criado server-side no composition root.

### REQUESTER context

Para operações privadas sujeitas a RLS, sobretudo OPP.

## GAPs reconhecidos e ainda abertos

### GAP-3B-01 — CurriculumRepository

`findActivePackageByState(state)` é ambíguo porque o banco define unicidade por `(state, stage)`.

Adapter curricular permanece bloqueado até alteração de contrato aprovada que inclua etapa.

### GAP-3B-02 — componente + versão

Componente + primeira versão/current version exige atomicidade multi-tabela.

Escrita permanece bloqueada até RPC/função transacional ou fronteira equivalente aprovada.

### GAP-3B-03 — OPP + evento

Transições de OPP e seus eventos exigem atomicidade.

Transições via adapter permanecem bloqueadas até fronteira transacional e requester client aprovados.

### GAP-3B-04 — lifecycle de fonte

`KnowledgeSourceRepository` não expõe gravação de `SourceVersion`, `SourceSegment` ou `SourcePermissionEvent`.

O adapter não inventará ingestão fora da porta.

### GAP-3B-05 — auditoria física mais rica que o contrato

`AuditRepository.listByAggregate()` retorna `DomainEvent`, enquanto `kf_audit_events` também persiste ator, papel, correlation id, outcome e reason.

O primeiro adapter prova a infraestrutura de persistência/auditoria dentro do contrato atual, mas não conclui uma visão enriquecida de auditoria. US-013.2 continua parcial.

## ADRs aprovadas

- ADR-040 — pacote concreto isolado para adapters Supabase;
- ADR-041 — SupabaseClient por injeção; SYSTEM e REQUESTER separados;
- ADR-042 — `api/` permanece composition root server-side;
- ADR-043 — atomicidade multi-tabela somente por transação real/RPC específica;
- ADR-044 — erros de persistência provider-neutral;
- ADR-045 — observabilidade injetada e sanitizada;
- ADR-046 — testes reutilizam Supabase descartável do Lote 3A;
- ADR-047 — implementação incremental por porta; AuditRepository primeiro.

As ADRs estão consolidadas no `DECISION-LOG.md`.

## Primeiro PR de código autorizado após merge documental

Branch:

`feat/knowledge-factory-supabase-audit-adapter`

Título:

`feat(knowledge-factory): add Supabase audit repository adapter`

Escopo estrito:

- criar `@profeplan/knowledge-factory-supabase`;
- implementar somente `AuditRepository`;
- mapper explícito;
- erro provider-neutral sanitizado;
- telemetria injetada;
- SYSTEM client injetado;
- testes unitários;
- integração no Supabase descartável;
- ajuste mínimo de CI se necessário.

Não inclui API, produção, migration/RPC nova, mudança de contrato público ou segunda porta.

## Ready for Code após integração deste PR documental

Somente:

`US-013.2 — persistence/audit adapter infrastructure slice`

Esse status representa fatia parcial e não `Done` integral da Story.

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

1. integrar este PR documental à `main` após CI verde;
2. registrar o commit efetivo de merge;
3. criar checkpoint pós-merge antes do próximo fork;
4. iniciar em nova conversa somente a primeira fatia `AuditRepository`.

## Próximo fork

**Ainda não realizar fork até o merge documental e o checkpoint pós-merge.**