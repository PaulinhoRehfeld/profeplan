# Lote 1.3A — Inventário econômico de créditos e fronteira BILLABLE/NON_BILLABLE

Data: 14 de agosto de 2026.

Base de inspeção: `main` em `e0ba47bf063b324df141c370ebf371763fbf2364`.

Branch documental: `docs/commercial-credit-accounting-inventory`.

## 1. Status e escopo

Este documento formaliza o inventário do sistema de créditos do ProfePlan antes de qualquer alteração de schema, migration, RPC, RLS, grant, frontend comercial ou produção.

O objetivo de 1.3A é responder, de forma governada, **qual é a unidade econômica que deve consumir 1 crédito** e quais operações nunca devem consumir saldo.

Este sublote é exclusivamente documental e de inspeção. Ele não:

- altera `profiles.credits`;
- cria ledger;
- cria migration/RPC/RLS/grant;
- altera Supabase hospedado;
- altera Stripe, Payment Links, promotion codes ou webhooks;
- altera produção;
- modifica o PR comercial nº 48;
- altera a Knowledge Factory.

## 2. Regras comerciais aprovadas que governam o desenho

As regras de produto para o novo motor são:

1. conta FREE inicia com **10 créditos promocionais**;
2. os 10 créditos FREE têm validade de **7 dias a partir da criação da conta**;
3. **somente o lote FREE inicial** expira automaticamente segundo a regra atualmente aprovada;
4. créditos adquiridos em compra não expiram;
5. havendo crédito FREE válido e crédito adquirido, consumir primeiro o FREE com vencimento mais próximo;
6. uma **ação de negócio efetivamente persistida** consome no máximo 1 crédito;
7. configuração, leitura, busca, carregamento e navegação não consomem crédito;
8. Gold é ilimitado e não sofre débito;
9. configurações de usuário/perfil/escola não consomem crédito;
10. saldo não pode ficar negativo;
11. retry, concorrência e duplo clique não podem gerar débito duplo;
12. consumo precisa ser atômico e idempotente;
13. a contabilidade precisa distinguir pelo menos `FREE_TRIAL`, `PURCHASED`, `PROMOTIONAL_BONUS` e `ADMIN_ADJUSTMENT`;
14. falta de saldo não pode destruir o trabalho do professor;
15. o usuário sem saldo deve poder seguir para “Planos & Créditos”.

Não se infere expiração para bônus de indicação/telefone ou ajustes administrativos. Enquanto não existir decisão comercial específica, a única expiração automática definida neste lote é a do `FREE_TRIAL` inicial de 7 dias.

## 3. Diagnóstico do modelo vigente

### 3.1 Saldo agregado sem origem

O estado atual usa `profiles.credits` como um único inteiro agregado.

A conta FREE é criada com `credits = 10`, mas o registro não informa:

- origem;
- lote;
- data de concessão específica;
- data de expiração;
- saldo remanescente por origem;
- operação econômica que adicionou ou consumiu o crédito.

O mesmo inteiro recebe hoje:

- 10 créditos iniciais FREE;
- créditos adquiridos pelo Stripe Silver;
- bônus de telefone;
- bônus de indicação;
- ajustes administrativos.

Logo, zerar ou expirar diretamente `profiles.credits` seria incorreto porque poderia eliminar crédito comprado ou concedido por outra origem.

### 3.2 Débito client-side não atômico

`incrementUserUsage` executa um padrão read-modify-write:

```text
ler profile.credits
-> calcular credits - 1
-> UPDATE profiles
```

Não existe `operation_id`, reserva transacional, compare-and-swap ou ledger de consumo. Dois comandos concorrentes podem observar o mesmo saldo e produzir resultado incorreto; retries não possuem chave econômica de idempotência.

### 3.3 Cobrança ligada à geração, não ao salvamento

Os tipos atualmente considerados pagos são:

```text
generate
document
chat
term_plan
aula
simulation
```

Essa taxonomia descreve **tipo técnico de chamada**, e não a ação de negócio persistida pelo professor.

Em vários fluxos, o crédito é consumido imediatamente após a resposta da IA, mesmo que o professor nunca salve o resultado.

## 4. Anomalias P1 comprovadas

