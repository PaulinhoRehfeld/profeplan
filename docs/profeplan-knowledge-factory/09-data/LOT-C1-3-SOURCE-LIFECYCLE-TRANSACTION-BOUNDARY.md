# Sublote C.1.3 — Fronteira transacional do lifecycle governado de fontes

Data da definição: 13 de agosto de 2026.

Base canônica verificada antes da abertura da branch documental:

- `main`: `7faf6af817099ce45757d606b392695bc4baee0d`;
- tree: `ec15e050785672c399db9169fd8431f9f00c2bf5`;
- parent: `673318c2d3370f60997fd0a15b68bc69c6be5755`;
- branch documental: `docs/knowledge-factory-lot-c1-3-atomic-boundary`.

## Status e fronteira

Este documento formaliza exclusivamente o desenho transacional de C.1.3. Ele não cria migration,
RPC, adapter, teste executável, wiring, acesso a Supabase hospedado ou autorização de produção.

C.1.3 implementará, somente após novo gate humano, a fronteira PostgreSQL estreita necessária para
executar os 13 comandos já integrados em C.1.1. Nenhum comando adicional é criado por esta definição.

Permanecem fora do contrato executável de C.1.3:

- materialização explícita de expiração como comando;
- classificação ou encerramento de impacto;
- processamento, ingestão e derivados;
- qualquer comando não pertencente a `SourceGovernanceCommand` em C.1.1.

## 1. Autoridades existentes

A implementação futura deve preservar as seguintes autoridades:

1. `kf_source_governance_events` — histórico autoritativo;
2. `kf_source_registration_projections` — projeção registral corrente reconstruível;
3. parte mutável de `kf_source_authorizations` — projeção corrente da autorização;
4. `kf_source_command_receipts` — resultado persistido de idempotência;
5. `kf_source_command_receipt_events` — ordem dos eventos produzidos por um comando.

Projeções nunca substituem o histórico. Elegibilidade continua derivada por sujeito, finalidade,
instante, autorização e estado registral.

## 2. Superfície de comandos fechada

### 2.1 Registro

- `register_identity`;
- `request_validation`;
- `confirm_validation`;
- `block_source`;
- `replace_source`;
- `archive_source`.

### 2.2 Autorização

- `grant_authorization`;
- `suspend_authorization`;
- `resume_authorization`;
- `revoke_authorization`;
- `block_purpose`;
- `supersede_authorization`.

### 2.3 Impacto

- `open_impact_assessment`.

A presença de `authorization_expired` entre os eventos físicos não cria automaticamente um comando
`expire_authorization`. A expiração continua derivável pela janela temporal e poderá ser
materializada apenas após contrato explícito futuro.

## 3. Identidades registráveis em C.1.3

O schema físico já admite oito `SourceIdentityKind`, mas C.1.3 não deve antecipar fases futuras.
`register_identity` poderá registrar somente:

- `work`;
- `edition`;
- `manifestation`;
- `received_file`;
- `governed_source`;
- `source_version`.

Os tipos abaixo permanecem fisicamente preparados, porém bloqueados nesta fronteira:

- `processing_run` — pertence à ingestão/processamento posterior;
- `derived_artifact` — pertence às fases que efetivamente produzirem derivados.

Tentativa de registrá-los por C.1.3 deverá resultar em `INVALID_INPUT`, sem escrita parcial.

## 4. Arquitetura recomendada

A fronteira externa deverá ser composta por RPCs públicas estreitas por comando, com helpers
internos compartilhados e não executáveis pelos papéis de API.

Superfície proposta:

```text
kf_source_register_identity
kf_source_request_validation
kf_source_confirm_validation
kf_source_block
kf_source_replace
kf_source_archive

kf_source_grant_authorization
kf_source_suspend_authorization
kf_source_resume_authorization
kf_source_revoke_authorization
kf_source_block_purpose
kf_source_supersede_authorization

kf_source_open_impact_assessment
```

Não criar uma RPC monolítica que aceite qualquer comando por `commandType`, nomes de tabela ou SQL.

As RPCs podem compartilhar helpers internos para:

- validação de JSON fechado;
- parsing de UUID/timestamp;
- fingerprint canônico;
- lock de comando;
- replay;
- competência do ator;
- lock de agregado;
- compare-and-set;
- geração de `aggregateVersion`;
- alocação de sequence;
- inserção de eventos;
- inserção de recibo;
- ordenação recibo–evento;
- abertura conservadora de impacto;
- emissão de SQLSTATE controlado.

Helpers internos deverão ter `EXECUTE` revogado de `PUBLIC`, `anon`, `authenticated` e
`service_role`.

## 5. Assinatura conceitual

A superfície deverá preservar o padrão já aprovado em outras fronteiras transacionais:

```text
(p_command_id uuid, p_fingerprint text, p_payload jsonb)
```

`p_payload` conterá o comando sem `commandId` e sem `fingerprint`. O schema de cada payload será
fechado: campos desconhecidos, ausentes ou com tipo incompatível deverão resultar em
`INVALID_INPUT`.

A RPC nunca aceitará nomes de tabela, SQL livre, operação genérica ou payload aberto.

## 6. Fingerprint canônico

O caller não será autoridade sobre o fingerprint.

A função deverá construir uma representação canônica contendo:

- versão canônica do algoritmo de fingerprint;
- operação;
- ator e papel;
- sujeito/agregado;
- scope e finalidade;
- basis;
- successor quando existir;
- `expectedState`;
- `expectedVersion`;
- `expectedSequence`;
- `occurredAt`;
- `effectiveAt`;
- `effectiveFrom`/`effectiveUntil` quando aplicáveis;
- `correlationId`;
- `reason`;
- demais campos semânticos específicos do comando.

Ficam fora do material hasheado:

- `commandId`, porque é a chave externa da idempotência;
- o próprio `fingerprint`.

O algoritmo aprovado para C.1.3 será:

```text
SHA-256(hex(lowercase)) sobre jsonb canônico de
{ fingerprintVersion: 1, operation, payload }
```

A RPC deverá recalcular o digest e compará-lo com `p_fingerprint`. Divergência é `INVALID_INPUT`.
O valor calculado, não o texto não verificado do caller, será persistido no recibo.

## 7. Idempotência

### 7.1 Ordem obrigatória

A idempotência precede validações dependentes de estado atual ou competência atual.

Ordem:

1. validar forma mínima de `commandId` e fingerprint;
2. adquirir lock transacional por `commandId`;
3. consultar receipt existente;
4. se houver receipt, comparar fingerprint e operação;
5. replay idêntico retorna o receipt persistido com `replayed=true`;
6. fingerprint/operação divergentes resultam em `CONFLICT`;
7. somente comando novo segue para competência, CAS e escrita.

Replay não deve revalidar:

- estado corrente do agregado;
- versão corrente;
- competência atual do ator;
- autorização atual;
- janela atual.

O receipt original é a prova do comando já comprometido.

### 7.2 Lock de comando

Usar transaction advisory lock derivado de `commandId` para serializar concorrência do mesmo
comando. Apenas uma execução poderá materializar o primeiro resultado.

## 8. Compare-and-set

Para toda mutação de agregado existente, C.1.3 torna obrigatórios:

- `expectedState` quando o contrato do comando o comportar;
- `expectedVersion`;
- `expectedSequence`.

Ausência de `expectedVersion` ou `expectedSequence` em mutação de agregado existente será
`INVALID_INPUT`.

Em criação inicial (`register_identity`, `grant_authorization` e criação do successor em
`supersede_authorization`), `expectedState`, `expectedVersion` e `expectedSequence` do novo agregado
não existem e não serão inventados pelo caller.

`open_impact_assessment` é append-only e não sobrescreve projeção. Para o primeiro evento de impacto,
expectativas podem estar ausentes. Se `expectedVersion`/`expectedSequence` forem fornecidos, devem
corresponder ao último evento da dimensão `impact` daquele subject; em eventos posteriores, a RPC
pode aceitar ausência e serializar apenas por lock/sequence, porque múltiplas avaliações de impacto
são historicamente acumuláveis e não representam uma transição de estado corrente.

Para atualização:

1. lock do agregado/projeção;
2. leitura do estado/version/sequence corrente;
3. comparação com expectativas;
4. qualquer mismatch resulta em `CONFLICT`;
5. somente então a nova revisão é criada.

Nenhum comando poderá adaptar silenciosamente sua intenção ao estado que encontrou depois de uma
corrida.

## 9. Aggregate version

`VersionTag` é string opaca e não possui semântica SemVer integrada. C.1.3 não transformará
`aggregateVersion` em versão bibliográfica, versão do arquivo ou versão de processamento.

A regra será:

- `sequence` é o ordinal monotônico do histórico daquele agregado/dimensão;
- `aggregateVersion` é um token opaco de revisão gerado pelo banco a cada estado/evento comprometido;
- a implementação futura utilizará UUID aleatório textual gerado dentro da transação;
- projeção, evento principal e receipt do agregado deverão compartilhar o mesmo novo token;
- replay retorna o token persistido e nunca gera outro.

Isso fornece CAS forte sem atribuir significado editorial ao token.

## 10. Temporalidade e monotonicidade

C.1.3 deverá rejeitar transições que reordenem a linha temporal já comprometida de um agregado.

Para agregado existente:

- `effectiveAt` do novo evento deve ser maior ou igual ao `effectiveAt` do último evento em sequence;
- `occurredAt` não pode ser anterior ao `occurredAt` do último evento em sequence;
- empate de `effectiveAt` é permitido e desempata por `sequence`/`eventId`;
- comando retroativo que exigiria inserir semanticamente antes de um evento já comprometido será
  `CONFLICT` e exigirá decisão futura específica de correção histórica.

`effectiveFrom` e `effectiveUntil` da autorização continuam representando a janela jurídica da
decisão; não são substitutos de `effectiveAt` do evento.

Essa restrição mantém projeção corrente, sequence e reconstrução histórica coerentes no MVP.

## 11. Locks de agregado

### 11.1 Agregados com projeção

Usar `SELECT ... FOR UPDATE` sobre:

- `kf_source_registration_projections`;
- `kf_source_authorizations`.

### 11.2 Criações e impacto

Quando ainda não há linha bloqueável, usar advisory lock derivado de chave estável:

```text
registration:<subjectIdentityId>
authorization:<authorizationId>
impact:<subjectIdentityId>
```

### 11.3 Ordem anti-deadlock

Comandos que bloqueiem mais de uma chave deverão ordenar as chaves deterministicamente antes de
adquirir locks.

`supersede_authorization` deverá bloquear predecessor e successor em ordem lexical dos UUIDs, além
do sujeito registral quando necessário para validar `VALIDATED`.

## 12. Competência do ator

A fronteira técnica não confiará no papel declarado no payload.

C.1.3 deverá possuir uma fonte runtime autoritativa mínima de atribuições, definida no documento de
segurança deste sublote como `kf_source_actor_assignments`.

A competência será verificada contra `occurredAt`, porque a pergunta é se o ator tinha competência
quando tomou a decisão. Replay não revalida competência posteriormente.

## 13. Matriz de comando e ator

### Curator

Pode originar:

- `register_identity`;
- `request_validation`;
- `confirm_validation`;
- `block_source`;
- `replace_source`;
- `archive_source`;
- `open_impact_assessment`.

### Legal/editorial reviewer

Pode originar:

- `grant_authorization`;
- `suspend_authorization`;
- `resume_authorization`;
- `revoke_authorization`;
- `block_purpose`;
- `supersede_authorization`;
- `open_impact_assessment`.

### System worker

Não recebe autoridade autônoma sobre nenhum dos 13 comandos de decisão de C.1.3. Fases futuras
poderão usar `system_worker` para executar decisões já autorizadas sem convertê-lo em decisor.

### Auditor e technical admin

Não originam comandos de mutação de C.1.3.

## 14. Comandos registrais

### 14.1 register_identity

Cria atomicamente:

- `kf_source_identities`;
- `kf_source_registration_projections` em `REGISTERED`;
- receipt;
- `source_registered`;
- receipt-event order 1.

Estado inicial:

```text
∅ -> REGISTERED
sequence = 1
```

Falhar se:

- identidade já existir;
- kind não for permitido em C.1.3;
- actor não for curator competente;
- qualquer parte do conjunto não puder ser gravada.

### 14.2 request_validation

Permitido:

- `REGISTERED -> PENDING_VALIDATION`;
- `BLOCKED -> PENDING_VALIDATION`.

### 14.3 confirm_validation

Permitido somente:

- `PENDING_VALIDATION -> VALIDATED`.

`VALIDATED` não concede direito de uso.

### 14.4 block_source

Transições conforme política integrada. A autorização existente não é alterada. O comando abre
impacto conservadoramente como segundo evento do mesmo receipt.

### 14.5 replace_source

Exige successor existente, diferente do predecessor e com identidade compatível. Não transfere
qualquer autorização. Abre impacto conservadoramente.

### 14.6 archive_source

Preserva todo o histórico e impede novo fluxo produtivo daquele registro. Abre impacto
conservadoramente.

## 15. Comandos de autorização

### 15.1 grant_authorization

Cria autorização nova em `GRANTED` somente se:

- subject existir;
- projeção registral estiver `VALIDATED`;
- reviewer estiver competente;
- basis for válida;
- purpose e scope forem válidos;
- janela for válida;
- authorizationId for novo.

A projeção registral do subject deve ser bloqueada durante a decisão para impedir grant concorrente
com bloqueio/substituição sem ordem definida.

### 15.2 Authorization basis

`kf_source_authorization_bases` continua append-only.

Grant/supersession resolverão basis dentro da mesma transação:

- basis inexistente: inserir o registro imutável;
- basis existente: kind e digest devem coincidir;
- divergência: `CONFLICT`.

Suspend/resume/revoke/block não criam basis. O basis e o scope informados devem corresponder aos
valores imutáveis da autorização existente. Os eventos dessas transições copiam do agregado a janela
`effective_from`/`effective_until`; `effectiveAt` continua sendo o instante efetivo da mudança de
estado, não uma reescrita da janela jurídica.

### 15.3 suspend_authorization

`GRANTED -> SUSPENDED`.

Abre impacto conservadoramente como segundo evento.

### 15.4 resume_authorization

`SUSPENDED -> GRANTED`.

Não apaga o intervalo histórico de suspensão e não abre impacto automaticamente.

### 15.5 revoke_authorization

Permitido de `GRANTED` ou `SUSPENDED` para `REVOKED`. Terminal para a decisão. Abre impacto.

### 15.6 block_purpose

Aplica somente transições já permitidas pela política integrada. Não cria um caminho implícito novo
para `PENDING_REVIEW`. Abre impacto.

### 15.7 supersede_authorization

Semântica fechada para C.1.3:

- `authorizationId` identifica o predecessor;
- `successorAuthorizationId` identifica nova autorização;
- `scope`, `basis`, `effectiveFrom` e `effectiveUntil` descrevem a decisão sucessora;
- predecessor termina em `SUPERSEDED`;
- successor nasce em `GRANTED`;
- successor exige subject registralmente `VALIDATED` e reviewer competente;
- predecessor e successor recebem tokens/version/sequence próprios;
- o receipt permanece agregado ao predecessor, conforme contrato C.1.1;
- o receipt pode relacionar múltiplos eventos ordenados;
- o comando abre impacto como evento adicional;
- falha em qualquer etapa reverte predecessor, successor, eventos, receipt e relações.

Não existe supersessão parcial e não existe edição silenciosa do scope do predecessor.

## 16. Impacto conservador

Até existir lineage completa em fases futuras, C.1.3 não consegue provar que não existem derivados.
Por isso, os comandos abaixo abrirão `source_impact_assessment_opened` atomicamente:

- `block_source`;
- `replace_source`;
- `archive_source`;
- `suspend_authorization`;
- `revoke_authorization`;
- `block_purpose`;
- `supersede_authorization`.

O evento de impacto:

- usa `dimension = impact`;
- usa o subject identity como aggregate;
- recebe sequence própria da dimensão impact;
- usa o mesmo `command_id` do comando causador;
- aparece depois do evento principal em `event_order`;
- herda ator, reason, correlation e temporalidade do comando que reduziu/alterou elegibilidade.

