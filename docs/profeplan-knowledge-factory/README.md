# ProfePlan Knowledge Factory

## Propósito

O ProfePlan Knowledge Factory é o projeto arquitetural responsável por transformar fontes curriculares, pedagógicas e bibliográficas em componentes de conhecimento estruturados, rastreáveis e recuperáveis por agentes especializados.

O sistema mantém matérias-primas pedagógicas semielaboradas, previamente processadas, classificadas e, quando adequado, vetorizadas. Agentes especializados combinarão esses componentes para gerar produtos autorais, personalizados e alinhados ao contexto do professor.

## Escopo educacional

- Ensino Fundamental II: 6º, 7º, 8º e 9º anos;
- Ensino Médio: 1º, 2º e 3º anos;
- currículo inicial: Minas Gerais;
- Rio Grande do Sul: bloqueado até a validação do piloto;
- agente piloto: Sócrates 2, Filosofia do 2º ano do Ensino Médio.

## Princípio central

> Padronizar o processo de produção, sem padronizar excessivamente o produto final.

Filtros pedagógicos, curriculares, jurídicos e de status deverão ser aplicados antes da busca por similaridade.

## Origem desta sincronização

- repositório: `PaulinhoRehfeld/profeplan_v5`;
- branch: `docs/profeplan-knowledge-factory`;
- commit aprovado: `cb36d71b1533fe7fa022c1aedca2c8790ab69692`;
- Marcos aprovados: 001, 002 e 003.

Consulte [SYNC-MANIFEST.md](SYNC-MANIFEST.md) para procedência, inventário e limites do snapshot.

## Documentos operacionais do Lote 0

### Governança

- [Decision Log](00-governance/DECISION-LOG.md)
- [Governança de execução proporcional ao risco](00-governance/RISK-PROPORTIONAL-EXECUTION-GOVERNANCE.md)
- [Checkpoint do Marco 003](00-governance/CONTINUITY-CHECKPOINT-003.md)
- [Checkpoint do Marco 004 — Lote 0](00-governance/CONTINUITY-CHECKPOINT-004.md)

### Entrega técnica

- [Baseline técnico](12-delivery/LOT-0-BASELINE-REPORT.md)
- [Falhas preexistentes](12-delivery/PREEXISTING-FAILURES.md)
- [Mapa de módulos de destino](12-delivery/MODULE-DESTINATION-MAP.md)
- [Diferenças entre arquitetura e código](12-delivery/ARCHITECTURE-CODE-GAP-REPORT.md)
- [Escopo autorizado do primeiro PR de código](12-delivery/FIRST-CODE-PR.md)
- [Tarefa autorizada para o Codex](12-delivery/FIRST-PR-CODEX-TASK.md)

### Fase C — Matéria-prima

