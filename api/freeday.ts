import type { VercelRequest, VercelResponse } from '@vercel/node';
import { AzureOpenAI } from 'openai';

// ==================== Types ====================
interface ChatMessage {
    role: 'user' | 'assistant' | 'system';
    content: string;
}

interface ToolResult {
    role: 'tool';
    name: string;
    content: string;
}

interface RequestBody {
    messages: ChatMessage[];
    systemPrompt?: string;
    toolResults?: ToolResult[];
}

// ==================== System prompt padrão (PROFEPLAN – apoio ao professor) ====================
const DEFAULT_SYSTEM_PROMPT = `Você é a FREEDAY, a assistente de Inteligência Artificial do PROFEPLAN, focada em apoiar o professor no dia a dia.

Sua missão: Ajudar o professor com dúvidas e dificuldades pedagógicas, de planejamento, gestão de turmas e uso da plataforma.

Regras de ouro:
1. Seja direta e acolhedora. Respostas curtas e claras (no máximo 3–4 frases quando for por voz), em português do Brasil.
2. Não use Markdown, listas longas ou títulos; fale em texto corrido próprio para ser lido em voz alta quando aplicável.
3. Foque em: planejamento de aulas, BNCC, avaliações, inclusão (PDI), dicas de organização e uso do PROFEPLAN.
4. Se não souber algo específico da escola do professor, oriente de forma genérica e sugira onde ele pode conferir na plataforma.
5. Tom: profissional, paciente e encorajador.`;

// ==================== Azure Client (chat) ====================
function getAzureClient() {
    // Suporta tanto AZURE_OPENAI_* quanto VITE_AZURE_OPENAI_* (Vercel)
    const endpoint = process.env.AZURE_OPENAI_ENDPOINT || process.env.VITE_AZURE_OPENAI_ENDPOINT;
    const apiKey = process.env.AZURE_OPENAI_API_KEY || process.env.VITE_AZURE_OPENAI_API_KEY;
    const deployment = process.env.AZURE_OPENAI_DEPLOYMENT || process.env.VITE_AZURE_OPENAI_DEPLOYMENT || 'gpt-4o';

    if (!endpoint || !apiKey) return null;

    return new AzureOpenAI({
        endpoint,
        apiKey,
        deployment,
        apiVersion: '2024-02-15-preview',
    });
}

// ==================== OpenAI Direct Client (fallback) ====================
async function chatWithOpenAI(
    messages: Array<{ role: 'system' | 'user' | 'assistant'; content: string }>
): Promise<string> {
    const key = process.env.OPENAI_API_KEY?.trim();
    if (!key) throw new Error('No AI provider configured. Set AZURE_OPENAI_ENDPOINT + AZURE_OPENAI_API_KEY or OPENAI_API_KEY.');
    const { default: OpenAI } = await import('openai');
    const client = new OpenAI({ apiKey: key });
    const completion = await client.chat.completions.create({
        model: process.env.OPENAI_MODEL || 'gpt-4o',
        messages,
        temperature: 0.6,
        max_tokens: 500,
    });
    return completion.choices[0]?.message?.content?.trim() || '';
}

// ==================== TTS Helpers (Azure TTS + OpenAI fallback) ====================
async function ttsWithOpenAI(text: string): Promise<string | undefined> {
    const key = process.env.OPENAI_API_KEY?.trim();
    if (!key) return undefined;
    try {
        const { default: OpenAI } = await import('openai');
        const client = new OpenAI({ apiKey: key });
        const speech = await client.audio.speech.create({
            model: 'tts-1',
            voice: 'alloy',
            input: text,
        });
        return Buffer.from(await speech.arrayBuffer()).toString('base64');
    } catch {
        return undefined;
    }
}

