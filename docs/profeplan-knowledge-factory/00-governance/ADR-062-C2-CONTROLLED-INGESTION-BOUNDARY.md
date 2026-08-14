# ADR-062 — C.2 separa ingestão controlada de extração e segmentação

Data: 14 de agosto de 2026.

**Status:** proposto para integração com a definição documental do Lote C.2.

## Contexto

O Lote C.1 encerrou a governança do lifecycle de fontes e fechou `GAP-3B-04`. A arquitetura já
possui identidades `received_file` e `processing_run`, além das finalidades `temporary_staging`,
`ingestion` e `extraction`.

Entretanto, C.1 não implementa ingestão. A fronteira transacional C.1.3 deliberadamente limita seus
comandos a identidades do lifecycle registral e não deve ser ampliada por conveniência para operar
`processing_run`.

O mapa da Fase C separa:

- C.2 — ingestão controlada;
- C.3 — extração e validação;
- C.4 — segmentação e classificação.

Também existem scripts e serviços legados no repositório chamados de “ingestão”, alguns misturando
frontend, chunking ou persistência histórica. A afinidade nominal não os torna arquitetura canônica
da Knowledge Factory.

## Decisão

1. **C.2 será a autoridade operacional da execução de ingestão.**
2. C.2 consumirá a governança e autorização de C.1 sem duplicar seu lifecycle jurídico-editorial.
3. `temporary_staging`, `ingestion` e `extraction` permanecerão finalidades distintas; uma nunca será
   inferida a partir da outra.
4. C.2 poderá admitir bytes somente em staging temporário, isolado e com descarte verificável.
5. Bytes, PDFs, renderizações e conteúdo bruto não integrarão Postgres nem o corpus permanente.
6. C.2 verificará integridade, tamanho, formato, duplicidade técnica, replay e vínculo com a versão
   governada, mas não interpretará semanticamente o conteúdo.
7. C.3 será a única autoridade para extração; C.4 será a única autoridade para segmentação/chunking.
8. `processing_run` não será adicionado às RPCs de C.1.3 apenas para reutilização técnica. C.2 terá
   sua própria fronteira transacional quando o sublote responsável for autorizado.
9. Contratos compartilhados de C.2 serão provider-neutral e não exporão bucket, signed URL,
   `SupabaseClient`, SQLSTATE ou detalhes de SDK.
10. O piloto exigirá revisão humana antes do handoff para C.3.
11. Conteúdo real continuará bloqueado até decisão específica sobre corpus, fundamento,
    finalidade, retenção e ambiente operacional.
12. Código legado de ingestão somente poderá ser reutilizado mediante auditoria explícita de
    compatibilidade; por padrão, não é considerado implementação de C.2.

## Consequências

### Positivas

- preserva separação de responsabilidades entre governança, ingestão, extração e segmentação;
- impede que frontend ou scripts históricos se tornem pipeline canônico por acidente;
- evita ampliar C.1.3 fora de seu escopo aprovado;
- mantém storage e Supabase fora dos contratos compartilhados;
- permite testar C.2 com fixtures sintéticas e infraestrutura descartável;
- mantém a minimização de conteúdo bruto como regra arquitetônica.

### Custos e riscos

- C.2 exigirá contratos e persistência próprios para execução de ingestão;
- staging seguro exigirá política explícita de retenção e descarte antes de fonte real;
- a passagem C.2 -> C.3 exigirá handoff formal, não chamada ad hoc;
- duplicidade binária precisará ser tratada sem colapsar identidade jurídica/editorial;
- infraestrutura legada potencialmente reutilizável terá de provar compatibilidade antes de ser
  incorporada.

## Alternativas rejeitadas

### Reusar o serviço legado de frontend como pipeline C.2

Rejeitado porque mistura leitura de arquivo, chunking e acesso Supabase e não respeita a separação
C.2/C.3/C.4.

### Ampliar C.1.3 para operar `processing_run`

Rejeitado porque mistura lifecycle jurídico-editorial com execução operacional de ingestão e altera
uma fronteira já fechada e testada.

### Armazenar PDFs no Postgres para simplificar rastreabilidade

Rejeitado por minimização, segurança, custo e porque rastreabilidade deve ser mantida por identidade,
digest, localizadores e receipts, não por retenção permanente do arquivo bruto.

### Tratar grant de `ingestion` como autorização automática para `extraction`

Rejeitado porque viola a autorização por finalidade definida em C.1.

## Autoridade

A definição detalhada desta decisão está em:

`12-delivery/LOT-C2-CONTROLLED-INGESTION-DEFINITION.md`.

A integração deste ADR não autoriza C.2.1, arquivo real, storage hospedado, extração, C.3 ou
produção.
