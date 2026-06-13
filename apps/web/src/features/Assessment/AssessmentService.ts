import { supabase } from '../../services/supabaseClient';
import { Assessment } from '../../types';
import { PdiDocumentService } from '../../services/pdi/PdiDocumentService'; // Updated from PdiService

// A-2: Key MUST include userId to prevent data leakage between accounts
const getAssessmentKey = (userId: string) => `profeplan_assessments:${userId}`;

/**
 * [LOCAL-FIRST]
 * Salva a avaliação localmente e tenta sincronizar com o Supabase em background.
 */
export const saveAssessment = async (userId: string, assessment: Assessment) => {
    // 1. Salvar no LocalStorage (Garantia de Sobrevivência)
    try {
        const saved = JSON.parse(localStorage.getItem(getAssessmentKey(userId)) || '[]');

        // Remove versão antiga se existir (Update)
        const filtered = saved.filter((a: Assessment) => a.id !== assessment.id);

        filtered.push(assessment);
        localStorage.setItem(getAssessmentKey(userId), JSON.stringify(filtered));
        console.log('✅ Avaliação salva localmente.');
    } catch (e) {
        console.error('Erro crítico ao salvar no LocalStorage:', e);
        throw new Error('Não foi possível salvar a avaliação no dispositivo.');
    }

    // 2. Sincronização Background (Fire-and-Forget)
    syncAssessmentToCloud(userId, assessment).catch(err => {
        console.warn('⚠️ Falha no Sync Background (será tentado novamente depois):', err);
    });

    return true;
};

/**
 * Sincroniza uma avaliação específica com o Supabase.
 * Salva em 'generated_contents' (histórico) e 'lessons' (memória context).
 */
const syncAssessmentToCloud = async (userId: string, assessment: Assessment) => {
    // Convert to Markdown for storage
    const markdown = assessmentToMarkdown(assessment);

    // A. Salvar no Histórico (generated_contents)
    const { error: contentError } = await supabase
        .from('generated_contents')
        .insert({
            user_id: userId,
            type: 'avaliacao',
            folder: 'AVALIAÇÕES', // Hardcoded fallback or import PlanFolder if possible, but string is safer for now
            title: assessment.title,
            content: markdown
        });

    if (contentError) throw contentError;

    // B. Salvar na Memória (lessons)
    const { error: lessonError } = await supabase
        .from('lessons')
        .insert({
            user_id: userId,
            topic: `AVALIAÇÃO: ${assessment.title}`,
            content: markdown,
            class_id: assessment.classId
        });

    if (lessonError) console.warn('Erro ao salvar memória da avaliação:', lessonError);

    // C. PDI Automation (Sync to Block X)
    if (assessment.classId) {
        PdiDocumentService.logEventForClass(
            assessment.classId,
            'EVALUATION',
            `Avaliação: ${assessment.title}`,
            {
                subject: assessment.subject,
                points: assessment.totalPoints,
                period: assessment.academicPeriod
            },
            'Bloco X' // Avaliação da Aprendizagem
        ).catch(err => console.warn('Erro ao logar PDI automático:', err));
    }

    console.log('☁️ Avaliação sincronizada com a nuvem!');
};

/**
 * Busca avaliações (Prioridade Local > Nuvem)
 */
export const getAssessments = async (userId: string): Promise<Assessment[]> => {
    // 1. Tenta Local
    const localData = localStorage.getItem(getAssessmentKey(userId));
    if (localData) {
        try { return JSON.parse(localData); } catch { return []; }
    }

    // 2. Se não tiver local, tenta buscar do Supabase (generated_contents)
    return [];
};


// Helper: Converte JSON Assessment para Markdown (para salvar no banco legado)
const assessmentToMarkdown = (assessment: Assessment): string => {
    let md = `# ${assessment.title}\n\n`;
    md += `**Disciplina:** ${assessment.subject}\n`;
    md += `**Turma:** ${assessment.className}\n`;
    md += `**Período:** ${assessment.academicPeriod}\n`;
    md += `**Valor Total:** ${assessment.totalPoints} pts\n\n`;
    md += `---\n\n`;

    assessment.questions.forEach((q, i) => {
        md += `### Questão ${i + 1} (${q.type === 'objective' ? 'Objetiva' : 'Dissertativa'}) - ${q.maxPoints} pts\n`;
        md += `${q.question}\n\n`;
        if (q.type === 'objective' && q.options) {
            q.options.forEach(opt => {
                md += `- ${opt}\n`;
            });
            md += `\n**Gabarito:** ${q.correctAnswer}\n\n`;
        } else if (q.type === 'dissertative' && q.rubric) {
            md += `**Critérios de Correção (Rubrica):**\n${q.rubric}\n\n`;
        }
        md += `---\n\n`;
    });

    return md;
};
