# CONTINUITY CHECKPOINT 011 — Lote 3A integrado à main

Data: 7 de agosto de 2026.

## Status

**Lote 3A — Schema, constraints, RLS e testes de isolamento — aprovado operacionalmente, validado em Supabase descartável e integrado à `main`. Produção permanece proibida. Lote 3B ainda não iniciado.**

## Repositório

`PaulinhoRehfeld/profeplan`

## Merge do Pull Request nº 7

Pull Request:

`feat(knowledge-factory): add persistence schema and RLS foundation`

Resultado do merge: **SUCCESS**

Método: squash

Commit resultante na `main`:

`c67394127376911ca0a26cdb53ee2624ccb257c0`

Head validado antes do merge:

`7bca583c4d2b0c3853d21fdc5f89b92bf43d99d2`

## Validações concluídas antes do merge

### CI geral do monorepo

Workflow: `CI Pipeline`

Run ID: `31193491502`

Resultado: **SUCCESS**

Passaram:

- instalação;
- Prettier;
- ESLint;
- TypeScript typecheck;
- build;
- testes do monorepo.

### CI de banco da Knowledge Factory

Workflow: `Knowledge Factory DB CI`

Run ID: `31193491591`

Resultado: **SUCCESS**

O workflow executou em Supabase local/descartável no GitHub Actions, sem credenciais de projeto Supabase hospedado e sem acesso a produção.

Foram comprovados:

1. baseline sintética mínima;
2. aplicação da migration 3A;
3. testes de schema e constraints;
4. matriz RLS com identidades sintéticas distintas;
5. rollback guardado;
6. confirmação `OK:rollback_isolated`;
7. reaplicação da migration;
8. segunda execução dos testes de schema;
9. segunda execução da matriz RLS;
10. `supabase db lint --local --level error` sem erros;
11. destruição do ambiente descartável sem backup.

## Fundação física integrada

A `main` agora contém a fundação física da Knowledge Factory com as 15 tabelas `public.kf_*` aprovadas, além de:

- constraints e FKs de proveniência;
- coerência de `current_version_id`;
- pacote curricular ativo único por `(state, stage)`;
- bloqueio de RS ativo no MVP;
- RLS deny-by-default;
- isolamento de OPP por `requester_id = auth.uid()`;
- `school_admin` sem privilégio global automático;
- leitura administrativa restrita ao papel global `admin`;
- append-only para permission events, OPP events e audit events;
- testes SQL sintéticos;
- workflow Supabase descartável de validação.

## O que NÃO foi feito

Não houve aplicação da migration no Supabase de produção.

Também não foram iniciados:

- adapters Supabase;
- Lote 3B;
- API da Knowledge Factory;
- jobs;
- retrieval;
- embeddings;
- pgvector;
- agentes executáveis;
- Sócrates 2 executável;
- PNLD real;
- currículo MG real;
- currículo RS;
- frontend;
- Gráfica;
- integração com Nexus.

## Gate de produção

O merge do PR nº 7 NÃO constitui autorização para aplicar a migration em produção.

Antes de qualquer ação no Supabase real continuam obrigatórios:

1. identificar formalmente o projeto Supabase alvo;
2. capturar snapshot/schema atual do banco alvo;
3. analisar drift entre banco alvo e migrations versionadas;
4. confirmar backup/pre-flight;
5. confirmar ausência de objetos `kf_*` no alvo;
6. definir executor e janela;
7. definir comando exato de aplicação;
8. definir resposta e rollback em caso de falha;
9. obter autorização humana explícita específica para produção.

Nenhuma credencial de produção deve ser armazenada em chat ou arquivo versionado.

## Nexus

A integração com Nexus permanece deliberadamente adiada. O foco continua nas funções internas do ProfePlan e na Knowledge Factory.

## Lote 3B

Permanece **não iniciado**.

O próximo ciclo deverá primeiro definir documentalmente o Lote 3B — adapters Supabase — antes de qualquer implementação.

Nenhuma autorização deste checkpoint permite criar adapters automaticamente.

## Próximo fork

**Este checkpoint marca o momento recomendado para o próximo fork.**

Na próxima conversa, o trabalho deverá começar pela definição documental do Lote 3B, preservando o gate separado de produção.
