# Checkpoint 040 — C.1.3 integrado e revalidado; C.1.4 permanece bloqueado

Data: 14 de agosto de 2026.

## Estado canônico

- repositório: `PaulinhoRehfeld/profeplan`;
- branch canônica: `main`;
- commit canônico pós-merge de C.1.3: `27ca7db0d07550b827c66bd4cdc7a2017d30b72d`;
- tree canônica: `fb58aa14be8a25bddbaae1f33e0344f05bc1a4c3`;
- parent direto: `3ca2ebbcd5ca849f270a1a2f24f53ac750181adc`;
- PR nº 51: integrado por squash merge em 14 de agosto de 2026;
- título canônico: `feat(knowledge-factory): implement C.1.3 atomic source lifecycle boundary (#51)`.

O merge preservou a genealogia recuperada da Knowledge Factory e não incorporou C.1.4, C.2, wiring, Supabase hospedado, dados reais ou produção.

## Escopo efetivamente integrado em C.1.3

C.1.3 materializou exclusivamente a fronteira PostgreSQL atômica já definida nos artefatos normativos do sublote:

- `public.kf_source_actor_assignments` como fonte runtime mínima e autoritativa de competência do ator;
- 13 RPCs públicas estreitas, uma por comando C.1.1;
- `SECURITY DEFINER` com `search_path = pg_catalog, public` nas RPCs públicas;
- helpers internos compartilhados sem `EXECUTE` para `PUBLIC`, `anon`, `authenticated` ou `service_role`;
- `EXECUTE` concedido a `service_role` somente nas 13 RPCs aprovadas;
- DML direto de `service_role` sobre as tabelas do lifecycle mantido revogado;
- fingerprint canônico SHA-256 recalculado pelo banco;
- idempotência por `commandId`, replay seguro e conflito por reutilização divergente;
- compare-and-set por estado/version/sequence nas mutações de agregado existente;
- `aggregateVersion` opaco gerado pelo banco e `sequence` monotônica;
- monotonicidade temporal de `occurredAt` e `effectiveAt`;
- impacto conservador aberto atomicamente para comandos restritivos;
- supersessão atômica de autorização com predecessor, successor e impacto no mesmo commit transacional;
- rollback estrutural guardado;
- testes de privilégio, competência, funcionalidade, idempotência, CAS, falha tardia e concorrência real multi-sessão.

A migration integrada é:

`supabase/migrations/202608141120_kf_source_lifecycle_command_boundary.sql`

Ela existe no repositório canônico, mas **não foi aplicada a Supabase hospedado nem a produção**.

## Validação pré-merge

O HEAD final do PR nº 51 foi:

`8b8985d4f2b858927a465ab03241f2cde0f15367`

Todos os gates aplicáveis fecharam verdes antes do squash merge:

- CI Pipeline nº 340 — Prettier, ESLint, TypeScript, Build e Tests verdes;
- Knowledge Factory DB CI nº 44 — schema, RLS, escritas transacionais anteriores, concorrência, rollbacks, adapter integration e `db lint` verdes;
- Knowledge Factory C.1.3 DB CI nº 2 — verde em dois passes completos;
- Vercel `profeplan` — Ready;
- Vercel `site` — Ready;
- nenhuma review thread pendente;
- PR 8 commits à frente e 0 atrás da base canônica;
- diff final restrito a 7 arquivos novos de migration, testes e CI de C.1.3.

## Evidência da correção do primeiro CI C.1.3

O primeiro run do workflow dedicado C.1.3 falhou antes dos testes novos porque a stack descartável foi inicialmente montada já com a migration C.1.3, enquanto a suíte histórica de C.1.2 exige provar explicitamente o estado pré-C.1.3 — exatamente 24 tabelas Knowledge Factory e ausência da superfície de comando C.1.3.

A falha não foi mascarada. O workflow foi corrigido para preservar a ordem de prova:

1. iniciar Supabase descartável somente até C.1.2;
2. provar schema/RLS de C.1.2 intactos;
3. aplicar C.1.3 explicitamente por `psql` no banco descartável;
4. executar segurança, competência, 13 comandos, atomicidade e concorrência;
5. ensaiar rollback estrutural C.1.3;
6. reaplicar C.1.3;
7. repetir a suíte;
8. concluir com `supabase db lint --local --level error`.

O segundo run passou integralmente. Assim, C.1.3 foi comprovado como camada adicional sobre C.1.2, não como redefinição silenciosa da fundação anterior.

## Validação pós-merge

Após o squash merge, a própria `main` no SHA `27ca7db0d07550b827c66bd4cdc7a2017d30b72d` executou novamente o CI geral e concluiu com sucesso:

- Prettier — verde;
- ESLint — verde;
- TypeScript — verde;
- Build — verde;
- Tests — verde.

A integração está, portanto, estabilizada no repositório canônico.

## Segurança e limites preservados

Nenhuma ação de C.1.3:

- acessou Supabase hospedado;
- aplicou migration em produção;
- utilizou `project_ref`, secret ou credencial real;
- criou assignment real de ator;
- processou dado real;
- iniciou PDF, PNLD, OCR, extração ou ingestão;
- alterou contratos C.1.1;
- implementou adapter C.1.4;
- realizou wiring de aplicação;
- iniciou C.2.

`service_role` permanece apenas canal técnico. A competência jurídico-editorial é verificada separadamente por assignment vigente no `occurredAt`.

## Estado do Lote C.1

- C.1 — definição integrada;
- C.1.1 — contratos integrados;
- C.1.2 — persistência, RLS e grants integrados;
- C.1.3 — **implementado, integrado e revalidado em ambiente descartável**;
- C.1.4 — bloqueado;
- C.1.5 — bloqueado;
- C.1.6 — bloqueado;
- C.2–C.7 — bloqueados.

C.1.3 não encerra isoladamente `GAP-3B-04`. O fechamento continua destinado a C.1.6 após C.1.4 e C.1.5 serem definidos, autorizados e integrados conforme seus próprios gates.

## Autoridade de continuidade

Os trechos de estado de `BLUEPRINT.md` e `12-delivery/PHASE-C-EXECUTION-MAP.md` que ainda registram C.1.3 como bloqueado são snapshots anteriores ao PR nº 51.

Para o estado operacional corrente de C.1, **este Checkpoint 040 prevalece sobre esses trechos históricos**, sem alterar a ordem estrutural, dependências ou gates definidos nesses documentos. Uma futura normalização integral de navegação poderá atualizar esses textos sem reabrir decisões técnicas já integradas.

Essa precedência documental evita reescrever arquivos macro extensos apenas para alterar marcadores de status e impede que uma atualização de navegação seja interpretada como início de C.1.4.

## Próximo gate

O próximo sublote tecnicamente candidato é C.1.4 — adapters de comando/leitura e tradução provider-neutral.

Ele **permanece bloqueado**. Este checkpoint não autoriza:

- implementação de C.1.4;
- abertura de branch técnica de C.1.4;
- C.1.5 ou C.1.6;
- C.2;
- Supabase hospedado;
- produção.

A continuidade técnica deverá começar por inspeção e Definition of Ready de C.1.4 somente após autorização própria.
