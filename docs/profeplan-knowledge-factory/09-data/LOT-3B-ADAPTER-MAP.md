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

| Método                           | Tabela(s)                     | Operação                                           | Client | Observações                                                              |
| -------------------------------- | ----------------------------- | -------------------------------------------------- | ------ | ------------------------------------------------------------------------ |
| `findById(id)`                   | `kf_sources`                  | SELECT por `id`, `maybeSingle`                     | SYSTEM | Retorna fonte inclusive bloqueada/arquivada; elegibilidade é do domínio. |
| `findVersion(sourceId, version)` | `kf_source_versions`          | SELECT por `source_id + version`                   | SYSTEM | Não lê segmentos.                                                        |
| `listPermissionEvents(sourceId)` | `kf_source_permission_events` | SELECT por `source_id`, ordenado por `occurred_at` | SYSTEM | Somente leitura de histórico append-only.                                |
| `save(source)`                   | `kf_sources`                  | INSERT/UPDATE controlado por `id`                  | SYSTEM | Uma tabela. Não cria versão, segmento ou evento.                         |

### Gap deliberado

A porta não oferece:

- `saveVersion`;
- `saveSegment`;
- `appendPermissionEvent`.

O adapter não inventará esses métodos.

## 2. PedagogicalComponentRepository

| Método                                      | Fronteira física                                                                         | Operação                       | Client | Observações                                                                                         |
| ------------------------------------------- | ---------------------------------------------------------------------------------------- | ------------------------------ | ------ | --------------------------------------------------------------------------------------------------- |
| `findById(id)`                              | `kf_pedagogical_components`                                                              | SELECT por `id`, `maybeSingle` | SYSTEM | Colunas explícitas; ausência legítima retorna `null`.                                               |
| `findVersion(componentId, version)`         | `kf_component_versions`, `kf_component_source_evidence`, `kf_component_curriculum_links` | SELECT base + hidratação       | SYSTEM | Falha de hidratação rejeita o resultado inteiro.                                                    |
| `listEvidenceOrigins(componentVersionId)`   | `kf_component_source_evidence`                                                           | SELECT por versão              | SYSTEM | Ordenação determinística por `recorded_at` e `id`.                                                  |
| `createComponentAggregate(command)`         | `kf_create_pedagogical_component_aggregate`                                              | uma RPC transacional           | SYSTEM | Persiste componente, versão inicial, evidências, vínculos e recibo como unidade.                    |
| `appendComponentVersion(command)`           | `kf_append_pedagogical_component_version`                                                | uma RPC transacional           | SYSTEM | Insere snapshot e relações sem promover o ponteiro corrente.                                        |
| `transitionComponentVersionStatus(command)` | `kf_transition_pedagogical_component_version_status`                                     | uma RPC transacional           | SYSTEM | Compare-and-set de estado e atualização coerente do componente quando a versão é corrente.          |
| `promoteComponentVersion(command)`          | `kf_promote_pedagogical_component_version`                                               | uma RPC transacional           | SYSTEM | Compare-and-set do ponteiro corrente e timestamp; exige alvo aprovado e material pedagógico válido. |

### Separação do Lote 3B.4

- 3B.4A: adapter separado para os três métodos de leitura, integrado;
- 3B.4B.1: quatro comandos explícitos e porta separada, integrado;
- 3B.4B.2: quatro RPCs transacionais estreitas, integrado;
- 3B.4B.3: adapter de comandos separado, integrado pelo PR nº 22, sem composição ou wiring automático com a leitura.

### Risco de hidratação

`findVersion()` exige compor dados de três tabelas. Como não existe consumidor operacional ou writer integrado, leituras sequenciais são aceitáveis no 3B.4A, porém nenhum código deverá prometer snapshot transacional.

Se consistência estrita for necessária, criar RPC/read model específico em migration aprovada.

### Gap de evidência

`sourceEvidenceIds` referencia evidências, mas a porta não possui método de criação de `EvidenceOrigin`.

O contrato 2.0 transporta objetos `EvidenceOrigin` completos dentro dos comandos e o adapter 3B.4B.3
os envia somente pela RPC correspondente, sem side-channel. A integração humana do PR nº 22 e o DB
CI verde satisfizeram o critério de encerramento do GAP-3B-06.

## 3. CurriculumRepository

