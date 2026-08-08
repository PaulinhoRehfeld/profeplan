# Lote 3B — Mapa porta → adapter → tabela → operação

## Status

**Aprovado integralmente em 7 de agosto de 2026.**

Este documento define o mapa técnico aprovado; não implementa código nem autoriza produção.

## Princípios

1. o domínio conhece portas, nunca Supabase;
2. adapters conhecem tabelas, nunca regras pedagógicas;
3. `api/` é composition root, não dependência do pacote;
4. corpus global usa client privilegiado injetado;
5. OPP do professor deve preferir client request-scoped para manter RLS em defesa em profundidade;
6. eventos append-only nunca expõem update/delete;
7. operações multi-tabela não fingem atomicidade.

## Classes de cliente

- **SYSTEM** — cliente server-side privilegiado, potencialmente `service_role`, injetado pelo composition root.
- **REQUESTER** — cliente server-side/autenticado com identidade do request, preservando `auth.uid()` e RLS.

## 1. KnowledgeSourceRepository

| Método | Tabela(s) | Operação | Client | Observações |
|---|---|---|---|---|
| `findById(id)` | `kf_sources` | SELECT por `id`, `maybeSingle` | SYSTEM | Retorna fonte inclusive bloqueada/arquivada; elegibilidade é do domínio. |
| `findVersion(sourceId, version)` | `kf_source_versions` | SELECT por `source_id + version` | SYSTEM | Não lê segmentos. |
| `listPermissionEvents(sourceId)` | `kf_source_permission_events` | SELECT por `source_id`, ordenado por `occurred_at` | SYSTEM | Somente leitura de histórico append-only. |
| `save(source)` | `kf_sources` | INSERT/UPDATE controlado por `id` | SYSTEM | Uma tabela. Não cria versão, segmento ou evento. |

### Gap deliberado

A porta não oferece:

- `saveVersion`;
- `saveSegment`;
- `appendPermissionEvent`.

O adapter não inventará esses métodos.

## 2. PedagogicalComponentRepository

| Método | Tabela(s) | Operação | Client | Observações |
|---|---|---|---|---|
| `findById(id)` | `kf_pedagogical_components` | SELECT por `id` | SYSTEM | Mapeamento simples. |
| `findVersion(componentId, version)` | `kf_component_versions`, `kf_component_source_evidence`, `kf_component_curriculum_links` | SELECT + hidratação dos IDs relacionais | SYSTEM | O contrato contém `sourceEvidenceIds` e `curriculumNodeIds`, não armazenados diretamente na linha de versão. |
| `listEvidenceOrigins(componentVersionId)` | `kf_component_source_evidence` | SELECT por `component_version_id` | SYSTEM | Reconstrói `EvidenceOrigin`. |
| `saveComponent(component)` | `kf_pedagogical_components` | INSERT/UPDATE | SYSTEM | Isoladamente é uma tabela, mas criação inicial pode depender de versão válida. |
| `saveVersion(version)` | `kf_component_versions` + potencial sincronização de vínculos curriculares | WRITE | SYSTEM | **Bloqueado para implementação de escrita até estratégia atômica aprovada.** |

### Risco de hidratação

`findVersion()` exige compor dados de três tabelas. Como versões aprovadas tendem a ser estáveis, leituras sequenciais podem ser aceitáveis em estágio inicial, porém nenhum código deverá prometer snapshot transacional.

Se consistência estrita for necessária, criar RPC/read model específico em migration aprovada.

### Gap de evidência

`sourceEvidenceIds` referencia evidências, mas a porta não possui método de criação de `EvidenceOrigin`.

Não criar side-channel de persistência fora da porta.

## 3. CurriculumRepository

| Método | Tabela(s) | Operação | Client | Observações |
|---|---|---|---|---|
| `findPackageById(id)` | `kf_curriculum_packages`, `kf_curriculum_package_sources` | SELECT + hidratação `sourceVersionIds` | SYSTEM | Read-only. |
| `findActivePackageByStateAndStage(state, stage)` | `kf_curriculum_packages`, `kf_curriculum_package_sources` | SELECT de pacote ativo | SYSTEM | Filtrar obrigatoriamente por `state`, `stage` e `status = active`; hidratar fontes sem retorno parcial. |
| `findNodeById(id)` | `kf_curriculum_nodes` | SELECT por `id` | SYSTEM | Read-only. |
| `listNodesByPackage(packageId)` | `kf_curriculum_nodes` | SELECT por pacote | SYSTEM | Read-only, ordenação determinística deverá ser definida pelo adapter. |

