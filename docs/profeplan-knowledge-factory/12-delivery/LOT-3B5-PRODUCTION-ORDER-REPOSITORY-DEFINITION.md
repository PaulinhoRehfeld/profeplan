# Lote 3B.5 — Fronteira do ProductionOrderRepository

Data: 11 de agosto de 2026.

## Status

**Concluído. A definição documental e os quatro sublotes foram integrados pelos Pull Requests nº 24
a 28. O `GAP-3B-03` foi encerrado após o checkpoint pós-merge; `GAP-3B-07` permanece ativo e
contido. Nenhum wiring, Supabase hospedado ou produção está autorizado por continuidade.**

Base canônica inspecionada:

- repositório: `PaulinhoRehfeld/profeplan`;
- branch-base: `main`;
- commit-base: `d54f092e451d6663404e4b747c56196c9bd2536d`;
- origem da base: squash merge do Pull Request nº 23;
- branch documental: `agent/knowledge-factory-lot-3b5-definition`.
- integração documental: Pull Request nº 24;
- commit de integração: `dc52b843094236207ab7aa22b12cbb97f02aab11`;
- branch técnica do 3B.5.1: `agent/knowledge-factory-lot-3b5-1-contracts`.
- integração do 3B.5.1: Pull Request nº 25;
- commit de integração do 3B.5.1: `a25acd014c213ce7552105a538fea5f0bd07037e`;
- branch técnica do 3B.5.2: `feat/knowledge-factory-supabase-production-order-requester-readonly`.
- integração do 3B.5.2: Pull Request nº 26;
- commit de integração do 3B.5.2: `b0d83c1b0a27dd20ca9bba891297c7453bb6e5fa`;
- branch técnica do 3B.5.3: `feat/knowledge-factory-production-order-write-rpcs`.
- integração do 3B.5.3: Pull Request nº 27;
- commit de integração do 3B.5.3: `e223de4d02b39df748c3063d0e495f528c025e9d`;
- branch técnica do 3B.5.4: `feat/knowledge-factory-production-order-command-adapters`;
- integração do 3B.5.4: Pull Request nº 28;
- commit de integração do 3B.5.4: `1429107facf816a9a45c12b1ce3ed5cb3c7b6722`;
- encerramento pós-merge: `00-governance/CONTINUITY-CHECKPOINT-031.md`.

Os Lotes 3B.4 e 3B.5 estão encerrados no estado proposto pelo Checkpoint 031. Requester isolation e
a coerência da timeline permanecem controles obrigatórios mesmo após o encerramento do
`GAP-3B-03`. `GAP-3B-04`, `GAP-3B-05` e `GAP-3B-07` permanecem fora do escopo desta conclusão.

## 1. Objetivo

Definir a menor fronteira segura para persistir e consultar Ordens de Produção Pedagógica — OPPs —
sem permitir:

- leitura de OPP pertencente a outro requester;
- criação de OPP sem evento `created` correspondente;
- transição de estado sem evento append-only correspondente;
- avanço da máquina de estados por DML direto ou RPC pública;
- pseudo-transação por chamadas PostgREST independentes;
- duplicidade por retry;
- last-write-wins silencioso;
- uso de `service_role` como substituto do requester nas leituras privadas;
- declaração indevida de conclusão integral das Stories de OPP.

## 2. Evidências canônicas reconciliadas

### 2.1 Porta atual

`ProductionOrderRepository` expõe hoje:

```ts
findById(id);
save(order);
appendEvent(event);
listEvents(oppId);
```

`save(order)` mistura criação e transição. `appendEvent(event)` é uma segunda chamada independente.
Logo, a porta permite expressar fisicamente o estado que `GAP-3B-03` proíbe: OPP atualizada sem
evento, ou evento inserido sem a transição correspondente.

Não foram identificados consumidores operacionais desses dois métodos de escrita. A suíte atual
verifica a existência nominal da porta, mas não há adapter, API ou wiring de OPP integrado.

### 2.2 Contratos atuais do domínio

