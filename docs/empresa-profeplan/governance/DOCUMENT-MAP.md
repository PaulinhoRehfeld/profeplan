# EMPRESA PROFEPLAN — Initial Document Map

**Status:** classificação inicial; não autoriza movimentação automática

## 1. Objetivo

Mapear o patrimônio documental existente antes de mover, renomear, consolidar ou arquivar arquivos.

## 2. Regra

Primeiro criar o mapa da nova cidade. Depois mover as casas.

## 3. Classificação inicial

| Caminho atual | Destino conceitual | Tipo | Status | Ação recomendada | Risco |
|---|---|---|---|---|---|
| `docs/profeplan-knowledge-factory/**` | C | Blueprint/ADR/contratos/checkpoints/evidências | ativo | manter no lugar até marco estável | alto se mover agora |
| `docs/profeplan-continuity/**` (PR #128) | transversal | bootstrap/continuidade | ativo em Draft | manter independente e futuramente apontar ao MASTER-BLUEPRINT | médio |
| `docs/PROPOSTAS-UX-PROFEPLAN.md` | E | UX/propostas | a validar | classificar e consolidar quando E for reconciliado | baixo |
| `docs/frontend-audit/**` | E/B | auditoria técnica/UX | histórico útil | manter e referenciar | médio |
| `docs/BETA_TEACHER_GUIDE.md` | B/E | operação/uso | a validar | manter até revisão de produto | baixo |
| `docs/OPERATIONAL_GUIDE.md` | B/A | operação | a validar | manter e reconciliar depois | médio |
| `docs/EMAIL_SETUP.md` | E/B | infraestrutura operacional | técnico | manter; revisar dependências antes de mover | médio |
| `docs/PHASE-3-CLOSURE.md` | histórico B/infra | checkpoint de fase | histórico | preservar | baixo |
| `docs/PHASE-5-API-FOUNDATION.md` | B/L histórico | fundação técnica | histórico/técnico | preservar e avaliar atualidade | médio |
| `docs/PHASE-6-AI-FOUNDATION.md` | L/B histórico | fundação IA | histórico/técnico | preservar e avaliar atualidade | médio |
| `docs/PHASE-7-FRONTEND-FOUNDATION.md` | B/E | fundação frontend | histórico/técnico | preservar | baixo |
| `docs/PHASE-8-OBSERVABILITY-FOUNDATION.md` | L/B | observabilidade | histórico/técnico | preservar | médio |
| `docs/PHASE-9-CICD-FOUNDATION.md` | B/L | CI/CD | histórico/técnico | preservar e não mover antes da migração GitHub | alto |
| `docs/REFACTORING_METHODOLOGY.md` | transversal B/L | metodologia | reutilizável | manter; possível referência transversal | baixo |
| `docs/SPRINT-1-VALIDATION.md` | histórico B | evidência/sprint | histórico | preservar | baixo |
| `docs/COMPARATIVO_REPOSITORIOS.md` | governança histórica | migração/repos | histórico | preservar; supersede apenas quando migração for concluída | médio |
| `docs/plano-execucao-estabilizacao-migracao-azure.md` | histórico L/B | plano de migração | possivelmente superseded | manter como histórico, não tratar como plano ativo sem validação | médio |
| `docs/agents/**` | L | agentes/IA | técnico/histórico | manter até NEB ser ativado | médio |
| `.agent/**` | tooling | agentes/skills | operacional técnico | não mover nesta reorganização | alto |
| `LEGADO.md` | histórico | genealogia | histórico | preservar | baixo |

## 4. Estados documentais permitidos

- **canônico**: fonte vigente autorizada para decisões;
- **ativo**: em uso ou evolução;
- **histórico útil**: preservado para rastreabilidade;
- **a validar**: conteúdo possivelmente útil cuja atualidade ainda precisa ser verificada;
- **superseded**: substituído por fonte posterior explícita;
- **temporário**: pode ser removido após gate definido.

## 5. Próxima expansão

A matriz deverá ser detalhada por domínio no momento da reconciliação de cada projeto. Não é necessário catalogar cada checkpoint individual da Knowledge Factory agora; a própria estrutura C já faz essa governança.