# CONTINUITY CHECKPOINT 013 — Lote 3B documental integrado à main

Data: 7 de agosto de 2026.

## Status

**Definição documental do Lote 3B aprovada integralmente e integrada à `main`. Primeiro PR de código do Lote 3B autorizado somente para a fatia `AuditRepository`. Produção permanece bloqueada. Nexus permanece adiado.**

## Repositório

`PaulinhoRehfeld/profeplan`

## Merge do Pull Request nº 9

Pull Request:

`docs(knowledge-factory): define Lote 3B Supabase adapters`

Método: squash

Commit resultante na `main`:

`1a7141967dd0592d3bbfe4bee81f5f0dc3d668b8`

Head validado antes do merge:

`37ad16431c426bdb5dc317215942b538f9583cf4`

CI final antes do merge:

- workflow: `CI Pipeline`;
- run: `31215096156`;
- resultado: **SUCCESS**;
- passaram: instalação, Prettier, ESLint, typecheck, build e testes.

## Decisões aprovadas e integradas

- ADR-040 — pacote concreto isolado `@profeplan/knowledge-factory-supabase`;
- ADR-041 — SupabaseClient por injeção; SYSTEM e REQUESTER separados;
- ADR-042 — `api/` permanece composition root server-side do runtime atual;
- ADR-043 — atomicidade multi-tabela somente por transação real/RPC específica;
- ADR-044 — erros de persistência provider-neutral;
- ADR-045 — observabilidade injetada e sanitizada;
- ADR-046 — testes reutilizam Supabase descartável do Lote 3A;
- ADR-047 — implementação incremental por porta, começando por `AuditRepository`.

As ADRs 040–047 estão consolidadas no `DECISION-LOG.md`.

## GAPs reconhecidos e ainda abertos

### GAP-3B-01 — currículo ativo

`CurriculumRepository.findActivePackageByState(state)` não distingue `stage`.

Consequência: adapter curricular permanece bloqueado até alteração contratual aprovada.

### GAP-3B-02 — componente + versão

Criação/escrita completa exige atomicidade real.

Consequência: escrita do `PedagogicalComponentRepository` permanece bloqueada até fronteira transacional aprovada.

### GAP-3B-03 — OPP + evento

Transição de OPP e evento correspondente precisam ser atômicos e usar requester context apropriado.

Consequência: transição OPP via adapter permanece bloqueada até RPC/fronteira transacional aprovada.

### GAP-3B-04 — lifecycle de fonte

A porta de fontes não cobre gravação de `SourceVersion`, `SourceSegment` ou `SourcePermissionEvent`.

Consequência: o adapter não inventará operações de ingestão.

### GAP-3B-05 — auditoria física mais rica que a porta

`AuditRepository` retorna `DomainEvent`, enquanto `kf_audit_events` também persiste ator, papel, correlation id, outcome e reason.

Consequência: o primeiro adapter é uma fatia de infraestrutura e não conclui auditoria enriquecida nem US-013.2 integralmente.

## Primeiro PR de código autorizado

Branch a criar somente no próximo ciclo, a partir da `main` que contém o commit acima:

`feat/knowledge-factory-supabase-audit-adapter`

Título previsto:

`feat(knowledge-factory): add Supabase audit repository adapter`

Escopo exato autorizado:

- criar `packages/knowledge-factory-supabase/`;
- workspace `@profeplan/knowledge-factory-supabase`;
- dependência concreta `@supabase/supabase-js` declarada diretamente no pacote, reutilizando a linha de versão já existente no monorepo;
- dependência nas portas/contratos aprovados;
- implementar somente `AuditRepository`;
- mapper SQL ↔ `DomainEvent`;
- erro de persistência provider-neutral;
- observabilidade mínima injetada e sanitizada;
- SYSTEM client injetado;
- testes unitários;
- integração contra Supabase descartável já existente;
- ajuste mínimo do workflow de CI, somente se necessário para executar a suíte de integração.

## Ready for Code

Após o merge documental, recebe `Ready for Code` somente:

`US-013.2 — persistence/audit adapter infrastructure slice`

Esse status representa **fatia parcial**. Não representa `Done` integral da Story.

## O que continua proibido no próximo PR

- segunda porta;
- mudança das portas públicas existentes;
- RPC ou migration nova;
- Supabase de produção;
- leitura de credenciais reais;
- wiring de endpoint/API;
- frontend;
- retrieval;
- embeddings;
- pgvector;
- reranking;
- ingestão;
- PNLD real;
- currículo MG real;
- currículo RS;
- agentes executáveis;
- Sócrates 2 executável;
- Gráfica;
- Nexus;
- EPIC-018.

## Fronteira com produção

A aplicação da migration 3A em produção continua uma trilha independente.

Antes de produção permanecem obrigatórios:

1. identificação formal do projeto alvo;
2. snapshot/schema atual;
3. análise de drift;
4. backup/pre-flight;
5. verificação de ausência de conflitos `kf_*`;
6. executor e comando exatos;
7. plano de falha/abort;
8. autorização humana específica.

Nenhum adapter deverá ser conectado a runtime de produção antes desse gate.

## Próximo ciclo

O próximo ciclo começa exclusivamente pela implementação controlada do primeiro adapter (`AuditRepository`) no novo pacote Supabase.

Antes de editar código, deverá:

1. confirmar que `main` contém `1a7141967dd0592d3bbfe4bee81f5f0dc3d668b8` e este checkpoint;
2. inspecionar novamente `AuditRepository`, `DomainEvent`, `kf_audit_events` e o workflow descartável;
3. criar a branch `feat/knowledge-factory-supabase-audit-adapter` a partir da `main` integrada;
4. apresentar a árvore exata do pacote;
5. confirmar dependências e lockfile;
6. implementar somente o escopo autorizado;
7. executar unitários, integração descartável e CI geral;
8. abrir PR inicialmente em modo rascunho;
9. não realizar merge automático.

## Próximo fork

**Este checkpoint marca o próximo momento oficial de fork.**

A nova conversa deverá iniciar pela leitura deste `CONTINUITY-CHECKPOINT-013.md` e pela implementação controlada da primeira fatia do Lote 3B.