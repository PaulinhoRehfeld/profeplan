# Lote C.3 — estado de implementação

**Data de reconciliação:** 18 de agosto de 2026.

Este documento registra o estado corrente do Lote C.3 sem criar checkpoint intermediário. A execução continua regida por `RISK-PROPORTIONAL-EXECUTION-GOVERNANCE.md`.

## Estado integrado

### Definição do Lote C.3

- PR nº 97 — integrado;
- squash canônico: `345dc26226f7a6d4457c2f6aab7295e5c07e1248`;
- integrou ADR-063, definição C.3.1–C.3.8 e governança proporcional ao risco.

### C.3.1 — contratos, lifecycle, proveniência, qualidade e fixtures

- PR nº 101 — integrado;
- squash canônico: `bed1fa9d30ba30815b9593dcea6fe1fe90a7d73e`;
- `EXTRACTION_CONTRACT_VERSION = 1.0.0`;
- lifecycle C.3 fechado e provider-neutral;
- autorização reavaliável em `claim`, `artifact_read` e `finalization`;
- nenhum estado durável `AUTHORIZED`;
- fixtures e testes inteiramente sintéticos.

### C.3.2 — control plane persistente, autorização temporal, CAS, RLS e grants

- PR nº 102 — integrado;
- squash canônico: `c932df77443855517c9af8e1620a64e61c294de6`;
- projeção persistente de run + receipts/events append-only;
- idempotência `commandId + fingerprint`;
- CAS por state/version/sequence;
- autorização C.1 `purpose=extraction` revalidada no claim;
- `service_role` restrito a RPCs estreitas, sem DML direto;
- concorrência multi-sessão com vencedor único comprovada;
- nenhum PDF, texto extraído, OCR, chunk, embedding ou conteúdo real persistido.

Gates do HEAD técnico antes da integração:

- CI Pipeline nº 609 — success;
- Knowledge Factory DB CI nº 208 — success;
- Knowledge Factory C.3.2 Control Plane CI nº 10 — success.

## Estado ativo — C.3.3

C.3.3 está em implementação Nível A na branch:

`feat/knowledge-factory-c3-3-artifact-read-port`

Primeira fatia autorizada e em desenvolvimento:

1. porta read-only provider-neutral do artefato;
2. resolução interna do locator opaco, sem expô-lo ao domínio C.3;
3. metadados mínimos de tamanho, media type e retenção;
4. revalidação do checkpoint de autorização `artifact_read`;
5. revalidação de tamanho e SHA-256 contra o handoff C.2;
6. erros explícitos para autorização negada, indisponibilidade, expiração, identidade, tamanho, digest e falha de leitura;
7. fixtures inteiramente sintéticas.

Esta fatia não introduz parser PDF, OCR, provider de Storage, recurso hospedado ou conteúdo real.

## Próxima fronteira material

Depois de a porta read-only e a integridade de C.3.3 estarem integradas, a extração textual nativa exigirá a escolha/introdução de um parser PDF caso nenhum parser aprovado já exista no monorepo.

Pela governança proporcional ao risco, **novo parser/provider é Nível B**. Portanto:

- a arquitetura, porta, testes e fixtures continuam avançando em Nível A;
- a introdução efetiva de nova dependência de parser será uma decisão agrupada de Nível B;
- OCR permanece fora do baseline e continua reservado a C.3.7;
- o primeiro PDF/conteúdo real juridicamente autorizado continua sendo fronteira Nível B própria;
- produção, secrets e dados pessoais/sensíveis continuam Nível C.

## Distância até conteúdo real

Após C.3.3 completar leitura + extração textual nativa em fixtures sintéticas, o primeiro ensaio com PDF real poderá ocorrer sob autorização Nível B, sem necessidade de concluir C.3.4–C.3.8 previamente. C.3.4–C.3.8 continuam necessários para persistência incremental, qualidade, recovery, fechamento do lote e handoff C.4.
