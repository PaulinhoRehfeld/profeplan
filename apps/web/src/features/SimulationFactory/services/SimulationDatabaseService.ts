/**
 * SIMULATION DATABASE SERVICE
 * ============================
 *
 * ⚠️ CRÍTICO: Camada de acesso DIRETA e ISOLADA ao banco de questões
 * Mudanças em outros serviços NÃO DEVEM afetar este módulo
 *
 * Conexões:
 * - Supabase (único ponto de dependência externa)
 *
 * Proteções:
 * - Try/catch em todas as operações
 * - Logs detalhados para debug
 * - Retornos seguros (array vazio em vez de null)
 */

import { supabase } from '../../../services/supabaseClient';
import { QuestionDatabaseRow } from '../types/question.types';

class SimulationDatabaseService {
  private readonly TABLE_NAME = 'enem_questions';
  private readonly DEFAULT_LIMIT = 50;

  /**
   * Busca textual direta no banco
   * Método mais confiável - sempre funciona mesmo se embeddings falharem
   */
  async searchByText(
    pattern: string,
    limit: number = this.DEFAULT_LIMIT
  ): Promise<QuestionDatabaseRow[]> {
    try {
      const searchPattern = `%${pattern}%`;

      console.log(`[SimDB] 🔍 Text search: "${pattern}" (limit: ${limit})`);

      const { data, error } = await supabase
        .from(this.TABLE_NAME)
        .select('id, content, metadata')
        .ilike('content', searchPattern)
        .limit(limit);

      if (error) {
        console.error('[SimDB] ❌ Text search error:', error);
        throw new Error(`Database search failed: ${error.message}`);
      }

      console.log(`[SimDB] ✅ Found ${data?.length || 0} results`);

      return (data as QuestionDatabaseRow[]) || [];
    } catch (error) {
      console.error('[SimDB] ❌ searchByText exception:', error);
      throw error;
    }
  }

  /**
   * Busca por IDs específicos (para hidratação de metadados)
   */
  async getByIds(ids: number[]): Promise<QuestionDatabaseRow[]> {
    try {
      if (ids.length === 0) return [];

      console.log(`[SimDB] 🔍 Fetching ${ids.length} questions by ID`);

      const { data, error } = await supabase
        .from(this.TABLE_NAME)
        .select('id, metadata')
        .in('id', ids);

      if (error) {
        console.error('[SimDB] ❌ ID search error:', error);
        throw new Error(`Question fetch failed: ${error.message}`);
      }

      console.log(`[SimDB] ✅ Retrieved ${data?.length || 0} questions`);

      return (data as QuestionDatabaseRow[]) || [];
    } catch (error) {
      console.error('[SimDB] ❌ getByIds exception:', error);
      throw error;
    }
  }

  /**
   * Contagem total de questões no banco
   * Útil para estatísticas e validação
   */
  async getTotalCount(): Promise<number> {
    try {
      console.log('[SimDB] 📊 Counting total questions');

      const { count, error } = await supabase
        .from(this.TABLE_NAME)
        .select('*', { count: 'exact', head: true });

      if (error) {
        console.error('[SimDB] ❌ Count error:', error);
        return 0;
      }

      console.log(`[SimDB] ✅ Total questions: ${count}`);

      return count || 0;
    } catch (error) {
      console.error('[SimDB] ❌ getTotalCount exception:', error);
      return 0;
    }
  }

  /**
   * Busca por área específica (filtro no banco)
   * Mais eficiente que filtrar client-side
   */
  async searchByArea(
    pattern: string,
    disciplines: string[],
    limit: number = this.DEFAULT_LIMIT
  ): Promise<QuestionDatabaseRow[]> {
    try {
      const searchPattern = `%${pattern}%`;

      console.log(`[SimDB] 🔍 Area search: "${pattern}" in [${disciplines.join(', ')}]`);

      // Busca com filtro de disciplina no metadata (JSONB)
      const { data, error } = await supabase
        .from(this.TABLE_NAME)
        .select('id, content, metadata')
        .ilike('content', searchPattern)
        .limit(limit * 2); // Buscar mais para compensar filtro

      if (error) {
        console.error('[SimDB] ❌ Area search error:', error);
        throw new Error(`Area search failed: ${error.message}`);
      }

      // Filtrar por disciplina (client-side por enquanto)
      // TODO: Melhorar com índice JSONB no futuro
      const filtered =
        (data as QuestionDatabaseRow[])?.filter((row) => {
          const disc = row.metadata?.discipline || row.metadata?.disciplina || '';
          return disciplines.some((d) => disc.toLowerCase().includes(d.toLowerCase()));
        }) || [];

      console.log(`[SimDB] ✅ Found ${filtered.length} results after area filter`);

      return filtered.slice(0, limit);
    } catch (error) {
      console.error('[SimDB] ❌ searchByArea exception:', error);
      throw error;
    }
  }

  /**
   * Health check - verifica conectividade com o banco
   */
  async healthCheck(): Promise<{ healthy: boolean; message: string }> {
    try {
      const count = await this.getTotalCount();

      if (count > 0) {
        return {
          healthy: true,
          message: `Database accessible. ${count} questions available.`,
        };
      } else {
        return {
          healthy: false,
          message: 'Database accessible but no questions found.',
        };
      }
    } catch (error) {
      return {
        healthy: false,
        message: `Database connection failed: ${error}`,
      };
    }
  }
}

// Singleton export
export const simulationDB = new SimulationDatabaseService();
