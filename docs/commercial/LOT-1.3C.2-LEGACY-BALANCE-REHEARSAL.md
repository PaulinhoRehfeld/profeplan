# Lote 1.3C.2 — Rehearsal descartável de `LEGACY_BALANCE`

Data: 14 de agosto de 2026.

Base canônica de abertura: `ad40b2b06382f56e979aceb62cba686b7af1fb8f`.

Branch: `test/commercial-credit-legacy-balance-rehearsal`.

## 1. Objetivo

Provar, sem tocar produção, a política conservadora aprovada em 1.3C.1 para migrar o saldo agregado legado de `profiles.credits` para o ledger governado.

Este sublote **não é um script de cutover de produção**. Ele é uma prova executável em Supabase descartável para verificar as invariantes econômicas antes de qualquer convergência de produtores/consumidores ou deployment hospedado.

## 2. Estado hospedado que motivou a fixture

A auditoria 1.3C.1 observou, em agregado:

```text
31 perfis totais
30 perfis finitos
  29 × saldo 10
   1 × saldo 2
  soma = 292
1 perfil GOLD/unlimited com sentinel legado 9999
```

O Stripe conectado não apresentou PaymentIntent, Charge ou Subscription histórico no snapshot auditado.

Como o modelo antigo não possui proveniência suficiente para decompor os 292 créditos em FREE/bônus/admin/compras, a política aceita é:

```text
saldo finito positivo atual
    -> um grant LEGACY_BALANCE
    -> mesmo valor
    -> expires_at NULL
```

Gold/unlimited não converte automaticamente `9999` em crédito real.

## 3. Fixture sintética

`supabase/tests/fixtures/credit_legacy_cutover_snapshot.sql`

A fixture contém somente UUIDs sintéticos e atributos econômicos. Não contém nome, e-mail, telefone ou qualquer outro dado pessoal real.

Ela reproduz exatamente a distribuição agregada relevante:

```text
IDs 1..29  -> FREE / finite / 10
ID 30      -> FREE / finite / 2
ID 31      -> GOLD / unlimited / 9999
```

## 4. Fundação aplicada no rehearsal

O workflow descartável aplica, nessa ordem:

```text
baseline mínimo profiles
baseline term_plans
1.3B.1 schema contábil
1.3B.2 command boundary
1.3B.2 invariants
1.3B.3 atomic TermPlan pilot
fixture sintética 1.3C.2
```

Logo a prova é executada sobre a mesma fundação versionada que precederia o futuro cutover.

## 5. Importador do rehearsal

O teste cria uma função **somente em `pg_temp`** para a duração da sessão de teste.

Ela:

1. seleciona somente perfis com `is_unlimited = false` e `credits > 0`;
2. ordena deterministicamente por `id`;
3. chama exclusivamente `credit_grant_command(...)`;
4. usa `origin = LEGACY_BALANCE`;
5. usa `expires_at = NULL`;
6. deriva chaves estáveis por usuário;
7. não atualiza `profiles.credits`;
8. não insere diretamente em `credit_operations`, `credit_grants` ou `credit_ledger_entries`.

Chaves de rehearsal:

```text
operation_id = legacy-balance-cutover-v1:<user-id>
grant_key    = legacy:<user-id>:credit-cutover-v1
action_key   = GRANT_LEGACY_BALANCE
```

O fingerprint inclui o usuário e o saldo observado. Assim, uma tentativa posterior de reutilizar a mesma operação para um saldo diferente falha fechada em vez de alterar silenciosamente o evento econômico já estabelecido.

## 6. Provas obrigatórias

### 6.1 Shape da origem

Antes da importação:

```text
profiles = 31
finite   = 30
finite sum = 292
Gold sentinel = 9999
```

### 6.2 Rollback integral

Dentro de uma transação:

```text
30 LEGACY_BALANCE grants
soma 292
```

Depois de `ROLLBACK`:

```text
credit_operations = 0
credit_grants = 0
credit_ledger_entries = 0
profiles.credits finite sum = 292
```

