# Lote 1.3C.3 — Convergência dos produtores positivos de créditos

Data: 14 de agosto de 2026.

Base canônica de abertura: `491d78f3d02b4a7db8c8d0fcf33e38bea06aea34`.

Branch: `feat/commercial-credit-positive-producers`.

## 1. Objetivo

1.3C.3 remove, no modelo-alvo de cutover, `profiles.credits` como autoridade para **criar saldo positivo**.

A fundação 1.3B já fornece:

```text
credit_operations
credit_grants
credit_ledger_entries
credit_grant_command(...)
credit_balance_snapshot_internal(...)
```

O 1.3C.1 demonstrou que ainda existiam cinco produtores positivos legados:

```text
onboarding FREE     -> profiles.credits = 10
telefone            -> profiles.credits += 10
referral            -> profiles.credits += 10
Stripe Silver       -> profiles.credits += 40
admin                -> profiles.credits += amount / set direto
```

Este sublote converge esses produtores para grants com origem explícita.

## 2. Regra de segurança desta branch

A implementação é **versionada e testada, mas não aplicada ao Supabase hospedado**.

Isso é obrigatório porque 1.3C.4 ainda precisa convergir os consumidores billable. Se esta migration fosse aplicada isoladamente:

- novos FREE passariam a ter `profiles.credits = 0`;
- Silver deixaria de aumentar o inteiro legado;
- telefone/referral/admin deixariam de aumentar o inteiro legado;
- consumidores antigos que ainda consultam `profiles.credits` poderiam negar uso incorretamente.

Portanto:

> **merge deste código não é autorização de deployment da migration.**

A migration só poderá participar do cutover coordenado depois da convergência dos consumidores e do rehearsal integral.

## 3. Feature flag de frontend

Foi criada:

```text
VITE_GOVERNED_CREDIT_PRODUCERS=true
```

Sem a variável, ou com qualquer valor diferente de `true`:

```text
frontend -> comportamento legado
```

Com a variável explicitamente `true`:

```text
telefone/referral/admin -> RPCs governados
```

A flag não ativa onboarding nem Stripe, porque esses produtores são server-side e mudam apenas quando a migration SQL for aplicada.

Logo, a ordem futura precisa coordenar migration + aplicação/configuração dentro da janela de cutover.

## 4. FREE_TRIAL — produtor único no INSERT do perfil

### 4.1 Problema anterior

O cadastro normal e o fallback `update_my_profile` tinham lógica própria de criação de perfil com saldo 10.

Duplicar a lógica econômica em duas funções facilita divergência.

### 4.2 Modelo 1.3C.3

Novo perfil FREE nasce com:

```text
tier         = FREE
is_unlimited = false
credits      = 0
```

Um único trigger:

```text
on_profile_created_credit_free_trial
```

executa após INSERT em `profiles` e chama o helper privado:

```text
credit_grant_profile_free_trial(user_id)
```

O grant criado é:

```text
origin      = FREE_TRIAL
amount      = 10
granted_at  = profiles.created_at
expires_at  = profiles.created_at + 7 dias
```

Chaves:

```text
operation_id = free-trial-v1:<user-id>
grant_key    = free-trial:<user-id>:v1
action_key   = GRANT_FREE_TRIAL
```

O uso de `profiles.created_at` torna o replay temporalmente determinístico.

### 4.3 Cadastro normal e recuperação

`handle_new_user()` e a recuperação emergencial autenticada de `update_my_profile()` passam a inserir `credits = 0`.

Ambos dependem do mesmo AFTER INSERT para o grant.

`update_my_profile(jsonb)` não é uma fronteira anônima: exige `auth.uid()`, falha com SQLSTATE `42501` quando a identidade está ausente, usa `search_path = pg_catalog`, revoga `EXECUTE` de `PUBLIC`, `anon` e `service_role` e concede execução somente a `authenticated`. A defesa interna permanece necessária mesmo se a ACL sofrer drift futuro.

Assim não existem duas implementações de FREE_TRIAL nem um caminho por email arbitrário para criar perfil e grant.

## 5. Bônus de telefone

Novo RPC:

```text
credit_register_my_phone_bonus(phone)
```

Propriedades:

- exige `auth.uid()`;
- não recebe user_id do navegador;
- trava a linha do perfil;
- só procede se `phone IS NULL`;
- grava telefone e grant na mesma transação;
- grant `PROMOTIONAL_BONUS`, quantidade 10;
- retries posteriores encontram telefone já registrado e não duplicam grant;
- telefone registrado antes da convergência não recebe bônus retroativo;
- anon não possui EXECUTE.