`PedagogicalProductionOrder` contém:

- identidade e versão;
- `requesterId`;
- perfil de agente e pacote curricular;
- tipo de produto, tema e duração opcional;
- estado;
- timestamps de criação e atualização.

`OppEvent` contém:

- identidade e versão;
- OPP;
- tipo do evento;
- estado anterior opcional e estado seguinte;
- motivo opcional;
- instante de ocorrência.

A máquina atual admite os estados:

```text
requested → scoped → retrieving → assembling → validating → ready
     │          │           │            │            │
     └──────────┴───────────┴────────────┴────────────┴→ blocked/failed
                           └───────────────→ insufficient
```

As políticas de domínio adicionam gates pedagógicos, por exemplo suficiência antes de montagem e
ausência de finding `must` aberto antes de `ready`.

### 2.3 Banco, grants e RLS atuais

O schema já possui:

- `kf_production_orders`;
- `kf_production_order_events`;
- trigger append-only contra `UPDATE` e `DELETE` de eventos;
- RLS de leitura por `requester_id = auth.uid()`;
- RLS de leitura de eventos por ownership da OPP pai;
- INSERT autenticado de OPP própria apenas em `requested`;
- nenhuma policy de UPDATE/DELETE para professor;
- nenhuma permissão direta de INSERT de evento para professor.

O estado atual ainda permite que `authenticated` insira uma OPP `requested` sem o evento `created`.
Também concede DML de OPP/evento ao `service_role`. Esses grants foram preparatórios; não são a
fronteira final do adapter.

### 2.4 Contrato normativo não materializado

O snapshot aprovado no commit imutável
`PaulinhoRehfeld/profeplan_v5@cb36d71b1533fe7fa022c1aedca2c8790ab69692` define uma OPP mais
rica do que o contrato físico atual, incluindo contexto de turma, metodologia, inclusão, atores,
sequência de eventos, correlação, causação, tentativas, entrega e linhagem.

O 3B.5 conecta somente a fatia mínima já materializada no domínio e no schema. Ele não substitui,
reduz nem declara integralmente implementado o contrato normativo. Essa diferença é registrada como
`GAP-3B-07`.

## 3. Decisões arquitetônicas propostas

### DEC-3B5-01 — Separar leitura, solicitação e transição

A porta será decomposta em capacidades explícitas:

```ts
ProductionOrderReadRepository;
ProductionOrderRequestRepository;
ProductionOrderTransitionRepository;
ProductionOrderRepository;
```

Responsabilidades:

- `ReadRepository`: `findById` e `listEvents` sob contexto REQUESTER;
- `RequestRepository`: criação atômica da OPP em `requested` com evento `created`;
- `TransitionRepository`: transição atômica server-only com evento derivado;
- `ProductionOrderRepository`: composição das três capacidades, sem exigir que uma única classe
  concreta implemente todas.

`save(order)` e `appendEvent(event)` serão removidos. Não haverá alias, overload, wrapper legado,
stub, `upsert`, `patch`, `updateStatus` genérico ou helper público de evento.

A remoção é breaking. O futuro sublote contratual deverá elevar
`KNOWLEDGE_FACTORY_CONTRACT_VERSION` de `2.0.0` para `3.0.0`.

### DEC-3B5-02 — Contexto REQUESTER explícito e efêmero

O pacote de infraestrutura publicará um contexto mínimo semelhante a:

```ts
interface SupabaseRequesterContext {
  readonly client: SupabaseClient;
  readonly requesterId: EntityId;
}
```

Regras:

- o composition root cria o client a partir da sessão autenticada já verificada;
- `requesterId` deriva da mesma identidade verificada, nunca de body, query, header arbitrário ou
  parâmetro de método;
