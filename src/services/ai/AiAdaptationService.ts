import { generateGeminiContent } from "../geminiService";

interface StudentProfile {
    name: string;
    psychomotor?: any;
    cognitive?: any;
    communication?: any;
}

export const AiAdaptationService = {
    /**
     * Generate specific lesson adaptations based on student PDI profile
     */
    async generateLessonAdaptation(
        studentProfile: StudentProfile,
        lessonTopic: string,
        lessonObjective: string,
        userId: string
    ): Promise<{ goal: string; strategy: string }> {

        // 1. Construct the PDI Context Summary
        const profileSummary = `
        ALUNO: ${studentProfile.name}
        
        PERFIL COGNITIVO:
        ${JSON.stringify(studentProfile.cognitive || {}, null, 2)}
        
        PERFIL PSICOMOTOR:
        ${JSON.stringify(studentProfile.psychomotor || {}, null, 2)}
        
        COMUNICAÇÃO:
        ${JSON.stringify(studentProfile.communication || {}, null, 2)}
        `;

        // 2. Build the Expert Prompt
        const prompt = `
        ATUE COMO UM ESPECIALISTA EM EDUCAÇÃO INCLUSIVA E PDI.
        
        CONTEXTO:
        O professor vai ministrar uma aula sobre: "${lessonTopic}"
        Objetivo da aula: "${lessonObjective}"
        
        PARA O ALUNO COM O SEGUINTE PERFIL:
        ${profileSummary}
        
        TAREFA:
        Sugira uma ADAPTAÇÃO CURRICULAR (Seção IX do PDI) específica para esta aula.
        
        SAÍDA ESPERADA (JSON):
        {
            "goal": "Objetivo adaptado (O que o aluno deve ser capaz de fazer? Seja realista baseado no perfil)",
            "strategy": "Estratégia/Metodologia (Como o professor pode adaptar? Materiais concretos? Tempo extra? Pares?)"
        }
        
        Responda APENAS o JSON.
        `;

        try {
            const response = await generateGeminiContent(prompt, [], "Você é uma API JSON de Educação Inclusiva.", userId, 0.4);

            // Clean JSON markdown if present
            const jsonStr = response.replace(/```json/g, '').replace(/```/g, '').trim();
            const result = JSON.parse(jsonStr);

            return {
                goal: result.goal || "Objetivo adaptado não gerado.",
                strategy: result.strategy || "Estratégia não gerada."
            };

        } catch (error) {
            console.error("AI Adaptation Error:", error);
            return {
                goal: "Erro ao gerar adaptação. Tente simplificar o tópico.",
                strategy: "Utilize estratégias visuais e verifique a compreensão."
            };
        }
    }
};
