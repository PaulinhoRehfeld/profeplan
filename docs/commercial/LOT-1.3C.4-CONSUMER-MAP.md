# Lote 1.3C.4 — Mapa de convergência dos consumidores de créditos

Data: 15 de agosto de 2026.

Base canônica da inspeção original: `3ded0a583a7b02361f04adcc39faf6515602c888`.

Estado canônico reconciliado após 4D: `f1629934941b682051bb55910da5e40cca21ba04`.

## 1. Objetivo

1.3C.4 elimina `profiles.credits` e `incrementUserUsage()` como autoridade de débito dos fluxos ativos, preservando a regra econômica definida em 1.3A:

> geração, preview, regeneração e chat não persistido são NON_BILLABLE; o evento billable é o primeiro Save canônico que cria/confirma um artefato durável.

Edição/retry do mesmo artefato não gera nova cobrança.

## 2. Mapa encontrado

### NON_BILLABLE

A inspeção original encontrou serviços que ainda executavam check/débito legado durante geração, embora 1.3A os classifique como NON_BILLABLE:

- `AiChatService` — chat geral;
- `AiPlanningService` — geração/chat de planejamento;
- `AiAssessmentService` — geração de avaliação;
- `AiPresentationService` — geração de apresentação;
- `AiPdiService` — geração/preview de adaptações e relatórios.

Todos passavam pelo par legado:

```text
checkUsageQuota()
incrementUserUsage()
```

Por isso, 1.3C.4 usa uma única flag de transição:

```text
VITE_GOVERNED_CREDIT_CONSUMERS=true
```

Quando OFF, a compatibilidade antiga permanece.

Quando ON, `checkUsageQuota()` deixa de bloquear geração por `profiles.credits` e `incrementUserUsage()` deixa de executar read-modify-write no inteiro legado. A flag **não pode ser ativada antes de 1.3C.4E**, quando a varredura final provar que todos os consumidores ativos estão reconciliados.

## 3. Saves BILLABLE e persistência canônica

### Planejamento/documentos — 4A integrado

`PlanningService.savePlan()` persiste em `generated_contents`.

O objeto `GeneratedPlan` já possuía `id` local, mas o fluxo antigo descartava esse ID na nuvem e deixava o banco gerar outro.

1.3C.4A tornou `GeneratedPlan.id` a identidade canônica do Save governado por `credit_save_generated_content(...)`.

### Avaliação — 4B integrado

`AssessmentService.saveAssessment()` usa `assessment.id` como identidade canônica no RPC governado.

`generated_contents` é a persistência econômica canônica e `lessons` permanece memória auxiliar/best-effort depois do Save confirmado.

### Apresentação — 4C integrado

Presentation passou a criar `artifactId` estável depois da geração válida e antes do primeiro Save.

Esse ID é reutilizado em retry/edição e se torna `p_artifact_id`/`generated_contents.id` no caminho governado. A memória auxiliar em `lessons` permanece pós-commit e best-effort.

### PDI — 4D integrado

PDI usa fronteiras especializadas porque uma única validação semântica pode envolver atomicamente:

```text
pdi_records
pdi_documents.block_9_content
generated_contents
```

1.3C.4D integrou:

- `credit_validate_pdi_adaptation(...)`;
- `credit_save_pdi_generated_report(...)`;
- `credit_save_pdi_final_report(...)`.

A adaptação usa UUID local estável como identidade econômica; o relatório pedagógico mantém identidade estável em retry; e o relatório final deriva server-side `pdi-final-report-v1:<pdi_document_id>`.

## 4. Finding de schema — `generated_contents`

A introspecção hospedada read-only confirmou as colunas reais:

```text
id text primary key
user_id uuid
type text
folder text
title text
content text
created_at timestamptz
```

Não existe coluna `category`, embora alguns caminhos de aplicação ainda tentem enviá-la.

Também não existe chave semântica única além de `id`.

Conclusão:

> o `artifact_id` precisa ser estável no cliente/estado e tornar-se o próprio `generated_contents.id`; título ou conteúdo não podem substituir identidade.

Snapshot agregado auditado na inspeção original:

```text
plano / PLANOS DE AULA = 26
avaliacao / AVALIAÇÕES = 2
adaptacao_pdi = 4
```

Nenhum dado pessoal foi materializado na auditoria.

## 5. Estado de implementação

### 1.3C.4A — generated content + Planning — INTEGRADO

- fronteira genérica `credit_save_generated_content(...)`;
- primeiro Save = até 1 crédito;
- retry/edição do mesmo artifact id = 0;
- insuficiência = nenhum artefato;
- Gold = NO_CHARGE;
- `PlanningService.savePlan()` migrado;
- geração/chat tornam-se non-billable sob a flag governada.

### 1.3C.4B — Assessment — INTEGRADO

- `assessment.id` é a identidade canônica;
- Save usa o RPC genérico;
- `lessons` permanece memória auxiliar;
- primeiro Save versus edição/retry foi provado.

### 1.3C.4C — Presentation — INTEGRADO

- `artifactId` estável criado antes do primeiro Save;
- “Salvar na Memória” conectado ao RPC genérico;
- memória auxiliar preservada após commit econômico.

### 1.3C.4D — PDI — INTEGRADO

- RPCs especializados integrados;
- adaptação e persistências correlatas são governadas atomicamente;
- Saves dos relatórios PDI são governados;
- idempotência, insuficiência, Gold, ownership, rollback e concorrência foram provados em Supabase descartável;
- PR #85 integrado no squash `f1629934941b682051bb55910da5e40cca21ba04`;
- CI pós-merge #533 — SUCCESS.

### 1.3C.4E — varredura final — BLOQUEADO / NÃO INICIADO

4E deve começar por inspeção própria e provar:

- nenhum consumidor ativo usa `profiles.credits` como autoridade de débito;
- `incrementUserUsage()` não produz débito com a flag governada;
- todas as fronteiras de Save estão reconciliadas;
- a migration necessária para o caminho governado está completamente inventariada;
- a estratégia de ativação/cutover é reversível, observável e segura;
- somente então pode ser avaliado o handoff para 1.3C.5 enforcement/rehearsal integral.

Este mapa não autoriza o início automático de 4E nem qualquer alteração hospedada.

## 6. Regra de ativação

`VITE_GOVERNED_CREDIT_CONSUMERS` permanece OFF durante 4A–4D e continua OFF após a integração técnica de 4D.

A integração de código não equivale a cutover: as migrations e fronteiras podem estar versionadas na `main` sem terem sido aplicadas ou ativadas em produção.

A ativação somente pode ser considerada depois do gate 4E e de autorização material específica para ações hospedadas.

## 7. Não escopo

Este mapa não autoriza:

- migration hospedada;
- alteração de saldo real;
- criação de grant real;
- ativação de flag;
- mudança de Vercel;
- alteração de Edge Function hospedada;
- Stripe;
- revogação de write direto;
- cutover de produção.

Produção permanece bloqueada.