- [Mapa integral da Fase C](12-delivery/PHASE-C-EXECUTION-MAP.md)
- [Plano de cartografia, extração integral e grafo de conhecimento](12-delivery/PHASE-C-KNOWLEDGE-CARTOGRAPHY-ACTION-PLAN.md)
- [Checkpoint 033 — abertura documental da Fase C](00-governance/CONTINUITY-CHECKPOINT-033.md)
- [Definição do Lote C.1 — lifecycle de fontes](12-delivery/LOT-C1-SOURCE-LIFECYCLE-GOVERNANCE-DEFINITION.md)
- [Checkpoint 034 — C.0 integrado e C.1 definido](00-governance/CONTINUITY-CHECKPOINT-034.md)
- [Checkpoint 035 — C.1.1 implementado, antes do PR](00-governance/CONTINUITY-CHECKPOINT-035.md)
- [Checkpoint 036 — C.1.2 implementado em branch, antes do PR](00-governance/CONTINUITY-CHECKPOINT-036.md)
- [Checkpoint 037 — C.1.2 revisado e CI verde, aguardando integração](00-governance/CONTINUITY-CHECKPOINT-037.md)
- [Checkpoint 038 — C.1.2 integrado; C.1.3 permanece bloqueado](00-governance/CONTINUITY-CHECKPOINT-038.md)
- [ADR-060 — fronteira atômica C.1.3](00-governance/ADR-060-C1-3-ATOMIC-BOUNDARY.md)
- [Fronteira transacional C.1.3](09-data/LOT-C1-3-SOURCE-LIFECYCLE-TRANSACTION-BOUNDARY.md)
- [Matriz de competência e EXECUTE C.1.3](10-legal-security/LOT-C1-3-EXECUTE-COMPETENCE-MATRIX.md)
- [Definição da fronteira atômica C.1.3](12-delivery/LOT-C1-3-SOURCE-LIFECYCLE-ATOMIC-BOUNDARY-DEFINITION.md)
- [Checkpoint 039 — C.1.3 rematerializado sobre a genealogia recuperada](00-governance/CONTINUITY-CHECKPOINT-039.md)
- [Checkpoint 040 — C.1.3 integrado e revalidado](00-governance/CONTINUITY-CHECKPOINT-040.md)
- [Checkpoint 041 — C.1.4 integrado e revalidado](00-governance/CONTINUITY-CHECKPOINT-041.md)
- [Matriz de evidências C.1.5 — testes do lifecycle de fontes](12-delivery/LOT-C1-5-SOURCE-LIFECYCLE-TEST-EVIDENCE-MATRIX.md)
- [Checkpoint 042 — C.1.5 integrado e revalidado](00-governance/CONTINUITY-CHECKPOINT-042.md)
- [Matriz de fechamento C.1.6 e decisão sobre GAP-3B-04](12-delivery/LOT-C1-6-SOURCE-LIFECYCLE-CLOSURE-MATRIX.md)
- [ADR-061 — encerramento de C.1 e GAP-3B-04](00-governance/ADR-061-C1-CLOSURE-GAP-3B-04.md)
- [Checkpoint 043 — Lote C.1 e GAP-3B-04 encerrados](00-governance/CONTINUITY-CHECKPOINT-043.md)
- [Definição do Lote C.2 — ingestão controlada](12-delivery/LOT-C2-CONTROLLED-INGESTION-DEFINITION.md)
- [ADR-062 — fronteira C.2 entre ingestão, extração e segmentação](00-governance/ADR-062-C2-CONTROLLED-INGESTION-BOUNDARY.md)
- [Checkpoint 044 — definição de C.2 integrada; C.2.1 bloqueado](00-governance/CONTINUITY-CHECKPOINT-044.md)
- [Definição C.2.1 — contratos, receipts e state machine](12-delivery/LOT-C2-1-INGESTION-CONTRACTS-AND-STATE-MACHINE.md)
- [Checkpoint 045 — C.2.1 integrado; C.2.2 bloqueado](00-governance/CONTINUITY-CHECKPOINT-045.md)
- [Definição C.2.2 — intake/staging seguro, limites e retenção](12-delivery/LOT-C2-2-SECURE-STAGING-LIMITS-AND-RETENTION.md)
- [Checkpoint 046 — C.2.2 integrado; C.2.3 bloqueado](00-governance/CONTINUITY-CHECKPOINT-046.md)
- [Definição C.2.3 — integridade, checksum, duplicidade e vínculo](12-delivery/LOT-C2-3-INTEGRITY-CHECKSUM-DUPLICITY-AND-LINKAGE.md)
- [Checkpoint 047 — C.2.3 integrado; C.2.4 bloqueado](00-governance/CONTINUITY-CHECKPOINT-047.md)
- [Definição C.2.4 — idempotência, retomada e falha segura](12-delivery/LOT-C2-4-IDEMPOTENCY-RECOVERY-AND-FAIL-SAFE.md)
- [Checkpoint 048 — C.2.4 integrado; C.2.5 bloqueado](00-governance/CONTINUITY-CHECKPOINT-048.md)
- [Definição C.2.5 — revisão humana e handoff governado para C.3](12-delivery/LOT-C2-5-HUMAN-REVIEW-AND-C3-HANDOFF.md)
- [Checkpoint 049 — C.2.5 integrado; C.2.6 bloqueado](00-governance/CONTINUITY-CHECKPOINT-049.md)
- [Prova integrada e fechamento C.2.6](12-delivery/LOT-C2-6-INTEGRATED-PROOF-AND-CLOSURE.md)
- [Checkpoint 050 — Lote C.2 encerrado; C.3 bloqueado](00-governance/CONTINUITY-CHECKPOINT-050.md)
- [Definição do Lote C.3 — extração e validação](12-delivery/LOT-C3-EXTRACTION-AND-VALIDATION-DEFINITION.md)
- [ADR-063 — fronteira entre ingestão, extração e segmentação](00-governance/ADR-063-C3-EXTRACTION-VALIDATION-BOUNDARY.md)
- [Reconciliação vertical da Fase C](12-delivery/PHASE-C-VERTICAL-CARTOGRAPHY-RECONCILIATION.md)
- [Primeira prova vertical — Introdução](12-delivery/INTRODUCTION-VERTICAL-RECONSTRUCTION-PROOF.md)
- [Segunda prova vertical — Unidade 1](12-delivery/SECOND-PART-VERTICAL-RECONSTRUCTION-PROOF.md)
- [Checkpoint 051 — duas provas verticais integradas](00-governance/CONTINUITY-CHECKPOINT-051.md)
- [Fronteira jurídica e operacional do piloto real (pré-autorização)](12-delivery/REAL-PILOT-AUTHORIZATION-BOUNDARY-DEFINITION.md)
- [Roadmap de execução do piloto real (acompanhamento contínuo)](12-delivery/REAL-PILOT-EXECUTION-ROADMAP.md)

