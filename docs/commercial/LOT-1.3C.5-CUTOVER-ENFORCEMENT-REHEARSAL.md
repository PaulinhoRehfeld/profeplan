# Lote 1.3C.5 — Enforcement e rehearsal integral do cutover de créditos

Data: 15 de agosto de 2026.

Base canônica de abertura: `0e3a2984b61c1518cd8382a2e45c35c52e86ceaf`.

Branch: `test/commercial-credit-cutover-integral-rehearsal`.

## 1. Objetivo

1.3C.5 é o último rehearsal técnico antes de qualquer decisão material de produção do motor governado de créditos.

O lote reúne, no **mesmo Supabase descartável**, as provas que até 1.3C.4 estavam distribuídas por fronteiras independentes e demonstra a ordem operacional de mudança de autoridade:

```text
estado legado sintético
  -> ledger governado
  -> importação conservadora LEGACY_BALANCE
  -> produtores positivos governados
  -> consumidores/Saves governados
  -> fechamento dos bypasses diretos billable
  -> smoke/readback
  -> prova de rollback anterior à liberação
```

O objetivo não é repetir cegamente todas as suítes históricas. O objetivo é provar que os componentes finais **coexistem e funcionam na ordem real esperada do cutover**, sem duas autoridades econômicas gastáveis.

## 2. Produção permanece bloqueada

1.3C.5 não autoriza e não executa:

- migration em Supabase hospedado;
- alteração de `profiles.credits` real;
- criação de grant ou ledger entry real;
- revogação de policy/grant hospedado;
- alteração de Vercel;
- ativação de `VITE_GOVERNED_CREDIT_PRODUCERS`;
- ativação de `VITE_GOVERNED_CREDIT_CONSUMERS`;
- ativação de `VITE_GOVERNED_TERM_PLAN_SAVE`;
- deploy de Edge Function hospedada;
- alteração externa no Stripe;
- congelamento de tráfego real;
- cutover.

Toda mudança de autoridade deste lote ocorre somente em fixtures e banco descartável criado pelo GitHub Actions.

## 3. Estado de entrada

A cadeia técnica já integrada antes de 1.3C.5 é:

```text
1.3B.1  schema contábil append-only
1.3B.2  command boundary + projeção de saldo
1.3B.3  Save atômico de TermPlan
1.3C.2  rehearsal de LEGACY_BALANCE
1.3C.3  convergência dos produtores positivos
1.3C.4A Planning / generated_contents
1.3C.4B Assessment
1.3C.4C Presentation
1.3C.4D PDI
1.3C.4E varredura final de autoridade e leitura governada
```

A `main` de abertura já contém também o avanço documental legítimo da Knowledge Factory pelo PR #91. 1.3C.5 nasce dessa `main` mais nova e não reverte nem reescreve esse avanço concorrente.

## 4. Por que existe um harness integrado novo

Os rehearsals anteriores foram deliberadamente isolados e usam baselines sintéticos diferentes.

Por exemplo:

- 1.3C.2 modela o snapshot agregado de 31 perfis;
- 1.3C.3 modela usuários e fluxos de onboarding/Stripe/bônus/admin;
- 4A modela `generated_contents` e usuários de Save;
- 4D modela PDI, escola, aluno e documentos.

Encadear as suítes antigas sem adaptação seria incorreto. Depois de 1.3C.3, a criação de um perfil FREE já dispara o grant governado de `FREE_TRIAL`; alguns testes mais antigos criam perfis depois da inicialização e assumem que nenhum producer está ativo.

Assim, 1.3C.5 cria um baseline complementar integrado e uma prova nova de transição. As suítes históricas continuam válidas como regressões dos seus próprios contratos, mas não são tratadas como substituto da prova end-to-end de cutover.

## 5. Schema descartável integrado

O workflow monta, em ordem determinística:

```text
credit_accounting_minimal_baseline
credit_positive_producer_baseline
credit_term_plan_pilot_baseline
credit_generated_content_baseline
credit_cutover_integrated_pdi_baseline
credit_legacy_cutover_snapshot

1.3B.1 schema
1.3B.2 commands
1.3B.2 invariants
Stripe fulfillment baseline
1.3B.3 TermPlan
1.3C.3 positive producers
1.3C.4A generated-content save
1.3C.4D PDI save
```

Assessment e Presentation usam a fronteira genérica `credit_save_generated_content(...)`; não possuem migration de banco independente.

O baseline PDI de 1.3C.5 é test-only e evita redefinir colunas de `profiles` já fornecidas pelo baseline de produtores.

