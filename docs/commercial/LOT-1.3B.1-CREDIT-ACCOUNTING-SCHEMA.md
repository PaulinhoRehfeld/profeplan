# Lote 1.3B.1 — Fundação do schema contábil de créditos

Data: 14 de agosto de 2026.

Base canônica de abertura: `main` em `93d50fc9b2fae63195db59477300215be0700ed5`.

Branch: `feat/commercial-credit-accounting-schema`.

## 1. Status e objetivo

Este sublote materializa exclusivamente a fundação persistente do novo motor contábil de créditos do ProfePlan.

Ele traduz para schema as invariantes aprovadas no Lote 1.3A sem realizar cutover do sistema vigente.

A implementação de 1.3B.1 é deliberadamente **aditiva, append-only na fronteira da aplicação e deny-by-default**.

Ela não:

- altera ou recalcula `profiles.credits`;
- migra saldos existentes;
- cria RPC de concessão, consumo ou consulta;
- altera `incrementUserUsage`, `checkUsageQuota` ou `CreditManager`;
- altera frontend;
- altera Stripe, Payment Links, promotion codes, webhook ou fulfillment;
- altera bônus de telefone ou indicação;
- altera funções administrativas de crédito;
- conecta a nova contabilidade ao fluxo de produção;
- aplica migration ao Supabase hospedado;
- inicia 1.3B.2.

## 2. Decisão arquitetônica central

O novo modelo não usa um campo mutável `remaining_credits` como fonte contábil de verdade.

A disponibilidade futura deve ser derivada de lotes e lançamentos imutáveis:

```text
credit_operations
        │
        ├── operação GRANT ──> credit_grants ──> CREDIT ledger entry
        │
        └── operação CONSUME ────────────────> DEBIT ledger entry por grant
```

A separação possui três objetivos:

1. **proveniência** — cada crédito positivo pertence a um lote com origem explícita;
2. **idempotência** — cada comando econômico possui identidade estável própria;
3. **auditabilidade** — concessões e consumos são reconstruíveis por lançamentos append-only.

A contabilidade não deve depender de `profiles.credits` para explicar de onde um saldo veio ou para qual operação ele foi consumido.

## 3. `credit_operations` — envelope econômico idempotente

`credit_operations` representa o receipt persistido de um comando econômico semântico.

Campos centrais:

- `operation_id` — chave econômica estável do comando;
- `user_id` — titular da operação;
- `operation_kind` — `GRANT` ou `CONSUME`;
- `action_key` — ação de negócio;
- `request_fingerprint` — fingerprint determinístico do payload relevante;
- `outcome` — `APPLIED`, `NO_CHARGE` ou `REJECTED`;
- `requested_amount`;
- `applied_amount`;
- `reason_code`;
- `artifact_type` / `artifact_id` quando houver artefato de trabalho;
- metadata e timestamps.

Invariantes estruturais:

- `operation_id` não pode ser vazio;
- o mesmo `operation_id` não pode ser duplicado;
- `applied_amount` nunca excede `requested_amount`;
- `APPLIED` exige aplicação integral da quantidade solicitada;
- `NO_CHARGE` e `REJECTED` exigem `applied_amount = 0`;
- uma operação `GRANT` deve ser integralmente `APPLIED`.

O comportamento de replay — inclusive comparar `request_fingerprint` em reenvios do mesmo `operation_id` — pertence ao Lote 1.3B.2. O schema de 1.3B.1 apenas fornece a persistência necessária para essa decisão futura.

## 4. `credit_grants` — lotes e proveniência

`credit_grants` representa cada concessão positiva de créditos.

Origens inicialmente reconhecidas:

- `FREE_TRIAL`;
- `PURCHASED`;
- `PROMOTIONAL_BONUS`;
- `ADMIN_ADJUSTMENT`;
- `LEGACY_BALANCE`.

`LEGACY_BALANCE` existe para permitir futura migração conservadora de saldos cuja origem econômica histórica não possa ser demonstrada. Por regra, esse lote não recebe expiração automática.

Cada grant possui:

- vínculo ao titular;
- vínculo à operação `GRANT` que o criou;
- `grant_key` estável e único do produtor;
- origem;
- quantidade concedida;
- instante da concessão;
- expiração opcional;
- referência externa opcional;
- metadata.

Exemplos futuros de `grant_key`:

```text
free-trial:<user-id>
stripe:<stripe-event-id>
referral:<referral-id>
admin:<operation-id>
legacy:<user-id>:<migration-version>
```

### 4.1 Contrato FREE e política de expiração codificados no schema

O schema de 1.3B.1 materializa diretamente a regra comercial aprovada para a concessão inicial:

- `FREE_TRIAL` contém **exatamente 10 créditos**;
- `FREE_TRIAL.expires_at = granted_at + 7 dias`;
- existe no máximo um lote `FREE_TRIAL` inicial por usuário;
- `PURCHASED` **não pode** possuir `expires_at`;
- `LEGACY_BALANCE` **não pode** possuir `expires_at`;
- toda outra expiração eventualmente informada deve ocorrer depois de `granted_at`.

