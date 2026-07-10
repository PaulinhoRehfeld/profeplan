# 🎭 PROFEPLAN V5 — Multi-Agent Orchestration System

> **Versão:** 5.0.0 | **Sprint:** 6 (Cutover) | **Data:** 2026-07-09

## Visão Geral

Sistema multi-agente do PROFEPLAN que transforma a geração de conteúdo pedagógico de um modelo monolítico para uma **arquitetura orquestrada com 13 agentes especializados**.

Cada agente representa uma disciplina e é batizado com o nome de uma figura icônica da área.

## Arquitetura

```
Professor/FREEDAY → OrchestratorAgent → AgentRegistry → Agente de Disciplina → Quality Gates (7) → Resposta
```

### Agentes de Disciplina (13)

| 🎭 Nome | Disciplina | Código | Níveis |
|---|---|---|---|
| Machado | Língua Portuguesa | `AgentLinguaPortuguesa` | EF + EM |
| Pitágoras | Matemática | `AgentMatematica` | EF + EM |
| Heródoto | História | `AgentHistoria` | EF + EM |
| Milton | Geografia | `AgentGeografia` | EF + EM |
| Darwin | Ciências / Biologia | `AgentCienciasBiologia` | EF + EM |
| Einstein | Física | `AgentFisica` | EM |
| Lavoisier | Química | `AgentQuimica` | EM |
| Shakespeare | Língua Inglesa | `AgentLinguaInglesa` | EF + EM |
| Tarsila | Artes | `AgentArtes` | EF + EM |
| Pelé | Educação Física | `AgentEducacaoFisica` | EF + EM |
| Sócrates | Filosofia | `AgentFilosofia` | EM |
| Durkheim | Sociologia | `AgentSociologia` | EM |
| Francisco | Ensino Religioso | `AgentEnsinoReligioso` | EF |

### Quality Gates (7)

1. **FormatValidator** — Valida estrutura JSON
2. **BNCCValidator** — Confere códigos BNCC contra currículo MG
3. **PrivacyGuard** — Detecta dados pessoais e termos sensíveis
4. **HallucinationDetector** — Detecta conteúdo potencialmente alucinado
5. **ContentScorer** — Avalia qualidade pedagógica (0-1)
6. **PDIGuardian** — Valida adaptações PDI/DUA
7. **AntiPlagiarismScorer** — Detecta repetição entre aulas

## Uso Rápido

```typescript
import { AgentRegistry, OrchestratorAgent, QualityGatePipeline } from '@profeplan/agents';
import { AgentMatematica } from '@profeplan/agents/disciplinas/matematica';
import { FormatValidatorAgent, BNCCValidatorAgent, PrivacyGuardAgent } from '@profeplan/agents/qualidade';

// 1. Registrar agentes
const registry = new AgentRegistry();
registry.register({
  codigo: 'Agent_Matematica_EF',
  disciplina: DisciplinaNome.MATEMATICA,
  nivel: NivelEnsino.EF_6,
  displayName: 'Pitágoras',
  construtor: AgentMatematica,
});

// 2. Configurar quality gates
const pipeline = new QualityGatePipeline([
  new FormatValidatorAgent(),
  new BNCCValidatorAgent(),
  new PrivacyGuardAgent(),
]);

// 3. Criar orquestrador
const orchestrator = new OrchestratorAgent(registry, {
  qualityPipeline: pipeline,
  maxRetries: 3,
});

// 4. Gerar conteúdo
const response = await orchestrator.processarRequisicao({
  disciplina: DisciplinaNome.MATEMATICA,
  nivel: NivelEnsino.EF_6,
  tipo: TipoGeracao.PLANO_AULA,
  professorId: 'prof-123',
  turmaId: 'turma-456',
  params: { tema: 'Frações' },
});
```

## Feature Flags

```typescript
import { shouldUseV5, DEFAULT_FEATURE_FLAGS } from '@profeplan/agents';

const useV5 = shouldUseV5(
  { ...DEFAULT_FEATURE_FLAGS, use_v5_agents: true, rolloutPercentage: 10 },
  professorId,
  schoolId,
);
```

## Rollback

Ver `PLAYBOOK_ROLLBACK.md` para procedimento de emergência V5 → V4.

## Testes

```bash
cd packages/agents
npx vitest run        # 171 testes
npx tsc --noEmit      # TypeScript strict
```

---

> 📚 **Documentação completa:** `docs/agents/plano-implementacao-agentes-v5.md`
