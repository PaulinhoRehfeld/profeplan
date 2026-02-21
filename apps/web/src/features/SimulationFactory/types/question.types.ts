/**
 * SIMULATION FACTORY - ISOLATED TYPES
 * ====================================
 * 
 * ⚠️ CRÍTICO: Este arquivo NÃO deve importar de types.ts global
 * Tipos isolados para garantir que mudanças externas não quebrem o módulo
 */

/**
 * Questão do banco ENEM/SAEB
 * Cópia isolada e independente de EnemQuestion
 */
export interface SimulationQuestion {
    id: number;
    similarity?: number;
    metadata: {
        id_original: number;
        year: number;
        discipline: string;
        disciplina?: string; // Suporte legado/português

        // Texto da questão dividido em duas partes:
        context: string; // Texto base, história ou cenário
        alternativesIntroduction: string; // Pergunta final (comando)

        // Array de alternativas
        alternatives: Array<{
            letter: string; // "A", "B", "C", "D", "E"
            text: string;
            isCorrect: boolean;
        }>;

        bncc: string[];
        tags: string[];
    };
}

/**
 * Parâmetros de busca de questões
 */
export interface QuestionSearchParams {
    query: string;
    areas?: string[]; // ['Linguagens', 'Matemática', 'Humanas', 'Natureza']
    limit?: number;
}

/**
 * Resultado de busca
 */
export interface QuestionSearchResult {
    questions: SimulationQuestion[];
    total: number;
    source: 'text' | 'semantic';
}

/**
 * Row do banco de dados (formato bruto)
 */
export interface QuestionDatabaseRow {
    id: number;
    content?: string;
    metadata: SimulationQuestion['metadata'];
    embedding?: any;
}

/**
 * Áreas disponíveis para filtro
 */
export type QuestionArea = 'Linguagens' | 'Matemática' | 'Humanas' | 'Natureza';

/**
 * Mapeamento de áreas para disciplinas
 */
export const AREA_DISCIPLINE_MAP: Record<QuestionArea, string[]> = {
    'Humanas': ['História', 'Geografia', 'Filosofia', 'Sociologia', 'Ciências Humanas'],
    'Natureza': ['Física', 'Química', 'Biologia', 'Ciências da Natureza'],
    'Linguagens': ['Português', 'Literatura', 'Inglês', 'Espanhol', 'Artes', 'Educação Física', 'Linguagens'],
    'Matemática': ['Matemática']
};
