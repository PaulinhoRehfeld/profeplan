# Lote 1.3B.2 — Fronteira transacional e idempotente de comandos de crédito

Data: 14 de agosto de 2026.

Base canônica de implementação: `9b13be90a510974a6ac3ca9e325c39310ccb9a9f`.

Branch: `feat/commercial-credit-command-boundary`.

## 1. Objetivo

Este sublote implementa a fronteira econômica governada construída sobre o schema contábil do Lote 1.3B.1.

O objetivo não é ainda substituir os fluxos atuais do aplicativo. O objetivo é provar, em ambiente descartável, que o backend possui primitivas capazes de sustentar futuramente a regra:

> uma ação de negócio efetivamente persistida consome no máximo 1 crédito, com replay idempotente, sem saldo negativo e sem autoridade econômica no cliente.

Nenhuma migration deste lote é aplicada ao Supabase hospedado durante sua implementação ou validação.

## 2. Decisão arquitetônica central — não existe RPC público de “gastar crédito”

Criar um RPC autenticado do tipo `consume_credit()` permitiria que o frontend debitasse um crédito independentemente do salvamento do artefato. Isso recriaria, em outra camada, o mesmo defeito conceitual identificado no 1.3A.

Por isso, o consumo é implementado como uma primitiva **privada**:

`credit_consume_internal(...)`

Ela não é executável por:

- `anon`;
- `authenticated`;
- `service_role`.

Somente o owner das funções de banco — e, futuramente, um RPC `SECURITY DEFINER` de salvamento canônico — pode invocá-la.

O padrão futuro obrigatório para um save billable será:

```text
BEGIN
  prealocar artifact_id + operation_id
  -> credit_consume_internal(...)

  se REJECTED:
       não persistir artefato
       COMMIT receipt REJECTED

  se APPLIED ou NO_CHARGE:
       persistir artefato canônico
       persistir escritas derivadas da mesma operação
       COMMIT

  se qualquer persistência falhar:
       ROLLBACK
       receipt + DEBIT também desaparecem
END
```

Assim, embora a decisão econômica possa ser calculada antes do INSERT do artefato dentro da transação, **nenhum débito pode sobreviver sem o save canônico correspondente**.

## 3. Autoridade contábil

`profiles.credits` continua intacto e não participa das decisões do novo ledger.

O saldo governado é derivado exclusivamente de:

- `credit_grants`;
- `credit_ledger_entries`;
- validade temporal do grant.

A projeção não usa `profiles.credits`, mesmo quando esse campo contém outro valor.

Isso permite validar o novo motor sem alterar o comportamento vigente da aplicação.

## 4. Receipt durável de consumo

`credit_operations` recebe dois campos adicionais:

- `consumed_grant_id`;
- `balance_after`.

Para `CONSUME/APPLIED`:

- `requested_amount = 1`;
- `applied_amount = 1`;
- `consumed_grant_id` é obrigatório;
- `balance_after` é obrigatório e não negativo.

Para `CONSUME/NO_CHARGE` e `CONSUME/REJECTED`:

- `applied_amount = 0`;
- não existe `consumed_grant_id`;
- `balance_after` permanece registrado.

Isso permite que um replay retorne o resultado original sem recalcular o saldo com base em operações posteriores.

## 5. Idempotência

A chave de repetição continua sendo `operation_id`.

Um replay válido precisa coincidir em:

- usuário;
- tipo de operação;
- `action_key`;
- `request_fingerprint`;
- quantidade;
- `artifact_type`;
- `artifact_id`.

Se o mesmo `operation_id` for reutilizado com payload divergente, o comando falha com erro de argumento inválido.

O replay válido:

- não insere uma nova `credit_operation`;
- não cria novo `DEBIT`;
- retorna `reason = REPLAY`;
- preserva `original_reason`;
- retorna o mesmo `consumed_grant_id` e `balance_after` da decisão original.

## 6. Anti-overdraft e concorrência

Todos os comandos econômicos de um usuário adquirem lock transacional sobre a mesma linha de `profiles`:

