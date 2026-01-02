
import { GoogleGenerativeAI, HarmBlockThreshold, HarmCategory } from "@google/generative-ai";
import { SYSTEM_PROMPT } from "../constants";
import { AccessLevel } from "../types";
import { fetchEnemQuestions } from "./databaseService";

// Utilitários de áudio internos (PCM decoding)
function decode(base64: string) {
  const binaryString = atob(base64);
  const len = binaryString.length;
  const bytes = new Uint8Array(len);
  for (let i = 0; i < len; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }
  return bytes;
}

async function decodeAudioData(
  data: Uint8Array,
  ctx: AudioContext,
  sampleRate: number,
  numChannels: number,
): Promise<AudioBuffer> {
  const dataInt16 = new Int16Array(data.buffer);
  const frameCount = dataInt16.length / numChannels;
  const buffer = ctx.createBuffer(numChannels, frameCount, sampleRate);

  for (let channel = 0; channel < numChannels; channel++) {
    const channelData = buffer.getChannelData(channel);
    for (let i = 0; i < frameCount; i++) {
      channelData[i] = dataInt16[i * numChannels + channel] / 32768.0;
    }
  }
  return buffer;
}

const safetySettings = [
  { category: HarmCategory.HARM_CATEGORY_HARASSMENT, threshold: HarmBlockThreshold.BLOCK_ONLY_HIGH },
  { category: HarmCategory.HARM_CATEGORY_HATE_SPEECH, threshold: HarmBlockThreshold.BLOCK_ONLY_HIGH },
  { category: HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT, threshold: HarmBlockThreshold.BLOCK_ONLY_HIGH },
  { category: HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT, threshold: HarmBlockThreshold.BLOCK_ONLY_HIGH },
];

export const generateProfePlanStream = async (
  message: string,
  history: { role: string; parts: { text: string }[] }[],
  mode: string,
  imagePart?: { inlineData: { data: string; mimeType: string } },
  audioPart?: { inlineData: { data: string; mimeType: string } }, // Mantido interface, mas pode não ser usado
  userAccessLevel?: AccessLevel
) => {
  // Inicialização Simples com a Chave de API
  const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();

  if (!apiKey) {
    throw new Error("A chave de API (VITE_GEMINI_API_KEY) não foi encontrada no arquivo .env. Verifique se o arquivo .env existe na raiz do projeto e se a chave está configurada corretamente.");
  }

  const genAI = new GoogleGenerativeAI(apiKey);

  // Configuração da instrução do sistema
  let specificInstruction = `${SYSTEM_PROMPT}\n\n[MODO ATIVO]: ${mode.toUpperCase()}`;

  if (mode === 'quarterly') {
    specificInstruction += `\n\n[DIRETRIZ DE PLANEJAMENTO]: Você está gerando um Planejamento Trimestral.
    
    PROTOCOLO DE ENTREVISTA (OBRIGATÓRIO):
    Antes de gerar a tabela final, verifique se o professor forneceu:
    1. Valor total do trimestre e distribuição de pontos.
    2. Datas ou semanas reservadas para provas.
    
    SE FALTAR ALGUMA DESSA INFORMAÇÕES: Não gere o plano ainda. Responda perguntando amigavelmente sobre esses detalhes para personalizar o cronograma.
    
    SE TIVER AS INFORMAÇÕES: Gere a tabela cruzando Semanas x BNCC x Avaliações.
    
    GATILHO ABP: Se o texto conter "PROJETO", estruture como Aprendizagem Baseada em Projetos (Etapas, Entregas, Rubricas).`;
  } else if (mode === 'enem') {
    specificInstruction += `\n\n[DIRETRIZ ENEM]: Você está atuando como um especialista do INEP. A questão deve ser inédita ou adaptada, seguindo a Matriz de Referência.`;

    try {
      const lastUserMessage = history.find(m => m.role === 'user')?.parts[0].text || message;
      const area = lastUserMessage.toLowerCase().includes('matemática') ? 'Matemática' :
        lastUserMessage.toLowerCase().includes('humana') ? 'Ciências Humanas' :
          lastUserMessage.toLowerCase().includes('linguagen') ? 'Linguagens' :
            lastUserMessage.toLowerCase().includes('natureza') ? 'Ciências da Natureza' : null;

      if (area) {
        // Nota: fetchEnemQuestions deve retornar array de objetos com question_text
        const examples = await fetchEnemQuestions(area, undefined, 2);
        if (examples && examples.length > 0) {
          specificInstruction += `\n\n[EXEMPLOS DE QUESTÕES DO BANCO]:\n${JSON.stringify(examples.map(q => q.question_text))}`;
        }
      }
    } catch (e) {
      console.warn("Falha ao buscar questões ENEM:", e);
    }
  } else if (mode === 'presentations') {
    specificInstruction += `\n\n[DIRETRIZ DE APRESENTAÇÃO]:
    O usuário quer transformar conteúdo em SLIDES.
    ESTRUTURA DE SAÍDA (MARKDOWN):
    Use headers (##) para cada Slide.
    
    Exemplo:
    ## Slide 1: Título 
    - Tópico A
    - Tópico B
    [Imagem Sugerida]: Descrição visual
    
    Gere 8 a 10 slides. Seja sintético e visual.`;
  }
  // A chave nova suporta modelos 2.0+. Configurando para o 2.0 Flash estável.
  const model = genAI.getGenerativeModel({
    model: "gemini-2.0-flash",
    systemInstruction: specificInstruction,
    safetySettings
  });

  // Convertendo histórico para o formato do SDK generative-ai
  // O SDK novo usa { role: 'user' | 'model', parts: [{ text: '...' }] }
  // Verificando compatibilidade: history já está nesse formato

  const chat = model.startChat({
    history: history.map(h => ({
      role: h.role,
      parts: h.parts
    })),
    generationConfig: {
      temperature: 0.8,
    }
  });

  // Montando a mensagem atual
  const currentParts: any[] = [];
  if (message) currentParts.push({ text: message });
  if (imagePart) currentParts.push(imagePart);
  // audioPart ignorado nesta versão simples para garantir estabilidade, ou adaptar se suportado

  try {
    const result = await chat.sendMessageStream(currentParts);

    // Adaptador para garantir compatibilidade com o App.tsx que espera chunk.text
    async function* streamAdapter() {
      for await (const chunk of result.stream) {
        const chunkText = chunk.text();
        yield { text: chunkText };
      }
    }

    return streamAdapter();
  } catch (error: any) {
    console.error("Erro na Chamada do Gemini API:", error);
    throw error;
  }
};

export const generateCanvaData = async (content: string) => {
  const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();
  if (!apiKey) throw new Error("API Key missing");

  const genAI = new GoogleGenerativeAI(apiKey);
  const instruction = `${SYSTEM_PROMPT}`;

  const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash", systemInstruction: instruction, safetySettings });

  const userMessage = `[CANVA_ARCHITECT]
  Analise o conteúdo abaixo e gere a TABELA DE DADOS (CSV) para o Canva:
  
  ${content}`;

  const result = await model.generateContent(userMessage);
  return result.response.text();
};

export const speakPedagogicalText = async (text: string) => {
  console.log("TTS solicitado para:", text);
};
