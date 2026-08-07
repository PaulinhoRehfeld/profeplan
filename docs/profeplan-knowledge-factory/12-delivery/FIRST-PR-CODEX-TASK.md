# Tarefa restrita para o Codex — primeiro PR contract-first

## Status

**Autorizada no Marco 004 — Lote 0.**

Executar somente no próximo ciclo, sem merge automático e dentro dos limites abaixo.

## Prompt autorizado

Você está trabalhando no repositório `PaulinhoRehfeld/profeplan`.

Branch base: `main`.

Crie a branch:

`feat/knowledge-factory-contracts`

Objetivo único:

Adicionar contratos puros, versionados, fixtures sintéticas e testes de invariantes da ProfePlan Knowledge Factory em `packages/types`, sem implementar persistência, APIs, IA, agentes ou mudanças de comportamento.

### Leitura obrigatória

Leia antes de propor alterações:

- `docs/profeplan-knowledge-factory/README.md`;
- `docs/profeplan-knowledge-factory/SYNC-MANIFEST.md`;
- `docs/profeplan-knowledge-factory/00-governance/DECISION-LOG.md`;
- `docs/profeplan-knowledge-factory/00-governance/CONTINUITY-CHECKPOINT-004.md`;
- `docs/profeplan-knowledge-factory/12-delivery/LOT-0-BASELINE-REPORT.md`;
- `docs/profeplan-knowledge-factory/12-delivery/PREEXISTING-FAILURES.md`;
- `docs/profeplan-knowledge-factory/12-delivery/MODULE-DESTINATION-MAP.md`;
- `docs/profeplan-knowledge-factory/12-delivery/ARCHITECTURE-CODE-GAP-REPORT.md`;
- `docs/profeplan-knowledge-factory/12-delivery/FIRST-CODE-PR.md`.

Consulte também a origem normativa dos Marcos 001–003 registrada em `SYNC-MANIFEST.md`.

### Antes de editar

1. inspecione `packages/types`;
2. liste arquivos que pretende criar ou alterar;
3. compare os contratos existentes com o escopo aprovado;
4. confirme que nenhuma alteração será necessária fora de `packages/types` e documentação diretamente relacionada;
5. apresente qualquer necessidade de nova dependência;
6. pare e solicite autorização se uma dependência nova for necessária.

### Escopo permitido

- arquivos em `packages/types/src/knowledge-factory/`;
- exports aditivos em `packages/types/src/index.ts`;
- scripts mínimos em `packages/types/package.json`;
- configuração mínima de teste do pacote;
- fixtures exclusivamente sintéticas;
- testes unitários de invariantes;
- documentação diretamente ligada ao PR.

### Contratos mínimos

- fontes, versões, permissões e segmentos;
- componentes pedagógicos, versões e evidências;
- pacote e nós curriculares;
- perfil e escopo do agente;
- OPP, eventos e estados;
- QueryPlan e filtros;
- suficiência e contexto;
- findings de validação;
- contrato de entrega dos quatro produtos.

### Restrições absolutas

Não alterar:

- `packages/db`;
- `packages/ai`;
- `packages/agents`;
- `packages/industry-pnld`;
- `packages/industry-curriculum`;
- `apps/bff`;
- `apps/web`;
- `api/`;
- `supabase/`;
- migrations;
- RLS;
- workflows de deploy;
- configuração de providers;
- embeddings, dimensões ou índices;
- fontes reais ou PNLD;
- Sócrates 2 executável;
- Rio Grande do Sul;
- Gráfica avançada.

Não corrija falhas preexistentes não necessárias ao pacote de tipos.

### Regras de tooling

- usar TypeScript strict;
- preferir Vitest já existente no monorepo;
- não adicionar dependência sem aprovação;
- se runtime schema exigir Zod ou outra biblioteca, interromper e informar;
- não importar código do frontend apenas para reutilizar Zod;
- não depender de banco, rede, ambiente ou provider.

### Validações obrigatórias

Execute e registre:

1. typecheck específico de `packages/types`;
2. testes específicos dos contratos;
3. testes de transições e invariantes;
4. CI geral aplicável;
5. comparação com `PREEXISTING-FAILURES.md`.

Se os comandos raiz falharem em módulos preexistentes, não os corrija silenciosamente. Registre a diferença e demonstre que o novo pacote passa isoladamente.

### Saída obrigatória

Ao final, apresente:

- árvore de arquivos alterados;
- contratos criados;
- invariantes testadas;
- dependências adicionadas ou confirmação de nenhuma;
- comandos e resultados;
- falhas preexistentes observadas;
- itens deliberadamente não implementados;
- plano de rollback;
- resumo pronto para Pull Request.

Não faça merge automático.

## Gate de execução

A aprovação humana explícita foi concedida em 6 de agosto de 2026.

Qualquer nova dependência, alteração fora de `packages/types`, ampliação de escopo ou necessidade de tocar banco, API, IA, agentes ou frontend exige nova autorização antes de continuar.
