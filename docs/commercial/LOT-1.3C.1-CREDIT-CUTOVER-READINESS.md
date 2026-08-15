# Lote 1.3C.1 — Auditoria de prontidão para cutover do motor de créditos

Data: 14 de agosto de 2026.

Base canônica de abertura: `main` em `b3a7dafbf585caa109ddc2302464f7ae4656c032`.

Branch: `docs/commercial-credit-cutover-readiness`.

## 1. Status e escopo

Este sublote é uma auditoria de prontidão para o futuro cutover do motor contábil implementado nos Lotes 1.3B.1, 1.3B.2 e 1.3B.3.

A conclusão desta auditoria é:

> **NO-GO para ativação de produção neste estado**, apesar de a fundação contábil e o piloto de Planejamento Trimestral estarem tecnicamente validados em ambientes descartáveis.

O motivo principal não é volume de dados nem ausência de testes do piloto. O bloqueio principal é arquitetônico: o aplicativo ainda possui **duas autoridades econômicas potenciais** se o piloto for ativado isoladamente.

Este sublote:

- inspeciona a `main` canônica;
- consulta o Supabase hospedado somente em modo leitura;
- consulta o Stripe conectado somente em modo leitura;
- registra agregados, sem materializar dados pessoais individualizados;
- define estratégia conservadora para saldos legados;
- identifica blockers de cutover;
- define a sequência recomendada de sublotes seguintes.

Este sublote **não**:

- aplica migration no Supabase hospedado;
- altera `profiles.credits`;
- cria grant real;
- altera usuário real;
- ativa feature flag;
- altera Vercel;
- altera Edge Function hospedada;
- altera Stripe;
- revoga policy real;
- altera `term_plans` hospedado;
- faz cutover.

## 2. Estado canônico no GitHub

A `main` auditada é:

```text
b3a7dafbf585caa109ddc2302464f7ae4656c032
feat(commercial): add atomic term-plan save pilot (#73)
```

A cadeia contábil versionada é:

```text
1.3A   inventário econômico e BILLABLE/NON_BILLABLE
  ↓
1.3B.1 schema contábil append-only
  ↓
1.3B.2 command boundary transacional/idempotente
  ↓
1.3B.3 piloto atômico de Save do Planejamento Trimestral
```

O 1.3B.3 permanece protegido por:

```text
VITE_GOVERNED_TERM_PLAN_SAVE=true
```

A ausência da variável ou qualquer valor diferente de `true` mantém o caminho legado.

## 3. Snapshot hospedado — Supabase PROFEPLAN

A inspeção hospedada foi estritamente de leitura.

### 3.1 O novo ledger ainda não existe no banco hospedado

No snapshot auditado:

```text
credit_operations          ausente
credit_grants              ausente
credit_ledger_entries      ausente
credit_get_my_balance()    ausente
```

Isso confirma que a integração dos PRs 1.3B não provocou cutover acidental.

As migrations 1.3B.1–1.3B.3 permanecem apenas versionadas no GitHub.

### 3.2 Perfil econômico agregado atual

Snapshot sem identificação individual:

| Estado | Quantidade |
|---|---:|
| perfis totais | 31 |
| FREE | 30 |
| SILVER | 0 |
| GOLD/unlimited | 1 |
| perfis finitos com saldo 10 | 29 |
| perfis finitos com saldo 2 | 1 |
| perfis finitos com saldo 0 | 0 |
| soma dos saldos finitos em `profiles.credits` | 292 |
| perfil GOLD/unlimited | 9999 no campo legado |

O valor 9999 do usuário unlimited é um sentinel/histórico do modelo antigo e **não deve ser transformado automaticamente em 9999 créditos reais no ledger**.

### 3.3 Telefone e indicação

O snapshot mostra:

```text
perfis com telefone cadastrado = 2
referrals completed             = 0
referrals pending               = 0
```

Os dois perfis com telefone não permitem reconstruir, a partir do saldo corrente, quanto do saldo veio do bônus de telefone e quanto veio do lote inicial ou de consumo posterior.

Logo, a existência do telefone não é evidência suficiente para decompor saldo atual em lotes econômicos históricos.

### 3.4 Stripe no banco hospedado

O fulfillment Stripe hospedado já existe, mas seu ledger de eventos está vazio no snapshot:

```text
stripe_webhook_events total = 0
processed SILVER            = 0
processed GOLD              = 0
pending_identity            = 0
failed                      = 0
```

Não existe usuário SILVER atual.

A função hospedada `process_stripe_checkout_event(...)` ainda mantém a semântica legada para Silver:

```text
profiles.credits = profiles.credits + 40
```

Portanto, antes do cutover, o produtor Stripe Silver precisa convergir para `credit_grant_command(...)` com origem `PURCHASED`.

## 4. Verificação financeira externa — Stripe WR TECH AI

A conta Stripe conectada foi consultada somente em leitura.

No snapshot auditado:

```text
PaymentIntents = 0
Charges        = 0
Subscriptions  = 0
```

Assim, **não há evidência Stripe atual de compra histórica** que precise ser reconstruída como `PURCHASED` durante esta migração.

Essa constatação simplifica o snapshot atual, mas não muda a regra arquitetônica: qualquer compra real que existir antes do futuro cutover deverá ser preservada por evidência própria e nunca reclassificada como FREE ou expirada.

## 5. Estado do onboarding FREE hospedado

A função `handle_new_user()` atualmente hospedada cria conta nova com:

```text
tier         = FREE
is_unlimited = false
credits      = 10
```

Isso é coerente com a regra comercial vigente de entrada FREE no modelo legado.

Porém, o modelo legado não grava:

- grant de origem;
- data econômica de concessão separada;
- expiração do lote;
- lançamentos de consumo por origem.

No novo ledger, novas contas deverão receber:

```text
origin     = FREE_TRIAL
amount     = 10
expires_at = granted_at + 7 dias
```

por comando governado e idempotente.

## 6. Histórico de migrations hospedadas não é fonte canônica completa

A tabela `supabase_migrations.schema_migrations` do projeto hospedado contém apenas um subconjunto pequeno das mudanças que comprovadamente existem no banco.

Por exemplo:

- o fulfillment Stripe recente aparece no histórico;
- a função `handle_new_user()` hospedada contém a regra FREE/10 introduzida posteriormente no repositório;
- essa mudança não aparece como uma linha equivalente no histórico consultado.

Conclusão:

> **o futuro deployment não pode confiar apenas em `schema_migrations` para decidir o que existe no banco.**

Todo cutover deverá começar por preflight de objetos reais:

- `to_regclass`;
- `to_regprocedure`;
- `pg_proc`;
- `pg_policies`;
- grants efetivos;
- constraints/indexes;
- shape das tabelas relevantes.

As migrations de cutover devem ser idempotentes ou explicitamente guardadas contra o estado real observado.

## 7. Estado atual de `term_plans`

### 7.1 Dados

No snapshot hospedado:

```text
term_plans total               = 4
usuários distintos             = 3
última atividade em term_plans = 11/07/2026
mirror trimestral legado       = 6 linhas em generated_contents
```

O pequeno volume reduz a superfície operacional do primeiro fluxo migrado.

### 7.2 Bypass econômico ainda existe

As policies hospedadas incluem:

```text
term_plans_insert_own
term_plans_update_own
term_plans_select_own
term_plans_delete_own
```

`authenticated` possui os privilégios de tabela necessários e as policies permitem INSERT/UPDATE direto do próprio usuário.

Isso é intencional no 1.3B.3 para manter compatibilidade enquanto o piloto está desligado, mas significa que:

> **o RPC `credit_save_term_plan(...)` ainda não é a única autoridade possível de escrita.**

A revogação/bloqueio desse bypass deve ser coordenada no mesmo gate em que o caminho governado for efetivamente ativado.

Revogar antes da ativação quebraria o legado. Ativar sem revogar permitiria save sem decisão econômica.

## 8. Produtores positivos que ainda escrevem no saldo legado

O repositório confirma que os seguintes caminhos continuam alterando `profiles.credits` diretamente:

### 8.1 Cadastro FREE

```text
handle_new_user()
-> profiles.credits = 10
```

### 8.2 Stripe Silver

```text
process_stripe_checkout_event(... SILVER ...)
-> profiles.credits = profiles.credits + 40
```

### 8.3 Bônus de telefone

```text
registerPhone(...)
-> profiles.credits = profiles.credits + 10
```

