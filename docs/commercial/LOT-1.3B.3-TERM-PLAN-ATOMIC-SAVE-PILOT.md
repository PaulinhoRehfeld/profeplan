# Lote 1.3B.3 — Piloto de Save Atômico do Planejamento Trimestral

Data: 14 de agosto de 2026.

Base canônica: `5d31a1375493b3043b2aa3bc621e9bc3aa98817d`.

Branch: `feat/commercial-term-plan-atomic-save-pilot`.

## 1. Objetivo

O 1.3B.3 é o primeiro fluxo de negócio que conecta a fronteira econômica do 1.3B.2 a uma persistência canônica real.

O piloto é limitado ao **Planejamento Trimestral** e prova a propriedade:

```text
gerar/regenerar
  -> não cobrar

salvar conteúdo gerado
  -> decisão econômica + term_plans no mesmo comando/transação

se save falhar
  -> receipt + DEBIT também fazem rollback
```

O lote permanece **sem produção e sem cutover**.

## 2. Defeito legado confirmado

Antes deste piloto, `executeTermPlanning()` envolve a geração com:

```text
creditManager.executeWithCreditCheck(..., 'term_plan')
```

Logo, o crédito legado é reduzido depois da geração, antes de qualquer confirmação de persistência do planejamento.

Depois, o botão Save executa separadamente:

1. cache em `localStorage`;
2. `upsert` direto em `term_plans`;
3. refresh da listagem;
4. escrita adicional em `generated_contents`.

Essa sequência não oferece atomicidade entre artefato e cobrança.

## 3. Decisão do piloto

O novo caminho fica protegido por:

```text
VITE_GOVERNED_TERM_PLAN_SAVE=true
```

Ausência da variável ou qualquer valor diferente de `true` mantém o comportamento legado.

**Nenhuma configuração de ambiente é alterada por este lote.**

Isso permite integrar e testar o código sem ativá-lo em produção antes de uma decisão separada de deployment/cutover.

## 4. Geração gratuita no caminho governado

Quando o flag estiver ativo:

- geração inicial não chama `creditManager.executeWithCreditCheck`;
- regeneração também não cria débito legado;
- `generateTermPlan(..., { skipCredits: true })` continua sendo utilizado;
- `planning:generated` continua sendo publicado;
- a decisão econômica é postergada para o Save.

Quando o flag estiver desligado, o fluxo legado permanece preservado.

## 5. RPC canônico

O lote cria:

```text
credit_save_term_plan(...)
```

Características:

- `SECURITY DEFINER`;
- exige `auth.uid()`;
- não recebe `user_id` do navegador;
- executável por `authenticated`;
- não executável por `anon` ou `service_role`;
- chama a primitiva privada `credit_consume_internal(...)`;
- persiste `term_plans` somente para `APPLIED`, `NO_CHARGE` ou replay de uma decisão de sucesso;
- retorna sem persistir se a decisão for `REJECTED`;
- qualquer erro no `INSERT/UPDATE term_plans` aborta a mesma transação e desfaz receipt/DEBIT.

## 6. Idempotência derivada no servidor

O navegador não fornece `operation_id` ou `request_fingerprint`.

O RPC cria um fingerprint determinístico no banco a partir de todos os campos canônicos relevantes do plano:

- id;
- título;
- período/regime;
- disciplina;
- série;
- nível;
- carga semanal;
- reservas;
- total de aulas;
- grade de avaliação;
- base estadual;
- esfera;
- texto gerado;
- aulas estruturadas.

O `operation_id` é então derivado de:

```text
term-plan-save:<auth.uid()>:<plan_id>:<fingerprint>
```

Consequências:

- retry do mesmo payload => replay, sem novo DEBIT;
- Save repetido sem mudança => replay;
- edição real do conteúdo => novo fingerprint e nova operação econômica;
- um cliente não consegue reutilizar o mesmo `operation_id` com fingerprint manipulado, porque ambos são definidos no servidor.

## 7. Preservação de trabalho

O frontend governado diferencia:

- **rascunho local**;
- **plano canonicamente salvo**.

Antes de chamar o RPC, o plano é gravado em uma chave separada:

```text
profeplan_term_plan_governed_draft:<userId>:<planId>
```

Se o RPC falhar ou rejeitar por falta de saldo:

- o texto gerado permanece no estado da UI;
- o rascunho local permanece;
- o plano não entra no cache local de itens salvos;
- o usuário não recebe confirmação falsa de persistência.

Depois de um save canônico bem-sucedido:

- o plano entra no cache local de salvos;
- o rascunho governado é removido.

## 8. Planos sem conteúdo gerado

O piloto billable só intercepta planos com `generatedText` não vazio.

Um plano sem conteúdo gerado continua usando o caminho legado/configuracional mesmo quando o flag estiver habilitado. Isso preserva a regra de que configuração não deve ser transformada acidentalmente em evento billable.

## 9. `generated_contents`

`term_plans` já é a fonte estruturada primária da listagem de planejamentos. `generated_contents` permanece como fallback para histórico legado.

Quando o piloto estiver ativo, a chamada histórica:

```text
saveGeneratedContent(..., 'trimestral', 'TermPlans', ...)
```

é suprimida.

