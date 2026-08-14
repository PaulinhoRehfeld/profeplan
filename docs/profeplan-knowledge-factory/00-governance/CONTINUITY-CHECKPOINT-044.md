# CONTINUITY CHECKPOINT 044 — definição de C.2 integrada; C.2.1 permanece bloqueado

Data: 14 de agosto de 2026.

## Estado canônico

- repositório: `PaulinhoRehfeld/profeplan`;
- branch canônica: `main`;
- commit canônico da definição documental de C.2: `787432fa8e7f5d891899c94b1089803430a4734a`;
- tree: `fc4d517def95ce23e5ddb73d935e1628710142d7`;
- parent direto: `cb74fa511c774baa7c96526827fd2fab51f4b2ff`;
- PR nº 59: integrado por squash merge em 14 de agosto de 2026;
- título canônico: `docs(knowledge-factory): define C.2 controlled ingestion (#59)`;
- HEAD do PR validado antes do merge: `e27bff7b2b653e5acfd28b838f2533ecc29c7280`;
- CI do PR: CI Pipeline nº 365 — `success`;
- CI pós-merge da `main`: CI Pipeline nº 366 — `success`.

O estado anterior estava formalizado pelo Checkpoint 043 na `main`
`cb74fa511c774baa7c96526827fd2fab51f4b2ff`, tree
`e8a5b9b9975a8ba57456735ab5787b412b0a3256`, parent
`3ae0f5554eed5e7bd7f208647e068a304127058d`.

## Autorização humana

Foi autorizada a revisão final e a integração do PR nº 59, a criação deste Checkpoint 044 e a
reconciliação documental pós-merge, **sem iniciar C.2.1**.

Também foi reiterado que ações ordinárias de governança sem risco de segurança permanecem
pré-autorizadas. Essa regra não elimina gates de segurança, não autoriza produção e não antecipa
sublotes cuja execução dependa de autorização específica segundo a definição canônica.

## Resultado da abertura de C.2

O Lote C.2 — Ingestão controlada possui agora definição normativa própria integrada em:

`12-delivery/LOT-C2-CONTROLLED-INGESTION-DEFINITION.md`.

A decisão arquitetônica correspondente está em:

`00-governance/ADR-062-C2-CONTROLLED-INGESTION-BOUNDARY.md`.

C.2 foi iniciado **somente no nível documental**. Nenhuma implementação técnica de C.2.1–C.2.6 foi
iniciada.

## Definition of Ready da abertura documental

A abertura documental de C.2 foi considerada Ready porque:

- C.1.1–C.1.6 estavam integrados;
- `GAP-3B-04` estava encerrado;
- a `main` final de C.1 estava verde;
- lifecycle e autorização histórica possuíam contratos provider-neutral integrados;
- `received_file`, `processing_run`, `temporary_staging` e `ingestion` já existiam no vocabulário de C.1;
- o mapa da Fase C identificava C.2 como próximo lote estrutural;
- houve autorização humana explícita para iniciar C.2.

Essas condições habilitaram a **definição documental de C.2**, e não a implementação de C.2.1.

## Decisões arquitetônicas integradas

### 1. Fronteira C.2/C.3/C.4

A decomposição canônica fica preservada:

```text
C.1 — governança da fonte e autorização
  ↓
C.2 — ingestão controlada e staging
  ↓
C.3 — extração e validação do conteúdo extraído
  ↓
C.4 — segmentação e classificação estrutural
```

C.2 não extrai texto e não produz chunks.

### 2. Reuso de C.1 sem reabertura de C.1.3

C.1 já define:

- identidade `received_file`;
- identidade `processing_run`;
- finalidade `temporary_staging`;
- finalidade `ingestion`;
- finalidade `extraction`.

Porém a fronteira transacional de C.1.3 deliberadamente não administra `processing_run`.

Decisão: C.2 consumirá os contratos e a governança de C.1, mas sua execução operacional terá
fronteira própria no sublote responsável. C.1.3 não será ampliado por conveniência.

### 3. Autorização por finalidade permanece independente

Autorização para `temporary_staging`, `ingestion` e `extraction` não é intercambiável.

Um grant para ingestão não concede automaticamente extração, geração, retrieval ou outra finalidade.

### 4. Staging não é corpus

Bytes, PDFs, páginas renderizadas, recortes, miniaturas e conteúdo bruto podem existir apenas na
área temporária de staging quando o sublote correspondente for autorizado.

Eles não integram:

- Postgres permanente;
- corpus pedagógico;
- índice vetorial;
- retrieval;
- histórico permanente de conteúdo.

O estado permanente deve conservar somente metadados necessários a identidade, integridade,
auditoria, revisão, retenção e descarte.

### 5. Minimização e descarte verificável

O staging deverá possuir prazo explícito e descarte verificável antes de qualquer fonte real.

Rastreabilidade será mantida por identidades, digest, metadados, receipts e localizadores lógicos,
não pela conservação indefinida do arquivo bruto.

