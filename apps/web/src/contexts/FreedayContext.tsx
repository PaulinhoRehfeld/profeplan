import React, {
    createContext,
    useCallback,
    useContext,
    useEffect,
    useRef,
    useState,
} from 'react';

export type FreedayState = 'idle' | 'listening' | 'thinking' | 'speaking';

export interface FreedayMessage {
    role: 'user' | 'assistant';
    content: string;
    timestamp: Date;
}

interface FreedayContextValue {
    state: FreedayState;
    messages: FreedayMessage[];
    isSupported: boolean;
    startListening: () => void;
    stopListening: () => void;
    sendTextMessage: (text: string) => Promise<void>;
    clearMessages: () => void;
}

const FreedayContext = createContext<FreedayContextValue | null>(null);

export function useFreedayContext(): FreedayContextValue {
    const ctx = useContext(FreedayContext);
    if (!ctx) {
        throw new Error('useFreedayContext must be used within a FreedayProvider');
    }
    return ctx;
}

const FREEDAY_SYSTEM_PROMPT = `Você é a FREEDAY, a assistente de Inteligência Artificial de Alta Performance exclusiva do Gerson (Executivo de Vendas B2B de Locação e Gestão de Frotas).

Sua missão: Reduzir a carga mental do Gerson, analisar dados do CRM (FLUX_CRM) em tempo real e entregar insights acionáveis por áudio.

Suas Regras de Ouro:
1. Seja Direta e Focada: Suas respostas serão lidas por um sintetizador de voz (TTS) enquanto o Gerson dirige. NUNCA use formatação markdown. Fale de forma fluida e conversacional.
2. Vá Direto ao Ponto: Não diga "Olá Gerson, como posso ajudar?". Vá direto para a resposta.
3. Não Leia Listas Longas: Resuma e ofereça detalhamento se necessário.
4. Use as Ferramentas: Sempre que perguntarem sobre cliente, faturamento, ou limites, ative as funções disponíveis. Nunca invente dados.
5. Tom: Profissional, analítica, proativa e levemente confiante.`;

// MOCK tool execution (will be wired to real DB later)
function executeTool(name: string, args: Record<string, string>): string {
    if (name === 'consultarFichaCliente') {
        return JSON.stringify({
            empresa: args.nomeEmpresa || 'Exemplo Representações',
            status: 'Ativo',
            creditoDisponivel: 'R$ 48.000',
            contratos: 3,
            ultimoContato: '2025-12-10',
            riscoChurn: 'Baixo',
        });
    }
    if (name === 'verResumoDoDia') {
        return JSON.stringify({
            clientesParaContatar: 10,
            prioridadeMaxima: 'Atenta Engenharia',
            motivoPrioridade: 'Contrato vence em 7 dias e sem retorno há 14 dias',
            reunioesHoje: 2,
            faturamentoMes: 'R$ 312.000',
        });
    }
    if (name === 'verificarRiscosDeChurn') {
        return JSON.stringify({
            clientesEmRisco: [
                { empresa: 'Atenta Engenharia', risco: 'Alto', motivo: 'Sem contato há 14 dias, contrato vence em 7 dias' },
                { empresa: 'Construtora Horizonte', risco: 'Médio', motivo: 'Solicitação de redução de frota pendente' },
            ],
        });
    }
    return JSON.stringify({ erro: 'Ferramenta desconhecida' });
}

const TOOLS_SPEC = [
    {
        type: 'function',
        function: {
            name: 'consultarFichaCliente',
            description: 'Consulta os dados de um cliente pelo nome da empresa',
            parameters: {
                type: 'object',
                properties: {
                    nomeEmpresa: { type: 'string', description: 'Nome da empresa' },
                },
                required: ['nomeEmpresa'],
            },
        },
    },
    {
        type: 'function',
        function: {
            name: 'verResumoDoDia',
            description: 'Retorna o resumo da agenda e prioridades do dia',
            parameters: { type: 'object', properties: {} },
        },
    },
    {
        type: 'function',
        function: {
            name: 'verificarRiscosDeChurn',
            description: 'Lista os clientes com risco de churn',
            parameters: { type: 'object', properties: {} },
        },
    },
];

