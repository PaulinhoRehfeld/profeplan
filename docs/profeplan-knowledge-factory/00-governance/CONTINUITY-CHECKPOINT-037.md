# Checkpoint 037 — C.1.2 revisado e CI verde, aguardando integração

Data: 12 de agosto de 2026.

## Estado canônico de referência

- repositório: `PaulinhoRehfeld/profeplan`;
- `main`: `2db5fc07378cc7c062753078b2a3fb2025cb1afe`;
- tree canônica da `main`: `cd477c5ba7b84e8bae14a39e2d6e86228f95b819`;
- PR nº 33: integrado;
- C.1.1: integrado;
- PR nº 34: aberto como Draft contra `main`;
- branch do PR nº 34: `feat/knowledge-factory-lot-c1-2-source-lifecycle-persistence`;
- HEAD técnico submetido à revisão/DB CI: `c742a422373271633dea86ade80afeb3d1a7c396`;
- Checkpoint 036: preservado como registro histórico do estado anterior à abertura do PR.

## Autorizações humanas registradas nesta etapa

Foram concedidas autorizações humanas específicas e separadas para:

1. abrir o Draft PR nº 34, sem merge;
2. realizar a revisão técnica final do PR nº 34, sem merge;
3. reconciliar documentalmente o estado pós-PR/pós-CI e criar este Checkpoint 037, sem merge e sem
   iniciar C.1.3.

Nenhuma dessas autorizações inclui C.1.3, ingestão, adapters, wiring, Supabase hospedado, produção ou
merge automático.

## Resultado da revisão final do PR nº 34

A revisão somente leitura concluiu que o escopo técnico de C.1.2 está aderente à definição aprovada e
aos contratos de C.1.1.

Gates técnicos revisados:

- base canônica correta;
- branch derivada da `main` esperada;
- escopo restrito à persistência incremental, RLS, grants, rollback, testes e documentação de C.1.2;
- sete tabelas aditivas do lifecycle governado;
- eventos de governança como histórico autoritativo;
- projeções correntes reconstruíveis;
- seis estados registrais, sete estados de autorização, dez finalidades, oito tipos de identidade e
  cinco papéis compatíveis com C.1.1;
- elegibilidade não persistida como booleano autoritativo;
- escopo/fundamento/janela da autorização protegidos contra mutação silenciosa;
- histórico, recibos e identidades protegidos por append-only onde aplicável;
- FKs auditáveis com `ON DELETE RESTRICT`;
- RLS deny-by-default nas sete tabelas novas;
- ausência de policies diretas de `INSERT`, `UPDATE`, `DELETE` ou `ALL` para runtime;
- `service_role` sem grants diretos nas sete tabelas novas;
- platform admin autenticado limitado a leitura administrativa RLS-controlled;
- rollback destrutivo guardado e exclusivo de ambiente descartável;
- legado preservado sem backfill ou reinterpretação semântica;
- nenhuma RPC, adapter, ingestão, frontend, agente ou wiring introduzido por C.1.2;
- nenhuma aplicação em produção ou Supabase hospedado.

Nenhum blocker técnico foi identificado na migration, constraints, RLS, grants ou testes de C.1.2.

## Evidência de CI descartável

### Knowledge Factory DB CI

- workflow: `Knowledge Factory DB CI`;
- run nº 32;
- run id: `31657560628`;
- HEAD validado: `c742a422373271633dea86ade80afeb3d1a7c396`;
- conclusão: `success`.

O job `Validate schema and transactional writes on disposable Supabase` concluiu com `success` e
incluiu, entre outras, as seguintes etapas:

- preparação e inicialização de stack Supabase descartável;
- primeira passagem de schema e constraints acumulados;
- primeira passagem da matriz RLS acumulada;
- primeira passagem do schema específico de C.1.2;
- primeira passagem da RLS específica de C.1.2;
- testes transacionais anteriores da Knowledge Factory;
- ensaio guardado de rollback de C.1.2;
- reaplicação das migrations;
- segunda passagem de schema e constraints;
- segunda passagem da matriz RLS;
- segunda passagem do schema específico de C.1.2;
- segunda passagem da RLS específica de C.1.2;
- lint do banco;
- finalização e upload da evidência;
- destruição da stack descartável.

