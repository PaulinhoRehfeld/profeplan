/**
 * Data Access Layer - Tipos e contratos.
 * Fase 1 da refatoração (ARCHITECTURE-PROFEPLAN).
 */

export interface PlanningContext {
  subject: string;
  grade: string;
  period: number;
  regime: string;
  stateBase?: string;
  educationSphere?: string;
  teacherName?: string;
  totalClasses?: number;
  reserves?: Record<string, unknown>;
  userId?: string;
  level?: string;
  feedback?: string;
  pnld_book_id?: string;
  gradingGrid?: Record<string, number>;
  userSettings?: unknown;
}

export interface CurriculumSearchResult {
  content?: string;
  metadata?: { ano_base?: number; source?: string };
}

export interface PlanningDAL {
  searchCurriculum(
    query: string,
    filters?: { disciplina?: string; ano?: string; periodo?: string }
  ): Promise<CurriculumSearchResult[]>;
  getDeterministicCurriculum(
    disciplina: string,
    periodo: string,
    ano?: string
  ): Promise<string | null>;
  searchPnldBookContent(
    query: string,
    filters?: { livro_titulo?: string; disciplina?: string }
  ): Promise<unknown[]>;
  searchEnemQuestions(query: string, areas?: string[]): Promise<unknown[]>;
  getGeneratedContents(userId: string): Promise<unknown[]>;
  saveTermPlan(plan: unknown, userId: string): Promise<unknown>;
}
