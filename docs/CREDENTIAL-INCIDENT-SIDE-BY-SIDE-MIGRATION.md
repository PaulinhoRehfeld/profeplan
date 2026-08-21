# Migração lado a lado de credenciais expostas

## Estado

Este documento governa a preparação técnica da resposta ao incidente identificado em
`Vassoura_PDF`. Ele não autoriza merge, produção, revogação, reescrita de histórico,
alterações no Supabase hospedado nem início de C.3.

## Objetivos

- remover credenciais literais do estado futuro do repositório;
- aceitar chaves Supabase modernas sem interromper consumidores legados;
- impedir que chaves Google sejam enviadas em parâmetros de URL;
- permitir validação de build e testes em preview sem executar operações contra produção;
- preservar rollback até autorização explícita de cutover e revogação.

## Contrato de seleção

### Vercel e demais backends Node

1. `SUPABASE_SECRET_KEY` é preferida;
2. `SUPABASE_SERVICE_ROLE_KEY` é fallback temporário;
3. chaves `sb_secret_` são enviadas somente no header `apikey`;
4. a chave legada JWT mantém `apikey` e `Authorization: Bearer` durante a convivência.

### Supabase Edge Function `stripe-webhook`

1. ler `SUPABASE_SECRET_KEYS`, que é um objeto JSON injetado pela plataforma;
2. preferir a chave nomeada `stripe_webhook`;
3. usar `default` como fallback moderno;
4. usar `SUPABASE_SERVICE_ROLE_KEY` apenas como rollback legado.

O webhook permanece com `verify_jwt = false`, pois sua autenticação de entrada é a
assinatura `Stripe-Signature`.

A inspeção de 18 de agosto de 2026 confirmou que a branch descartável contém a
`stripe-webhook` versão 5 em estado `ACTIVE`, com o seletor `stripe_webhook` do
candidato atual. Isso comprova implantação na branch isolada, mas não valida assinatura,
fulfillment, mutação de assinatura ou evento financeiro. Nenhum evento Stripe foi executado.

### Google Gemini

`GEMINI_API_KEY` permanece server-side. Chamadas REST usam o header
`x-goog-api-key`, nunca query string. O script de ingestão também exige a chave por
variável de ambiente.

## Matriz de ambientes

| Ambiente | Supabase administrativo | Google | Regra |
| --- | --- | --- | --- |
| Production | configuração atual, sem alteração neste lote | configuração atual | intocada |
| Preview Vercel | somente chave substituta de ambiente isolado | chave substituta restrita | não apontar credencial administrativa para banco de produção |
| Supabase Edge hospedado | configuração atual | não aplicável | não implantar nesta autorização |
| Execução manual | variáveis de ambiente | variável de ambiente | nenhum literal no repositório |

## Estado operacional reconciliado — 15 de agosto de 2026

### Branch Supabase isolada confirmada

Uma frente operacional autorizada em paralelo criou a branch descartável:

- nome: `pr-99-credential-preview`;
- project ref: `qporbmwedjvmbfqghkls`;
- parent project ref: `uatejrgmbzgoeayfascf` (`PROFEPLAN`);
- default: `false`;
- persistente: `false`;
- cópia de dados: `with_data=false`;
- estado observado: `FUNCTIONS_DEPLOYED`;
- preview project status: `ACTIVE_HEALTHY`;
- criação observada: 15 de agosto de 2026, 20:10 UTC.

A existência saudável da branch satisfaz somente o gate de provisionamento do recurso
isolado. Ela não comprova credenciais substitutas, configuração de variáveis Vercel,
wiring do Preview, execução funcional ou isolamento efetivo de uma requisição.

Nenhuma alteração nessa branch Supabase foi executada por esta reconciliação
documental.

### Credenciais e wiring Vercel parcialmente comprovados — 18 de agosto de 2026

A inspeção remota e sanitizada confirmou na branch descartável:

- chave publishable padrão ativa;
- chaves secretas nomeadas `stripe_webhook` e `vercel_preview_pr_99`, com notas de uso descartável;
- ausência de exibição ou registro dos valores completos.

No projeto Vercel `profeplan`, cinco entradas específicas continuam restritas a
`Preview` e à branch `agent/credential-incident-side-by-side-migration`:

- `SUPABASE_SECRET_KEY`;
- `SUPABASE_ANON_KEY`;
- `VITE_SUPABASE_ANON_KEY`;
- `SUPABASE_URL`;
- `VITE_SUPABASE_URL`.

O deployment validado é `dpl_6UKCr7LMwq4bW1RzX7ZQu5s33QPU`, em `READY`,
`target=null`, região `gru1`, associado ao PR 99 e ao SHA
`67e9e1fe38d572833cdd47dd0863bb89925fac45`. O alias da branch aponta para esse
deployment e o build terminou sem os diagnósticos `TS2339`.

