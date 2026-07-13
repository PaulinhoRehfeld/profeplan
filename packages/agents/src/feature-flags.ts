// ============================================================================
// PROFEPLAN V5 — Feature Flags
// S5-05: Flags de ativação dos agentes V5 por escola/professor
// ============================================================================

/**
 * Controla a ativação gradual dos agentes V5.
 *
 * Estratégia de canário progressivo (Sprint 6):
 *   1. use_v5_agents = false → fallback V4 (comportamento atual)
 *   2. use_v5_agents = true + rolloutPercentage = 10 → 10% do tráfego
 *   3. rolloutPercentage = 50 → 50%
 *   4. rolloutPercentage = 100 → 100% (cutover completo)
 *
 * Também suporta ativação por escola (schoolId) e por professor (professorId)
 * para testes A/B controlados.
 */

export interface FeatureFlags {
  /** Se true, o sistema tenta usar agentes V5. Se false, usa V4 (fallback). */
  use_v5_agents: boolean;

  /** Percentual de rollout (0-100). Só aplica se use_v5_agents = true. */
  rolloutPercentage: number;

  /** Lista de school_id com V5 ativado (independente do rolloutPercentage). */
  enabledSchools: string[];

  /** Lista de professor_id com V5 ativado (independente do rolloutPercentage). */
  enabledProfessors: string[];

  /** Lista de school_id com V5 DESATIVADO (força fallback V4). */
  disabledSchools: string[];

  /** Se true, ativa logs detalhados do pipeline de agentes. */
  debugMode: boolean;
}

/** Configuração padrão — V5 desativado, rollout 0%. */
export const DEFAULT_FEATURE_FLAGS: FeatureFlags = {
  use_v5_agents: false,
  rolloutPercentage: 0,
  enabledSchools: [],
  enabledProfessors: [],
  disabledSchools: [],
  debugMode: false,
};

/**
 * Determina se os agentes V5 devem ser usados para uma requisição específica.
 *
 * Ordem de precedência:
 *   1. disabledSchools → força V4 (fallback)
 *   2. enabledSchools / enabledProfessors → força V5
 *   3. rolloutPercentage → hash determinístico do professorId
 *   4. use_v5_agents = false → V4
 *
 * @param flags    — Configuração atual de feature flags.
 * @param schoolId  — ID da escola (opcional).
 * @param professorId — ID do professor.
 * @returns true se deve usar agentes V5, false para fallback V4.
 */
export function shouldUseV5(flags: FeatureFlags, professorId: string, schoolId?: string): boolean {
  // Força V4 para escolas na lista de desabilitadas
  if (schoolId && flags.disabledSchools.includes(schoolId)) {
    return false;
  }

  // Força V5 para professores/schools na whitelist
  if (flags.enabledProfessors.includes(professorId)) {
    return true;
  }
  if (schoolId && flags.enabledSchools.includes(schoolId)) {
    return true;
  }

  // V5 desativado globalmente
  if (!flags.use_v5_agents) {
    return false;
  }

  // Rollout percentual — hash determinístico do professorId
  if (flags.rolloutPercentage >= 100) {
    return true;
  }
  if (flags.rolloutPercentage <= 0) {
    return false;
  }

  // Hash simples para distribuição determinística
  const hash = _simpleHash(professorId);
  const bucket = hash % 100;
  return bucket < flags.rolloutPercentage;
}

/**
 * Hash simples e determinístico para distribuição de rollout.
 * TODO: Substituir por hash mais robusto (ex: SHA-256 truncado) em produção.
 */
function _simpleHash(str: string): number {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    const char = str.charCodeAt(i);
    hash = (hash * 31 + char) | 0;
  }
  return Math.abs(hash);
}
