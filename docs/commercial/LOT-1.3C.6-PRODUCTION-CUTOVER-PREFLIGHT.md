# Lote 1.3C.6 — Preflight governado do cutover de produção do motor de créditos

Data: 15 de agosto de 2026.

Base canônica de abertura desta branch: `3b8c2d317542bd701ea61e671f9b6e4334f61b1c`.

Branch: `fix/commercial-credit-cutover-preflight-pdi-enforcement`.

## 1. Estado de governança

**1.3C.6 permanece NO-GO para produção.**

Este documento registra uma inspeção read-only do ambiente hospedado e os artefatos candidatos necessários para que uma futura janela de cutover possa ser autorizada de forma material e reversível.

Nenhuma ação deste preflight autoriza ou executa:

- migration no Supabase hospedado;
- import de `LEGACY_BALANCE` real;
- alteração de `profiles.credits` real;
- criação de grant/ledger entry real;
- alteração de policy/grant hospedado;
- ativação de flags Vercel;
- deploy manual de produção;
- alteração ou deploy de Edge Function;
- alteração externa no Stripe;
- criação de conta de smoke em produção;
- freeze de tráfego;
- cutover.

## 2. Estado canônico do repositório

1.3C.5 foi integrado pelo PR #92 no squash:

`57d7e387676224ef6fb5e3101270c0b6e4f8c245`

Depois disso houve avanço concorrente legítimo da Knowledge Factory pelo PR #93. A `main` passou para:

`3b8c2d317542bd701ea61e671f9b6e4334f61b1c`

A branch de 1.3C.6 nasceu exatamente dessa `main`, preservando integralmente o avanço da Knowledge Factory.

## 3. Supabase hospedado — projeto e estado observado

Projeto canônico inspecionado em leitura:

- nome: `PROFEPLAN`;
- project ref: `uatejrgmbzgoeayfascf`;
- região: `sa-east-1`;
- estado: `ACTIVE_HEALTHY`.

### 3.1 Ledger governado ainda ausente

No momento do preflight não existiam no hospedado:

- `credit_operations`;
- `credit_grants`;
- `credit_ledger_entries`;
- `credit_get_my_balance()`;
- `credit_save_term_plan(...)`;
- `credit_save_generated_content(...)`;
- demais funções públicas `credit_%`.

Portanto, o banco hospedado **ainda opera economicamente no modelo legado**.

### 3.2 Snapshot agregado de saldo legado

A leitura agregada confirmou:

- 31 perfis;
- 27 FREE;
- 3 SILVER;
- 1 Gold/unlimited;
- 30 perfis finitos com saldo positivo;
- soma finita = **292**;
- sentinel legado Gold = **9999**;
- 4 perfis com telefone preenchido.

Fingerprint read-only do preflight:

- finite count: `30`;
- finite sum: `292`;
- finite hash: `04728d96646ee3a8f3753bd9a9ee45f1`;
- Gold/unlimited count: `1`;
- Gold/unlimited hash: `da1b05b43ebe47d7d19b3fef9f037976`.

Esses hashes **não são parâmetros permanentes de produção**. Eles servem apenas como evidência deste preflight. A futura janela autorizada deverá executar novamente `scripts/sql/credit_legacy_balance_snapshot.sql` depois do freeze e usar exclusivamente o snapshot congelado daquela janela.

### 3.2.1 Revalidação read-only posterior ao PR #96

Uma segunda leitura hospedada em 2026-08-15 preservou os invariantes econômicos:

- 31 perfis;
- 30 perfis finitos com saldo positivo;
- soma finita = **292**;
- finite hash = `04728d96646ee3a8f3753bd9a9ee45f1`;
- 1 Gold/unlimited;
- Gold/unlimited hash = `da1b05b43ebe47d7d19b3fef9f037976`.

