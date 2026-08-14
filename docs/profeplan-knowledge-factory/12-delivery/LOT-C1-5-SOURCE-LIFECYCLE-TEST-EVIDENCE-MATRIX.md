# C.1.5 — Matriz de evidências de testes do lifecycle de fontes

Data: 14 de agosto de 2026.

Base canônica de implementação: `main` em `6b5f8964ed27345357d4c40ff74444e80dc276bb`.

## 1. Autoridade e propósito

Este documento materializa a matriz positiva/negativa exigida pela Definition of Ready de C.1.5 no
Lote C.1. Ele deve ser lido em conjunto com:

- `LOT-C1-SOURCE-LIFECYCLE-GOVERNANCE-DEFINITION.md`;
- `PHASE-C-EXECUTION-MAP.md`;
- `../00-governance/CONTINUITY-CHECKPOINT-041.md`;
- os contratos C.1.1 em `packages/types/src/knowledge-factory/source-lifecycle.ts`;
- a persistência/RLS C.1.2;
- a fronteira transacional C.1.3;
- as portas e adapters C.1.4.

C.1.5 não cria uma nova interpretação do lifecycle. Seu objetivo é **provar o lifecycle como
capacidade integrada fora de produção**, reutilizando as garantias já integradas em C.1.1–C.1.4 e
adicionando somente a cobertura que faltava para o gate de testes.

## 2. Decisão arquitetônica

C.1.5 é uma camada de validação, não uma nova camada funcional.

Por isso, esta implementação não adiciona:

- migration de produto;
- tabela, índice, trigger, grant ou RLS novos;
- RPC de produto;
- repository port novo;
- adapter paralelo;
- regra jurídica duplicada em TypeScript;
- frontend, API, job, fila ou wiring de aplicação;
- acesso a Supabase hospedado;
- dado, arquivo, PDF, secret, project ref ou assignment real.

A prova integrada mantém a separação:

```text
contratos e políticas provider-neutral C.1.1
                ↓
ports C.1.4
                ↓
adapters C.1.4
                ↓
RPCs atômicas C.1.3
                ↓
persistência + RLS C.1.2
                ↓
PostgreSQL/Supabase descartável
```

A competência continua sendo decidida na fronteira transacional. `service_role` permanece apenas o
canal técnico server-side usado pelo adapter e não constitui autorização funcional.

## 3. Definition of Ready verificada

| Requisito | Evidência de entrada | Situação |
|---|---|---|
| C.1.1–C.1.4 integrados | Checkpoint 041 e `main` canônica | satisfeita |
| matriz positiva/negativa | este documento + suítes listadas abaixo | satisfeita para execução |
| ambiente descartável reproduzível | workflows C.1.3/C.1.4 e novo workflow C.1.5 | satisfeita |

## 4. Matriz de evidências

