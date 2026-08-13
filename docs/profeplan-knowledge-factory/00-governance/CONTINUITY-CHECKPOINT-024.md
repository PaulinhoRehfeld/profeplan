# CONTINUITY CHECKPOINT 024 — Lote 3B.4B.3 adapter Supabase de comandos

Data: 11 de agosto de 2026.

## Estado oficial

**O Lote 3B.4B.3 foi implementado em branch isolada e está preparado para revisão humana. O adapter
consome exclusivamente as quatro RPCs transacionais integradas pelo PR nº 21. Não houve wiring,
acesso à produção, aplicação de migration ou início do Lote 3B.5. `GAP-3B-02` e `GAP-3B-06`
permanecem ativos até eventual integração humana deste sublote.**

Base canônica:

- repositório: `PaulinhoRehfeld/profeplan`;
- branch-base: `main`;
- commit-base: `fdf9bfdb28bea5dc85f9ed6b11913dd69b94cbd1`;
- origem da base: squash merge do PR nº 21.

## Escopo implementado

- `SupabasePedagogicalComponentCommandRepository`, atribuível somente à porta de comandos;
- uma RPC aprovada por método, sem chamadas DML diretas;
- mapper explícito de comando para `p_command_id` + payload fechado;
- mapper e validação integral do recibo provider-neutral;
- replay preservado sem mutação adicional;
- `PT409` → `CONFLICT`;
- `P0002` → `NOT_FOUND`;
- `22023` → `INVALID_INPUT`;
- telemetria allowlisted sem payload, conteúdo pedagógico ou erro bruto;
- exports públicos do pacote atualizados;
- testes unitários sem rede e integração no Supabase descartável.

## Provas locais

- typecheck do pacote Supabase: aprovado;
- testes acumulados do pacote: 118/118 aprovados;
- 23 testes unitários novos do adapter e mapper;
- formatter e `git diff --check`: aprovados;
- lockfile preservado;
- nenhuma migration, RPC, grant, RLS ou schema alterado.

O teste de integração real será executado pelo `Knowledge Factory DB CI`, pois esta sessão não
possui stack Supabase local descartável.

## Limites preservados

- nenhuma composição automática entre adapters read e command;
- nenhum composition root, API ou frontend;
- nenhuma criação de `SupabaseClient` ou leitura de env no adapter;
- nenhum fallback para `.insert()`, `.update()`, `.upsert()` ou `.delete()`;
- nenhum retry automático de mutação;
- nenhum segredo, URL hospedada ou dado pedagógico real;
- nenhum acesso ao Supabase de produção;
- nenhum encerramento antecipado de GAP;
- nenhum início do Lote 3B.5.

## GAPs

### GAP-3B-02

Permanece ativo até a integração humana do adapter que comprova o uso exclusivo das transações
reais já integradas no 3B.4B.2.

### GAP-3B-06

Permanece ativo até a integração humana do fluxo que transporta evidências completas e vínculos
curriculares dentro do comando, sem side-channel.

## Próximo gate

Publicar a branch em Pull Request draft, executar CI geral, DB CI descartável e Vercel, e submeter o
resultado à revisão humana. Nenhum merge está autorizado por este checkpoint.