Artefato produzido:

- nome: `knowledge-factory-db-validation-31657560628`;
- artifact id: `9164984155`;
- digest: `sha256:78108e4a619f9a09f583bc0ab3a75de3f1f60c141667074ebc328756f44b42d9`.

### CI geral

- workflow: `CI Pipeline`;
- run nº 280;
- run id: `31657560699`;
- conclusão: `success`.

Foram concluídos com sucesso formatter check, ESLint, TypeScript, build e testes.

Essas evidências são exclusivamente de ambiente descartável/CI e não autorizam produção.

## Reconciliação documental pós-PR/pós-CI

O blocker documental encontrado na revisão final foi tratado sem reescrever o Checkpoint 036.

Foram reconciliados os documentos vivos de C.1.2 e da navegação da Fase C para substituir o estado
pré-PR/pre-DB-CI pelo estado material comprovado após a execução dos workflows:

- `../09-data/LOT-C1-2-SOURCE-LIFECYCLE-PHYSICAL-MODEL.md`;
- `../10-legal-security/LOT-C1-2-RLS-GRANTS-MATRIX.md`;
- `../BLUEPRINT.md`;
- `../12-delivery/PHASE-C-EXECUTION-MAP.md`;
- `../12-delivery/LOT-C1-SOURCE-LIFECYCLE-GOVERNANCE-DEFINITION.md`;
- `DECISION-LOG.md`;
- `../README.md`;
- este Checkpoint 037.

As alterações posteriores ao HEAD técnico validado são exclusivamente documentais e não modificam a
migration, os testes SQL, o workflow de DB CI ou código de runtime.

## Estado material de C.1.2 após a reconciliação

C.1.2 possui agora evidência para os itens de seu Definition of Done:

- migration aditiva/reversível conforme plano — satisfeita no escopo descartável;
- FKs, constraints, índices e append-only — satisfeitos;
- RLS/grants deny-by-default — satisfeitos;
- risco de `service_role` reduzido conforme decisão aprovada — satisfeito para as sete tabelas novas;
- rollback e reaplicação verdes em ambiente descartável — satisfeitos;
- nenhuma produção aplicada — satisfeito.

Isso significa que os gates técnicos próprios de C.1.2 estão satisfeitos. **Não significa que C.1
esteja concluído**, que `GAP-3B-04` esteja encerrado ou que C.1.3 possa começar automaticamente.

## GAPs e bloqueios preservados

- `GAP-3B-04`: ativo e contido; C.1.2 sozinho não satisfaz contrato + persistência + segurança +
  adapter + testes integrados exigidos para seu encerramento;
- `GAP-3B-05`: ativo e contido;
- `GAP-3B-07`: ativo e contido;
- C.1.3–C.1.6: bloqueados;
- C.2–C.7: bloqueados;
- Fases D–G: bloqueadas;
- ingestão real: não autorizada;
- PNLD real/conteúdo protegido: não autorizado por este checkpoint;
- Supabase hospedado: não autorizado;
- produção: não autorizada.

## Próximo gate seguro

Após esta reconciliação documental, o PR nº 34 deverá ter seus checks confirmados novamente no HEAD
mais recente da branch.

Se os checks permanecerem verdes e nenhuma alteração técnica fora do escopo tiver sido introduzida,
o próximo ato elegível será **uma decisão humana específica sobre a integração de C.1.2**.

Nenhum merge é autorizado por este checkpoint. Uma eventual integração de C.1.2 não autoriza C.1.3.
C.1.3 somente poderá ser aberto depois da integração de C.1.2, da verificação da nova `main` e de uma
nova autorização humana específica.
