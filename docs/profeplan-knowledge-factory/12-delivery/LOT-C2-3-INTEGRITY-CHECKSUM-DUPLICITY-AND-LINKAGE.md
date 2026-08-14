# C.2.3 — integridade, checksum, duplicidade e vínculo

Data: 14 de agosto de 2026.

Base de implementação: `main` em `ef4e7b48a8417eb8809707951df56d4324d957f4`.

## 1. Status e autoridade

Este sublote implementa exclusivamente a verificação técnica de integridade dos bytes já presentes no staging temporário de C.2.2, sua classificação de duplicidade binária e o vínculo rastreável da evidência às identidades canônicas de C.1/C.2.1.

Deve ser lido em conjunto com:

- `LOT-C2-CONTROLLED-INGESTION-DEFINITION.md`;
- `LOT-C2-1-INGESTION-CONTRACTS-AND-STATE-MACHINE.md`;
- `LOT-C2-2-SECURE-STAGING-LIMITS-AND-RETENTION.md`;
- `../00-governance/ADR-062-C2-CONTROLLED-INGESTION-BOUNDARY.md`;
- `../00-governance/CONTINUITY-CHECKPOINT-046.md`.

C.2.3 não redefine a state machine de C.2.1 e não antecipa persistência/replay de C.2.4, revisão humana de C.2.5 ou handoff para C.3.

## 2. Separação obrigatória de identidades

C.2.3 mantém formalmente distintas:

```text
identidade bibliográfica
  != source_version
  != received_file
  != processing_run
  != staging artifact
  != checksum/digest dos bytes
  != equivalência editorial
  != duplicidade técnica
  != duplicidade semântica
```

Digest igual prova somente igualdade binária dos bytes observados pelo algoritmo indicado. Não prova que duas referências representam a mesma obra, edição, manifestação, licença, situação jurídica, equivalência editorial ou conteúdo semanticamente idêntico.

Digest diferente prova somente que os bytes observados são diferentes. Metadados internos, serialização, compressão, timestamps, geração do PDF ou revisão editorial podem alterar os bytes sem que isso determine, por si, uma identidade bibliográfica diferente.

Nenhuma identidade é fundida automaticamente por C.2.3.

## 3. Algoritmo e representação

A versão inicial usa:

- algoritmo: `sha-256`;
- representação: hexadecimal minúsculo;
- tamanho canônico: 64 caracteres hexadecimais;
- algoritmo sempre explícito no contrato;
- `INTEGRITY_CONTRACT_VERSION = 1.0.0`.

O campo é representado como `algorithm + value`, evitando acoplamento estrutural permanente a um nome como `sha256Digest`. A evolução futura para outro algoritmo exigirá decisão/versionamento explícitos, nunca inferência pelo tamanho da string.

MD5, SHA-1 ou hash provider-specific não são aceitos no boundary.

## 4. Origem autoritativa do digest

O digest de C.2.3 é calculado sobre os bytes efetivamente relidos do staging privado após o upload.

```text
TemporaryStagingArtifactDescriptor (STAGED)
  -> locator validado internamente
  -> provider privado
  -> readback do objeto armazenado
  -> SHA-256 dos bytes relidos
  -> TemporaryStagingIntegrityEvidence
```

O digest não é calculado apenas sobre o payload alegadamente enviado ao adapter. Essa decisão permite provar o estado físico observado no staging no instante da verificação.

O primeiro adapter físico usa `SupabaseTemporaryStagingAdapter`, mas o contrato permanece provider-neutral. Bucket, path, URL, signed URL, SDK, região e credenciais não saem do adapter.

## 5. Contrato de evidência

`TemporaryStagingIntegrityEvidence` registra somente:

- versão do contrato;
- artifact ID;
- `processing_run`;
- `source_version`;
- `received_file`;
- algoritmo;
- digest;
- quantidade de bytes fisicamente observada;
- instante de verificação;
- correlation ID.

A evidência não contém:

- bytes;
- texto extraído;
- nome original do arquivo;
- bucket;
- path físico;
- signed URL;
- secret;
- credencial;
- erro bruto de provider.

O vínculo com a fonte governada de C.1 permanece reconstruível pela relação canônica da `source_version`; C.2.3 não cria uma segunda fonte de verdade repetindo identidade bibliográfica ou `source` sem necessidade.

## 6. Estado `VERIFIED`

C.2.3 materializa a parcela técnica de:

```text
STAGED -> VERIFIED
```

no lifecycle do artefato temporário.

`VERIFIED` significa somente que:

1. o artefato ainda estava disponível dentro da retenção;
2. o locator correspondia ao `processing_run + artifactId` esperado;
3. o objeto armazenado foi relido;
4. o digest SHA-256 foi calculado sobre esse readback;
5. o byte length fisicamente observado é coerente com o descriptor de staging;
6. a evidência mantém os mesmos vínculos de `source_version`, `received_file`, `processing_run` e artifact;
7. não existe conflito histórico conhecido em que o mesmo artefato físico tenha sido observado com digest diferente.

`VERIFIED` não significa:

- aprovação humana;
- aprovação editorial;
- unicidade;
- equivalência bibliográfica;
- equivalência jurídica;
- equivalência semântica;
- aprovação para extração;
- `RELEASED_FOR_EXTRACTION`.

C.2.3 não executa `VERIFIED -> PENDING_REVIEW`, `APPROVED_FOR_EXTRACTION` ou qualquer handoff para C.3.

## 7. Duplicidade técnica

A policy classifica digest idêntico de forma explícita e auditável nas relações:

- `same_artifact` — mesma identidade física `processing_run + artifactId` já observada com o mesmo digest;
- `same_run` — outro artifact no mesmo `processing_run` com bytes idênticos;
- `same_source_version` — bytes idênticos em outro run ligados à mesma `source_version`;
- `cross_source_version` — bytes idênticos ligados a outra `source_version`.