- o contexto é por request; não é singleton, cache global ou estado reutilizado entre usuários;
- o pacote não cria client, não lê token, não chama `getUser()`, não renova sessão e não lê env;
- o adapter valida identidade não vazia antes de operar;
- rows hidratadas devem possuir `requester_id` igual ao principal esperado;
- o client REQUESTER é obrigatório para leituras privadas e para a solicitação inicial;
- ausência de identidade resulta em `UNAUTHORIZED` provider-neutral;
- OPP estrangeira permanece indistinguível de ausente no read path e retorna `null`, evitando
  enumeração.

O contexto não será serializado, logado nem exportado ao frontend como credencial.

### DEC-3B5-03 — Dois comandos fechados

A futura superfície de escrita conterá somente:

```ts
createProductionOrder(command);
transitionProductionOrder(command);
```

Criação:

```ts
interface CreateProductionOrderCommand {
  readonly commandId: EntityId;
  readonly order: Readonly<
    Omit<PedagogicalProductionOrder, 'requesterId' | 'status' | 'createdAt' | 'updatedAt'>
  >;
  readonly eventId: EntityId;
  readonly eventVersion: VersionTag;
  readonly occurredAt: ISODateTime;
}
```

Transição:

```ts
interface TransitionProductionOrderCommand {
  readonly commandId: EntityId;
  readonly requesterId: EntityId;
  readonly oppId: EntityId;
  readonly expectedStatus: OppStatus;
  readonly expectedUpdatedAt: ISODateTime;
  readonly toStatus: OppStatus;
  readonly eventId: EntityId;
  readonly eventVersion: VersionTag;
  readonly reason?: string;
  readonly occurredAt: ISODateTime;
}
```

Na criação, requester, status e timestamps são derivados pela fronteira; o payload não pode
escolhê-los. Na transição server-only, `requesterId` é a expectativa de ownership derivada do
contexto autenticado/orquestrado pelo backend, e a RPC confere esse valor contra a OPP bloqueada.

O tipo e os estados do evento não vêm do chamador. Eles são derivados da transição aprovada:

| Destino        | Evento derivado           |
| -------------- | ------------------------- |
| `requested`    | `created` somente criação |
| `scoped`       | `scope_resolved`          |
| `retrieving`   | `retrieval_started`       |
| `assembling`   | `context_assembled`       |
| `validating`   | `validation_started`      |
| `ready`        | `approved`                |
| `insufficient` | `insufficiency_detected`  |
| `blocked`      | `blocked`                 |
| `failed`       | `failed`                  |

### DEC-3B5-04 — Criação sempre inclui o primeiro evento

Uma OPP somente existe validamente quando a mesma transação persiste:

1. a linha `kf_production_orders` em `requested`;
2. o evento `created`, com `from_status = null` e `to_status = requested`;
3. o recibo idempotente.

Após a migration do sublote transacional:

- `authenticated` não terá INSERT direto na tabela de OPP;
- criação ocorrerá apenas por `kf_create_production_order`;
- a função derivará `requester_id` de `auth.uid()`;
- `anon` e identidade ausente serão rejeitados;
- falha em ordem, evento ou recibo reverterá o conjunto inteiro.

### DEC-3B5-05 — Transição é server-only

`kf_transition_production_order` não será executável por `anon` nem `authenticated`.

Motivo: RLS protege ownership, mas não substitui os gates pedagógicos de
`evaluateOppTransition()`. Se a função fosse pública ao usuário autenticado, o requester poderia
percorrer transições estruturalmente válidas sem comprovar suficiência, findings ou validações.

A camada de aplicação deverá:

1. carregar a OPP sob requester isolation;
2. executar a política de domínio;
3. rejeitar decisão negada;
4. somente então chamar o adapter server-only de transição;
5. enviar requester esperado, estado e timestamp lidos;
6. nunca expor a credencial SYSTEM ao cliente.

A RPC repetirá somente as invariantes estruturais verificáveis no banco: ownership esperado,
estado esperado, timestamp esperado, transição permitida, monotonicidade temporal, evento derivado,
unicidade e idempotência. Ela não alegará reexecutar gates pedagógicos cujos insumos ainda não estão
persistidos no Lote 3B.

