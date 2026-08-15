# Lote 1.3C.4E — Varredura final dos consumidores e preparação governada do cutover

Data: 15 de agosto de 2026.

Base canônica inicial: `69211a2a64c05c341f5fd2d5742a1d252607e22d`.

## 1. Objetivo

1.3C.4E fecha a convergência de consumidores iniciada em 4A–4D sem realizar o cutover de produção.

O sublote prova e reforça quatro invariantes:

1. geração, preview, regeneração e chat não persistido tornam-se NON_BILLABLE quando o gate global de consumidores estiver ativo;
2. todo Save billable ativo possui uma fronteira server-side governada;
3. `profiles.credits` deixa de ser autoridade de débito, de crédito positivo e de leitura de saldo atual durante o modo governado;
4. nenhum gate pode ser ativado em produção antes de as migrations correspondentes estarem materialmente implantadas e reconciliadas.

4E prepara o código e os gates. **4E não ativa produção.**

## 2. Estado de entrada

Antes de 4E estavam tecnicamente integrados:

- 1.3C.4A — Planning / `generated_contents`;
- 1.3C.4B — Assessment;
- 1.3C.4C — Presentation;
- 1.3C.4D — PDI.

A flag global permanecia OFF:

```text
VITE_GOVERNED_CREDIT_CONSUMERS=false
```

Os produtores positivos também permaneciam no modo legado:

```text
VITE_GOVERNED_CREDIT_PRODUCERS=false
```

O piloto histórico do planejamento trimestral permanecia independente:

```text
VITE_GOVERNED_TERM_PLAN_SAVE=false
```

## 3. Varredura de consumidores ativos

A inspeção do runtime ativo confirmou chamadas históricas de:

```text
checkUsageQuota()
incrementUserUsage()
```

em serviços de geração/chat.

Essas chamadas não precisam ser removidas fisicamente em 4E porque a camada central `apps/web/src/services/credits/quota.ts` já define o comportamento de compatibilidade:

- consumer flag OFF: preserva a checagem e o débito legado;
- consumer flag ON: `checkUsageQuota()` permite o trabalho e `incrementUserUsage()` é no-op.

Assim, a geração pode continuar chamando a API histórica sem continuar sendo autoridade econômica.

A varredura também exige que qualquer read-modify-write de débito direto fique isolado exclusivamente nesse helper legado. O gate 4E falha se um segundo decremento direto equivalente reaparecer no runtime ativo.

## 4. Finding P0 — coordenação do planejamento trimestral

4E encontrou uma janela econômica incorreta entre dois gates independentes.

Antes da correção:

```text
VITE_GOVERNED_CREDIT_CONSUMERS=true
VITE_GOVERNED_TERM_PLAN_SAVE=false
```

produziria:

```text
geração trimestral -> NON_BILLABLE
Save trimestral    -> caminho legado
mirror adicional   -> caminho legado
```

Isso violaria a regra de primeiro Save billable.

### Correção

`isGovernedTermPlanSavePilotEnabled()` passa a significar:

```text
VITE_GOVERNED_TERM_PLAN_SAVE=true
OR
VITE_GOVERNED_CREDIT_CONSUMERS=true
```

Consequências:

- o piloto histórico continua podendo ser exercitado isoladamente;
- o cutover global de consumidores implica automaticamente o Save trimestral governado;
- a mesma decisão suprime o mirror legado em `generated_contents`;
- não existe mais configuração em que a geração trimestral fique NON_BILLABLE enquanto o Save gerado permanece fora da fronteira econômica.

## 5. Finding P0 — criação administrativa de usuário

A varredura identificou `/api/auth/admin-create-user` como produtor positivo que não constava do inventário original de 1.3C.3.

O endpoint aceitava `credits` do navegador, aplicava default 10 e escrevia diretamente `profiles.credits` via `service_role`.

Isso permitia reintroduzir saldo legado depois da convergência dos demais produtores.

### Correção server-side

Quando:

```text
VITE_GOVERNED_CREDIT_PRODUCERS=true
```

o endpoint:

- rejeita qualquer request que ainda tente fornecer `credits`;
- omite `credits` do `profiles.upsert`;
- registra no audit log que a autoridade é `ledger`;
- não possui fallback silencioso para saldo legado.

Quando a flag está OFF, o default histórico de 10 créditos é preservado.

### Correção de UI

`CreateUserModal`:

- não mostra o campo de créditos iniciais em modo governado;
- não envia `credits` no request;
- informa que créditos adicionais devem usar ajuste administrativo governado;
- mantém exatamente o comportamento legado com a flag OFF.

O servidor continua sendo a proteção real: um cliente antigo ou request forjado não consegue contornar a regra apenas enviando o campo manualmente.

## 6. Finding P0 — criação emergencial de perfil

Foram encontrados dois fallbacks ativos capazes de fabricar saldo legado quando um perfil não era localizado:

1. `apps/web/src/hooks/useProfeplanAuth.ts`;
2. `apps/web/src/services/profile/profileRepository.ts`.

Ambos podiam executar:

```text
FREE -> credits = 10
admin -> credits = 9999
```

### Correção

Com produtores governados ON, os dois fallbacks continuam podendo recuperar/criar a linha de perfil, mas omitem totalmente o campo `credits`.

O onboarding positivo pertence então ao mecanismo 1.3C.3 do banco/ledger.

Com a flag OFF, o fallback histórico permanece disponível.

O `IS_BETA_TESTING=false` de `profileRepository` contém um override visual histórico de `credits=9999`; como está desativado e não grava banco, não constitui autoridade econômica ativa. Um futuro modo beta deve ser reconciliado separadamente antes de ser habilitado.

## 7. Produtores positivos já convergidos

A varredura reconfirmou que os produtores conhecidos de 1.3C.3 já possuem gates governados:

- FREE onboarding;
- Stripe;
- bônus de telefone;
- bônus de indicação;
- ajuste administrativo.

Em particular:

- `referrals.ts` usa RPCs governados quando producer flag ON;
- `adminProfiles.ts` envia `p_credits=null` em edição genérica governada;
- `admin_add_credits` governado exige `operation_id` idempotente;
- `UserList` deixa de editar/exibir o inteiro legado como saldo atual;
- `AddCreditsModal` apresenta o ajuste como operação do ledger.

## 8. Leitura de saldo

4E encontrou duas leituras de UX que ainda tratavam `profiles.credits` como saldo atual:

- Sidebar;
- alerta de crédito baixo do Planning Cockpit.

Foi introduzido o reader:

```text
getMyGovernedCreditBalance()
  -> credit_get_my_balance()
  -> projeção server-side do ledger
```

### Regra de falha

Com consumer flag ON:

- Sidebar usa exclusivamente a projeção governada;
- se o RPC falhar, mostra `Saldo indisponível`;
- não volta silenciosamente para `profiles.credits`;
- o alerta de crédito baixo também consulta a projeção governada;
- falha dessa leitura não cria um bloqueio baseado no inteiro legado.

Com a flag OFF, a UX histórica continua usando o valor do perfil.

## 9. PDI — ausência de bypass ativo

A inspeção confirmou que o fluxo ativo de validação PDI:

```text
validatePdiAdaptationGoverned(...)
-> return
```

quando o consumidor governado está ativo.

Portanto ele não cai nos writes legados posteriores de `addBlock9Adaptation()` / autosave.

Também foi confirmado que `generateAdaptationsForLesson()` não possui call site ativo no app corrente.

Esses caminhos não são blockers de 4E.

## 10. Fronteiras de Save reconciliadas

Com `VITE_GOVERNED_CREDIT_CONSUMERS=true`, a topologia esperada é:

```text
Planning / documentos
  -> credit_save_generated_content(...)

Assessment
  -> credit_save_generated_content(...)

Presentation
  -> credit_save_generated_content(...)

Term Planning gerado
  -> credit_save_term_plan(...)

PDI adaptação
  -> credit_validate_pdi_adaptation(...)

PDI relatório pedagógico
  -> credit_save_pdi_generated_report(...)

PDI relatório final / Bloco 11
  -> credit_save_pdi_final_report(...)
```