Chaves:

```text
operation_id = phone-bonus-v1:<user-id>
grant_key    = phone:<user-id>:bonus-v1
action_key   = GRANT_PHONE_BONUS
```

O frontend com flag ON não possui fallback para escrita direta se o RPC falhar.

## 6. Bônus de indicação

Novo RPC:

```text
credit_claim_my_referral_bonus()
```

O cliente deixa de ser autoridade sobre o email do novo usuário.

O RPC usa:

```text
auth.uid()
  -> auth.users.email
  -> referrals.referee_email
```

Regras:

1. nenhum pending -> no-op;
2. exatamente um pending -> trava referral;
3. status `pending -> completed`;
4. grant de 10 ao `referrer_id`;
5. status e grant compartilham a mesma transação;
6. dois ou mais pending para o mesmo email -> falha fechada `23514`.

Grant:

```text
origin       = PROMOTIONAL_BONUS
operation_id = referral-bonus-v1:<referral-id>
grant_key    = referral:<referral-id>:bonus-v1
action_key   = GRANT_REFERRAL_BONUS
```

A decisão de falhar fechado em ambiguidade evita pagar múltiplos referrers sem uma regra de negócio explícita.

## 7. Stripe Silver

A assinatura pública do RPC de fulfillment permanece compatível com a Edge Function existente:

```text
process_stripe_checkout_event(...)
```

A mudança é interna.

### 7.1 Antes

```text
SILVER -> profiles.credits = profiles.credits + 40
```

### 7.2 Depois

```text
SILVER
  -> PURCHASED 40
  -> expires_at NULL
  -> tier SILVER, salvo se já GOLD
```

Chaves:

```text
operation_id = stripe-silver-v1:<stripe-event-id>
grant_key    = stripe:<stripe-event-id>:silver-credit-v1
action_key   = GRANT_STRIPE_SILVER
```

`p_event_created_at` é usado como `granted_at`, portanto o replay é temporalmente estável.

A idempotência existente em `stripe_webhook_events.stripe_event_id` continua sendo a primeira barreira; o command boundary oferece defesa econômica adicional.

### 7.3 Rollback

O grant Silver é executado dentro do bloco transacional de fulfillment.

Se tier/profile/subsequente falhar:

```text
grant + CREDIT entry -> rollback
stripe event          -> failed
```

O teste descartável força exatamente esse cenário.

## 8. Gold e downgrade

Gold continua:

```text
is_unlimited = true
NO_CHARGE para consumo
```

Checkout Gold não cria `PURCHASED` apenas por existir assinatura.

Ao cancelar Gold, a decisão de tier deixa de usar:

```text
profiles.credits > 0
```

E passa a usar:

```text
credit_balance_snapshot_internal(user, now()).total
```

Resultado:

```text
saldo governado finito > 0 -> SILVER
saldo governado finito = 0 -> FREE
```

Assim créditos comprados/bônus/admin/legacy que permanecerem no ledger continuam disponíveis depois do unlimited.

## 9. Ajuste administrativo

### 9.1 Novo overload governado

```text
admin_add_credits(target_id, amount, operation_id)
```

Cria:

```text
origin     = ADMIN_ADJUSTMENT
action_key = GRANT_ADMIN_ADJUSTMENT
```

O `operation_id` é obrigatório.

Em retry, o wrapper recupera `granted_at` do grant já persistido antes de chamar novamente `credit_grant_command`, garantindo que o replay compare os mesmos timestamps.

### 9.2 Overload legado

```text
admin_add_credits(target_id, amount)
```

continua existindo apenas para produzir erro explícito depois do cutover:

```text
Créditos são governados; identificador idempotente obrigatório.
```

Ele não cria saldo.

### 9.3 admin_update_profile

`p_credits IS NOT NULL` passa a ser rejeitado.

Continuam independentes:

- tier;
- is_unlimited;
- role;
- is_admin.

Saldo econômico deve ser alterado somente por `ADMIN_ADJUSTMENT`.

## 10. Idempotência no modal administrativo

O frontend mantém um `pendingOperationId` enquanto a intenção econômica está em andamento.

Fluxo:

```text
Confirmar
  -> gera operation id
  -> chama admin_add_credits(..., operation id)

erro/timeout
  -> mantém operation id

retry com mesma quantidade
  -> reutiliza mesmo operation id

sucesso
  -> descarta operation id
```

