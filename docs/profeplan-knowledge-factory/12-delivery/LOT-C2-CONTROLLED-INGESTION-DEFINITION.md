# Lote C.2 — Ingestão controlada

Data da definição: 14 de agosto de 2026.

Base canônica verificada: `main` em `cb74fa511c774baa7c96526827fd2fab51f4b2ff`.

Árvore canônica verificada: `e8a5b9b9975a8ba57456735ab5787b412b0a3256`.

## Status

**Definição documental de C.2 em preparação. Nenhum sublote técnico de C.2 foi iniciado.**

C.1 está concluído de C.1.1 a C.1.6 e `GAP-3B-04` está encerrado conforme o Checkpoint 043.
A autorização humana de 14 de agosto de 2026 permite iniciar C.2 por sua definição documental.
C.2.1–C.2.6 permanecem bloqueados até integração desta definição, checkpoint correspondente e
nova autorização humana específica para o sublote seguinte.

Esta definição não autoriza fonte real, PDF real, conteúdo PNLD, Supabase hospedado, bucket real,
secret real, frontend, endpoint público, job operacional, fila, extração, OCR, segmentação,
embeddings ou produção.

## 1. Autoridade documental

Esta definição deve ser lida em conjunto com:

- `../BLUEPRINT.md`;
- `PHASE-C-EXECUTION-MAP.md`;
- `PHASE-C-KNOWLEDGE-CARTOGRAPHY-ACTION-PLAN.md`;
- `../00-governance/CONTINUITY-CHECKPOINT-043.md`;
- `../00-governance/ADR-061-C1-CLOSURE-GAP-3B-04.md`;
- `LOT-C1-SOURCE-LIFECYCLE-GOVERNANCE-DEFINITION.md`;
- `LOT-C1-6-SOURCE-LIFECYCLE-CLOSURE-MATRIX.md`;
- `../../../packages/types/src/knowledge-factory/source-lifecycle.ts`;
- `../../../packages/knowledge-factory/src/repositories/source-lifecycle.repository.ts`;
- `../../../supabase/migrations/202608122230_kf_source_lifecycle_persistence.sql`;
- `../../../supabase/migrations/202608141120_kf_source_lifecycle_command_boundary.sql`.

Em caso de conflito, C.2 deve preservar os contratos já integrados de C.1 e parar para formalizar a
mudança antes de alterar lifecycle, autorização, segurança ou provider-neutrality.

## 2. Objetivo

C.2 cria a fronteira controlada entre uma **fonte governada e autorizada** e uma futura execução de
extração em C.3.

Seu objetivo é:

1. receber uma solicitação de ingestão vinculada a fonte e versão governadas;
2. verificar se a finalidade necessária está autorizada no instante aplicável;
3. admitir um arquivo somente em staging temporário e controlado;
4. registrar identidade, integridade, formato e tamanho sem incorporar o arquivo ao corpus;
5. detectar replay, duplicidade e conflitos de identidade de forma explícita;
6. abrir e acompanhar uma execução de ingestão rastreável;
7. impedir publicação parcial ou avanço silencioso quando houver falha;
8. exigir revisão humana antes de liberar o material para C.3;
9. manter descarte do artefato temporário como obrigação auditável;
10. permanecer provider-neutral e não depender de ambiente produtivo.

C.2 **não extrai conteúdo**. Sua saída é uma execução aprovada para extração, não texto, chunk,
embedding, nota, componente pedagógico ou grafo.

## 3. Problema arquitetônico

C.1 resolveu a governança do lifecycle de fontes, mas deliberadamente não implementou ingestão.

C.1 já oferece o vocabulário necessário para C.2:

- identidades `received_file` e `processing_run`;
- finalidades `temporary_staging` e `ingestion`;
- registro e autorização históricos;
- consulta `as of`;
- competência jurídico-editorial independente de `service_role`;
- idempotência e recibos para comandos de lifecycle;
- impacto conservador;
- RLS e grants mínimos.

Porém C.1.3 limita sua fronteira de comandos a identidades do lifecycle registral de C.1 e não deve
ser ampliado por conveniência para administrar a execução de ingestão. O lifecycle operacional de
`processing_run` pertence a C.2.