Motivo: uma segunda escrita fora do RPC poderia falhar depois de `term_plans + DEBIT` já terem sido confirmados, fazendo a UI reportar erro mesmo com o save econômico concluído.

O piloto portanto estabelece:

```text
term_plans = persistência canônica do novo fluxo

generated_contents = leitura/fallback legado, sem nova duplicação para esse fluxo
```

Outros tipos de `generated_contents` não são alterados.

## 10. Gold e falta de saldo

Gold usa a mesma função de save, mas o 1.3B.2 devolve:

```text
NO_CHARGE / GOLD_UNLIMITED
```

O plano é persistido e nenhum DEBIT é criado.

Sem saldo elegível:

```text
REJECTED / INSUFFICIENT_CREDITS
```

O novo conteúdo não substitui a última versão canonicamente salva e nenhum DEBIT é criado.

## 11. Colisão de ownership

Antes da decisão econômica, o RPC verifica se um `term_plans.id` já existente pertence ao próprio `auth.uid()`.

Uma tentativa de salvar um id pertencente a outro usuário é rejeitada antes da cobrança.

Existe ainda uma segunda proteção depois do `ON CONFLICT`, cobrindo a corrida em que outro usuário consiga criar o mesmo id entre a pré-verificação e o INSERT. Nesse caso é levantado erro e a transação inteira faz rollback.

## 12. Provas descartáveis

O CI específico sobe Supabase descartável e prova:

1. permissões do RPC;
2. `authenticated` continua sem acesso à primitiva privada de consumo;
3. `profiles.credits = 999` não influencia o novo saldo;
4. primeiro Save persistido gera exatamente um DEBIT;
5. retry exato não gera segundo DEBIT;
6. edição real do plano gera uma nova operação;
7. terceira edição sem saldo é rejeitada e não sobrescreve a última versão salva;
8. Gold salva com `NO_CHARGE` e zero DEBIT;
9. falha forçada de persistência depois da decisão econômica não deixa artefato, receipt ou DEBIT;
10. o crédito reaparece integralmente após o rollback;
11. colisão cross-user não transfere ownership e não cobra o usuário rejeitado;
12. oito sessões paralelas salvando exatamente o mesmo payload convergem para uma única operação, um único DEBIT e uma única linha canônica;
13. `supabase db lint --level warning` permanece verde.

## 13. Concorrência do Save

O cenário paralelo usa um usuário com exatamente um crédito e oito sessões autenticadas chamando o mesmo Save ao mesmo tempo.

Gate esperado:

```text
credit_operations = 1
DEBIT = 1
term_plans = 1
saldo = 0
```

As demais chamadas devem convergir por replay da mesma operação derivada no servidor.

## 14. Limite intencional do piloto: ainda não é cutover

A RLS atual de `term_plans` ainda permite ao usuário autenticado inserir/atualizar seus próprios registros diretamente.

Isso é preservado neste lote para que **versionar a migration não quebre o aplicativo legado** caso o banco ainda não tenha sido coordenado com o frontend.

Consequentemente, 1.3B.3 prova o caminho atômico correto, mas **não declara ainda que todo write possível em `term_plans` passa obrigatoriamente pelo ledger**.

O cutover posterior precisará coordenar, em gate próprio:

1. deployment das migrations 1.3B.1–1.3B.3;
2. migração/projeção conservadora dos saldos necessários ao piloto;
3. ativação do feature flag;
4. bloqueio/revogação do write direto de `term_plans` para o caminho migrado;
5. observabilidade e rollback operacional.

Essas ações são materialmente diferentes de apenas integrar código e **não são autorizadas por este lote**.

## 15. Arquivos do sublote

O escopo esperado inclui:

- migration do RPC atômico;
- fixture e testes SQL descartáveis;
- workflow CI específico;
- feature flag desligado por padrão;
- adaptação do PlanningOrchestrator;
- adaptação governada do TermPlanningService;
- supressão do mirror `generated_contents` somente no piloto;
- testes de frontend;
- este documento.

## 16. Fora de escopo

O 1.3B.3 não:

- aplica migration em Supabase hospedado;
- altera variáveis Vercel/produção;
- ativa `VITE_GOVERNED_TERM_PLAN_SAVE`;
- migra `profiles.credits`;
- cria FREE no ledger para usuários reais;
- altera Stripe, checkout, webhook ou fulfillment;
- altera bônus/admin atuais;
- remove ainda as policies diretas de write de `term_plans`;
- migra Assessment, Presentation, PDI, Simulation ou outros artefatos;
- faz cutover global do motor de créditos.

## 17. Gate de saída

O sublote só pode ser considerado tecnicamente pronto quando, no mesmo HEAD:

1. CI geral estiver verde;
2. CI específico 1.3B.3 estiver verde;
3. regressões de banco disparadas pelo repositório estiverem verdes;
4. testes de frontend provarem flag OFF = legado e flag ON = geração sem crédito legado + save por RPC;
5. rollback de persistência provar zero resíduo econômico;
6. concorrência de oito saves idênticos provar exatamente um DEBIT;
7. diff permanecer limitado ao piloto;
8. nenhum ambiente hospedado tiver sido alterado.

A integração futura do PR, por si só, continuará **sem autorizar deployment/cutover**.