| Método                                           | Tabela(s)                                                 | Operação                               | Client | Observações                                                                                             |
| ------------------------------------------------ | --------------------------------------------------------- | -------------------------------------- | ------ | ------------------------------------------------------------------------------------------------------- |
| `findPackageById(id)`                            | `kf_curriculum_packages`, `kf_curriculum_package_sources` | SELECT + hidratação `sourceVersionIds` | SYSTEM | Read-only.                                                                                              |
| `findActivePackageByStateAndStage(state, stage)` | `kf_curriculum_packages`, `kf_curriculum_package_sources` | SELECT de pacote ativo                 | SYSTEM | Filtrar obrigatoriamente por `state`, `stage` e `status = active`; hidratar fontes sem retorno parcial. |
| `findNodeById(id)`                               | `kf_curriculum_nodes`                                     | SELECT por `id`                        | SYSTEM | Read-only.                                                                                              |
| `listNodesByPackage(packageId)`                  | `kf_curriculum_nodes`                                     | SELECT por pacote                      | SYSTEM | Read-only, ordenação determinística deverá ser definida pelo adapter.                                   |

### GAP-3B-01

Encerrado após a integração do PR nº 15: a porta e o adapter usam `findActivePackageByStateAndStage(state, stage)`, sem alias do método antigo, e os testes comprovam desambiguação por etapa.

## 4. ProductionOrderRepository

Definição integrada do 3B.5:

| Capacidade / método                         | Fronteira física                 | Operação                      | Client             | Observações                                                                                 |
| ------------------------------------------- | -------------------------------- | ----------------------------- | ------------------ | ------------------------------------------------------------------------------------------- |
| `Read.findById(id)`                         | `kf_production_orders`           | SELECT por `id`               | REQUESTER          | RLS garante OPP própria; OPP estrangeira é indistinguível de ausente.                       |
| `Read.listEvents(oppId)`                    | `kf_production_order_events`     | SELECT por OPP, ordenado      | REQUESTER          | RLS segue ownership da OPP pai; ordem `occurred_at`, `id`.                                  |
| `Request.createProductionOrder(cmd)`        | `kf_create_production_order`     | RPC: OPP + `created` + recibo | REQUESTER          | Requester deriva de `auth.uid()`; sem INSERT direto após a migration.                       |
| `Transition.transitionProductionOrder(cmd)` | `kf_transition_production_order` | RPC: UPDATE + evento + recibo | SYSTEM server-only | Política de domínio precede chamada; requester/status/timestamp esperados impedem confusão. |

### GAP-3B-03

`save(order)` + `appendEvent(event)` separados não constituem uma transição atômica.

Decisão aprovada:

- remover `save` e `appendEvent` no contrato `3.0.0`;
- criar comandos distintos para criação e transição;
- fazer criação + `created` e transição + evento como transações reais;
- manter leituras e criação sob REQUESTER;
- manter transição server-only para impedir bypass dos gates pedagógicos;
- testar no Supabase descartável;
- não liberar `UPDATE` direto de OPP ao professor.

O adapter de OPP é deliberadamente o último do 3B.

`GAP-3B-03` permanece ativo até integração humana de contratos, requester read adapter, RPCs,
adapters de comando e checkpoint pós-merge. `GAP-3B-07` registra que essa fatia não materializa a
OPP normativa completa.

## 5. AuditRepository

| Método                         | Tabela(s)         | Operação                                              | Client | Observações                           |
| ------------------------------ | ----------------- | ----------------------------------------------------- | ------ | ------------------------------------- |
| `append(event)`                | `kf_audit_events` | INSERT                                                | SYSTEM | Append-only; nunca upsert.            |
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
4. leituras do `PedagogicalComponentRepository` como fatia 3B.4A;
5. escrita do componente por RPC, integrada e com GAP-3B-02 e GAP-3B-06 encerrados;
6. `ProductionOrderRepository` em quatro sublotes após integração da definição 3B.5.

Os itens 1 a 5 foram integrados. O Lote 3B.4 está concluído. A definição do item 6 foi integrada e o
3B.5.1 foi integrado pelo Pull Request nº 25. O adapter REQUESTER read-only do 3B.5.2 foi
implementado em branch própria e está em revisão. Os sublotes 3B.5.3 e 3B.5.4 permanecem bloqueados
até gates humanos próprios.