## 6. Reutilização da prova de saldo legado

Antes do smoke de cutover, o workflow executa a prova existente de 1.3C.2.

O estado obrigatório permanece:

```text
30 perfis finitos positivos
30 grants LEGACY_BALANCE
soma = 292
Gold/unlimited sentinel 9999 -> zero grants automáticos
```

O import continua:

- não expirável;
- idempotente;
- baseado em `credit_grant_command(...)`;
- sem alterar `profiles.credits`;
- com rollback integral;
- fail-closed diante de drift do snapshot.

## 7. Produtores no mesmo schema final

Depois da importação legado, o workflow executa a prova existente de 1.3C.3 no **mesmo banco integrado**.

Isso reconfirma no estado final:

- onboarding FREE -> `FREE_TRIAL` de 10 créditos / 7 dias;
- recuperação emergencial de perfil -> mesmo producer governado;
- telefone -> `PROMOTIONAL_BONUS`;
- indicação -> `PROMOTIONAL_BONUS`;
- Stripe Silver -> `PURCHASED`;
- replay de Stripe sem duplicação;
- Gold sem grant artificial de consumo;
- downgrade Gold baseado no saldo governado;
- ajuste administrativo -> `ADMIN_ADJUSTMENT` idempotente;
- ausência de incremento positivo de `profiles.credits` nesses fluxos governados.

## 8. Enforcement dos bypasses billable

### 8.1 Superfície legada reproduzida

A fixture integrada concede deliberadamente ao papel `authenticated` os privilégios diretos históricos de INSERT/UPDATE em:

```text
term_plans
generated_contents
```

Isso permite provar que o gate realmente fecha um bypass existente, em vez de apenas testar uma tabela que já estava inacessível.

### 8.2 Rollback antes da liberação

A primeira prova de enforcement ocorre dentro de transação:

```text
BEGIN
REVOKE INSERT, UPDATE ...
verificar privilégios removidos
ROLLBACK
verificar privilégios restaurados
```

Essa prova materializa a regra operacional definida em 1.3C.1: antes da reabertura de operações econômicas, o operador precisa conseguir desfazer o fechamento de bypasses sem produzir estado parcial.

### 8.3 Enforcement no restante do rehearsal

Depois da prova de rollback, o mesmo REVOKE é reaplicado **somente no Supabase descartável**.

Em seguida o harness prova que:

- INSERT direto autenticado em `term_plans` falha;
- INSERT direto autenticado em `generated_contents` falha;
- nenhuma tentativa deixa artifact ou evento econômico residual;
- os RPCs `SECURITY DEFINER` governados continuam salvando normalmente.

Nenhuma migration de produção é criada neste lote para materializar esses REVOKEs hospedados.

## 9. Smoke integral dos consumidores

O usuário sintético de corte é um perfil legado finito com:

```text
profiles.credits = 10
LEGACY_BALANCE governado = 10
```

Depois do enforcement, ele executa sete primeiros Saves governados:

1. Planning/documento;
2. Assessment;
3. Presentation;
4. TermPlan;
5. validação de adaptação PDI;
6. relatório pedagógico PDI;
7. relatório final PDI.

Cada `CONSUME` possui contrato de custo unitário no command boundary.

Resultado esperado:

```text
ledger antes = 10
7 DEBITs      = 7
ledger depois = 3
profiles.credits permanece = 10
```

A diferença é intencional no rehearsal: depois do corte, o inteiro legado permanece congelado como registro de compatibilidade, mas não é saldo gastável nem autoridade de autorização.

Assim, não existem dois contadores consumíveis. Somente a projeção do ledger diminui.

## 10. Persistência governada sob enforcement

O smoke prova que, mesmo sem INSERT/UPDATE direto para `authenticated`, persistem corretamente:

```text
term_plans
  -> 1 TermPlan governado

generated_contents
  -> Planning
  -> Assessment
  -> Presentation
  -> mirror da adaptação PDI
  -> relatório pedagógico PDI
  -> relatório final PDI

pdi_records
  -> adaptação validada

pdi_documents
  -> block_9_content
  -> final_report
```

Isso é possível porque a decisão econômica e a persistência passam pelas fronteiras `SECURITY DEFINER` governadas, e não por writes client-side independentes.

## 11. Replay e edição

Após os sete débitos, o harness edita/reexecuta identidades de artifact já persistidas para as fronteiras de primeiro Save.

O resultado obrigatório continua:

```text
saldo governado = 3
DEBITs = 7
```

Nenhum retry ou edição do mesmo artifact pode gastar a mesma unidade econômica novamente quando o contrato daquela fronteira define primeiro Save billable.

