# Checkpoint 033 — Abertura documental e mapa integral da Fase C

Data: 11 de agosto de 2026.

## Status

**C.0 concluído documentalmente e pronto para publicação. Nenhum lote técnico da Fase C foi
iniciado.**

## 1. Base canônica

- repositório: `PaulinhoRehfeld/profeplan`;
- branch-base: `main`;
- commit-base: `73599716f28073eb93894682736e4bd497103a49`;
- origem do commit-base: squash merge do PR nº 30;
- estado herdado: Fase B encerrada por bloqueio parcial controlado no Checkpoint 032.

## 2. Autorização humana recebida

Foi autorizada a continuidade documental para, com base no Blueprint, tornar visíveis todas as
etapas da Fase C, incluindo sua relação com Epics, Features, Stories, sublotes e gates.

A autorização não incluiu:

- implementação técnica;
- ingestão ou processamento de fontes reais;
- código, dependências, migrations, RPCs, RLS ou grants;
- Supabase hospedado, wiring ou produção;
- Fase D, retrieval, embeddings ou agentes.

Em autorização posterior de 11 de agosto de 2026, o início da Fase C foi confirmado. Como C.0 ainda
não está integrado, o efeito operacional desta autorização é concluir e preparar C.0 para
publicação. C.1 permanece bloqueado até a integração deste checkpoint e sua definição específica.

Na mesma continuidade, ficou estabelecido que as editoras fornecem predominantemente PDFs com
camada textual utilizável. OCR não é caminho padrão e somente poderá ser acionado como exceção
localizada e justificada.

## 3. Decisão formalizada

A Fase C passa a possuir a seguinte navegação documental:

```text
C.0 — Definição integral, governança e gates
C.1 — Governança operacional do lifecycle de fontes
C.2 — Ingestão controlada
C.3 — Extração e validação do conteúdo extraído
C.4 — Segmentação e classificação estrutural
C.5 — Destilação pedagógica e deduplicação
C.6 — Componentização, versionamento e vínculo curricular
C.7 — Curadoria, corpus piloto e gate C → D
```

Somente C.0 está abrangido pela autorização atual. C.1–C.7 estão visíveis, ordenados e bloqueados.

## 4. Mapeamento preservado

- `EPIC-002`; `F-002.1–002.2`; `US-002.1–002.2` — C.1;
- `EPIC-003`; `F-003.1`; `US-003.1` — C.2 e C.3;
- `EPIC-003`; `F-003.2`; `US-003.2` — C.4;
- `EPIC-005`; `F-005.1–005.2`; `US-005.1–005.2` — C.5;
- `EPIC-004`; `F-004.1–004.3`; `US-004.1–004.3` — C.6 e C.7;
- `EPIC-006`; `F-006.1–006.2`; `US-006.1–006.2` — C.6 e C.7.

Os identificadores vêm do baseline aprovado no Marco 003 e não foram renumerados.

## 5. Arquivos deste checkpoint

- novo `12-delivery/PHASE-C-EXECUTION-MAP.md`;
- novo `12-delivery/PHASE-C-KNOWLEDGE-CARTOGRAPHY-ACTION-PLAN.md`;
- atualizado `BLUEPRINT.md`;
- atualizado `README.md`;
- atualizado `00-governance/DECISION-LOG.md` com ADR-054 e ADR-055;
- novo `00-governance/CONTINUITY-CHECKPOINT-033.md`.

O diff deve permanecer exclusivamente Markdown.

## 6. Estado dos GAPs

### GAP-3B-04

Permanece **ativo e contido**. Seu destino primário é C.1. Ingestão real continua bloqueada até
lifecycle de fontes contract-first, persistência, segurança, adapters e testes serem aprovados e
integrados.

### GAP-3B-05

Permanece **ativo e contido**. Auditoria enriquecida e conclusão integral da `US-013.2` não são
resolvidas por este mapa e exigem extensão contratual própria com minimização/LGPD.

### GAP-3B-07

Permanece **ativo e contido**. O mapa da Fase C não amplia a OPP normativa nem antecipa retrieval,
agentes, validação ou entrega.

## 7. Gates preservados

Cada lote e sublote da Fase C exige:

1. definição documental específica;
2. Stories e critérios de aceite;
3. análise de contratos e fronteiras;
4. plano de testes, segurança e rollback;
5. autorização humana antes da implementação;
6. integração apenas após checks aplicáveis e revisão;
7. checkpoint pós-merge;
8. nova autorização antes do próximo sublote.

Nenhum item da lista é dispensado por já estar visível no mapa.

## 8. Itens explicitamente não iniciados

- Lotes C.1–C.7;
- ingestão, extração, segmentação, destilação ou curadoria real;
- conteúdo PNLD ou protegido;
- currículo real adicional;
- migrations ou banco hospedado;
- embeddings, retrieval e Fase D;
- runtime de agentes e Sócrates 2;
- frontend, API, jobs, filas ou produção.

## 8.1 Regra de minimização incorporada ao mapa

PDFs, imagens integrais de páginas, renderizações, recortes, miniaturas, coordenadas em pixels,
OCRs duplicados e saídas brutas são artefatos transitórios de staging. Não poderão integrar o banco,
o corpus, o índice vetorial ou o histórico permanente. Após extração, reconciliação e revisão,
deverão ser descartados com recibo auditável.

O estado permanente conterá somente dados derivados necessários: texto normalizado, chunks
selecionados, estrutura, tabelas e gráficos estruturados, descrições semânticas dos elementos
visuais, procedência lógica, hashes, métricas, notas, relações, vínculos, decisões de revisão e
embeddings seletivos.

Os PDFs editoriais previstos são predominantemente textuais. A extração nativa é obrigatoriamente
o primeiro caminho. OCR fica restrito a exceções localizadas nas quais a camada textual esteja
ausente, corrompida ou insuficiente, com causa, cobertura, confiança e revisão registradas.

## 9. Gate de saída de C.0

C.0 poderá ser encerrado documentalmente quando:

- o mapa integral estiver revisado;
- Blueprint, README, ADR-054 e checkpoint estiverem coerentes;
- o diff continuar exclusivamente documental;
- a integração ocorrer por decisão humana;
- C.1 continuar bloqueado até nova autorização.

## 10. Próximo escopo elegível

Após eventual integração deste checkpoint, o próximo escopo elegível será exclusivamente a
**definição documental do Lote C.1 — Governança operacional do lifecycle de fontes**.

Essa futura definição deverá tratar estados, transições, comandos, eventos, versões, permissões,
revogações, idempotência, concorrência, segurança, persistência, adapters, testes e a condição exata
de encerramento de `GAP-3B-04`. Ela não iniciará ingestão nem conteúdo real.

## 11. Continuidade

- branch documental proposta: `docs/knowledge-factory-phase-c-map`;
- commit: a registrar após publicação autorizada;
- PR: a registrar após publicação autorizada;
- merge: não autorizado por este checkpoint;
- produção: permanece bloqueada.
