# Checkpoint 041 — C.1.4 integrado e revalidado; C.1.5 permanece bloqueado

Data: 14 de agosto de 2026.

## Estado canônico

- repositório: `PaulinhoRehfeld/profeplan`;
- branch canônica: `main`;
- commit canônico pós-merge técnico de C.1.4: `c4620d036addbd2b331ef2aea2396ce104fe9176`;
- tree canônica: `2bd70d132572b49a372cc1020ce3ca0ece0f0d92`;
- parent direto: `096ec8162fc19c68d9a801c9481057b3ab699841`;
- PR nº 53: integrado por squash merge em 14 de agosto de 2026;
- título canônico: `feat(knowledge-factory): implement C.1.4 source lifecycle adapters (#53)`.

O merge preservou integralmente C.1.1–C.1.3 e não iniciou C.1.5, C.1.6, C.2, wiring de aplicação, Supabase hospedado, dados reais ou produção.

## Objetivo efetivamente satisfeito em C.1.4

C.1.4 materializou a camada provider-neutral de acesso ao lifecycle governado de fontes sobre a fronteira transacional de C.1.3, sem reinterpretar o `KnowledgeSourceRepository` legado e sem transferir regra jurídico-editorial para adapters.

Foram integrados:

- novas portas provider-neutral específicas para lifecycle;
- separação entre comandos registrais, comandos de autorização, comando de impacto e leitura histórica;
- `SourceLifecycleRepository` como composição das capacidades aprovadas;
- adapter Supabase de comandos para as 13 RPCs estreitas de C.1.3;
- validação estrita dos receipts retornados pelo provider;
- tradução de erro de competência `PT403` para erro provider-neutral `FORBIDDEN`;
- adapter Supabase de leitura histórica para registro, autorização e impacto;
- três RPCs de leitura `SECURITY DEFINER`, `STABLE` e com `search_path` fixo;
- `EXECUTE` das três RPCs de leitura somente para `service_role`;
- manutenção da revogação de `SELECT` e DML direto de `service_role` sobre as tabelas protegidas;
- mappers SQL ↔ contratos C.1.1 sem exposição de nomes de coluna ao domínio;
- telemetria allowlisted e sanitizada;
- testes unitários e integração em Supabase descartável;
- rollback isolado e reaplicação da fronteira de leitura C.1.4;
- workflow dedicado de validação C.1.4.

## Portas provider-neutral

C.1.4 não ampliou silenciosamente o `KnowledgeSourceRepository` histórico. Foi criada uma superfície própria em:

`packages/knowledge-factory/src/repositories/source-lifecycle.repository.ts`

Ela separa:

- `SourceRegistrationCommandRepository`;
- `SourceAuthorizationCommandRepository`;
- `SourceImpactCommandRepository`;
- `SourceLifecycleCommandRepository`;
- `SourceLifecycleReadRepository`;
- `SourceLifecycleRepository`.

A lista explícita de repository ports da Knowledge Factory foi atualizada para reconhecer `SourceLifecycleRepository` como a sexta porta aprovada, mantendo o teste de inventário exato em vez de enfraquecê-lo.

## Adapter de comandos

O adapter:

`packages/knowledge-factory-supabase/src/source-lifecycle/supabase-source-lifecycle-command.repository.ts`

roteia exclusivamente os 13 comandos C.1.1 para as 13 RPCs C.1.3 correspondentes.

O adapter:

- recebe `SupabaseSystemContext` injetado;
- não cria client Supabase;
- não lê `process.env`;
- não contém regra de competência de negócio;
- não executa DML direto;
- envia `commandId`, fingerprint e payload à RPC estreita correspondente;
- traduz o receipt SQL para o receipt provider-neutral;
- rejeita respostas malformadas do provider;
- preserva idempotência, CAS, atomicidade e competência como responsabilidades da fronteira C.1.3.

## Fronteira de leitura

Como C.1.2 mantém as tabelas do lifecycle protegidas e C.1.4 não poderia reabrir `SELECT` direto para `service_role`, foram criadas três RPCs de consulta:

- `kf_source_list_registration_history`;
- `kf_source_list_authorization_history`;
- `kf_source_list_impact_history`.

A migration integrada é:

`supabase/migrations/202608141730_kf_source_lifecycle_read_rpcs.sql`

As funções são:

- somente leitura;
- `LANGUAGE sql`;
- `STABLE`;
- `SECURITY DEFINER`;
- `SET search_path = pg_catalog, public`;
- schema-qualified;
- executáveis somente por `service_role`;
- não executáveis por `PUBLIC`, `anon` ou `authenticated`;
- incapazes de conceder acesso genérico às tabelas subjacentes.

A migration existe no repositório canônico, mas **não foi aplicada a Supabase hospedado ou produção**.

## Telemetria e erros

A telemetria de C.1.4 foi mantida em superfície allowlisted. Ela pode registrar metadados operacionais como operação, adapter, duração, resultado, agregado, correlação, contagem de linhas e código de erro provider-neutral.

Ela não registra:

- payload de comando;
- `reason`;
- fingerprint;
- identidade completa do ator;
- fundamento jurídico completo;
- conteúdo de fonte;
- credenciais ou secrets.

O mapper compartilhado de erros foi estendido para converter `PT403`/HTTP 403 em `FORBIDDEN`, preservando a semântica de competência negada sem vazar mensagem interna do PostgreSQL ao domínio.

## Validação pré-merge

O HEAD final do PR nº 53 foi:

`58fef3134cc29f566534a967edc6723782169a19`

Todos os gates aplicáveis fecharam verdes sobre esse HEAD:

- CI Pipeline nº 348 — Prettier, ESLint, TypeScript, Build e Tests verdes;
- Knowledge Factory C.1.4 Adapter CI nº 5 — verde;
- Knowledge Factory C.1.3 DB CI nº 7 — verde em sua suíte completa de regressão de segurança/atomicidade;
- Knowledge Factory DB CI nº 49 — verde em sua suíte histórica completa;
- Vercel `profeplan` — Ready;
- Vercel `site` — Ready;
- nenhuma review thread pendente;
- branch técnica 19 commits à frente e 0 atrás da base canônica antes do squash;
- diff final restrito a 16 arquivos de portas, adapters, leitura, testes e CI de C.1.4.

## Evidências de correção durante o PR

Duas correções foram realizadas de forma governada durante a validação:

1. o primeiro CI encontrou exclusivamente divergências de formatação em arquivos TypeScript novos. Um workflow temporário, restrito à própria branch controlada, executou o Prettier oficial do repositório; o workflow temporário foi removido antes do HEAD final e não permaneceu no diff integrado;
2. a suíte monorepo detectou que o teste histórico de inventário congelava exatamente cinco repository ports. Como C.1.4 cria legitimamente `SourceLifecycleRepository`, o teste foi atualizado para continuar exigindo uma lista exata de portas, agora com seis entradas. A asserção não foi removida nem relaxada.

Essas correções não alteraram o escopo funcional ou de segurança de C.1.4.

## Validação em Supabase descartável

O workflow dedicado C.1.4 comprovou, sem Supabase hospedado:

- criação da stack sintética até C.1.4;
- privilégios mínimos das RPCs de leitura;
- manutenção da ausência de `SELECT`/DML direto de `service_role` nas tabelas protegidas;
- typecheck dos packages de domínio e Supabase;
- testes unitários dos adapters e mappers;
- roteamento dos 13 comandos para as RPCs corretas;
- replay idempotente;
- conflito por reutilização divergente de `commandId`;
- leitura histórica de registro com filtro temporal;
- leitura histórica de autorização por finalidade;
- leitura de impactos;
- tradução de ator não competente para `FORBIDDEN`;
- rollback isolado das três RPCs de leitura;
- reaplicação da migration C.1.4;
- revalidação de privilégios;
- `supabase db lint --local --level error` verde.

Os fixtures utilizaram somente UUIDs sintéticos e assignments descartáveis. O helper usado para calcular fingerprints canônicos existe apenas no fixture de teste e não integra migration de produto.

## Validação pós-merge

Após o squash merge, a própria `main` no SHA `c4620d036addbd2b331ef2aea2396ce104fe9176` executou novamente o CI geral.

CI Pipeline nº 349:

- Prettier — verde;
- ESLint — verde;
- TypeScript — verde;
- Build — verde;
- Tests — verde.

C.1.4 está, portanto, tecnicamente integrado e revalidado no repositório canônico.

## Segurança e limites preservados

Nenhuma ação de C.1.4:

- acessou Supabase hospedado;
- aplicou migration em produção;
- utilizou secret, `project_ref` ou credencial real;
- criou assignment real de ator;
- processou dado real;
- alterou os contratos C.1.1;
- removeu a verificação de competência C.1.3;
- reabriu DML ou `SELECT` direto de `service_role` nas tabelas do lifecycle;
- implementou frontend, endpoint, API ou wiring de aplicação;
- iniciou C.1.5 ou C.1.6;
- iniciou C.2, ingestão, PDF, OCR ou extração.

`service_role` permanece exclusivamente um canal técnico de servidor. A competência de negócio continua sendo verificada dentro da fronteira transacional C.1.3.

## Estado do Lote C.1

- C.1 — definição integrada;
- C.1.1 — contratos integrados;
- C.1.2 — persistência, RLS e grants integrados;
- C.1.3 — fronteira atômica implementada, integrada e revalidada;
- C.1.4 — **ports e adapters provider-neutral implementados, integrados e revalidados**;
- C.1.5 — bloqueado;
- C.1.6 — bloqueado;
- C.2–C.7 — bloqueados.

`GAP-3B-04` permanece ativo e contido. Seu fechamento continua destinado a C.1.6 após a conclusão governada das etapas restantes de C.1.

## Autoridade de continuidade

Os trechos de estado de documentos macro que ainda indiquem C.1.4 como bloqueado são snapshots anteriores ao PR nº 53.

Para o estado operacional corrente do Lote C.1, **este Checkpoint 041 prevalece sobre esses marcadores históricos**, sem modificar a ordem estrutural, dependências e gates dos documentos de planejamento.

## Próximo gate

O próximo sublote tecnicamente candidato é C.1.5 — testes unitários, de contrato, integração descartável, idempotência e concorrência na abrangência prevista pela definição do Lote C.1.

C.1.5 **permanece bloqueado**. Este checkpoint não autoriza:

- abertura de branch técnica de C.1.5;
- implementação de C.1.5 ou C.1.6;
- encerramento de `GAP-3B-04`;
- C.2;
- wiring;
- Supabase hospedado;
- produção.

A continuidade deverá começar pela inspeção da Definition of Ready e pela delimitação do que C.1.5 ainda precisa provar sem duplicar desnecessariamente as suítes já integradas em C.1.3 e C.1.4.