## Estado atual

O [Blueprint de Execução](BLUEPRINT.md) permanece a referência macro de sequência, dependências e
gates. Para o estado operacional corrente da cartografia e reconstrução vertical, prevalece o
[Checkpoint 051](00-governance/CONTINUITY-CHECKPOINT-051.md) sobre marcadores históricos. A
[Governança de execução proporcional ao risco](00-governance/RISK-PROPORTIONAL-EXECUTION-GOVERNANCE.md)
continua definindo os limites de autorização.

- Fase A — concluída;
- Fase B — concluída por bloqueio parcial controlado no [Checkpoint 032](00-governance/CONTINUITY-CHECKPOINT-032.md);
- Lotes 3B.1 a 3B.5 — concluídos;
- GAP-3B-01, GAP-3B-02, GAP-3B-03, GAP-3B-04 e GAP-3B-06 — encerrados;
- GAP-3B-05 e GAP-3B-07 — ativos e contidos;
- Fase C — C.0 integrado pelo PR nº 31;
- Lote C.1 — **concluído**;
- C.1.1 — contratos normativos integrados;
- C.1.2 — persistência incremental, RLS, grants, rollback e testes integrados;
- C.1.3 — fronteira transacional atômica, competência, idempotência, CAS, concorrência e impacto conservador integrados;
- C.1.4 — ports e adapters provider-neutral, leitura histórica, erros/receipts e CI integrados;
- C.1.5 — prova integrada de contrato, segurança, concorrência, rollback e lifecycle E2E integrada;
- C.1.6 — auditoria de fechamento integrada pelo PR nº 57 no commit `3ae0f5554eed5e7bd7f208647e068a304127058d`;
- GAP-3B-04 — **encerrado** após comprovação de que o lifecycle necessário à ingestão está definido, persistido, protegido, adaptado, testado e integrado;
- Lote C.2 — **concluído**;
- C.2.1 — **integrado e revalidado** pelo PR nº 62 no commit `e0ba47bf063b324df141c370ebf371763fbf2364`;
- C.2.2 — **integrado e revalidado** pelo PR nº 67 no commit `7557bc3aa80ce5ebd6423b10a179fa3790b97cb6`, com CI pós-merge nº 412 verde;
- C.2.3 — **integrado e revalidado** pelo PR nº 70 no commit `f70312a9936b99e1c131627277ad4c4a65b126a5`, com CI pós-merge nº 430 verde;
- C.2.4 — **integrado e revalidado** pelo PR nº 74 no commit `14b7ff30d1b659ed8b2c824f9a943b05cdca93bc`, com CI pós-merge nº 523 verde;
- C.2.5 — **integrado e revalidado** pelo PR nº 84 no commit `01a985a94272608007a57fd60695fed719c625d2`, com CI pós-merge nº 547 verde;
- C.2.6 — **integrado e revalidado** pelo PR nº 93 no commit `3b8c2d317542bd701ea61e671f9b6e4334f61b1c`, tree `0fbe3377d3dac6aa9730a6e895d20a0762fc855c`, com CI pós-merge nº 562 verde;
- C.3.1–C.3.5 — integrados;
- reconhecimento estrutural, golden sample e cartografia preliminar — integrados pelos PRs nº 112–113;
- primeira prova vertical da Introdução — integrada pelo PR nº 114;
- segunda prova vertical da Unidade 1 — integrada pelo PR nº 116;
- C.3.6 / PR nº 110 — aberto, não integrado e suspenso;
- C.4-local candidata — generalização mínima comprovada; C.4 integral e C.4–C.7 permanecem bloqueados;
- fronteira do piloto real definida documentalmente; aguardando dados da obra/parte e autorização Nível B;
- conteúdo real/PDF/livro/PNLD — somente por autorização Nível B juridicamente delimitada;
- produção, credenciais e dados pessoais/sensíveis — somente por autorização Nível C específica.

