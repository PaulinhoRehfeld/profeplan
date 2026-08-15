# Lote 1.3C.4C — Presentation: Save governado

Data: 15 de agosto de 2026.

Base canônica: `56e125bf72aabb885b0c0bc8b27f64d76ce98106`.

## Objetivo

Migrar o botão **Salvar na Memória** de Presentation para a fronteira econômica genérica criada em 1.3C.4A, sem alterar produção e sem iniciar PDI ou enforcement final.

## Identidade canônica

Presentation não possuía identidade estável antes do primeiro Save. Em 4C, `generatePresentationJSON()` cria um `artifactId` local somente depois de uma geração válida.

Esse ID:

- não vem do modelo de IA;
- nasce antes do primeiro Save;
- permanece no mesmo objeto em estado enquanto a apresentação atual existir;
- é reutilizado em retry e edição do mesmo resultado;
- muda somente quando uma nova apresentação é gerada;
- torna-se `p_artifact_id` e, no caminho governado, `generated_contents.id`.

Fluxo:

```text
geração válida
  -> artifactId local estável
  -> preview/edição
  -> primeiro Save
  -> credit_save_generated_content(...)
  -> generated_contents.id = artifactId
```

## Economia

A geração de Presentation continua com o comportamento legado enquanto:

```text
VITE_GOVERNED_CREDIT_CONSUMERS=false
```

Com a flag `true`:

- geração/preview é NON_BILLABLE;
- `checkUsageQuota()` e `incrementUserUsage()` deixam de participar da geração;
- primeiro Save de `artifactId` novo usa o RPC genérico;
- `type='apresentacao'` deriva `SAVE_PRESENTATION` server-side;
- retry/edição do mesmo `artifactId` é NON_BILLABLE pela fronteira de 4A;
- Gold pode persistir com `NO_CHARGE`;
- insuficiência não confirma Save;
- falha do RPC não cai para insert direto legado.

O navegador não fornece `action_key` nem valor econômico.

## Persistência

`generated_contents` é a persistência econômica canônica no caminho governado.

`lessons` permanece memória contextual auxiliar. Ela só é tentada depois de o RPC confirmar o Save canônico. Falha em `lessons` não desfaz o Save, não altera o receipt econômico e não autoriza nova cobrança.

Com a flag OFF, a sequência histórica é preservada:

```text
lessons -> saveGeneratedContent() legado
```

## SQL

Nenhuma migration nova é necessária em 4C.

A fronteira 4A já contém:

```text
apresentacao -> SAVE_PRESENTATION
```

As provas de banco de 4A devem ser reutilizadas em Supabase descartável.

## Provas mínimas

- flag OFF preserva geração e Save legados;
- flag ON torna geração NON_BILLABLE;
- geração válida cria `artifactId` local;
- nova geração cria nova identidade;
- flag ON envia `artifactId` como `p_artifact_id`;
- primeiro Save é governado;
- retry/edição reutilizam identidade;
- insuficiência não grava memória auxiliar;
- falha do RPC não faz fallback legado;
- Gold persiste sem write alternativo;
- falha da memória auxiliar não invalida Save já commitado;
- CI geral e prova econômica 4A permanecem verdes.

## Não escopo

4C não autoriza:

- ativação de `VITE_GOVERNED_CREDIT_CONSUMERS` em produção;
- migration hospedada;
- saldo ou grant real;
- Vercel;
- Edge Function hospedada;
- Stripe;
- 4D PDI;
- 4E varredura/cutover;
- revogação de writes diretos.

Produção permanece bloqueada.
