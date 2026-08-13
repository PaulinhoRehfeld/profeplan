# CONTINUITY CHECKPOINT 034 — C.0 integrado e definição documental de C.1 concluída

Data: 12 de agosto de 2026.

## Status

**O Lote C.0 foi integrado à `main` pelo PR nº 31. A definição documental do Lote C.1 — Governança
operacional do lifecycle de fontes — foi concluída localmente nesta branch, sem iniciar nenhum
sublote técnico. `GAP-3B-04`, `GAP-3B-05` e `GAP-3B-07` permanecem ativos. C.2 e as Fases D–G
continuam bloqueados.**

## Estado canônico pós-merge

Repositório:

`PaulinhoRehfeld/profeplan`

Branch canônica:

`main`

Commit remoto verificado antes de qualquer edição:

`a370d2f80663f2ae5a6bc0aa2ba5942d85db9708`

Título:

`docs(knowledge-factory): map and govern Phase C entry (#31)`

Árvore:

`cea333ad456aaac6d3d120ccdeee85e95672bd09`

Pull Request integrado:

`#31`

A verificação confirmou que a `main` remota coincide com o commit esperado. Nenhuma divergência de
base foi detectada.

## Encerramento documental de C.0

Com a integração do PR nº 31:

- C.0 deixa de estar “pronto para publicação” e passa a **integrado/encerrado documentalmente**;
- o mapa C.0–C.7 passa a compor a navegação canônica;
- C.1 torna-se o primeiro lote elegível apenas para definição documental específica;
- nenhuma implementação técnica da Fase C foi iniciada pelo merge;
- o PR nº 31 não autorizou ingestão, conteúdo real, migration, RPC, RLS, wiring, Supabase hospedado
  ou produção.

## Escopo desta continuidade

Autorizado nesta conversa:

- verificar a `main` pós-merge;
- reconstruir/sincronizar a base documental local contra o SHA canônico;
- criar branch documental local;
- formalizar este checkpoint;
- definir integralmente C.1 em documentação;
- atualizar navegação e decisões necessárias;
- validar o pacote documental;
- criar commit local se todos os gates forem satisfeitos.

Não autorizado:

- push;
- PR;
- merge;
- branch remota;
- alteração de produção;
- qualquer implementação de C.1.1–C.1.6;
- C.2;
- código TypeScript;
- migration/SQL/RPC/RLS/grant;
- Supabase hospedado;
- service role real;
- ingestão, OCR, extração, chunking, embeddings, destilação ou componentização;
- agentes, frontend, API, job ou fila.

## Branch documental local

`docs/knowledge-factory-lot-c1-definition`

A branch foi preparada exclusivamente para documentação.

## Diagnóstico herdado de C.1

A inspeção reconciliou cinco camadas já existentes:

1. `EPIC-002`, `F-002.1`, `F-002.2`, `US-002.1` e `US-002.2` exigem fonte identificável,
   procedência, licença/finalidade, histórico de alteração e bloqueio de conteúdo não autorizado;
2. `@profeplan/types` já possui `KnowledgeSource`, `SourceVersion`, `SourcePermissionEvent`, quatro
   `SourceStatus`, quatro `SourceUse` e três ações de permissão;
3. a política `evaluateSourceEligibility()` já combina status, `allowedUses`, categoria de licença e
   último evento por uso;
4. o schema já possui `kf_sources`, `kf_source_versions`, `kf_source_permission_events` e proteção
   append-only para eventos, porém ainda não materializa integralmente identidade bibliográfica,
   vigência, ator, fundamento ou autorização temporal;
5. `SupabaseKnowledgeSourceRepository` cobre apenas a porta mínima e não escreve versão, segmento ou
   evento de permissão.

Conclusão:

> C.1 deve evoluir a fundação existente de forma incremental. Não deve substituir o modelo atual por
> uma taxonomia paralela nem transformar `save(source)` em lifecycle multi-tabela por conveniência.

## Ambiguidades resolvidas documentalmente

### 1. “Fonte autorizada” não será um único estado

A futura arquitetura separará:

- lifecycle registral da fonte;
- lifecycle da autorização por finalidade;
- elegibilidade efetiva derivada por finalidade e instante.

Isso evita sobrecarregar `approved` com significado bibliográfico, jurídico e operacional ao mesmo
tempo.

### 2. Obra, edição, manifestação e arquivo não são sinônimos

Foram definidos como identidades distintas. Hash de arquivo serve para integridade/duplicidade e não
substitui identidade bibliográfica ou jurídica.

### 3. Permissão corrente não substitui histórico

`allowedUses` poderá continuar como projeção de compatibilidade, mas a autoridade futura deverá ser
histórica, append-only, temporal e consultável “as of”.

### 4. Revogação não significa apagar tudo

Foram separadas:

- elegibilidade para novos usos;
- retenção jurídica/auditável;
- descarte quando exigido.

### 5. `service_role` não é permissão de negócio

Identidade técnica nunca substitui autorização jurídica/editorial. A futura fronteira de comando
deverá reduzir DML direto e usar operações server-only estreitas, auditadas e com menor privilégio.