export function FreedayProvider({ children }: { children: React.ReactNode }) {
    const [state, setState] = useState<FreedayState>('idle');
    const [messages, setMessages] = useState<FreedayMessage[]>([]);
    const [isSupported] = useState(() => {
        return 'SpeechRecognition' in window || 'webkitSpeechRecognition' in window;
    });

    const recognitionRef = useRef<SpeechRecognition | null>(null);
    const synthRef = useRef<SpeechSynthesis>(window.speechSynthesis);
    const isListeningRef = useRef(false);

    const speak = useCallback((text: string) => {
        if (!text) return;
        synthRef.current.cancel();
        setState('speaking');

        const utterance = new SpeechSynthesisUtterance(text);
        utterance.lang = 'pt-BR';
        utterance.rate = 1.05;
        utterance.pitch = 1.0;

        // Try to find a pt-BR voice
        const voices = synthRef.current.getVoices();
        const ptBrVoice = voices.find(
            (v) => v.lang === 'pt-BR' || v.lang.startsWith('pt')
        );
        if (ptBrVoice) utterance.voice = ptBrVoice;

        utterance.onend = () => setState('idle');
        utterance.onerror = () => setState('idle');

        synthRef.current.speak(utterance);
    }, []);

    const sendTextMessage = useCallback(
        async (userText: string) => {
            if (!userText.trim()) return;

            const userMsg: FreedayMessage = {
                role: 'user',
                content: userText,
                timestamp: new Date(),
            };
            setMessages((prev) => [...prev, userMsg]);
            setState('thinking');

            try {
                const history = [...messages, userMsg].map((m) => ({
                    role: m.role,
                    content: m.content,
                }));

                const response = await fetch('/api/freeday', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ messages: history, systemPrompt: FREEDAY_SYSTEM_PROMPT }),
                });

                if (!response.ok) {
                    throw new Error(`API error: ${response.status}`);
                }

                const data = await response.json();
                let assistantText = data.text || data.content || '';
                let toolCalls = data.toolCalls || [];

                // Handle tool calls
                if (toolCalls.length > 0) {
                    const toolResults: Array<{ role: 'tool'; name: string; content: string }> = [];
                    for (const call of toolCalls) {
                        const result = executeTool(call.name, call.arguments || {});
                        toolResults.push({ role: 'tool', name: call.name, content: result });
                    }

                    // Send tool results back for final answer
                    const followupResponse = await fetch('/api/freeday', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({
                            messages: history,
                            systemPrompt: FREEDAY_SYSTEM_PROMPT,
                            toolResults,
                        }),
                    });
                    const followupData = await followupResponse.json();
                    assistantText = followupData.text || followupData.content || '';
                }

                const assistantMsg: FreedayMessage = {
                    role: 'assistant',
                    content: assistantText,
                    timestamp: new Date(),
                };
                setMessages((prev) => [...prev, assistantMsg]);
                speak(assistantText);
            } catch (err) {
                console.error('[FREEDAY] API error:', err);
                const errorMsg = 'Gerson, tive um problema de conexão. Tente novamente em um momento.';
                setMessages((prev) => [
                    ...prev,
                    { role: 'assistant', content: errorMsg, timestamp: new Date() },
                ]);
                speak(errorMsg);
            }
        },
        [messages, speak]
    );

    const startListening = useCallback(() => {
        if (isListeningRef.current || state === 'speaking') return;

        const SpeechRecognitionAPI =
            window.SpeechRecognition || (window as any).webkitSpeechRecognition;
        if (!SpeechRecognitionAPI) return;

        if (recognitionRef.current) {
            recognitionRef.current.abort();
        }

        const recognition = new SpeechRecognitionAPI();
        recognition.lang = 'pt-BR';
        recognition.interimResults = false;
        recognition.maxAlternatives = 1;
        recognitionRef.current = recognition;
        isListeningRef.current = true;
        setState('listening');

        recognition.onresult = (event: SpeechRecognitionEvent) => {
            const transcript = event.results[0]?.[0]?.transcript;
            if (transcript) {
                sendTextMessage(transcript);
            }
        };

        recognition.onerror = () => {
            isListeningRef.current = false;
            setState('idle');
        };

        recognition.onend = () => {
            isListeningRef.current = false;
            if (state === 'listening') setState('idle');
        };

        recognition.start();
    }, [state, sendTextMessage]);

    const stopListening = useCallback(() => {
        recognitionRef.current?.stop();
        isListeningRef.current = false;
        setState('idle');
    }, []);

    const clearMessages = useCallback(() => {
        setMessages([]);
    }, []);

    // Load voices when available
    useEffect(() => {
        const loadVoices = () => synthRef.current.getVoices();
        loadVoices();
        synthRef.current.addEventListener('voiceschanged', loadVoices);
        return () => synthRef.current.removeEventListener('voiceschanged', loadVoices);
    }, []);

    return (
        <FreedayContext.Provider
            value={{
                state,
                messages,
                isSupported,
                startListening,
                stopListening,
                sendTextMessage,
                clearMessages,
            }}
        >
            {children}
        </FreedayContext.Provider>
    );
}
