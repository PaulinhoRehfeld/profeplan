export const maxDuration = 60;
import type { VercelRequest, VercelResponse } from '@vercel/node';
import OpenAI from 'openai';

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

function getOpenAIClient() {
    const key = process.env.OPENAI_API_KEY?.trim() || process.env.VITE_OPENAI_API_KEY?.trim();
    if (!key) return null;
    return new OpenAI({ apiKey: key });
}

async function gerarAudioTTS(
    texto: string,
    client: OpenAI
): Promise<{ audioBase64?: string; error?: string }> {
    try {
        const speech = await client.audio.speech.create({
            model: 'tts-1',
            voice: 'alloy',
            input: texto,
        });
        return { audioBase64: Buffer.from(await speech.arrayBuffer()).toString('base64') };
    } catch (e) {
        return { error: (e as Error).message };
    }
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

        const client = getOpenAIClient();
        if (!client) {
            return res.status(500).json({ error: 'Configure OPENAI_API_KEY nas variáveis de ambiente.' });
        }

        const model = process.env.OPENAI_MODEL || 'gpt-4o';
        const completion = await client.chat.completions.create({
            model: model,
            messages: apiMessages as any,
            temperature: 0.6,
            max_tokens: 500,
        });
        
        const text = completion.choices[0]?.message?.content?.trim() || '';

        // Gera áudio com TTS usando a mesma resposta
        const tts = await gerarAudioTTS(text, client);

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
