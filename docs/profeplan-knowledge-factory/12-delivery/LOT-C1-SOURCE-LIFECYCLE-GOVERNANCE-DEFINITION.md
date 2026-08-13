# Lote C.1 — Governança operacional do lifecycle de fontes

Data da definição: 12 de agosto de 2026.

Base canônica verificada: `main` em `a370d2f80663f2ae5a6bc0aa2ba5942d85db9708`.

Árvore canônica verificada: `cea333ad456aaac6d3d120ccdeee85e95672bd09`.

## Status

**Definição documental de C.1 integrada pelo PR nº 32. C.1.1 foi integrado pelo PR nº 33. C.1.2
está no Draft PR nº 34, com revisão técnica final concluída e `Knowledge Factory DB CI` run nº 32 e
`CI Pipeline` run nº 280 verdes. A integração de C.1.2 ainda depende de autorização humana
específica. C.1.3–C.1.6 e C.2 permanecem bloqueados. `GAP-3B-04`, `GAP-3B-05` e `GAP-3B-07`
permanecem ativos e contidos.**

Este documento detalha a primeira frente elegível depois da integração do Lote C.0 pelo PR nº 31.
Ele preserva `EPIC-002`, `F-002.1`, `F-002.2`, `US-002.1` e `US-002.2` e transforma os requisitos
já aprovados em um contrato normativo para a futura implementação do lifecycle de fontes.

## 1. Autoridade documental e referências obrigatórias

Esta definição deve ser lida em conjunto com:

- `../BLUEPRINT.md`;
- `PHASE-C-EXECUTION-MAP.md`;
- `PHASE-C-KNOWLEDGE-CARTOGRAPHY-ACTION-PLAN.md`;
- `../00-governance/CONTINUITY-CHECKPOINT-032.md`;
- `../00-governance/CONTINUITY-CHECKPOINT-033.md`;
- `../00-governance/CONTINUITY-CHECKPOINT-036.md`;
- `../00-governance/CONTINUITY-CHECKPOINT-037.md`;
- `../00-governance/DECISION-LOG.md`;
- `../../../packages/types/src/knowledge-factory/source.ts`;
- `../../../packages/knowledge-factory/src/repositories/knowledge-source.repository.ts`;
- `../../../packages/knowledge-factory/src/policies/source-eligibility.ts`;
- `../../../packages/knowledge-factory-supabase/src/source/supabase-knowledge-source.repository.ts`;
- `../../../supabase/migrations/202608071120_knowledge_factory_schema.sql`;
- documentos normativos do Marco 003 preservados pelo `SYNC-MANIFEST.md` para `EPIC-002`,
  `F-002.1`, `F-002.2`, `US-002.1` e `US-002.2`.

Em caso de conflito entre esta definição e um contrato já integrado, a implementação deve parar e
formalizar a mudança contratual antes de alterar comportamento. Este documento não autoriza
alteração silenciosa de contratos existentes.

## 2. Objetivo e problema arquitetônico

O Lote 3B.2 integrou deliberadamente uma porta mínima de fontes. A superfície atual permite:

- localizar uma `KnowledgeSource`;
- localizar uma `SourceVersion`;
- listar `SourcePermissionEvent`;
- salvar a ficha principal de `KnowledgeSource`.

Essa superfície foi suficiente para provar persistência e leitura, mas não representa o lifecycle
necessário para uma ingestão governada. Hoje:

- `SourceStatus` possui apenas `draft`, `approved`, `blocked` e `archived`;
- `SourceUse` possui `retrieval`, `generation`, `quotation` e `internal_review`;
- eventos de permissão possuem apenas `grant`, `revoke` e `block`;
- `KnowledgeSource.allowedUses` representa uma visão corrente;
- `evaluateSourceEligibility()` considera o último evento conhecido por uso, mas não possui janela
  de vigência, fundamento, ator decisor, escopo detalhado ou consulta histórica completa;
- `kf_sources`, `kf_source_versions` e `kf_source_permission_events` existem, porém ainda não
  distinguem integralmente obra, edição, manifestação, arquivo recebido, versão processável,
  autorização e execução de processamento;
- o adapter atual não escreve versões, segmentos nem eventos de permissão e não deve ser estendido
  por inferência para fazê-lo.

C.1 resolve essa fronteira em nível normativo antes de qualquer ingestão real.

## 3. Não escopo

C.1 não realiza:

- upload, ingestão ou leitura de PDF;
- OCR;
- extração textual;
- segmentação, chunking ou notas atômicas;
- destilação ou deduplicação;
- embeddings, pgvector, retrieval ou reranking;
- componentização ou curadoria de conteúdo real;
- processamento PNLD;
- alteração de currículo;
- runtime de agentes;
- wiring, frontend, API pública, job ou fila;
- acesso ao Supabase hospedado;
- uso de credenciais de produção;
- ativação do Sócrates 2;
- alteração das Fases D–G.

Também não define gestão comercial de royalties, portal de editoras ou negociação automatizada de
direitos, capacidades explicitamente fora do MVP de `EPIC-002`.

## 4. Princípio de modelagem: identidades não podem ser colapsadas

A expressão “fonte” continuará sendo útil para navegação e linguagem de produto, mas a futura
implementação deverá distinguir as identidades abaixo.

### 4.1 Obra intelectual

Representa a criação intelectual abstrata, independentemente de edição ou arquivo.

Exemplos de atributos conceituais:

- identificador interno estável;
- título canônico;
- autoria ou entidade responsável;
- tipo geral de obra;
- identificadores externos quando disponíveis;
- relações entre obra principal e materiais complementares.

Uma obra não possui checksum de arquivo e não é autorizada automaticamente apenas porque uma de
suas manifestações foi autorizada.

### 4.2 Edição

Representa uma edição, revisão ou versão editorial da obra.

Deve permitir distinguir, quando aplicável:

- número ou designação da edição;
- ano;
- idioma;
- editora ou entidade publicadora;
- revisão editorial;
- ISBN ou identificador equivalente associado à edição/manifestações.

Uma nova edição não deve herdar autorização de outra edição por pressuposição.

### 4.3 Manifestação bibliográfica

Representa a forma publicada concreta de uma edição.

Deve permitir distinguir, por exemplo:

