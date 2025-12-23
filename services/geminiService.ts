
import { GoogleGenAI, HarmBlockThreshold, HarmCategory, Modality } from "@google/genai";
import { SYSTEM_PROMPT } from "../constants";

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
  imagePart?: { inlineData: { data: string; mimeType: string } }
) => {
  // A chave API é injetada via environment variable process.env.API_KEY
  const ai = new GoogleGenAI({ apiKey: process.env.API_KEY });
  
  const specificInstruction = `${SYSTEM_PROMPT}\n\n[MODO ATIVO]: ${mode.toUpperCase()}`;

  const contents = [...history];
  const currentParts: any[] = [{ text: message }];
  if (imagePart) {
    currentParts.push(imagePart);
  }
  contents.push({ role: 'user', parts: currentParts });

  try {
    // Utilizando Gemini 3 Flash para máxima velocidade e suporte ao Thinking Mode
    return await ai.models.generateContentStream({
      model: 'gemini-3-flash-preview',
      contents: contents,
      config: {
        systemInstruction: specificInstruction,
        temperature: 0.8,
        thinkingConfig: { thinkingBudget: 24576 },
        safetySettings,
      },
    });
  } catch (error: any) {
    console.error("Erro na Chamada do Gemini API:", error);
    throw error;
  }
};

export const speakPedagogicalText = async (text: string) => {
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