### 8.4 Bônus de indicação

```text
checkAndRewardReferrer(...)
-> profiles.credits = profiles.credits + 10
```

### 8.5 Ajuste administrativo

```text
admin_add_credits(...)
-> profiles.credits = profiles.credits + amount
```

Além disso, `admin_update_profile(...)` ainda pode definir diretamente `p_credits`.

Antes de o ledger se tornar autoridade, esses produtores precisam convergir para grants explícitos e idempotentes.

## 9. Consumidores que ainda usam a autoridade legada

O aplicativo ainda possui múltiplos caminhos ativos baseados em:

```text
checkUsageQuota()
incrementUserUsage()
CreditManager.executeWithCreditCheck()
```

`incrementUserUsage()` executa read-modify-write em `profiles.credits`.

Chamadas/caminhos legados permanecem presentes em domínios como:

- Planning;
- chat/IA;
- avaliação;
- apresentação;
- PDI;
- outros geradores classificados pelo modelo antigo.

O 1.3B.3 altera apenas o Planejamento Trimestral quando seu flag estiver ativo.

## 10. BLOCKER P0 — dupla autoridade econômica durante cutover parcial

Este é o principal achado da auditoria.

Suponha um usuário com saldo legado 10.

Se o cutover fizer:

```text
profiles.credits = 10
+
LEGACY_BALANCE no novo ledger = 10
```

mas somente Planejamento Trimestral passar a usar o novo ledger, teremos:

```text
Save trimestral
-> novo ledger: 10 -> 9
-> profiles.credits continua 10

Avaliação/apresentação/chat legado
-> profiles.credits: 10 -> 9
-> novo ledger continua 9
```

O mesmo saldo econômico original passa a existir em dois contadores independentes.

O usuário poderia consumir aproximadamente duas vezes o orçamento econômico antes de ambos chegarem a zero.

Portanto:

> **não é seguro ativar globalmente o piloto 1.3B.3 enquanto outros consumidores billable continuarem usando `profiles.credits`.**

### 10.1 Soluções avaliadas

#### Opção A — espelhamento bidirecional temporário

Fazer toda operação no ledger também alterar `profiles.credits` e toda operação legada também alterar o ledger.

**Não recomendado.**

Isso cria duas autoridades sincronizadas, amplia corrida/rollback e reintroduz parte do problema que o ledger foi criado para eliminar.

#### Opção B — canary isolado

Ativar o novo motor apenas para usuários que não possam executar consumidores legados durante o teste.

O flag atual é global, não por usuário. Logo, o repositório ainda não possui isolamento suficiente para um canary econômico seguro em produção.

#### Opção C — migrar toda a autoridade econômica antes da ativação global

Convergir primeiro:

- produtores positivos;
- consumidores billable;
- leitura de saldo da UI;
- saves canônicos;

Depois realizar um cutover único de autoridade.

**Esta é a estratégia recomendada.**

## 11. Política conservadora para o saldo existente

Como os saldos atuais foram historicamente agregados e podem ter recebido FREE, bônus, ajustes ou consumo sem proveniência, o cutover não deve inferir origem sem evidência.

### 11.1 Usuários finitos

Para cada perfil não-unlimited com saldo positivo no snapshot final de corte:

```text
origin      = LEGACY_BALANCE
amount      = max(profiles.credits, 0)
expires_at  = NULL
```

Com chaves determinísticas, por exemplo:

```text
operation_id = legacy-balance-cutover-v1:<user-id>
grant_key    = legacy:<user-id>:credit-cutover-v1
```

O comando deverá ser idempotente e seguro para reexecução.

No snapshot atual, isso preservaria exatamente:

```text
30 usuários finitos
292 créditos agregados
```

sem tentar decompor esses 292 créditos em origens que o sistema antigo não consegue demonstrar.

### 11.2 Usuários unlimited/GOLD

Não importar automaticamente sentinels como `9999` para o ledger.

Gold usa `NO_CHARGE`; o inteiro legado 9999 não é evidência de compra.

Somente créditos positivos com proveniência independente demonstrável devem virar grant preservado para eventual downgrade.

No snapshot Stripe atual não existe compra demonstrada.

### 11.3 Usuários com saldo zero

Não criar grant de quantidade zero.

### 11.4 FREE legado não ganha expiração retroativa

