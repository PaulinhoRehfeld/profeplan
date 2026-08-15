# CONTINUITY CHECKPOINT 050 — Lote C.2 encerrado; C.3 permanece bloqueado

Data: 15 de agosto de 2026.

> Este checkpoint assume autoridade de continuidade somente após a integração do PR documental que o contém. Até essa integração, o Checkpoint 049 permanece a autoridade formal vigente. O Checkpoint 049 deve permanecer histórico e não deve ser reescrito.

## Estado técnico canônico de fechamento de C.2

- repositório: `PaulinhoRehfeld/profeplan`;
- branch canônica: `main`;
- PR técnico de C.2.6: nº 93 — `test(knowledge-factory): prove C.2.6 integrated closure`;
- HEAD técnico validado e autorizado: `4f010128b5909224bff52914672cf9a080136531`;
- tree do HEAD técnico: `a0ba9baf16adb427e93d827e11c3628852aec634`;
- squash técnico integrado: `3b8c2d317542bd701ea61e671f9b6e4334f61b1c`;
- tree do squash técnico: `0fbe3377d3dac6aa9730a6e895d20a0762fc855c`;
- parent direto do squash: `57d7e387676224ef6fb5e3101270c0b6e4f8c245`;
- commit concorrente imediatamente anterior: PR nº 92 — `test(commercial): rehearse 1.3C.5 integral credit cutover (#92)`;
- CI pós-merge da `main`: CI Pipeline nº 562 — `success`;
- `INGESTION_CONTRACT_VERSION`: `1.0.0`;
- state machine de C.2.1: preservada;
- migrations funcionais novas em C.2.6: nenhuma;
- C.3 executado por C.2: não.

## Autoridade histórica

O Checkpoint 049 permanece evidência histórica do encerramento de C.2.5 e do bloqueio anterior de C.2.6. Ele não deve ser reescrito.

Após a integração deste fechamento documental, o Checkpoint 050 passa a ser a referência operacional corrente para continuidade da Knowledge Factory.

## Resultado governado de C.2.6

C.2.6 não criou nova capacidade funcional de ingestão. Seu papel foi consolidar e provar, em uma única narrativa sintética e descartável, as fronteiras já integradas em C.2.1–C.2.5.

A definição e matriz de fechamento estão em:

`12-delivery/LOT-C2-6-INTEGRATED-PROOF-AND-CLOSURE.md`.

O gate específico está em:

`.github/workflows/knowledge-factory-c2-6-closure-ci.yml`.

A prova integrou:

1. contrato e provider-neutrality de C.2.1;
2. staging físico temporário de C.2.2;
3. integridade SHA-256 e vínculo de C.2.3;
4. persistência, idempotência, CAS, recovery e fail-safe de C.2.4;
5. competência humana, autorização independente de `extraction` e handoff read-only de C.2.5;
6. postconditions globais de fechamento de C.2;
7. prova explícita de que nenhuma superfície executora de C.3 foi introduzida.

## Fluxo positivo consolidado

A prova E2E de C.2.6 utilizou somente IDs e bytes sintéticos em PostgreSQL/Supabase/Storage descartáveis:

```text
fonte/versão governada sintética
  -> request_ingestion
  -> replay idêntico
  -> replay divergente bloqueado
  -> begin_staging
  -> staging físico temporário
  -> mark_staged
  -> begin_verification
  -> readback físico + SHA-256
  -> confirm_verified
  -> request_review
  -> competência humana C.1
  -> autorização independente purpose=extraction
  -> approve_for_extraction
  -> APPROVED_FOR_EXTRACTION
  -> handoff read-only
  -> STOP
```

O objeto físico foi comprovado presente no instante do handoff, enquanto leitura `anon` permaneceu negada.

`APPROVED_FOR_EXTRACTION` continua sendo apenas fato persistido de elegibilidade dentro de C.2. Ele não significa que C.3 foi executado.

## Caminho fail-safe consolidado

Um segundo run sintético independente comprovou:

```text
request_ingestion
  -> begin_staging
  -> staging físico
  -> cancel_ingestion
  -> prepareDiscard
  -> descarte físico
  -> confirmDiscard
  -> retry de descarte = already_discarded
```

O run terminou `CANCELLED`, o artefato terminou `DISCARDED`, e nenhuma evidência de `ingestion_approved_for_extraction` pôde surgir nesse caminho.

## Achado integrado — canonicalização do fingerprint v1

O primeiro E2E de C.2.6 revelou uma divergência preexistente de implementação entre JavaScript e PostgreSQL.

O PostgreSQL já canonicalizava as chaves JSON do fingerprint v1 usando `COLLATE "C"`, enquanto o código JavaScript utilizava `localeCompare('en')`. Em chaves camelCase com prefixos comuns — como `requestId`, `requestedAt` e `requestedBy` — as ordens poderiam divergir.

