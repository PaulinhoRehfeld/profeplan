# Lote C.3 — Definição de extração e validação do conteúdo extraído

**Status:** proposta exclusivamente documental neste Draft PR; C.3.1–C.3.8 bloqueados

**Base canônica inspecionada:** `main@287d5ae989d6b4f0504fee4f6fb16d554f97fbfb`

**ADR de fronteira:** [ADR-063](../00-governance/ADR-063-C3-EXTRACTION-VALIDATION-BOUNDARY.md)

## 1. Objetivo

C.3 transforma um artefato governado e elegível recebido de C.2 em uma representação extraída
observável, rastreável, mensurável e revisável. O lote responde:

> O que foi fisicamente observado e extraído do artefato, com qual método, cobertura, proveniência,
> autorização vigente e decisão de qualidade?

C.3 não responde o que um trecho significa pedagogicamente, onde começa um segmento semântico, qual
hierarquia editorial deve ser confirmada, como o conteúdo se alinha à BNCC ou se está pronto para
retrieval. Essas decisões começam em C.4 ou em lotes posteriores.

Esta definição não implementa nada. Não cria código, migration, schema, parser, OCR, conteúdo real,
recursos hospedados, wiring ou produção.

## 2. Autoridade e pré-condições

C.3 somente poderá operar quando todas as condições seguintes forem verdadeiras no tempo corrente:

- existe fonte e versão governadas por C.1;
- existe `IngestionHandoffEvidence` válido, versionado e read-only emitido por C.2;
- existe artefato temporário íntegro e legível por porta autorizada;
- `purpose=extraction` está vigente e é compatível com sujeito, versão, restrições e operação;
- o sublote técnico correspondente foi explicitamente autorizado;
- execução ocorre apenas em fixture e infraestrutura descartáveis até autorização em contrário.

O handoff de C.2 é necessário e insuficiente. Ele não concede autorização permanente, não garante
que os bytes continuem disponíveis e não prova qualidade ou cobertura de extração.

## 3. Fronteiras entre C.1, C.2, C.3 e C.4

| Camada | Autoridade | Produz | Não produz |
|---|---|---|---|
| C.1 | identidade, fundamento, permissão e vigência | fonte/versão e decisão de autorização | bytes, ingestão ou extração |
| C.2 | staging, integridade, vínculo e revisão de ingestão | artefato temporário, digest, receipts/events e handoff | páginas, texto, cartografia ou executor C.3 |
| C.3 | extração e validação observável | páginas, texto, elementos observados, métricas, cobertura e handoff C.4 | chunks semânticos, hierarquia confirmada, BNCC ou conhecimento destilado |
| C.4 | segmentação e classificação estrutural | segmentos/chunks, hierarquia editorial confirmada e classificação | mutação retroativa da evidência C.3 |

## 4. Princípios contract-first

1. C.3 terá `EXTRACTION_CONTRACT_VERSION` independente.
2. Identidades compostas e timestamps são explícitos; nenhum locator ou nome de arquivo vira
   identidade por conveniência.
3. Commands expressam intenção; receipts registram resultado; events formam histórico
   autoritativo; snapshots são projeções reconstruíveis.
4. Mutação exige idempotency key, fingerprint determinístico, versão esperada e compare-and-set.
5. Replays compatíveis retornam o mesmo efeito lógico; colisões incompatíveis falham fechado.
6. Tipos provider-neutral não expõem bucket, URL assinada, SDK, parser ou provedor OCR.
7. Entradas desconhecidas, versões incompatíveis, autorização inválida e transições ilegais são
   rejeitadas sem efeito parcial.
8. O contrato não reutiliza informalmente recovery, handoff ou receipt de C.2 para funções novas.

## 5. Identidade e vínculos mínimos

A identidade de C.3 deverá distinguir, no mínimo:

- `extractionRunId`;
- `sourceId` e `sourceVersionId`;
- `ingestionRunId` e versão do `IngestionHandoffEvidence`;
- digest canônico do artefato;
- versão do contrato de extração;
- método e versão do extrator;
- tentativa e origem de retomada, quando houver;
- ator técnico e autoridade de negócio avaliados separadamente.

