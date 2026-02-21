import { getGenAIClient } from "./AiCore";
import { extractGuardrailsFromSettings, generateGuardrailsPrompt } from "./AiGuardrailsService";
import { UserSettings } from "../../types";

type LessonContext = {
    topic?: string;
    content?: string;
};

/**
 * [ASSESSMENT_WITH_CONTEXT_MODE]
 * Gera avaliações baseadas no histórico de aulas dadas (Ciclo de Feedback Fechado)
 */
export const generateAssessmentWithContext = async (
    className: string,
    subject: string,
    lessonsContext: LessonContext[],
    additionalTopic: string = '',
    academicPeriod: string = '',
    objectiveCount: number = 10,
    dissertativeCount: number = 2,
    numEnem: number = 0,
    difficulty: string = 'Médio',
    userSettings?: UserSettings, // 🛡️ GUARDRAILS
    userId?: string
) => {
    const genAI = getGenAIClient();

    const lessonsToReference = lessonsContext.map((lesson, i) =>
        `Aula ${i + 1}: ${lesson.topic}\nConteúdo: ${lesson.content?.substring(0, 500)}...`
    ).join('\n\n');

    // 🛡️ GUARDRAILS: Apply user preferences to assessments
    let guardrailsPrompt = "";
    if (userSettings) {
        const guardrailsConfig = extractGuardrailsFromSettings(userSettings);
        guardrailsConfig.context = `Avaliação - ${subject} - ${academicPeriod}`;
        guardrailsPrompt = generateGuardrailsPrompt(guardrailsConfig, true);
    }

    const instruction = `Age como um Professor Avaliador Pedagógico do PROFEPLAN.
  
  ${guardrailsPrompt}
  
  OBJETIVO: Gerar uma avaliação oficial, coerente e contextualizada.
  
  CONTEXTO DAS AULAS DADAS:
  ${lessonsToReference || 'Nenhuma aula anterior disponível como base.'}
  
  ASSUNTO ESPECÍFICO ADICIONAL:
  ${additionalTopic || 'Nenhum'}
  
  PERÍODO LETIVO: ${academicPeriod}
  
  ESTRUTURA DA AVALIAÇÃO:
  - ${objectiveCount} questões OBJETIVAS baseadas nas aulas contextuais.
  - ${dissertativeCount} questões DISSERTATIVAS (abertas) baseadas nas aulas contextuais.
  - ${numEnem} questões ESTILO ENEM: Devem ser SEMPRE OBJETIVAS (múltipla escolha).
  
  NÍVEL DE DIFICULDADE GERAL: ${difficulty}
  
  REGRAS TÉCNICAS:
  1. Todas as questões OBJETIVAS (Contextuais e ENEM) devem ter EXATAMENTE 5 alternativas (A, B, C, D, E).
  2. Referência ENEM: Para cada questão estilo ENEM, comece o enunciado com a referência entre colchetes, ex: "[ENEM 2022] ...", "[ENEM 2023] ...".
  3. Coerência Pedagógica: As questões contextuais devem focar no que foi ensinado nas aulas fornecidas.
  4. Matriz ENEM: As questões estilo ENEM devem abordar competências oficiais no nível ${difficulty}.
  5. Formato: Retorne um JSON puro para ser processado pelo sistema.
  6. Gabarito: Inclua a resposta correta para objetivas e rubrica para dissertativas.
  
  Retorne APENAS um JSON puro:
  {
    "title": "Título da Avaliação (Ex: Avaliação de ${subject} - ${academicPeriod})",
    "questions": [
      {
        "id": "q1",
        "type": "objective",
        "question": "[ENEM 2023] Enunciado...",
        "options": ["A) ...", "B) ...", "C) ...", "D) ...", "E) ..."],
        "correctAnswer": "A",
        "maxPoints": 1,
        "difficulty": "${difficulty}"
      },
      {
        "id": "q2",
        "type": "dissertative",
        "question": "Enunciado aberto...",
        "rubric": "Critérios: 1. Explicação do conceito (X pts)...",
        "maxPoints": 10,
        "difficulty": "${difficulty}"
      }
    ]
  }`;

    const model = genAI.getGenerativeModel({
        model: "gemini-2.0-flash",
        systemInstruction: instruction
    });

    const prompt = `Crie uma avaliação de ${subject} para a turma ${className}, referente ao ${academicPeriod}.`;
    const result = await model.generateContent(prompt);
    const responseText = result.response.text();

    try {
        const jsonMatch = responseText.match(/\{[\s\S]*\}/);
        if (jsonMatch) {
            return JSON.parse(jsonMatch[0]);
        }
        return JSON.parse(responseText);
    } catch (e) {
        console.error("Erro ao parsear JSON da avaliação:", responseText);
        throw new Error("Não foi possível gerar a avaliação. Tente novamente.");
    }
};

/**
 * [GRADING_MODE - Gemini Vision]
 * Corrige questões dissertativas via OCR + Análise Pedagógica
 */
export const gradeWrittenAnswer = async (
    questionText: string,
    rubric: string,
    imageBase64: string // Foto da resposta escrita
) => {
    const genAI = getGenAIClient();

    const instruction = `Age como um Professor Corretor Pedagógico.
  
  TAREFA: Corrigir uma questão dissertativa escrita à mão.
  
  PASSOS:
  1. Leia a escrita do aluno (OCR)
  2. Compare com a RUBRICA de correção
  3. Atribua uma nota de 0 a 10
  4. Dê um FEEDBACK PEDAGÓGICO construtivo
  
  Retorne APENAS um JSON:
  {
    "studentAnswer": "Texto extraído da imagem",
    "score": 7.5,
    "maxScore": 10,
    "feedback": "Você demonstrou compreensão de X, mas faltou mencionar Y..."
  }`;

    const model = genAI.getGenerativeModel({
        model: "gemini-2.0-flash",
        systemInstruction: instruction
    });

    const prompt = `QUESTÃO: ${questionText}\n\nRUBRICA DE CORREÇÃO:\n${rubric}\n\nAgora analise a resposta escrita do aluno na imagem.`;

    const result = await model.generateContent([
        { text: prompt },
        {
            inlineData: {
                data: imageBase64.split(',')[1] || imageBase64,
                mimeType: 'image/jpeg'
            }
        }
    ]);

    const responseText = result.response.text();

    try {
        const jsonMatch = responseText.match(/\{[\s\S]*\}/);
        if (jsonMatch) {
            return JSON.parse(jsonMatch[0]);
        }
        return JSON.parse(responseText);
    } catch (e) {
        console.error("Erro ao parsear resultado de correção:", responseText);
        throw new Error("Não foi possível processar a correção. Tente novamente.");
    }
};
