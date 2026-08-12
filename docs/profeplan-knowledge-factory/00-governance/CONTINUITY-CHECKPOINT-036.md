# Checkpoint 036 — C.1.2 implementado em branch, aguardando PR e DB CI

Data: 12 de agosto de 2026.

## Estado canônico de partida

- repositório: `PaulinhoRehfeld/profeplan`;
- `main`: `2db5fc07378cc7c062753078b2a3fb2025cb1afe`;
- tree: `cd477c5ba7b84e8bae14a39e2d6e86228f95b819`;
- PR nº 33: merged;
- C.1.1: integrado;
- Checkpoint 035: registro histórico preservado e não reescrito.

## Escopo autorizado

Foi autorizada a criação da branch
`feat/knowledge-factory-lot-c1-2-source-lifecycle-persistence` e a implementação exclusiva de
C.1.2: modelo físico incremental, constraints, índices necessários, RLS, grants, append-only,
histórico temporal, compatibilidade legada, rollback e testes descartáveis.

Continuam fora do escopo C.1.3, RPCs, adapters, wiring, ingestão, conteúdo real, Supabase hospedado,
produção e todas as capacidades das Fases D e E.

## Commits da branch neste checkpoint

- `e845f18cec81d2233832c2716d7b5ab5cc7efbf8` — migration física de C.1.2;
- `20aa3de3f9c33923014cea2a538d7e78f65234e2` — matriz de testes e integração ao DB CI;
- `50b9ab2a3e6b4efdf94e59db920b56cd693846f7` — imutabilidade física do escopo da autorização.

O commit documental que contém este checkpoint será registrado no handoff final da branch.

## Entregas materiais

- sete tabelas aditivas para identidades, fundamentos, projeções, autorizações, eventos e recibos;
- eventos como fonte autoritativa e projeções correntes reconstruíveis;
- seis estados registrais, sete estados de autorização e dez finalidades persistidos sem super
  status;
- `commandId`/fingerprint, versão e sequência preparados para idempotência e CAS futuros;
- histórico append-only, janela temporal, supersessão e consultas “as of” preserváveis;
- RLS nas sete tabelas, sem policy de escrita;
- grants revogados de `PUBLIC`, `anon`, `authenticated` e `service_role`, com somente leitura
  administrativa RLS-controlled para platform admin autenticado;
- nenhum backfill ou reinterpretação do legado;
- rollback destrutivo guardado para ambiente descartável e estratégia forward-only após dados reais;
- três suítes SQL novas e workflow de duas passagens com rollback/reaplicação.

## Compatibilidade

`kf_sources.status`, `allowed_uses`, `license_category`, `kf_source_permission_events`, repository,
mapper e adapter legados permanecem inalterados. `approved`, `draft`, `allowed_uses` e eventos
`grant/revoke/block` não foram convertidos em lifecycle governado porque os dados existentes não
provam ator, competência, fundamento, escopo ou janela.

Ausência histórica continua desconhecida, nunca autorização implícita.

## Validações realizadas

- reconciliação integral com `source-lifecycle.ts` 1.0.0;
- parser PostgreSQL aceitou migration e as três suítes SQL;
- inventário acumulado atualizado de 17 para 24 tabelas;
- workflow inclui aplicação, testes C.1.2, rollback guardado, reaplicação e segunda passagem;
- nenhum arquivo de adapter, API, frontend ou agente foi alterado;
- nenhuma RPC de lifecycle foi criada;
- nenhum acesso a produção ou Supabase hospedado foi realizado.

## Validações ainda pendentes

- execução real da migration/testes em Supabase descartável pelo DB CI;
- revisão do diff completo;
- autorização humana separada para abrir draft PR;
- CI e revisão humana do futuro PR;
- verificação da `main` e checkpoint pós-merge, caso a integração seja autorizada.

Não se declara migration, rollback, RLS ou grants “verdes em runtime” antes dessa execução.

## GAPs e gates

- `GAP-3B-04`: ativo e contido; C.1.2 sozinho não o encerra;
- `GAP-3B-05`: ativo e contido; auditoria geral não foi ampliada;
- `GAP-3B-07`: ativo e contido; OPP não foi ampliada;
- C.1.3: não iniciado e bloqueado;
- C.2–C.7: bloqueados;
- Fases D–G: bloqueadas;
- produção: não autorizada.

## Próximo gate seguro

Revisar o diff completo da branch. Somente mediante autorização humana específica poderá ser aberto
um draft PR de C.1.2. A abertura ou integração desse PR não autoriza C.1.3 automaticamente.