Nenhum campo novo é presumido dentro do contrato C.2. C.3 consome a evidência publicada por C.2 e
mantém os próprios vínculos.

## 6. Lifecycle de referência

O lifecycle candidato, a ser cristalizado e testado em C.3.1, é:

| Estado | Significado | Efeito permitido |
|---|---|---|
| `REQUESTED` | intenção aceita, sem claim | preparar validações |
| `READY` | pré-condições verificadas para claim | disputar claim |
| `EXTRACTING` | leitura/extrator em andamento | persistir lotes incrementais |
| `VALIDATING` | extração encerrada, cobertura/qualidade em cálculo | reconciliar e avaliar |
| `PENDING_REVIEW` | decisão humana requerida | aceitar, rejeitar ou reprocessar |
| `VALIDATED_FOR_SEGMENTATION` | saída C.3 aceita | emitir snapshot read-only para C.4 |

Saídas controladas: `REQUIRES_ALTERNATE_EXTRACTION`, `BLOCKED_AUTHORIZATION`, `REJECTED`,
`FAILED` e `CANCELLED`.

Não existe estado durável `AUTHORIZED`. Vigência é reavaliada imediatamente antes de:

1. claim da execução;
2. cada abertura ou retomada relevante da leitura do artefato;
3. finalização e emissão do handoff para C.4.

Se a autorização expirar, for suspensa, revogada ou deixar de abranger o efeito, o run não avança e
registra bloqueio explícito.

## 7. Porta de leitura do artefato

C.3 introduzirá uma porta estreita, provider-neutral e read-only. Seu contrato deverá oferecer apenas
o necessário para:

- abrir stream/bytes por referência opaca governada;
- obter metadados mínimos de integridade e retenção;
- revalidar digest e tamanho antes do uso;
- encerrar o handle sem promover cópia permanente;
- distinguir indisponibilidade, expiração, integridade inválida e negação de autorização.

A porta não fornece URL pública, credencial, listagem irrestrita de storage ou escrita arbitrária.
O adapter concreto permanece detalhe de infraestrutura. `service_role` não substitui a decisão de
autorização.

## 8. Extração nativa e fallback

A camada textual nativa é o baseline. C.3.3 deverá provar o fluxo com PDFs inteiramente sintéticos e
sem conteúdo protegido.

OCR não pertence ao baseline. C.3.7 deverá primeiro definir:

- evidência objetiva de insuficiência nativa;
- granularidade do fallback por página ou elemento;
- autorização e restrições aplicáveis;
- limites de custo, retenção e dados;
- métricas e revisão obrigatórias;
- efeitos de reprocessamento e substituição;
- critérios para escolher ou rejeitar um provedor.

Até que C.3.7 seja autorizado, implementado e revisado, `REQUIRES_ALTERNATE_EXTRACTION` é a saída
para ausência ou corrupção da camada textual; nenhum OCR é executado.

## 9. Representação observável e proveniência

C.3 poderá registrar:

- página física e, quando observada, paginação impressa;
- blocos/linhas e ordem de leitura observada;
- texto bruto transitório e texto normalizado persistível conforme policy;
- cabeçalho, rodapé, nota, box, coluna e outros tipos físicos observados;
- relações físicas de tabela: linha, coluna, célula, span e cabeçalho, quando expostas pelo adapter;
- marcador de imagem, mapa, gráfico ou infográfico, tipo observado e localizador lógico;
- método, versão, digest, timestamps e métricas por unidade;
- origem de correção ou decisão humana.

C.3 não inventa descrição semântica de imagem, intenção editorial, título de capítulo, conceito,
habilidade, disciplina, ano, currículo ou BNCC. Um rótulo vindo do documento continua sendo
observação, não validação externa.

Localizadores são lógicos. Coordenadas normalizadas poderão ser avaliadas em sublote próprio quando
necessárias para proveniência; coordenadas em pixels, renderizações e recortes não integram o corpus
definitivo por padrão.

## 10. Qualidade e cobertura

