# Empresa ProfePlan — Porta de Entrada

**Status:** camada institucional inicial
**Objetivo:** organizar a EMPRESA PROFEPLAN em domínios de trabalho sem mover documentação existente prematuramente.

## 1. Princípio

A EMPRESA PROFEPLAN é organizada por domínios A–M. Cada domínio possui identidade própria, dependências explícitas e, quando atingir maturidade suficiente, documentação especializada própria.

Nesta fase, esta estrutura NÃO substitui nem move documentação existente. Ela funciona como mapa institucional acima das estruturas atuais.

## 2. Porta de entrada

Comece por:

1. `MASTER-BLUEPRINT.md` — visão integrada da empresa, produto e fábricas;
2. `blueprints/README.md` — índice dos domínios A–M;
3. `governance/PROJECT-MATURITY-MAP.md` — estágio atual e critério de migração de cada domínio.

## 3. Regra de migração por maturidade

Um domínio não precisa estar "finalizado" para migrar. O gate é atingir um marco estável suficiente para:

- possuir identidade documental clara;
- ter estado verificável;
- ter interfaces e dependências compreendidas;
- reduzir risco de mover caminhos durante desenvolvimento estrutural intenso.

Por isso, documentação especializada existente permanece em sua localização atual até o gate apropriado.

## 4. Estruturas atualmente preservadas

Em especial, permanecem intactas nesta fase:

- `docs/profeplan-knowledge-factory/`;
- documentação histórica e de fases;
- auditorias existentes;
- documentação de agentes;
- documentos operacionais já referenciados por código, workflows ou checkpoints;
- o Continuity Pack proposto no PR #128.

## 5. Relação com Continuity Pack

O Continuity Pack é a camada técnica de bootstrap para IA e novos ambientes.

A arquitetura pretendida é:

`Continuity Pack -> MASTER-BLUEPRINT -> domínio A–M -> documentação especializada -> código/ADR/contrato/checkpoint`.

O Continuity Pack não deve duplicar a visão institucional; deve apontar para ela.

## 6. Repositório canônico

Até a transferência institucional, o repositório canônico permanece `PaulinhoRehfeld/profeplan`.

O destino previsto é `Profeplan-Edtech/profeplan`, condicionado à auditoria administrativa e ao corte seguro de integrações.