Essa abertura não classifica derivados, não executa takedown e não encerra avaliação. Apenas mantém o
sistema fail-closed e auditável.

`open_impact_assessment` permanece disponível como comando explícito e produz somente o evento de
impacto correspondente.

## 17. Receipt e eventos

Todo comando novo deve produzir exatamente um receipt. IDs de eventos serão gerados pelo banco
dentro da transação e nunca confiados ao caller. `committedAt` também será tempo de commit do banco.

O receipt contém o estado/resultante do agregado principal definido pelo contrato C.1.1. Eventos
secundários, inclusive impact e successor grant, são ligados por
`kf_source_command_receipt_events.event_order`. Para comandos restritivos simples, o evento principal
é `event_order = 1` e o impacto é `event_order = 2`. Em `supersede_authorization`, a ordem canônica é:
predecessor superseded = 1, successor granted = 2, impact = 3.

Replay reconstrói `eventIds` pela ordem persistida e não consulta ordem física da tabela de eventos.

## 18. Erros provider-neutral

C.1.3 não introduz novo código público de persistência.

Semântica:

- `INVALID_INPUT` — payload, fingerprint, janela, kind ou expectativa obrigatória ausente;
- `NOT_FOUND` — aggregate, subject, successor ou basis referenciada quando exigida e inexistente;
- `CONFLICT` — CAS, transição inválida, idempotência divergente, monotonicidade temporal, identidade
  concorrente ou supersessão concorrente;
- `CONSTRAINT_VIOLATION` — constraint física não representada por caso de domínio conhecido;
- `UNAUTHORIZED` — ausência de autenticação técnica tratada pela borda futura;
- `FORBIDDEN` — executor sem EXECUTE ou ator sem competência;
- `UNAVAILABLE`, `INVALID_RESPONSE`, `UNKNOWN` — permanecem na taxonomia já integrada.

SQLSTATE interno futuro deverá reutilizar os padrões já estabelecidos, sem vazar mensagem/hint/raw
provider para camadas superiores.

## 19. Rollback obrigatório

A suíte futura deverá provar falha integral após cada ponto de escrita relevante.

Nenhuma falha pode deixar:

- identidade sem projection/event/receipt;
- projection atualizada sem evento;
- autorização sem histórico;
- basis nova órfã do comando que a criou;
- predecessor superseded sem successor;
- successor sem predecessor superseded;
- evento principal sem impacto obrigatório;
- impact sem receipt-event;
- sequence avançada parcialmente;
- aggregateVersion divergente entre projection/event/receipt;
- receipt sem conjunto completo de eventos.

## 20. Concorrência obrigatória

Testar no mínimo:

1. dois comandos diferentes sobre o mesmo expectedVersion/expectedSequence;
2. replay simultâneo do mesmo commandId/fingerprint;
3. mesmo commandId com fingerprints diferentes;
4. dois commands diferentes com a mesma expectativa de estado;
5. duas supersessões concorrentes do mesmo predecessor;
6. grant concorrente com block/replace/archive do subject;
7. duas decisões de autorização concorrentes sobre o mesmo aggregate;
8. dois eventos de impacto concorrentes sobre o mesmo subject.

Resultado esperado: no máximo um escritor por estado esperado; os demais falham deterministicamente
ou retornam replay, sem histórico duplicado.

## 21. Não escopo

Esta definição não autoriza:

- migration;
- RPC;
- adapter;
- mudança em contrato C.1.1;
- C.1.4;
- C.1.5;
- C.1.6;
- fechamento de GAP-3B-04;
- ingestão/C.2;
- upload, PDF, OCR, extração, segmentação, destilação;
- componentização, embeddings, retrieval ou agentes;
- frontend/API pública/wiring;
- Supabase hospedado, secrets ou produção.

## 22. Gate de implementação

C.1.3 somente poderá receber migration/RPC após revisão humana desta definição e autorização explícita
separada. A autorização de implementação não deverá ser interpretada como autorização de push, PR,
merge ou produção.