Os saldos antigos preservados como `LEGACY_BALANCE` não expiram.

A regra `FREE_TRIAL = 10 por 7 dias` passa a valer para grants novos após a convergência do onboarding.

Isso evita apagar retroativamente créditos cujo histórico não possui proveniência suficiente.

## 12. Estratégia de autoridade única

O objetivo de produção deve ser:

```text
credit_operations
credit_grants
credit_ledger_entries
        │
        └── única autoridade econômica
```

`profiles.credits` pode permanecer temporariamente como campo legado para compatibilidade de leitura, mas:

- não pode continuar decidindo autorização;
- não pode continuar recebendo débitos de negócio;
- não pode continuar recebendo grants econômicos;
- não pode coexistir como segundo saldo gastável.

Depois do cutover, toda leitura de saldo deve convergir para:

```text
credit_get_my_balance()
```

ou uma projeção backend equivalente.

## 13. Sequência recomendada de 1.3C

### 1.3C.1 — readiness audit

Este documento + diagnóstico read-only reproduzível.

Status: **implementado nesta branch documental**.

### 1.3C.2 — rehearsal de migração de saldo legado

Em Supabase descartável:

- aplicar 1.3B.1 + 1.3B.2 + 1.3B.3;
- carregar fixture sintética com shape equivalente ao snapshot hospedado;
- migrar saldos finitos para `LEGACY_BALANCE`;
- provar idempotência da migração;
- provar que 9999 unlimited não vira grant automaticamente;
- provar igualdade `sum(legacy finite input) = governed balance after migration`;
- provar rollback integral;
- não tocar hospedado.

### 1.3C.3 — convergência dos produtores positivos

Versionar e testar, sem deployment hospedado:

- onboarding FREE -> `FREE_TRIAL`;
- Stripe Silver -> `PURCHASED`;
- telefone -> `PROMOTIONAL_BONUS`;
- referral -> `PROMOTIONAL_BONUS`;
- admin -> `ADMIN_ADJUSTMENT`;
- remover autoridade econômica de `p_credits` em `admin_update_profile`.

Cada produtor precisa de `operation_id`/`grant_key` estável e replay comprovado.

### 1.3C.4 — convergência dos consumidores billable restantes

Migrar os saves econômicos identificados no 1.3A, em sublotes independentes:

- plano/documento;
- avaliação;
- apresentação;
- PDI;
- demais artefatos efetivamente billable.

Geração/preview/chat não persistido permanece NON_BILLABLE conforme 1.3A.

Ao final, `incrementUserUsage()` deixa de ser autoridade econômica.

### 1.3C.5 — enforcement e rehearsal integral

Em ambiente descartável:

- provar todos os consumidores no ledger;
- provar todos os produtores no ledger;
- provar ausência de write econômico direto em `profiles.credits`;
- provar revogação segura do bypass billable de `term_plans` e demais artefatos;
- provar rollout e rollback em ordem operacional;
- provar que uma mesma unidade econômica nunca existe simultaneamente em dois saldos gastáveis.

### 1.3C.6 — produção

Somente com autorização material explícita e checklist verde.

## 14. Gate de produção proposto

Nenhuma alteração econômica hospedada deve começar enquanto algum item abaixo estiver vermelho:

### Autoridade

- [ ] todos os grants positivos passam por command boundary governada;
- [ ] todos os consumidores billable passam por save canônico governado;
- [ ] UI não usa `profiles.credits` como autoridade de autorização;
- [ ] `incrementUserUsage` não é mais autoridade econômica em fluxo ativo;
- [ ] não existe dual-write econômico necessário para operação normal.

### Saldo legado

- [ ] snapshot de corte definido;
- [ ] migration de `LEGACY_BALANCE` idempotente provada;
- [ ] soma antes/depois reconciliada;
- [ ] sentinels unlimited excluídos corretamente;
- [ ] compras comprovadas, se existirem no futuro, preservadas separadamente.

### Banco

- [ ] preflight de objetos reais executado;
- [ ] migrations aplicáveis sobre o estado hospedado real;
- [ ] RLS/grants revisados;
- [ ] bypasses billable fechados no momento correto;
- [ ] rollback ensaiado.

### Aplicação

