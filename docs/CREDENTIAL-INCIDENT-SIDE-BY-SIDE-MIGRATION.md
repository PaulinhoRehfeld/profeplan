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

## Gates antes de qualquer cutover

- [ ] criar chaves substitutas por componente em consoles oficiais;
- [ ] prover um Supabase isolado ou branch descartável para preview;
- [ ] configurar variáveis apenas no preview e, preferencialmente, por Git branch;
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
- build e typecheck verdes;
- Preview Vercel sem tráfego funcional contra produção;
- registro explícito de que credenciais ainda não foram revogadas.
