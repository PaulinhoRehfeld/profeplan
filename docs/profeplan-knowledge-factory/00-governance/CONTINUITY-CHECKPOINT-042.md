# Checkpoint 042 — C.1.5 integrado e revalidado; C.1.6 permanece bloqueado

Data: 14 de agosto de 2026.

## Estado canônico

- repositório: `PaulinhoRehfeld/profeplan`;
- branch canônica: `main`;
- commit canônico pós-merge técnico de C.1.5: `f033faa51ed33ac504c5775e8bdcca7915c00d89`;
- tree canônica: `ccd3b4e1922eb9cde22802609d0294c3ce61b8c7`;
- parent direto: `6b5f8964ed27345357d4c40ff74444e80dc276bb`;
- PR técnico nº 55: integrado por squash merge em 14 de agosto de 2026;
- título canônico: `test(knowledge-factory): prove C.1.5 integrated source lifecycle (#55)`.

O merge preservou integralmente C.1.1–C.1.4 e não iniciou C.1.6, C.2, wiring de aplicação,
Supabase hospedado, dados reais, ingestão ou produção.

## Autoridade e propósito de C.1.5

A definição canônica do Lote C.1 estabelece C.1.5 como o sublote de **testes de contrato,
integração, segurança e concorrência** cujo objetivo é provar o lifecycle de fontes como capacidade
integrada fora de produção.

C.1.5 não foi reinterpretado como nova camada funcional, caso de uso, adapter ou persistência. A
execução integrou somente a evidência adicional necessária para provar, em conjunto, as garantias já
materializadas por:

- C.1.1 — contratos e política provider-neutral;
- C.1.2 — persistência incremental, RLS e grants;
- C.1.3 — fronteira transacional atômica, competência, idempotência, CAS, concorrência, impacto e
  supersessão;
- C.1.4 — ports, adapters Supabase, tradução provider-neutral de erros/receipts e leitura histórica.

## Artefatos integrados em C.1.5

O diff técnico final permaneceu restrito a três arquivos:

1. `.github/workflows/knowledge-factory-c1-5-lifecycle-ci.yml`;
2. `docs/profeplan-knowledge-factory/12-delivery/LOT-C1-5-SOURCE-LIFECYCLE-TEST-EVIDENCE-MATRIX.md`;
3. `packages/knowledge-factory-supabase/test/source-lifecycle.c1-5.test.mjs`.

C.1.5 não adicionou:

- migration de produto;
- tabela, índice, trigger, grant ou política RLS;
- RPC de produto;
- repository port ou adapter novo;
- regra jurídica duplicada em TypeScript;
- frontend, endpoint, job, fila ou wiring;
- configuração para Supabase hospedado ou produção.

## Matriz de evidências

A matriz integrada em:

`docs/profeplan-knowledge-factory/12-delivery/LOT-C1-5-SOURCE-LIFECYCLE-TEST-EVIDENCE-MATRIX.md`

formaliza as provas positivas e negativas para:

- contratos provider-neutral;
- transições registrais;
- autorização por finalidade;
- janelas temporais;
- suspensão, revogação e bloqueio;
- supersessão;
- impacto conservador;
- idempotência e fingerprint;
- concorrência otimista e concorrência real multi-session;
- atomicidade e rollback por falha parcial;
- competência;
- RLS e grants mínimos;
- leitura histórica;
- tradução de erros;
- validação de receipts;
- ausência de leak de provider;
- rollback estrutural de C.1.3/C.1.4;
- `db lint`;
- minimização e descarte do ambiente.

A matriz também registra explicitamente que a propagação real para entidades futuras de C.2–C.7
não é antecipada por C.1.5. O contrato de impacto é provado apenas dentro das fronteiras já existentes,
sem criar chunk, embedding, artefato derivado, vínculo curricular ou dado real.

## Workflow C.1.5

O gate dedicado integrado é:

`.github/workflows/knowledge-factory-c1-5-lifecycle-ci.yml`

Ele reconstrói uma única stack Supabase descartável e a faz avançar pelos marcos canônicos, em vez de
executar testes congelados de sublotes antigos sobre um schema posterior.

A ordem governada é:

1. fundação transacional histórica + C.1.2;
2. contratos, typecheck e testes provider-neutral;
3. inventário estrutural e matriz RLS positiva/negativa C.1.2;
4. aplicação de C.1.3;
5. competência, least privilege, matriz dos 13 comandos e supersessão;
6. idempotência, fingerprint, CAS e falha parcial injetada;
7. concorrência real multi-session;
8. aplicação de C.1.4;
9. least privilege das leituras históricas;
10. rollback estrutural C.1.4/C.1.3 preservando C.1.2;
11. reaplicação de C.1.3/C.1.4 e revalidação de privilégios;
12. aplicação somente então do fixture sintético necessário aos adapters;
13. regressão E2E C.1.4;
14. prova integrada C.1.5;
15. `supabase db lint --local --level error`;
16. publicação da evidência do run;
17. destruição da stack no passo `always()`.