- [ ] flags/configuração de ativação revisadas;
- [ ] build/CI verdes;
- [ ] UX preserva rascunho em insuficiência/falha;
- [ ] observabilidade pronta;
- [ ] versão anterior identificada para rollback.

### Stripe

- [ ] fulfillment positivo usa `PURCHASED` governado;
- [ ] replay de webhook não duplica grant;
- [ ] Gold continua `NO_CHARGE`;
- [ ] lifecycle Gold não depende de `profiles.credits` para decidir tier pós-cancelamento.

## 15. Rollout de produção recomendado — somente como runbook futuro

O cutover final deve ser tratado como uma mudança de autoridade, não como simples aplicação de migration.

Sequência recomendada:

```text
1. congelar temporariamente operações econômicas
2. capturar snapshot final de profiles/tier/saldo
3. executar preflight de schema/funções/policies/grants
4. aplicar migrations governadas
5. materializar LEGACY_BALANCE do snapshot
6. reconciliar saldo por usuário e agregado
7. habilitar produtores novos
8. habilitar consumidores/saves novos
9. fechar bypasses econômicos antigos
10. validar smoke tests/readbacks
11. liberar operações econômicas
12. observar erros, receipts e divergências
```

A janela de congelamento evita que `profiles.credits` mude entre snapshot e materialização do ledger.

## 16. Rollback operacional futuro

Antes da liberação de usuários, rollback deve ser simples:

```text
- manter flags OFF
- restaurar policies/grants legados se necessário
- reverter deployment de aplicação
- remover/ignorar objetos novos ainda sem autoridade
- manter profiles.credits como estado vigente
```

Depois que usuários começarem a produzir eventos econômicos no ledger, rollback passa a exigir reconciliação dos eventos ocorridos após o corte.

Por isso, o gate de smoke test deve ocorrer **antes** da reabertura das operações econômicas.

## 17. Findings formais

### P0-CUT-01 — dupla autoridade de saldo

Ativar apenas 1.3B.3 cria risco de dois saldos gastáveis independentes.

**Bloqueia produção.**

### P0-CUT-02 — produtores positivos continuam fora do ledger

FREE, Stripe Silver, telefone, referral e admin ainda escrevem no inteiro legado.

**Bloqueia autoridade única.**

### P0-CUT-03 — consumidores billable restantes continuam em `incrementUserUsage`

O Planejamento Trimestral não pode virar única exceção global sem isolamento econômico.

**Bloqueia ativação global do piloto.**

### P0-CUT-04 — bypass de `term_plans`

INSERT/UPDATE direto autenticado ainda existe.

**Deve ser fechado no cutover, não antes.**

### P1-CUT-05 — histórico de migrations incompleto

`schema_migrations` não representa todo o estado real hospedado.

**Exige preflight por introspecção.**

### P1-CUT-06 — proveniência histórica ambígua

Saldo agregado não permite decomposição confiável por origem.

**Mitigação aprovada nesta auditoria: `LEGACY_BALANCE` não expirável.**

### INFO-CUT-07 — baixo volume atual

31 perfis, nenhum Silver, nenhuma evidência Stripe de pagamento, quatro `term_plans` canônicos.

Isso reduz risco operacional, mas não elimina blockers arquitetônicos.

## 18. Definition of Done de 1.3C.1

1.3C.1 está pronto para revisão quando:

- `main` canônica tiver sido confirmada;
- Supabase hospedado tiver sido auditado somente em leitura;
- Stripe tiver sido auditado somente em leitura;
- nenhum dado pessoal individual tiver sido incluído no documento;
- saldos agregados tiverem sido registrados;
- estado do ledger hospedado tiver sido confirmado;
- policies de `term_plans` tiverem sido confirmadas;
- dual-authority tiver sido formalizada como blocker;
- política `LEGACY_BALANCE` tiver sido definida;
- sequência 1.3C.2–1.3C.6 estiver explícita;
- nenhuma produção tiver sido alterada.

## 19. Próximo gate

O próximo trabalho técnico seguro é:

> **1.3C.2 — rehearsal descartável da migração conservadora de saldos legados.**

Ele deve ocorrer em branch/PR separado ou como avanço explícito desta frente, usando apenas fixtures sintéticas e Supabase descartável.

**Nenhuma aplicação no Supabase hospedado é autorizada por este documento.**
