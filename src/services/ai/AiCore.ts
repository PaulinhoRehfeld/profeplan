import { GoogleGenerativeAI, HarmBlockThreshold, HarmCategory } from "@google/generative-ai";

export const safetySettings = [
    { category: HarmCategory.HARM_CATEGORY_HARASSMENT, threshold: HarmBlockThreshold.BLOCK_ONLY_HIGH },
    { category: HarmCategory.HARM_CATEGORY_HATE_SPEECH, threshold: HarmBlockThreshold.BLOCK_ONLY_HIGH },
    { category: HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT, threshold: HarmBlockThreshold.BLOCK_ONLY_HIGH },
    { category: HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT, threshold: HarmBlockThreshold.BLOCK_ONLY_HIGH },
];

export const GENERATION_MODELS = [
    "gemini-2.0-flash",
    "gemini-2.0-flash-lite-preview-02-05",
    "gemini-flash-latest",
    "gemini-2.0-flash-exp",
];

export function getGenAIClient(): GoogleGenerativeAI {
    const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();

    if (!apiKey) {
        throw new Error("A chave de API (VITE_GEMINI_API_KEY) não foi encontrada no arquivo .env.");
    }

    return new GoogleGenerativeAI(apiKey);
}

export async function executeWithFallback<T>(
    actionName: string,
    operation: (modelName: string) => Promise<T>
): Promise<T> {
    let lastError: any;

    for (const modelName of GENERATION_MODELS) {
        try {
            console.log(`[Gemini] Tentando modelo: ${modelName} para ${actionName}...`);
            return await operation(modelName);
        } catch (error: any) {
            console.warn(`[Gemini] Falha no modelo ${modelName}:`, error.message);
            lastError = error;
        }
    }

    throw new Error(`Todas as tentativas de modelo falharam para ${actionName}. Último erro: ${lastError?.message}`);
}

// Utilitários de áudio internos (PCM decoding)
export function decode(base64: string) {
    const binaryString = atob(base64);
    const len = binaryString.length;
    const bytes = new Uint8Array(len);
    for (let i = 0; i < len; i++) {
        bytes[i] = binaryString.charCodeAt(i);
    }
    return bytes;
}

export async function decodeAudioData(
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