### P1-CR-01 — risco de débito duplo no PlanningManager

Fluxo observado:

```text
generateGeminiContent(userId)
  -> checkUsageQuota
  -> IA
  -> incrementUserUsage(..., 'chat')

PlanningManager AUTO-PERSISTENCE
  -> savePlan(...)
  -> generated_contents INSERT
  -> incrementUserUsage(..., 'document')
```

Consequência: uma única interação que gera e é automaticamente persistida pode consumir **2 créditos**.

### P1-CR-02 — planejamento trimestral cobra antes do Save

`PlanningAuthority`/`PlanningOrchestrator` cobram após geração bem-sucedida. O `TermPlanningManager` possui posteriormente um botão próprio de `Salvar`, que persiste em `term_plans` e também em `generated_contents`.

Consequências:

- gerar e abandonar o resultado já pode consumir crédito;
- regenerar por feedback pode consumir novo crédito sem novo salvamento;
- o clique de salvar não é a fronteira econômica;
- uma única ação de salvar produz múltiplas escritas que não podem ser cobradas separadamente.

### P1-CR-03 — avaliação cobra na geração, não no salvamento

`generateAssessmentWithContext` cobra depois de gerar e parsear a avaliação.

O `AssessmentManager` apenas mantém a avaliação em memória até o usuário clicar `Salvar Avaliação`.

`saveAssessment` grava localmente e dispara sincronização com `generated_contents`/`lessons`, mas não consome crédito.

Consequência: a prévia abandonada é cobrada; o comando de salvamento não é a fronteira econômica.

### P1-CR-04 — apresentação cobra na geração, não no salvamento

`generatePresentationJSON` consome crédito após a geração do JSON.

`PresentationCreator` oferece depois `Salvar na Memória`, que grava memória + `generated_contents`, sem débito próprio.

Consequência: geração abandonada é cobrada, enquanto a persistência não é a autoridade econômica.

### P1-CR-05 — PDI possui caminhos com check sem débito e caminhos BFF sem o mesmo gate

`generateBlock9Adaptation` pode:

- no fluxo local, verificar quota e retornar a adaptação sem executar débito;
- no fluxo BFF, retornar antes do gate local;
- posteriormente, a validação da adaptação pode escrever `pdi_records`, `pdi_documents.block_9_content` e `generated_contents`.

Consequência: a semântica de crédito difere por rota técnica e não pela ação do professor.

### P1-CR-06 — múltiplas escritas derivadas de um único comando

Exemplos:

- `Salvar Planejamento` -> `term_plans` + `generated_contents`;
- `savePlan` -> `generated_contents` + `lessons` + possível log PDI;
- `Salvar Avaliação` -> localStorage + `generated_contents` + `lessons` + possível log PDI;
- `Validar Adaptação` -> log PDI + bloco 9 + documento em `generated_contents`;
- `Salvar Apresentação` -> memória de aula + `generated_contents`.

A quantidade de tabelas afetadas **não pode definir a quantidade de créditos**.

## 5. Unidade econômica normativa proposta

A unidade econômica é um **comando de persistência semântico e visível ao usuário**.

Definição:

> Uma operação BILLABLE é um comando do professor que cria ou confirma a persistência canônica de um artefato pedagógico de trabalho. Todas as escritas auxiliares produzidas por esse mesmo comando pertencem à mesma operação econômica e, em conjunto, podem consumir no máximo 1 crédito.

Cada execução billable deve receber um `operation_id` estável.

O mesmo `operation_id` reapresentado por retry, refresh, double-click, falha de rede ou reprocessamento deve devolver o resultado econômico anterior e **não consumir novo crédito**.

### 5.1 O que NÃO define uma nova unidade econômica

Não gera novo crédito adicional:

- número de tabelas atualizadas;
- gravação de memória auxiliar;
- registro automático em PDI derivado de outro save;
- atualização de cache/localStorage;
- retry de sincronização;
- reenvio do mesmo comando;
- execução de webhook repetido;
- exportação do artefato já salvo.

## 6. Matriz BILLABLE/NON_BILLABLE