async function gerarAudioTTS(
    texto: string
): Promise<{ audioBase64?: string; error?: string }> {
    const ttsEndpoint = process.env.AZURE_OPENAI_TTS_ENDPOINT?.trim();
    const mainEndpoint = process.env.AZURE_OPENAI_ENDPOINT?.trim();
    const baseUrl = (ttsEndpoint || mainEndpoint)?.replace(/\/$/, '');
    const ttsKey = process.env.AZURE_OPENAI_TTS_API_KEY?.trim();
    const mainKey = process.env.AZURE_OPENAI_API_KEY?.trim();
    const azureKey = ttsKey || mainKey;
    const ttsDeployment =
        process.env.AZURE_OPENAI_TTS_DEPLOYMENT?.trim() || 'tts';
    const isCognitiveServices =
        baseUrl && baseUrl.includes('cognitiveservices.azure.com');
    const apiVersion = isCognitiveServices
        ? '2025-03-01-preview'
        : '2025-04-01-preview';

    if (baseUrl && azureKey) {
        try {
            const ttsUrl = `${baseUrl}/openai/deployments/${ttsDeployment}/audio/speech?api-version=${apiVersion}`;
            const headers: Record<string, string> = {
                'Content-Type': 'application/json',
                ...(isCognitiveServices
                    ? { Authorization: `Bearer ${azureKey}` }
                    : { 'api-key': azureKey }),
            };
            const body: Record<string, unknown> = {
                input: texto,
                voice: 'alloy',
                ...(isCognitiveServices
                    ? { model: ttsDeployment }
                    : { response_format: 'mp3' }),
            };
            const ttsRes = await fetch(ttsUrl, {
                method: 'POST',
                headers,
                body: JSON.stringify(body),
            });

            if (ttsRes.ok) {
                const arrayBuffer = await ttsRes.arrayBuffer();
                return {
                    audioBase64: Buffer.from(arrayBuffer).toString('base64'),
                };
            }
            const errText = await ttsRes.text();
            const errMsg = `Azure TTS ${ttsRes.status}: ${errText.slice(
                0,
                120
            )}`;
            const fallback = await ttsWithOpenAI(texto);
            if (fallback) return { audioBase64: fallback };
            return { error: errMsg };
        } catch (e) {
            const fallback = await ttsWithOpenAI(texto);
            if (fallback) return { audioBase64: fallback };
            return { error: (e as Error).message };
        }
    }

    const fallback = await ttsWithOpenAI(texto);
    if (fallback) return { audioBase64: fallback };
    return {
        error:
            'Configure AZURE_OPENAI_TTS_ENDPOINT + AZURE_OPENAI_TTS_API_KEY + AZURE_OPENAI_TTS_DEPLOYMENT, ou OPENAI_API_KEY.',
    };
}

// ==================== Handler ====================
export default async function handler(req: VercelRequest, res: VercelResponse) {
    if (req.method === 'OPTIONS') {
        res.setHeader('Access-Control-Allow-Origin', '*');
        res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
        res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
        return res.status(200).end();
    }

    if (req.method !== 'POST') {
        return res.status(405).json({ error: 'Method Not Allowed' });
    }

    try {
        const { messages, systemPrompt } = req.body as RequestBody;

        const apiMessages: Array<{ role: 'system' | 'user' | 'assistant'; content: string }> = [];

        apiMessages.push({
            role: 'system',
            content: systemPrompt?.trim() || DEFAULT_SYSTEM_PROMPT,
        });

        for (const msg of messages || []) {
            if (msg.role && msg.content) {
                apiMessages.push({ role: msg.role, content: msg.content });
            }
        }

        let text: string;

        const azureClient = getAzureClient();
        if (azureClient) {
            // Azure OpenAI (primary)
            const deployment = process.env.AZURE_OPENAI_DEPLOYMENT || 'gpt-4o';
            const completion = await azureClient.chat.completions.create({
                model: deployment,
                messages: apiMessages as any,
                temperature: 0.6,
                max_tokens: 500,
            });
            text = completion.choices[0]?.message?.content?.trim() || '';
        } else {
            // OpenAI direct (fallback)
            text = await chatWithOpenAI(apiMessages);
        }

        // Gera áudio com TTS (Azure ou OpenAI) usando a mesma resposta
        const tts = await gerarAudioTTS(text);

        return res.status(200).json({
            text,
            audioBase64: tts.audioBase64 ?? null,
            error: tts.error ?? undefined,
        });
    } catch (err: unknown) {
        const msg = err instanceof Error ? err.message : 'Internal error';
        console.error('[FREEDAY API]', msg);
        return res.status(500).json({ error: msg });
    }
}
