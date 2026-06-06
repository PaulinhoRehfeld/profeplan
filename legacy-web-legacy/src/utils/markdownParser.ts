import { Lesson } from '../types';

/**
 * Parses a "Markdown-First" plan into structured lessons.
 * Strategies:
 * 1. Finds strictly formatted headers "### Aula X: Title".
 * 2. Extracts description, objectives, and BNCC from the body of each section.
 */
export const parseMarkdownToLessons = (markdown: string): Lesson[] => {
    const lines = markdown.split('\n');
    const lessons: Lesson[] = [];

    let currentLesson: Partial<Lesson> | null = null;
    let captureMode: 'description' | 'objectives' | 'bncc' | null = null;

    const finalizeLesson = () => {
        if (currentLesson && currentLesson.number) {
            // Defaults
            if (!currentLesson.objectives) currentLesson.objectives = [];
            if (!currentLesson.bncc) currentLesson.bncc = [];

            // Clean up strings
            if (currentLesson.description) {
                currentLesson.description = currentLesson.description.trim();
            }

            lessons.push(currentLesson as Lesson);
        }
    };

    for (let i = 0; i < lines.length; i++) {
        const line = lines[i].trim();

        // 1. Detect New Lesson Header: "### Aula 1: Título" or "### Aula 01 - Título"
        // Regex: ### + Space + Aula + Space + Number + (Separator) + Title
        const lessonMatch = line.match(/^###\s+Aula\s+(\d+)[\s:\-\.]+(.*)/i);

        if (lessonMatch) {
            finalizeLesson(); // Push previous

            currentLesson = {
                number: parseInt(lessonMatch[1]),
                title: lessonMatch[2].trim(),
                description: '',
                objectives: [],
                bncc: [],
                content: '' // Optional or combined with description
            };
            captureMode = 'description';
            continue;
        }

        if (!currentLesson) continue;

        // 2. Detect Metadata Headers within a Lesson
        if (line.match(/^\*\*Objetivos?:?\*\*/i)) {
            captureMode = 'objectives';
            continue;
        }
        if (line.match(/^\*\*BNCC:?\*\*/i) || line.match(/^\*\*Habilidades?:?\*\*/i)) {
            captureMode = 'bncc';
            continue;
        }
        if (line.match(/^\*\*Descrição:?\*\*/i) || line.match(/^\*\*Conteúdo:?\*\*/i)) {
            captureMode = 'description';
            // If the line has content immediately after "**Descrição:** resumo...", capture it.
            const contentMatch = line.match(/^\*\*Descrição:?\*\*\s*(.*)/i);
            if (contentMatch && contentMatch[1]) {
                currentLesson.description += contentMatch[1] + '\n';
            }
            continue;
        }

        // 3. Capture Content based on Mode
        if (line === '') continue; // Skip empty lines mostly, or keep single newline?

        if (captureMode === 'objectives') {
            // Bullet points
            const bulletMatch = line.match(/^[-•*]\s*(.*)/);
            if (bulletMatch) {
                currentLesson.objectives?.push(bulletMatch[1].trim());
            }
        } else if (captureMode === 'bncc') {
            // Codes usually comma separated or bullet points
            // simple heuristic: split by comma or spaces if it looks like code
            // Or just treat as list items
            const bulletMatch = line.match(/^[-•*]\s*(.*)/);
            if (bulletMatch) {
                const codes = bulletMatch[1].split(/[,;]+/).map(s => s.trim()).filter(s => s.length > 0);
                currentLesson.bncc?.push(...codes);
            } else {
                // Inline codes: "EF05, EF06"
                const codes = line.split(/[,;]+/).map(s => s.trim()).filter(s => /^[A-Z0-9]{4,10}$/.test(s));
                if (codes.length > 0) currentLesson.bncc?.push(...codes);
            }
        } else if (captureMode === 'description') {
            // Append general text
            if (!line.startsWith('**')) {
                currentLesson.description += line + '\n';
            }
        }
    }

    finalizeLesson(); // Push last
    return lessons;
};
