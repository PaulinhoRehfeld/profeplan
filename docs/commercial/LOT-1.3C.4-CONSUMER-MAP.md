# Lote 1.3C.4 — Mapa de convergência dos consumidores de créditos

Data: 14 de agosto de 2026.

Base canônica da inspeção: `3ded0a583a7b02361f04adcc39faf6515602c888`.

## 1. Objetivo

1.3C.4 elimina `profiles.credits` e `incrementUserUsage()` como autoridade de débito dos fluxos ativos, preservando a regra econômica definida em 1.3A:

> geração, preview, regeneração e chat não persistido são NON_BILLABLE; o evento billable é o primeiro Save canônico que cria/confirma um artefato durável.

Edição/retry do mesmo artefato não gera nova cobrança.

## 2. Mapa encontrado

### NON_BILLABLE

Os serviços abaixo ainda executavam check/debito legado durante geração, embora 1.3A os classifique como NON_BILLABLE:

- `AiChatService` — chat geral;
- `AiPlanningService` — geração/chat de planejamento;
- `AiAssessmentService` — geração de avaliação;
- `AiPresentationService` — geração de apresentação;
- `AiPdiService` — geração/preview de adaptações e relatórios.

Todos passam pelo par legado:

```text
checkUsageQuota()
incrementUserUsage()
```

Por isso, 1.3C.4 usa uma única flag de transição:

```text
VITE_GOVERNED_CREDIT_CONSUMERS=true
```

Quando OFF, a compatibilidade antiga permanece.

Quando ON, `checkUsageQuota()` deixa de bloquear geração por `profiles.credits` e `incrementUserUsage()` deixa de executar read-modify-write no inteiro legado. A flag **não pode ser ativada antes de 1.3C.4E**, quando todos os Saves billable estiverem migrados.

## 3. Saves BILLABLE e persistência canônica

### Planejamento/documentos

`PlanningService.savePlan()` persiste em `generated_contents`.

O objeto `GeneratedPlan` já possui `id` local, mas o fluxo antigo descartava esse ID na nuvem e deixava o banco gerar outro.

1.3C.4A transforma o `GeneratedPlan.id` em identidade canônica do Save governado.

### Avaliação

`AssessmentService.saveAssessment()` já possui `assessment.id` estável e persiste `generated_contents` + memória auxiliar em `lessons`.

Será conectado à mesma fronteira genérica em 1.3C.4B.

### Apresentação

`PresentationCreator` persiste `generated_contents` e `lessons`, mas não possui hoje uma identidade de artefato estável antes do primeiro Save.

1.3C.4C deverá introduzir `artifactId` persistente no estado da tela antes de ligar o Save ao RPC governado.

### PDI

PDI não cabe na fronteira genérica sem perder semântica.

A validação pode envolver:

```text
pdi_records
pdi_documents.block_9_content
generated_contents
```

O relatório PDI também possui persistência própria.

1.3C.4D terá fronteiras especializadas para garantir atomicidade do evento pedagógico completo, não apenas de uma linha em `generated_contents`.

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

Snapshot agregado auditado:

```text
plano / PLANOS DE AULA = 26
avaliacao / AVALIAÇÕES = 2
adaptacao_pdi = 4
```

Nenhum dado pessoal foi materializado na auditoria.

## 5. Divisão de implementação

### 1.3C.4A — generated content + Planning

- criar fronteira genérica `credit_save_generated_content(...)`;
- primeiro Save = até 1 crédito;
- retry/edição do mesmo artifact id = 0;
- insuficiência = nenhum artefato;
- Gold = NO_CHARGE;
- migrar `PlanningService.savePlan()`;
- tornar geração/chat non-billable por compatibilidade central sob flag.

### 1.3C.4B — Assessment

- usar `assessment.id` como identidade canônica;
- conectar Save ao RPC genérico;
- preservar `lessons` como memória auxiliar;
- provar primeiro Save versus edição/retry.

### 1.3C.4C — Presentation

- introduzir `artifactId` estável antes do primeiro Save;
- conectar “Salvar na Memória” ao RPC genérico;
- preservar memória auxiliar.

### 1.3C.4D — PDI

- criar RPCs especializados;
- validar adaptação + persistências correlatas de modo governado;
- governar Save do relatório PDI;
- provar que edição do mesmo artefato não cobra novamente.

### 1.3C.4E — varredura final

- provar que nenhum consumidor ativo usa `profiles.credits` como autoridade;
- provar que `incrementUserUsage()` não produz débito com a flag governada;
- reconciliar todas as fronteiras de Save;
- somente então considerar 1.3C.5 enforcement/rehearsal integral.

## 6. Regra de ativação

`VITE_GOVERNED_CREDIT_CONSUMERS` permanece OFF durante 4A–4D.

Ativação antecipada seria incorreta: geração ficaria non-billable antes de todos os respectivos Saves possuírem uma fronteira econômica governada.

Portanto o código pode ser integrado incrementalmente, mas a mudança comportamental só ocorre no gate final coordenado.

## 7. Não escopo

Este mapa não autoriza:

- migration hospedada;
- alteração de saldo real;
- ativação de flag;
- revogação de write direto;
- cutover.
