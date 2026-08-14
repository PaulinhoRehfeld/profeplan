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
- [Checkpoint 040 — C.1.3 integrado e revalidado; C.1.4 permanece bloqueado](00-governance/CONTINUITY-CHECKPOINT-040.md)
- [Checkpoint 041 — C.1.4 integrado e revalidado; C.1.5 permanece bloqueado](00-governance/CONTINUITY-CHECKPOINT-041.md)
- [Matriz de evidências C.1.5 — testes do lifecycle de fontes](12-delivery/LOT-C1-5-SOURCE-LIFECYCLE-TEST-EVIDENCE-MATRIX.md)
- [Checkpoint 042 — C.1.5 integrado e revalidado; C.1.6 permanece bloqueado](00-governance/CONTINUITY-CHECKPOINT-042.md)

## Estado atual

O [Blueprint de Execução](BLUEPRINT.md) permanece a referência macro de sequência, dependências e gates. Para o estado operacional corrente de C.1 após o PR nº 55, prevalece o [Checkpoint 042](00-governance/CONTINUITY-CHECKPOINT-042.md) sobre marcadores de status anteriores ainda preservados no Blueprint e no mapa da Fase C.

- Fase A — concluída;
- Lotes 3B.1, 3B.2, 3B.3 e 3B.4 — concluídos;
- GAP-3B-01 — encerrado;
- GAP-3B-02 e GAP-3B-06 — condições de encerramento satisfeitas e formalizadas no
  [Checkpoint 025](00-governance/CONTINUITY-CHECKPOINT-025.md);
- GAP-3B-03 — condições de encerramento satisfeitas e formalizadas no
  [Checkpoint 031](00-governance/CONTINUITY-CHECKPOINT-031.md);
- GAP-3B-04, GAP-3B-05 e GAP-3B-07 — ativos e explicitamente limitados;
- Lote 3B.5 — definição documental e sublotes 3B.5.1 a 3B.5.4 integrados; encerramento
  formalizado no [Checkpoint 031](00-governance/CONTINUITY-CHECKPOINT-031.md);
- Fase B — encerramento por bloqueio parcial controlado formalizado no
  [Checkpoint 032](00-governance/CONTINUITY-CHECKPOINT-032.md);
- Fase C — C.0 integrado pelo PR nº 31 no commit
  `a370d2f80663f2ae5a6bc0aa2ba5942d85db9708`;
- Lote C.1 — definição integrada pelo PR nº 32 no commit
  `01c92dda8257935e7a6c042be12308ebccdaeb73`;
- C.1.1 — contratos integrados pelo PR nº 33 no commit
  `2db5fc07378cc7c062753078b2a3fb2025cb1afe`;
- C.1.2 — persistência incremental, RLS, grants, rollback e testes integrados pelo PR nº 34 no
  commit canônico `673318c2d3370f60997fd0a15b68bc69c6be5755`; validações pré-merge concluídas com CI Pipeline
  nº 288, Knowledge Factory DB CI nº 40 e Vercel verdes;
- recuperação canônica da Knowledge Factory até C.1.2 — integrada pelo PR nº 43 no merge commit
  `39068d3225185d29c38c8b5841a21f60636b58b2`;
- C.1.3 — definição documental rematerializada pelo PR nº 49 e implementação executável integrada pelo
  PR nº 51 no commit canônico `27ca7db0d07550b827c66bd4cdc7a2017d30b72d`; a fronteira inclui
  `kf_source_actor_assignments`, 13 RPCs estreitas `SECURITY DEFINER`, grants mínimos, idempotência,
  CAS, impacto conservador, supersessão atômica e validação de segurança/concorrência em Supabase
  descartável; a migration existe no repositório, mas não foi aplicada a Supabase hospedado ou produção;
- C.1.4 — ports e adapters provider-neutral integrados pelo PR nº 53 no commit canônico
  `c4620d036addbd2b331ef2aea2396ce104fe9176`; inclui adapter para os 13 comandos C.1.3, leitura
  histórica de registro/autorização/impacto por três RPCs `SECURITY DEFINER` somente-leitura,
  tradução provider-neutral de receipts/erros, telemetria sanitizada e integração validada em
  Supabase descartável, sem reabrir `SELECT` ou DML direto de `service_role` nas tabelas protegidas;
- C.1.5 — testes de contrato, integração, segurança e concorrência integrados pelo PR nº 55 no commit
  canônico `f033faa51ed33ac504c5775e8bdcca7915c00d89`; a prova integrada recompõe C.1.2 → C.1.3 → C.1.4
  em Supabase descartável, valida RLS, competência, idempotência, CAS, falha parcial, concorrência
  multi-session, rollback/reapply, leitura histórica, expiração temporal, supersessão e
  provider-neutrality; não adiciona migration ou código funcional de produto;
- C.1.6 e C.2–C.7 — bloqueados;
- GAP-3B-04, GAP-3B-05 e GAP-3B-07 — ativos e contidos;
- produção — não autorizada por nenhum merge técnico ou documental.

C.1.5 está integrado e revalidado. O próximo sublote tecnicamente candidato é C.1.6, mas permanece bloqueado e não foi iniciado. Nenhuma ação desta reconciliação encerra `GAP-3B-04`, inicia C.1.6, C.2, ingestão, wiring, Supabase hospedado ou produção.