O baseline descartável de C.1.2 inclui as migrations transacionais canônicas que já existiam antes
desse sublote:

- `202608081600_kf_component_write_rpcs.sql`;
- `202608111900_kf_production_order_write_rpcs.sql`.

Elas são apenas pré-requisitos históricos para reproduzir o inventário congelado de C.1.2 e não
constituem mudança funcional de C.1.5.

## Prova E2E adicional de C.1.5

O teste:

`packages/knowledge-factory-supabase/test/source-lifecycle.c1-5.test.mjs`

comprovou dois cenários integrados adicionais usando somente dados sintéticos:

### Autorização temporal

- registra e valida uma versão de fonte sintética;
- concede autorização de `generation` com janela determinada;
- lê o histórico persistido por meio do adapter C.1.4;
- entrega esse histórico diretamente à política provider-neutral C.1.1;
- confirma elegibilidade durante a janela;
- confirma inelegibilidade por `SOURCE_AUTHORIZATION_EXPIRED` após `effectiveUntil`;
- confirma ausência de campos snake_case/PostgreSQL nos eventos consumidos pela política.

### Supersessão

- registra e valida outra versão de fonte sintética;
- concede autorização de `retrieval`;
- segue a máquina de estados canônica `GRANTED → SUSPENDED → BLOCKED`;
- executa supersessão atômica para nova autorização de `generation`;
- preserva o predecessor como `SUPERSEDED` e referencia o sucessor;
- confirma que a finalidade antiga não é transferida implicitamente;
- confirma que a finalidade do sucessor é avaliada por sua autorização própria;
- lê e valida histórico de impacto sem expor campos internos do provider.

## Validação pré-merge

O HEAD técnico final do PR nº 55 foi:

`3216a7c9938f16ad63bd413aac43555b11c8b4d2`

A branch final estava 8 commits à frente e 0 atrás da `main` de base e continha somente os três
arquivos C.1.5 listados acima.

Todos os gates aplicáveis fecharam verdes sobre esse HEAD:

- CI Pipeline nº 357 — verde;
- Knowledge Factory DB CI nº 55 — verde;
- Knowledge Factory C.1.4 Adapter CI nº 11 — verde;
- Knowledge Factory C.1.5 Lifecycle CI nº 6 — verde;
- C.1.2 schema + RLS — verdes dentro do gate C.1.5;
- C.1.3 competência, least privilege, comandos, supersessão, idempotência, CAS e falha parcial —
  verdes dentro do gate C.1.5;
- C.1.3 concorrência real multi-session — verde dentro do gate C.1.5;
- C.1.4 leitura histórica, rollback/reapply e regressão de adapters — verdes dentro do gate C.1.5;
- prova E2E C.1.5 — verde;
- `db lint` — verde;
- upload de evidência — verde;
- destruição da stack descartável — verde.

O workflow dedicado `Knowledge Factory C.1.3 DB CI` não foi acionado pelo path filter do PR porque o
diff final não alterou arquivo pertencente a C.1.3. A suíte C.1.3 completa aplicável foi reexecutada
explicitamente dentro do gate C.1.5 e ficou verde.

Não havia review thread ou revisão humana pendente no momento do merge.

O bot da Vercel registrou inicialmente mensagens transitórias de limite de deployments gratuitos,
mas o estado final do preview do projeto `profeplan` foi `Ready`. C.1.5 não alterou frontend e Vercel
não foi utilizado como evidência funcional do lifecycle.

## Falhas encontradas e correções governadas

Três problemas reais de validação foram encontrados e corrigidos durante o PR técnico:

### 1. Teste C.1.2 executado sobre schema posterior

A primeira versão do workflow iniciou a stack já contendo C.1.3/C.1.4 e depois executou o teste
estrutural congelado de C.1.2. O teste, corretamente, rejeitou a 25ª tabela introduzida por C.1.3.

Correção:

- não alterar o teste congelado;
- não ampliar o inventário esperado;
- fazer a stack avançar incrementalmente por sublote.

### 2. Baseline C.1.2 incompleto

A primeira reprodução incremental omitiu duas migrations transacionais que já faziam parte do
estado canônico quando C.1.2 foi integrado. O teste congelado voltou a falhar, agora porque o
baseline tinha menos objetos que o marco histórico esperado.

Correção:

- identificar a genealogia do workflow DB canônico;
- incluir as migrations históricas de componentes e OPP no baseline descartável;
- manter C.1.3/C.1.4 ausentes até seus respectivos estágios.