O browser não determina `action_key`, débito ou saldo econômico dessas fronteiras.

## 11. Matriz de flags

### Todas OFF

```text
TERM_PLAN_SAVE=false
CREDIT_PRODUCERS=false
CREDIT_CONSUMERS=false
```

Resultado: comportamento legado preservado.

### Somente TermPlan pilot ON

```text
TERM_PLAN_SAVE=true
CREDIT_PRODUCERS=false
CREDIT_CONSUMERS=false
```

Resultado: rehearsal isolado do Save trimestral, como definido em 1.3B.3.

### Producers ON

```text
CREDIT_PRODUCERS=true
```

Pré-condição: migrations de produtores 1.3C.3 materialmente aplicadas.

Resultado esperado: FREE/Stripe/bônus/admin/fallbacks positivos não usam `profiles.credits` como autoridade.

### Consumers ON

```text
CREDIT_CONSUMERS=true
```

Pré-condição: fronteiras/migrations de 4A–4D e TermPlan materialmente aplicadas.

Resultado esperado:

- geração/chat/preview NON_BILLABLE;
- Planning, Assessment, Presentation, TermPlan e PDI salvam por fronteiras governadas;
- TermPlan é automaticamente coordenado com o gate global;
- saldo de UX vem da projeção do ledger.

### Cutover de produção

4E **não define que ligar uma flag isoladamente seja seguro em produção**.

O cutover real deverá usar uma ordem coordenada, após prova material do ambiente hospedado:

1. migrations/funções/schema presentes;
2. saldo legado reconciliado/importado conforme 1.3C.2;
3. produtores positivos governados disponíveis;
4. consumidores/Saves governados disponíveis;
5. leituras do ledger disponíveis;
6. somente então alteração explícita das flags hospedadas;
7. smoke/rehearsal/rollback conforme o lote posterior de enforcement.

## 12. Gate automático 4E

O script:

```text
scripts/credit-consumer-final-sweep.mjs
```

verifica contratos estáticos do runtime ativo e falha se os invariantes esperados desaparecerem.

O workflow:

```text
Credit Accounting 1.3C.4E Final Sweep CI
```

executa:

- varredura estática de autoridade;
- testes de coordenação TermPlan;
- teste de supressão do mirror;
- testes do reader de saldo governado;
- testes de criação administrativa com producer flag ON/OFF;
- teste existente de idempotência do ajuste administrativo.

O gate não usa credenciais de produção nem modifica ambiente hospedado.

## 13. Escopo do runtime

A prova de 4E considera como runtime ativo principal:

```text
apps/web/src
api
```

`legacy-web-legacy`, exemplos históricos e scripts de diagnóstico não são executados pelo build web canônico e não constituem autoridade do runtime ativo.

Isso não os transforma em código aprovado para futura reativação: qualquer tentativa de reintroduzi-los no runtime exige nova auditoria econômica.

## 14. Risco residual deliberado

A migration de convergência dos produtores 1.3C.3 cria a concessão FREE a partir do lifecycle de criação do perfil. Um usuário criado administrativamente pode atravessar esse lifecycle antes de seu tier administrativo final ser atualizado.

Em 4E isso permanece dentro do ledger — não reintroduz `profiles.credits` como autoridade — mas a semântica exata de onboarding de contas provisionadas por admin deve ser observada no rehearsal hospedado antes do cutover. Créditos adicionais continuam exigindo ajuste administrativo governado.

Esse ponto é classificado como **rehearsal/cutover concern**, não como bypass de autoridade.

## 15. Não escopo e bloqueios

4E não autoriza:

- aplicação de migration em Supabase hospedado;
- alteração de saldo ou grant real;
- ativação de qualquer flag em Vercel/produção;
- alteração de Edge Function hospedada;
- alteração externa no Stripe;
- revogação final de policies/grants hospedados;
- eliminação física imediata de todo código legado;
- cutover;
- 1.3C.5 enforcement/rehearsal integral.

Produção permanece bloqueada.
