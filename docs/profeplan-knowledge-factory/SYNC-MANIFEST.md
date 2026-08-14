# Manifesto de sincronização — Marcos 001–003

## Status

Sincronização controlada iniciada e validada no Marco 004 — Lote 0.

## Origem imutável

- repositório: `PaulinhoRehfeld/profeplan_v5`;
- branch: `docs/profeplan-knowledge-factory`;
- commit aprovado: `cb36d71b1533fe7fa022c1aedca2c8790ab69692`;
- árvore raiz: `16e70b553e9b2c9b2fcf111a6f7defc51767e32a`;
- árvore documental: `383ef72c65489eaf1ef78024ebf5640efa76906e`;
- Marcos: 001, 002 e 003 aprovados integralmente.

## Destino

- repositório canônico de implementação: `PaulinhoRehfeld/profeplan`;
- branch do Lote 0: `docs/knowledge-factory-lot0`;
- diretório: `docs/profeplan-knowledge-factory/`.

## Estratégia

Objetos Git não podem ser reutilizados diretamente entre repositórios. A tentativa de anexar a árvore ou blobs do repositório de origem ao repositório canônico foi rejeitada pelo GitHub por pertencimento a repositórios diferentes.

A sincronização utiliza:

1. origem e commit imutáveis;
2. documentos operacionais materializados no monorepo;
3. registro explícito de documentos não materializados byte a byte;
4. referências canônicas à origem aprovada;
5. proibição de reinterpretar decisões durante a cópia;
6. atualização posterior somente por processo deliberado e auditável.

## Documentos materializados no Lote 0

- `README.md`;
- `00-governance/DECISION-LOG.md`;
- `00-governance/CONTINUITY-CHECKPOINT-003.md`;
- `12-delivery/FIRST-CODE-PR.md`;
- `12-delivery/LOT-0-BASELINE-REPORT.md`;
- `12-delivery/PREEXISTING-FAILURES.md`;
- `12-delivery/MODULE-DESTINATION-MAP.md`;
- `12-delivery/ARCHITECTURE-CODE-GAP-REPORT.md`;
- `12-delivery/FIRST-PR-CODEX-TASK.md`;
- `00-governance/CONTINUITY-CHECKPOINT-004.md`.

## Inventário aprovado na origem

### Governança

- `00-governance/PROJECT-CHARTER.md`;
- `00-governance/DECISION-LOG.md`;
- `00-governance/CONTINUITY-AND-FORK-POLICY.md`;
- `00-governance/CONTINUITY-CHECKPOINT-001.md`;
- `00-governance/CONTINUITY-CHECKPOINT-002.md`;
- `00-governance/CONTINUITY-CHECKPOINT-003.md`.

### Arquitetura e agentes

- `02-architecture/ARCHITECTURE-OVERVIEW.md`;
- `02-architecture/REPOSITORY-INTEGRATION-ASSESSMENT.md`;
- `02-architecture/TECHNICAL-CAPABILITY-MAP.md`;
- `02-architecture/INCREMENTAL-IMPLEMENTATION-ARCHITECTURE.md`;
- `02-architecture/TOKEN-COST-LATENCY-OBSERVABILITY.md`;
- `03-agents/profiles/socrates-2/README.md`;
- `03-agents/profiles/socrates-2/TECHNICAL-PROFILE.md`.

### Conhecimento, currículo e retrieval

- `04-knowledge/KNOWLEDGE-MODEL.md`;
- `04-knowledge/TECHNICAL-DOMAIN-CONTRACTS.md`;
- `05-curriculum/CURRICULUM-PACKAGE-STANDARD.md`;
- `05-curriculum/CURRICULUM-PACKAGE-TECHNICAL-CONTRACT.md`;
- `06-retrieval/RETRIEVAL-PIPELINE.md`;
- `06-retrieval/HYBRID-RETRIEVAL-ARCHITECTURE.md`;
- `06-retrieval/RETRIEVAL-EXPERIMENT-PLAN.md`.

### Produção, qualidade, dados e segurança

- `07-production/PEDAGOGICAL-PRODUCTION-ORDER.md`;
- `07-production/OPP-AND-DELIVERY-TECHNICAL-CONTRACT.md`;
- `08-quality/VALIDATION-TECHNICAL-CONTRACTS.md`;
- `09-data/LOGICAL-DATA-MODEL.md`;
- `10-legal-security/SECURITY-RLS-AUDIT-MODEL.md`.

### Testes e entrega

- `11-testing/MVP-ACCEPTANCE-MATRIX.md`;
- `11-testing/FAILURE-AND-EXCLUSION-CASES.md`;
- `11-testing/TECHNICAL-TEST-AND-BASELINE-PLAN.md`;
- `12-delivery/EPICS.md`;
- `12-delivery/MVP-SOCRATES-2.md`;
- `12-delivery/MVP-EPIC-SELECTION.md`;
- `12-delivery/MVP-FEATURES.md`;
- `12-delivery/MVP-USER-STORIES.md`;
- `12-delivery/MOSCOW-PRIORITIZATION.md`;
- `12-delivery/MVP-DEPENDENCY-MAP.md`;
- `12-delivery/DEFINITION-OF-READY.md`;
- `12-delivery/DEFINITION-OF-DONE.md`;
- `12-delivery/STORY-TO-TECHNICAL-MAP.md`;
- `12-delivery/CODEX-IMPLEMENTATION-BATCHES.md`;
- `12-delivery/FIRST-CODE-PR.md`;
- `12-delivery/STORY-READINESS-ASSESSMENT.md`;
- `12-delivery/TECHNICAL-RISK-REGISTER.md`;
- `12-delivery/MARCO-003-APPROVAL-PACKAGE.md`.

## Regra de autoridade

Até uma migração byte a byte validada, o conteúdo integral no commit de origem é a referência normativa para os documentos não materializados. Os documentos do Lote 0 no repositório canônico não podem contradizer, reduzir ou substituir silenciosamente essa origem.

## Verificação

A sincronização é considerada válida quando:

- origem e commit estão registrados;
- os documentos operacionais existem no destino;
- nenhuma documentação existente do monorepo foi apagada;
- nenhum código, migration, RLS, dependência ou configuração de produção foi alterado;
- os limites do EPIC-018 permanecem explícitos.
