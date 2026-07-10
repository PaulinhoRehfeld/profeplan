import { describe, expect, it, beforeEach } from 'vitest';
import { getLocalClasses, saveClassToLocal } from '../services/localStorageService';

// Regressão: ClassManager sempre grava o backup local sob `userId` (session.id), que pode
// ser um Ghost ID desatualizado em relação ao auth.uid() real (ver feedback_ghost_id_pattern).
// usePDIManager buscava o fallback local só por `realUserId` (resolvido via getUser()),
// então turmas presas no localStorage sob o Ghost ID ficavam invisíveis em Adaptações PDI/DUA
// mesmo aparecendo em "Minhas Turmas". O fix tenta os dois IDs.

describe('fallback local do PDI/DUA sob Ghost ID', () => {
    beforeEach(() => {
        localStorage.clear();
    });

    it('turma salva sob o Ghost ID não é encontrada buscando só pelo realUserId', () => {
        const ghostUserId = 'ghost-uuid-antigo';
        const realUserId = 'real-uuid-atual';

        saveClassToLocal(ghostUserId, { className: '1º EM REG 7', subject: 'Filosofia', students: ['Aluno A'] });

        expect(getLocalClasses(realUserId)).toEqual([]);
        expect(getLocalClasses(ghostUserId)).toHaveLength(1);
    });

    it('a lógica de fallback com dois IDs (a que o fix introduz) recupera a turma presa no Ghost ID', () => {
        const ghostUserId = 'ghost-uuid-antigo';
        const realUserId = 'real-uuid-atual';

        saveClassToLocal(ghostUserId, { className: '1º EM REG 7', subject: 'Filosofia', students: ['Aluno A'] });

        // Réplica exata do trecho novo em usePDIManager.ts
        let localClasses = getLocalClasses(realUserId);
        if (!localClasses.length && ghostUserId !== realUserId) {
            localClasses = getLocalClasses(ghostUserId);
        }

        expect(localClasses).toHaveLength(1);
        expect(localClasses[0].name).toBe('1º EM REG 7');
    });
});
