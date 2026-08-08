# CONTINUITY CHECKPOINT 021 — definição do Lote 3B.4B

Data: 8 de agosto de 2026.

## Status

**Definição documental da fronteira contratual e transacional do Lote 3B.4B proposta para revisão humana. Nenhuma implementação foi iniciada. `GAP-3B-02` e `GAP-3B-06` permanecem ativos.**

## Repositório e continuidade

Repositório: `PaulinhoRehfeld/profeplan`.

Branch padrão: `main`.

Branch documental: `agent/knowledge-factory-lot-3b4b-definition`.

Base e merge-base esperados: `8ef2a7cdace312d9286ca50fb74335f6c954a2c8`.

## Escopo documental

- definição de quatro comandos explícitos de escrita;
- rejeição dos métodos genéricos `saveComponent()` e `saveVersion()` para o contrato futuro;
- evidências completas e vínculos curriculares dentro da transação da versão;
- versionamento insert-only dos conjuntos relacionais;
- idempotência por `commandId` e fingerprint calculado no banco;
- concorrência otimista por estado esperado;
- quatro RPCs PostgreSQL estreitas;
- segurança `SECURITY DEFINER`, `search_path` fixo e `EXECUTE` somente para `service_role`;
- revogação futura de DML direto sobre as tabelas do agregado;
- divisão do 3B.4B em três sublotes com gates independentes.

## Arquivos desta branch

- `docs/profeplan-knowledge-factory/BLUEPRINT.md`;
- `docs/profeplan-knowledge-factory/00-governance/CONTINUITY-CHECKPOINT-021.md`;
- `docs/profeplan-knowledge-factory/12-delivery/LOT-3B4B-COMPONENT-WRITE-BOUNDARY-DEFINITION.md`.

## Estado preservado

- Lote 3B.4A: integrado;
- Lote 3B.4B: bloqueado, ainda não implementado;
- Lote 3B.5: não iniciado;
- Fase B: não concluída;
- `GAP-3B-02`: ativo;
- `GAP-3B-06`: ativo.

## Ausências confirmadas

Não houve:

- código TypeScript ou SQL;
- alteração de contrato, porta, adapter, mapper ou testes;
- migration, função PostgreSQL ou RPC;
- alteração de schema, grant, policy, RLS ou workflow;
- lockfile ou dependência;
- wiring de API ou frontend;
- acesso à produção;
- uso de dados reais;
- início do 3B.4B.1, 3B.4B.2, 3B.4B.3 ou 3B.5;
- encerramento de GAP;
- merge automático.

## Pull Request

- número: `PENDING`;
- URL: `PENDING`;
- estado inicial exigido: draft;
- base: `main`;
- head: `agent/knowledge-factory-lot-3b4b-definition`.

O número e a URL reais deverão ser registrados em commit adicional após a abertura do PR. O SHA final será revalidado e registrado na descrição do PR e no handoff, evitando auto-referência impossível dentro do próprio commit.

## Validações aplicáveis

- base e merge-base;
- `main` sem avanço incompatível;
- diff completo e restrito aos três documentos;
- ausência de código, SQL, workflow, lockfile e secrets;
- formatação documental;
- links e caminhos canônicos;
- CI geral, se acionado;
- Vercel, se acionada;
- mergeabilidade, conflitos, reviews, threads e checks do SHA final.

O DB CI não deverá ser forçado artificialmente para um diff exclusivamente documental.

## Próximo gate humano

Revisar o PR documental e autorizar — ou não — sua integração controlada.

Somente após o squash merge desta definição e nova autorização explícita poderá começar o sublote 3B.4B.1 — contratos e porta. Nenhuma migration, RPC ou implementação de adapter estará autorizada por este checkpoint.
