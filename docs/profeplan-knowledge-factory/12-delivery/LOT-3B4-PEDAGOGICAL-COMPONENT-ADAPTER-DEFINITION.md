# Lote 3B.4 — PedagogicalComponentRepository

Data: 8 de agosto de 2026.

## Status

**Definição documental proposta para revisão humana. Nenhum adapter, mapper, teste de código, contrato, migration, RPC, RLS, wiring ou acesso a produção é autorizado por este documento.**

Base inspecionada: `main` no commit `ad168c6926cb404a5abda5109be4a42d4d0df30b`, após o squash merge do Pull Request nº 15.

## 1. Objetivo

Definir o menor caminho seguro para conectar as leituras já existentes da porta `PedagogicalComponentRepository` às tabelas canônicas `kf_*`, preservando domínio puro, client SYSTEM injetado, erros provider-neutral, observabilidade sanitizada, testes sintéticos e a fronteira separada de produção.

O Lote 3B.4 fica separado em:

- `3B.4A — leituras`, candidato a futuro PR de código após integração humana desta definição e nova autorização;
- `3B.4B — escritas transacionais`, bloqueado por `GAP-3B-02` e `GAP-3B-06`.

## 2. Evidências da inspeção

### 2.1 Porta atual

A porta expõe exatamente cinco métodos:

```ts
findById(id);
findVersion(componentId, version);
listEvidenceOrigins(componentVersionId);
saveComponent(component);
saveVersion(version);
```

Os três primeiros são exclusivamente de leitura. Os dois últimos são de escrita.

Nenhum consumidor operacional da porta ou de seus métodos foi encontrado na `main` inspecionada. A porta é exportada pelo pacote de domínio, seu nome participa do teste da lista das cinco portas e as políticas de domínio recebem componentes, versões e evidências já materializados; elas não invocam o repositório.

### 2.2 Contratos e invariantes

`PedagogicalComponent` exige, entre outros campos, `currentVersionId`, status, escopo escolar e timestamps.

`PedagogicalComponentVersion` exige `sourceEvidenceIds` e `curriculumNodeIds`; esses arrays não existem na linha `kf_component_versions` e precisam ser hidratados pelas relações físicas.

`EvidenceOrigin` exige:

- `id`;
- `version`;
- `componentVersionId`;
- `sourceId`;
- `sourceVersionId`;
- `sourceSegmentId`;
- `contribution`;
- `recordedAt`.

As políticas do domínio exigem coerência entre `component.currentVersionId`, `version.id` e `version.componentId`, além de evidência e alinhamento curricular para componentes aprovados. O adapter não reexecuta essas políticas; ele apenas reconstrói contratos válidos ou falha integralmente.

### 2.3 Schema físico relevante

| Tabela                          | Papel na porta                                             | Restrições relevantes                                                                   |
| ------------------------------- | ---------------------------------------------------------- | --------------------------------------------------------------------------------------- |
| `kf_pedagogical_components`     | registro canônico do componente                            | PK `id`, `canonical_key` único, `current_version_id` obrigatório                        |
| `kf_component_versions`         | versão do componente                                       | FK imediata para componente; unicidade `(component_id, version)` e `(component_id, id)` |
| `kf_component_source_evidence`  | entidade `EvidenceOrigin` e origem dos `sourceEvidenceIds` | FKs para versão do componente e cadeia coerente fonte → versão → segmento               |
| `kf_component_curriculum_links` | vínculo versão → nó curricular                             | PK `(component_version_id, curriculum_node_id)` e FKs para versão e nó                  |

A FK composta `(id, current_version_id) → kf_component_versions(component_id, id)` é `DEFERRABLE INITIALLY DEFERRED`. Ela permite que componente e primeira versão sejam criados na mesma transação, mas não torna requisições PostgREST independentes atômicas.

O corpus permanece deny-by-default para professores. O acesso futuro do adapter continua classificado como SYSTEM, com client já criado e injetado pelo composition root.

## 3. Lote 3B.4A — leituras

### 3.1 Escopo permitido do futuro PR

Somente:

- `findById(id)`;
- `findVersion(componentId, version)`;
- `listEvidenceOrigins(componentVersionId)`.

Não criar aliases, overloads, stubs de escrita, métodos auxiliares públicos ou operações não presentes na porta.

### 3.2 Fronteira de tipagem

A interface completa também contém os dois métodos de escrita bloqueados. Portanto, o futuro código 3B.4A não deverá declarar falsamente implementação integral de `PedagogicalComponentRepository` nem adicionar métodos de escrita que apenas lancem erro.

A classe read-only deverá ser verificável contra:

```ts
Pick<PedagogicalComponentRepository, 'findById' | 'findVersion' | 'listEvidenceOrigins'>;
```

Isso não altera a porta pública. A atribuibilidade à interface completa somente poderá ser exigida quando 3B.4B estiver formalmente resolvido e implementado.

### 3.3 Consultas e colunas

#### `findById(id)`

Tabela:

- `kf_pedagogical_components`.

Colunas explícitas:

- `id`;
- `version`;
- `canonical_key`;
- `title`;
- `component_type`;
- `school_component`;
- `grades`;
- `status`;
- `current_version_id`;
- `created_at`;
- `updated_at`.

Filtro obrigatório: `id`.

#### `findVersion(componentId, version)`

Leitura base em `kf_component_versions` com colunas explícitas:

- `id`;
- `version`;
- `component_id`;
- `summary`;
- `keywords`;
- `supersedes_version`;
- `approved_at`;
- `status`.

Filtros obrigatórios:

- `component_id = componentId`;
- `version = version`.

Hidratação de `sourceEvidenceIds`:

- tabela `kf_component_source_evidence`;
- selecionar somente `id`;
- filtrar por `component_version_id = versão encontrada.id`;
- ordenar por `id` ascendente;
- mapear os IDs na ordem retornada.

Hidratação de `curriculumNodeIds`:

- tabela `kf_component_curriculum_links`;
- selecionar somente `curriculum_node_id`;
- filtrar por `component_version_id = versão encontrada.id`;
- ordenar por `curriculum_node_id` ascendente;
- mapear os IDs na ordem retornada.

Não carregar `KnowledgeSource`, `SourceVersion`, `SourceSegment` ou `CurriculumNode` completos nesse método.

#### `listEvidenceOrigins(componentVersionId)`

Tabela:

- `kf_component_source_evidence`.

Colunas explícitas:

- `id`;
- `version`;
- `component_version_id`;
- `source_id`;
- `source_version_id`;
- `source_segment_id`;
- `contribution`;
- `recorded_at`.

Filtro obrigatório: `component_version_id`.

Ordenação determinística:

1. `recorded_at` ascendente;
2. `id` ascendente como desempate.

Cada linha deve reconstruir exatamente um `EvidenceOrigin`, com validação explícita do enum `contribution`, IDs, versão e timestamp.

### 3.4 Ausência, falha e retorno parcial

- `findById()` retorna `null` somente quando a linha principal está legitimamente ausente e o provider retorna `data: null` sem erro;
- `findVersion()` retorna `null` somente quando a linha base da versão está legitimamente ausente;
- arrays relacionais vazios são válidos para uma versão existente, especialmente em estados anteriores à aprovação;
- `listEvidenceOrigins()` retorna `[]` quando não há evidências;
- indisponibilidade, permissão negada, constraint, resposta malformada ou shape inválido nunca se convertem em `null` ou `[]`;
- se qualquer hidratação de `findVersion()` falhar ou vier malformada, o método falha integralmente e não devolve versão parcial;
- mais de uma linha em consulta logicamente única deve resultar em erro provider-neutral, nunca em escolha silenciosa.

Usar a taxonomia já aprovada de `KnowledgeFactoryPersistenceError`. Detalhes Supabase/PostgREST, SQLSTATE, URL, headers, tokens, query e payload não atravessam a borda.

### 3.5 Consistência das leituras

Leituras sequenciais são aceitáveis para 3B.4A porque:

- não existe consumidor operacional atual que exija snapshot forte;
- nenhuma escrita do `PedagogicalComponentRepository` está autorizada ou integrada;
- o retorno parcial é proibido;
- a ausência de snapshot será documentada e testada como limite, não mascarada.

O adapter não prometerá que linha base, evidências e vínculos curriculares pertencem ao mesmo snapshot PostgreSQL.

Nenhuma RPC ou read model é necessária para 3B.4A. Se surgir consumidor cuja decisão exija consistência forte sob concorrência, a leitura composta deverá ser suspensa para esse uso até ADR, migration e RPC/read model específicos.

### 3.6 Client, privilégios e dependências

- usar `SupabaseSystemContext` já existente;
- receber client SYSTEM por injeção;
- não chamar `createClient()`;
- não ler `process.env`;
- não importar `api/` nem `supabaseAdmin`;
- não usar REQUESTER context;
- não criar dependência nova;
- não mudar grant, RLS ou migration;
- não usar Supabase hospedado ou produção.

### 3.7 Observabilidade

Usar `PersistenceLogger` já aprovado.

Campos permitidos:

- operation;
- adapter;
- durationMs;
- outcome;
- aggregateType;
- aggregateId quando conhecido;
- correlationId;
- rowCount;
- errorCode sanitizado em falha.

