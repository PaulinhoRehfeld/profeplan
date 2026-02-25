import { GENERATION_MODELS, getGenAIClient } from "./AiCore";

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
    const client = getGenAIClient();

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

    const messages = [
        {
            role: "system" as const,
            content: instruction,
        },
        {
            role: "user" as const,
            content: `Gere o roteiro da apresentação sobre: ${topic}`,
        },
    ];

    const completion = await client.chat.completions.create({
        model: GENERATION_MODELS[0],
        messages,
        temperature: 0.3,
    } as any);

    const content = completion.choices[0]?.message?.content as any;
    const text =
        typeof content === "string"
            ? content
            : (content as any[] | undefined)?.map((c) => (typeof c === "string" ? c : c.text || "")).join("") ?? "";

    try {
        return JSON.parse(text);
    } catch (e) {
        console.error("Erro ao gerar slides:", e, text);
        throw new Error("Falha ao gerar o roteiro da apresentação.");
    }
};

