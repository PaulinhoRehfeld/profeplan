/**
 * PdiDAL - Camada de acesso a dados para PDI.
 * Encapsula PdiDocumentService (consolidado).
 * Fase 2 da refatoração (ARCHITECTURE-PROFEPLAN).
 */
import { PdiDocumentService } from '../pdi/PdiDocumentService';
import type { PdiRecordType } from '../pdi/PdiDocumentService';

export interface PdiDAL {
  getOrCreatePdi(
    studentId: string,
    year?: number,
    contextualData?: { profile?: unknown; studentName?: string }
  ): Promise<{ data: unknown; error: unknown }>;
  logEvent(
    studentId: string,
    type: PdiRecordType,
    title: string,
    content: Record<string, unknown>,
    pdiBlock?: string
  ): Promise<unknown>;
  getStudentTimeline(studentId: string): Promise<unknown[]>;
  getStudentAdaptations(pdiId: string): Promise<unknown[]>;
  getAdaptationStats(
    pdiId: string
  ): Promise<{ total: number; last_generated?: string; subjects: string[] }>;
}

export const pdiDAL: PdiDAL = {
  async getOrCreatePdi(studentId, year = new Date().getFullYear(), contextualData) {
    return PdiDocumentService.getOrCreatePdi(studentId, year, contextualData as any);
  },

  async logEvent(studentId, type, title, content, pdiBlock) {
    return PdiDocumentService.logEvent(studentId, type, title, content, pdiBlock);
  },

  async getStudentTimeline(studentId) {
    return PdiDocumentService.getStudentTimeline(studentId);
  },

  async getStudentAdaptations(pdiId) {
    return PdiDocumentService.getStudentAdaptations(pdiId);
  },

  async getAdaptationStats(pdiId) {
    return PdiDocumentService.getAdaptationStats(pdiId);
  },
};
