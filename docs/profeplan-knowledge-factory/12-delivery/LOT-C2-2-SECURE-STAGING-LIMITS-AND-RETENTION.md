# C.2.2 — intake/staging seguro, limites e retenção

Data: 14 de agosto de 2026.

Base de implementação: `main` em `93d50fc9b2fae63195db59477300215be0700ed5`.

## 1. Status e autoridade

Este sublote implementa exclusivamente a fronteira física mínima de intake/staging temporário prevista em C.2.

Deve ser lido em conjunto com:

- `LOT-C2-CONTROLLED-INGESTION-DEFINITION.md`;
- `LOT-C2-1-INGESTION-CONTRACTS-AND-STATE-MACHINE.md`;
- `../00-governance/ADR-062-C2-CONTROLLED-INGESTION-BOUNDARY.md`;
- `../00-governance/CONTINUITY-CHECKPOINT-045.md`;
- `../../../packages/types/src/knowledge-factory/ingestion.ts`.

C.2.2 consome os contratos de C.2.1 e não redefine a state machine de ingestão, as identidades de C.1 ou a autorização por finalidade.

## 2. Decisão arquitetônica

A fronteira física é composta por uma porta provider-neutral e adapters isolados:

```text
C.2.1 IngestionRequest
  -> policy C.2.2 de intake
  -> TemporaryStagingPort
  -> adapter de storage
  -> provider
```

O domínio não conhece bucket, path físico, signed URL, região, client SDK, access key, secret ou erro bruto do provider.

O primeiro adapter físico é `SupabaseTemporaryStagingAdapter`, localizado exclusivamente em `@profeplan/knowledge-factory-supabase`. Sua presença não transforma Supabase Storage em contrato arquitetônico da Knowledge Factory. Azure Blob ou storage S3-compatible poderão implementar a mesma porta futuramente sem alterar a superfície compartilhada.

Nenhum bucket hospedado foi criado por este sublote. A prova de integração usa somente Supabase local/descartável no GitHub Actions.

## 3. Reuso obrigatório de C.2.1

C.2.2 reutiliza:

- `IngestionRequest`;
- `IngestionRunRef` (`processing_run`);
- `IngestionReceivedFileRef` (`received_file`);
- `IngestionSourceVersionRef` (`source_version`);
- `TemporaryStagingArtifactRef`;
- evidências independentes para `temporary_staging` e `ingestion`;
- correlation ID e identidades de comando no boundary de C.2.1 quando aplicáveis.

A policy C.2.2 chama a policy de C.2.1 para validar a solicitação antes de aceitar bytes. Ausência de qualquer autorização obrigatória permanece fail-closed.

## 4. Contrato complementar de staging

O contrato complementar `STAGING_CONTRACT_VERSION = 1.0.0` adiciona somente o necessário para representar a presença física temporária e seu descarte:

- referência já canônica `TemporaryStagingArtifactRef`;
- `processing_run`;
- `source_version`;
- `received_file`;
- tamanho em bytes;
- media type normalizado;
- `createdAt`;
- `expiresAt`;
- receipt provider-neutral de descarte.

O receipt de descarte contém:

- artifact ID;
- processing run;
- instante solicitado;
- instante confirmado;
- outcome;
- reason code provider-neutral;
- correlation ID.

Não contém bucket, path, signed URL, secret, stack trace ou payload de provider.

## 5. Política de intake

O intake trata toda entrada como não confiável.

A policy tipada e centralizada valida, antes do adapter:

- autorização de `temporary_staging`;
- autorização de `ingestion`;
- tamanho individual;
- quantidade por execução;
- volume total por execução;
- duração máxima do intake;
- media type permitido;
- extensão permitida;
- filename hostil;
- path traversal;
- caracteres de controle/null byte;
- assinatura física mínima necessária ao tipo permitido;
- retenção solicitada.

A normalização do media type remove parâmetros e usa comparação lower-case. O filename é normalizado em NFC e nunca é utilizado para compor o object key do provider.

Para o formato piloto sintético permitido em C.2.2, a assinatura mínima `%PDF-` pode ser verificada somente como proteção física contra arquivo incompatível com a declaração. Nenhum digest criptográfico é calculado.

## 6. Limites padrão

Os limites ficam em uma única `StagingIntakePolicy`, substituível por configuração:

| Regra | Baseline C.2.2 |
|---|---:|
| tamanho máximo individual | 50 MiB |
| máximo de arquivos por `processing_run` | 10 |
| volume total máximo por `processing_run` | 200 MiB |
| duração máxima de intake | 15 minutos |
| media types | `application/pdf` |
| extensões | `.pdf` |
| retenção padrão | 6 horas |
| retenção máxima | 24 horas |
| tamanho máximo do filename | 255 caracteres |

Os testes podem injetar limites menores para evitar consumo desnecessário de recursos. Nenhum valor de provider substitui essa policy de domínio.

## 7. Retenção

Todo artefato de staging nasce com `createdAt` e `expiresAt` explícitos.

Regras:

1. retenção indefinida é proibida;
2. o default é 6 horas;
3. o teto inicial é 24 horas;
4. retenção acima do teto é rejeitada;
5. o clock é fornecido à policy/adapter nos pontos em que determinismo é necessário;
6. artefato no instante `expiresAt` ou posterior é indisponível para avanço;
7. expiração torna o artefato elegível para descarte;
8. C.2.2 não cria cron, worker ou fila para varredura automática de expirados.

A automação periódica de órfãos, caso necessária, deverá ser decidida em lote posterior apropriado sem alterar retroativamente esta policy.

## 8. Object identity e isolamento

O adapter não usa nome original do arquivo como object key.

A identidade física é derivada internamente de:

```text
processing_run + artifactId
```