Não se presume expiração automática para `PROMOTIONAL_BONUS` ou `ADMIN_ADJUSTMENT` neste sublote.

### 4.2 Coerência grant ↔ operation

Um trigger de integridade de 1.3B.1 exige que cada novo grant corresponda a uma operação econômica:

- do mesmo usuário;
- de tipo `GRANT`;
- com outcome `APPLIED`;
- com `applied_amount` exatamente igual a `granted_amount`.

Assim, mesmo uma inserção direta com `service_role` não pode criar um lote cujo receipt econômico declare tipo, outcome ou quantidade diferente.

## 5. `credit_ledger_entries` — lançamentos append-only

`credit_ledger_entries` vincula movimentos econômicos a um lote específico.

Tipos:

- `CREDIT` — financia o grant;
- `DEBIT` — aloca consumo de uma operação contra um grant.

Cada lançamento vincula simultaneamente:

- usuário;
- `operation_id`;
- `grant_id`;
- tipo;
- quantidade;
- timestamps e metadata.

Foreign keys compostas por `user_id` impedem que uma operação de um usuário seja lançada sobre grant de outro usuário.

Cada grant aceita apenas um lançamento `CREDIT` inicial.

A mesma combinação `operation_id + grant_id + entry_type` não pode ser repetida.

### 5.1 Coerência ledger ↔ operation ↔ grant

Um segundo trigger de integridade impede combinações semanticamente inválidas:

- todo lançamento exige uma operação `APPLIED`;
- `CREDIT` exige operação `GRANT`;
- o `CREDIT` deve usar a mesma operação que criou o grant;
- o valor do `CREDIT` deve corresponder ao valor integral do grant/receipt;
- `DEBIT` exige operação `CONSUME`;
- uma operação `NO_CHARGE` ou `REJECTED` não pode produzir lançamento;
- um lançamento não pode apontar para grant de outro usuário.

O trigger também impede que um único lançamento `DEBIT` seja maior que `applied_amount` do receipt correspondente.

A soma concorrente de múltiplos débitos contra o mesmo grant permanece fora desta camada e é responsabilidade transacional de 1.3B.2.

## 6. Saldo derivável

O schema evita manter saldo remanescente autoritativo mutável dentro de cada grant.

Conceitualmente, para um grant ainda elegível:

```text
funded(grant)
  = soma(CREDIT)

consumed(grant)
  = soma(DEBIT)

remaining(grant)
  = funded(grant) - consumed(grant)
```

A disponibilidade total futura do usuário será derivada somente dos grants elegíveis e ainda não vencidos.

### Limite intencional de 1.3B.1

**O schema isolado não é a fronteira que impede overdraft agregado.**

Duas sessões concorrentes não devem poder ler o mesmo saldo e registrar débitos que, somados, ultrapassem o grant. Essa garantia exige uma função transacional que bloqueie/serialize a decisão econômica, determine a ordem dos grants e grave operação + lançamentos atomicamente.

Essa fronteira será responsabilidade de **1.3B.2** e não é implementada neste sublote.

Logo, 1.3B.1 fornece estrutura, coerência entre entidades e constraints locais; ele não afirma que INSERTs arbitrários de `service_role` constituem uma API completa e segura de consumo.

## 7. RLS e least privilege

As três tabelas possuem RLS habilitada.

Em 1.3B.1:

- `PUBLIC`: sem privilégios;
- `anon`: sem privilégios;
- `authenticated`: sem privilégios diretos;
- nenhuma policy de usuário é criada;
- `service_role`: somente `SELECT` e `INSERT` nas tabelas;
- `service_role`: sem `UPDATE` e sem `DELETE`.

As funções internas de validação de trigger também têm execução direta revogada de `PUBLIC`, `anon` e `authenticated`.

O objetivo é evitar que o cliente se torne autoridade sobre saldo, grants ou ledger.

A superfície autenticada de leitura e comando deve surgir somente através de RPCs governadas no sublote apropriado.

## 8. Compatibilidade com `profiles.credits`

`profiles.credits` continua intacto durante 1.3B.1.

Isso é proposital:

```text
produção atual
profiles.credits
      │
      │  permanece autoridade vigente
      │
      └───────────────────────┐
                              │
novo schema 1.3B.1            │ ainda sem cutover
credit_operations             │
credit_grants                 │
credit_ledger_entries         │
```

Nenhum saldo existente é copiado, zerado, reinterpretado ou expirado nesta etapa.

A migração futura deve ser explicitamente governada e conservadora. Quando a origem histórica não puder ser comprovada, o saldo deverá ser representado como `LEGACY_BALANCE` não expirável, salvo nova decisão humana baseada em evidência suficiente.

## 9. Integração futura com produtores positivos

1.3B.1 não altera produtores atuais, mas o schema foi desenhado para que, em sublotes posteriores, todos convirjam para grants explícitos:

| Produtor atual | Origem futura |
|---|---|
| cadastro FREE | `FREE_TRIAL` |
| compra Silver Stripe | `PURCHASED` |
| bônus de telefone | `PROMOTIONAL_BONUS` |
| bônus de indicação | `PROMOTIONAL_BONUS` |
| crédito administrativo | `ADMIN_ADJUSTMENT` |
| saldo antigo sem proveniência demonstrável | `LEGACY_BALANCE` |

A idempotência já existente do webhook Stripe por `stripe_event_id` deverá ser preservada quando o fulfillment for posteriormente adaptado para gerar `PURCHASED`.

## 10. Testes descartáveis

1.3B.1 adiciona teste SQL dedicado que comprova, em Supabase descartável:

- existência das três tabelas;
- RLS em todas elas;
- ausência de policies diretas de usuário;
- least privilege de roles;
- criação válida de FREE e PURCHASED;
- FREE com exatamente 10 créditos e janela exata de 7 dias;
- rejeição de FREE sem expiração, com quantidade diferente ou janela diferente;
- PURCHASED e LEGACY_BALANCE não expirantes;
- somente um FREE inicial por usuário;
- unicidade de `grant_key`;
- correspondência de quantidade entre `GRANT operation` e grant;
- proibição de `CONSUME operation` criar grant;
- um único lançamento `CREDIT` de funding por grant;
- correspondência do funding com grant e operation;
- proibição de `GRANT → DEBIT`;
- proibição de ledger para operação `REJECTED`/`NO_CHARGE`;
- bloqueio estrutural de atribuição cross-user;
- formas válidas e inválidas de `outcome/applied_amount`;
- shape de receipt `NO_CHARGE` para futuro Gold ilimitado.

A fixture usada pelo teste contém apenas uma tabela mínima `profiles` e dados sintéticos.

## 11. CI remoto

O workflow dedicado:

`Credit Accounting 1.3B.1 Schema CI`

usa GitHub Actions para:

1. iniciar projeto Supabase descartável;
2. aplicar fixture sintética;
3. aplicar a migration de 1.3B.1;
4. executar a matriz SQL de invariantes;
5. encerrar a stack descartável.

Não usa projeto Supabase hospedado, segredo de produção, `service_role` real ou dado de usuário real.

## 12. Artefatos do sublote

Migration versionada:

`infra/supabase/migrations/202608142140_credit_accounting_schema.sql`

Fixture descartável:

`supabase/tests/fixtures/credit_accounting_minimal_baseline.sql`

Matriz de schema:

`supabase/tests/credit_accounting_schema.sql`

Workflow:

`.github/workflows/credit-accounting-1-3b-1-schema-ci.yml`

## 13. Rollout e rollback

### Rollout permitido neste sublote

Somente:

- versionar a migration;
- provar a migration em ambiente descartável;
- revisar schema, constraints, RLS e grants;
- manter PR sem aplicação ao banco hospedado.

### Produção permanece bloqueada

A presença de uma migration no repositório **não autoriza sua aplicação**.

Antes de qualquer aplicação futura será necessário, em gate separado:

- confirmar o estado real do Supabase hospedado;
- revisar conflitos de nomes/objetos;
- revisar plano de cutover;
- revisar migração de saldos legados;
- revisar coexistência temporária com `profiles.credits`;
- revisar rollback e observabilidade;
- obter autorização explícita para produção.

### Rollback estrutural futuro

Como 1.3B.1 não faz cutover e não altera `profiles.credits`, um eventual ensaio descartável de rollback deve remover primeiro triggers/funções e depois, em ordem de dependência:

```text
credit_ledger_entries
credit_grants
credit_operations
```

Esse rollback não é executado em produção neste sublote.

## 14. Definition of Done de 1.3B.1

1.3B.1 somente poderá ser considerado tecnicamente pronto quando:

- migration for aditiva;
- `profiles.credits` permanecer sem alteração;
- as três tabelas, triggers e constraints forem comprovadas;
- RLS/least privilege forem comprovados;
- workflow descartável ficar verde;
- CI geral do monorepo ficar verde;
- regressões transversais acionadas pelos paths permanecerem verdes;
- diff permanecer restrito ao sublote;
- não houver aplicação em Supabase hospedado;
- não houver alteração de Stripe/frontend;
- 1.3B.2 não tiver sido iniciado.

## 15. Próximo gate

Após a revisão e eventual integração futura de 1.3B.1, o próximo trabalho técnico será o **Lote 1.3B.2 — command/RPC boundary transacional e idempotente**.

1.3B.2 deverá tratar, entre outros pontos:

- replay por `operation_id` + fingerprint;
- bloqueio/serialização transacional;
- saldo elegível derivado;
- consumo do FREE válido com vencimento mais próximo antes do adquirido;
- prevenção de saldo negativo e overdraft concorrente;
- Gold `NO_CHARGE` com telemetria;
- persistência da operação e seus lançamentos na mesma transação.

**1.3B.2 permanece fora do escopo e não é iniciado por este documento.**