Também existe código legado no repositório com nomes de “ingestão”, incluindo serviço de frontend e
scripts antigos. Esse código não é arquitetura canônica da Knowledge Factory e não poderá ser
reutilizado por simples afinidade nominal. C.2 deverá avaliar qualquer reutilização somente por
compatibilidade explícita com esta definição, separação de camadas, segurança e testes.

## 4. Definition of Ready do Lote C.2

A abertura documental de C.2 está Ready porque:

- C.1.1–C.1.6 estão integrados;
- `GAP-3B-04` está encerrado;
- a `main` final de C.1 está verde;
- lifecycle, autorização histórica e provider-neutrality possuem contratos integrados;
- `received_file`, `processing_run`, `temporary_staging` e `ingestion` já existem no vocabulário de C.1;
- o mapa da Fase C identifica C.2 como próximo lote estrutural;
- houve autorização humana explícita para iniciar C.2.

Isso satisfaz o **DoR da definição documental**, não o DoR de C.2.1.

### DoR de C.2.1

C.2.1 somente poderá iniciar após:

1. integração humana desta definição;
2. checkpoint pós-merge da definição de C.2;
3. confirmação de que a `main` documental está verde;
4. nova autorização humana específica;
5. preservação de C.3–C.7 bloqueados.

## 5. Relação com EPIC, Feature e Story

C.2 materializa a parcela de entrada de:

- `EPIC-003` — Ingestão e leitura estrutural das fontes;
- `F-003.1` — ingestão assistida do conjunto piloto;
- `US-003.1` — ingestão assistida, na parcela anterior à extração.

A mesma Story continua em C.3 para a parcela de extração e validação. C.2 não pode declarar
`US-003.1` integralmente concluída.

## 6. Não escopo

C.2 não realiza:

- extração de texto;
- leitura semântica de PDF;
- OCR;
- renderização permanente de páginas;
- segmentação ou chunking;
- classificação estrutural de conteúdo;
- destilação ou deduplicação;
- embeddings, pgvector, retrieval ou reranking;
- componentização;
- vínculo curricular;
- curadoria do corpus;
- geração pedagógica;
- runtime de agentes;
- uso de OpenAI ou outro modelo para interpretar conteúdo;
- frontend de upload público;
- endpoint público de ingestão;
- job operacional de produção;
- fila operacional;
- Supabase hospedado ou produção;
- ingestão de fonte real sem autorização jurídica e operacional própria.

## 7. Princípios obrigatórios

### 7.1 Fonte governada antes de bytes

Nenhum arquivo poderá ser admitido por C.2 sem referência explícita a uma fonte/versão governada.
Receber bytes primeiro e “resolver a procedência depois” é proibido.

### 7.2 Autorização por finalidade e instante

O aceite deve ser fail-closed.

A execução deverá verificar a autorização efetiva aplicável à identidade governada no instante da
operação. A arquitetura deve distinguir:

- autorização para `temporary_staging`;
- autorização para `ingestion`;
- autorização futura para `extraction`.

C.2 nunca inferirá uma finalidade a partir de outra. Um grant para `ingestion` não cria grant para
`extraction`, `generation` ou qualquer outra finalidade.

### 7.3 Staging não é corpus

O arquivo recebido, nome original, bytes, representações temporárias e eventuais artefatos de
pré-validação pertencem ao staging temporário. Eles não podem ser tratados como corpus, fonte de
retrieval ou histórico permanente.

### 7.4 Metadado persistente não inclui conteúdo bruto

O estado permanente poderá conservar somente o necessário para identidade, integridade,
auditoria, revisão e descarte, por exemplo:

- IDs governados;
- digest criptográfico e algoritmo;
- tamanho em bytes;
- media type declarado e detectado quando houver detecção;
- timestamps;
- estado da execução;
- estado da revisão;
- identificador opaco do artefato temporário enquanto existir;
- deadline de retenção;
- recibo de descarte;
- razões sanitizadas de rejeição/falha.

Bytes do arquivo e conteúdo textual bruto não pertencem às tabelas permanentes de C.2.