Os dois snapshots repetidos dessa revalidação foram idênticos. Porém, a distribuição cadastral observada passou a ser 30 FREE, 0 SILVER e 1 Gold/unlimited, com 2 telefones preenchidos. Isso diverge do registro inicial de 27 FREE, 3 SILVER e 4 telefones, embora count, soma e hashes econômicos tenham permanecido estáveis. A divergência documental deve ser reconciliada em uma futura janela; ela não autoriza inferir alteração econômica nem substituir o snapshot congelado.

### 3.3 Atividade observável

No momento da inspeção:

- `term_plans`: 4 linhas;
- `generated_contents`: 60 linhas;
- nenhuma criação/atualização observável nessas superfícies nas últimas 24 horas pelas colunas disponíveis;
- nenhuma criação de perfil nas últimas 24 horas.

A ausência recente de atividade **não elimina a necessidade de freeze**. O cutover altera simultaneamente autoridade de produtores, consumidores, leitura e persistência.

### 3.4 PDI hospedado

Agregados observados:

- `school_students`: 1;
- `pdi_documents`: 0;
- `pdi_records`: 0;
- perfis com escola: 2;
- perfis sem escola: 29;
- papéis: 1 `admin`, 30 `teacher`.

A migration 4D foi comparada ao schema real. O hospedado possui as colunas usadas pelos RPCs governados (`teacher_id`, `student_id`, `school_id`, `block_9_content`, `final_report`, `updated_at`); a ausência de `user_id` nas tabelas PDI não é incompatibilidade, porque 4D não depende dessa coluna.

## 4. Histórico de migrations hospedadas

Na faixa recente, o histórico hospedado registra somente as migrations Stripe já implantadas:

- `20260814134632` — `stripe_webhook_fulfillment`;
- `20260814134734` — `stripe_webhook_fulfillment_rpc_grants`.

Nenhuma migration 1.3B/1.3C do ledger está materialmente aplicada.

Consequência: em produção **não se deve reaplicar cegamente** `20260813_stripe_webhook_fulfillment.sql`. O fulfillment Stripe já existe. A migration 1.3C.3 substitui as funções Stripe mantendo as mesmas assinaturas após a fundação contábil estar disponível.

## 5. Estado server-side legado capturado

O preflight confirmou que o hospedado ainda contém as autoridades econômicas anteriores:

- `handle_new_user()` cria FREE com `credits=10`;
- `update_my_profile(jsonb)` pode criar perfil emergencial com `credits=10`;
- `process_stripe_checkout_event(...)` adiciona `+40` em `profiles.credits` para Silver;
- `process_stripe_subscription_event(...)` usa `profiles.credits` na decisão de downgrade;
- `admin_add_credits(uuid,integer)` incrementa diretamente `profiles.credits`;
- `admin_update_profile(...)` aceita substituição direta de `p_credits`.

As definições hospedadas foram capturadas sem dados de usuário e serviram de base para `scripts/sql/credit_positive_producer_rollback.sql`.

### 5.1 Finding crítico posterior — recuperação de perfil exposta

A leitura dos advisors e da ACL hospedada revelou que a função legada `update_my_profile(jsonb)` é `SECURITY DEFINER` e executável por `PUBLIC`/`anon`. A primeira versão do candidato 1.3C.3 usava `CREATE OR REPLACE` e concedia `authenticated`, mas não revogava os privilégios preexistentes. Como `CREATE OR REPLACE FUNCTION` preserva ACL, o cutover poderia manter o endpoint anônimo.

O corpo anterior também aceitava `auth.uid() IS NULL`, resolvia o alvo por email fornecido pelo chamador e podia criar um perfil com UUID aleatório. Depois da ativação de 1.3C.3, esse INSERT acionaria o produtor `FREE_TRIAL`. Portanto, o problema era simultaneamente uma exposição de autorização e uma quebra da convergência econômica.

A correção versionada de follow-up:

- rejeita identidade nula com SQLSTATE `42501`;
- remove a criação por UUID aleatório e usa somente a identidade autenticada;
- preserva a recuperação por email apenas a partir do email verificado em `auth.users`;
- define `search_path = pg_catalog`;
- revoga `PUBLIC`, `anon`, `authenticated` e `service_role`, concedendo novamente apenas `authenticated`;
- mantém a mesma proteção no rollback econômico;
- prova ACL, guard interno, ausência de criação anônima e ciclo rollback/reaplicação em Supabase descartável.

Nenhuma função hospedada foi alterada por este follow-up. Produção permanece NO-GO.

## 6. Stripe e Edge Function

Conta Stripe observada: `WR TECH AI`.

Leitura do momento do preflight:

- PaymentIntents: 0;
- Charges: 0;
- Subscriptions: 0;
- `stripe_webhook_events` no Supabase: 0.

A Edge Function hospedada `stripe-webhook` está ACTIVE, versão 25. Ela:

- verifica a assinatura Stripe no corpo da requisição;
- chama `process_stripe_checkout_event(...)` com a assinatura de 9 argumentos;
- chama `process_stripe_subscription_event(...)` com a assinatura de 7 argumentos.

A migration 1.3C.3 mantém essas assinaturas. Não foi identificada necessidade técnica de redeploy da Edge Function para o cutover do ledger.

## 7. Vercel e bundle de produção

Projeto: `profeplan`.

O deployment de produção observado permanece READY no SHA:

`57d7e387676224ef6fb5e3101270c0b6e4f8c245`

Deployment ID observado:

`dpl_7F8dnhxgDy6Bv1aJzvvHnEneTo7A`

O avanço posterior da `main` da Knowledge Factory não havia substituído esse deployment de produção no instante desta leitura. A branch de preflight gerou somente previews (`target=null`).

Um deployment READY anterior observado no SHA `01a985a94272608007a57fd60695fed719c625d2` é um candidato técnico de rollback, mas **nenhum deployment deve ser fixado como rollback definitivo sem nova verificação imediatamente antes da janela**.

A inspeção do bundle servido confirmou que as flags governadas não estão materializadas como verdadeiras:

- `VITE_GOVERNED_CREDIT_PRODUCERS`;
- `VITE_GOVERNED_CREDIT_CONSUMERS`;
- `VITE_GOVERNED_TERM_PLAN_SAVE`.

Portanto o código 4A–4E já pode estar publicado, mas permanece economicamente dormente. O runtime atual continua usando o caminho legado coerente com o banco ainda sem ledger.

As flags Vite são build-time. Alterá-las exige novo build/deployment de produção; não são um toggle server-side instantâneo.

## 8. Finding de segurança — bypass PDI por cliente direto

4E havia provado ausência de bypass **no fluxo ativo da aplicação**: quando consumidores governados estão ON, o handler de validação PDI retorna após o RPC e não executa os writes legados seguintes.

1.3C.6 ampliou a ameaça para um cliente autenticado bruto.

O Supabase hospedado ainda concede INSERT/UPDATE em:

- `pdi_records`;
- `pdi_documents`.

As policies permitem writes quando as condições de professor/escola são satisfeitas.

Logo, depois de um cutover sem enforcement adicional, um cliente autenticado poderia tentar persistir diretamente uma adaptação (`ADAPTATION`/`block9`) ou alterar `block_9_content`/`final_report`, contornando as fronteiras econômicas 4D.

### 8.1 Por que não revogar PDI inteiro

Isso quebraria fluxos legítimos não faturáveis.

`pdi_records` também persiste diretamente:

- `EVALUATION`;
- `OCCURRENCE`;
- `LESSON_PLAN`;
- `OBSERVATION`.

`pdi_documents` também recebe updates legítimos de:

- `content_data`;
- `status`;
- demais seções pedagógicas não faturáveis.

### 8.2 Enforcement granular candidato

Foi versionada, mas **não aplicada em hospedado**:

