export type AssistantStatus = 'IDLE' | 'AGUARDANDO_CONFIRMACAO' | 'PROCESSANDO';

export interface GuardContext {
    status: AssistantStatus;
    foundPlan?: any; // O plano encontrado para confirmação
    originalIntent?: string; // O que o usuário pediu inicialmente
}

/**
 * Analisa se uma resposta de texto é uma confirmação positiva.
 * Útil para quando o usuário digita/fala em vez de clicar no botão.
 */
export function analisarPositivo(texto: string): boolean {
    const termosPositivos = [
        'sim', 'pode', 'bora', 'claro', 'com certeza', 'ok', 'segue', 'isso', 'exato', 'confirmado', 'positive'
    ];
    const cleaned = texto.toLowerCase().trim();
    // Verifica se o texto começa com, ou contém de forma isolada, os termos
    return termosPositivos.some(termo =>
        cleaned === termo ||
        cleaned.startsWith(termo + ' ') ||
        cleaned.includes(' ' + termo + ' ')
    );
}

/**
 * Realiza uma busca local rápida (Client-Side) nos planos carregados
 */
export function searchLocalPlans(query: string, plans: any[]): any | null {
    const q = query.toLowerCase();

    // Tenta encontrar menções diretas a "Aula X"
    const lessonMatch = q.match(/(?:aula|encontro)\s+(\d+)/i);
    const lessonNumber = lessonMatch ? lessonMatch[1] : null;

    // Filtra planos que batem com o texto (Disciplina, Série ou Aula específica)
    const matches = plans.filter(p => {
        const subjectMatch = q.includes(p.subject?.toLowerCase());
        const gradeMatch = q.includes(p.grade?.toLowerCase());
        // Se tiver número de aula, tenta ver se o plano cobre (simulação simples)
        return subjectMatch || gradeMatch;
    });

    // Retorna o mais recente ou mais relevante
    return matches.length > 0 ? matches[0] : null;
}