### 7.5 Provider-neutrality

Contratos compartilhados não podem expor:

- nome de bucket Supabase;
- path físico de storage;
- signed URL;
- token;
- `SupabaseClient`;
- SQLSTATE;
- detalhes do SDK do provider.

O localizador do staging deverá ser opaco e traduzido por adapter específico somente quando o
sublote correspondente for autorizado.

### 7.6 Não ampliar C.1.3 por conveniência

C.1.3 continuará responsável pelo lifecycle de governança já aprovado.
C.2 criará sua própria fronteira para a execução de ingestão quando necessário, sem adicionar
`processing_run` às RPCs de C.1.3 apenas para reutilizar infraestrutura existente.

### 7.7 Duplicidade não significa equivalência jurídica

Digest igual permite detectar conteúdo binário repetido, mas não prova que duas obras, edições,
manifestações ou autorizações sejam equivalentes.

C.2 deve registrar duplicidade como fato técnico e preservar as identidades governadas distintas.
Qualquer consolidação semântica ou editorial pertence a outra decisão/lote.

### 7.8 Falha não publica parcialmente

C.2 não publica conteúdo. Falha de upload, verificação, persistência, revisão ou descarte não pode
produzir estado que C.3 interprete como aprovado.

### 7.9 Revisão humana obrigatória no piloto

Antes da saída para C.3, a execução deve possuir decisão humana explícita de aprovação para
extração. Automação poderá apoiar validações técnicas, mas não substituir esse gate no piloto.

### 7.10 Retenção mínima e descarte verificável

Todo artefato temporário deve possuir regra de expiração. A política concreta de retenção deverá ser
definida em C.2.2 antes de qualquer arquivo real ser admitido.

O descarte deve gerar recibo auditável sem reter cópia do conteúdo descartado.

## 8. Identidades e agregados

C.2 deverá preservar as identidades de C.1 e introduzir somente os agregados operacionais que forem
necessários.

### 8.1 `received_file`

Representa o arquivo efetivamente recebido. Deve apontar para a versão governada que motivou a
entrada e conservar apenas metadados mínimos permanentes.

### 8.2 `processing_run`

Representa uma execução operacional rastreável de ingestão.

Uma execução não é a fonte, a versão, o arquivo nem o resultado da futura extração.

### 8.3 Artefato temporário de staging

É a referência operacional aos bytes enquanto eles existem. Pode possuir identidade própria no
modelo de C.2, mas não deve ser promovido a identidade bibliográfica ou derivado permanente.

### 8.4 Relações mínimas

A futura persistência deverá ser capaz de reconstruir:

```text
governed_source
  -> source_version
    -> received_file
      -> processing_run
        -> temporary staging artifact
```

A relação não autoriza conteúdo nem finalidades por herança.

## 9. Estado normativo da execução de ingestão

C.2.1 deverá materializar um state machine provider-neutral. A definição do lote fixa os estados
conceituais mínimos abaixo; nomes exatos de símbolos públicos serão confirmados no contrato C.2.1.

```text
REQUESTED
  -> STAGING
  -> STAGED
  -> VERIFYING
  -> VERIFIED
  -> PENDING_REVIEW
  -> APPROVED_FOR_EXTRACTION
```

Saídas de exceção:

```text
REQUESTED/STAGING/STAGED/VERIFYING/VERIFIED/PENDING_REVIEW
  -> REJECTED
  -> FAILED
  -> CANCELLED
```

Regras:

- `APPROVED_FOR_EXTRACTION` é terminal dentro de C.2;
- `REJECTED`, `FAILED` e `CANCELLED` não autorizam C.3;
- retry não cria transição silenciosa para aprovado;
- retomada deve preservar a identidade da execução quando for replay legítimo;
- nova tentativa materialmente distinta deve possuir nova identidade ou comando segundo o contrato;
- descarte do artefato temporário é obrigação relacionada, não sinônimo do estado final da execução.

## 10. Estado normativo do artefato temporário

C.2.2 deverá separar o lifecycle do staging do lifecycle da execução.

Estados conceituais mínimos:

```text
EXPECTED
  -> RECEIVING
  -> STAGED
  -> VERIFIED
  -> RELEASED_FOR_EXTRACTION
  -> DISCARD_PENDING
  -> DISCARDED
```

Estados de exceção:

```text
RECEIVING/STAGED/VERIFIED
  -> QUARANTINED
  -> FAILED
```

`DISCARDED` deve possuir recibo e timestamp. O estado de descarte não apaga a auditoria da execução.

## 11. Contratos mínimos esperados de C.2.1

Sem antecipar implementação, C.2.1 deverá definir contratos provider-neutral para, no mínimo:

- solicitação de ingestão;
- identidade da execução;
- referência ao `received_file`;
- referência à `source_version` governada;
- estado da execução;
- receipt de abertura/replay;
- resultado de cancelamento/rejeição quando aplicável;
- metadados técnicos minimizados;
- correlação e idempotência;
- decisão de revisão humana;
- referência opaca ao artefato temporário, sem SDK/provider.

O contrato deve ser fechado, versionado e usar fixtures exclusivamente sintéticas.

## 12. Idempotência, replay e concorrência

C.2 deverá manter os princípios já comprovados em C.1:

- `commandId` estável;
- fingerprint canônico;
- mesmo comando + mesmo fingerprint = replay consistente;
- mesmo comando + fingerprint diferente = conflito;
- transições concorrentes não podem produzir dois estados vencedores;
- estado esperado/versão esperada devem ser usados quando a persistência exigir compare-and-set;
- nenhuma camada client-side é fonte de verdade para estado da execução.

A chave de idempotência da solicitação não deverá ser derivada apenas do nome do arquivo.

## 13. Integridade e duplicidade

C.2.3 deverá verificar, no mínimo:

- digest criptográfico do arquivo recebido;
- algoritmo do digest explicitamente registrado;
- tamanho em bytes;
- media type permitido;
- consistência entre media type declarado e detectado quando detecção existir;
- duplicidade binária conhecida;
- vínculo com a versão governada solicitada.

A descoberta de digest já conhecido deve retornar decisão explícita:

- replay da mesma execução;
- duplicado técnico relacionado;
- conflito de identidade;
- rejeição.

Nunca deve produzir merge automático de identidades bibliográficas.

## 14. Segurança

### 14.1 Deny-by-default

Toda persistência de C.2 deverá começar sem acesso direto de `anon` ou professor ao storage interno e
sem DML irrestrito nas tabelas operacionais.

### 14.2 Canal técnico não é competência jurídica

`service_role` ou identidade SYSTEM, se futuramente usados por adapter server-side, são apenas canal
técnico. A fonte continua dependente das autorizações e decisões de C.1.

### 14.3 Upload público proibido nesta fase

C.2 não autoriza endpoint público nem upload direto do navegador para storage interno da Knowledge
Factory. A composição operacional será definida somente em sublote específico e com gate próprio.

### 14.4 Conteúdo não entra em logs

Observabilidade não pode registrar:

- bytes;
- texto extraído;
- signed URL;
- tokens;
- secrets;
- conteúdo de páginas;
- payload arbitrário de metadata.

Pode registrar allowlist mínima como IDs, estado, duração, tamanho, digest truncado/seguro quando
necessário, outcome e erro provider-neutral.

### 14.5 Quarentena

Arquivo que falha validação técnica, tipo, integridade ou política não avança. Quarentena é estado
controlado e temporário, não uma segunda forma de corpus.

## 15. Privacidade, direitos e minimização

C.2 não processará dados reais nesta etapa documental.

Antes de qualquer arquivo real, C.2.2 deverá documentar:

- corpus autorizado;
- fundamento jurídico/editorial;
- finalidade permitida;
- política de retenção de staging;
- prazo máximo;
- procedimento de descarte;
- evidência do descarte;
- papéis autorizados;
- resposta a revogação durante staging/ingestão.

Uma revogação ou suspensão aplicável durante C.2 deve impedir novo avanço e abrir a avaliação de
impacto prevista em C.1 quando cabível.

## 16. Relação entre C.2 e C.3

