# CONTINUITY CHECKPOINT 023 — Lote 3B.4B.2 migration e RPCs transacionais

Data: 8 de agosto de 2026.

## Status

**O Lote 3B.4B.2 — migration e RPCs transacionais foi implementado em branch isolada e está
preparado para revisão humana. Nenhum adapter Supabase de comando, wiring ou acesso à produção foi
implementado. `GAP-3B-02` e `GAP-3B-06` permanecem ativos.**

## Repositório e continuidade

- repositório: `PaulinhoRehfeld/profeplan`;
- branch padrão: `main`;
- branch técnica: `agent/knowledge-factory-lot-3b4b2-transactional-rpcs`;
- base e merge-base esperados: `d481d998603e9a335edb308cfdb82b7868289cea`;
- definição governante: `12-delivery/LOT-3B4B-COMPONENT-WRITE-BOUNDARY-DEFINITION.md`;
- Pull Request: será registrado após a abertura em draft;
- estado inicial exigido: draft.

## Escopo implementado

### Migration aditiva

- tabela mínima `kf_component_write_receipts`;
- fingerprint SHA-256 calculado no PostgreSQL sobre operação e JSONB canônico;
- nenhum título, resumo, keyword, payload ou conteúdo pedagógico armazenado no recibo;
- RLS habilitado e nenhum acesso direto concedido ao `service_role`;
- revogação de `INSERT` e `UPDATE` diretos do `service_role` nas quatro tabelas do agregado;
- `SELECT` preservado para o adapter read-only já integrado.

### Quatro RPCs estreitas

- `kf_create_pedagogical_component_aggregate`;
- `kf_append_pedagogical_component_version`;
- `kf_transition_pedagogical_component_version_status`;
- `kf_promote_pedagogical_component_version`;
- todas `SECURITY DEFINER`, pertencentes a `postgres` e com
  `search_path = pg_catalog, public`;
- `EXECUTE` somente para `service_role`;
- payloads fechados, invariantes validados e arrays sem duplicatas;
- evidências completas e vínculos curriculares dentro da mesma transação da versão;
- snapshots de versão insert-only;
- advisory lock transacional por `commandId`;
- locks de linha do agregado em ordem determinística;
- compare-and-set para append, transição e promoção;
- replay fiel para mesmo comando/fingerprint e conflito para divergência;
- recibo retornado sem detalhes do provider.

### Rollback e DB CI

- rollback específico recusa remover recibos já persistidos;
- rollback remove RPCs, helpers e recibos sem apagar componentes ou alterar o schema-base;
- grants anteriores são restaurados apenas no ensaio de rollback;
- workflow aplica migrations em ordem, ensaia os dois rollbacks na ordem inversa e reaplica tudo;
- suíte acumulada passa a reconhecer 16 tabelas `kf_*`;
- teste de integração RPC usa chamadas reais via PostgREST no Supabase descartável;
- testes de integração são serializados para evitar interferência entre fixtures sintéticas.

## Provas implementadas

- criação integral do agregado;
- append sem promoção implícita;
- transições aceitas e rejeitadas;
- paridade completa da matriz SQL com a matriz TypeScript;
- aprovação bloqueada sem evidência e currículo;
- promoção com comparação de ponteiro e timestamp;
- replay idempotente e fingerprint divergente;
- rollback em cada etapa física da criação por injeção sintética de falha;
- rollback integral de append quando o recibo falha;
- rollback de transição e promoção quando o recibo falha;
- DML direto do `service_role` negado;
- `anon` e `authenticated` sem execução;
- duas chamadas simultâneas do mesmo comando resultam em um commit e um replay;
- duas promoções concorrentes partindo do mesmo estado resultam em um vencedor e um conflito.

## Validação local concluída

- parser PostgreSQL: migration e duas suítes SQL aceitas;
- réplica PostgreSQL local em WebAssembly: migrations aplicadas;
- suíte transacional: aprovada;
- rollback específico: aprovado;
- rollback-base depois do rollback específico: aprovado;
- reaplicação limpa: aprovada;
- `@profeplan/knowledge-factory-supabase`: typecheck verde;
- testes unitários do pacote: 95/95;
- novo teste de integração: sintaxe JavaScript válida;
- Prettier dos arquivos suportados: verde;
- lockfile: sem alteração.

A réplica local não substitui o Supabase descartável oficial. Concorrência PostgREST, DB lint,
schema, RLS, rollback e integração acumulada deverão ser comprovados pelo DB CI do Pull Request.

## Estado dos GAPs

### GAP-3B-02

Permanece ativo. A atomicidade foi implementada e provada localmente, mas o encerramento ainda exige
DB CI verde, integração humana do 3B.4B.2 e uso exclusivo das RPCs pelo adapter 3B.4B.3.

### GAP-3B-06

Permanece ativo. O contrato `2.0.0` está integrado e as RPCs aceitam evidências completas e vínculos
versionados, mas o adapter transacional ainda não existe.

## Itens expressamente ausentes

- adapter Supabase de comando, mapper de escrita ou fallback para DML direto;
- alteração dos contratos TypeScript `2.0.0` ou da porta;
- API, frontend, composition root ou wiring;
- acesso a Supabase hospedado, secrets ou dados reais;
- migration aplicada, escrita ou integração em produção;
- 3B.4B.3 ou Lote 3B.5;
- encerramento de GAP ou da Fase B;
- merge ou auto-merge.

## Próximo gate humano

Revisar o Pull Request draft do 3B.4B.2 e autorizar — ou não — sua integração controlada.

Mesmo se este sublote for integrado, o 3B.4B.3 permanecerá bloqueado até nova autorização
explícita. Nenhuma continuidade implícita autoriza adapter, wiring, produção ou Lote 3B.5.
