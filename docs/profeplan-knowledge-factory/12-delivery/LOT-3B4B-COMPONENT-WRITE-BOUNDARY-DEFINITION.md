# Lote 3B.4B — Fronteira contratual e transacional das escritas de componentes

Data: 8 de agosto de 2026.

## Status

**Definição documental integrada pelo Pull Request nº 19 no commit `d9838ef290522aba6dba4e104a03420dd12192fb`. O 3B.4B.1 foi integrado pelo Pull Request nº 20 no commit `d481d998603e9a335edb308cfdb82b7868289cea`. O 3B.4B.2 foi integrado pelo Pull Request nº 21 no commit `fdf9bfdb28bea5dc85f9ed6b11913dd69b94cbd1`. A autorização atual alcança somente o 3B.4B.3 — adapter Supabase de comandos; wiring, produção e Lote 3B.5 permanecem bloqueados.**

Base inspecionada para o 3B.4B.3: `main` no commit
`fdf9bfdb28bea5dc85f9ed6b11913dd69b94cbd1`, após o squash merge do Pull Request nº 21.

O Lote 3B.4A, o 3B.4B.1 e o 3B.4B.2 permanecem integrados. O 3B.4B.3 avançou em branch própria
para revisão humana. `GAP-3B-02` e `GAP-3B-06` continuam ativos até que o adapter seja aprovado no
Supabase descartável e integrado consumindo exclusivamente as quatro RPCs transacionais.

## 1. Objetivo

Definir a fronteira de escrita necessária para persistir um componente pedagógico como agregado coerente, incluindo:

- componente;
- versões;
- evidências de origem completas;
- vínculos curriculares;
- versão corrente;
- transições de estado;
- idempotência;
- retry seguro;
- concorrência otimista;
- rollback integral.

A decisão elimina a ambiguidade dos métodos genéricos `saveComponent()` e `saveVersion()` sem antecipar sua implementação.

## 2. Evidências canônicas reconciliadas

### 2.1 Porta no momento da definição documental

Quando esta definição foi aprovada, `PedagogicalComponentRepository` expunha três leituras e duas
escritas genéricas:

```ts
findById(id);
findVersion(componentId, version);
listEvidenceOrigins(componentVersionId);
saveComponent(component);
saveVersion(version);
```

`saveComponent()` não distingue criação, alteração de metadados, transição de estado ou promoção da versão corrente.

`saveVersion()` recebe apenas `PedagogicalComponentVersion`. O objeto contém IDs de evidências, mas não contém os campos obrigatórios de `EvidenceOrigin`. Logo, a porta não consegue expressar a gravação integral do agregado sem um side-channel.

O 3B.4B.1 removeu os dois `save*`, publicou os quatro comandos explícitos, separou leitura de
comando e elevou o contrato para `2.0.0`.

### 2.2 Contratos atuais

`PedagogicalComponent` exige `currentVersionId` não vazio.

`PedagogicalComponentVersion` contém:

- `componentId`;
- conteúdo resumido e palavras-chave;
- `sourceEvidenceIds`;
- `curriculumNodeIds`;
- versão anterior opcional;
- estado e aprovação.

`EvidenceOrigin` contém a cadeia completa:

- versão do componente;
- fonte;
- versão da fonte;
- segmento;
- tipo de contribuição;
- instante de registro.

As políticas do domínio exigem coerência entre componente, versão corrente, evidências, fontes e currículo. A política de lifecycle também define transições de estado permitidas.

### 2.3 Schema atual

O lifecycle atravessa quatro tabelas:

| Tabela                          | Responsabilidade                         |
| ------------------------------- | ---------------------------------------- |
| `kf_pedagogical_components`     | identidade e ponteiro da versão corrente |
| `kf_component_versions`         | conteúdo e estado de cada versão         |
| `kf_component_source_evidence`  | evidências completas da versão           |
| `kf_component_curriculum_links` | conjunto de nós curriculares da versão   |

A FK composta entre componente e versão corrente é `DEFERRABLE INITIALLY DEFERRED`. Ela resolve a circularidade somente dentro de uma transação PostgreSQL real.

O `service_role` possui hoje DML direto nas quatro tabelas, exceto `DELETE`. Esse estado não é suficiente para garantir que futuras escritas passem exclusivamente pelas transações aprovadas.