| Domínio | Ação observada | Estado atual | Classificação-alvo | Unidade econômica / observação |
|---|---|---|---|---|
| Chat geral | enviar pergunta e receber resposta | cobra `chat` ao iniciar/obter resposta | **NON_BILLABLE** | conversa/preview não persistida como artefato não consome crédito |
| Planning chat | gerar resposta sem persistir artefato | cobra `chat` | **NON_BILLABLE** | geração não é save |
| Planning auto-persistence | resposta detectada como plano/material/atividade e salva automaticamente | pode cobrar geração + `document` | **BILLABLE somente se a auto-persistência for tratada como save visível/confirmado** | 1 `operation_id`; nunca 2 créditos; recomendação: tornar a persistência economicamente explícita ao usuário |
| Plano de aula/documento | `savePlan` com persistência canônica | cobra `document` após `generated_contents` | **BILLABLE** | 1 comando; `lessons`/PDI derivados fazem parte da mesma operação |
| Planejamento trimestral | gerar | cobra `term_plan` | **NON_BILLABLE** | prévia/regeneração não salva não deve cobrar |
| Planejamento trimestral | Salvar | persiste `term_plans` + `generated_contents`, sem novo débito específico | **BILLABLE** | 1 comando/1 crédito, apesar das duas representações persistidas |
| Planejamento trimestral | regenerar por feedback sem salvar | cobra novamente hoje | **NON_BILLABLE** | somente save posterior pode cobrar |
| Avaliação | gerar prévia | cobra `generate` | **NON_BILLABLE** | geração em memória não é artefato persistido |
| Avaliação | Salvar Avaliação | local-first + sync cloud, sem débito | **BILLABLE** | 1 comando; billing só deve ser confirmado quando o backend aceitar o commit canônico; retry de sync mantém `operation_id` |
| Avaliação | imprimir/exportar DOCX | sem débito | **NON_BILLABLE** | transformação/saída de artefato já existente |
| Correção de resposta escrita | analisar imagem/resposta | não usa quota no serviço atual | **NON_BILLABLE por padrão** | se no futuro houver comando explícito “Salvar correção”, esse save pode ser classificado separadamente |
| Apresentação | gerar roteiro/preview | cobra `generate` | **NON_BILLABLE** | geração não salva não cobra |
| Apresentação | Salvar na Memória | memória + `generated_contents`, sem débito | **BILLABLE** | 1 comando/1 crédito |
| Apresentação | apresentar/exportar para Canva/Prezi/download | sem débito | **NON_BILLABLE** | saída/uso de artefato, não novo save canônico |
| PDI | gerar adaptação para visualização | comportamento de quota inconsistente | **NON_BILLABLE** | geração em memória não cobra |
| PDI | Validar/Salvar adaptação | múltiplas escritas PDI + documento | **BILLABLE** | 1 validação semântica = 1 crédito; todas as escritas derivadas compartilham o `operation_id` |
| PDI | gerar várias adaptações por uma ação em lote | pode gerar/salvar múltiplos registros | **BILLABLE por comando de lote, não por chamada técnica de IA** | um clique/command idempotente deve ter preço explícito; neste lote recomenda-se 1 crédito por comando de lote para evitar cobrança surpresa por número de alunos |
| PDI | salvar relatório pedagógico em `generated_contents` | sem débito próprio | **BILLABLE** | 1 relatório persistido = 1 operação econômica |
| PDI | exportar relatório/adaptação | sem débito | **NON_BILLABLE** | download/export não cria nova unidade econômica |
| PDI | atualizar feedback/avaliação dentro de registro já validado | update de `pdi_records` | **NON_BILLABLE enquanto edição do mesmo artefato** | evita transformar correções/ajustes do mesmo registro em múltiplas cobranças; novo artefato explícito seria nova operação |
| Meus Arquivos | renomear/editar conteúdo existente | update | **NON_BILLABLE por padrão** | edição do mesmo artefato não cria nova unidade econômica |
| Meus Arquivos | excluir | delete | **NON_BILLABLE** | exclusão nunca cobra |
| Configurações | perfil/preferências | sem consumo observado | **NON_BILLABLE obrigatório** | regra comercial explícita |
| Configurações | segurança/senha | sem consumo observado | **NON_BILLABLE obrigatório** | operação de conta |
| Escola | selecionar/trocar escola | sem consumo observado | **NON_BILLABLE** | configuração/contexto |
| Turmas | criar/editar/importar turma/alunos | sem consumo observado | **NON_BILLABLE** | dados operacionais, não artefato gerado |
| Busca/RAG/PNLD/ENEM | pesquisar/consultar | sem débito autônomo | **NON_BILLABLE** | leitura nunca cobra |
| Feedback de produto | registrar feedback | sem débito | **NON_BILLABLE** | telemetria/qualidade |
| Exportações | DOCX/PDF/impressão | sem débito autônomo | **NON_BILLABLE** | artefato derivado fora do ledger econômico de save |
| Gold | qualquer comando billable | bypass por `GOLD`/`is_unlimited` | **UNLIMITED / NO DEBIT** | registrar telemetria de uso, sem movimentação negativa de saldo |
| Admin | adicionar créditos | RPC/admin | **CREDIT GRANT** | origem `ADMIN_ADJUSTMENT`, não é operação billable do professor |
| Telefone | cadastrar telefone e receber +10 | soma em `profiles.credits` | **CREDIT GRANT** | origem `PROMOTIONAL_BONUS`; não inferir expiração neste lote |
| Indicação | indicação concluída +10 | soma em `profiles.credits` | **CREDIT GRANT** | origem `PROMOTIONAL_BONUS`; idempotência própria necessária |
| Stripe Silver | checkout concluído +40 | fulfillment transacional/idempotente Stripe | **CREDIT GRANT** | origem `PURCHASED`; nunca expira |
| FREE | criação de conta +10 | inteiro em `profiles.credits` | **CREDIT GRANT** | origem `FREE_TRIAL`; expira 7 dias após criação |