O banco falhou corretamente de forma fechada com `INVALID_INPUT`, porque o fingerprint enviado pelo cliente não correspondia ao fingerprint canônico recalculado server-side.

A correção foi feita no lado JavaScript, alinhando a ordenação a comparação bytewise UTF-8 equivalente ao contrato já existente no PostgreSQL. Foi adicionado vetor de regressão explícito com o fingerprint v1:

`7a812ddb177c2ab737ab429a925b74c167638af7ce4ac6ed63bd86b512399317`.

Não houve mudança de protocolo. Portanto:

- `INGESTION_CONTRACT_VERSION` permanece `1.0.0`;
- nenhuma migration funcional foi necessária;
- a state machine não mudou;
- a semântica server-side de fingerprint não mudou;
- o cliente foi corrigido para cumprir o contrato v1 já vigente.

## Gates técnicos no HEAD autorizado

No HEAD `4f010128b5909224bff52914672cf9a080136531`, fecharam com `success`:

- CI Pipeline nº 560;
- Knowledge Factory C.2.6 Closure CI nº 3;
- Knowledge Factory C.2.4 Recovery CI nº 44;
- Knowledge Factory C.2.5 Human Review CI nº 10;
- Knowledge Factory DB CI nº 187;
- Knowledge Factory C.1.5 Lifecycle CI nº 84.

Esses gates revalidaram não apenas a nova prova C.2.6, mas também as fronteiras de lifecycle, banco, recovery, concorrência, atomicidade, autorização humana e handoff já integradas.

## Exceção governada de statuses Vercel

Imediatamente antes do merge do PR nº 93, os únicos statuses externos em `failure` eram:

- `Vercel – site`;
- `Vercel – profeplan`.

Os comentários do bot da Vercel registravam a causa como:

`api-deployments-free-per-day`

por limite diário do plano, e não por falha técnica da Knowledge Factory.

O merge ocorreu somente após autorização humana explícita para dispensar exclusivamente esses dois statuses externos, preservando todos os gates técnicos obrigatórios.

Essa exceção não constitui autorização genérica para ignorar failures externos futuros nem reduz o rigor dos checks técnicos da Knowledge Factory.

## Corrida concorrente PR nº 92 → PR nº 93

A verificação imediatamente anterior ao merge do PR nº 93 confirmou:

- `main = 0e3a2984b61c1518cd8382a2e45c35c52e86ceaf`;
- HEAD exato `4f010128b5909224bff52914672cf9a080136531`;
- `behind_by: 0`;
- `mergeable: true`;
- seis workflows técnicos em `success`;
- somente os dois statuses Vercel autorizados como exceção.

Entre essa leitura e a operação de merge, outra frente governada integrou o PR nº 92, criando:

`57d7e387676224ef6fb5e3101270c0b6e4f8c245`

com parent direto:

`0e3a2984b61c1518cd8382a2e45c35c52e86ceaf`.

A sequência real da `main` tornou-se:

```text
0e3a2984...  — fechamento documental pós-C.2.5
  ↓
57d7e387...  — PR #92, frente comercial
  ↓
3b8c2d31...  — PR #93, C.2.6
```

O endpoint de merge protegeu o HEAD do PR por `expected_head_sha`, mas não oferece na mesma operação uma guarda equivalente de `expected base SHA`. Portanto, houve uma janela TOCTOU (`time-of-check to time-of-use`) entre a última leitura da base e o merge.

Não houve rollback, reset, rebase destrutivo ou reescrita da `main`.

A comparação direta `57d7e387... → 3b8c2d31...` comprovou que o squash de C.2.6 adicionou exatamente os sete arquivos do PR nº 93, sem incorporar arquivo comercial ao diff técnico, sem colisão material e sem perda do trabalho concorrente.

O CI pós-merge nº 562 validou a árvore composta final da `main` com Prettier, ESLint, TypeScript, Build e Tests em `success`.

### Aprendizado de governança

A corrida não invalida o merge, mas deve permanecer registrada como evidência operacional.

Para merges críticos futuros:

1. reconfirmar base e HEAD imediatamente antes do merge;
2. proteger sempre o HEAD com `expected_head_sha`;
3. considerar a possibilidade de avanço concorrente da base entre check e merge;
4. auditar genealogia e diff resultante imediatamente após o merge;
5. nunca tentar corrigir automaticamente essa corrida por reset/rebase destrutivo;
6. exigir CI pós-merge sobre a árvore composta final;
7. quando a plataforma permitir, preferir mecanismo que também serialize a base, como fila de merge ou proteção equivalente.

Nenhuma mudança de configuração do repositório é autorizada por este checkpoint; o item acima é regra operacional para análise futura.

## Critérios globais de saída de C.2

O fechamento C.2.6 comprovou os critérios definidos para o lote:

1. somente fonte/versão governada e autorizada abre ingestão;
2. `temporary_staging`, `ingestion` e `extraction` permanecem finalidades independentes;
3. cada execução possui identidade, receipts, eventos e estado auditáveis;
4. staging é temporário, isolado e provider-neutral;
5. bytes não integram Postgres nem corpus permanente;
6. limites e acesso indevido falham fechados;
7. integridade criptográfica usa readback físico e SHA-256;
8. replay, duplicidade e conflito possuem comportamento explícito;
9. idempotência, CAS e concorrência são seguras;
10. falha parcial não produz aprovação parcial;
11. revisão humana precede qualquer elegibilidade para C.3;
12. competência e autorização continuam sob autoridade C.1;
13. autorização `extraction` é independente e historicamente avaliada;
14. descarte físico e persistido é verificável e idempotente;
15. toda a prova usa somente fixtures sintéticas e infraestrutura descartável;
16. nenhum frontend, endpoint público, recurso hospedado ou produção foi ativado;
17. C.3 não foi executado por C.2.

## Ownership preservado

### C.1

Continua autoridade de:

- identidade governada;
- versões de fonte;
- competência humana;
- autorização por finalidade e instante;
- histórico jurídico-editorial.

### C.2

Encerra sua responsabilidade como autoridade de:

- lifecycle operacional do `processing_run`;
- staging temporário;
- integridade física necessária ao gate;
- receipts/eventos operacionais;
- idempotência, recovery, CAS e concorrência;
- revisão operacional persistida;
- fato terminal de elegibilidade `APPROVED_FOR_EXTRACTION`;
- evidência read-only de handoff.

### C.3

Permanece bloqueado. Quando e se for aberto em contexto próprio, será a autoridade de:

- execução de extração;
- validação do conteúdo extraído;
- revalidação da autorização `extraction` no instante real da execução.

C.3 não herda autorização operacional automática do fechamento de C.2.

## Estado operacional após este checkpoint

- C.0 — concluído;
- C.1 — concluído;
- **C.2 — concluído canonicamente após a integração deste fechamento documental**;
- C.2.1 — concluído e revalidado;
- C.2.2 — concluído e revalidado;
- C.2.3 — concluído e revalidado;
- C.2.4 — concluído e revalidado;
- C.2.5 — concluído e revalidado;
- C.2.6 — concluído e revalidado;
- **C.3 — bloqueado**;
- C.4–C.7 — bloqueados;
- `GAP-3B-05` — ativo e contido;
- `GAP-3B-07` — ativo e contido;
- conteúdo real — bloqueado;
- PNLD real — bloqueado;
- PDF/livro real — bloqueado;
- Supabase hospedado — bloqueado;
- Storage hospedado — bloqueado;
- secrets de produção — bloqueados;
- produção — bloqueada.

## Definition of Ready de C.3

O próximo lote arquitetural candidato é **C.3 — extração e validação do conteúdo extraído**, mas ele permanece bloqueado e não pode ser iniciado por continuidade implícita.

Antes de qualquer implementação de C.3 será obrigatório, em contexto próprio:

1. reconfirmar a `main` e este Checkpoint 050 como autoridade vigente;
2. inspecionar integralmente a saída contratual de C.2 e preservar `APPROVED_FOR_EXTRACTION` + handoff como única entrada positiva;
3. definir contract-first a porta e o resultado de extração provider-neutral antes de qualquer parser;
4. preservar C.4 como autoridade futura de segmentação/classificação, sem criar chunks em C.3;
5. revalidar autorização C.1 com `purpose = extraction` no instante real de eventual execução, não apenas confiar no snapshot histórico do handoff;
6. iniciar provas exclusivamente com fixtures sintéticas e infraestrutura descartável;
7. manter OCR como exceção/fallback governado, não como caminho implícito;
8. manter conteúdo real, PNLD real, PDF/livro real e recursos hospedados bloqueados até autorização jurídica e operacional própria;
9. manter frontend, endpoint público, fila, worker, agente, wiring e produção fora do escopo inicial;
10. definir métricas de qualidade e falha fechada para extração antes de qualquer integração real;
11. exigir nova autorização humana específica para abrir C.3;
12. não alterar ownership C.1/C.2/C.3, state machine ou contratos de C.2 incidentalmente.

Satisfazer este DoR documental não autoriza automaticamente implementação nem uso de conteúdo real.

## Próximo passo permitido

Após a integração deste fechamento documental, o próximo passo permitido é apenas:

**inspeção e definição governada de C.3 em nova autorização humana específica.**

Não estão autorizados por este checkpoint:

- executar C.3;
- abrir PDF real;
- extrair texto real;
- usar PNLD real;
- criar chunks;
- gerar embeddings;
- publicar jobs;
- iniciar workers/agentes;
- usar Supabase/Storage hospedados;
- tocar produção.
