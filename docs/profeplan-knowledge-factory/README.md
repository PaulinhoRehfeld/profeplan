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

## Estado atual

O [Blueprint de Execução](BLUEPRINT.md) é a referência de navegação vigente.

- Fase A — concluída;
- Lotes 3B.1, 3B.2, 3B.3 e 3B.4 — integrados;
- GAP-3B-01 — encerrado;
- GAP-3B-02 e GAP-3B-06 — condições de encerramento satisfeitas e formalizadas no
  [Checkpoint 025](00-governance/CONTINUITY-CHECKPOINT-025.md);
- GAP-3B-03, GAP-3B-04 e GAP-3B-05 — ativos;
- Lote 3B.5 — não iniciado;
- Fase B — não concluída;
- produção — não autorizada por nenhum merge técnico ou documental.

O próximo gate, após a integração humana do Checkpoint 025, é definir documentalmente o Lote 3B.5
— `ProductionOrderRepository`. Código, migration, RPC, wiring, Supabase hospedado e produção exigem
autorizações próprias.