C.3.1 define vocabulário; C.3.5 cristaliza policy e thresholds com evidência. A definição não escolhe
números arbitrários.

As métricas candidatas incluem:

- páginas esperadas, abertas, extraídas, vazias, rejeitadas e pendentes;
- elementos esperados/observados e cobertura por método;
- caracteres inválidos ou de substituição;
- densidade e continuidade textual;
- ordem de leitura ambígua;
- integridade de relações tabulares observadas;
- falhas, retries, duração e bytes lidos;
- necessidade, decisão e resultado de revisão humana.

Gates não compensatórios:

- autorização inválida;
- digest divergente;
- página elegível sem decisão;
- proveniência quebrada;
- versão contratual incompatível;
- efeito parcial não reconciliado.

Boa média documental não compensa qualquer um desses gates.

## 11. Revisão humana

A revisão recebe snapshot imutável suficiente para decidir sem alterar o histórico. Os comandos
mínimos deverão cobrir aceitação, rejeição, solicitação de reprocessamento, cancelamento e registro
de exceção. Cada decisão fixa ator, competência, fundamento, fingerprint, versão esperada e
timestamp.

Correção humana não apaga saída original. O resultado anterior permanece histórico e a correção
gera nova evidência vinculada.

## 12. Idempotência, concorrência e recuperação

- claim concorrente admite um único vencedor;
- batches incrementais usam identidade e sequência determinísticas;
- replay do mesmo command/fingerprint não duplica páginas, receipts ou events;
- mesmo command com fingerprint divergente falha fechado;
- retomada continua do último boundary confirmado;
- finalize concorre por compare-and-set e ocorre uma única vez;
- cancelamento bloqueia novos efeitos e dispara cleanup compatível;
- falha entre persistência e evento não deixa sucesso invisível;
- cleanup é repetível e emite evidência do resultado.

## 13. Persistência, RLS e grants futuros

C.3.2 deverá separar:

- identidade/configuração do run;
- projeção de estado;
- receipts e events append-only;
- páginas/elementos e seus lotes;
- métricas/reconciliação;
- decisões humanas;
- handoff read-only para C.4.

Todas as tabelas começam deny-by-default. Escrita ocorre apenas pela superfície atômica autorizada;
leitura administrativa obedece RLS. Nenhuma tabela, RPC, migration ou grant é criada nesta proposta
documental.

## 14. Observabilidade

A telemetria técnica deverá correlacionar `extractionRunId`, source/version, ingestion run,
command, receipt, event, tentativa, método e versão sem expor bytes, texto protegido, credenciais ou
locator sensível. Logs não são histórico de negócio e não substituem receipts/events.

Métricas operacionais distinguem sucesso, bloqueio de autorização, baixa qualidade, falha técnica,
cancelamento, retry e cleanup. Alertas não promovem estado automaticamente.

## 15. Sublotes C.3.1–C.3.8

### C.3.1 — Contratos, lifecycle e fixtures

**Inclui:** tipos provider-neutral; identidade; commands/results; receipts/events; state machine;
proveniência; vocabulário de qualidade; incompatibilidade de versões; fixtures sintéticas.

**Gate:** testes unitários cobrem transições, idempotência contratual, fingerprints, serialização e
falha fechada. Não inclui schema, adapter, parser ou OCR.

### C.3.2 — Control plane persistente e segurança

**Inclui:** schema descartável; RPC/transação atômica; autorização temporal; CAS; receipts/events;
RLS/grants; rollback seguro no ambiente descartável.

**Gate:** DB CI prova atomicidade, replay, corridas, reconstrução, deny-by-default e negativos de
autorização. Não inclui conteúdo real nem recursos hospedados persistentes.

### C.3.3 — Porta do artefato e extração textual nativa

**Inclui:** porta read-only; adapter mínimo; validação de digest; parser nativo; PDFs sintéticos;
proveniência de método/versão.

**Gate:** fixtures com páginas simples, vazias, múltiplas colunas e texto corrompido produzem saídas
determinísticas ou exceções explícitas. Não inclui OCR.

### C.3.4 — Persistência incremental e reconciliação