Mudar a quantidade limpa a chave pendente, pois passa a ser uma nova intenção econômica.

Isso evita grant duplicado quando o servidor tiver commitado, mas a resposta não chegar ao navegador.

## 11. Painel administrativo sob flag governada

Quando `VITE_GOVERNED_CREDIT_PRODUCERS=true`:

- `updateUserProfileAdmin` envia `p_credits = NULL`;
- `UserList` não oferece input numérico de saldo;
- a coluna deixa de exibir o inteiro legado como autoridade e mostra `Ledger governado`;
- `AddCreditsModal` usa o overload idempotente.

A leitura administrativa detalhada do saldo derivado será fechada em gate posterior; 1.3C.3 não cria uma nova projeção admin apenas para reproduzir o inteiro antigo.

## 12. Matriz descartável

O workflow:

```text
Credit Accounting 1.3C.3 Positive Producers CI
```

aplica em Supabase descartável:

1. baseline mínimo de profiles;
2. baseline sintético dos produtores;
3. 1.3B.1;
4. 1.3B.2;
5. invariantes 1.3B.2;
6. fulfillment Stripe legado;
7. migration 1.3C.3.

### Provas SQL

#### FREE

- auth.users INSERT cria profile FREE;
- `profiles.credits = 0`;
- exatamente um FREE_TRIAL 10;
- expiração em 7 dias;
- replay do helper não duplica;
- fallback emergencial também produz o mesmo shape.

#### Telefone

- telefone + grant atômicos;
- retry não duplica;
- rollback desfaz telefone e grant;
- telefone histórico não ganha bônus retroativo.

#### Referral

- claim usa identidade autenticada;
- referral completed + grant atômicos;
- retry não duplica;
- ambiguidade falha fechada sem alterar os referrals.

#### Stripe

- Silver produz um PURCHASED 40;
- retry não duplica;
- `profiles.credits` permanece 0;
- falha forçada depois do grant deixa event failed e zero grant;
- Gold não fabrica grant;
- Gold com saldo governado >0 retorna a SILVER no cancelamento;
- Gold sem saldo governado retorna a FREE.

#### Admin

- ajuste governado cria ADMIN_ADJUSTMENT;
- retry com mesma operation id não duplica;
- overload legado não cria grant;
- `admin_update_profile(... credits ...)` é rejeitado;
- update não econômico continua funcionando;
- não-admin não cria ajuste.

#### Invariante final

Nenhum produtor da suíte deixa saldo positivo ou negativo em `profiles.credits`.

## 13. Testes de frontend

A suíte cobre:

- flag OFF preserva RPC admin legada;
- flag ON exige operation id;
- flag ON remove `p_credits` do update genérico;
- telefone governado usa somente RPC;
- falha de RPC não cai de volta no write legado;
- referral governado não usa o email fornecido pelo cliente;
- retry do modal reutiliza a mesma operation id.

## 14. Limites intencionais

1.3C.3 não:

- migra consumidores billable;
- troca `checkUsageQuota`/`incrementUserUsage`;
- torna o ledger autoridade global ainda;
- aplica migration hospedada;
- ativa Vite flag;
- altera configuração Vercel;
- altera Edge Function hospedada;
- altera Stripe externo;
- revoga bypasses de artefato;
- executa cutover.

## 15. Gate de deployment

Mesmo depois de merge técnico, a migration 1.3C.3 permanece bloqueada no hospedado enquanto:

```text
algum consumidor billable ativo usa profiles.credits
```

Aplicar apenas 1.3C.3 quebraria o contrato legado de consumidores sem ainda tornar o ledger autoridade global.

## 16. Definition of Done

1.3C.3 estará pronto quando o mesmo HEAD tiver:

- CI geral verde;
- CI específico 1.3C.3 verde;
- regressão Knowledge Factory DB verde;
- SQL lint verde;
- frontend flag OFF preservando legado;
- frontend flag ON fail-closed para producers governados;
- replay/rollback provados para os produtores relevantes;
- diff reconciliado;
- nenhuma alteração hospedada.

## 17. Próximo gate

Após integração governada de 1.3C.3:

> **1.3C.4 — convergência dos consumidores billable restantes para saves econômicos governados.**

O objetivo de 1.3C.4 será eliminar `incrementUserUsage()`/`profiles.credits` como autoridade de débito antes do enforcement/cutover integral.

**Este documento não autoriza deployment ou cutover.**