`infra/supabase/migrations/202608151900_credit_cutover_enforcement.sql`

Ela:

1. revoga INSERT/UPDATE direto de `anon` e `authenticated` em `term_plans` e `generated_contents`;
2. instala trigger granular em `pdi_records` que bloqueia somente `ADAPTATION`/`block9` direto;
3. instala trigger granular em `pdi_documents` que bloqueia somente mudanças diretas em `block_9_content` e `final_report`;
4. preserva writes PDI não faturáveis;
5. deixa os RPCs `SECURITY DEFINER` governados atravessarem o enforcement.

Rollback candidato:

`scripts/sql/credit_cutover_enforcement_rollback.sql`

Ele restaura a ACL legado de `anon`/`authenticated` para TermPlan/generated contents e remove os guards PDI, sem apagar ledger.

## 9. Finding crítico — rollback não pode ser somente flags

A migration:

`202608150225_credit_positive_producer_convergence.sql`

altera comportamento server-side independentemente das flags Vercel.

Depois que for aplicada:

- `handle_new_user()` passa a criar saldo legado 0 + FREE_TRIAL no ledger;
- emergência passa a saldo 0 + producer governado;
- Silver passa a `PURCHASED` no ledger;
- downgrade Gold passa a consultar saldo governado;
- admin de 3 argumentos passa ao ledger;
- admin de 2 argumentos falha fechado;
- `admin_update_profile` rejeita saldo direto.

Portanto, em caso de abort **não basta desligar flags e fazer rollback do frontend**.

Foi versionado:

`scripts/sql/credit_positive_producer_rollback.sql`

O candidato restaura as definições server-side legadas observadas no próprio hospedado, remove o trigger FREE_TRIAL governado e os entry points exclusivos de produtores governados, mas preserva tabelas e histórico do ledger.

O gate 1.3C.6 deve provar:

`governado -> rollback legado -> reaplicação governada`

antes de qualquer GO de produção.

## 10. Import de LEGACY_BALANCE — artefato de produção

O rehearsal histórico 1.3C.2 é explicitamente `Disposable Supabase only` e contém IDs sintéticos. Ele **não é executável em produção**.

Foram versionados:

- `scripts/sql/credit_legacy_balance_snapshot.sql` — somente leitura;
- `scripts/sql/credit_legacy_balance_production_import.sql` — import transacional parametrizado.

O import exige parâmetros obtidos do snapshot congelado:

- count finito;
- soma finita;
- hash finito;
- count Gold/unlimited;
- hash Gold/unlimited;
- `cutover_id`;
- `cutover_at`.

Características:

- trava os source rows sem imprimir IDs;
- aborta antes do primeiro grant se count/soma/hash divergirem;
- exclui Gold/unlimited do `LEGACY_BALANCE`;
- usa `credit_grant_command(...)`;
- cria lotes não expirantes;
- não altera `profiles.credits`;
- reconcilia grant count/sum, CREDIT count/sum e valor por perfil;
- falha diante de outro cutover LEGACY_BALANCE;
- replay exato do mesmo cutover/snapshot é seguro;
- qualquer falha faz rollback integral da transação.

O hash deste preflight nunca substitui o hash da janela de freeze.

## 11. Gate descartável 1.3C.6

Foi adicionado:

`.github/workflows/credit-accounting-1-3c-6-production-preflight-ci.yml`

Sem credenciais de produção, ele deverá provar no mesmo Supabase descartável:

1. static sweep 4E;
2. schema integrado 1.3B/1.3C;
3. captura de snapshot sintético;
4. import production-shaped `LEGACY_BALANCE`;
5. replay idempotente;
6. drift de snapshot -> fail closed;
7. produtores governados;
8. enforcement granular PDI + TermPlan/generated contents;
9. persistência não faturável PDI ainda funcional;
10. RPCs governados funcionando sob enforcement;
11. rollback do enforcement;
12. reaplicação do enforcement;
13. rollback server-side dos produtores;
14. restauração de signup/Silver/admin legado;
15. reaplicação de 1.3C.3;
16. retorno de signup/Silver/admin ao ledger;
17. preservação do cohort LEGACY_BALANCE durante rollback/reaplicação;
18. lint do banco.