TermPlan mantém sua semântica própria já provada em 1.3B.3: payload economicamente diferente pode representar nova operação conforme o fingerprint server-side. O rehearsal integral não altera esse contrato histórico.

## 12. Leitura de saldo

Com os writes diretos fechados, o smoke chama:

```text
credit_get_my_balance()
```

A projeção user-facing precisa continuar disponível.

O runtime 4E também é verificado pelo script:

```text
scripts/credit-consumer-final-sweep.mjs
```

Assim, o gate cobre conjuntamente:

- banco final integrado;
- ausência de bypass direto nas tabelas billable ensaiadas;
- projeção governada de saldo;
- contratos estáticos do runtime web/api.

## 13. Ordem operacional provada

O rehearsal representa a seguinte ordem futura, sem executá-la em hospedado:

```text
1. preservar/congelar estado legado
2. materializar fundação contábil
3. importar LEGACY_BALANCE
4. reconciliar o saldo
5. disponibilizar produtores governados
6. disponibilizar fronteiras de Save governadas
7. fechar writes diretos billable
8. smoke de consumidores + leitura de saldo
9. somente após sucesso, considerar liberação de tráfego
```

O passo de alteração das flags hospedadas continua fora de 1.3C.5.

## 14. Critério de autoridade única

O gate passa somente se o usuário sintético provar simultaneamente:

```text
profiles.credits não muda com consumo governado
ledger é debitado exatamente uma vez por evento billable
writes diretos billable falham
RPCs governados continuam persistindo
UI/backend possui projeção governada de saldo
```

Essa é a prova material de que uma unidade econômica não precisa existir como saldo gastável em dois sistemas durante a transição.

## 15. Risco residual de provisioning administrativo

4E registrou que uma conta criada administrativamente pode atravessar o lifecycle FREE antes de seu tier administrativo final ser aplicado.

1.3C.5 mantém esse ponto como **concern operacional de cutover**, não como bypass de autoridade: qualquer concessão nesse caminho continua no ledger e não reativa `profiles.credits` como produtor econômico.

O runbook de 1.3C.6 deverá observar explicitamente esse cenário no smoke hospedado antes da liberação de usuários.

## 16. Gate automático

O workflow:

```text
Credit Accounting 1.3C.5 Integral Cutover Rehearsal CI
```

executa:

1. varredura estática 4E;
2. criação do Supabase descartável integrado;
3. import/replay/rollback de `LEGACY_BALANCE`;
4. regressão integral dos produtores positivos;
5. prova transacional de enforcement + rollback;
6. reaplicação descartável de enforcement;
7. tentativa negativa de writes diretos;
8. smoke de sete Saves governados;
9. projeção governada de saldo;
10. replay/edição sem débito extra nas fronteiras de primeiro Save;
11. `supabase db lint --level warning`;
12. destruição do stack descartável.

O workflow não recebe credenciais de produção.

## 17. Definition of Done

1.3C.5 estará tecnicamente pronto quando o mesmo HEAD provar:

- `main` de origem confirmada e sem perda de avanço concorrente;
- static sweep 4E verde;
- 30 grants `LEGACY_BALANCE` / 292 créditos preservados;
- sentinel Gold 9999 não materializado;
- produtores 1.3C.3 verdes no schema integrado;
- rollback do enforcement restaura a superfície pré-corte;
- enforcement final descartável remove INSERT/UPDATE billable direto;
- tentativa de bypass autenticado falha fechada;
- sete Saves governados geram exatamente sete débitos;
- saldo governado 10 -> 3;
- `profiles.credits` do usuário de corte permanece 10;
- persistências canônicas sobrevivem sob enforcement;
- replay/edição não cria débito indevido;
- `credit_get_my_balance()` continua funcional;
- lint do banco verde;
- CI geral verde;
- nenhum recurso hospedado alterado.

## 18. Handoff para 1.3C.6

A integração de 1.3C.5, por si só, **não autoriza produção**.

1.3C.6 permanece bloqueado até autorização material explícita e deverá começar por nova inspeção, incluindo no mínimo:

- `main` canônica daquele momento;
- preflight read-only dos objetos reais hospedados;
- snapshot agregado final e comparação com o histórico anterior;
- estado real de policies/grants;
- estado de Stripe/fulfillment em leitura;
- versão anterior de aplicação para rollback;
- runbook exato de freeze, migrations, import, flags, enforcement, smoke e liberação;
- critérios objetivos de abort/rollback.

Nenhuma dessas ações hospedadas é executada por 1.3C.5.
