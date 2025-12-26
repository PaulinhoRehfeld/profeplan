
import { GoogleGenAI, HarmBlockThreshold, HarmCategory, Modality } from "@google/genai";
import { SYSTEM_PROMPT } from "../constants";
import { AccessLevel } from "../types"; // Importar AccessLevel

// Utilitários de áudio internos (PCM decoding)
// Manual implementation following the coding guidelines for audio processing.
function decode(base64: string) {
  const binaryString = atob(base64);
  const len = binaryString.length;
  const bytes = new Uint8Array(len);
  for (let i = 0; i < len; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }
  return bytes;
}

// Manual implementation of raw PCM audio decoding as required by the Gemini API documentation.
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
  audioPart?: { inlineData: { data: string; mimeType: string } },
  userAccessLevel?: AccessLevel // Novo parâmetro para o nível de acesso
) => {
  // Creating GoogleGenAI instance right before making an API call to ensure it uses the most up-to-date API key.
  const ai = new GoogleGenAI({ apiKey: process.env.API_KEY });
  
  const specificInstruction = `${SYSTEM_PROMPT}\n\n[MODO ATIVO]: ${mode.toUpperCase()}`;

  const contents = [...history];
  const currentParts: any[] = [];
  
  if (message) {
    currentParts.push({ text: message });
  }
  
  if (imagePart) {
    currentParts.push(imagePart);
  }
  
  if (audioPart) {
    currentParts.push(audioPart);
  }

  // Fallback se não houver conteúdo nenhum (embora improvável com o UI)
  if (currentParts.length === 0) {
    currentParts.push({ text: "Olá" });
  }

  contents.push({ role: 'user', parts: currentParts });

  let modelName: string;
  let thinkingBudget: number;

  // Seleção do modelo e budget baseado no nível de acesso
  if (userAccessLevel === 'ADMIN') {
    modelName = 'gemini-3-pro-preview';
    thinkingBudget = 32768; // Max thinking budget for gemini-3-pro-preview
  } else { // BASICO or PRO
    modelName = 'gemini-3-flash-preview';
    thinkingBudget = 24576; // Max thinking budget for gemini-3-flash-preview
  }

  try {
    return await ai.models.generateContentStream({
      model: modelName, // Modelo dinâmico
      contents: contents,
      config: {
        systemInstruction: specificInstruction,
        temperature: 0.8,
        thinkingConfig: { thinkingBudget: thinkingBudget }, // Thinking budget dinâmico
        safetySettings,
      },
    });
  } catch (error: any) {
    console.error("Erro na Chamada do Gemini API:", error);
    throw error;
  }
};

export const speakPedagogicalText = async (text: string) => {
  // Creating GoogleGenAI instance right before making an API call for real-time key synchronization.
  const ai = new GoogleGenAI({ apiKey: process.env.API_KEY });
  try {
    const response = await ai.models.generateContent({
      model: "gemini-2.5-flash-preview-tts",
      contents: [{ parts: [{ text: `Como um professor experiente e acolhedor: ${text.substring(0, 500)}` }] }],
      config: {
        responseModalities: [Modality.AUDIO],
        speechConfig: {
          voiceConfig: { prebuiltVoiceConfig: { voiceName: 'Kore' } },
        },
      },
    });

    const base64Audio = response.candidates?.[0]?.content?.parts?.[0]?.inlineData?.data;
    if (base64Audio) {
      const audioContext = new (window.AudioContext || (window as any).webkitAudioContext)({ sampleRate: 24000 });
      const audioBuffer = await decodeAudioData(decode(base64Audio), audioContext, 24000, 1);
      const source = audioContext.createBufferSource();
      source.buffer = audioBuffer;
      source.connect(audioContext.destination);
      source.start();
    }
  } catch (error) {
    console.error("Erro TTS:", error);
  }
};