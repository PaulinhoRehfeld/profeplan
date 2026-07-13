/**
 * PlanningDAL - Camada de acesso a dados para planejamento.
 * Encapsula searchService, questionService, databaseService, TermPlanningService.
 */
import {
  searchCurriculum,
  getDeterministicCurriculum,
  searchPnldBookContent,
} from '../searchService';
import { searchQuestions } from '../questionService';
import { getGeneratedContents } from '../databaseService';
import { saveTermPlan } from '../../features/TermPlanning/TermPlanningService';
import type { PlanningDAL as IPlanningDAL, CurriculumSearchResult } from './types';
import type { TermPlan } from '../../types';

export const planningDAL: IPlanningDAL = {
  async searchCurriculum(query, filters) {
    const results = await searchCurriculum(query, filters, 5);
    return (results || []) as CurriculumSearchResult[];
  },

  async getDeterministicCurriculum(disciplina, periodo, ano) {
    return getDeterministicCurriculum(disciplina, periodo, ano);
  },

  async searchPnldBookContent(query, filters) {
    return searchPnldBookContent(query, filters, 5);
  },

  async searchEnemQuestions(query, areas) {
    return searchQuestions(query, areas);
  },

  async getGeneratedContents(userId) {
    return getGeneratedContents(userId);
  },

  async saveTermPlan(plan, userId) {
    return saveTermPlan(plan as TermPlan, userId);
  },
};