Uma tentativa única de login com identidade sintética inexistente retornou
`invalid_credentials`. O evento correspondente apareceu nos logs de Auth de
`qporbmwedjvmbfqghkls` e não apareceu nos logs de Auth da produção. A branch
descartável permaneceu com zero usuários. Isso comprova o wiring da autenticação
frontend para a branch isolada sem criar usuário ou enviar e-mail.

Permanecem não comprovados:

- correspondência de valor da variável server-side `SUPABASE_SECRET_KEY` com
  `vercel_preview_pr_99`, pois o segredo não foi revelado para comparação;
- signup bem-sucedido, sessão válida e logout com identidade descartável aprovada;
- execução isolada de busca e embeddings;
- credencial Google/Gemini substituta e escopo exclusivo por branch;
- validação funcional da Edge Function com evento Stripe sintético autorizado.

### Diagnósticos TypeScript resolvidos — 17 de agosto de 2026

Os Previews anteriores registraram, apesar de terminarem `READY`:

`api/auth/admin-create-user.ts(86,32): error TS2339: Property 'getUser' does not exist on type 'SupabaseAuthClient'.`

`api/auth/admin-create-user.ts(150,75): error TS2339: Property 'admin' does not exist on type 'SupabaseAuthClient'.`

A correção foi dividida em duas fronteiras:

- `bd362c65ae1f1e0502185e6e2be5ed27c8c13c4c` modernizou
  `api/tsconfig.json` e adicionou ao CI o typecheck explícito de `api/**/*.ts`;
- `6285f5767ef62d6c182df910c576c9f3cb51b98a` adicionou uma fronteira estrutural
  tipada para os dois métodos de Auth consumidos por `admin-create-user.ts`, sem
  trocar o objeto de runtime nem alterar o comportamento HTTP do endpoint.

Evidências da resolução:

- CI Pipeline nº 587: `success`, incluindo o novo gate
  `Run API Typecheck (TypeScript)`;
- Credit Accounting 1.3C.3 Positive Producers CI nº 26: `success`;
- Credit Accounting 1.3C.4E Final Sweep CI nº 10: `success`;
- Preview `dpl_2mNbyVfaFCx1wdT9JseuF9dAbmVe` do SHA `6285f576...`:
  `READY`, `target=null`;
- logs do build sem os dois diagnósticos `TS2339`.

Permanecem apenas avisos preexistentes sobre a divergência Node entre
`package.json` e Project Settings e sobre a configuração `pnpm.onlyBuiltDependencies`.
Eles não foram ampliados para esta correção.

A resolução TypeScript não comprova credenciais substitutas, wiring Vercel para a
branch Supabase isolada nem validação funcional de signup, busca, embeddings ou
webhook. Nenhuma variável, credencial, deployment de produção, recurso Supabase,
revogação, merge ou C.3 foi alterado.

## Gates antes de qualquer cutover

- [x] criar chaves Supabase substitutas por componente na branch descartável;
- [x] prover uma branch Supabase descartável sem cópia de dados;
- [x] configurar cinco entradas Vercel somente no Preview e por Git branch;
- [x] comprovar que a autenticação frontend do Preview aponta para a branch isolada;
- [x] executar testes unitários, typecheck, build e inspeção de literais;
- [ ] comparar de forma segura o valor server-side Vercel com `vercel_preview_pr_99`;
- [ ] validar signup, sessão, logout, busca e embeddings somente no ambiente isolado;
- [ ] criar e isolar a credencial substituta Google/Gemini;
- [ ] validar webhook apenas com evento sintético e autorização específica;
- [ ] inventariar scripts, automações e terceiros;
- [ ] obter autorização separada para produção;
- [ ] obter autorização posterior e independente para desativar/revogar as chaves antigas.

## Rollback

Enquanto a chave legada permanecer ativa, remover `SUPABASE_SECRET_KEY` do ambiente
faz os backends Node voltarem ao fallback. Na Edge Function, ausência ou JSON inválido
em `SUPABASE_SECRET_KEYS` preserva o fallback legado. Nenhum rollback deve depender
de restaurar um segredo no código ou no histórico Git.

## Evidências exigidas no Draft PR

- testes comprovando preferência moderna e fallback legado;
- busca sem credenciais literais no estado proposto;
- build e typecheck verdes, incluindo cobertura explícita de `api/**/*.ts`;
- resolução ou validação explícita dos erros de `admin-create-user.ts`;
- Preview Vercel do candidato técnico final conectado ao ambiente isolado;
- Preview Vercel sem tráfego funcional contra produção;
- registro explícito de que credenciais ainda não foram revogadas.