A presença de qualquer uma dessas relações produz `duplicate`, mas não altera nenhuma identidade.

Duplicidade binária, por si, não bloqueia a verificação técnica. Um arquivo pode estar íntegro e ainda ser duplicado. A policy produz a informação para auditoria e para gates posteriores.

A exceção fail-closed é o conflito histórico do **mesmo artefato físico**: se `processing_run + artifactId` já tiver evidência com digest diferente, C.2.3 rejeita a promoção para `VERIFIED` com `STAGING_INTEGRITY_DIGEST_CONFLICT`.

Replay de comando não é deduplicação por hash. Replay/idempotência continuam sob os contratos de C.2.1 e a implementação persistida de C.2.4.

## 8. Filename

Filename não participa da chave de duplicidade.

- mesmo nome + bytes diferentes: não é duplicidade binária;
- nomes diferentes + bytes iguais: é duplicidade binária;
- o nome original continua fora do object key físico e fora da evidência de integridade.

## 9. Fail-closed

A promoção técnica para `VERIFIED` é negada quando ocorrer, entre outros:

- artefato expirado;
- algoritmo não suportado;
- digest fora da representação canônica;
- mismatch de artifact/run/source_version/received_file;
- byte length observado divergente;
- timestamp de verificação fora da janela válida;
- mesmo artefato físico previamente observado com digest diferente;
- locator opaco incompatível com o `processing_run + artifactId` esperado;
- falha de download/readback;
- falha de hashing.

Erros do provider são traduzidos para erros sanitizados do boundary de persistência.

## 10. Persistência

C.2.3 não adiciona:

- migration;
- tabela;
- índice global de hash;
- RPC;
- RLS;
- grant;
- trigger;
- fila;
- worker.

A classificação recebe evidências conhecidas por uma superfície provider-neutral e pode ser provada com fixtures/in-memory neste sublote.

A persistência transacional das evidências, lookup concorrente, replay, retomada, compare-and-swap e recuperação segura pertencem a C.2.4. Antecipá-los aqui misturaria integridade física com idempotência/recovery.

## 11. Segurança

C.2.3 mantém:

- fail-closed;
- staging privado;
- locator opaco;
- nenhuma signed URL compartilhada;
- nenhuma credencial em contrato/receipt;
- nenhuma exposição de bucket/path;
- nenhuma credencial hospedada em CI;
- nenhum conteúdo real;
- nenhum acesso à produção.

A prova física utiliza somente bytes sintéticos e Supabase local/descartável no runner do GitHub Actions.

## 12. Testes

A suíte C.2.3 cobre pelo menos:

- SHA-256 conhecido para fixture sintética;
- hexadecimal minúsculo canônico;
- digest calculado sobre readback;
- mutação pós-staging alterando o digest observado;
- byte length físico;
- mismatch de vínculo;
- locator inválido antes do provider;
- algoritmo não suportado;
- erro provider sanitizado;
- artefato expirado;
- timestamp inválido;
- reverificação consistente;
- conflito do mesmo artefato com digest diferente;
- duplicidade no mesmo run;
- duplicidade em outro run da mesma `source_version`;
- duplicidade entre `source_version`s;
- preservação das identidades diante de digest igual;
- regressão dos boundaries C.2.1 e C.2.2.

## 13. Prova remota descartável

O workflow dedicado é:

`.github/workflows/knowledge-factory-c2-3-integrity-ci.yml`.

Ele:

1. cria projeto Supabase local temporário no runner;
2. inicia Storage somente na stack descartável;
3. captura e mascara credenciais locais efêmeras;
4. executa typecheck dos três packages envolvidos;
5. executa testes unitários de policy e adapter;
6. executa regressões C.2.1/C.2.2;
7. cria bucket privado descartável;
8. prova digest de readback, mutação e duplicidade com bytes sintéticos;
9. produz artifact de evidência sanitizada;
10. destrói a stack no final.

Nenhum Supabase hospedado, bucket hospedado, secret real ou conteúdo protegido participa da prova.

## 14. Não escopo preservado

C.2.3 não implementa:

- idempotência persistida de C.2.4;
- replay distribuído por digest;
- recovery/retomada;
- lock/CAS transacional;
- persistência definitiva de evidências;
- revisão humana de C.2.5;
- `RELEASED_FOR_EXTRACTION`;
- C.2.6;
- C.3;
- extração;
- OCR;
- parser;
- páginas;
- chunking;
- embeddings;
- deduplicação semântica;
- equivalência editorial automática;
- identidade bibliográfica por hash;
- PDF real;
- PNLD real;
- conteúdo protegido;
- storage hospedado;
- Supabase hospedado;
- produção.

## 15. Gate de saída de C.2.3

C.2.3 estará apto à integração quando:

- contrato de integridade estiver provider-neutral e versionado;
- SHA-256 for calculado sobre bytes relidos do staging;
- `VERIFIED` estiver materializado apenas como estado técnico;
- vínculos canônicos forem preservados;
- digest igual não colapsar identidades;
- conflitos do mesmo artefato físico forem fail-closed;
- nenhum mecanismo de C.2.4 for antecipado;
- nenhum bucket/path/secret aparecer em contrato ou evidência;
- testes unitários e de boundary estiverem verdes;
- prova descartável em Storage estiver verde;
- regressões C.2.1/C.2.2 estiverem verdes;
- CI geral estiver verde;
- diff integral estiver revisado;
- branch estiver `0 behind` antes do merge;
- nenhuma thread estiver pendente.

A conclusão de C.2.3 não autoriza C.2.4, C.2.5, C.2.6 ou C.3.