- livro do estudante;
- manual do professor;
- anexo;
- suplemento;
- material digital complementar;
- versão eletrônica formalmente disponibilizada.

A manifestação é a unidade adequada para registrar diferenças de conteúdo e escopo jurídico que
não pertencem à obra abstrata.

### 4.4 Arquivo digital recebido

Representa o arquivo efetivamente recebido para preparação técnica.

O registro permanente deve conter somente metadados necessários, como:

- identificador;
- manifestação relacionada;
- hash criptográfico do arquivo;
- algoritmo do hash;
- tamanho e tipo declarados quando necessários;
- canal/procedência do recebimento;
- instante do recebimento;
- estado do recibo e descarte.

O binário do PDF, suas páginas renderizadas, imagens, recortes e miniaturas permanecem temporários.
O registro do arquivo não autoriza conservar o binário indefinidamente.

### 4.5 Hash do arquivo

O hash serve para:

- integridade;
- detecção de arquivo idêntico;
- reconciliação de reprocessamento;
- prova de qual arquivo foi processado.

O hash **não** representa sozinho:

- identidade da obra;
- edição;
- manifestação;
- titularidade;
- licença;
- autorização;
- equivalência jurídica entre arquivos.

Dois registros bibliográficos diferentes podem exigir análise mesmo quando o hash coincide. Dois
arquivos com hashes diferentes podem pertencer à mesma manifestação.

### 4.6 Versão governada e versão processável da fonte

`SourceVersion` continuará representando a versão governada que pode ser vinculada ao processamento,
mas sua futura definição deverá explicitar a relação com manifestação e arquivo recebido.

Devem permanecer distinguíveis:

- versão editorial;
- versão/manifestação bibliográfica;
- versão do arquivo digital;
- versão do registro governado;
- versão do processamento;
- versão de cada derivado.

`supersedesVersion` não transfere permissão automaticamente.

A **versão processável** não deve ser confundida com um novo arquivo binário. Ela representa o
snapshot governado que uma execução futura poderá consumir: versão da fonte + recibo/hash do arquivo
+ identidade/procedência validadas + autorizações efetivas para as finalidades necessárias + versão
da política de processamento. Se esse snapshot for materializado, deverá possuir identificador
reproduzível e imutável para a execução.

Os mesmos bytes podem deixar de ser processáveis sem mudança de hash quando uma autorização expira,
é suspensa ou revogada. Portanto, “processável” é uma condição governada e temporal, não uma
propriedade física do PDF.

### 4.7 Execução de processamento

Cada execução futura deverá possuir identidade própria e registrar, no mínimo:

- fonte/versão processada;
- arquivo recebido que serviu de entrada;
- finalidade ou conjunto de finalidades necessárias;
- autorização efetiva consultada no instante de início;
- versão da política utilizada;
- instante de início e encerramento;
- estado e resultado;
- correlação e idempotência;
- relação com execuções anteriores quando houver reprocessamento.

C.1 não cria a execução de processamento; define a obrigação que C.2 deverá satisfazer.

### 4.8 Derivados

“Derivado” é qualquer resultado cuja linhagem dependa total ou parcialmente da fonte, incluindo:

- texto normalizado;
- chunks ou segmentos;
- notas atômicas;
- sínteses;
- componentes pedagógicos e versões;
- embeddings;
- relações de grafo;
- vínculos curriculares;
- pacotes de retrieval;
- produtos pedagógicos gerados.

Os tipos permanecem entidades próprias nas fases correspondentes. C.1 define somente a regra de
linhagem e impacto de permissão.

### 4.9 Autorização

Autorização é uma decisão governada, temporal, versionada e vinculada a uma finalidade. Não é
sinônimo de `licenseCategory` nem de `allowedUses`.

Uma autorização deve poder informar:

- quem ou qual papel concedeu/alterou a decisão;
- em nome de qual titularidade ou fundamento;
- qual fonte, edição, manifestação ou versão está abrangida;
- qual finalidade está permitida;
- restrições;
- início e fim de vigência;
- decisão atual e histórico;
- documento ou fonte normativa que fundamenta a decisão.

### 4.10 Fundamento normativo ou contratual

Toda autorização produtiva deve apontar para um fundamento identificável, por exemplo:

- titularidade da WR Tech;
- contrato/licença de editora;
- licença aberta;
- autorização expressa;
- norma ou documento oficial cuja utilização seja juridicamente permitida;
- outra base aprovada pelo responsável jurídico/editorial.

O corpus deve armazenar apenas os metadados necessários para provar a decisão. Contratos integrais,
segredos comerciais e dados pessoais desnecessários não devem ser copiados para eventos ou logs.

## 5. Máquinas de estado ortogonais

C.1 não adotará uma única máquina de estados que misture qualidade bibliográfica, permissão jurídica
e elegibilidade técnica. Três dimensões devem permanecer separadas.

Na linguagem operacional, a situação “autorizada” corresponde a uma autorização `GRANTED` para
finalidade/escopo/vigência determinados; ela não vira estado registral universal da fonte. Como
`BLOCKED` pode existir nas duas dimensões com causas diferentes, C.1.1 deverá usar tipos/contextos
inequívocos na nomenclatura final, sem criar ambiguidade entre bloqueio registral e bloqueio de
autorização.

### 5.1 Lifecycle registral da fonte

Estados normativos:

- `REGISTERED` — registro criado, ainda sem validação suficiente;
- `PENDING_VALIDATION` — identidade/procedência em análise;
- `VALIDATED` — identidade e procedência verificadas para o escopo cadastral;
- `BLOCKED` — impedimento operacional/jurídico impede avanço;
- `REPLACED` — existe sucessor explícito; histórico permanece;
- `ARCHIVED` — registro encerrado para novos fluxos, preservado para auditoria.

Regras:

- `VALIDATED` não significa autorizado para qualquer finalidade;
- `REPLACED` não significa revogado e não transfere direitos ao sucessor;
- `ARCHIVED` não apaga histórico;
- `BLOCKED` prevalece sobre qualquer autorização para novos usos enquanto o bloqueio estiver ativo.

Compatibilidade com o contrato atual:

- `draft` cobre hoje parte dos significados de `REGISTERED/PENDING_VALIDATION`;
- `approved` mistura prontidão registral e elegibilidade e, por isso, não deve ser reinterpretado
  automaticamente como `VALIDATED + GRANTED`;
