import { AzureOpenAI } from "openai";

// Mantém a exportação para compatibilidade, embora não seja mais usada diretamente com Azure.
export const safetySettings: unknown[] = [];

const getEnvVar = (browserKey: string, nodeKey: string): string | undefined => {
    const browserValue = typeof import.meta !== "undefined" && (import.meta as any).env && (import.meta as any).env[browserKey];
    const nodeValue = typeof process !== "undefined" ? (process.env as Record<string, string | undefined>)[nodeKey] : undefined;
    return (browserValue ?? nodeValue)?.toString().trim() || undefined;
};

const endpoint = getEnvVar("VITE_AZURE_OPENAI_ENDPOINT", "VITE_AZURE_OPENAI_ENDPOINT");
const apiKey = getEnvVar("VITE_AZURE_OPENAI_API_KEY", "VITE_AZURE_OPENAI_API_KEY");
const deployment = getEnvVar("VITE_AZURE_OPENAI_DEPLOYMENT", "VITE_AZURE_OPENAI_DEPLOYMENT");

if (!endpoint || !apiKey || !deployment) {
    throw new Error("Configuração Azure OpenAI ausente. Verifique VITE_AZURE_OPENAI_ENDPOINT, VITE_AZURE_OPENAI_API_KEY e VITE_AZURE_OPENAI_DEPLOYMENT no .env.");
}

export const GENERATION_MODELS = [
    deployment,
];

const client = new AzureOpenAI({
    endpoint,
    apiKey,
    deployment,
    apiVersion: "2024-02-15-preview",
    // Permitido temporariamente no PWA
    dangerouslyAllowBrowser: true,
});

const getErrorMessage = (error: unknown): string =>
    error instanceof Error ? error.message : "Unknown error";

// Mantém o nome público para não quebrar os serviços existentes.
export function getGenAIClient(): AzureOpenAI {
    return client;
}

export async function executeWithFallback<T>(
    actionName: string,
    operation: (modelName: string) => Promise<T>
): Promise<T> {
    let lastError: unknown;

    for (const modelName of GENERATION_MODELS) {
        try {
            console.log(`[AzureOpenAI] Tentando deployment/model: ${modelName} para ${actionName}...`);
            return await operation(modelName);
        } catch (error: unknown) {
            console.warn(`[AzureOpenAI] Falha no deployment/model ${modelName}:`, getErrorMessage(error));
            lastError = error;
        }
    }

    throw new Error(`Todas as tentativas de deployment/model falharam para ${actionName}. Último erro: ${getErrorMessage(lastError)}`);
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
