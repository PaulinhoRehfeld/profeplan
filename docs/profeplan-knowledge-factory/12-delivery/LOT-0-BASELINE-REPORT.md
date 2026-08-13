# Relatório de baseline técnico — Marco 004, Lote 0

## Status

Baseline auditado em 6 de agosto de 2026 sobre:

- repositório: `PaulinhoRehfeld/profeplan`;
- branch base: `main`;
- commit base: `a6e105ac4260adf7c314ff0338a9f7bbd13610b5`;
- branch documental do Lote 0: `docs/knowledge-factory-lot0`.

Nenhum código de produto, migration, banco, RLS, dependência ou configuração de produção foi alterado.

## Método

O ambiente local desta sessão não conseguiu resolver acesso de rede para clonar o repositório. O baseline foi auditado pela integração autenticada do GitHub, utilizando:

- arquivos reais do monorepo;
- configuração dos workflows;
- resultado e etapas do último CI do commit base;
- logs dos workflows com falha;
- configuração do Vercel;
- inventário de apps e packages.

Consequência: os comandos não foram executados novamente nesta sessão local. O CI verde do commit base é a evidência executável disponível para o escopo ativo, e as exclusões do workflow são registradas como limitações.

## Estrutura do monorepo

### Runtime e workspaces

- Node.js: `22.x`;
- package manager: `pnpm@11.5.2`;
- raiz: monorepo privado, versão `4.3.8`;
- workspaces declarados no `package.json`: `apps/*` e `packages/*`;
- workspaces adicionais no `pnpm-workspace.yaml`: `services/*` e `infra/*`.

### Aplicações

- `apps/web`: aplicação Vite/React efetivamente construída pelo Vercel;
- `apps/bff`: Azure Functions/BFF presente, mas excluído do CI geral e sem implantação ativa comprovada.

### Pacotes relevantes

- `packages/types`;
- `packages/agents`;
- `packages/ai`;
- `packages/db`;
- `packages/logger`;
- `packages/industry-curriculum`;
- `packages/industry-pnld`;
- `packages/graphics-profeplan`.

### API ativa no Vercel

O diretório raiz `api/` contém funções e proxies, incluindo IA, autenticação, busca e PDI. O `vercel.json` constrói somente `apps/web` e reescreve `/api/*` para esse diretório.

## Comandos reais identificados

### Instalação

```bash
pnpm install
```

O CI geral não utiliza `--frozen-lockfile`.

### Scripts raiz declarados

```bash
pnpm build
pnpm lint
pnpm typecheck
pnpm test
```

Eles resolvem respectivamente para:

```bash
pnpm -r build
pnpm -r lint
pnpm -r typecheck
pnpm -r test
```

### Baseline efetivamente utilizado pelo CI geral

```bash
pnpm install
pnpm exec prettier --check "apps/web/src/**/*.{ts,tsx}" "api/**/*.ts" "packages/*/src/**/*.ts"
pnpm --filter '!./apps/bff' --filter '!./packages/db' --filter '!./packages/ai' --filter '!./packages/auth' -r lint
pnpm --filter '!./apps/bff' --filter '!./packages/db' --filter '!./packages/ai' --filter '!./packages/auth' -r typecheck
pnpm --filter '!./apps/bff' --filter '!./packages/db' --filter '!./packages/ai' --filter '!./packages/auth' -r build
pnpm test
```

## Resultado do commit base

### CI geral

Workflow: `.github/workflows/ci.yml`

Resultado no commit base:

- instalação: sucesso;
- Prettier no escopo ativo: sucesso;
- lint filtrado: sucesso;
- typecheck filtrado: sucesso;
- build filtrado: sucesso;
- testes do comando raiz: sucesso;
- conclusão geral: sucesso.

### Vercel

- status combinado: sucesso;
- build real configurado: `pnpm --filter ./apps/web build`;
- saída: `apps/web/dist`;
- região: `gru1`.

### CI específico de agentes

Workflow: `.github/workflows/agents-v5-ci.yml`

Último resultado auditado: falha antes da instalação e dos testes.

Causa imediata:

- workflow fixa pnpm `9`;
- `package.json` fixa `pnpm@11.5.2`;
- `pnpm/action-setup` interrompe por múltiplas versões incompatíveis.

O workflow também contém etapas de deploy que apenas imprimem `TODO`, não realizam implantação.

## O que o baseline verde não comprova

O CI geral exclui explicitamente de lint, typecheck e build:

- `apps/bff`;
- `packages/db`;
- `packages/ai`;
- `packages/auth`.

Portanto, o estado verde do CI não significa que o monorepo inteiro esteja compilando. Significa apenas que o escopo ativo filtrado está verde.

Também não comprova:

- pipeline Python de currículo;
- pipeline Python PNLD;
- runtime de BFF;
- Prisma e migrations;
- testes reais do BFF;
- workflow de agentes;
- deploy Azure;
- contratos da Knowledge Factory.

## CI/CD

### CI geral

- ativo em `main` e `develop`;
- verde no commit base;
- usa filtros para evitar módulos conhecidos como inativos ou quebrados.

### CI de agentes

- ativo por caminhos de `packages/agents/**` e `apps/bff/**`;
- atualmente vermelho por conflito de pnpm;
- não chega ao typecheck ou aos testes;
- exige cobertura de 70% após correção da instalação.

### CD

- workflow manual (`workflow_dispatch`);
- desativado como automação por depender de Prisma/schema legado e conexão inválida;
- deploy real ocorre pela integração nativa do Vercel;
- deploy Azure permanece apenas como intenção/TODO.

## Branches

### Base confirmada

`main` é a branch padrão e base proposta para os PRs da Knowledge Factory.

### Branch do Lote 0

`docs/knowledge-factory-lot0`

### Branch proposta para o primeiro PR de código

`feat/knowledge-factory-contracts`

Essa branch só deverá ser criada após aprovação humana deste Lote 0.

## Conclusão do baseline

O monorepo possui base real reutilizável, mas o verde atual é parcial. O primeiro PR contract-first é adequado porque pode ficar restrito ao pacote de contratos e a testes puros, sem depender dos módulos excluídos, do banco ou dos workflows de agentes.