C.2 termina quando uma execução está tecnicamente íntegra, governada e humanamente aprovada para
extração.

C.3 começa com essa execução aprovada e é o único lote autorizado a interpretar o conteúdo do
arquivo.

A passagem deverá transportar somente referências e metadados necessários, nunca “chunks prontos”.

```text
C.2
arquivo governado + staging + integridade + revisão
  -> APPROVED_FOR_EXTRACTION

C.3
extração nativa + validação do conteúdo extraído
```

## 17. Sublotes oficiais de C.2

### C.2.1 — Contrato de solicitação, receipt e state machine

Escopo:

- contratos provider-neutral;
- estados e transições;
- command envelope/idempotência;
- receipts;
- revisão humana como contrato;
- fixtures sintéticas e testes de invariantes;
- nenhum banco, storage, provider ou arquivo real.

Gate de saída:

- contrato fechado e versionado;
- state machine sem transição ambígua para C.3;
- invariantes de autorização e idempotência testadas;
- zero dependência de Supabase/storage em types/domínio.

### C.2.2 — Intake/staging seguro, limites e retenção

Escopo:

- porta provider-neutral de staging;
- modelo físico mínimo de metadados operacionais;
- adapter somente em ambiente descartável;
- allowlist de formatos/tamanho;
- retenção e descarte verificável;
- segurança, RLS/grants quando banco participar;
- nenhuma extração.

Gate de saída:

- arquivo sintético pode entrar e sair de staging descartável;
- bytes nunca entram em Postgres;
- acesso direto indevido é negado;
- expiração/descarte geram evidência;
- rollback/cleanup descartável comprovado.

### C.2.3 — Integridade, checksum, duplicidade e vínculo

Escopo:

- hash/integridade;
- identificação de duplicidade binária;
- vínculo com `source_version`/`received_file`;
- decisões explícitas de replay/duplicado/conflito/rejeição;
- testes com fixtures sintéticas.

Gate de saída:

- corrupção e mismatch são fail-closed;
- digest repetido não funde identidades;
- decisões são auditáveis;
- nenhuma leitura semântica do conteúdo ocorre.

### C.2.4 — Idempotência, retomada e falha segura

Escopo:

- persistência/command boundary da execução;
- replay consistente;
- compare-and-set quando necessário;
- retomada controlada;
- cancelamento;
- falha parcial;
- concorrência;
- observabilidade sanitizada.

Gate de saída:

- retries não duplicam processamento;
- concorrência não produz dois vencedores;
- falha não produz aprovação parcial;
- recovery é testável em ambiente descartável.

### C.2.5 — Revisão humana e liberação para C.3

Escopo:

- decisão humana explícita;
- competência mínima de revisão;
- approve/reject com reason;
- revalidação da autorização no instante da decisão;
- emissão do handoff provider-neutral para C.3;
- sem iniciar extração.

Gate de saída:

- somente execução aprovada pode produzir handoff;
- revogada/suspensa/expirada/bloqueada não avança;
- decisão é auditável;
- nenhum conteúdo real é necessário para provar o fluxo.

### C.2.6 — Prova integrada e fechamento

Escopo:

- matriz de evidências C.2;
- integração end-to-end com fixtures sintéticas;
- segurança negativa;
- replay/duplicidade/conflito;
- concorrência;
- descarte;
- rollback/reapply quando aplicável;
- checkpoint e gate C.2 -> C.3.

Gate de saída:

- todos os critérios globais de C.2 satisfeitos;
- nenhuma dependência de produção;
- documentação reconciliada;
- C.3 permanece bloqueado até autorização própria.

## 18. Matriz preliminar de responsabilidades

| Responsabilidade | C.1 | C.2 | C.3 |
|---|---|---|---|
| identidade e autorização da fonte | autoridade | consome | consome |
| finalidade `temporary_staging` | autoridade | verifica | não amplia |
| finalidade `ingestion` | autoridade | verifica | não amplia |
| finalidade `extraction` | autoridade | revalida no handoff | verifica/consome |
| arquivo temporário | não armazena | staging | consome temporariamente |
| integridade/checksum | identidade mínima | executa | herda evidência |
| execução de ingestão | identidade conceitual | autoridade operacional | referencia |
| extração textual | proibida | proibida | autoridade |
| segmentação/chunks | proibida | proibida | ainda não; C.4 |
| descarte do arquivo | princípio | controla obrigação | conclui quando consumo transitório terminar |

