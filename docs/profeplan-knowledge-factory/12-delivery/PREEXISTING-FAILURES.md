# Falhas e limitações preexistentes — Lote 0

## Finalidade

Separar problemas já existentes no commit base de qualquer alteração futura da Knowledge Factory.

Referência:

- branch: `main`;
- commit: `a6e105ac4260adf7c314ff0338a9f7bbd13610b5`;
- data da auditoria: 6 de agosto de 2026.

## PF-001 — Workflow de agentes interrompido pelo pnpm

**Severidade:** alta para mudanças em agentes.

O workflow `.github/workflows/agents-v5-ci.yml` configura pnpm 9, enquanto o monorepo declara `pnpm@11.5.2`. O action-setup falha antes da instalação, do typecheck e dos testes.

**Impacto:** mudanças em `packages/agents` ou `apps/bff` não possuem pipeline específico funcional.

**Não causado pela Knowledge Factory:** sim.

## PF-002 — Referência residual a `docs/blueprint`

**Severidade:** média.

O cleanup do checkout registrou `fatal: No url found for submodule path 'docs/blueprint' in .gitmodules`, enquanto `.gitmodules` não existe no estado atual.

**Impacto:** indica estado residual de submódulo ou gitlink que precisa de auditoria própria.

## PF-003 — CI geral exclui módulos relevantes

**Severidade:** alta para interpretação do baseline.

O CI geral exclui de lint, typecheck e build:

- `apps/bff`;
- `packages/db`;
- `packages/ai`;
- `packages/auth`.

**Impacto:** o status verde não representa o monorepo inteiro.

## PF-004 — Teste do BFF é apenas stub

**Severidade:** média.

`apps/bff` declara:

```bash
echo "No tests specified" && exit 0
```

**Impacto:** o comando de testes não valida comportamento do BFF.

## PF-005 — Pacote de IA sem suíte de testes declarada

**Severidade:** média.

`packages/ai` possui build, typecheck e fluxo manual, mas não declara script `test`.

## PF-006 — Pacote de tipos sem scripts de validação

**Severidade:** alta para o primeiro PR.

`packages/types` não declara build, typecheck, lint ou test. O pacote apenas exporta arquivos TypeScript diretamente.

**Impacto:** o primeiro PR precisa definir como seus contratos serão compilados e testados, sem ampliar o escopo.

## PF-007 — Pipelines Python fora do CI principal

**Severidade:** média.

`packages/industry-curriculum` e `packages/industry-pnld` possuem Python e `requirements.txt`, mas não possuem `package.json` nem workflow de validação Python identificado.

**Impacto:** o CI pnpm não comprova a saúde desses pipelines.

## PF-008 — CD manual e legado

**Severidade:** alta se executado sem revisão.

O workflow de CD foi convertido para execução manual porque:

- dependia de schema Prisma/Next inativo;
- a conexão de migration falhava;
- o deploy real ocorre pela integração nativa do Vercel.

**Impacto:** não deve ser reutilizado pela Knowledge Factory sem projeto específico.

## PF-009 — Branch `main` sem proteção

**Severidade:** média/alta de governança.

A branch padrão não possui proteção nem required status checks.

**Impacto:** merge direto pode ignorar CI e revisão.

## PF-010 — Deploy de agentes é apenas TODO

**Severidade:** média.

Os jobs de staging e produção do workflow de agentes apenas imprimem comandos pendentes.

## PF-011 — Instalação do CI geral não é congelada

**Severidade:** média.

O CI geral executa `pnpm install`, não `pnpm install --frozen-lockfile`.

**Impacto:** menor reprodutibilidade do baseline.

## PF-012 — Scripts raiz não equivalem ao baseline verde

**Severidade:** alta de interpretação.

Os scripts raiz executam recursivamente todos os pacotes, mas o CI verde usa filtros de exclusão. Portanto, afirmar simplesmente que `pnpm build`, `pnpm lint` e `pnpm typecheck` passam seria incorreto.

## PF-013 — Acoplamento entre IA e DB legado

**Severidade:** média.

`packages/ai` depende de `packages/db`, e o próprio CI registra que o pacote de IA importa source do pacote de DB, que não é construído no fluxo ativo.

## PF-014 — Dupla superfície de backend

**Severidade:** alta de arquitetura.

Há:

- `api/`, usado pelo Vercel;
- `apps/bff`, orientado a Azure Functions.

A superfície realmente ativa é o diretório `api/`; o BFF não deve ser assumido como destino operacional sem nova evidência.

## Regra para os próximos PRs

Toda falha observada após o início da Knowledge Factory deverá ser comparada com este inventário.

Uma falha somente será atribuída ao novo PR quando:

- não constar neste baseline;
- ou houver evidência de regressão mensurável;
- ou o PR modificar diretamente o componente preexistente.

## Correções fora do primeiro PR

O primeiro PR contract-first não deverá corrigir estas falhas, exceto quando uma correção mínima for indispensável para testar exclusivamente `packages/types` e tiver autorização humana explícita.

Não misturar saneamento amplo do monorepo com contratos da Knowledge Factory.
