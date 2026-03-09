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

// ==================== Tool Mocks ====================
// These mock functions return structured data. They will be replaced by real Prisma/Supabase queries later.
const TOOL_MOCKS: Record<string, (args: Record<string, string>) => unknown> = {
    consultarFichaCliente: (args) => ({
        empresa: args.nomeEmpresa || 'N/A',
        status: 'Ativo',
        creditoDisponivel: 'R$ 48.000',
        contratos: 3,
        proximoVencimento: '2025-12-20',
        ultimoContato: '2025-12-10',
        riscoChurn: 'Baixo',
        historicoPagamento: 'Excelente',
    }),
    verResumoDoDia: () => ({
        data: new Date().toLocaleDateString('pt-BR'),
        clientesParaContatar: 10,
        prioridadeMaxima: 'Atenta Engenharia',
        motivoPrioridade: 'Contrato vence em 7 dias e sem retorno há 14 dias',
        reunioesAgendadas: 2,
        faturamentoMes: 'R$ 312.000',
        metaMes: 'R$ 400.000',
        percentualMeta: '78%',
    }),
    verificarRiscosDeChurn: () => ({
        totalEmRisco: 2,
        clientes: [
            {
                empresa: 'Atenta Engenharia',
                risco: 'Alto',
                motivo: 'Sem contato há 14 dias, contrato vence em 7 dias',
                acaoRecomendada: 'Ligar agora e oferecer incentivo de renovação',
            },
            {
                empresa: 'Construtora Horizonte',
                risco: 'Médio',
                motivo: 'Solicitação de redução de frota pendente há 5 dias',
                acaoRecomendada: 'Agendar reunião de alinhamento estratégico',
            },
        ],
    }),
};

const TOOLS_SPEC = [
    {
        type: 'function' as const,
        function: {
            name: 'consultarFichaCliente',
            description:
                'Consulta os dados cadastrais e comerciais de um cliente pelo nome da empresa. Use quando o Gerson perguntar sobre um cliente específico.',
            parameters: {
                type: 'object',
                properties: {
                    nomeEmpresa: {
                        type: 'string',
                        description: 'Nome da empresa a consultar',
                    },
                },
                required: ['nomeEmpresa'],
            },
        },
    },
    {
        type: 'function' as const,
        function: {
            name: 'verResumoDoDia',
            description:
                'Retorna o resumo da agenda do dia, prioridades de contato e métricas de faturamento. Use quando o Gerson perguntar sobre o dia, agenda ou o que deve fazer.',
            parameters: {
                type: 'object',
                properties: {},
                required: [],
            },
        },
    },
    {
        type: 'function' as const,
        function: {
            name: 'verificarRiscosDeChurn',
            description:
                'Lista os clientes com maior risco de cancelamento ou não-renovação. Use quando o Gerson perguntar sobre churns, cancelamentos ou clientes em risco.',
            parameters: {
                type: 'object',
                properties: {},
                required: [],
            },
        },
    },
];

// ==================== Azure Client ====================
function getAzureClient() {
    const endpoint = process.env.AZURE_OPENAI_ENDPOINT;
    const apiKey = process.env.AZURE_OPENAI_API_KEY;
    const deployment = process.env.AZURE_OPENAI_DEPLOYMENT || 'gpt-4o';

    if (!endpoint || !apiKey) {
        throw new Error(
            'Azure OpenAI credentials missing. Set AZURE_OPENAI_ENDPOINT and AZURE_OPENAI_API_KEY.'
        );
    }

    return new AzureOpenAI({
        endpoint,
        apiKey,
        deployment,
        apiVersion: '2024-02-15-preview',
    });
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
        const { messages, systemPrompt, toolResults } = req.body as RequestBody;

        const client = getAzureClient();
        const deployment = process.env.AZURE_OPENAI_DEPLOYMENT || 'gpt-4o';

        // Build message array
        const apiMessages: Array<{
            role: 'system' | 'user' | 'assistant' | 'tool';
            content: string;
            name?: string;
            tool_call_id?: string;
        }> = [];

        if (systemPrompt) {
            apiMessages.push({ role: 'system', content: systemPrompt });
        }

        for (const msg of messages || []) {
            apiMessages.push({ role: msg.role, content: msg.content });
        }

        // If tool results provided, append them as tool messages
        if (toolResults && toolResults.length > 0) {
            for (const tr of toolResults) {
                apiMessages.push({
                    role: 'tool',
                    content: tr.content,
                    name: tr.name,
                    tool_call_id: `call_${tr.name}`,
                });
            }

            // Final completion after tools
            const finalCompletion = await client.chat.completions.create({
                model: deployment,
                messages: apiMessages as any,
                temperature: 0.6,
                max_tokens: 300,
            });

            const text = finalCompletion.choices[0]?.message?.content || '';
            return res.status(200).json({ text });
        }

        // First pass — may trigger tool calls
        const completion = await client.chat.completions.create({
            model: deployment,
            messages: apiMessages as any,
            tools: TOOLS_SPEC as any,
            tool_choice: 'auto',
            temperature: 0.6,
            max_tokens: 500,
        });

        const choice = completion.choices[0];
        const toolCalls = choice?.message?.tool_calls;

        // If the model wants to call tools, return them to the frontend
        if (toolCalls && toolCalls.length > 0) {
            const calls = toolCalls.map((tc) => ({
                id: tc.id,
                name: tc.function.name,
                arguments: JSON.parse(tc.function.arguments || '{}'),
            }));

            // Execute mocks server-side and return final text immediately
            const toolResultsForFinal: Array<{
                role: 'tool';
                content: string;
                name: string;
                tool_call_id: string;
            }> = [];

            for (const call of calls) {
                const mockFn = TOOL_MOCKS[call.name];
                const result = mockFn ? mockFn(call.arguments) : { error: 'Unknown tool' };
                toolResultsForFinal.push({
                    role: 'tool',
                    content: JSON.stringify(result),
                    name: call.name,
                    tool_call_id: call.id,
                });
            }

            // Append assistant's tool call message + tool results and get final text
            const messagesWithTools = [
                ...apiMessages,
                { ...choice.message } as any,
                ...toolResultsForFinal,
            ];

            const finalCompletion = await client.chat.completions.create({
                model: deployment,
                messages: messagesWithTools,
                temperature: 0.6,
                max_tokens: 300,
            });

            const finalText = finalCompletion.choices[0]?.message?.content || '';
            return res.status(200).json({ text: finalText, toolCalls: calls });
        }

        // Direct text response
        const text = choice?.message?.content || '';
        return res.status(200).json({ text });
    } catch (err: unknown) {
        const msg = err instanceof Error ? err.message : 'Internal error';
        console.error('[FREEDAY API]', msg);
        return res.status(500).json({ error: msg });
    }
}