### 3. Premissa incorreta no cenário E2E novo

O primeiro cenário de supersessão C.1.5 tentou executar `block_purpose` diretamente de `GRANTED`.
A máquina de estados C.1.3 exige que o bloqueio de finalidade ocorra a partir de `SUSPENDED`.

Correção:

- preservar a implementação C.1.3;
- alterar somente o teste novo para `GRANTED → SUSPENDED → BLOCKED → SUPERSEDED`;
- reexecutar toda a cadeia.

Nenhuma dessas correções:

- relaxou RLS ou grants;
- eliminou teste legítimo;
- reduziu cobertura;
- concedeu privilégio adicional;
- transformou `service_role` em competência;
- introduziu `any` ou bypass provider-specific no domínio;
- modificou migration ou código funcional do lifecycle.

## Validação pós-merge

O squash merge do PR nº 55 produziu:

- commit: `f033faa51ed33ac504c5775e8bdcca7915c00d89`;
- tree: `ccd3b4e1922eb9cde22802609d0294c3ce61b8c7`;
- parent: `6b5f8964ed27345357d4c40ff74444e80dc276bb`.

A tree do squash é exatamente a mesma tree do HEAD técnico
`3216a7c9938f16ad63bd413aac43555b11c8b4d2` que havia passado todos os gates de banco e integração.
Assim, não houve alteração de conteúdo entre a validação final do PR e a materialização do squash na
`main`.

A própria `main` executou novamente o CI geral no SHA `f033faa51ed33ac504c5775e8bdcca7915c00d89`.

CI Pipeline nº 358:

- Prettier — verde;
- ESLint — verde;
- TypeScript — verde;
- Build — verde;
- Tests — verde.

C.1.5 está, portanto, tecnicamente integrado e revalidado no repositório canônico.

## Segurança e limites preservados

Nenhuma ação de C.1.5:

- acessou Supabase hospedado;
- aplicou migration em produção;
- utilizou secret, `project_ref` ou credencial real;
- criou assignment real de ator;
- processou dado, PDF ou conteúdo real;
- executou OCR, ingestão, extração, chunking ou embedding real;
- alterou os contratos normativos C.1.1;
- alterou a persistência/RLS C.1.2;
- relaxou a fronteira de competência/atomicidade C.1.3;
- reabriu DML ou `SELECT` direto nas tabelas jurídicas protegidas;
- criou adapter paralelo à camada C.1.4;
- implementou frontend, endpoint público ou wiring de aplicação;
- iniciou C.1.6;
- iniciou C.2–C.7;
- tomou decisão de encerramento sobre `GAP-3B-04`;
- ativou operacionalmente a Knowledge Factory em produção.

`service_role` permanece exclusivamente canal técnico server-side. A competência funcional continua
sendo verificada na fronteira transacional C.1.3.

## Estado do Lote C.1

- C.1 — definição integrada;
- C.1.1 — contratos integrados;
- C.1.2 — persistência, RLS e grants integrados;
- C.1.3 — fronteira atômica implementada, integrada e revalidada;
- C.1.4 — ports e adapters provider-neutral implementados, integrados e revalidados;
- C.1.5 — **testes de contrato, integração, segurança e concorrência integrados e revalidados**;
- C.1.6 — bloqueado;
- C.2–C.7 — bloqueados.

`GAP-3B-04` permanece ativo e contido. C.1.5 não decide seu encerramento. A decisão documental de
fechamento do Lote C.1 e a avaliação correspondente do GAP continuam pertencendo exclusivamente a
C.1.6.

## Autoridade de continuidade

Os trechos de documentos macro que ainda indiquem C.1.5 como bloqueado são snapshots anteriores ao
PR nº 55.

Para o estado operacional corrente do Lote C.1, **este Checkpoint 042 prevalece sobre esses marcadores
históricos**, sem modificar a ordem estrutural, dependências e gates do Blueprint, da definição do
Lote C.1 ou do mapa da Fase C.

## Próximo gate

O próximo sublote tecnicamente candidato é C.1.6 — fechamento documental do Lote C.1 e decisão sobre
`GAP-3B-04`, exatamente nos limites definidos pelos documentos canônicos.

C.1.6 **permanece bloqueado**. Este checkpoint não autoriza:

- abertura de branch técnica ou documental de C.1.6;
- encerramento de `GAP-3B-04`;
- início de C.2;
- ingestão, PDF, OCR, extração, chunking ou embedding;
- wiring;
- Supabase hospedado;
- produção.

A continuidade posterior deverá iniciar por inspeção canônica específica de C.1.6 e somente mediante
nova autorização explícita.