## 19. Testes obrigatórios por evolução

Cada sublote deverá executar gates proporcionais ao que tocar.

### Contratos/domínio

- unitários;
- invariantes de state machine;
- fixtures sintéticas;
- typecheck;
- lint/formatter;
- ausência de imports de provider.

### Persistência/storage

- ambiente descartável;
- RLS/grants negativos e positivos;
- acesso sem autorização negado;
- rollback/cleanup;
- expiração/descarte;
- ausência de bytes no banco;
- nenhum secret real.

### Boundary transacional

- idempotência;
- fingerprint divergente;
- CAS;
- concorrência multi-session quando aplicável;
- falha parcial;
- replay;
- cancelamento.

### Integração final

- fonte/versão governada sintética;
- autorização sintética para finalidades necessárias;
- staging sintético;
- verificação de integridade;
- duplicidade;
- revisão humana sintética;
- handoff para C.3 apenas como contrato;
- descarte/cleanup;
- nenhuma chamada a C.3 executável.

## 20. Rollback e recovery

Antes de existir dado real, testes destrutivos podem ser usados somente em ambientes descartáveis.

Depois de existir histórico operacional real, rollback destrutivo não poderá apagar auditoria. A
reversão deverá ser forward-only:

- cancelar novas admissões;
- revogar capacidade de execução;
- bloquear avanço;
- preservar receipts e eventos;
- descartar artefatos temporários segundo política;
- corrigir schema/comportamento por migration aditiva.

## 21. Critério global de saída de C.2

C.2 somente poderá ser encerrado quando houver evidência integrada de que:

1. somente fonte/versão governada e autorizada pode abrir ingestão;
2. `temporary_staging`, `ingestion` e `extraction` não são confundidas;
3. cada execução possui identidade e estado auditáveis;
4. staging é temporário, isolado e provider-neutral;
5. bytes não integram Postgres/corpus permanente;
6. limites de formato/tamanho são fail-closed;
7. integridade criptográfica é verificada;
8. duplicidade/replay/conflito possuem comportamento explícito;
9. idempotência e concorrência são seguras;
10. falha não produz aprovação parcial;
11. revisão humana precede C.3;
12. revogação/suspensão/expiração/bloqueio impedem avanço;
13. descarte é verificável;
14. testes executam apenas com fixtures sintéticas/ambiente descartável até autorização de corpus real;
15. nenhuma produção, frontend ou endpoint público é ativado;
16. documentação, PRs, CI e checkpoint final estão reconciliados.

## 22. Definition of Done desta definição documental

A definição documental de C.2 estará concluída quando:

- este documento estiver revisado e integrado;
- a decisão arquitetônica de fronteira C.2 estiver registrada;
- README/mapa de navegação refletirem que C.2 foi definido, mas C.2.1 continua bloqueado;
- CI documental estiver verde;
- checkpoint pós-merge registrar SHA/tree/parent e próximo sublote candidato;
- nenhuma alteração técnica de C.2 tiver sido antecipada.

## 23. Itens explicitamente bloqueados após esta definição

Mesmo após eventual integração deste documento, continuarão bloqueados até autorização própria:

- C.2.1–C.2.6;
- C.3–C.7;
- arquivos/fontes reais;
- PNLD real;
- bucket/storage hospedado;
- Supabase hospedado;
- secrets e credenciais;
- migrations em produção;
- upload público;
- frontend;
- API pública;
- jobs/filas/workers operacionais;
- extração/OCR;
- chunks/embeddings;
- agentes;
- produção.

## 24. Próximo sublote candidato

Após integração desta definição e seu checkpoint, o próximo sublote candidato será:

**C.2.1 — contrato de solicitação, receipt e state machine da ingestão.**

Ele deverá começar somente após nova autorização humana explícita.