Isso prova que o futuro corte pode ser construído como uma unidade transacional, sem deixar importação parcial se uma validação falhar antes do commit.

### 6.3 Commit e preservação exata

Depois da importação comprometida:

```text
30 GRANT operations
30 LEGACY_BALANCE grants
30 CREDIT entries
sum(granted_amount) = 292
sum(CREDIT amount)  = 292
expires_at != NULL  = 0
Gold grants          = 0
```

Para cada perfil finito, o saldo derivado governado deve ser exatamente igual ao `profiles.credits` sintético correspondente.

O campo legado permanece inalterado durante o rehearsal.

### 6.4 Sentinel unlimited

O perfil Gold permanece:

```text
unlimited = true
governed finite total = 0
```

`9999` não é materializado como `LEGACY_BALANCE`.

### 6.5 Replay idempotente

Executar novamente a mesma importação com as mesmas chaves e mesmo instante de corte mantém:

```text
30 operations
30 grants
30 ledger CREDIT entries
aggregate = 292
```

Nenhuma duplicação é permitida.

### 6.6 Drift fail-closed

Depois do commit, o teste altera temporariamente o saldo sintético do usuário de saldo 2 para saldo 3 e tenta reutilizar a mesma identidade de cutover.

Resultado esperado:

```text
SQLSTATE 22023
operation_id replay payload mismatch
```

A transação de drift é revertida e o estado continua:

```text
profiles.credits = 2
grant = 2
```

Isso força um futuro operador a interromper e reconciliar divergência de snapshot, em vez de remapear silenciosamente uma operação já comprometida.

## 7. O que este rehearsal deliberadamente não prova

1.3C.2 não resolve ainda:

- dupla autoridade econômica de `profiles.credits` versus ledger;
- onboarding FREE governado;
- Stripe Silver `PURCHASED`;
- bônus de telefone/referral;
- ajustes administrativos;
- consumidores billable restantes;
- UI de saldo;
- revogação de bypass de `term_plans`;
- freeze operacional de produção;
- aplicação de migrations hospedadas;
- observabilidade do cutover real.

Esses pontos permanecem nos sublotes posteriores 1.3C.3–1.3C.6.

## 8. Por que não existe migration de produção neste lote

A política econômica foi provada, mas o 1.3C.1 demonstrou que ainda existem produtores e consumidores ativos fora do ledger.

Versionar agora uma migration de dados destinada a ser aplicada automaticamente aumentaria o risco de alguém executar uma transição parcial antes da autoridade única estar pronta.

Por isso:

> **1.3C.2 mantém o algoritmo exclusivamente no harness descartável.**

O script/runbook material de produção só deve ser formalizado no gate de enforcement/rehearsal integral, quando a ordem operacional inteira estiver fechada.

## 9. Definition of Done

1.3C.2 estará tecnicamente pronto quando o mesmo HEAD provar:

- fixture sintética equivalente ao snapshot agregado;
- 292 créditos finitos preservados exatamente;
- 30 grants não expirantes `LEGACY_BALANCE`;
- nenhum grant de sentinel Gold;
- `profiles.credits` não alterado pelo import;
- rollback integral;
- replay sem duplicação;
- drift de snapshot falhando fechado;
- `supabase db lint --level warning` verde;
- CI geral verde;
- nenhuma alteração hospedada.

## 10. Próximo gate

Após integração governada de 1.3C.2, o próximo trabalho seguro é:

> **1.3C.3 — convergência dos produtores positivos para `credit_grant_command(...)`, ainda sem deployment hospedado.**

Ordem recomendada dentro de 1.3C.3:

```text
FREE onboarding       -> FREE_TRIAL / 10 / 7 dias
Stripe Silver         -> PURCHASED / 40 / sem expiração
telefone              -> PROMOTIONAL_BONUS
referral              -> PROMOTIONAL_BONUS
admin_add_credits     -> ADMIN_ADJUSTMENT
admin_update_profile  -> remover p_credits como autoridade econômica
```

**Nenhuma ação de produção é autorizada por este documento ou pelo rehearsal.**
