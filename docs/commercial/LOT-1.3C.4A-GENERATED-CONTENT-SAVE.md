# Lote 1.3C.4A — Fronteira governada de Save em `generated_contents`

Data: 14 de agosto de 2026.

Base canônica de abertura: `3ded0a583a7b02361f04adcc39faf6515602c888`.

Branch: `feat/commercial-credit-consumers-4a-generated-content`.

## 1. Objetivo

Criar a primeira fronteira reutilizável para artefatos cujo registro canônico é `generated_contents` e migrar o Save de Planning/documentos para essa fronteira, sem alterar produção.

Regra:

```text
primeiro Save canônico do artifact_id -> até 1 crédito
retry/edição do mesmo artifact_id      -> 0 crédito
Gold/unlimited                          -> NO_CHARGE
insuficiência                           -> nenhum artefato
falha de persistência                   -> rollback de receipt + DEBIT + artefato
```

## 2. RPC

```text
credit_save_generated_content(
  artifact_id,
  type,
  folder,
  title,
  content,
  created_at
)
```

A função:

- exige `auth.uid()`;
- não aceita `user_id` do navegador;
- não aceita quantidade de créditos;
- não aceita `action_key` econômico do navegador;
- deriva a ação no servidor;
- usa o `artifact_id` como `generated_contents.id`;
- valida ownership antes de editar artefato existente;
- bloqueia tipos que precisam de fronteira dedicada.

## 3. Taxonomia econômica server-side

```text
avaliacao                   -> SAVE_ASSESSMENT
apresentacao                -> SAVE_PRESENTATION
plano/aula/material/
exercicio/simulado/
documento/enem/outros       -> SAVE_DOCUMENT
```

Rejeitados pela fronteira genérica:

```text
trimestral
adaptacao_pdi
relatorio_pdi
unknown types
```

Planejamento Trimestral já possui RPC dedicado. PDI terá fronteiras especializadas em 1.3C.4D.

## 4. Lock e idempotência

Ordem:

```text
profile FOR UPDATE
  -> artifact lookup/lock
  -> decisão econômica
  -> persistência canônica
```

O lock do perfil serializa dois primeiros Saves concorrentes do mesmo usuário.

### Primeiro Save

Se o `artifact_id` ainda não existe:

1. servidor cria uma operação econômica nova;
2. chama `credit_consume_internal`;
3. se REJECTED, não insere artefato;
4. se APPLIED/NO_CHARGE, persiste `generated_contents` na mesma transação.

### Retry depois de resposta perdida

Se o primeiro Save commitou mas a resposta se perdeu, o retry reutiliza o mesmo `artifact_id`.

O RPC encontra o artefato e toma o caminho NON_BILLABLE.

### Retry depois de insuficiência

Uma insuficiência gera receipt REJECTED, mas nenhum artefato.

Se o usuário receber novo grant e tentar novamente o mesmo `artifact_id`, o servidor pode fazer uma nova decisão econômica e salvar. O artifact id não fica permanentemente preso a uma decisão rejeitada antiga.

### Edição

Artefato existente do próprio usuário é atualizado sem nova operação de consumo.

### Colisão cross-user

Artefato existente de outro usuário falha com `42501` antes do consumo. Uma corrida de chave primária depois da decisão econômica também falha dentro da mesma transação e reverte receipt/DEBIT.

## 5. PlanningService

Com flag OFF:

```text
checkUsageQuota
insert direto generated_contents
incrementUserUsage('document')
```

permanece como legado.

Com:

```text
VITE_GOVERNED_CREDIT_CONSUMERS=true
```

`savePlan()`:

- não consulta o inteiro legado para autorização;
- cria um artifact id estável;
- salva o draft local antes da nuvem;
- chama apenas `credit_save_generated_content` como autoridade canônica;
- não chama `incrementUserUsage`;
- preserva draft local `synced=false` se RPC falhar/rejeitar;
- em retry exato, procura draft idêntico não sincronizado e reutiliza o mesmo artifact id.

Isso fecha a janela:

```text
servidor COMMIT
resposta perdida
ação repetida pelo usuário
```

sem cobrar duas vezes.

## 6. Geração/chat NON_BILLABLE

1.3A já define que geração, preview e chat não persistido não são eventos econômicos.

Em vez de editar cinco serviços de IA com regras paralelas, 1.3C.4 introduz compatibilidade central em:

```text
checkUsageQuota()
incrementUserUsage()
```

Com flag OFF, comportamento legado permanece.

Com flag ON:

- `checkUsageQuota()` permite geração sem consultar `profiles.credits`;
- `incrementUserUsage()` não faz read-modify-write legado.

A flag só poderá ser ativada depois de 4B–4E, quando todos os Saves billable ativos estiverem governados.

## 7. Memória auxiliar

`generated_contents` é a persistência canônica econômica.

`lessons` e eventos PDI disparados após um Planning Save permanecem memória/automação auxiliar. Falha auxiliar não transforma um Save canônico já commitado em falha econômica.

O enforcement/reconciliação dessas escritas auxiliares não é autoridade de cobrança.

## 8. Matriz descartável SQL

A suíte 1.3C.4A prova:

- permissões do RPC;
- primeiro Save = 1 DEBIT;
- retry exato = 0 adicional;
- edição real = 0 adicional;
- segundo artefato = novo DEBIT;
- insuficiência = nenhum artefato;
- novo grant + retry do mesmo artifact após insuficiência = sucesso;
- Gold = Save + NO_CHARGE;
- cross-user collision sem consumo;
- falha forçada de persistência = rollback integral;
- tipos dedicados/desconhecidos = fail closed;
- `profiles.credits` não é alterado;
- oito primeiros Saves paralelos do mesmo artifact = uma linha, um APPLIED, um DEBIT;
- `supabase db lint --level warning`.

## 9. Testes de frontend

A suíte cobre:

- flag OFF preserva check, insert e débito legado;
- flag ON usa RPC e não usa helper legado;
- timeout + retry exato reutiliza `artifact_id`;
- insuficiência preserva draft local não sincronizado;
- camada central de quota deixa geração non-billable somente com flag ON.

## 10. Limite material

Mesmo após merge técnico:

- migration 4A não é aplicada hospedada;
- flag continua OFF;
- direct INSERT/UPDATE em `generated_contents` não é revogado ainda;
- Assessment/Presentation/PDI ainda não estão migrados;
- cutover continua bloqueado.

## 11. Próximo gate

Depois da integração técnica de 4A:

> **1.3C.4B — Assessment: conectar `assessment.id` à fronteira genérica e provar primeiro Save versus edição/retry.**

**Este lote não autoriza alteração de produção.**