## 7. Decisões de fronteira para operações local-first/offline

O frontend possui fluxos local-first. Para não cobrar por algo que apenas parece salvo localmente, mas falhou na fonte canônica:

1. o conteúdo local deve ser preservado imediatamente;
2. o comando recebe `operation_id` antes da tentativa de sincronização;
3. a UI pode mostrar `salvamento pendente` enquanto offline;
4. o débito econômico só é confirmado quando o backend executar atomicamente a persistência canônica + consumo;
5. retry de sincronização reutiliza o mesmo `operation_id`;
6. se o backend negar por falta de saldo, o conteúdo local permanece recuperável e a UI oferece “Planos & Créditos”;
7. não deve existir compensação por subtrair crédito no cliente antes do commit canônico.

## 8. Invariantes obrigatórias para o Lote 1.3B

### INV-CR-01 — no debit before canonical save

Nenhum crédito é consumido apenas porque uma chamada de IA iniciou ou terminou.

### INV-CR-02 — one semantic command, at most one debit

Um comando billable com `operation_id = X` pode gerar zero ou um débito, nunca dois.

### INV-CR-03 — derived writes share the operation

Escritas em tabelas auxiliares, memória, PDI, histórico e cache derivadas do mesmo save não criam novos débitos.

### INV-CR-04 — replay-safe

Repetir `operation_id = X` retorna o resultado econômico já registrado.

### INV-CR-05 — no negative balance

O commit billable falha de forma controlada se não houver saldo elegível; saldo nunca fica negativo.

### INV-CR-06 — Gold no debit

Gold executa o mesmo comando de negócio, mas a decisão econômica retorna `charged = false`, motivo `GOLD_UNLIMITED`.

### INV-CR-07 — FREE expiry is lot-scoped

Expiração remove somente disponibilidade de lotes `FREE_TRIAL` vencidos. Nunca altera ou apaga lotes `PURCHASED`.

### INV-CR-08 — consume expiring promo first

Entre lotes elegíveis, consumir primeiro `FREE_TRIAL` válido com vencimento mais próximo; depois saldos não expirados conforme política determinística.

### INV-CR-09 — configuration is free

Nenhuma mutation de perfil, preferências, escola, turma, segurança ou configuração consome crédito.

### INV-CR-10 — work preservation

Falta de saldo ou falha econômica não pode apagar o conteúdo já produzido no cliente.

### INV-CR-11 — grant provenance

Todo crédito positivo registra origem, quantidade, evento de origem e política de expiração.

