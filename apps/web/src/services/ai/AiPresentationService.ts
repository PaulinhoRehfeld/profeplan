import { getGenAIClient } from "./AiCore";

/**
 * [PRESENTATION_MODE - Structured JSON]
 * Gera roteiro de slides estruturado em JSON para o módulo de Apresentações
 */
export const generatePresentationJSON = async (
    topic: string,
    context: string,
    slideCount: number,
    style: string,
    includeInteractions: boolean
) => {
    const genAI = getGenAIClient();

    const instruction = `Age como um Designer Instrucional e Especialista em Apresentações Visuais.

  OBJETIVO: Criar um roteiro de apresentação de alto impacto, estruturado em JSON.

  PARÂMETROS:
  - TEMA/ASSUNTO: ${topic}
  - CONTEXTO/AULA BASE: ${context || 'Criar do zero'}
  - QUANTIDADE DE SLIDES: Aprox. ${slideCount}
  - ESTILO VISUAL: ${style}
  - INCLUIR INTERAÇÕES: ${includeInteractions ? 'Sim (Perguntas, Enquetes, Reflexões)' : 'Não (Apenas conteúdo)'}

  ESTRUTURA DO JSON DE SAÍDA:
  Retorne APENAS um JSON com a seguinte estrutura:
  {
    "title": "Título Criativo da Apresentação",
    "theme": "${style}",
    "slides": [
      {
        "order": 1,
        "type": "capa" | "conteudo" | "interacao" | "conclusao",
        "title": "Título do Slide",
        "contentBulletPoints": ["Tópico 1", "Tópico 2", "Tópico 3"],
        "imageSuggestion": "Descrição visual detalhada para IA generativa de imagens",
        "speakerNotes": "Roteiro do que o professor deve falar neste slide"
      }
    ]
  }

  DIRETRIZES DE CONTEÚDO:
  1. Seja sintético nos bullet points (regra 6x6).
  2. Use linguagem adequada ao estilo visual escolhido.
  3. Se interações estiverem ativadas, insira pelo menos 1 slide de "interacao" a cada 3-4 slides de conteúdo.
  4. As 'imageSuggestion' devem ser prompts artísticos e descritivos.
  `;

    const model = genAI.getGenerativeModel({
        model: "gemini-2.0-flash",
        systemInstruction: instruction,
        generationConfig: { responseMimeType: "application/json" }
    });

    const prompt = `Gere o roteiro da apresentação sobre: ${topic}`;

    try {
        const result = await model.generateContent(prompt);
        const text = result.response.text();
        return JSON.parse(text);
    } catch (e) {
        console.error("Erro ao gerar slides:", e);
        throw new Error("Falha ao gerar o roteiro da apresentação.");
    }
};
