// Mantém a exportação para compatibilidade.
export const safetySettings: unknown[] = [];

export const GENERATION_MODELS = [
    "backend-ai-proxy",
];

type ChatMessage = { role: "system" | "user" | "assistant"; content: string };

type CompletionRequest = {
    model?: string;
    messages: ChatMessage[];
    temperature?: number;
    max_tokens?: number;
};

type CompletionResponse = {
    choices: Array<{
        message: {
            content: string;
        };
    }>;
};

const callAiBackend = async (payload: CompletionRequest): Promise<CompletionResponse> => {
    const response = await fetch("/api/ai", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
    });

    const data = await response.json().catch(() => ({}));
    if (!response.ok) {
        throw new Error(data?.error || `Falha no proxy de IA (HTTP ${response.status})`);
    }

    const text = typeof data?.text === "string" ? data.text : "";
    return {
        choices: [
            {
                message: {
                    content: text,
                },
            },
        ],
    };
};

const client = {
    chat: {
        completions: {
            create: async (payload: CompletionRequest) => callAiBackend(payload),
        },
    },
};

const getErrorMessage = (error: unknown): string =>
    error instanceof Error ? error.message : "Unknown error";

// Mantém o nome público para não quebrar os serviços existentes.
export function getGenAIClient(): typeof client {
    return client;
}

/**
 * Helper para completions simples (prompt → resposta).
 * Usa a API nativa da OpenAI configurada.
 */
export async function createSimpleCompletion(
    prompt: string,
    systemInstruction?: string,
    temperature: number = 0.7
): Promise<string> {
    const messages: Array<{ role: "system" | "user" | "assistant"; content: string }> = [];
    if (systemInstruction) {
        messages.push({ role: "system", content: systemInstruction });
    }
    messages.push({ role: "user", content: prompt });

    const completion = await client.chat.completions.create({
        model: "backend-ai-proxy",
        messages,
        temperature,
    } as any);

    const content = completion.choices[0]?.message?.content;
    return typeof content === "string" ? content : (content as { text?: string }[] | undefined)?.map((c) => c?.text ?? "").join("") ?? "";
}

/**
 * Helper para chat com histórico (multi-turn).
 * Usa a API nativa da OpenAI configurada.
 */
export async function createChatCompletion(
    userMessage: string,
    history: Array<{ role: string; content: string }> = [],
    systemInstruction?: string,
    temperature: number = 0.7
): Promise<string> {
    const messages: Array<{ role: "system" | "user" | "assistant"; content: string }> = [];
    if (systemInstruction) {
        messages.push({ role: "system", content: systemInstruction });
    }
    for (const h of history) {
        const role = h.role === "user" ? "user" : h.role === "assistant" ? "assistant" : "user";
        messages.push({ role, content: h.content || "" });
    }
    messages.push({ role: "user", content: userMessage });

    const completion = await client.chat.completions.create({
        model: "backend-ai-proxy",
        messages,
        temperature,
    } as any);

    const content = completion.choices[0]?.message?.content;
    return typeof content === "string" ? content : (content as { text?: string }[] | undefined)?.map((c) => c?.text ?? "").join("") ?? "";
}

export async function executeWithFallback<T>(
    actionName: string,
    operation: (modelName: string) => Promise<T>
): Promise<T> {
    let lastError: unknown;

    for (const modelName of GENERATION_MODELS) {
        try {
            console.log(`[OpenAI] Tentando deployment/model: ${modelName} para ${actionName}...`);
            return await operation(modelName);
        } catch (error: unknown) {
            console.warn(`[OpenAI] Falha no deployment/model ${modelName}:`, getErrorMessage(error));
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
