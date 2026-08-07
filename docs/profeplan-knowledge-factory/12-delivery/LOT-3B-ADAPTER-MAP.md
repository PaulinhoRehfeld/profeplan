# Lote 3B — Mapa porta → adapter → tabela → operação

Data: 7 de agosto de 2026.

Status: proposta documental.

## Convenções

- **System**: cliente server-side privilegiado, injetado pelo composition root.
- **Requester**: cliente autenticado no contexto do usuário, sujeito a RLS.
- `null`: ausência válida para métodos `find*`.
- Erros de provider nunca atravessam a porta sem tradução.
- O adapter implementa apenas métodos existentes; não inventa novos casos de uso.

## 1. KnowledgeSourceRepository

| Método da porta | Tabela(s) | Operação | Contexto | Observações |
|---|---|---|---|---|
| `findById(id)` | `kf_sources` | SELECT por `id` | System | Corpus não é leitura direta de professor. |
| `findVersion(sourceId, version)` | `kf_source_versions` | SELECT por `source_id + version` | System | Retorna `null` se ausente. |
| `listPermissionEvents(sourceId)` | `kf_source_permission_events` | SELECT por `source_id`, ordenado por `occurred_at` | System | Leitura histórica; eventos append-only. |
| `save(source)` | `kf_sources` | INSERT/UPDATE controlado por `id` | System | Não cria versões, segmentos ou eventos. |

### Bloqueios

- criação de `SourceVersion` não existe na porta;
- criação de `SourceSegment` não existe na porta;
- append de `SourcePermissionEvent` não existe na porta;
- nenhuma dessas operações será inventada no adapter.

## 2. PedagogicalComponentRepository

| Método da porta | Tabela(s) | Operação | Contexto | Observações |
|---|---|---|---|---|
| `findById(id)` | `kf_pedagogical_components` | SELECT por `id` | System | Mapper simples. |
| `findVersion(componentId, version)` | `kf_component_versions`, `kf_component_source_evidence`, `kf_component_curriculum_links` | SELECT + composição de arrays relacionais | System | Deve reconstruir `sourceEvidenceIds` e `curriculumNodeIds`. |
| `listEvidenceOrigins(componentVersionId)` | `kf_component_source_evidence` | SELECT por `component_version_id` | System | Retorna `EvidenceOrigin[]`. |
| `saveComponent(component)` | `kf_pedagogical_components` | INSERT/UPDATE | System | Bloqueado para criação inicial até transação com primeira versão ser definida. |
| `saveVersion(version)` | `kf_component_versions` + links relacionais | múltiplas escritas | System | Bloqueado até fronteira atômica aprovada. |

### GAP-3B-02

`PedagogicalComponentVersion` contém arrays relacionais que não são colunas da tabela principal. Persistir uma versão completa exige coordenação de:

- `kf_component_versions`;
- `kf_component_source_evidence`;
- `kf_component_curriculum_links`;
- eventual atualização de `current_version_id`.

Isso não pode ser tratado como uma sequência de chamadas Supabase sem atomicidade.

## 3. CurriculumRepository

| Método da porta | Tabela(s) | Operação | Contexto | Observações |
|---|---|---|---|---|
| `findPackageById(id)` | `kf_curriculum_packages`, `kf_curriculum_package_sources` | SELECT + reconstrução de `sourceVersionIds` | System | Read-only. |
| `findActivePackageByState(state)` | `kf_curriculum_packages`, `kf_curriculum_package_sources` | SELECT ativo | System | **Bloqueado:** falta `stage` na assinatura. |
| `findNodeById(id)` | `kf_curriculum_nodes` | SELECT por `id` | System | Read-only. |
| `listNodesByPackage(packageId)` | `kf_curriculum_nodes` | SELECT por `curriculum_package_id` | System | Read-only; ordem determinística deverá ser definida. |

### GAP-3B-01

O banco garante um ativo por `(state, stage)`, enquanto a porta consulta somente `state`.

Assinatura recomendada para proposta futura:

`findActivePackage(state, stage): Promise<CurriculumPackage | null>`

Nenhuma alteração é autorizada por este documento.

## 4. ProductionOrderRepository

| Método da porta | Tabela(s) | Operação | Contexto | Observações |
|---|---|---|---|---|
| `findById(id)` | `kf_production_orders` | SELECT por `id` | Requester | RLS deve negar OPP alheia. |
| `save(order)` | `kf_production_orders` | INSERT/UPDATE | Requester | Criação própria pode usar RLS; mudança de status não deve se separar do evento. |
| `appendEvent(event)` | `kf_production_order_events` | INSERT | Contexto interno aprovado | Professor não possui grant direto para eventos. |
| `listEvents(oppId)` | `kf_production_order_events` | SELECT | Requester ou serviço mediado | Deve preservar isolamento do aggregate. |

### GAP-3B-03

Transição OPP e seu evento precisam ser uma unidade atômica. A API atual da porta separa as duas chamadas.

Antes da escrita de transições deverá ser aprovada uma destas estratégias:

1. RPC SQL transacional orientada ao comando de transição; ou
2. Unit of Work explícito, se houver suporte real no provider.

Não utilizar compensação best-effort como substituto de transação para timeline/auditoria.

## 5. AuditRepository

| Método da porta | Tabela(s) | Operação | Contexto | Observações |
|---|---|---|---|---|
| `append(event)` | `kf_audit_events` | INSERT | System | Uma escrita, append-only, sem update/delete. |
| `listByAggregate(aggregateId)` | `kf_audit_events` | SELECT por `aggregate_id`, ordem por `occurred_at` | System | Mapper descarta campos infra não pertencentes a `DomainEvent`. |

### Primeiro PR recomendado

AuditRepository é a primeira fatia porque:

- cobre a porta inteira;
- não exige mudança de contrato;
- não exige transação multi-tabela;
- permite testar client injection;
- permite testar erro sanitizado;
- permite testar observabilidade;
- reutiliza o Supabase descartável já validado.

## 6. Autorização por capacidade

### System adapters

Previstos inicialmente:

- AuditRepository;
- KnowledgeSourceRepository;
- PedagogicalComponentRepository;
- CurriculumRepository.

Acesso privilegiado não elimina as políticas do domínio: ele apenas permite que um serviço autorizado acesse o corpus global que o professor não pode consultar diretamente.

### Requester adapter

`ProductionOrderRepository` deve preferir contexto de usuário/RLS para operações privadas.

O uso de `service_role` para OPP exigiria filtros manuais e retiraria uma camada de defesa. Por isso não é o padrão recomendado.

## 7. Mappers

Cada adapter terá mapper explícito e testado.

Regras:

- snake_case fica na infraestrutura;
- camelCase fica nos contratos;
- datas ISO permanecem strings ISO nos contratos;
- arrays SQL são copiados para arrays readonly de contrato;
- valores desconhecidos de status não são silenciosamente convertidos;
- row incompleta/incompatível gera erro de mapeamento sanitizado;
- nenhum `any` atravessa a fronteira pública.

## 8. Ordem de implementação recomendada

1. AuditRepository;
2. KnowledgeSourceRepository em métodos existentes;
3. correção contratual do CurriculumRepository;
4. CurriculumRepository read-only;
5. leituras de PedagogicalComponentRepository;
6. definição de RPCs/atomicidade para componentes;
7. definição do requester-scoped client;
8. ProductionOrderRepository e transições atômicas.

Essa ordem pode ser alterada somente por decisão documentada.