```sql
SELECT ...
FROM profiles
WHERE id = p_user_id
FOR UPDATE;
```

Esse lock é usado tanto em grants quanto em consumes.

Consequência: duas transações concorrentes do mesmo usuário não podem tomar a decisão econômica final sobre o mesmo saldo ao mesmo tempo.

O CI do lote dispara oito sessões PostgreSQL paralelas contra um usuário com exatamente um crédito.

Gate esperado:

```text
1 APPLIED
7 REJECTED
1 DEBIT
saldo final = 0
```

## 7. Cardinalidade econômica

O contrato aprovado é um comando semântico salvo = no máximo 1 crédito.

O schema passa a impor:

- todo `CONSUME` solicita exatamente 1;
- uma operação pode possuir no máximo um `DEBIT`;
- o `DEBIT` deve apontar exatamente para `consumed_grant_id` gravado no receipt;
- uma operação `GRANT` pode criar no máximo um grant.

Isso endurece a proteção mesmo contra inserções administrativas incorretas.

## 8. Ordem determinística de consumo

O 1.3A exige FREE válido primeiro e política determinística para os demais lotes.

Para este sublote, a política de referência é:

1. `FREE_TRIAL` válido, com vencimento mais próximo primeiro;
2. `PROMOTIONAL_BONUS`;
3. `ADMIN_ADJUSTMENT`;
4. `LEGACY_BALANCE`;
5. `PURCHASED`.

Dentro da mesma origem, grants mais antigos são consumidos antes; `id` é o desempate final.

Razão da escolha: preservar o máximo possível de saldo comprovadamente comprado, depois de consumir promoções válidas e saldos não comprados.

Essa política está versionada em código e testes, mas ainda não produz efeito comercial porque não há cutover.

## 9. Expiração e tempo

Um grant só entra no saldo elegível quando:

```text
granted_at <= agora
```

E permanece elegível quando:

```text
expires_at IS NULL
OU
expires_at > agora
```

Logo:

- FREE vencido permanece no histórico, mas sai do saldo disponível;
- PURCHASED continua não expirável por constraint do 1.3B.1;
- grant futuro não pode ser gasto antes de `granted_at`.

## 10. Gold

Gold passa pela mesma fronteira econômica, mas produz:

```text
outcome = NO_CHARGE
reason = GOLD_UNLIMITED
applied_amount = 0
consumed_grant_id = NULL
```

A operação fica auditável, mas nenhum `DEBIT` é inserido.

Os créditos eventualmente existentes no ledger do usuário Gold permanecem preservados para uso futuro após eventual downgrade.

## 11. Falta de saldo

Se não houver grant elegível com saldo positivo:

```text
outcome = REJECTED
reason = INSUFFICIENT_CREDITS
balance_after = 0
```

Nenhum `DEBIT` é criado.

No futuro RPC de salvamento, esse resultado significa que o artefato não deve ser persistido no banco, enquanto o conteúdo ainda existente no cliente deve ser preservado pela camada de UX.

## 12. Concessões positivas

O sublote cria:

`credit_grant_command(...)`

A função é executável somente por `service_role` e será o ponto de convergência futuro para:

- onboarding FREE;
- fulfillment Silver/Stripe;
- bônus promocionais;
- ajustes administrativos;
- migração conservadora de saldo legado.

O comando exige:

- `operation_id`;
- `request_fingerprint`;
- `grant_key`;
- origem;
- quantidade;
- datas;
- referência de origem.

Replay do mesmo comando não duplica grants ou CREDITs.

Reutilização divergente de `operation_id` ou `grant_key` é recusada.

## 13. Fim do INSERT direto por service_role

O 1.3B.1 concedia temporariamente `SELECT, INSERT` ao `service_role` para permitir a construção incremental do schema.

O 1.3B.2 remove o `INSERT` direto de:

- `credit_operations`;
- `credit_grants`;
- `credit_ledger_entries`.

