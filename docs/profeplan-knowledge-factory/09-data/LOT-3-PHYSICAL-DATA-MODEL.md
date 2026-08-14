# Modelo físico proposto — Lote 3

## Status

**Proposta documental. Não é migration executável.**

## Decisões de modelagem

- PostgreSQL/Supabase como persistência canônica da Knowledge Factory;
- objetos no schema `public` com prefixo `kf_`;
- IDs físicos em UUID;
- versões em `text` não vazio;
- timestamps em `timestamptz`;
- estados/tipos em `text` + `CHECK`, evitando PostgreSQL enums rígidos;
- relações N:N normalizadas;
- JSONB apenas para metadados realmente abertos, especialmente auditoria;
- nenhuma coluna vetorial neste lote;
- nenhuma duplicação de conteúdo bruto em tabelas de componente.

## Por que `public.kf_*` e não um schema PostgreSQL separado agora

O produto atual já usa Supabase/PostgREST sobre `public`, e o repositório ainda não possui configuração canônica para expor ou operar um schema customizado da Knowledge Factory.

Usar prefixo `kf_` permite:

- migration incremental simples;
- inspeção clara dos objetos;
- RLS e grants explícitos;
- nenhum impacto nas tabelas atuais;
- futura migração para schema dedicado, se comprovadamente útil.

A segurança não dependerá do nome do schema: o corpus global terá `REVOKE` explícito para `anon` e `authenticated`, além de RLS deny-by-default.

## Tabelas

### 1. `kf_sources`

Representa `KnowledgeSource`.

Campos mínimos:

- `id uuid primary key`;
- `version text not null`;
- `title text not null`;
- `source_type text not null`;
- `status text not null`;
- `license_category text not null`;
- `allowed_uses text[] not null`;
- `provenance_uri text null`;
- `created_at timestamptz not null`;
- `updated_at timestamptz not null`.

Checks seguem os enums do contrato 1.1.0.

### 2. `kf_source_versions`

Representa `SourceVersion`.

Campos:

- `id uuid primary key`;
- `version text not null`;
- `source_id uuid not null references kf_sources(id)`;
- `checksum text not null`;
- `effective_at timestamptz not null`;
- `supersedes_version text null`.

Constraints:

- `unique(source_id, version)`;
- checksum não vazio.

### 3. `kf_source_permission_events`

Representa `SourcePermissionEvent`.

Campos:

- `id uuid primary key`;
- `version text not null`;
- `source_id uuid not null references kf_sources(id)`;
- `action text not null`;
- `use_type text not null`;
- `reason text not null`;
- `occurred_at timestamptz not null`.

Política física: append-only.

### 4. `kf_source_segments`

Representa `SourceSegment`.

Campos:

- `id uuid primary key`;
- `version text not null`;
- `source_version_id uuid not null references kf_source_versions(id)`;
- `parent_segment_id uuid null references kf_source_segments(id)`;
- `locator text not null`;
- `content_digest text not null`;
- `extracted_text text not null`;
- `created_at timestamptz not null`.

Observação:

`extracted_text` é dado protegido por política de acesso. Não será exposto a professor diretamente.

### 5. `kf_pedagogical_components`

Representa `PedagogicalComponent`.

Campos:

- `id uuid primary key`;
- `version text not null`;
- `canonical_key text not null unique`;
- `title text not null`;
- `component_type text not null`;
- `school_component text not null`;
- `grades text[] not null`;
- `status text not null`;
- `current_version_id uuid not null`;
- `created_at timestamptz not null`;
- `updated_at timestamptz not null`.

A FK de `current_version_id` será adicionada depois da criação de `kf_component_versions` para evitar dependência circular durante DDL.

### 6. `kf_component_versions`

Representa `PedagogicalComponentVersion`.

Campos:

- `id uuid primary key`;
- `version text not null`;
- `component_id uuid not null references kf_pedagogical_components(id)`;
- `summary text not null`;
- `keywords text[] not null default '{}'`;
- `supersedes_version text null`;
- `approved_at timestamptz null`;
- `status text not null`.

Constraints:

- `unique(component_id, version)`;
- uma versão aprovada precisa respeitar invariantes de domínio; a migration não duplicará toda a lógica pedagógica.

### 7. `kf_component_source_evidence`

Representa `EvidenceOrigin`.

Campos:

- `id uuid primary key`;
- `version text not null`;
- `component_version_id uuid not null references kf_component_versions(id)`;
- `source_id uuid not null references kf_sources(id)`;
- `source_version_id uuid not null references kf_source_versions(id)`;
- `source_segment_id uuid not null references kf_source_segments(id)`;
- `contribution text not null`;
- `recorded_at timestamptz not null`.

Constraints devem impedir evidência órfã. Teste adicional validará que source/version/segment formam cadeia coerente.

### 8. `kf_curriculum_packages`

Representa `CurriculumPackage`.

Campos:

- `id uuid primary key`;
- `version text not null`;
- `state text not null`;
- `stage text not null`;
- `status text not null`;
- `title text not null`;
- `effective_from timestamptz not null`;
- `effective_until timestamptz null`.

Constraint crítica:

- índice único parcial para impedir mais de um pacote `active` por `(state, stage)`.

O MVP testará MG; RS poderá existir apenas em status bloqueado/draft, nunca ativo no piloto.

### 9. `kf_curriculum_package_sources`

Materializa `sourceVersionIds` do pacote.

Campos:

- `curriculum_package_id uuid references kf_curriculum_packages(id)`;
- `source_version_id uuid references kf_source_versions(id)`;
- primary key composta.