Nenhuma prova verde autoriza, por si só, produção.

## 12. Sequência candidata da futura janela de cutover

Ainda sujeita à autorização material e a novo preflight imediatamente anterior.

### Fase A — freeze e evidência

1. confirmar SHA canônico da `main` e SHA servido em produção;
2. confirmar gates verdes;
3. confirmar rollback deployment READY;
4. iniciar freeze/maintenance window;
5. bloquear/liberar zero operações econômicas de usuário durante a transição;
6. executar snapshot read-only final duas vezes e exigir estabilidade;
7. registrar count/soma/hashes finais sem expor IDs.

### Fase B — fundação contábil hospedada

Aplicar, nesta ordem:

1. `202608142140_credit_accounting_schema.sql`;
2. `202608142230_credit_accounting_commands.sql`;
3. `202608142231_credit_accounting_command_invariants.sql`.

Não reaplicar o baseline Stripe já hospedado.

### Fase C — importar saldo legado congelado

Executar exclusivamente o import production-shaped usando os parâmetros do snapshot da janela.

Critérios obrigatórios:

- count exato;
- soma exata;
- hashes exatos;
- nenhum grant Gold/unlimited;
- `profiles.credits` imutável;
- ledger reconciliado antes de prosseguir.

### Fase D — materializar consumers/producers governados

Ainda sob freeze:

1. `202608150115_credit_term_plan_atomic_save_pilot.sql`;
2. `202608150330_credit_generated_content_atomic_save.sql`;
3. `202608151530_credit_pdi_atomic_save.sql`;
4. `202608150225_credit_positive_producer_convergence.sql`.

A migration de produtores é deixada por último nesta fase para reduzir o intervalo em que funções de onboarding/Stripe já mudaram, embora todo o período permaneça congelado.

### Fase E — build governado

Configurar de forma coordenada no ambiente de produção:

- `VITE_GOVERNED_CREDIT_PRODUCERS=true`;
- `VITE_GOVERNED_CREDIT_CONSUMERS=true`;
- `VITE_GOVERNED_TERM_PLAN_SAVE=true` (explícita, ainda que 4E também coordene via consumer gate).

Gerar novo deployment de produção e **não liberar tráfego ainda**.

Verificar:

- SHA esperado;
- deployment READY;
- bundle servido contém gates governados ativos;
- runtime sem erros críticos.

### Fase F — enforcement final

Somente depois do bundle governado estar READY e ainda durante freeze:

aplicar `202608151900_credit_cutover_enforcement.sql`.

Confirmar:

- TermPlan/generated direct write fechado para anon/authenticated;
- PDI billable direct write fechado;
- PDI não faturável preservado;
- RPCs governados executáveis.

### Fase G — smoke e release

Executar smoke controlado antes de liberar tráfego.

O smoke deve cobrir no mínimo:

- leitura governada de saldo;
- um Save genérico;
- TermPlan;
- Assessment/Presentation pelo boundary genérico;
- PDI boundary quando houver contexto controlado;
- Stripe somente por inspeção/compatibilidade, salvo evento real explicitamente autorizado;
- nenhuma mutação de `profiles.credits` por consumo governado;
- receipt/ledger coerentes.

Somente se todos os critérios forem verdes, encerrar freeze.

## 13. Rollback candidato

Se qualquer smoke falhar antes da liberação:

1. manter freeze;
2. executar `credit_cutover_enforcement_rollback.sql`;
3. executar `credit_positive_producer_rollback.sql`;
4. retornar flags governadas para OFF e redeploy/rollback da aplicação para um deployment READY previamente validado;
5. confirmar que o bundle servido está no modo legado;
6. confirmar que signup/Stripe/admin server-side voltaram ao comportamento legado;
7. confirmar que writes legados necessários foram restaurados;
8. **não apagar ledger, grants ou operações já materializados**;
9. reconciliar qualquer operação criada durante smoke;
10. somente depois reabrir tráfego.

Rollback é troca de autoridade, não destruição da trilha contábil.

## 14. Blocker operacional — conta de smoke de débito

Ainda não existe nesta governança uma conta explicitamente autorizada para sofrer um débito real de smoke em produção.

Não é aceitável escolher silenciosamente um professor real.

Antes do GO é necessária uma decisão material entre opções como:

- uma conta interna/controlada já existente e explicitamente designada;
- criação antecipada de uma conta permanente de teste, autorizada, que participe do snapshot legado;
- outra estratégia que prove débito real sem alterar saldo de usuário não consentido.

A conta Gold/admin pode provar `NO_CHARGE` e autoridade de Save, mas **não substitui sozinha** uma prova de débito finito se o critério de release exigir débito real.

## 15. Critérios objetivos de abort antes do GO

Abortar/manter NO-GO se qualquer um ocorrer:

- `main` ou deployment mudou sem reconciliação;
- snapshot final diverge do snapshot congelado;
- saldo finito/count/hash não reconciliam;
- qualquer Gold/unlimited recebe `LEGACY_BALANCE`;
- migration falha;
- função Stripe/Edge perde compatibilidade de assinatura;
- producer rollback não estiver previamente verde;
- `update_my_profile(jsonb)` aceitar identidade nula ou permanecer executável por `PUBLIC`, `anon` ou `service_role`;
- enforcement rollback não estiver previamente verde;
- PDI não faturável quebrar sob enforcement;
- write direto billable sobreviver;
- RPC governado falhar;
- bundle governado não estiver READY;
- conta de smoke não estiver explicitamente autorizada;
- qualquer smoke produzir débito/persistência inesperada;
- rollback deployment deixar de estar disponível/validado;
- surgir tráfego econômico não previsto durante freeze.

## 16. Definition of Done do preflight

O preflight de 1.3C.6 só pode ser considerado tecnicamente pronto para pedir autorização de produção quando:

- todos os artefatos acima estiverem versionados;
- o gate 1.3C.6 estiver verde no mesmo HEAD;
- CI geral estiver verde;
- regressão Knowledge Factory DB estiver verde quando disparada;
- branch estiver reconciliada com a `main` atual;
- nenhum arquivo temporário permanecer;
- o relatório continuar declarando produção NO-GO;
- nenhum recurso hospedado tiver sido modificado pelo preflight.

Mesmo depois disso, produção continuará bloqueada até uma autorização material específica para a janela de cutover.


## 17. Reconciliação operacional pós-Preview

Esta seção registra, de forma sanitizada, as evidências operacionais obtidas depois da integração dos PRs #96 e #98. Ela é uma fotografia de auditoria de 15 de agosto de 2026 e não altera o caráter histórico das seções anteriores.

A classificação permanece:

**1.3C.6 NO-GO para produção.**

### 17.1 Preview de árvore exatamente igual à main

Após o hardening de recuperação autenticada de perfil, a `main` foi confirmada em:

- commit: `2b1a3dbb56268c6da1ceabf6407f934aa22a4ec4`;
- tree: `e580464a0cbffed9e3cdcc37a0a189212639da74`;
- origem: PR #98, `fix(commercial): harden authenticated profile recovery`.

Para obter uma prova hospedada sem promover a `main`, foi criada a branch técnica:

`ops/preview-2b1a3db`

Como a Vercel não gerou um novo Preview para o mesmo SHA já associado à `main`, foi criado um único commit vazio:

- commit: `2aaae3300eb0213dea60fa40f84c970359919c05`;
- mensagem: `chore(ops): trigger exact-tree Vercel preview`;
- parent: `2b1a3dbb56268c6da1ceabf6407f934aa22a4ec4`;
- tree: `e580464a0cbffed9e3cdcc37a0a189212639da74`.

A comparação confirmou um commit à frente, zero atrás e nenhum arquivo alterado. Portanto, o Preview testado possuía árvore exatamente igual à `main` auditada, sem merge ou promoção.

Deployment do aplicativo:

- ID: `dpl_E1PiMMAmxcqZJiMmTz68whRqAAEz`;
- estado observado: `READY`;
- SHA: `2aaae3300eb0213dea60fa40f84c970359919c05`;
- branch: `ops/preview-2b1a3db`;
- target: `null`;
- URL técnica: `profeplan-h0pp7lukb-paulo-roberto-rehfelds-projects.vercel.app`.

Esse deployment era Preview, não produção. Nenhum link temporário de compartilhamento, cookie, token ou credencial efêmera integra esta documentação.

### 17.2 Resultado funcional read-only

A raiz `/` do Preview enviava o usuário não autenticado para `/landing`, e essa rota encaminhava para o site público de produção. Por isso, a prova funcional usou diretamente `/login`.

Com a conta interna `suporte@profeplan.com.br`, a validação confirmou:

- usuário existente no Auth;
- email confirmado e senha configurada;
- perfil existente;
- autenticação bem-sucedida;
- criação da sessão;
- carregamento do perfil;
- bootstrap da aplicação;
- redirecionamento interno para `/app`;
- renderização da visão geral e da navegação.

Resultado:

**PASS para autenticação e bootstrap read-only do Preview.**

A expressão “read-only” qualifica o domínio econômico e funcional da prova. A autenticação pode atualizar metadados técnicos, como `last_sign_in_at`, e telemetria de login; portanto, não se declara “zero writes absolutos”.

Não foram executados:

- geração de conteúdo;
- primeiro Save;
- consumo ou concessão de crédito;
- produtor econômico positivo;
- alteração de perfil;
- operação administrativa de criação, edição ou exclusão;
- atualização de banco RAG;
- Stripe write;
- deploy ou invocação econômica de Edge Function;
- smoke econômico;
- cutover.

### 17.3 Limitação crítica: Preview sem isolamento de dados

As requisições observadas no navegador autenticaram contra:

`https://uatejrgmbzgoeayfascf.supabase.co`

Esse é o projeto Supabase hospedado canônico. Logo, o Preview comprovou o frontend e o bootstrap da aplicação, mas não comprovou isolamento de dados.

Consequências obrigatórias:

- a prova não autoriza geração, Save, administração ou smoke econômico;
- esse Preview não é validação funcional final da migração de credenciais do PR #99;
- nenhuma credencial administrativa de produção deve ser usada em validação funcional;
- testes mutáveis somente podem ocorrer em Supabase isolado ou branch descartável sem dados de produção;
- o wiring entre o Preview do HEAD final do PR #99 e o ambiente isolado deve ser comprovado antes de qualquer teste funcional daquela frente.

### 17.4 Conta inadequada para smoke econômico

O estado persistido observado para `suporte@profeplan.com.br` foi:

- tier: `FREE`;
- saldo legado: 10 créditos.

A interface, porém, exibiu “Plano Gold”. A inspeção do código confirmou a causa:

1. `apps/web/src/constants.ts` inclui esse email em `ADMIN_EMAILS`;
2. `applyAdminOverride()`, em `useProfeplanAuth.ts`, substitui em memória o perfil por `role=admin`, `is_admin=true`, `tier=GOLD` e `is_unlimited=true`;
3. `Sidebar.tsx` apresenta “Plano Gold” quando o perfil em memória é Gold ou ilimitado.

Não foi comprovada alteração do tier persistido no banco. A divergência é uma representação administrativa client-side, mas basta para tornar a conta não neutra para uma prova de débito finito. Essa conta não deve ser usada como conta econômica de smoke do cutover.