O `service_role` mantém leitura, mas concessões positivas devem passar por `credit_grant_command`.

A primitiva de consumo permanece privada inclusive para `service_role`.

## 14. Consulta de saldo

São criadas duas projeções governadas:

### `credit_get_my_balance()`

Executável por `authenticated`.

Não aceita `user_id`; utiliza `auth.uid()` e, portanto, só retorna o saldo do próprio usuário.

### `credit_get_balance_for_user(uuid)`

Executável por `service_role` para integrações backend.

A resposta inclui:

- `total`;
- `free_trial`;
- `purchased`;
- `promotional_bonus`;
- `admin_adjustment`;
- `legacy_balance`;
- `next_expiry`;
- `tier`;
- `unlimited`;
- `as_of`.

Nenhuma leitura direta das tabelas é concedida a `authenticated`.

## 15. Prova de rollback

O CI executa:

```text
BEGIN
  credit_consume_internal(...)
ROLLBACK
```

Depois verifica:

- operação de consumo inexistente;
- DEBIT inexistente;
- saldo original preservado.

Essa é a prova mínima de que a futura persistência do artefato poderá compartilhar a mesma atomicidade do débito.

## 16. Testes negativos e de segurança

A matriz descartável cobre pelo menos:

- `service_role` sem INSERT direto;
- `service_role` sem EXECUTE na primitiva privada de consumo;
- `service_role` com acesso ao grant governado;
- `anon` sem leitura de saldo;
- `authenticated` com leitura apenas do próprio saldo;
- replay de grant sem duplicação;
- replay de consume sem débito duplo;
- fingerprint divergente recusado;
- FREE consumido antes de PURCHASED;
- FREE vencido ignorado;
- grant futuro ignorado;
- Gold sem débito;
- insuficiência sem saldo negativo;
- política determinística para bônus/admin/legacy/purchased;
- rollback sem resíduo;
- oito sessões concorrentes contra um único crédito.

## 17. Arquivos do sublote

1. `infra/supabase/migrations/202608142230_credit_accounting_commands.sql`
2. `infra/supabase/migrations/202608142231_credit_accounting_command_invariants.sql`
3. `supabase/tests/credit_accounting_commands.sql`
4. `supabase/tests/credit_accounting_commands_concurrency_assert.sql`
5. `.github/workflows/credit-accounting-1-3b-2-command-ci.yml`
6. `docs/commercial/LOT-1.3B.2-CREDIT-COMMAND-BOUNDARY.md`

## 18. Fora de escopo

Este lote não:

- aplica migration no Supabase hospedado;
- migra `profiles.credits`;
- altera o cadastro atual para criar FREE no ledger;
- altera fulfillment Stripe;
- altera `admin_add_credits`;
- altera bônus de telefone/indicação;
- altera `checkUsageQuota`;
- altera `incrementUserUsage`;
- altera `CreditManager`;
- altera qualquer fluxo de save do frontend;
- cria checkout;
- altera PR comercial nº 48;
- altera Knowledge Factory como mudança própria;
- faz cutover do ledger.

## 19. Gate de saída

O 1.3B.2 só pode ser considerado tecnicamente concluído quando, no mesmo HEAD:

1. CI geral estiver verde;
2. CI específico 1.3B.2 estiver verde;
3. regressões de banco disparadas pelo repositório estiverem verdes;
4. teste paralelo provar `1 APPLIED / 7 REJECTED / 1 DEBIT`;
5. rollback provar ausência de resíduo econômico;
6. diff continuar limitado aos arquivos declarados;
7. nenhuma produção tiver sido tocada.

Mesmo após integração futura do PR, a migration continuará apenas versionada no GitHub até autorização material separada para ambiente hospedado.

## 20. Próximo trabalho após 1.3B.2

Somente após integração e novo gate será possível escolher um primeiro fluxo de negócio para provar a atomicidade completa `save + decisão econômica`.

A recomendação é começar por **um único tipo de artefato**, em PR separado, antes de migrar os demais fluxos e antes de qualquer cutover global.