### 10. `kf_curriculum_nodes`

Representa `CurriculumNode`.

Campos:

- `id uuid primary key`;
- `version text not null`;
- `curriculum_package_id uuid not null references kf_curriculum_packages(id)`;
- `node_type text not null`;
- `code text not null`;
- `title text not null`;
- `description text not null`;
- `component text not null`;
- `grades text[] not null`.

Constraint sugerida:

- `unique(curriculum_package_id, code, version)`.

### 11. `kf_curriculum_links`

Representa `CurriculumLink` entre nós.

Campos:

- `id uuid primary key`;
- `version text not null`;
- `curriculum_package_id uuid not null references kf_curriculum_packages(id)`;
- `from_node_id uuid not null references kf_curriculum_nodes(id)`;
- `to_node_id uuid not null references kf_curriculum_nodes(id)`;
- `relation text not null`.

### 12. `kf_component_curriculum_links`

Materializa o vínculo entre versão de componente e nó curricular.

Campos:

- `component_version_id uuid not null references kf_component_versions(id)`;
- `curriculum_node_id uuid not null references kf_curriculum_nodes(id)`;
- `created_at timestamptz not null default now()`;
- primary key composta.

O adapter reconstruirá `curriculumNodeIds` a partir desta relação.

### 13. `kf_production_orders`

Representa `PedagogicalProductionOrder`.

Campos:

- `id uuid primary key`;
- `version text not null`;
- `requester_id uuid not null references auth.users(id)`;
- `agent_profile_id uuid not null`;
- `curriculum_package_id uuid not null references kf_curriculum_packages(id)`;
- `product_type text not null`;
- `theme text not null`;
- `duration_minutes integer null`;
- `status text not null`;
- `created_at timestamptz not null`;
- `updated_at timestamptz not null`.

Observação:

`agent_profile_id` permanece identificador opaco neste lote, pois persistência de `AgentProfile` não faz parte do Lote 3.

### 14. `kf_production_order_events`

Representa `OppEvent`.

Campos:

- `id uuid primary key`;
- `version text not null`;
- `opp_id uuid not null references kf_production_orders(id)`;
- `event_type text not null`;
- `from_status text null`;
- `to_status text not null`;
- `reason text null`;
- `occurred_at timestamptz not null`.

Política: append-only.

### 15. `kf_audit_events`

Persistência técnica do `DomainEvent` acrescida de contexto de execução.

Campos:

- `id uuid primary key default gen_random_uuid()`;
- `event_type text not null`;
- `aggregate_type text not null`;
- `aggregate_id uuid not null`;
- `occurred_at timestamptz not null`;
- `actor_id uuid null`;
- `actor_role text null`;
- `correlation_id uuid null`;
- `outcome text not null default 'recorded'`;
- `reason text null`;
- `metadata jsonb not null default '{}'`;
- `created_at timestamptz not null default now()`.

O `DomainEvent` não será alterado para carregar contexto HTTP/infra. O adapter concreto deverá ser instanciado com contexto de execução e enriquecer a persistência sem contaminar o domínio.

## Índices permitidos no Lote 3

Somente índices operacionais determinísticos:

- foreign keys de alto uso;
- status;
- `canonical_key`;
- `(source_id, version)`;
- `(component_id, version)`;
- `(state, stage, status)`;
- `requester_id` em OPP;
- `opp_id` em eventos;
- `(aggregate_type, aggregate_id, occurred_at)` em auditoria.

Não criar:

- GIN full-text;
- vector index;
- IVFFlat;
- HNSW;
- materialized view de retrieval.

## Regras append-only

As seguintes tabelas não deverão aceitar UPDATE/DELETE em fluxos normais:

- `kf_source_permission_events`;
- `kf_production_order_events`;
- `kf_audit_events`.

A migration poderá usar trigger de proteção ou combinação de grants/RLS. O mecanismo final deve ser testado antes do merge.

## Concorrência

### Componente corrente

`kf_pedagogical_components.current_version_id` deve referenciar uma versão do próprio componente.

A implementação deve escolher constraint/trigger transacional verificável; não aceitar validação apenas em aplicação.

### Pacote curricular ativo

Índice único parcial deve impedir duas versões ativas simultâneas do mesmo `(state, stage)`.

### OPP

`version` será usada pelo adapter para controle otimista quando atualização for adicionada. O Lote 3 não introduzirá fila nem processamento concorrente.

## Compatibilidade com os contratos

Arrays lógicos que representam relações reais não serão persistidos duplicadamente:

- `PedagogicalComponentVersion.sourceEvidenceIds` deriva de `kf_component_source_evidence`;
- `PedagogicalComponentVersion.curriculumNodeIds` deriva de `kf_component_curriculum_links`;
- `CurriculumPackage.sourceVersionIds` deriva de `kf_curriculum_package_sources`.

O adapter deve reconstruir os contratos completos.

## Dados reais

Nenhum dado real será inserido pela migration.

Seeds de teste devem usar exemplos claramente sintéticos, como:

- fonte `WRTECH-SYNTHETIC-SOURCE-001`;
- componente `synthetic-philosophy-concept`;
- nó `SYN-MG-PHI-2-001`;
- OPP de usuário fictício do ambiente de teste.

## Compatibilidade com legado

Nenhuma FK será criada contra `curriculum_rag`.

Nenhum trigger será instalado em tabelas legadas.

Nenhuma policy existente será modificada.

Nenhum dado será migrado automaticamente de estruturas legadas para `kf_*`.

Qualquer migração de conteúdo legado será um projeto/lote separado com análise de procedência e licença.