Não registrar título, resumo, keywords, conteúdo de fonte, IDs de evidência em lote, texto pedagógico, client, secret, JWT, erro bruto ou payload integral.

### 3.8 Testes unitários obrigatórios no futuro PR

1. classe atribuível ao `Pick` read-only aprovado e superfície pública restrita aos três métodos;
2. mappers SQL → domínio para componente, versão e `EvidenceOrigin`;
3. validação de enums, arrays, opcionais, IDs e timestamps;
4. `findById()` usa tabela, colunas e filtro corretos;
5. `findVersion()` filtra por componente e versão;
6. hidrata `sourceEvidenceIds` e `curriculumNodeIds` em ordem determinística;
7. ausência da linha base retorna `null` e não inicia hidratações;
8. arrays relacionais vazios são aceitos;
9. falha ou shape inválido em qualquer hidratação rejeita o método sem retorno parcial;
10. `listEvidenceOrigins()` filtra e ordena por `recorded_at`, `id`;
11. lista vazia é válida; `data: null` ou linha inválida gera `INVALID_RESPONSE`;
12. erros de provider são traduzidos para a taxonomia aprovada;
13. rede e timeout resultam em `UNAVAILABLE`;
14. telemetria contém somente allowlist e redaction;
15. listas de colunas não usam `SELECT *`;
16. verificação estática impede `any` generalizado, client interno, env, import de `api/`, RPC e qualquer escrita.

### 3.9 Testes de integração obrigatórios no futuro PR

No Supabase descartável do `Knowledge Factory DB CI`, com fixtures exclusivamente sintéticas:

1. criar diretamente no setup sintético a cadeia fonte → versão → segmento;
2. criar pacote e nós curriculares sintéticos;
3. criar componentes, versões, evidências e vínculos de pelo menos dois componentes;
4. comprovar `findById()` e ausência legítima;
5. comprovar `findVersion()` com IDs hidratados, isolados e ordenados;
6. comprovar que evidências ou nós de outro componente não vazam;
7. comprovar arrays vazios para versão sintética sem vínculos;
8. comprovar `listEvidenceOrigins()` completo, isolado e determinístico;
9. confirmar que o adapter não executa escrita;
10. confirmar que nenhuma credencial ou dado hospedado é usado e que o ambiente é destruído.

As inserções de fixture pertencem somente ao setup de integração; não ampliam a superfície do adapter.

### 3.10 Arquivos previstos para o futuro PR de código

```text
packages/knowledge-factory-supabase/
├── src/
│   ├── component/
│   │   ├── pedagogical-component.mapper.ts
│   │   └── supabase-pedagogical-component.repository.ts
│   └── index.ts
└── test/
    ├── pedagogical-component.repository.test.mjs
    └── pedagogical-component.integration.test.mjs
```

Ajuste mínimo do workflow somente será permitido se necessário para incluir a nova suíte no comando já existente. Não criar outro stack.

### 3.11 Critérios de aceite do 3B.4A

3B.4A poderá ser considerado pronto para revisão quando:

1. esta definição estiver integrada por decisão humana;
2. houver nova autorização explícita para código e branch nova baseada na `main` integrada;
3. somente os três métodos de leitura estiverem implementados;
4. nenhum stub ou escrita existir;
5. mappers, filtros, hidratações, ordenações e tratamento integral de falha estiverem comprovados;
6. typecheck, unitários, integração descartável, CI geral e DB CI aplicável estiverem verdes;
7. nenhuma mudança de contrato, migration, RPC, RLS, API, frontend ou produção existir;
8. um checkpoint específico registrar evidências e próximo gate humano.

Encerrar 3B.4A não encerra 3B.4, não resolve 3B.4B e não conclui integralmente as Stories de componentes.

## 4. Lote 3B.4B — escritas transacionais

### 4.1 Estado

**Bloqueado.**

Bloqueios ativos:

- `GAP-3B-02` — componente, primeira versão e `current_version_id` exigem atomicidade real;
- `GAP-3B-06` — a superfície contratual de escrita não representa integralmente a persistência de evidências e vínculos.

### 4.2 Operações físicas atravessadas

O lifecycle completo pode envolver:

- `kf_pedagogical_components`;
- `kf_component_versions`;
- `kf_component_source_evidence`;
- `kf_component_curriculum_links`.

Criação inicial deve manter, como uma unidade:

1. componente;
2. primeira versão pertencente ao componente;
3. `current_version_id` apontando para essa versão;
4. evidências de origem completas;
5. vínculos curriculares;
6. rollback integral em qualquer falha.

### 4.3 Efeito da FK deferrable