## 3. Decisões arquitetônicas aprováveis

### DEC-3B4B-01 — Separar leitura e comando

A porta deverá ser decomposta conceitualmente em:

```ts
PedagogicalComponentReadRepository;
PedagogicalComponentCommandRepository;
PedagogicalComponentRepository;
```

`PedagogicalComponentRepository` poderá compor as duas capacidades. O adapter já integrado continuará atribuível somente à capacidade read-only até que o adapter de comando exista.

Os métodos `saveComponent()` e `saveVersion()` deverão ser removidos da superfície canônica no futuro PR contratual. Não serão mantidos aliases, overloads, stubs, wrappers de compatibilidade ou métodos depreciados que permitam escrita incompleta.

Essa é uma alteração breaking do contrato da Knowledge Factory. O futuro PR contratual deverá atualizar `KNOWLEDGE_FACTORY_CONTRACT_VERSION` de `1.1.0` para `2.0.0`, depois de comprovar que não há consumidor operacional dependente dos dois métodos removidos.

### DEC-3B4B-02 — Quatro comandos explícitos

A futura porta de comando deverá expor somente:

```ts
createComponentAggregate(command);
appendComponentVersion(command);
transitionComponentVersionStatus(command);
promoteComponentVersion(command);
```

Não haverá `save`, `upsert`, `sync`, `patch` ou `update` genérico.

### DEC-3B4B-03 — Atualização por evolução, não por sobrescrita

No MVP, os seguintes campos do componente são imutáveis após a criação:

- `id`;
- `canonicalKey`;
- `componentType`;
- `schoolComponent`;
- `grades`;
- `createdAt`.

Mudança de conteúdo, escopo pedagógico, título material ou alinhamento será representada por nova versão, seguida de validação e eventual promoção.

O estado do componente deriva do estado da versão corrente e poderá ser sincronizado apenas pelas operações explícitas de transição ou promoção.

Não haverá edição destrutiva de uma versão já criada. Correções de conteúdo, evidência ou currículo exigem nova versão.

### DEC-3B4B-04 — Evidências e currículo são snapshot imutável da versão

Cada versão receberá, no momento de sua criação:

- o conjunto completo de `EvidenceOrigin`;
- o conjunto completo de `curriculumNodeIds`.

Esses conjuntos pertencem à versão e não serão sincronizados posteriormente. Portanto:

- a semântica não é aditiva sobre versão existente;
- a semântica não é substitutiva por `DELETE + INSERT`;
- a semântica é versionada e insert-only;
- conjunto vazio é permitido somente enquanto as regras de estado aceitarem versão ainda não aprovada;
- uma versão `approved` exige pelo menos uma evidência e um vínculo curricular.

`PedagogicalComponentVersion.sourceEvidenceIds` deverá corresponder exatamente, sem duplicatas, aos IDs dos objetos `EvidenceOrigin` enviados no mesmo comando.

### DEC-3B4B-05 — Idempotência por `commandId`

Todo comando de escrita deverá conter um `commandId` UUID gerado pela camada de aplicação e reutilizado em retries.

O banco manterá um recibo mínimo por comando, contendo:

- `command_id`;
- operação;
- fingerprint canônico do payload validado;
- `component_id`;
- `component_version_id` quando aplicável;
- instante de commit;
- resultado sanitizado.

Regras:

- mesmo `commandId` e mesmo fingerprint: retornar o mesmo resultado como replay, sem nova mutação;
- mesmo `commandId` e fingerprint diferente: falhar com conflito;
- falha antes do commit: nenhum recibo nem linha parcial permanece;
- payload bruto, resumo, título, keywords ou conteúdo pedagógico não serão armazenados no recibo.

O fingerprint será calculado no PostgreSQL a partir do payload validado; não será aceito como verdade um hash fornecido pelo cliente.

### DEC-3B4B-06 — Concorrência otimista e comparação de estado

Os comandos que dependem de estado existente deverão declarar a expectativa lida pelo chamador.

- `appendComponentVersion`: `expectedCurrentVersionId`;
- `transitionComponentVersionStatus`: `expectedStatus`;
- `promoteComponentVersion`: `expectedCurrentVersionId` e `expectedComponentUpdatedAt`.