## Definição documental de C.1

Documento novo:

`12-delivery/LOT-C1-SOURCE-LIFECYCLE-GOVERNANCE-DEFINITION.md`

O documento formaliza:

- modelo de identidade;
- máquinas de estado ortogonais;
- finalidades de uso;
- permissão histórica e vigência;
- comandos e eventos;
- ator e fundamento;
- idempotência e concorrência;
- atomicidade;
- falhas provider-neutral;
- propagação de impacto;
- persistência física candidata;
- RLS, grants, service role e minimização;
- contratos e adapters;
- testes;
- DoR/DoD de C.1.1–C.1.6;
- condição futura de encerramento de `GAP-3B-04`.

## Sublotes confirmados

A ordem definida em C.0 é confirmada:

1. `C.1.1` — contrato normativo de estados, comandos, eventos e invariantes;
2. `C.1.2` — modelo físico incremental, RLS, grants e rollback;
3. `C.1.3` — RPCs ou outra fronteira atômica para versão e permissão;
4. `C.1.4` — adapters de comando e leitura com tradução provider-neutral;
5. `C.1.5` — testes unitários, contrato, integração descartável, idempotência, concorrência e RLS;
6. `C.1.6` — fechamento documental e decisão sobre `GAP-3B-04`.

Nenhum sublote recebe `Ready for Code` por este checkpoint.

## Premissas da matéria-prima preservadas

Permanecem normativas:

- PDFs fornecidos pelas editoras serão predominantemente textuais;
- extração nativa é o caminho padrão futuro;
- OCR é fallback localizado, justificado e mensurável;
- PDF, páginas renderizadas, imagens, recortes, miniaturas e OCR bruto são temporários;
- o estado permanente retém somente dados derivados necessários;
- imagens serão convertidas em descrições semânticas;
- tabelas e gráficos relevantes terão estrutura/dados preservados;
- embeddings serão seletivos e pertencem à Fase D;
- procedência é lógica, textual e auditável;
- papéis de cartografia/inspeção são responsabilidades de processamento, não agentes executáveis;
- runtime multiagente permanece reservado à Fase E.

## Estado dos GAPs

### `GAP-3B-04`

**Ativo e contido.**

A definição normativa foi produzida, mas isso não satisfaz o gate de encerramento. O gap só poderá
fechar em C.1.6 quando o lifecycle estiver:

- definido em contratos;
- persistido;
- protegido;
- adaptado;
- testado;
- integrado.

### `GAP-3B-05`

**Ativo e contido.**

C.1 não amplia incidentalmente a US-013.2 nem o contrato geral de auditoria. Eventos específicos do
lifecycle não equivalem ao fechamento da auditoria enriquecida.

### `GAP-3B-07`

**Ativo e contido.**

A Fase C não reutiliza a OPP normativa como job de ingestão e não antecipa retrieval, geração,
validação ou entrega.

## Estado das fases

```text
FASE A — FUNDAÇÃO
✅ concluída

FASE B — CONEXÃO COM O BANCO
✅ concluída por bloqueio parcial controlado
⚠️ GAP-3B-04, GAP-3B-05 e GAP-3B-07 ativos e contidos

FASE C — MATÉRIA-PRIMA
✅ C.0 — integrado/encerrado documentalmente pelo PR nº 31
🔵 C.1 — definição documental concluída localmente; implementação bloqueada
⬜ C.2 — bloqueado
⬜ C.3 — bloqueado
⬜ C.4 — bloqueado
⬜ C.5 — bloqueado
⬜ C.6 — bloqueado
⬜ C.7 — bloqueado

FASES D–G
⬜ bloqueadas
```

## Gate desta branch

O pacote somente pode receber commit local quando:

- a `main` canônica estiver confirmada em `a370d2f80663f2ae5a6bc0aa2ba5942d85db9708`;
- o diff for exclusivamente documental;
- não existir código, SQL, migration, RPC, RLS ou grant;
- C.1.1–C.1.6 aparecerem somente como definição futura;
- `GAP-3B-04`, `GAP-3B-05` e `GAP-3B-07` permanecerem ativos;
- C.2 permanecer bloqueado;
- links e Markdown estiverem coerentes;
- whitespace não possuir erro bloqueante;
- navegação de Blueprint, README, mapa e Decision Log estiver reconciliada.

## Próximo gate humano

Depois do commit local, **parar**.

A próxima ação remota possível é apenas:

- publicar a branch documental;
- abrir PR documental contra `main`;

mas somente com nova autorização explícita.

Mesmo depois de eventual merge dessa documentação, implementação de `C.1.1` exigirá autorização
humana própria. Nenhum sublote posterior será iniciado por continuidade implícita.

## Próximo momento oficial de fork

Este checkpoint é o ponto de continuidade para a próxima conversa.

A próxima conversa deverá começar por:

1. verificar novamente a `main` remota;
2. conferir o commit local desta branch e sua equivalência documental;
3. decidir explicitamente entre ajustar o pacote, autorizar push/PR documental ou encerrar sem
   publicação.

Não realizar push, PR ou merge sem nova autorização.