- `blocked` e `archived` possuem significado compatível, mas a futura migração deverá definir
  equivalência e backfill explicitamente.

Nenhum enum TypeScript é alterado por esta definição.

#### Transições registrárias permitidas

| Estado atual | Próximos estados permitidos | Condição normativa |
|---|---|---|
| `REGISTERED` | `PENDING_VALIDATION`, `BLOCKED`, `ARCHIVED` | validação deve ser explicitamente solicitada; bloqueio/arquivo exigem fundamento |
| `PENDING_VALIDATION` | `VALIDATED`, `BLOCKED`, `ARCHIVED` | `VALIDATED` exige identidade e procedência verificadas |
| `VALIDATED` | `BLOCKED`, `REPLACED`, `ARCHIVED` | substituição exige sucessor explícito; bloqueio/arquivo abrem avaliação de impacto quando houver derivados |
| `BLOCKED` | `PENDING_VALIDATION`, `REPLACED`, `ARCHIVED` | desbloqueio registral nunca retorna direto a `VALIDATED`; exige nova validação |
| `REPLACED` | `ARCHIVED` | o sucessor é outro registro/versão; não há retorno produtivo do registro substituído |
| `ARCHIVED` | nenhum estado produtivo | reativação exige decisão futura explícita e, por padrão, novo registro/versão governado |

Transições registrárias proibidas incluem:

- `REGISTERED → VALIDATED` sem validação;
- `BLOCKED → VALIDATED` sem nova passagem por validação;
- `REPLACED/ARCHIVED → VALIDATED`;
- qualquer entrada em `REPLACED` sem vínculo de sucessão;
- qualquer transição registral usada para conceder ou revogar permissão jurídica implicitamente.

### 5.2 Lifecycle da autorização

Estados normativos por finalidade e escopo:

- `PENDING_REVIEW` — decisão ainda não concedida;
- `GRANTED` — finalidade autorizada dentro de uma janela e escopo;
- `SUSPENDED` — autorização temporariamente não utilizável;
- `REVOKED` — autorização retirada a partir do instante efetivo informado;
- `EXPIRED` — janela de vigência encerrada;
- `BLOCKED` — decisão explícita de não permitir a finalidade no escopo avaliado;
- `SUPERSEDED` — decisão substituída por outra decisão formal, preservando histórico.

`SUSPENDED`, `REVOKED`, `EXPIRED` e `BLOCKED` não são equivalentes. O motivo e o comportamento de
retomada devem permanecer reconstruíveis.

#### Transições de autorização permitidas

| Estado atual | Próximos estados permitidos | Condição normativa |
|---|---|---|
| `PENDING_REVIEW` | `GRANTED`, `BLOCKED`, `SUPERSEDED` | concessão exige ator competente, fundamento, finalidade, escopo e vigência |
| `GRANTED` | `SUSPENDED`, `REVOKED`, `EXPIRED`, `SUPERSEDED` | toda restrição registra instante efetivo e abre impacto quando aplicável |
| `SUSPENDED` | `GRANTED`, `REVOKED`, `EXPIRED`, `BLOCKED`, `SUPERSEDED` | retomada exige novo evento; não apaga o intervalo suspenso |
| `BLOCKED` | `SUPERSEDED` | eventual permissão futura nasce como nova decisão formal, não como edição do bloqueio |
| `REVOKED` | nenhum retorno ao mesmo grant | nova concessão exige nova autorização relacionada historicamente |
| `EXPIRED` | nenhum retorno ao mesmo grant | renovação exige nova autorização; não se estende a janela antiga silenciosamente |
| `SUPERSEDED` | nenhum retorno produtivo | a decisão sucessora passa a ser consultada para o novo intervalo/escopo |

`EXPIRED` pode ser derivado pela passagem do tempo mesmo sem evento de manutenção. Se houver uma
projeção materializada, sua atualização não altera a verdade histórica da janela de vigência.

Transições de autorização proibidas incluem:

- `REVOKED/EXPIRED/BLOCKED → GRANTED` por simples update do mesmo registro;
- mudar finalidade, escopo ou fundamento de um grant vigente sem nova decisão/supersessão;
- apagar intervalo de suspensão por retomada;
- conceder autorização a fonte/versão sem identidade/procedência suficiente;
- usar transição de autorização para alterar conteúdo bibliográfico ou versão processada.

### 5.3 Elegibilidade efetiva

Elegibilidade é uma **decisão derivada**, não a fonte histórica de verdade.

Para uma consulta `(fonte/versão, finalidade, instante)`, o resultado mínimo é:

- `ELIGIBLE`; ou
- `INELIGIBLE` com uma ou mais razões controladas.

A decisão deve considerar conjuntamente:

1. identidade/procedência válida;
2. estado registral da fonte;
3. classe de licença;
4. autorização efetiva no instante consultado;
5. finalidade exata;
6. restrições de escopo;
7. bloqueios globais ou específicos;
8. estado da versão;
9. políticas adicionais da etapa solicitante.

Uma projeção corrente poderá ser mantida por performance, mas deve ser reconstruível a partir do
histórico e nunca substituir o histórico.

## 6. Finalidades de uso

O contrato atual possui `retrieval`, `generation`, `quotation` e `internal_review`. C.1 formaliza que
esses quatro valores não são suficientemente expressivos para governar todo o pipeline.

A futura revisão contratual deverá representar, sem presumir equivalência, pelo menos as seguintes
finalidades semânticas:

- staging temporário;
- ingestão;
- extração;
- análise/classificação;
- destilação;
- citação/quotation;
- criação de índice/embedding, quando a Fase D for autorizada;
- retrieval;
- uso como evidência;
- geração.

Uma permissão para uma finalidade **não** concede as demais. Em especial:

- permissão para `internal_review` não autoriza geração;
- permissão para extração não autoriza retrieval;
- permissão para retrieval não autoriza citação;
- permissão para geração não implica retenção indefinida do arquivo original;
- a possibilidade técnica de criar embedding não equivale a autorização jurídica para fazê-lo.

A nomenclatura final dos enums pertence a C.1.1. O significado acima é normativo.

## 7. Permissão histórica e consulta “as of”

O modelo futuro deverá responder, para qualquer instante relevante:

- qual decisão estava vigente;
- para qual finalidade;
- para qual fonte/edição/manifestação/versão;
- qual era a janela de vigência;
- quem decidiu;
- qual papel possuía;
- qual fundamento sustentava a decisão;
- quais restrições existiam;
- qual evento anterior foi substituído;
- quais execuções e derivados usaram aquela decisão.

### 7.1 Eventos append-only

Mudanças de permissão não devem editar o passado. Cada mudança gera novo evento.

Uma correção histórica excepcional também deve gerar novo evento de correção/supersessão, com
fundamento e ator, nunca `UPDATE` silencioso do evento original.

### 7.2 Vigência

Cada autorização deve possuir:

- `effective_from` obrigatório;
- `effective_until` opcional;
- instante de registro do evento, distinto do instante de vigência quando necessário.

`effective_until` não pode ser anterior a `effective_from`.

Mudanças retroativas, quando juridicamente necessárias, devem abrir obrigatoriamente análise de
impacto sobre execuções e derivados produzidos no intervalo afetado.

### 7.3 Alteração de escopo

Reduzir ou ampliar escopo não deve sobrescrever a autorização existente. A operação correta é criar
uma nova decisão e relacioná-la à anterior por supersessão, preservando os períodos de validade.

### 7.4 Expiração

Expiração pode ser derivada do relógio quando a janela termina; a projeção corrente pode registrar o
estado para eficiência. A ausência de um job de expiração não pode tornar uma autorização vencida
novamente elegível.

## 8. Comandos normativos

A futura camada de aplicação deverá distinguir intenção de negócio de persistência genérica.

### 8.1 Registro e identidade

Comandos candidatos:

- registrar obra;
- registrar edição;
- registrar manifestação;
- registrar recibo de arquivo;
- solicitar validação;
- confirmar validação;
- bloquear fonte;
- substituir fonte/manifestação/versão;
- arquivar fonte.

### 8.2 Autorização

Comandos candidatos:

- conceder autorização;
- suspender autorização;
- retomar autorização suspensa;
- revogar autorização;
- bloquear finalidade;
- superseder autorização com novo escopo;
- registrar expiração quando uma projeção materializada exigir evento explícito.

### 8.3 Impacto

Comandos candidatos:

- abrir avaliação de impacto;
- classificar derivado afetado;
- suspender elegibilidade de derivado;
- confirmar elegibilidade independente;
- registrar descarte exigido;
- encerrar avaliação de impacto.

A propagação concreta pertence aos lotes que possuem os derivados. C.1 define a obrigação e a
fronteira, não implementa efeitos em C.2–C.7 ou D–F.

### 8.4 Pré-condições, pós-condições, falhas e compensação

| Família de comando | Pré-condições mínimas | Pós-condições mínimas | Falhas esperadas | Compensação/rollback |
|---|---|---|---|---|
| registrar obra/edição/manifestação/arquivo | campos obrigatórios; ausência de conflito de identidade/idempotência | identidade + evento + recibo coerentes | `INVALID_INPUT`, `CONFLICT` | rollback integral; nenhum registro parcial |
| solicitar/confirmar validação | estado registral compatível; procedência/evidência exigida; versão esperada | novo estado + evento + recibo | `NOT_FOUND`, `INVALID_INPUT`, `CONFLICT`, `FORBIDDEN` | rollback integral; validação não pode existir sem evento |
| bloquear/substituir/arquivar | estado compatível; motivo; ator; sucessor quando necessário | estado registral + evento; avaliação de impacto aberta quando aplicável | `NOT_FOUND`, `INVALID_TRANSITION`, `CONFLICT`, `FORBIDDEN` | rollback integral; não alterar autorização silenciosamente |
| conceder autorização | fonte/versão registralmente válida; ator competente; fundamento; finalidade; escopo; janela válida | autorização + evento + recibo + projeção coerente | `NOT_FOUND`, `INVALID_INPUT`, `CONFLICT`, `FORBIDDEN` | rollback integral; grant não pode existir sem fundamento/evento |
| suspender/retomar/revogar/bloquear finalidade | autorização atual compatível; ator/fundamento; versão/sequência esperada | novo estado/evento; impacto aberto quando reduz elegibilidade | `NOT_FOUND`, `INVALID_TRANSITION`, `CONFLICT`, `FORBIDDEN` | rollback integral; nenhuma janela histórica é reescrita |
| superseder autorização | predecessor identificável; nova decisão completa; relação de sucessão válida | predecessor preservado + sucessor + eventos/recibos coerentes | `NOT_FOUND`, `INVALID_INPUT`, `CONFLICT` | rollback integral; não deixar duas projeções correntes conflitantes |
| classificar/encerrar impacto | caso de impacto existente; lineage e decisão revisáveis | classificação/decisão + evento + recibo | `NOT_FOUND`, `INVALID_INPUT`, `CONFLICT`, `FORBIDDEN` | rollback da decisão; derivado continua fail-closed se houver dúvida |

`INVALID_TRANSITION` é um conceito provider-neutral candidato; a taxonomia final deverá decidir em
C.1.1 se ele recebe código próprio ou se é representado por `CONFLICT`/`INVALID_INPUT` sem perder a
semântica de domínio.

## 9. Eventos auditáveis

Eventos futuros deverão registrar no mínimo:

- identificador do evento;
- agregado e versão;
- tipo do evento;
- ator e papel;
- fundamento/reason code;
- `occurred_at`;
- `effective_at` quando distinto;
- correlation ID;
- command ID/idempotency key;
- estado anterior e posterior quando aplicável;
- referência mínima ao fundamento;
- metadados allowlisted e minimizados.

Famílias candidatas:

- eventos de identidade/validação;
- eventos de lifecycle registral;
- eventos de autorização;
- eventos de substituição;
- eventos de impacto;
- recibos de descarte;
- eventos administrativos excepcionais.

Logs e eventos não devem incluir automaticamente texto integral de livro, PDF, páginas, credenciais,
prompt completo, contrato integral ou dados pessoais desnecessários.

## 10. Invariantes não negociáveis

1. Nenhuma execução produtiva inicia sem identidade/procedência válida e autorização efetiva para
   todas as finalidades exigidas.
