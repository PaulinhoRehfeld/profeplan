# Lote C.3 — Definição de extração e validação do conteúdo extraído

**Status:** proposta exclusivamente documental neste Draft PR; C.3.1–C.3.8 bloqueados até integração

**Base canônica inspecionada:** `main@287d5ae989d6b4f0504fee4f6fb16d554f97fbfb`

**ADR de fronteira:** [ADR-063](../00-governance/ADR-063-C3-EXTRACTION-VALIDATION-BOUNDARY.md)

**Governança operacional:** [execução proporcional ao risco](../00-governance/RISK-PROPORTIONAL-EXECUTION-GOVERNANCE.md)

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
- a execução permanece dentro da fronteira de risco e escopo autorizada para o lote;
- fixtures, testes, CI e infraestrutura descartável seguem Nível A; mudanças materiais escalam para
  Nível B ou C conforme a política de governança.

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

Até que a fronteira C.3.7 seja aprovada como Nível B, implementada e revisada,
`REQUIRES_ALTERNATE_EXTRACTION` é a saída para ausência ou corrupção da camada textual; nenhum OCR é
executado.

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

**Gate:** decisão explícita de Nível B autoriza ou rejeita a introdução de adapter OCR. O baseline
deste lote não pressupõe provedor nem execução OCR.

### C.3.8 — Prova integrada e fechamento

**Inclui:** E2E sintético C.2 handoff → C.3 → handoff read-only C.4; negativos de segurança;
reprocessamento; revogação temporal; cleanup; documentação de fechamento.

**Gate:** CI verde, diff auditado, nenhuma superfície C.4 executora e nenhuma dependência de conteúdo
real, storage de produção ou produção.

## 16. Definition of Ready para iniciar C.3.1

Antes de iniciar C.3.1:

- esta definição, ADR-063 e a política de execução proporcional ao risco foram revisadas e integradas;
- `main` foi reinspecionada para mudanças concorrentes relevantes;
- nomes candidatos foram comparados com símbolos legados;
- fixtures sintéticas e política de dados estão delimitadas;
- escopo técnico de C.3.1, invariantes e gates estão fechados.

Não é necessário emitir checkpoint intermediário nem solicitar nova microautorização para cada
commit, fixture, teste, correção ou reexecução de CI de Nível A.

## 17. Definition of Done do lote C.3

C.3 somente fecha quando:

- C.3.1–C.3.8 satisfizeram seus gates técnicos e foram integrados conforme a fronteira material de
  risco aplicável;
- contratos e migrations aplicáveis têm testes unitários, integração e DB CI;
- E2E sintético prova caminho positivo e negativos de segurança;
- autorização é revalidada nos três instantes definidos;
- cobertura e proveniência são completas;
- baixa qualidade e falha nunca promovem o run;
- retries, cancelamento e cleanup são comprovados;
- handoff para C.4 é versionado, read-only e não executa C.4;
- qualquer conteúdo real usado no processo foi previamente autorizado em fronteira de Nível B;
- não há infraestrutura ou efeito de produção sem autorização de Nível C;
- o fechamento integrado de C.3 é documentado de forma suficiente para handoff a C.4.

## 18. Governança de branch, PR e TOCTOU

Branch e PR continuam como unidades preferenciais de isolamento e revisão, mas a execução segue a
política proporcional ao risco:

1. atividades de Nível A podem avançar em sequência dentro do escopo do lote sem autorização humana
   nova por microação;
2. cada PR técnico relevante deve registrar head, base, paths, gates e efeitos materiais;
3. avanço concorrente da `main` deve ser avaliado antes do merge e auditado depois dele;
4. correções necessárias para cumprir os gates do próprio escopo podem ser feitas e testadas sem
   reabrir autorização;
5. checkpoint intermediário é opcional e só deve ser criado quando houver mudança material de
   fronteira, incidente, handoff importante ou ganho real de continuidade;
6. merges, conteúdo real, providers novos e recursos hospedados seguem Nível B quando aplicável;
7. produção, secrets, dados sensíveis, efeitos financeiros e operações destrutivas seguem Nível C.

A integração desta documentação autoriza a continuidade técnica de Nível A em C.3.1–C.3.6, mas não
autoriza por si só conteúdo real, OCR/provider novo, produção, credenciais ou dados sensíveis.

## 19. Fora de escopo desta definição

- qualquer código, migration, tabela, RPC, adapter ou workflow nesta proposta documental;
- parser executável, OCR ou modelo multimodal nesta proposta;
- PDF, livro, PNLD ou conteúdo real sem autorização Nível B;
- bucket, Storage/Supabase de produção ou credenciais;
- wiring runtime de produção, cron/fila de produção ou backfill;
- descrições semânticas geradas de imagens;
- chunks, embeddings, segmentação, classificação, BNCC ou retrieval;
- agente autônomo ou orquestrador de produção;
- qualquer efeito Nível C sem decisão humana específica.

## 20. Próximo passo permitido

Após revisão e integração desta definição, **C.3.1 pode começar imediatamente como execução Nível A**
em branch/PR, com fixtures sintéticas, testes e infraestrutura descartável. C.3.2–C.3.6 podem seguir
pela mesma autorização agrupada quando cada gate técnico anterior estiver satisfeito.

O primeiro uso de PDF/conteúdo real juridicamente autorizado será uma fronteira Nível B separada.
OCR/provider novo também será Nível B. Produção, secrets e dados pessoais/sensíveis permanecem Nível C.