**Inclui:** batches de páginas/elementos; ordem; cobertura; retomada; deduplicação; proveniência
granular.

**Gate:** interrupção/replay não duplica efeitos; toda página termina extraída, rejeitada, pendente
ou descartada com motivo.

### C.3.5 — Qualidade, policy e revisão

**Inclui:** métricas; policy versionada; thresholds baseados em fixtures; fila de revisão; aceitar,
rejeitar e reprocessar.

**Gate:** baixa qualidade não alcança `VALIDATED_FOR_SEGMENTATION`; decisão humana é auditável e
replay-safe.

### C.3.6 — Recovery, concorrência, cancelamento e cleanup

**Inclui:** lease/claim se adotado; timeout; retries; retomada; corridas; cancelamento; retenção e
cleanup.

**Gate:** testes de falha injetada e concorrência demonstram efeito único, ausência de órfãos e
descarte verificável.

### C.3.7 — Decisão governada de OCR e exceções visuais

**Inclui:** critérios de fallback, contrato, privacy/security review, limites, métricas e plano de
avaliação provider-neutral.

**Gate:** decisão explícita autoriza ou rejeita a introdução de adapter OCR. O baseline deste lote
não pressupõe provedor nem execução OCR.

### C.3.8 — Prova integrada e fechamento

**Inclui:** E2E sintético C.2 handoff → C.3 → handoff read-only C.4; negativos de segurança;
reprocessamento; revogação temporal; cleanup; documentação e checkpoint.

**Gate:** CI verde, diff auditado, nenhuma superfície C.4 executora e nenhuma dependência de conteúdo
real, storage hospedado ou produção.

## 16. Definition of Ready para C.3.1

Antes de abrir C.3.1:

- esta definição e ADR-063 foram revisadas e integradas por humano;
- existe checkpoint pós-merge que reconfirma SHA, tree, parent e CI;
- `main` foi reinspecionada para mudanças concorrentes;
- nomes candidatos foram comparados com símbolos legados;
- fixtures sintéticas e política de dados foram aprovadas;
- escopo do sublote, testes e rollback estão fechados;
- autorização humana específica para C.3.1 foi registrada.

## 17. Definition of Done do lote C.3

C.3 somente fecha quando:

- C.3.1–C.3.8 foram autorizados, integrados e checkpointados individualmente;
- contratos e migrations aplicáveis têm testes unitários, integração e DB CI;
- E2E sintético prova caminho positivo e negativos de segurança;
- autorização é revalidada nos três instantes definidos;
- cobertura e proveniência são completas;
- baixa qualidade e falha nunca promovem o run;
- retries, cancelamento e cleanup são comprovados;
- handoff para C.4 é versionado, read-only e não executa C.4;
- não há conteúdo real ou infraestrutura de produção sem autorização separada.

## 18. Governança de branch, PR e TOCTOU

Cada sublote deverá usar branch e PR próprios. Antes de qualquer merge:

1. registrar head do PR e head corrente da `main`;
2. comparar base/head e confirmar apenas paths autorizados;
3. avaliar commits concorrentes e colisões semânticas;
4. exigir revisão humana e checks verdes;
5. após merge, confirmar commit, tree, parent, diff efetivo e CI da árvore composta;
6. emitir checkpoint antes de autorizar o sublote seguinte.

A integração desta documentação não é autorização implícita para C.3.1.

## 19. Fora de escopo desta definição

- qualquer código, migration, tabela, RPC, adapter ou workflow;
- parser executável, OCR ou modelo multimodal;
- PDF, livro, PNLD ou conteúdo real;
- bucket, Storage/Supabase hospedados ou credenciais;
- wiring runtime, cron, fila, produção ou backfill;
- descrições semânticas geradas de imagens;
- chunks, embeddings, segmentação, classificação, BNCC ou retrieval;
- agente autônomo ou orquestrador de produção;
- merge desta própria proposta sem decisão humana.

## 20. Próximo passo permitido

Se este Draft PR for revisado e integrado, o próximo passo possível é emitir checkpoint documental e
solicitar autorização específica para **C.3.1**. Nenhum outro sublote é aberto por continuidade.
