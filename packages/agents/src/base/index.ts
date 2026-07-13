// Base classes and contracts for discipline agents

export { TipoGeracao, NivelEnsino, DisciplinaNome } from './discipline-agent-base';

export type { DisciplinaContext, GeracaoResultado } from './discipline-agent-base';

export { AGENT_DISPLAY_NAMES, BaseDisciplineAgent } from './discipline-agent-base';

// Agent registry (S1-04)
export { AgentRegistry } from './agent-registry';
export type { AgentEntry, AgentConstructor } from './agent-registry';