### INV-CR-12 — no client authority

O cliente não calcula o novo saldo autoritativo. O backend é a única fronteira de concessão/consumo.

## 9. Tipos econômicos mínimos para 1.3B

### 9.1 CreditGrantOrigin

```text
FREE_TRIAL
PURCHASED
PROMOTIONAL_BONUS
ADMIN_ADJUSTMENT
```

A taxonomia pode ser estendida sem alterar a regra de que apenas `FREE_TRIAL` possui expiração automática de 7 dias no contrato atual.

### 9.2 BillableAction

Vocabulário inicial recomendado:

```text
SAVE_GENERATED_CONTENT
SAVE_TERM_PLAN
SAVE_ASSESSMENT
SAVE_PRESENTATION
SAVE_PDI_ADAPTATION
SAVE_PDI_REPORT
SAVE_SIMULATION
```

Não usar `chat`, `generate`, `aula` ou nomes de modelo de IA como autoridade econômica.

### 9.3 EconomicDecision

Cada comando deve produzir decisão auditável, por exemplo:

```text
operation_id
user_id
action
charged
amount
reason
grant_id_consumed
balance_after
created_at
```

`reason` deve diferenciar pelo menos:

```text
CHARGED
GOLD_UNLIMITED
REPLAY
INSUFFICIENT_CREDITS
NON_BILLABLE
```

## 10. Modelo físico recomendado para o próximo lote — ainda não implementado

1. `credit_grants`
   - registra lotes positivos e sua proveniência;
   - `granted_amount`;
   - `remaining_amount` ou contabilização derivada;
   - `origin`;
   - `source_event_id` idempotente;
   - `expires_at` nullable;
   - timestamps.

2. `credit_operations`
   - ledger de comandos econômicos;
   - `operation_id` UNIQUE;
   - usuário;
   - ação;
   - quantidade;
   - decisão;
   - referência do artefato/comando;
   - timestamps.

3. relação de consumo por lote, se necessária para auditoria/fila de validade.

`profiles.credits` não deve continuar sendo a fonte contábil única. Durante migração, pode existir temporariamente como projeção/cache de compatibilidade, desde que o ledger seja a autoridade e exista estratégia de reconciliação explícita.

## 11. Estratégia de migração de saldo legado — princípio, não execução

O saldo existente não possui proveniência completa. Portanto não é seguro tentar inferir automaticamente que todo saldo atual é FREE ou PURCHASED.

Para 1.3B/1.3C, a migração deverá:

1. identificar usuários cujo histórico Stripe permite provar créditos adquiridos;
2. preservar integralmente saldos comprados comprováveis;
3. identificar grants administrativos/bonificações quando houver evidência confiável;
4. tratar saldo sem origem comprovável com política conservadora de não destruição;
5. jamais expirar saldo legado ambíguo automaticamente;
6. criar os 10 créditos FREE/7 dias apenas para contas novas após o cutover, ou migrar contas existentes somente sob regra explícita e auditável.

## 12. Gates de saída de 1.3A

1. inventário dos pontos atuais de check/débito concluído;
2. persistências principais cruzadas com a regra econômica;
3. P1 de débito duplo identificado;
4. geração separada de salvamento no contrato-alvo;
5. comandos de configuração marcados como NON_BILLABLE;
6. múltiplas escritas derivadas consolidadas em uma única unidade econômica;
7. grants de FREE/Stripe/bônus/admin separados conceitualmente;
8. invariantes de atomicidade/idempotência formalizadas;
9. nenhum código econômico alterado;
10. nenhuma produção alterada.

## 13. Próximo sublote proposto

**Lote 1.3B — desenho físico do ledger + RPC/command boundary de consumo idempotente**, ainda sem aplicação em produção.

Antes de implementar migration, 1.3B deve definir:

- schema exato;
- constraints/índices;
- seleção determinística de lote;
- fronteira atômica persistência + débito;
- estratégia de integração com artefatos que usam tabelas diferentes;
- compatibilidade temporária com `profiles.credits`;
- migração conservadora do saldo legado;
- testes de concorrência, replay, insuficiência, Gold, expiração e rollback;
- rollback técnico;
- ambiente Supabase descartável para validação.
