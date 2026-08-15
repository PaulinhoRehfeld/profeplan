# Lote 1.3C.4B — Assessment na fronteira governada de Save

Data: 15 de agosto de 2026.

Base de implementação: `e57380b1ba422220eb147ef94cf9d50f799adadb`.

## Objetivo

Conectar o Save de avaliações à fronteira econômica genérica criada em 1.3C.4A, preservando `assessment.id` como a única identidade do artefato.

Regra econômica:

- geração/preview: `NON_BILLABLE`;
- primeiro Save canônico de um novo `assessment.id`: até 1 crédito;
- retry/edição do mesmo `assessment.id`: `NON_BILLABLE`;
- Gold: persistência sem débito;
- insuficiência: nenhum Save canônico confirmado.

## Identidade

Não é criado `artifactId` paralelo.

```text
assessment.id
  -> p_artifact_id
  -> generated_contents.id
  -> identidade econômica do receipt
```

A identidade nasce na criação da avaliação e é preservada durante Save, retry e edição.

## Flag de transição

`VITE_GOVERNED_CREDIT_CONSUMERS` permanece OFF por padrão e não é alterada por este sublote.

### OFF

O comportamento legado é preservado:

- Assessment é salvo primeiro no `localStorage`;
- `generated_contents` é escrito diretamente em background;
- geração continua usando `checkUsageQuota()` e `incrementUserUsage()`.

### ON

- geração de Assessment deixa de executar check/débito legado e passa a ser NON_BILLABLE;
- Save usa exclusivamente `credit_save_generated_content(...)`;
- o navegador envia identidade e payload pedagógico, nunca `action_key` nem valor econômico;
- `generated_contents` é a persistência canônica;
- falha do RPC não faz fallback silencioso para write direto;
- `localStorage`, `lessons` e PDI são auxiliares e não podem redefinir o resultado econômico.

## Atomicidade auxiliar

Após `credit_save_generated_content` retornar `saved=true`, o evento econômico e `generated_contents` já são autoritativos.

Falhas posteriores em:

- `lessons`;
- log automático de PDI;
- atualização do cache local;

são tratadas como best-effort. Elas não transformam um Save canônico commitado em falha econômica e não autorizam uma segunda cobrança.

## Provas

A suíte frontend de 4B cobre:

- flag OFF mantém o caminho legado;
- flag ON usa `assessment.id` como `p_artifact_id`;
- retry/edição preservam a identidade;
- insuficiência não confirma Save local nem dispara memória auxiliar;
- erro de RPC não cai para `generated_contents.insert`;
- Gold/`NO_CHARGE` é aceito como Save canônico;
- falha de memória auxiliar não invalida Save canônico;
- geração é NON_BILLABLE com a flag ON e mantém compatibilidade com a flag OFF.

A prova econômica de banco não é duplicada: o workflow 1.3C.4A já cobre a fronteira genérica em Supabase descartável, incluindo primeiro Save, edição, insuficiência, Gold, rollback e concorrência. Os novos testes `*creditConsumer*` fazem esse workflow ser reexecutado no PR de 4B.

## Não escopo

1.3C.4B não autoriza nem realiza:

- migration hospedada;
- alteração de saldo ou grant real;
- ativação de `VITE_GOVERNED_CREDIT_CONSUMERS`;
- alteração Vercel;
- alteração de Edge Function hospedada;
- Stripe;
- Presentation (4C);
- PDI (4D);
- enforcement/cutover final (4E).

Produção permanece bloqueada.