A FK deferrable resolve apenas a circularidade física durante uma transação PostgreSQL. O fluxo viável insere o componente com o ID da primeira versão, insere a versão pertencente ao mesmo componente e valida a FK até o commit.

Ela não:

- cria transação entre chamadas HTTP;
- persiste evidências ou vínculos;
- define idempotência;
- decide insert versus update;
- autoriza retry;
- corrige falha parcial fora da transação.

### 4.4 `saveComponent()`

Uma atualização isolada de linha existente pode ser fisicamente simples, mas a semântica pública de `saveComponent()` não diferencia criação de atualização. Uma criação isolada não satisfaz a FK obrigatória de `current_version_id` ao fim da operação e não representa o lifecycle completo.

Portanto, `saveComponent()` não será tratado como seguro isoladamente enquanto não houver decisão contratual sobre comandos de criação, atualização e troca de versão corrente.

### 4.5 `saveVersion()` e GAP-3B-06

Persistir fielmente `PedagogicalComponentVersion` exige tratar:

- a linha de versão;
- `curriculumNodeIds` em `kf_component_curriculum_links`;
- `sourceEvidenceIds` em `kf_component_source_evidence`.

Entretanto, `sourceEvidenceIds` contém somente IDs e a porta não oferece operação para criar `EvidenceOrigin`, cujos demais campos são obrigatórios. Persistir evidência por função lateral, acesso direto externo ou método inventado violaria contract-first.

Também não está definido se `saveVersion()` é insert-only, upsert ou substituição integral dos vínculos. O schema não concede DELETE ao `service_role`, portanto sincronização por apagar e recriar não pode ser presumida.

Nenhuma dessas lacunas será resolvida neste documento por alteração de contrato implícita.

### 4.6 Decisões ainda necessárias

Antes de 3B.4B será obrigatório decidir humanamente:

1. comando de aplicação para criação completa do agregado;
2. payload completo, incluindo `EvidenceOrigin` e vínculos curriculares;
3. semântica separada para criar, atualizar e promover versão corrente;
4. política de mutação dos vínculos: aditiva, substitutiva ou versionada;
5. idempotency key e comportamento de retry;
6. validações de estado esperado e conflito concorrente;
7. função PostgreSQL/RPC estreita e específica;
8. `SECURITY DEFINER`, `search_path` e privilégios mínimos;
9. migration isolada;
10. testes de sucesso, falha intermediária, rollback e repetição idempotente;
11. eventual mudança da porta/contratos, em PR documental e contratual separado;
12. gate humano próprio para implementação e outro para produção.

### 4.7 Critérios futuros para encerrar os gaps

`GAP-3B-02` somente poderá ser encerrado quando o comando transacional aprovado comprovar criação e promoção de versão com rollback integral no Supabase descartável e o PR correspondente for integrado humanamente.

`GAP-3B-06` somente poderá ser encerrado quando a superfície contratual aprovada representar sem side-channel a persistência de evidências e vínculos, com semântica de mutação e idempotência explícitas, testes e integração humana.

Não criar `GenericUnitOfWork`, `TransactionManager` fictício, compensação silenciosa, pseudo-transação por Promises ou RPC genérica.

## 5. Riscos e contenções

- leitura composta sem snapshot: aceita apenas em 3B.4A, sem promessa de consistência forte e sem retorno parcial;
- adapter parcial confundido com porta completa: contido por `Pick` explícito e nomenclatura documental de fatia read-only;
- evidência persistida por fora da porta: proibida;
- vínculos incompletos ou removidos silenciosamente: 3B.4B bloqueado;
- componente órfão ou `current_version_id` inconsistente: 3B.4B exige transação real;
- vazamento de conteúdo pedagógico ou secrets: mappers, erros e telemetria sanitizados;
- produção acidental: nenhuma conexão hospedada, migration, RLS ou wiring.

## 6. Itens expressamente excluídos

- implementação de adapter ou mapper;
- alteração de contratos TypeScript;
- testes de código;
- migration, função PostgreSQL, RPC ou RLS;
- qualquer escrita;
- Supabase de produção ou `service_role` real;
- API, frontend ou composition wiring;
- ingestão, fontes reais, componentes reais ou currículo real;
- PNLD;
- retrieval, embeddings, agentes ou Sócrates 2 executável;
- Lote 3B.5;
- merge automático.

## 7. Próximo gate humano

O próximo gate é revisar este PR documental e decidir entre solicitar ajustes, rejeitar/adiar ou autorizar seu squash merge.

Somente após integração humana poderá ser aberta, em nova conversa e mediante nova autorização explícita, a branch de implementação do Lote 3B.4A. O Lote 3B.4B permanecerá bloqueado.