C.2.1 definiu a linguagem operacional da ingestão controlada: identidades compostas sobre C.1, state machine determinística, comandos tipados, idempotência contratual, receipts provider-neutral e revisão humana obrigatória antes de `APPROVED_FOR_EXTRACTION`.

C.2.2 acrescentou a fronteira física mínima de staging temporário sem alterar a state machine do `processing_run`: porta provider-neutral, policy centralizada de limites e retenção, lifecycle físico do artefato, adapter Supabase isolado, locator opaco, `upsert: false`, descarte verificável e CI específico com Supabase Storage inteiramente descartável. Nenhum arquivo real entrou no sistema; nenhum byte foi persistido em Postgres; nenhum Storage hospedado foi criado.

C.2.3 acrescentou integridade criptográfica sobre readback dos bytes efetivamente armazenados, usando SHA-256 em hexadecimal minúsculo, evidência provider-neutral, classificação explícita de duplicidade binária sem colapso de identidades e materialização técnica de `VERIFIED`. O gate `evaluateIngestionVerificationConfirmation` vincula o `confirm_verified` de C.2.1 à evidência física aprovada sem redefinir a state machine.

C.2.4 acrescentou persistência durável do lifecycle operacional, receipts/events, idempotência por `commandId + fingerprint` recalculado server-side, CAS por state/version/sequence, recovery PostgreSQL ↔ Storage sem pseudo-transação distribuída, write-intent separado da evidence C.2.3, confirmação atômica de `VERIFIED`, cleanup em duas fases e least privilege por RPCs estreitas. A prova integrada permaneceu inteiramente sintética e descartável.

C.2.5 acrescentou a fronteira de revisão humana e handoff governado: competência `legal_editorial_reviewer` sob autoridade C.1, autorização `extraction` independente e historicamente válida no instante da decisão, persistência atômica de run + receipt + event, snapshot read-only provider-neutral e concorrência approve/reject fail-closed. O handoff registra elegibilidade para C.3, mas não executa extração nem inicia C.3.

C.2.6 consolidou C.2.1–C.2.5 em uma única prova E2E sintética e descartável. O caminho positivo concluiu em `APPROVED_FOR_EXTRACTION` + handoff read-only; o caminho fail-safe concluiu em `CANCELLED + DISCARDED`; as postconditions comprovaram ausência de bytes permanentes e ausência de superfície executora C.3. O E2E também revelou uma divergência preexistente entre `localeCompare('en')` e a canonicalização PostgreSQL `COLLATE "C"`; o JavaScript foi corrigido para ordenação bytewise UTF-8, preservando `INGESTION_CONTRACT_VERSION = 1.0.0`.

No merge do PR nº 93, o PR nº 92 da frente comercial avançou a `main` entre a última leitura pré-merge e o squash. O commit de C.2.6 tornou-se filho de `57d7e387676224ef6fb5e3101270c0b6e4f8c245`. A comparação pós-merge confirmou exatamente os sete arquivos de C.2.6, e o CI Pipeline nº 562 validou a árvore composta final. O Checkpoint 050 registra explicitamente essa janela TOCTOU e suas implicações de governança.

A menção histórica a `SourceSegment` em `GAP-3B-04` não antecipa segmentação no Lote C.1. A decomposição canônica preserva C.2 para ingestão, C.3 para extração e C.4 para segmentação/classificação.

As duas provas verticais demonstraram que a reconstrução local generaliza da Introdução para uma
Unidade/Capítulo sem processar o livro inteiro e sem criar ontologia antecipada. O próximo avanço
material não é uma terceira prova sintética automática: é preparar, em fronteira Nível B própria,
um piloto sobre uma única parte real juridicamente autorizada, com ambiente temporário, retenção,
descarte e revisão humana definidos. Produção, secrets e dados pessoais/sensíveis permanecem Nível C.