O override do cliente, isoladamente, também não constitui prova de autorização administrativa server-side.

### 17.5 Findings auxiliares do Preview e da cobertura de build

Foi observado erro CORS em recurso auxiliar/PWA redirecionado para a proteção `vercel.com/sso-api`. O aplicativo principal carregou e autenticou; o finding foi não bloqueante para o bootstrap e não deve ser confundido com falha do Supabase. Ele deve ser reavaliado no Preview final se a experiência PWA fizer parte do gate de release.

Embora o deployment tenha terminado `READY`, os logs do build registraram:

`api/auth/admin-create-user.ts(86,32): error TS2339: Property 'getUser' does not exist on type 'SupabaseAuthClient'.`

`api/auth/admin-create-user.ts(150,75): error TS2339: Property 'admin' does not exist on type 'SupabaseAuthClient'.`

Também houve avisos de versão Node/pnpm.

Classificação:

**defeito técnico real e lacuna de cobertura do CI; não impediu o bundle principal, mas bloqueia promoção e cutover até validação do endpoint no HEAD final.**

A explicação estrutural observada foi:

- o build da Vercel executa `pnpm --filter ./apps/web build`;
- o CI executa `pnpm -r typecheck` nos workspaces;
- a pasta raiz `api/` não é um workspace;
- o `tsconfig.json` raiz possui `files: []`;
- assim, CI verde não comprova typecheck de `api/**/*.ts`;
- a análise de funções da Vercel emite os diagnósticos sem torná-los fatais para o deployment.

Como o PR #99 modifica a fronteira compartilhada de `supabaseAdmin`, qualquer correção ou ampliação de cobertura deve ser reconciliada com o HEAD final daquela frente, sem branch concorrente.

### 17.6 Produção reconfirmada como inalterada

Depois da prova do Preview, o deployment produtivo observado permaneceu:

- ID: `dpl_7F8dnhxgDy6Bv1aJzvvHnEneTo7A`;
- SHA: `57d7e387676224ef6fb5e3101270c0b6e4f8c245`;
- branch: `main`;
- target: `production`;
- alias: `app.profeplan.com.br`;
- estado: `READY`.

A `main@2b1a3dbb56268c6da1ceabf6407f934aa22a4ec4` não estava publicada em produção nessa leitura.

Não houve:

- promoção do Preview;
- novo deployment de produção;
- alteração de alias ou flags;
- migration do ledger no Supabase hospedado;
- alteração Stripe;
- deploy de Edge Function;
- início do cutover.

### 17.7 Bloqueios e sequência atualizada de gates

Antes de qualquer pedido de GO para 1.3C.6, permanecem necessários, em ordem governada:

1. concluir a frente do Draft PR #99 sem criar correção concorrente;
2. confirmar, em consoles oficiais, credenciais substitutas por componente;
3. disponibilizar credenciais substitutas somente no ambiente de Preview;
4. comprovar o wiring do Preview com Supabase isolado ou branch descartável sem dados de produção;
5. gerar e identificar um Preview do HEAD final do PR #99;
6. validar `signup`, busca, embeddings e webhook somente no ambiente isolado;
7. resolver ou classificar os erros TypeScript de `admin-create-user.ts` e fechar a lacuna de cobertura de `api/**/*.ts`;
8. revisar e, somente com autorização separada, integrar o PR #99;
9. planejar a troca lado a lado em produção, preservando rollback;
10. considerar revogação das credenciais antigas apenas após autorização posterior e independente;
11. designar ou criar, com autorização material, uma conta econômica neutra;
12. repetir todo o preflight hospedado imediatamente antes da janela;
13. obter autorização material separada para o cutover 1.3C.6.

A existência de preparação técnica, de um Preview READY ou de CI verde não satisfaz esses gates por si só. C.3 da Knowledge Factory permanece fora deste escopo.