Se a expectativa não corresponder ao estado bloqueado dentro da transação, a operação falhará com conflito provider-neutral. Não haverá last-write-wins silencioso.

As funções usarão locks de linha somente sobre o agregado necessário e em ordem determinística. Não será adotado lock global nem `TransactionManager` de aplicação.

### DEC-3B4B-07 — Uma RPC estreita por comando

Cada comando terá uma função PostgreSQL específica:

- `kf_create_pedagogical_component_aggregate`;
- `kf_append_pedagogical_component_version`;
- `kf_transition_pedagogical_component_version_status`;
- `kf_promote_pedagogical_component_version`.

Cada função receberá `p_command_id uuid` e um payload JSONB com schema fechado e validado para aquela operação. O uso de JSONB é apenas transporte de estruturas aninhadas; campos desconhecidos, ausentes, duplicados ou de tipo incorreto serão rejeitados.

Não haverá RPC genérica de repositório, SQL dinâmico, nome de tabela vindo do cliente ou função que execute múltiplos tipos de comando.

### DEC-3B4B-08 — Segurança das funções

As futuras funções deverão:

- ser `SECURITY DEFINER`;
- ter owner técnico controlado;
- usar `SET search_path = pg_catalog, public`;
- qualificar objetos de banco explicitamente;
- revogar `EXECUTE` de `PUBLIC`, `anon` e `authenticated`;
- conceder `EXECUTE` somente a `service_role`;
- validar todas as entradas antes da primeira mutação;
- não confiar em claims ou IDs vindos do payload para elevar privilégio;
- retornar apenas recibo mínimo e dados necessários ao mapper.

A migration deverá revogar `INSERT` e `UPDATE` diretos de `service_role` nas quatro tabelas do agregado. `SELECT` permanecerá para o adapter read-only. As escritas do agregado deverão ocorrer exclusivamente pelas RPCs aprovadas.

RLS continuará habilitado. Não serão criadas policies de escrita para professor, `authenticated` ou `anon`.

## 4. Contratos dos comandos

### 4.1 Criação do agregado

```ts
interface CreatePedagogicalComponentAggregateCommand {
  commandId: EntityId;
  component: PedagogicalComponent;
  initialVersion: PedagogicalComponentVersion;
  evidenceOrigins: readonly EvidenceOrigin[];
}
```

Invariantes mínimas:

- IDs são UUIDs válidos e fornecidos antes da chamada;
- `component.currentVersionId === initialVersion.id`;
- `initialVersion.componentId === component.id`;
- `initialVersion.sourceEvidenceIds` é exatamente o conjunto de IDs de `evidenceOrigins`;
- toda evidência aponta para `initialVersion.id`;
- arrays não contêm duplicatas;
- toda cadeia fonte → versão → segmento existe e é coerente;
- todos os nós curriculares existem;
- `canonicalKey` ainda não existe;
- componente e versão começam com estados coerentes;
- versão aprovada não pode nascer sem evidência e currículo.

A RPC deverá inserir componente, primeira versão, evidências, vínculos e recibo na mesma transação. A FK deferrable será validada no commit. Qualquer falha reverte tudo.

### 4.2 Inclusão de nova versão

```ts
interface AppendPedagogicalComponentVersionCommand {
  commandId: EntityId;
  expectedCurrentVersionId: EntityId;
  version: PedagogicalComponentVersion;
  evidenceOrigins: readonly EvidenceOrigin[];
}
```

Invariantes adicionais:

- o componente existe;
- a versão ainda não existe por ID nem por `(componentId, version)`;
- o ponteiro corrente coincide com `expectedCurrentVersionId`;
- `supersedesVersion`, quando informado, identifica a versão corrente esperada;
- a nova versão, suas evidências e seus vínculos são inseridos de forma atômica;
- o ponteiro corrente não é alterado por este comando.

### 4.3 Transição de estado

```ts
interface TransitionPedagogicalComponentVersionStatusCommand {
  commandId: EntityId;
  componentId: EntityId;
  componentVersionId: EntityId;
  expectedStatus: PedagogicalComponentStatus;
  toStatus: PedagogicalComponentStatus;
  occurredAt: ISODateTime;
}
```

Regras:

- a versão pertence ao componente;
- o estado atual coincide com `expectedStatus`;
- a transição pertence a `COMPONENT_TRANSITIONS`;
- a camada de aplicação deverá executar a política de domínio antes da persistência;
- a RPC repetirá a validação estrutural da matriz como defesa em profundidade;
- transição para `approved` exige evidência e currículo persistidos;
- `approvedAt` será preenchido com `occurredAt` na primeira aprovação;
- se a versão for a corrente, o estado do componente e `updatedAt` serão atualizados na mesma transação;
- nenhuma transição apagará evidências, vínculos ou o histórico de aprovação.

A futura suíte deverá manter um teste de paridade entre a matriz TypeScript e a matriz aplicada pela função SQL, evitando divergência silenciosa.

### 4.4 Promoção de versão corrente

```ts
interface PromotePedagogicalComponentVersionCommand {
  commandId: EntityId;
  componentId: EntityId;
  targetVersionId: EntityId;
  expectedCurrentVersionId: EntityId;
  expectedComponentUpdatedAt: ISODateTime;
  occurredAt: ISODateTime;
}
```

Regras:

- componente e versão alvo existem;
- a versão alvo pertence ao componente;
- versão alvo está `approved` e possui evidência e currículo;
- ponteiro e timestamp atuais coincidem com as expectativas;
- `currentVersionId`, estado do componente e `updatedAt` são alterados atomicamente;
- a versão anteriormente corrente não é modificada implicitamente;
- eventual transição da versão anterior para `superseded` exige comando explícito e política de domínio própria;
- promover novamente o mesmo alvo com o mesmo `commandId` é replay idempotente;
- promover alvo já corrente com outro `commandId` retorna conflito ou no-op explícito conforme resultado definido no futuro contrato, nunca sucesso ambíguo. A decisão aprovada para o MVP é conflito.

## 5. Resultado e erros da porta

Todos os comandos retornarão um recibo provider-neutral:

```ts
interface PedagogicalComponentWriteReceipt {
  commandId: EntityId;
  operation: PedagogicalComponentWriteOperation;
  componentId: EntityId;
  componentVersionId?: EntityId;
  replayed: boolean;
  committedAt: ISODateTime;
}
```

O adapter deverá traduzir falhas para a taxonomia existente, ampliada somente se necessário por PR contratual explícito. No mínimo, deverão permanecer distinguíveis:

- entrada inválida;
- ausência legítima de agregado alvo;
- conflito de idempotência ou concorrência;
- violação de constraint;
- resposta inválida;
- indisponibilidade ou timeout.

Nenhum SQLSTATE, mensagem PostgreSQL, nome interno de função, payload, segredo ou erro bruto atravessará a borda.

## 6. Sequência de implementação futura

O 3B.4B será dividido em três sublotes, cada um com branch, PR e gate humano próprios:

### 3B.4B.1 — Contratos e porta — integrado

- criar tipos de comando e recibo;
- decompor a porta read/command;
- remover os dois `save*` genéricos;
- atualizar a versão contratual para `2.0.0`;
- testar invariantes de shape, exports e ausência de consumidores quebrados;
- nenhuma migration, RPC ou adapter de escrita.

### 3B.4B.2 — Migration e RPCs — integrado

- criar tabela mínima de recibos idempotentes;
- criar as quatro funções estreitas;
- ajustar grants das tabelas e funções;
- preservar RLS deny-by-default;
- criar rollback guardado;
- testar atomicidade, falha intermediária, retry, replay, fingerprint divergente e concorrência no Supabase descartável;
- nenhuma integração com produção e nenhum wiring de aplicação.

### 3B.4B.3 — Adapter Supabase de comando — em revisão

- implementar a porta de comando usando somente as RPCs;
- reutilizar `SupabaseSystemContext` injetado;
- mapear payloads e recibos explicitamente;
- aplicar erros provider-neutral e telemetria allowlisted;
- testar sem rede e no Supabase descartável;
- não criar fallback para DML direto;
- não ativar API, frontend ou produção.

O Lote 3B.4 somente poderá ser considerado concluído após integração humana dos três sublotes e checkpoint pós-merge próprio.

## 7. Testes obrigatórios futuros

### Contrato e domínio

