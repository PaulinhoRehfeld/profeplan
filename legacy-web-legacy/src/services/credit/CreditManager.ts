/**
 * CreditManager - Centraliza verificação e consumo de créditos.
 * Fase 1 da refatoração (ARCHITECTURE-PROFEPLAN).
 *
 * Uso: executeWithCreditCheck(userId, async () => { ... }, 'term_plan')
 *
 * CONTEXTO COLABORATIVO: O PROFEPLAN é um projeto de utilização colaborativa
 * (professor ↔ turmas ↔ alunos ↔ escolas ↔ disciplinas). O context opcional
 * permite futura extensão para pool de créditos por escola.
 */
import { checkUsageQuota, incrementUserUsage } from '../ProfileService';

export type CreditTaskType = 'generate' | 'document' | 'chat' | 'term_plan' | 'aula' | 'simulation';

export interface CreditContext {
  /** Escola do professor (profiles.school_id). Futuro: pool de créditos por escola. */
  schoolId?: string;
  /** Turma em contexto. Auditoria e relatórios. */
  classId?: string;
  /** Disciplina em contexto. */
  subject?: string;
}

export interface CreditManager {
  checkQuota(userId: string): Promise<{ allowed: boolean; message?: string }>;
  executeWithCreditCheck<T>(
    userId: string,
    fn: () => Promise<T>,
    taskType: CreditTaskType,
    context?: CreditContext
  ): Promise<T>;
}

class CreditManagerImpl implements CreditManager {
  async checkQuota(userId: string): Promise<{ allowed: boolean; message?: string }> {
    return checkUsageQuota(userId);
  }

  async executeWithCreditCheck<T>(
    userId: string,
    fn: () => Promise<T>,
    taskType: CreditTaskType,
    _context?: CreditContext
  ): Promise<T> {
    const quota = await checkUsageQuota(userId);
    if (!quota.allowed) {
      throw new Error(quota.message || 'Créditos insuficientes.');
    }

    const result = await fn();

    await incrementUserUsage(userId, taskType);
    return result;
  }
}

export const creditManager: CreditManager = new CreditManagerImpl();