### DEC-3B5-06 — Uma RPC estreita por comando

Funções propostas:

- `public.kf_create_production_order` — executável somente por `authenticated`;
- `public.kf_transition_production_order` — executável somente por `service_role`.

Ambas receberão `p_command_id uuid` e `p_payload jsonb` fechado, sem SQL dinâmico, nome de tabela,
role, claim ou operação arbitrária fornecida pelo cliente.

Requisitos comuns:

- `SECURITY DEFINER`;
- owner técnico controlado;
- `SET search_path = pg_catalog, public`;
- objetos qualificados;
- `PUBLIC` e `anon` sem `EXECUTE`;
- validação integral antes da primeira mutação;
- retorno provider-neutral mínimo;
- nenhuma chamada externa;
- uma transação PostgreSQL por invocação.

A migration revogará DML direto de OPP/evento necessário para forçar a fronteira:

- `INSERT` de `authenticated` em `kf_production_orders`;
- `INSERT` e `UPDATE` de `service_role` em `kf_production_orders`;
- `INSERT` de `service_role` em `kf_production_order_events`.

SELECTs existentes permanecerão inalterados nesta fatia. Qualquer leitura SYSTEM de OPP privada
exigirá decisão e caso de uso próprios; não será adicionada ao adapter requester.

### DEC-3B5-07 — Idempotência e recibo por requester

Uma tabela dedicada `kf_production_order_write_receipts` armazenará somente:

- `command_id`;
- `requester_id`;
- operação;
- fingerprint canônico;
- `opp_id`;
- `event_id`;
- estado resultante;
- instante de commit.

Regras:

- mesmo `commandId`, mesmo requester, mesma operação e mesmo fingerprint: replay do recibo;
- mesmo `commandId` com requester, operação ou fingerprint divergente: conflito;
- fingerprint é calculado no PostgreSQL após validação, nunca aceito do chamador;
- advisory lock transacional por `commandId` evita corrida de recibos;
- falha antes do commit não deixa recibo nem mutação parcial;
- payload, tema, motivo, conteúdo pedagógico, token ou contexto de turma não entram no recibo;
- recibos não recebem grants diretos para `anon`, `authenticated` ou frontend.

### DEC-3B5-08 — Concorrência otimista e timeline determinística

Na transição, a função fará lock apenas da OPP alvo e exigirá:

- `requester_id` igual ao requester esperado;
- status atual igual a `expectedStatus`;
- `updated_at` igual a `expectedUpdatedAt`;
- `occurredAt >= updated_at`;
- transição presente na matriz canônica;
- `eventId` ainda não utilizado.

Em sucesso, UPDATE da OPP, INSERT do evento e INSERT do recibo ocorrem na mesma transação. Conflito
de expectativa nunca vira no-op ou last-write-wins.

`listEvents(oppId)` ordenará por `occurred_at ASC, id ASC`. A ausência atual de `sequence` é uma
limitação conhecida de `GAP-3B-07`; o desempate por ID é determinístico, mas não substitui uma
sequência normativa futura.

### DEC-3B5-09 — Recibo provider-neutral

```ts
type ProductionOrderWriteOperation = 'create_production_order' | 'transition_production_order';

interface ProductionOrderWriteReceipt {
  readonly commandId: EntityId;
  readonly operation: ProductionOrderWriteOperation;
  readonly oppId: EntityId;
  readonly eventId: EntityId;
  readonly status: OppStatus;
  readonly replayed: boolean;
  readonly committedAt: ISODateTime;
}
```

O adapter deverá validar integralmente o recibo e traduzir, no mínimo:

- `22023` → `INVALID_INPUT`;
- `PT409` → `CONFLICT`;
- `P0002` → `NOT_FOUND`;
- identidade ausente → `UNAUTHORIZED`;
- ownership/execução negada → `FORBIDDEN` ou `NOT_FOUND`, conforme a fronteira;
- resposta incompatível → `INVALID_RESPONSE`.