| Capacidade / risco | Prova positiva | Prova negativa / conflito | Evidência executável |
|---|---|---|---|
| contratos provider-neutral | tipos, comandos, eventos e receipts compilam pelas portas | nenhum nome Postgres/Supabase é necessário pelo domínio | typecheck de `knowledge-factory` e `knowledge-factory-supabase`; testes de repository |
| transições registrais | sequência `REGISTERED → PENDING_VALIDATION → VALIDATED` | transições proibidas e CAS obsoleto falham fechadas | `source-lifecycle.test.mjs`; `knowledge_factory_source_lifecycle_commands.sql`; `...atomicity.sql` |
| autorização por finalidade | grant válido produz `GRANTED` para finalidade exata | finalidade diferente não herda permissão | `governed-source-eligibility.test.mjs`; matriz SQL C.1.3; teste C.1.5 |
| janela temporal | grant é elegível durante a janela | antes de `effectiveFrom` e depois de `effectiveUntil` é inelegível | `governed-source-eligibility.test.mjs`; `source-lifecycle.c1-5.test.mjs` |
| suspensão e revogação | histórico preserva grant/suspend/resume/revoke | suspensão/revogação impedem novo uso no instante efetivo | unitários provider-neutral; `source-lifecycle.c1-4.test.mjs`; matriz SQL C.1.3 |
| bloqueio | bloqueio registral/autorizativo produz estado correspondente | grant anterior não sobrepõe bloqueio | unitários provider-neutral; matriz SQL C.1.3 |
| supersessão | predecessor é preservado e sucessor recebe decisão própria | permissão antiga não é transferida implicitamente; finalidade anterior permanece inelegível | matriz SQL C.1.3; `source-lifecycle.c1-5.test.mjs` |
| impacto conservador | comandos restritivos abrem eventos de impacto | nenhuma ação restritiva ignora silenciosamente a necessidade de impacto prevista | matriz SQL C.1.3; teste C.1.5 lê histórico de impacto |
| idempotência | mesmo `commandId` + fingerprint retorna receipt persistido/replay | mesmo `commandId` com payload/fingerprint divergente conflita | unitários; `...atomicity.sql`; `source-lifecycle.c1-4.test.mjs` |
| fingerprint | fingerprint canônico é aceito | fingerprint adulterado falha sem estado parcial | `knowledge_factory_source_lifecycle_atomicity.sql` |
| concorrência otimista | comando com versão/sequência corrente avança | versão/sequência obsoleta conflita | unitários e `...atomicity.sql` |
| concorrência real | sessão vencedora preserva resultado íntegro | disputa multi-session não produz dupla transição | `knowledge_factory_source_lifecycle_concurrency.sh` |
| atomicidade | comando completo persiste receipt/eventos/projeção coerentes | falha tardia injetada não deixa publicação parcial | `knowledge_factory_source_lifecycle_atomicity.sql` |
| competência | ator sintético com assignment/role adequado executa RPC | assignment ausente/expirado, role inadequado e manipulações falham | command schema/atomicity; integração C.1.4 |
| RLS / grants | superfícies explicitamente permitidas funcionam | DML/SELECT direto indevido e privilégios excessivos permanecem negados | `knowledge_factory_source_lifecycle_rls.sql`; command/read schema tests |
| leitura histórica | adapters reconstruem eventos ordenados | query histórica não vira SELECT genérico nas tabelas protegidas | C.1.4 read schema + C.1.4/C.1.5 adapters |
| tradução de erros | erro de competência vira `FORBIDDEN` provider-neutral | mensagem/código interno de Postgres não precisa vazar ao domínio | `source-lifecycle.repository.test.mjs`; `source-lifecycle.c1-4.test.mjs` |
| receipt | receipt válido é traduzido para o contrato C.1.1 | receipt malformado é rejeitado | `source-lifecycle.repository.test.mjs` |
| provider-neutrality E2E | histórico persistido alimenta diretamente política C.1.1 | campos snake_case do provider não aparecem nos eventos entregues à política | `source-lifecycle.c1-5.test.mjs` |
| rollback estrutural | C.1.3/C.1.4 podem ser reaplicados | rollback não remove a fundação C.1.2 | rollback SQL C.1.3/C.1.4 + workflow C.1.5 |
| DB lint | banco descartável fecha sem erro de lint | nenhuma exceção é mascarada | `supabase db lint --local --level error` no CI C.1.5 |
| minimização | fixtures usam apenas UUIDs e metadados sintéticos | nenhum PDF, conteúdo real, usuário real ou secret hospedado é usado | workflow C.1.5 e fixtures de teste |
| descarte | stack é encerrada no passo `always()` | ambiente descartável não persiste como infraestrutura operacional | workflow C.1.5 |

## 5. Propagação de impacto sem antecipar C.2–C.7

A definição de C.1.5 exige provar o contrato de propagação com fixtures sintéticas, sem implementar
as entidades futuras. Essa obrigação é satisfeita pela combinação das invariantes do contrato e da
fronteira C.1.3:

- comandos restritivos geram impacto conservador de forma atômica;
- o impacto é uma decisão/histórico próprio e não uma mutação de um derivado futuro;
- C.1 não materializa `processing_run` ou `derived_artifact` como identidades produtivas;
- o teste de atomicidade confirma que kinds futuros não entram pela fronteira C.1.3;
- cenários de execução, derivado simples/multifonte, embedding, grafo, currículo e produto histórico
  permanecem fixtures conceituais do contrato de impacto, e sua integração real pertence aos lotes
  que criarem essas entidades.

Nenhum teste de C.1.5 deve criar chunk, embedding, conteúdo extraído, vínculo curricular produtivo ou
outro artefato real apenas para satisfazer artificialmente este gate.

## 6. Workflow dedicado

O gate adicional é:

`.github/workflows/knowledge-factory-c1-5-lifecycle-ci.yml`

Ele usa **uma única stack descartável que avança incrementalmente pelos marcos já integrados**. Essa
ordem é deliberada: testes estruturais congelados de um sublote são executados exatamente no estágio
que eles certificam, sem relaxar seus inventários para acomodar estruturas legítimas de sublotes
posteriores.

A sequência é:

1. iniciar a stack somente com a fundação e C.1.2;
2. executar contratos, typecheck, unitários e a matriz RLS positiva/negativa C.1.2;
3. aplicar a migration C.1.3 no mesmo banco descartável;
4. validar competência, least privilege, matriz completa de comandos e supersessão;
5. validar idempotência, CAS, fingerprint, falha parcial injetada e concorrência real multi-session;
6. aplicar a migration C.1.4 no mesmo banco descartável;
7. validar least privilege das leituras históricas C.1.4;
8. ensaiar rollback estrutural isolado de C.1.4 e C.1.3, preservando C.1.2;
9. reaplicar C.1.3/C.1.4 e revalidar suas superfícies de privilégio;
10. aplicar somente então o fixture sintético de actors necessário aos adapters;
11. executar a regressão E2E C.1.4;
12. executar a prova integrada C.1.5 de expiração temporal, supersessão e provider-neutrality;
13. executar `db lint`;
14. publicar a evidência técnica do run;
15. destruir a stack no passo `always()`.

Credenciais locais geradas pela stack descartável são mascaradas e não são armazenadas na matriz ou
nos logs deliberados. O workflow não lê secrets de Supabase hospedado e não conhece `project_ref` de
produção.

## 7. Critério de aceitação técnico de C.1.5

C.1.5 técnico somente pode ser considerado apto ao merge quando:

- `CI Pipeline` estiver verde;
- `Knowledge Factory DB CI` permanecer verde quando aplicável;
- `Knowledge Factory C.1.3 DB CI` permanecer verde quando aplicável;
- `Knowledge Factory C.1.4 Adapter CI` permanecer verde quando aplicável;
- `Knowledge Factory C.1.5 Lifecycle CI` estiver verde;
- nenhum privilégio, contrato ou teste anterior tiver sido relaxado;
- não houver migration ou código funcional novo sem necessidade normativa;
- o diff permanecer restrito à prova C.1.5;
- nenhuma evidência depender de produção.

## 8. Limites

Este documento e os testes de C.1.5 **não autorizam nem iniciam C.1.6**.

Permanecem fora de escopo:

- fechamento de `GAP-3B-04`;
- C.2–C.7;
- ingestão, PDF, OCR, extração, chunks e embeddings reais;
- wiring de aplicação;
- frontend ou endpoint público;
- Supabase hospedado;
- migrations de produção;
- assignments, usuários, fontes ou dados reais.

A decisão documental de encerramento do Lote C.1 e sobre `GAP-3B-04` continua pertencendo
exclusivamente a C.1.6. O fechamento pós-merge desta conversa pode registrar que C.1.5 foi integrado,
mas não deve antecipar essa decisão.
