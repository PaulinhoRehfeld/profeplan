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
2. preferir a chave nomeada `stripe-webhook`;
3. usar `default` como fallback moderno;
4. usar `SUPABASE_SERVICE_ROLE_KEY` apenas como rollback legado.

O webhook permanece com `verify_jwt = false`, pois sua autenticação de entrada é a
assinatura `Stripe-Signature`. Esta branch não implanta a função hospedada.

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

### Credenciais e wiring Vercel ainda não comprovados

As evidências disponíveis não permitem confirmar:

- se as credenciais substitutas Supabase e Google já foram criadas nos consoles
  oficiais;
- se foram disponibilizadas exclusivamente no ambiente de Preview;
- se as variáveis Vercel da branch Git apontam para
  `qporbmwedjvmbfqghkls`;
- se qualquer rota administrativa do Preview deixou de apontar para produção.

“Não comprovado” não equivale a “inexistente”. Esses itens permanecem gates
operacionais e não devem ser inferidos a partir da mera existência da branch Supabase.

A Vercel possui um Preview anterior, `dpl_CNfRMiUgxbTM3ADVxe8Fo8ipqPga`, em
`READY`, `target=null`, associado ao SHA
`e33bef95eecaca6882c1a8858895d6cc0d425d57`.

Esse deployment antecede o candidato técnico final
`576693ce22f7586ac4e537fd48a9364833f5fedf`. Na leitura de reconciliação, nenhum
deployment do projeto `profeplan` estava associado ao SHA final. Os status externos
do HEAD final para `site` e `profeplan` registravam falha por
`api-deployments-free-per-day`.

Portanto:

- o Preview anterior não substitui a prova do candidato técnico final;
- não existe prova de que ele estivesse conectado à branch Supabase isolada;
- nenhuma requisição funcional contra a branch isolada foi validada;
- signup, busca, embeddings e webhook permanecem sem validação funcional isolada.

### Diagnósticos TypeScript observados

Os logs do Preview anterior registraram, apesar de o deployment terminar `READY`:

`api/auth/admin-create-user.ts(86,32): error TS2339: Property 'getUser' does not exist on type 'SupabaseAuthClient'.`

`api/auth/admin-create-user.ts(150,75): error TS2339: Property 'admin' does not exist on type 'SupabaseAuthClient'.`

Também foram observados avisos de divergência entre a versão Node configurada no
projeto e `engines.node`, além de aviso de configuração pnpm ignorada.

O CI do candidato técnico final terminou verde, mas essa evidência não elimina os
diagnósticos de `api/auth/admin-create-user.ts`. A pasta raiz `api/` não integra o
typecheck recursivo dos workspaces nas mesmas condições da análise de funções da
Vercel. Os erros são classificados como defeito técnico real e lacuna de cobertura,
bloqueadores de promoção ou rotação até resolução ou validação explícita do endpoint.

Esta reconciliação não altera código, variáveis, credenciais, deployments, Supabase
hospedado, produção, revogação, histórico Git anterior ou C.3.

## Gates antes de qualquer cutover

- [ ] criar chaves substitutas por componente em consoles oficiais;
- [x] prover uma branch Supabase descartável sem cópia de dados para preview;
- [ ] confirmar a criação das credenciais substitutas nos consoles oficiais;
- [ ] configurar variáveis somente no Preview e, preferencialmente, por Git branch;
- [ ] comprovar que o wiring Vercel aponta para a branch Supabase isolada;
- [ ] confirmar que o preview não possui rota administrativa pública conectada à produção;
- [ ] executar testes unitários, typecheck, build e inspeção do bundle;
- [ ] validar `signup`, busca e webhook somente no ambiente isolado;
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