Nenhum SQLSTATE, mensagem PostgreSQL, hint, URL, header, token, payload ou nome interno de função
atravessará a borda.

## 4. Sequência proposta de implementação

Cada sublote terá branch, PR, CI e gate humano próprios.

### 3B.5.1 — Contratos e contextos

- elevar o contrato para `3.0.0`;
- adicionar comandos, operações e recibo;
- decompor a porta em três capacidades;
- remover `save` e `appendEvent` sem compatibilidade silenciosa;
- criar os tipos de contexto REQUESTER necessários, sem criar clients;
- atualizar fixtures e testes de contrato;
- provar ausência de consumidores quebrados;
- nenhuma migration, RPC ou adapter.

Estado: **integrado pelo Pull Request nº 25.** O contrato foi elevado
para `3.0.0`; operações, comandos e recibo foram adicionados; a porta foi separada em leitura,
solicitação e transição; `save` e `appendEvent` foram removidos; e
`SupabaseRequesterContext` foi publicado somente com client injetado e `requesterId` que o
composition root deverá derivar da identidade verificada. Type tests cobrem a superfície exata e a
imutabilidade. Nenhum comportamento de persistência foi criado.

### 3B.5.2 — Adapter requester read-only

- implementar `findById` e `listEvents` com client REQUESTER injetado;
- colunas explícitas e mappers estritos;
- verificar requester da row hidratada;
- ordenar eventos deterministicamente;
- testar usuários A/B, identidade ausente, erro e redaction;
- nenhuma escrita, RPC ou SYSTEM fallback.

Estado: **integrado pelo Pull Request nº 26.** O adapter implementa
somente `ProductionOrderReadRepository`, usa `SupabaseRequesterContext` injetado, valida identidade
antes de consultar, confere o requester da OPP hidratada, seleciona colunas explícitas e ordena
eventos por `occurred_at ASC, id ASC`. Testes unitários cobrem ausência, mismatch, sanitização e
proibições; teste de integração A/B está preparado para o Supabase descartável do DB CI. Nenhuma
escrita, RPC, migration, client, sessão ou fallback SYSTEM foi criada.

### 3B.5.3 — Migration e RPCs

- criar recibos idempotentes;
- criar as duas funções estreitas;
- ajustar grants de tabela e função;
- preservar RLS e append-only;
- testar criação + evento e transição + evento como unidades;
- testar rollback, replay, fingerprint divergente, concorrência e ownership;
- testar que `authenticated` não executa transição;
- testar que `service_role` não faz DML direto;
- criar rollback guardado e DB lint;
- nenhuma aplicação no Supabase hospedado.

Estado: **integrado pelo Pull Request nº 27.** A migration adiciona
recibos requester-scoped, helpers internos e exatamente as duas RPCs aprovadas. A criação
REQUESTER deriva `auth.uid()`, status, timestamps e evento `created`; a transição SYSTEM confere
ownership, compare-and-set, matriz estrutural, monotonicidade e evento derivado sob row lock. DML
direto foi revogado, RLS e append-only foram preservados, rollback guardado e corridas
multi-sessão foram aprovados. CI geral, DB CI, integração A/B, rollback, reaplicação e DB lint
ficaram verdes antes do squash merge `e223de4d02b39df748c3063d0e495f528c025e9d`.

### 3B.5.4 — Adapters de comando

- adapter REQUESTER para `createProductionOrder` usando somente a RPC de criação;
- adapter SYSTEM server-only para `transitionProductionOrder` usando somente a RPC de transição;
- nenhuma `.insert()`, `.update()`, `.upsert()` ou `.delete()`;
- nenhum fallback entre contextos;
- payload e recibo explicitamente mapeados;
- telemetria allowlisted e erros sanitizados;
- integração no Supabase descartável;
- nenhum API/frontend/composition root/produção.

