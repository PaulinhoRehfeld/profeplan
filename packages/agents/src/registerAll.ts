// ============================================================================
// PROFEPLAN — Registro estático dos 13 agentes de disciplina
// AgentRegistry.discover() é um placeholder (retorna 0 — ver débito técnico
// DT-03 no tracker). Em vez de discovery dinâmico via import(), registramos
// explicitamente: mais simples, mais previsível e sem custo de cold-start
// de imports desconhecidos numa function serverless.
// ============================================================================

import { AgentRegistry, type AgentConstructor } from './base/agent-registry';
import { DisciplinaNome, NivelEnsino, AGENT_DISPLAY_NAMES } from './base/discipline-agent-base';

import { AgentLinguaPortuguesa } from './disciplinas/lingua-portuguesa';
import { AgentMatematica } from './disciplinas/matematica';
import { AgentCienciasBiologia } from './disciplinas/ciencias-biologia';
import { AgentGeografia } from './disciplinas/geografia';
import { AgentHistoria } from './disciplinas/historia';
import { AgentArtes } from './disciplinas/artes';
import { AgentEducacaoFisica } from './disciplinas/educacao-fisica';
import { AgentEnsinoReligioso } from './disciplinas/ensino-religioso';
import { AgentLinguaInglesa } from './disciplinas/lingua-inglesa';
import { AgentFisica } from './disciplinas/fisica';
import { AgentQuimica } from './disciplinas/quimica';
import { AgentFilosofia } from './disciplinas/filosofia';
import { AgentSociologia } from './disciplinas/sociologia';

const NIVEIS_EF: NivelEnsino[] = [
  NivelEnsino.EF_6,
  NivelEnsino.EF_7,
  NivelEnsino.EF_8,
  NivelEnsino.EF_9,
];
const NIVEIS_EM: NivelEnsino[] = [NivelEnsino.EM_1, NivelEnsino.EM_2, NivelEnsino.EM_3];
const NIVEIS_EF_EM: NivelEnsino[] = [...NIVEIS_EF, ...NIVEIS_EM];

interface AgentDef {
  disciplina: DisciplinaNome;
  construtor: AgentConstructor;
  niveis: NivelEnsino[];
}

/**
 * Definição de todos os agentes de disciplina e os níveis de ensino que cada
 * um cobre. Uma mesma classe concreta pode ser registrada sob mais de uma
 * `DisciplinaNome` (caso de {@link AgentCienciasBiologia}, que responde por
 * CIENCIAS no EF e BIOLOGIA no EM) — a classe decide o rótulo certo em
 * runtime via `this.context.nivel`.
 */
const AGENT_DEFS: AgentDef[] = [
  {
    disciplina: DisciplinaNome.LINGUA_PORTUGUESA,
    construtor: AgentLinguaPortuguesa,
    niveis: NIVEIS_EF_EM,
  },
  { disciplina: DisciplinaNome.MATEMATICA, construtor: AgentMatematica, niveis: NIVEIS_EF_EM },
  { disciplina: DisciplinaNome.CIENCIAS, construtor: AgentCienciasBiologia, niveis: NIVEIS_EF },
  { disciplina: DisciplinaNome.BIOLOGIA, construtor: AgentCienciasBiologia, niveis: NIVEIS_EM },
  { disciplina: DisciplinaNome.GEOGRAFIA, construtor: AgentGeografia, niveis: NIVEIS_EF_EM },
  { disciplina: DisciplinaNome.HISTORIA, construtor: AgentHistoria, niveis: NIVEIS_EF_EM },
  { disciplina: DisciplinaNome.ARTES, construtor: AgentArtes, niveis: NIVEIS_EF_EM },
  {
    disciplina: DisciplinaNome.EDUCACAO_FISICA,
    construtor: AgentEducacaoFisica,
    niveis: NIVEIS_EF_EM,
  },
  {
    disciplina: DisciplinaNome.ENSINO_RELIGIOSO,
    construtor: AgentEnsinoReligioso,
    niveis: NIVEIS_EF,
  },
  {
    disciplina: DisciplinaNome.LINGUA_INGLESA,
    construtor: AgentLinguaInglesa,
    niveis: NIVEIS_EF_EM,
  },
  { disciplina: DisciplinaNome.FISICA, construtor: AgentFisica, niveis: NIVEIS_EM },
  { disciplina: DisciplinaNome.QUIMICA, construtor: AgentQuimica, niveis: NIVEIS_EM },
  { disciplina: DisciplinaNome.FILOSOFIA, construtor: AgentFilosofia, niveis: NIVEIS_EM },
  { disciplina: DisciplinaNome.SOCIOLOGIA, construtor: AgentSociologia, niveis: NIVEIS_EM },
];

/**
 * Registra os 13 agentes de disciplina num {@link AgentRegistry}.
 * @returns Número de entradas (disciplina × nível) registradas.
 */
export function registerAllAgents(registry: AgentRegistry): number {
  let count = 0;
  for (const def of AGENT_DEFS) {
    for (const nivel of def.niveis) {
      registry.register({
        codigo: `Agent_${def.disciplina}_${nivel}`,
        disciplina: def.disciplina,
        nivel,
        displayName: AGENT_DISPLAY_NAMES[def.disciplina],
        construtor: def.construtor,
      });
      count += 1;
    }
  }
  return count;
}

/** Cria e devolve um {@link AgentRegistry} já populado com os 13 agentes. */
export function createPopulatedRegistry(): AgentRegistry {
  const registry = new AgentRegistry();
  registerAllAgents(registry);
  return registry;
}
