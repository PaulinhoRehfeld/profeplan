# CONTINUITY CHECKPOINT 031 — Encerramento do Sublote 3B.5.4 e do Lote 3B.5

Data: 11 de agosto de 2026.

## Estado proposto para integração

**As condições aprovadas para encerrar o Sublote 3B.5.4, o `GAP-3B-03` e o Lote 3B.5 foram
satisfeitas na `main` pela integração humana do Pull Request nº 28. Este checkpoint formaliza
documentalmente esse resultado. Não encerra a Fase B, não inicia a Fase C e não autoriza wiring,
Supabase hospedado, deploy ou produção.**

Base canônica verificada:

- repositório: `PaulinhoRehfeld/profeplan`;
- branch-base: `main`;
- commit-base: `1429107facf816a9a45c12b1ce3ed5cb3c7b6722`;
- origem da base: squash merge do Pull Request nº 28;
- branch documental: `docs/knowledge-factory-close-lot-3b5`;
- Pull Request documental: a registrar após publicação da branch.

## Linha de integração do Lote 3B.5

| Fatia             | Resultado                                                         | Integração |
| ----------------- | ----------------------------------------------------------------- | ---------- |
| Definição do 3B.5 | fronteira tripartida, comandos atômicos e cobertura parcial       | PR nº 24   |
| 3B.5.1            | contrato `3.0.0`, comandos, recibo e contextos                    | PR nº 25   |
| 3B.5.2            | adapter REQUESTER read-only com isolamento por RLS                | PR nº 26   |
| 3B.5.3            | recibos, RPCs, grants, rollback, idempotência e concorrência      | PR nº 27   |
| 3B.5.4            | adapters REQUESTER create e SYSTEM transition exclusivos das RPCs | PR nº 28   |

Commit técnico final do Lote 3B.5:

`1429107facf816a9a45c12b1ce3ed5cb3c7b6722`

## Encerramento pós-merge do Sublote 3B.5.4

O Pull Request nº 28 integrou:

- `SupabaseProductionOrderRequestRepository`, atribuído somente à capacidade REQUESTER de criação;
- `SupabaseProductionOrderTransitionRepository`, atribuído somente à capacidade SYSTEM de
  transição;
- chamada exclusiva a `kf_create_production_order` e `kf_transition_production_order`;
- payloads reconstruídos por allowlist, sem requester, estado ou timestamps derivados indevidos;
- validação estrita de cardinalidade, colunas, identidades, operação, estado, replay e timestamp dos
  recibos;
- erros provider-neutral e telemetria sanitizada;
- testes unitários, de tipo e integração PostgreSQL real pelo Supabase descartável;
- correção ESM necessária para que a entrada pública TypeScript fosse executada pelo Node 22 do CI,
  sem alterar adapters, contratos, migrations, dependências ou lockfile.

Permanecem ausentes, por desenho:

- composição integral das três capacidades em uma única classe concreta;
- DML direto nos adapters;
- criação de client, leitura de env, sessão, token ou credencial;
- fallback REQUESTER para SYSTEM ou SYSTEM para REQUESTER;
- API, frontend, composition root, worker, agente ou wiring;
- Supabase hospedado, dados pedagógicos reais, deploy ou produção.

## Provas pós-integração

- Pull Request nº 28 fechado e integrado por decisão humana;
- head revisado do PR: `1c13562b6641230fe400c96c7f40026e7df1154a`;
- squash na `main`: `1429107facf816a9a45c12b1ce3ed5cb3c7b6722`;
- CI Pipeline nº 268 (`31525199789`): sucesso integral em formatter, lint, typecheck, build e
  testes;
- Knowledge Factory DB CI nº 31 (`31525199791`): sucesso integral em schema, RLS, RPCs,
  concorrência, rollbacks, reaplicação, lint de banco e integração real dos adapters;
- Vercel do PR e pós-merge: sucesso;
- pacote Supabase: 155/155 testes unitários;
- frontend: 87/87 testes;
- agentes: 178/178 testes;
- nenhuma review ou thread pendente;
- nenhuma migration aplicada no Supabase hospedado;
- nenhum acesso a produção, credencial hospedada ou dado pedagógico real.

## Matriz de encerramento

