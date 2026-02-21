/**
 * USE SIMULATION QUESTIONS HOOK
 * ==============================
 * 
 * React Hook para gerenciar busca de questões de forma isolada
 * Encapsula toda a lógica de estado e busca
 */

import { useState, useCallback } from 'react';
import { questionBank } from '../services/QuestionBankService';
import { SimulationQuestion, QuestionSearchParams } from '../types/question.types';

interface UseSimulationQuestionsReturn {
    questions: SimulationQuestion[];
    isLoading: boolean;
    error: string | null;
    search: (params: QuestionSearchParams) => Promise<void>;
    clear: () => void;
    totalFound: number;
}

export const useSimulationQuestions = (): UseSimulationQuestionsReturn => {
    const [questions, setQuestions] = useState<SimulationQuestion[]>([]);
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);
    const [totalFound, setTotalFound] = useState(0);

    const search = useCallback(async (params: QuestionSearchParams) => {
        setIsLoading(true);
        setError(null);

        try {
            const result = await questionBank.search(params);
            setQuestions(result.questions);
            setTotalFound(result.total);
        } catch (err) {
            const errorMessage = err instanceof Error ? err.message : 'Erro ao buscar questões';
            setError(errorMessage);
            setQuestions([]);
            setTotalFound(0);
        } finally {
            setIsLoading(false);
        }
    }, []);

    const clear = useCallback(() => {
        setQuestions([]);
        setError(null);
        setTotalFound(0);
    }, []);

    return {
        questions,
        isLoading,
        error,
        search,
        clear,
        totalFound
    };
};