2. Hash não substitui identidade bibliográfica ou decisão jurídica.
3. Autorização não é representada exclusivamente por booleano ou array corrente.
4. Histórico de permissão é append-only em operação normal.
5. `service_role` ou qualquer identidade técnica não constitui autorização jurídica.
6. Fonte registralmente bloqueada é inelegível para novos usos, ainda que exista grant antigo.
7. Autorização expirada é inelegível independentemente de job de manutenção.
8. Revogação, suspensão ou redução de escopo não apagam eventos nem produtos históricos por padrão.
9. Substituição não transfere autorização automaticamente.
10. Um mesmo `commandId` com o mesmo fingerprint deve ser replay seguro; com fingerprint diferente
    deve resultar em conflito.
11. Concorrência não pode produzir dois estados finais incompatíveis para a mesma versão esperada.
12. Operação multi-registro crítica não pode ser simulada por chamadas independentes ao provider.
13. Falha parcial não pode deixar grant sem evento, evento sem recibo esperado ou projeção corrente
    divergente da história confirmada.
14. Nenhum repository decide sozinho se uma licença é juridicamente suficiente; ele persiste uma
    decisão já validada pela camada responsável.
15. Nenhuma regra de C.1 autoriza C.2 ou conteúdo real.

## 11. Idempotência, concorrência e atomicidade

### 11.1 Idempotência

Todo comando que altera lifecycle ou permissão deverá possuir `commandId` externo ao provider.

O recibo deve permitir reconstruir:

- comando;
- agregado;
- versão esperada;
- fingerprint do payload;
- resultado;
- replay;
- timestamp.

Repetição idêntica retorna o mesmo resultado lógico. Reutilização do mesmo `commandId` com payload
diferente é conflito e nunca nova operação.

### 11.2 Concorrência

A estratégia preferencial é concorrência otimista:

- versão esperada ou sequência esperada;
- compare-and-set dentro da mesma transação;
- rejeição provider-neutral de estado obsoleto;
- novo comando após releitura explícita.

Não haverá retry automático cego de comando de negócio. Replay só é seguro pelo mecanismo de
idempotência.

### 11.3 Atomicidade

Operações como as seguintes exigirão fronteira transacional real:

- transição registral + evento + recibo;
- grant/revogação/suspensão + evento + projeção + recibo;
- supersessão + nova autorização + vínculo entre decisões;
- bloqueio/revogação + abertura da avaliação de impacto;
- substituição de versão + relação de sucessão + evento.

No Supabase, RPC PostgreSQL estreita é a candidata preferencial quando múltiplas tabelas estiverem
envolvidas, seguindo ADR-043. C.1.3 deverá confirmar a fronteira exata antes de qualquer SQL.

### 11.4 Compensação e rollback

Para comandos inteiramente persistentes dentro da fronteira transacional, a estratégia padrão é
**rollback integral**, não compensação posterior. Nenhuma falha pode deixar projeção corrente,
evento, autorização, versão ou recibo em combinações parciais.

C.1 não possui side effect externo autorizado. Quando lotes futuros introduzirem staging, jobs,
indexação ou outros efeitos externos, a coordenação deverá usar recibos/idempotência e estado
explícito; não será permitido “desfazer” história auditável por `DELETE` silencioso. Compensações
futuras devem gerar novos eventos e permanecer rastreáveis.

## 12. Falhas esperadas e taxonomia provider-neutral

A evolução deverá preservar a taxonomia de persistência existente e acrescentar, no domínio ou na
camada de comando, razões estáveis para situações como:

- entrada inválida;
- entidade não encontrada;
- versão esperada divergente;
- transição proibida;
- identidade ainda não validada;
- autorização inexistente;
- autorização inativa;
- finalidade fora do escopo;
- autorização expirada;
- fonte bloqueada;
- idempotency key reutilizada com fingerprint divergente;
- conflito de concorrência;
- fundamento obrigatório ausente;
- avaliação de impacto pendente;
- indisponibilidade do provider.

SQLSTATE, mensagem PostgreSQL, detalhes PostgREST ou estrutura Supabase não podem atravessar a porta
provider-neutral.

## 13. Propagação de impacto

Mudanças de autorização devem produzir impacto explícito e rastreável. A regra padrão do piloto é
**fail closed**: quando não for possível provar elegibilidade independente, o derivado deixa de ser
elegível para novos usos até revisão.

### 13.1 Matriz de impacto

| Camada | Suspensão/bloqueio/revogação/expiração | Histórico |
|---|---|---|
| ingestão ainda não iniciada | impedir início | registrar motivo |
| execução em andamento | interromper no próximo ponto seguro; impedir promoção; quarentenar saída parcial | preservar execução e decisão |
| texto extraído/normalizado | retirar de novas etapas/retrieval conforme finalidade afetada; avaliar retenção | preservar metadados mínimos e recibo de descarte quando necessário |
| chunks/segmentos | tornar inelegíveis para novas derivações enquanto dependentes da fonte afetada | manter linhagem; conteúdo pode exigir descarte conforme base jurídica |
| notas atômicas | suspender se a evidência material depender da fonte | preservar versão e decisão |
| componentes pedagógicos | suspender/revisar versões cuja evidência material dependa da fonte | nunca reescrever produto histórico silenciosamente |
| embeddings | invalidar e remover/reindexar quando a unidade subjacente ficar inelegível | manter apenas metadados de auditoria necessários |
| relações de grafo | suspender aresta cuja evidência dependa da fonte; manter somente com evidência independente revisada | preservar relação histórica e motivo |
| vínculos curriculares | revisar/suspender quando a justificativa depender da fonte afetada; vínculo normativo independente pode permanecer após prova | preservar origem e decisão |
| pacote de retrieval/cache | invalidar imediatamente e não reemitir | registrar versão/manifesto quando necessário |
| produto já gerado | impedir nova geração/reemissão automática baseada na fonte; sinalizar lineage para revisão | produto histórico não é apagado automaticamente, salvo obrigação jurídica própria |
| auditoria | nunca tornar inacessível por simples revogação de fonte | minimizar conteúdo e preservar eventos |

### 13.2 Derivados multifonte

Quando um derivado possui mais de uma fonte:

- não é suficiente remover a referência afetada do array de procedência;
- deve-se avaliar se o conteúdo continua sustentado por evidências independentes;
- ausência dessa prova implica suspensão para novos usos;
- a decisão humana de manter elegibilidade deve registrar justificativa e evidências remanescentes;
- reescrita substantiva cria nova versão, não alteração silenciosa da versão antiga.

### 13.3 Retenção versus elegibilidade

“Não elegível” e “deve ser apagado” são decisões diferentes.

- inelegibilidade controla novos usos;
- retenção depende de fundamento jurídico, auditoria, minimização e política de descarte;
- quando retenção do conteúdo não for permitida, o conteúdo deve ser descartado e ficar somente o
  mínimo não reversível necessário para comprovar o evento, quando juridicamente cabível.

C.1.2 materializa essa distinção sem armazenar PDFs ou artefatos visuais permanentes; o modelo
físico detalhado está em `../09-data/LOT-C1-2-SOURCE-LIFECYCLE-PHYSICAL-MODEL.md`.

## 14. Persistência física incremental — requisitos para C.1.2

A definição original não criou tabelas. A implementação autorizada de C.1.2 partiu do schema atual
por migration aditiva e está detalhada em
`../09-data/LOT-C1-2-SOURCE-LIFECYCLE-PHYSICAL-MODEL.md`. Eventos são autoritativos; projeções
correntes são reconstruíveis; o legado permanece sem backfill semântico.

### 14.1 Entidades candidatas

A persistência deverá representar, de forma própria ou por extensão compatível:

- obras;
- edições;
- manifestações bibliográficas;
- recibos/metadados de arquivos digitais;
- fontes governadas e versões;
- fundamentos de autorização;
- autorizações e respectivas projeções correntes;
- eventos append-only de lifecycle e permissão;
- recibos de comando/idempotência;
- avaliações de impacto;
- vínculos de lineage necessários para atingir derivados;
- recibos de descarte.

### 14.2 Compatibilidade com o schema atual

Devem ser preservadas até migração explícita:

- `kf_sources`;
- `kf_source_versions`;
- `kf_source_permission_events`;
- FKs já consumidas por evidências e currículo;
- IDs já emitidos;
- semântica append-only dos eventos existentes.

`kf_sources.allowed_uses` poderá tornar-se projeção compatível, mas não permanecer como autoridade
histórica única quando C.1 for implementado.

`kf_source_permission_events` deve ser evoluído ou sucedido de forma que eventos antigos permaneçam
interpretáveis. Nenhuma estratégia de migração poderá apagar ou reinterpretar silenciosamente
`grant/revoke/block` já persistidos.

### 14.3 Constraints

A migration de C.1.2 implementa, conforme o modelo aprovado:

- FKs de identidade e versão;
- unicidade de chaves de idempotência no escopo correto;
- janelas de vigência válidas;
- sequência/versionamento consistente;
- ausência de autorreferência em supersessão;
- vínculo obrigatório de evento a agregado;
- integridade entre autorização, fundamento e escopo;
- proteção append-only para eventos;
- `ON DELETE RESTRICT` onde auditoria e lineage não podem ser quebradas.

Hash deverá ser indexável para detecção de duplicidade, mas não necessariamente chave de identidade
bibliográfica.

## 15. Segurança, RLS, grants e LGPD

### 15.1 Deny by default

O padrão continua sendo deny-by-default. Professor não consulta fonte bruta nem registros jurídicos
diretamente.

### 15.2 Papéis

Papéis conceituais relevantes:

- `curator` — registra e valida procedência dentro da atribuição;
- `legal_editorial_reviewer` — concede, restringe, suspende ou revoga direitos;
- `system_worker` — executa somente operação previamente autorizada para IDs e finalidade definidos;
- `auditor` — consulta trilha minimizada;
- administrador técnico — não substitui o papel jurídico/editorial.

A implementação não deve inferir autorização jurídica a partir de “admin”.

### 15.3 `service_role`

`service_role` não é ator de negócio e não é autorização de uso.

C.1.2 reduz o risco para as sete tabelas novas ao revogar acesso direto de `service_role`; C.1.3
deverá manter essa fronteira ao conceder apenas execução estreita. Para lifecycle de fontes, a regra
é:

- nenhuma escrita direta por conveniência;
- comandos através de fronteiras server-only estreitas;
- parâmetros de ator, fundamento, versão esperada e command ID validados;
- grants de execução mínimos;
- DML direto revogado quando a arquitetura final permitir;
- observabilidade e auditoria de cada comando;
- nenhum uso de chave real em testes.

### 15.4 RLS

A matriz de C.1.2 testa explicitamente:

- leitura permitida por papel;
- leitura negada a professor comum;
- escrita negada fora das RPCs/fronteiras aprovadas;
- papel de curadoria sem capacidade jurídica indevida;
- papel jurídico sem acesso desnecessário a conteúdo bruto;
- worker limitado à finalidade e IDs da execução;
- admin técnico sem bypass de decisão de negócio;
- negativos com usuário autenticado comum e sem papel.

RLS não substitui política de domínio, e política de domínio não substitui RLS/grants.

### 15.5 Minimização e retenção

Persistir somente:

- identidade e metadados necessários;
- fundamento em forma minimizada;
- hashes e localizadores lógicos;
- eventos e decisões;
- conteúdo derivado permitido pela fase e autorização.

Não persistir como histórico permanente de C.1:

- PDF;
- página renderizada;
- recorte;
- miniatura;
- imagem-fonte;
- OCR bruto;
- coordenadas em pixels;
- credencial;
- contrato integral quando referência/hash e metadados bastarem.

Prazos exatos de retenção permanecem decisão jurídico-operacional que deve ser fechada antes do uso
de corpus real quando aplicável.

## 16. Contratos e adapters — requisitos para C.1.1 e C.1.4

### 16.1 Compatibilidade com `KnowledgeSourceRepository`

A porta atual não deve ser inflada por inferência.

Especialmente:

- `save(source)` não deve virar comando de lifecycle multi-tabela;
- `listPermissionEvents()` pode continuar como leitura compatível, mas não é suficiente para todas as
  consultas históricas futuras;
- `findVersion()` continua útil como consulta de versão;
- novas capacidades de comando devem ser explícitas e versionadas.

### 16.2 Separação recomendada de portas

A futura definição contratual deve separar, semanticamente:

- consultas de catálogo/identidade;
- consultas de versão;
- consultas de autorização histórica e “as of”;
- comandos de lifecycle registral;
- comandos de autorização;
- consultas/registro de impacto.

Os nomes TypeScript finais pertencem a C.1.1 e C.1.4; a separação de responsabilidades é normativa.

### 16.3 Responsabilidades fora do repository

Repository não deve:

- decidir se um contrato jurídico é válido;
- converter admin em reviewer jurídico;
- inferir autorização de `licenseCategory` isoladamente;
- iniciar ingestão;
- interromper jobs diretamente;
- decidir se um derivado multifonte continua autoral/elegível;
- aplicar regra pedagógica;
- disparar retrieval ou geração;
- criar client Supabase ou ler credencial/env;
- retornar detalhes brutos de provider.

### 16.4 Resultados de comando

Comandos devem retornar recibos provider-neutral com informação suficiente para:

- identificar o agregado;
- confirmar estado/versão resultante;
- indicar replay idempotente;
- correlacionar evento e comando;
- permitir observabilidade sem payload sensível.

## 17. Estratégia de testes — requisitos para C.1.5

### 17.1 Unitários

Cobrir:

- transições permitidas e proibidas;
- elegibilidade por estado registral;
- finalidade autorizada/não autorizada;
- suspensão, revogação, bloqueio e expiração;
- janelas temporais;
- supersessão;
- derivação de elegibilidade “as of”;
- idempotência e fingerprint;
- concorrência otimista;
- razões provider-neutral;
- impacto multifonte em políticas puras quando aplicável.

### 17.2 Contratos

Validar:

- compatibilidade de tipos e versões;
- comandos e recibos;
- leitura histórica ordenada deterministicamente;
- não exposição de tipos Supabase/Postgres;
- round-trip de campos obrigatórios;
- ausência de defaults que transformem “não informado” em “autorizado”.

### 17.3 Integração descartável

No Supabase local/descartável:

- aplicar migration do C.1.2;
- executar comandos reais do C.1.3;
- validar adapter do C.1.4;
- repetir comandos idempotentes;
- provocar fingerprint divergente;
- provocar concorrência;
- provocar falha no meio da transação;
- validar rollback sem publicação parcial;
- reaplicar migration/rollback conforme estratégia aprovada;
- destruir ambiente ao final.

### 17.4 Segurança/RLS

Testes positivos e negativos para:

- papéis permitidos;
- usuário sem papel;
- professor;
- worker;
- reviewer jurídico/editorial;
- tentativa de DML direto;
- leitura direta indevida;
- chamadas com IDs manipulados;
- bypass via `service_role` fora da fronteira permitida;
- ausência de dependência de produção.

### 17.5 Propagação

Mesmo antes das fases posteriores existirem integralmente, testes devem provar o contrato de impacto
com fixtures sintéticas para:

- execução não iniciada;
- execução em andamento;
- derivado de uma fonte;
- derivado multifonte;
- embedding hipotético;
- relação de grafo;
- vínculo curricular;
- produto histórico.

A integração real com cada tipo de derivado só será exigida no lote que o implementa.

## 18. Sublotes oficiais de C.1

A ordem candidata de C.0 é confirmada sem renumeração.

### C.1.1 — Contrato normativo de estados, comandos, eventos e invariantes

**Estado material:** integrado pelo PR nº 33 na `main` `2db5fc07378cc7c062753078b2a3fb2025cb1afe`.

**Objetivo:** materializar em contratos provider-neutral a semântica aprovada neste documento.

**Definition of Ready:**

- esta definição integrada;
- EPIC/Features/Stories reconciliados;
- nomenclatura final de estados e finalidades aprovada;
- estratégia de compatibilidade com contratos atuais explícita;
- nenhuma migration necessária para iniciar a fatia contratual.

**Definition of Done:**

- tipos/contratos versionados;
- estados, comandos, eventos, recibos e razões definidos;
- política “as of” determinística;
- invariantes testadas unitariamente;
- sem provider, banco, API, ingestion ou wiring;
- revisão humana e checkpoint próprios.

### C.1.2 — Modelo físico incremental, RLS, grants e rollback

**Estado material:** implementado e revisado no Draft PR nº 34; parser SQL verde; execução em
Supabase descartável, rollback/reaplicação e CI geral verdes; integração ainda pendente de decisão
humana específica.

**Objetivo:** representar identidades, autorizações históricas e comandos de forma segura sobre a
base existente.

**Definition of Ready:**

- C.1.1 integrado;
- contratos estáveis;
- modelo de migração/backfill aprovado;
- retenção e minimização definidas para os campos persistidos;
- matriz de acesso aprovada.

**Definition of Done:**

- migration aditiva/reversível conforme plano;
- FKs, constraints, índices e append-only definidos;
- RLS/grants deny-by-default;
- risco de `service_role` reduzido conforme decisão aprovada;
- rollback e reaplicação verdes em ambiente descartável;
- nenhuma produção aplicada.

### C.1.3 — Fronteira atômica para lifecycle e permissão

**Objetivo:** implementar comandos multi-registro sem pseudo-transação.

**Definition of Ready:**

- C.1.2 integrado;
- sequências atômicas e invariantes listadas;
- error mapping aprovado;
- command ID/fingerprint/version semantics definidos.

**Definition of Done:**

- RPCs estreitas ou fronteira transacional equivalente;
- atomicidade, rollback, idempotência e concorrência comprovados;
- sem DML paralelo alternativo;
- privilégios mínimos;
- nenhuma chamada a ambiente hospedado.

### C.1.4 — Adapters de comando e leitura

**Objetivo:** traduzir portas provider-neutral para a persistência aprovada.

**Definition of Ready:**

- C.1.3 integrado;
- portas de C.1.1 estáveis;
- queries e comandos separados;
- contexto SYSTEM/server-only definido sem credencial embutida.

**Definition of Done:**

- adapters atribuíveis às portas exatas;
- sem regra jurídica/pedagógica no adapter;
- sem `createClient()`, `process.env`, API/frontend ou wiring;
- erros e recibos traduzidos/validados;
- telemetria allowlisted;
- unitários e integração descartável verdes.

### C.1.5 — Testes de contrato, integração, segurança e concorrência

