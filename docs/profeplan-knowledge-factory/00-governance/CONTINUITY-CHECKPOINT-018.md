# CONTINUITY CHECKPOINT 018 — Definição documental do Lote 3B.4

Data: 8 de agosto de 2026.

## Status

**A definição documental do `Lote 3B.4 — PedagogicalComponentRepository` foi preparada e publicada no Pull Request nº 16, em draft. Nenhum código, contrato, teste de código, migration, RPC, RLS, banco, wiring ou produção foi alterado. O Lote 3B.4A não está autorizado para implementação e o Lote 3B.4B permanece bloqueado.**

## Repositório e Pull Request

Repositório:

`PaulinhoRehfeld/profeplan`

Branch:

`agent/knowledge-factory-lot-3b4-definition`

Pull Request:

`#16 — docs(knowledge-factory): define Lote 3B.4 pedagogical component adapter`

Estado do PR:

- draft;
- sem merge automático;
- base `main`;
- exclusivamente documental.

Base validada:

`ad168c6926cb404a5abda5109be4a42d4d0df30b`

Head documental antes deste checkpoint:

`867230a61dd6709248d5091882f9da6c55bd22a5`

## Estado de continuidade reconciliado

- Lote 3B.1 — `AuditRepository`: concluído e integrado;
- Lote 3B.2 — `KnowledgeSourceRepository`: concluído e integrado;
- Lote 3B.3 — `CurriculumRepository`: concluído e integrado;
- GAP-3B-01: encerrado após a integração do PR nº 15;
- GAP-3B-02 a GAP-3B-05: preservados conforme seus escopos;
- GAP-3B-06: identificado para a escrita incompleta de evidências e vínculos;
- Lote 3B.4: definição documental em revisão;
- Lote 3B.5: não iniciado;
- produção: não autorizada.

O `BLUEPRINT.md` foi atualizado somente no estado de navegação e na descrição atual do 3B.3/3B.4. Os checkpoints históricos permanecem inalterados.

## Evidências técnicas da inspeção

### Porta e consumidores

A porta real expõe cinco métodos:

1. `findById(id)`;
2. `findVersion(componentId, version)`;
3. `listEvidenceOrigins(componentVersionId)`;
4. `saveComponent(component)`;
5. `saveVersion(version)`.

Os três primeiros são leituras; os dois últimos são escritas.

Nenhum consumidor operacional atual foi encontrado. A porta é exportada e listada nos testes contratuais, enquanto as políticas de domínio recebem contratos já materializados e não chamam o repositório.

### Leituras do 3B.4A

- `findById()` consulta `kf_pedagogical_components`;
- `findVersion()` consulta `kf_component_versions` e hidrata IDs de `kf_component_source_evidence` e `kf_component_curriculum_links`;
- `listEvidenceOrigins()` reconstrói `EvidenceOrigin` de `kf_component_source_evidence`;
- IDs de evidência serão ordenados por `id`;
- IDs curriculares serão ordenados por `curriculum_node_id`;
- evidências completas serão ordenadas por `recorded_at` e `id`;
- ausência legítima da linha principal retorna `null`;
- lista legitimamente vazia retorna `[]`;
- indisponibilidade ou shape inválido geram erro provider-neutral;
- falha em hidratação impede retorno parcial;
- leituras sequenciais são aceitáveis sem promessa de snapshot forte;
- nenhuma RPC/read model é necessária no estado atual.

Como a interface completa também contém escritas, a futura classe 3B.4A será verificada contra um `Pick` dos três métodos de leitura. Não haverá stubs de escrita nem alegação de implementação integral da porta.

### Escritas do 3B.4B

A criação completa atravessa:

- `kf_pedagogical_components`;
- `kf_component_versions`;
- `kf_component_source_evidence`;
- `kf_component_curriculum_links`.

A FK composta de `current_version_id` é deferrable e permite resolver a circularidade apenas dentro de uma transação PostgreSQL real. Ela não torna chamadas Supabase independentes atômicas.

`saveComponent()` não distingue criação de atualização e não é seguro como semântica isolada para o lifecycle completo.

`saveVersion()` precisa representar evidências e vínculos, mas a porta não oferece criação de `EvidenceOrigin`, não define insert versus update/substituição e não fornece idempotência. Persistência lateral foi proibida.

Consequência:

- GAP-3B-02 bloqueia atomicidade;
- GAP-3B-06 bloqueia suficiência contratual;
- ambos bloqueiam 3B.4B;
- nenhum contrato foi alterado neste PR.

## Documentos alterados

- `BLUEPRINT.md`;
- `00-governance/DECISION-LOG.md`;
- `00-governance/LOT-3B-ARCHITECTURE-DECISIONS.md`;
- `09-data/LOT-3B-ADAPTER-MAP.md`;
- `09-data/LOT-3B-TRANSACTION-STRATEGY.md`;
- `12-delivery/LOT-3B-RISK-REGISTER.md`;
- `12-delivery/LOT-3B4-PEDAGOGICAL-COMPONENT-ADAPTER-DEFINITION.md`;
- este `CONTINUITY-CHECKPOINT-018.md`.

Não foram alterados `LOT-3B-DEFINITION.md`, `LOT-3B-TEST-STRATEGY.md` ou `LOT-3B-PRODUCTION-BOUNDARY.md`, pois suas regras gerais continuam válidas e a definição específica registra os testes e limites próprios do 3B.4.

## Validação local antes do checkpoint

- base e merge-base: `ad168c6926cb404a5abda5109be4a42d4d0df30b`;
- branch remota criada sem conflito de nome;
- `git diff --check`: verde;
- Prettier 3.8.4 em todos os documentos alterados: verde;
- caminhos e arquivos referenciados: conferidos;
- diff restrito a `docs/`: confirmado;
- lockfile, código, schema, migration, testes de código e workflow: inalterados;
- nenhum Supabase hospedado ou produção acessado;
- nenhum secret solicitado ou exibido.

O `Knowledge Factory DB CI` não foi acionado artificialmente antes do PR, porque o corte documental não altera seus paths de banco, adapter ou workflow. Os checks associados ao SHA final do PR deverão ser revalidados após a inclusão deste checkpoint.

## Stories e fases

A definição prepara infraestrutura futura para US-004.1, US-004.2 e US-004.3, sem conceder `Done` integral a qualquer Story.

- Fase B não está concluída;
- Fase C não foi iniciada;
- nenhum componente, evidência ou currículo real foi criado;
- retrieval, embeddings, agentes e Sócrates 2 executável permanecem fora do escopo.

## Próximo gate humano

O próximo gate é revisar o Pull Request nº 16 e decidir entre:

1. solicitar ajustes;
2. rejeitar ou adiar;
3. autorizar squash merge.

Não realizar merge automático.

Somente após a integração humana deste PR e nova autorização explícita poderá ser criada uma branch nova para implementar exclusivamente o Lote 3B.4A.

3B.4B e 3B.5 permanecem bloqueados.

## Próximo momento de fork

**Este checkpoint marca o próximo momento oficial de fork.**

A próxima conversa deverá começar pela leitura deste checkpoint, pela revisão do PR nº 16 e pela decisão humana sobre sua integração. Nenhuma continuidade implícita autoriza código.