- shape e imutabilidade dos quatro comandos;
- correspondência exata entre IDs de evidência e objetos completos;
- ausência dos métodos genéricos `save*`;
- compatibilidade do adapter read-only com a nova porta de leitura;
- transições aceitas e rejeitadas;
- contrato `2.0.0` exportado corretamente.

### Banco descartável

- criação integral bem-sucedida;
- falha em cada etapa física com rollback total;
- nenhum componente órfão;
- nenhum ponteiro corrente inválido;
- nenhum conjunto parcial de evidência ou currículo;
- append sem promoção;
- aprovação sem evidência ou currículo rejeitada;
- promoção com compare-and-set;
- conflito concorrente determinístico;
- mesmo comando e mesmo payload produz replay;
- mesmo comando e payload diferente produz conflito;
- corrida simultânea do mesmo comando produz um commit lógico;
- DML direto por `service_role` negado;
- `anon` e `authenticated` sem execução;
- rollback remove funções, recibos e grants sem afetar o schema anterior;
- reaplicação limpa e DB lint verde.

### Adapter

- uma RPC explícita por método;
- nenhuma chamada `.insert()`, `.update()`, `.upsert()` ou `.delete()`;
- nenhuma leitura de ambiente ou criação interna de client;
- payload sem campos extras;
- recibo integralmente validado;
- retry não duplica linhas;
- erros e logs sanitizados;
- fixtures exclusivamente sintéticas;
- CI geral e DB CI verdes.

## 8. Estado dos GAPs

### GAP-3B-02

Permanece ativo. O sublote 3B.4B.2 integrou a contenção escolhida — transação PostgreSQL real,
RPCs estreitas e rollback integral. O 3B.4B.3 implementa o consumo exclusivo dessa fronteira, mas
seu encerramento ainda depende de DB CI e integração humana.

Critério de encerramento: integração humana do sublote 3B.4B.2 com testes de atomicidade, falha intermediária, concorrência e rollback verdes, seguida da integração do adapter de comando que usa exclusivamente essas RPCs.

### GAP-3B-06

Permanece ativo. O contrato `2.0.0` já transporta `EvidenceOrigin` completo e vínculos versionados,
mas o encerramento depende do adapter 3B.4B.3 persistir o agregado sem side-channel.

Critério de encerramento: integração humana do contrato 2.0 e do adapter que persiste o agregado sem side-channel, com semântica insert-only versionada, idempotência e testes verdes.

Nenhum gap é declarado encerrado por esta etapa documental.

## 9. Itens expressamente excluídos da definição documental original

- alteração de TypeScript, SQL ou workflow;
- implementação de adapter, mapper, migration, função ou RPC;
- alteração de tabela, constraint, índice, grant, policy ou RLS;
- acesso a Supabase hospedado;
- secrets ou dados pedagógicos reais;
- DML em produção;
- API, frontend ou composition root;
- ingestão, PNLD, embeddings, retrieval ou agentes;
- Lote 3B.5;
- encerramento da Fase B;
- merge automático.

## 10. Critérios históricos de aceite da definição

Esta definição estará pronta para integração documental somente se:

1. os quatro comandos estiverem explicitamente delimitados;
2. os dois métodos `save*` forem formalmente rejeitados para o contrato futuro;
3. evidências completas e vínculos estiverem dentro do payload atômico;
4. atualização for definida por nova versão, sem sobrescrita destrutiva;
5. idempotência, retry e concorrência tiverem semântica determinística;
6. RPCs, grants, `SECURITY DEFINER` e `search_path` estiverem delimitados;
7. os três sublotes e seus gates estiverem separados;
8. os testes futuros cubrirem rollback, replay e corrida;
9. GAP-3B-02 e GAP-3B-06 permanecerem ativos;
10. nenhuma implementação ou produção tiver sido iniciada.

## 11. Próximo gate humano

O próximo gate é revisar o Pull Request draft do 3B.4B.3 — adapter Supabase de comandos — e decidir
entre solicitar ajustes, rejeitar/adiar ou autorizar seu squash merge.

Mesmo após eventual integração do 3B.4B.3, wiring, aplicação de migrations no Supabase hospedado,
produção e início do Lote 3B.5 exigirão autorizações explícitas próprias.