**Objetivo:** provar o lifecycle como capacidade integrada fora de produção.

**Definition of Ready:**

- C.1.1–C.1.4 integrados;
- matriz de casos positivos/negativos aprovada;
- ambiente descartável reproduzível.

**Definition of Done:**

- unitários, contrato e integração verdes;
- RLS positiva e negativa verde;
- idempotência e concorrência verde;
- revogação, expiração e supersessão verdes;
- rollback e falhas parciais verdes;
- nenhum secret/project ref/dado real;
- ambiente destruído ao final.

### C.1.6 — Fechamento documental e decisão sobre `GAP-3B-04`

**Objetivo:** inspecionar evidências de todos os sublotes e decidir se o lifecycle necessário à
ingestão está realmente concluído.

**Definition of Ready:**

- C.1.1–C.1.5 integrados por decisão humana;
- CI e DB CI aplicáveis verdes;
- documentação e diff revisados;
- nenhum bypass de segurança aberto;
- impacto derivado e retenção formalmente endereçados.

**Definition of Done:**

- checkpoint de encerramento;
- matriz de evidências completa;
- decisão explícita de fechar ou manter `GAP-3B-04`;
- se fechado, registrar exatamente quais evidências satisfizeram contrato, persistência, segurança,
  adapter e testes;
- se mantido, registrar bloqueio e destino;
- C.2 permanece bloqueado até autorização humana própria mesmo se o gap for encerrado.

## 19. Critério de saída global de C.1

C.1 somente poderá ser declarado concluído tecnicamente quando houver evidência integrada de:

- identidade bibliográfica/documental suficiente;
- lifecycle registral;
- autorização histórica por finalidade e vigência;
- consulta “as of”;
- persistência segura;
- append-only e auditabilidade;
- RLS/grants adequados;
- comandos atômicos;
- adapters provider-neutral;
- idempotência e concorrência;
- revogação/expiração;
- contrato de propagação de impacto;
- testes unitários e integração descartável;
- rollback;
- documentação e checkpoint.

C.1.1 e C.1.2, mesmo com os gates próprios satisfeitos, **não** satisfazem o gate global de C.1 e
**não encerram `GAP-3B-04`**.

## 20. Estado dos GAPs

### `GAP-3B-04`

**Ativo e contido.**

C.1 é seu destino primário. C.1.1 e C.1.2 avançam contrato e persistência, mas o gap só poderá ser
encerrado em C.1.6 depois de implementação, segurança, adapters e testes integrados.

### `GAP-3B-05`

**Ativo e contido.**

C.1 pode usar a auditoria suportada atualmente e definir eventos próprios mínimos, mas não deve
resolver incidentalmente a lacuna mais ampla de `US-013.2`. Qualquer extensão geral do contrato de
auditoria exige decisão separada.

### `GAP-3B-07`

**Ativo e contido.**

OPP normativa não é reutilizada como job de ingestão. Contexto de professor, retrieval, geração,
validação e entrega permanecem nas fases correspondentes.

## 21. Riscos e controles

| Risco | Consequência | Controle |
|---|---|---|
| usar `approved` como sinônimo de direito vigente | fonte tecnicamente aprovada usada sem autorização válida | separar lifecycle registral, autorização e elegibilidade |
| usar `allowedUses` como verdade histórica | perda de vigência e autoria da decisão | eventos append-only + consulta `as of` |
| transferir autorização ao substituir versão | uso indevido de edição/arquivo novo | sucessão não transfere grant automaticamente |
| tratar hash como identidade | colisão conceitual entre arquivos/obras | modelo de obra/edição/manifestação/arquivo |
| `service_role` virar bypass de governança | uso produtivo sem decisão jurídica | RPC/fronteira estreita, grants mínimos, auditoria e política de domínio |
| revogar sem atingir derivados | novos usos indevidos | avaliação de impacto e fail closed |
| apagar tudo após revogação | perda de auditoria ou violação de obrigação de retenção | separar elegibilidade, retenção e descarte |
| manter tudo após revogação | retenção indevida de conteúdo | política jurídica de retenção e recibo de descarte |
| retry duplicar evento | histórico inconsistente | command ID + fingerprint + recibo |
| concorrência produzir grants conflitantes | estado imprevisível | version check/CAS transacional |
| ampliar enum sem migração | quebra de adapter/schema | contrato versionado e plano incremental |
| antecipar C.2 | conteúdo real entra antes dos direitos | gate explícito e proibição de ingestão |

## 22. Decisões formalizadas por C.1

1. Identidade da obra, edição, manifestação, arquivo e processamento são entidades conceituais
   distintas.
2. Lifecycle registral e lifecycle de autorização são ortogonais.
3. Elegibilidade é decisão derivada por finalidade e instante, não booleano histórico.
4. Autorização possui fundamento, ator, escopo e vigência.
5. Mudanças de autorização são append-only e consultáveis historicamente.
6. Substituição não transfere autorização.
7. Revogação/suspensão/expiração abrem obrigação de impacto sobre derivados.
8. Regra de impacto do piloto é fail closed até prova de independência.
9. `service_role` não constitui permissão nem papel jurídico.
10. Escritas críticas usarão fronteira atômica real, nunca pseudo-transação PostgREST.
11. O adapter mínimo existente será preservado até mudança contratual explícita; `save(source)` não
    será transformado silenciosamente em lifecycle multi-tabela.
12. O pacote permanente não armazenará PDFs, páginas renderizadas, recortes, miniaturas ou OCR bruto.
13. Cada sublote exige autorização humana individual; C.1.1 e C.1.2 receberam autorizações próprias,
    enquanto C.1.3–C.1.6 permanecem bloqueados.
14. C.2 permanece bloqueado.

## 23. Próximo gate seguro

O gate técnico de C.1.2 foi satisfeito no Draft PR nº 34: revisão final concluída, DB CI descartável
verde e CI geral verde. A reconciliação documental pós-PR/pós-CI e a confirmação dos checks da branch
devem preceder qualquer integração.

O próximo ato permitido é uma decisão humana específica sobre integrar ou não C.1.2. C.1.3 não está
autorizado. A eventual integração de C.1.2 não autoriza automaticamente C.1.3–C.1.6, C.2, conteúdo
real, Supabase hospedado, wiring ou produção.