### GAP-3B-01

O banco permite um pacote ativo por `(state, stage)`, enquanto a porta atual busca apenas por `state`.

A definição do Lote 3B.3 propõe substituir a assinatura ambígua por:

`findActivePackageByStateAndStage(state, stage)`

O método antigo não será mantido. O GAP-3B-01 permanece aberto até a decisão ser integrada, a porta ser alterada e os testes do adapter comprovarem a desambiguação.

## 4. ProductionOrderRepository

| Método | Tabela(s) | Operação | Client | Observações |
|---|---|---|---|---|
| `findById(id)` | `kf_production_orders` | SELECT por `id` | REQUESTER preferencial | RLS garante requester próprio. Fluxos internos privilegiados exigem decisão explícita. |
| `save(order)` | `kf_production_orders` | INSERT ou futura transição | REQUESTER para criação; transição interna a definir | INSERT inicial `requested` pode usar RLS. UPDATE direto de professor não é permitido. |
| `appendEvent(event)` | `kf_production_order_events` | INSERT | SYSTEM/futura RPC | Professor não possui INSERT direto. Evento de transição deve acompanhar mudança da OPP atomicamente. |
| `listEvents(oppId)` | `kf_production_order_events` | SELECT por OPP | REQUESTER preferencial | RLS limita aos eventos da OPP própria. |

### GAP-3B-03

`save(order)` + `appendEvent(event)` separados não constituem uma transição atômica.

Antes de implementar transições reais:

- definir comando/RPC PostgreSQL transacional;
- testar no Supabase descartável;
- não liberar `UPDATE` direto de OPP ao professor.

O adapter de OPP é deliberadamente o último do 3B.

## 5. AuditRepository

| Método | Tabela(s) | Operação | Client | Observações |
|---|---|---|---|---|
| `append(event)` | `kf_audit_events` | INSERT | SYSTEM | Append-only; nunca upsert. |
| `listByAggregate(aggregateId)` | `kf_audit_events` | SELECT por `aggregate_id`, ordenado por `occurred_at` | SYSTEM | Leitura interna/admin; não professor. |

### Primeiro adapter aprovado

`AuditRepository` é o menor corte vertical porque:

- usa uma tabela;
- não exige port change;
- não exige RPC;
- valida INSERT append-only;
- valida SELECT mapeado;
- valida error translation;
- valida observabilidade;
- valida client injection;
- integra naturalmente com o Supabase descartável já existente.

O GAP-3B-05 permanece: a porta retorna `DomainEvent`, enquanto a tabela física possui campos adicionais de auditoria. O primeiro adapter é uma fatia de infraestrutura, não auditoria enriquecida completa.

## Mapeamento de campos — princípios

### SQL → contrato

- `snake_case` → `camelCase`;
- `timestamptz` → ISO string sem transformação semântica;
- `uuid` → `EntityId`;
- arrays SQL → arrays readonly nos contratos;
- `jsonb` → allowlist/mapa validado quando houver;
- `null` SQL → `undefined` apenas quando o contrato usa campo opcional.

### Contrato → SQL

- não persistir propriedades derivadas que não existam na tabela;
- não escrever `undefined` como string/null automaticamente;
- IDs e versões são preservados;
- timestamps do contrato são persistidos explicitamente quando exigidos;
- defaults do banco só são usados quando isso fizer parte do contrato aprovado.

## Operações proibidas em adapters

- `delete` em qualquer tabela histórica;
- `update/delete/upsert` em `kf_source_permission_events`;
- `update/delete/upsert` em `kf_production_order_events`;
- `update/delete/upsert` em `kf_audit_events`;
- `SELECT *` indiscriminado quando há lista de colunas suficiente;
- queries sem filtro em corpus global por conveniência;
- bypass de regra de domínio para tornar teste verde.

## Ordem de implementação aprovada

1. `AuditRepository`;
2. `KnowledgeSourceRepository`;
3. correção da porta curricular e `CurriculumRepository`;
4. leituras do `PedagogicalComponentRepository`;
5. escrita do componente após fronteira transacional;
6. `ProductionOrderRepository` após requester client + RPC de transição.

A primeira implementação está restrita ao item 1. Avançar para item 2 ou além exige novo gate humano.