Cada segmento é codificado antes de compor o path privado do provider. Esse path nunca sai do adapter.

O `opaqueLocator` compartilhado vincula de forma provider-neutral `processing_run + artifactId`. Ele não revela bucket, path físico, região, URL ou provider e é tratado como valor opaco fora do adapter.

`upsert` permanece desabilitado. Uma colisão no mesmo `processing_run`/artifact ID é `CONFLICT`, nunca overwrite silencioso.

Um comando de descarte somente pode operar quando o `processing_run` informado corresponde ao locator opaco do artefato. Divergência é rejeitada como `INVALID_INPUT` antes de qualquer chamada ao provider, preservando o artefato pertencente ao run original.

## 9. Segurança de acesso

C.2.2 não cria upload público nem signed URL.

A prova descartável cria um bucket privado somente dentro do Supabase local do GitHub Actions e confirma:

- escrita pelo adapter SYSTEM descartável;
- negação de escrita por client `anon` sem policy de Storage;
- isolamento de object key entre `processing_run`s;
- ausência de bucket/path no descriptor e no discard receipt.

A existência de `service_role` descartável no CI representa somente canal técnico efêmero. Não constitui autorização de negócio e não altera a necessidade das evidências de C.1/C.2.1.

## 10. Descarte verificável

O adapter executa delete e em seguida consulta o namespace privado correspondente para confirmar ausência do objeto.

Somente após essa verificação é emitido `TemporaryStagingDiscardReceipt`.

Se a ausência não puder ser confirmada, a operação falha de forma sanitizada e não declara descarte concluído.

Repetir o descarte é seguro quando o provider trata remoção de objeto ausente como sucesso. A idempotência distribuída/persistida de comandos continua pertencendo a C.2.4.

Em falha não conflitiva de upload, o adapter executa cleanup best-effort do object key gerado. Em conflito, cleanup é deliberadamente proibido para não apagar um objeto preexistente.

## 11. Observabilidade

O adapter reutiliza `PersistenceLogger` e registra somente allowlist estrutural:

- operação;
- adapter;
- duração;
- outcome;
- aggregate type;
- artifact ID;
- correlation ID;
- error code provider-neutral.

Não registra bytes, texto, nome original, bucket, path, signed URL, secret ou erro bruto do provider.

## 12. Persistência

C.2.2 não adiciona tabela, migration, RPC, RLS ou grant PostgreSQL.

Justificativa:

- bytes pertencem ao Storage temporário, nunca ao Postgres da Knowledge Factory;
- as identidades permanentes já existem em C.1/C.2.1;
- a persistência transacional da execução e replay pertence a C.2.4;
- antecipar uma tabela operacional neste ponto misturaria responsabilidades.

Os metadados/receipts necessários são representados por contratos e provados em memória/CI. Sua persistência definitiva será decidida no sublote responsável pelo command boundary de C.2.

## 13. Testes sintéticos

C.2.2 usa somente bytes artificiais mínimos iniciados por `%PDF-`.

A suíte cobre:

- intake válido;
- autorização de staging ausente;
- autorização de ingestion ausente;
- tamanho excedido;
- quantidade excedida;
- volume total excedido;
- media type proibido;
- extensão proibida;
- filename hostil/path traversal;
- assinatura física incompatível;
- duração de intake excedida;
- retenção acima do teto;
- artefato expirado;
- determinismo;
- `upsert: false`;
- colisão sem overwrite;
- cleanup em falha não conflitiva;
- path derivado de IDs codificados;
- descriptor/receipt sem provider;
- mismatch de `processing_run` rejeitado antes do provider;
- descarte verificável;
- descarte repetido;
- isolamento entre runs;
- acesso `anon` negado no Storage descartável.

## 14. Prova remota descartável

O workflow dedicado é:

`.github/workflows/knowledge-factory-c2-2-staging-ci.yml`.

Ele:

1. cria projeto Supabase local temporário no runner;
2. inicia a stack com `storage-api` habilitado;
3. mascara credenciais descartáveis geradas localmente;
4. cria bucket privado somente durante o teste de integração;
5. executa typecheck, unit tests e integration test;
6. produz evidência sanitizada como artifact de CI;
7. esvazia/deleta o bucket de teste;
8. destrói a stack local com `supabase stop --no-backup`.

Nenhum secret hospedado, bucket real, Supabase hospedado ou produção participa dessa prova.

## 15. Não escopo preservado

C.2.2 não implementa:

- checksum/digest criptográfico;
- deduplicação;
- vínculo definitivo por hash;
- persistência/replay distribuído de C.2.4;
- worker, fila, cron ou Trigger.dev;
- revisão humana operacional;
- handoff para C.3;
- extração;
- parser;
- OCR;
- leitura de páginas;
- chunking;
- embeddings;
- retrieval;
- frontend;
- endpoint público;
- signed URL público;
- PNLD real;
- PDF real;
- conteúdo protegido;
- storage hospedado;
- produção.

## 16. Gate de saída de C.2.2

C.2.2 estará apto à integração quando:

- a porta provider-neutral estiver fechada e exportada;
- limites e retenção estiverem centralizados e testados;
- `TemporaryStagingArtifactRef` de C.2.1 for consumido sem redefinição;
- adapter provider-specific permanecer isolado;
- overwrite estiver negado;
- acesso `anon` indevido estiver negado no ambiente descartável;
- descarte produzir evidência provider-neutral após confirmação de ausência;
- bytes não entrarem em tabela PostgreSQL da Knowledge Factory;
- CI geral estiver verde;
- CI específico C.2.2 estiver verde;
- nenhuma mudança de C.2.3 ou produção aparecer no diff.

A conclusão de C.2.2 não autoriza C.2.3.