### 6. Revisão humana antes de C.3

No piloto, o handoff C.2 → C.3 exige decisão humana explícita.

A aprovação de intake não constitui autorização automática para extração.

## Código legado auditado

Foi localizado `apps/web/src/services/ingestionService.ts` e outros scripts históricos de ingestão.

O serviço de frontend analisado mistura:

- leitura de arquivo;
- parsing de Markdown;
- chunking heurístico;
- contexto de currículo;
- referência direta a Supabase/`curriculos_mg`.

Ele não é implementação canônica de C.2. Qualquer reaproveitamento futuro exige auditoria explícita
de compatibilidade com a definição atual, separação de camadas, segurança e testes.

## Sublotes oficiais de C.2

A definição integrada formaliza:

- `C.2.1` — contratos, receipts e state machine;
- `C.2.2` — intake/staging seguro, limites e retenção;
- `C.2.3` — integridade, checksum, duplicidade e vínculo;
- `C.2.4` — idempotência, retomada e falha segura;
- `C.2.5` — revisão humana e handoff para C.3;
- `C.2.6` — prova integrada, fechamento e gate para C.3.

A sequência não autoriza avanço implícito entre sublotes.

## Gates do PR nº 59

Antes da integração foram confirmados:

- `main` ainda em `cb74fa511c774baa7c96526827fd2fab51f4b2ff`;
- HEAD do PR em `e27bff7b2b653e5acfd28b838f2533ecc29c7280`;
- 0 behind da `main`;
- dois arquivos alterados, ambos Markdown;
- nenhuma review thread pendente;
- CI Pipeline nº 365 — `success`;
- Prettier — verde;
- ESLint — verde;
- TypeScript — verde;
- Build — verde;
- Tests — verde;
- squash merge com expected HEAD SHA.

## Validação pós-merge

A `main` pós-merge foi verificada em:

- SHA `787432fa8e7f5d891899c94b1089803430a4734a`;
- tree `fc4d517def95ce23e5ddb73d935e1628710142d7`;
- parent `cb74fa511c774baa7c96526827fd2fab51f4b2ff`.

O CI Pipeline nº 366 executado por `push` nesse SHA concluiu com `success`, incluindo formatter,
lint, typecheck, build e testes.

## Ocorrência externa

Os checks Vercel dos projetos `profeplan` e `site` reportaram limite diário da camada gratuita de
deployments durante o PR.

A ocorrência é externa ao conteúdo de C.2 e não representa falha de formatter, lint, typecheck,
build ou testes do repositório. Nenhum gate de segurança foi removido ou relaxado por esse motivo.

## Estado operacional após este checkpoint

- C.0 — concluído;
- C.1 — concluído;
- `GAP-3B-04` — encerrado;
- **C.2 — definição documental integrada**;
- **C.2.1 — bloqueado**;
- C.2.2–C.2.6 — bloqueados;
- C.3–C.7 — bloqueados;
- `GAP-3B-05` — ativo e contido;
- `GAP-3B-07` — ativo e contido;
- conteúdo real — bloqueado;
- Supabase hospedado — bloqueado;
- produção — bloqueada.

## Definition of Ready de C.2.1

Conforme a definição integrada de C.2, o próximo sublote somente poderá iniciar após:

1. integração da definição documental — **satisfeito pelo PR nº 59**;
2. checkpoint pós-merge — **satisfeito por este Checkpoint 044 após sua integração**;
3. `main` documental verde — deverá ser confirmado após a reconciliação documental;
4. autorização humana específica para C.2.1 — **não concedida por esta continuidade**;
5. C.3–C.7 permanecerem bloqueados.

Portanto, mesmo depois da integração deste checkpoint, **C.2.1 continua bloqueado**.

## Limites preservados

Este checkpoint não inicia nem autoriza:

- C.2.1 ou qualquer implementação técnica de C.2;
- intake real;
- upload real;
- bucket hospedado;
- Supabase hospedado;
- fonte real ou PDF real;
- conteúdo PNLD;
- extração;
- OCR;
- segmentação;
- chunks;
- embeddings;
- frontend de upload;
- endpoint público;
- job ou fila operacional;
- secrets ou credenciais reais;
- migrations em produção;
- produção.

## Próximo escopo elegível

O próximo escopo técnico candidato é:

`C.2.1 — contratos, receipts e state machine`.

Ele permanece **BLOQUEADO**. Seu início exigirá nova autorização humana específica e deverá começar
por inspeção de sua Definition of Ready e dos contratos de C.1 que serão consumidos, sem antecipar
staging, storage, extração ou conteúdo real.

## Autoridade de continuidade

Após a integração da reconciliação documental pós-PR nº 59, este Checkpoint 044 passa a ser a
referência operacional corrente para a abertura de C.2.

O Checkpoint 043 permanece evidência histórica do fechamento de C.1 e não deve ser reescrito.