| Alvo      | Critério aprovado                                                                                                    | Evidência integrada                            | Resultado                                |
| --------- | -------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------- | ---------------------------------------- |
| 3B.5.4    | dois adapters exclusivos das RPCs; payload/recibo estritos; separação de papéis; CI e integração descartável verdes  | PR nº 28 + CI nº 268 + DB CI nº 31             | concluído                                |
| GAP-3B-03 | contratos; atomicidade; requester isolation; server-only; rollback; idempotência; concorrência; adapters; checkpoint | PRs nº 25 a 28 + DB CI nº 31 + este checkpoint | encerrado                                |
| Lote 3B.5 | definição e quatro sublotes integrados; provas acumuladas; checkpoint pós-merge                                      | PRs nº 24 a 28 + CI/DB CI + este checkpoint    | concluído após integração deste registro |

O encerramento não elimina os controles que mitigaram o gap. Continuam obrigatórios:

- criação REQUESTER como OPP + evento `created` + recibo na mesma transação;
- transição SYSTEM somente após decisão de domínio aceita;
- ownership esperado, compare-and-set e evento derivado;
- uma RPC aprovada por comando, sem DML direto no adapter;
- idempotência, rollback, replay e concorrência;
- client REQUESTER efêmero e identidade derivada da sessão verificada no futuro composition root;
- erros provider-neutral, recibos estritos e telemetria allowlisted;
- gate independente para wiring e produção.

## GAP-3B-07 preservado e contido

`GAP-3B-07` permanece ativo. O encerramento do Lote 3B.5 significa que a infraestrutura mínima
aprovada para OPP foi concluída; não significa que a OPP normativa esteja funcionalmente completa.

Continuam fora da fatia materializada:

- contexto minimizado de turma, metodologia e requisitos inclusivos;
- actor, sequence, correlation e causation dos eventos;
- tentativas, custos, componentes recuperados e validadores;
- vínculos completos com contexto, retrieval, geração, validação e entrega;
- conclusão integral de US-010.1, US-010.2, US-014.1 e US-016.\*.

Essa contenção satisfaz o limite aprovado pela ADR-052 sem antecipar as Fases C, D ou E.

## Inspeção do gate da Fase B

O encerramento do Lote 3B.5 conclui a ordem de adapters prevista para o Lote 3B, mas não encerra
automaticamente a Fase B. O gate B → C do Blueprint ainda deverá receber decisão documental própria
sobre a contenção dos gaps remanescentes:

- `GAP-3B-04` — lifecycle completo de fontes pertence à futura governança operacional e ingestão;
- `GAP-3B-05` — auditoria enriquecida permanece extensão contratual posterior, com US-013.2
  parcial;
- `GAP-3B-07` — OPP normativa completa permanece extensão futura explicitamente contida.

Não foi identificado novo adapter do MVP a implementar dentro do Lote 3B. A próxima decisão deve
avaliar exclusivamente se essas contenções satisfazem o gate de saída da Fase B, sem definir nem
iniciar código da Fase C por continuidade implícita.

## Estado preservado

- Fase A — concluída;
- Lotes 3B.1 a 3B.4 — concluídos;
- Sublote 3B.5.4 — tecnicamente integrado e documentalmente encerrado por este registro;
- Lote 3B.5 — tecnicamente integrado e proposto para encerramento documental;
- `GAP-3B-01`, `GAP-3B-02`, `GAP-3B-03` e `GAP-3B-06` — encerrados no estado proposto;
- `GAP-3B-04`, `GAP-3B-05` e `GAP-3B-07` — ativos e explicitamente limitados;
- Fase B — não encerrada por este checkpoint;
- Fase C — não iniciada;
- produção — não autorizada.

## Limites desta branch

- somente documentação e governança;
- nenhuma alteração TypeScript, JavaScript, SQL, migration, RPC, grant, RLS, workflow ou lockfile;
- nenhum wiring de API, frontend, composition root, autenticação, worker ou agente;
- nenhum acesso ao Supabase hospedado;
- nenhuma aplicação, deploy ou teste em produção;
- nenhuma fonte, currículo, componente pedagógico, PNLD, PDI, turma ou estudante real;
- nenhum início implícito da Fase C;
- nenhum merge ou auto-merge autorizado por este checkpoint.

## Próximo gate humano

Revisar o Pull Request documental deste checkpoint e decidir entre solicitar ajustes,
rejeitar/adiar ou autorizar seu squash merge.

Somente após eventual integração deste registro poderá ser aberto, em branch documental própria,
o checkpoint de saída da Fase B. Esse próximo gate poderá formalizar a contenção de `GAP-3B-04`,
`GAP-3B-05` e `GAP-3B-07` e decidir se a Fase B pode ser encerrada. A Fase C, o Supabase hospedado,
wiring e produção continuarão bloqueados até autorizações posteriores específicas.