Estado: **integrado pelo Pull Request nº 28.** O adapter REQUESTER
implementa somente `createProductionOrder` e chama exclusivamente `kf_create_production_order`; o
adapter SYSTEM implementa somente `transitionProductionOrder` e chama exclusivamente
`kf_transition_production_order`. Payloads são reconstruídos por allowlist, recibos são validados
integralmente, telemetria é sanitizada e não existe DML direto, criação de client, troca de contexto
ou wiring. CI geral e DB CI ficaram verdes, incluindo a integração PostgreSQL real dos adapters,
antes do squash merge `1429107facf816a9a45c12b1ce3ed5cb3c7b6722`.

O Checkpoint 031 verificou os quatro sublotes, encerrou `GAP-3B-03` e formalizou o encerramento do
Lote 3B.5. A Fase B permanece aberta até decisão documental própria; nenhum encerramento de fase é
automático por esta definição.

## 5. Testes obrigatórios

### Contrato

- versão `3.0.0`;
- ausência de `save` e `appendEvent`;
- atribuição independente às três capacidades;
- comandos readonly e sem requester/status/timestamps controláveis na criação;
- enum fechado de operações;
- fixtures exclusivamente sintéticas.

### REQUESTER e RLS

- A lê OPP A e eventos A;
- A não lê OPP B nem eventos B;
- B não lê OPP A;
- OPP estrangeira retorna `null` no read path;
- contexto sem identidade falha como `UNAUTHORIZED`;
- requester adulterado ou row incompatível é rejeitado;
- REQUESTER nunca é substituído por SYSTEM nas leituras;
- nenhuma credencial aparece em erro, log ou artifact.

### Banco descartável

- criação grava ordem, `created` e recibo ou não grava nada;
- status inicial é sempre `requested`;
- requester da criação é `auth.uid()`;
- INSERT direto autenticado é negado após a migration;
- transição atualiza ordem, insere evento e recibo ou reverte tudo;
- evento deriva corretamente do destino;
- transição inválida é rejeitada;
- estado/timestamp esperados implementam compare-and-set;
- evento fora de ordem temporal é rejeitado;
- requester esperado divergente falha;
- `authenticated` não executa RPC de transição;
- `service_role` não executa DML direto nas tabelas;
- mesmo comando/payload produz replay;
- mesmo comando/payload divergente produz conflito;
- corrida do mesmo comando produz um commit lógico;
- duas transições concorrentes a partir do mesmo estado produzem um vencedor;
- UPDATE/DELETE de evento continua bloqueado;
- rollback remove funções, recibos e grants sem afetar o schema anterior;
- reaplicação limpa e DB lint verde.

### Adapters

- uma RPC explícita por comando;
- nenhuma escrita direta;
- nenhuma criação de client ou leitura de ambiente;
- nenhuma troca silenciosa REQUESTER ↔ SYSTEM;
- colunas e payloads fechados;
- resposta malformada é `INVALID_RESPONSE`;
- erro provider é sanitizado;
- eventos são ordenados por `occurredAt` e `id`;
- CI geral e DB CI verdes.

## 6. GAPs e cobertura funcional

### GAP-3B-03 — OPP + evento

**Status atualizado: encerrado no Checkpoint 031.** As condições exigidas foram:

1. contratos explícitos integrados;
2. criação e transição atômicas integradas;
3. requester isolation e separação server-only comprovadas;
4. rollback, idempotência e concorrência verdes;
5. adapters usando exclusivamente as RPCs;
6. integração humana dos quatro sublotes;
7. checkpoint pós-merge.

Os sete critérios foram satisfeitos pelos Pull Requests nº 25 a 28, pelo CI Pipeline nº 268, pelo
Knowledge Factory DB CI nº 31 e pelo checkpoint pós-merge. Atomicidade, isolamento REQUESTER,
transição server-only, idempotência, rollback, concorrência e uso exclusivo das RPCs permanecem
invariantes obrigatórias.

### GAP-3B-07 — Fatia física da OPP menor que o contrato normativo

Novo gap registrado por esta definição.

O domínio e o schema atuais não persistem integralmente:

- componente, etapa e ano como campos próprios;
- contexto minimizado da turma;
- preferências metodológicas e requisitos inclusivos;
- sequence, actor, correlation e causation dos eventos;
- tentativas, custos, componentes recuperados e validadores;
- vínculo com contexto, geração, validação e entrega;
- timestamps completos de início/conclusão/falha.

Consequências:

- 3B.5 conclui uma fatia de infraestrutura, não a OPP funcional completa;
- US-010.1 e US-010.2 permanecem parciais;
- US-014.1, US-016.1, US-016.2 e rastreabilidade de entrega não recebem `Done`;
- Fases C, D e E não serão antecipadas para preencher esses campos;
- a extensão futura exigirá contrato, data model, minimização/LGPD e migrations próprios;
- a Fase B poderá ser encerrada por decisão formal de bloqueio parcial prevista no Blueprint, sem
  fingir que o gap desapareceu.

`GAP-3B-07` não bloqueia a fatia mínima do 3B.5, desde que seus limites permaneçam explícitos.

## 7. Riscos adicionais

- client REQUESTER reutilizado entre usuários;
- requester vindo do payload em vez da sessão verificada;
- criação direta sem evento;
- RPC de transição exposta a `authenticated`;
- service role usado para leitura privada por conveniência;
- adapter de transição executado sem decisão de domínio aceita;
- evento com tipo/status fornecido arbitrariamente;
- relógio regressivo quebrando a timeline;
- replay que duplica evento;
- declaração indevida de `Done` das Stories normativas.

Esses riscos serão incorporados ao registro do Lote 3B com gates verificáveis.

## 8. Itens expressamente excluídos

Na branch documental original, qualquer alteração de código estava excluída. O 3B.5.1 ficou
restrito a contratos/contextos; o 3B.5.2, à leitura REQUESTER; o 3B.5.3, à migration, RPCs, grants,
rollback e provas descartáveis; e o 3B.5.4, aos dois adapters de comando exclusivos das RPCs.
Permanecem expressamente excluídos:

- DML direto em adapters ou fallback entre REQUESTER e SYSTEM;
- aplicação no Supabase hospedado;
- criação ou rotação de credenciais;
- API, frontend, composition root ou autenticação;
- worker assíncrono, fila, scheduler ou Edge Function;
- retrieval, embeddings, reranking ou context package;
- Sócrates 2 executável, geração, validação ou entrega;
- contexto real de turma, PDI ou dado de estudante;
- PNLD, currículo ou componente pedagógico real;
- fechamento de `GAP-3B-04`, `GAP-3B-05` ou `GAP-3B-07`;
- início da Fase C;
- acesso ou deploy em produção;
- merge automático.

## 9. Critérios de aceite desta definição

Esta definição estará pronta para integração documental somente se:

1. a insuficiência de `save + appendEvent` estiver demonstrada;
2. criação e transição incluírem evento na mesma transação;
3. leitura, solicitação e transição estiverem separadas;
4. REQUESTER context estiver definido sem criação de client no pacote;
5. transição pública autenticada estiver explicitamente proibida;
6. os dois comandos, o recibo provider-neutral e a tabela física de recibos estiverem delimitados;
7. idempotência, compare-and-set e ordenação estiverem definidos;
8. grants e execução mínima estiverem especificados;
9. os quatro sublotes e seus gates estiverem separados;
10. testes A/B, rollback, replay e concorrência estiverem exigidos;
11. `GAP-3B-03` permanecer ativo até integração técnica completa;
12. `GAP-3B-07` impedir alegação de OPP funcional completa;
13. nenhuma implementação ou produção tiver sido iniciada.

## 10. Próximo gate humano

Revisar o Checkpoint 031 e decidir sobre sua integração documental. Após eventual merge desse
registro, o próximo trabalho permitido é exclusivamente inspecionar o gate de saída da Fase B e a
contenção formal de `GAP-3B-04`, `GAP-3B-05` e `GAP-3B-07`.

Nenhuma produção, wiring, Supabase hospedado ou Fase C recebe autorização por continuidade
implícita.
