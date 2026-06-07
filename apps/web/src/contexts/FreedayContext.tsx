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
    openWithPrompt: (text: string) => void;
}

const FreedayContext = createContext<FreedayContextValue | null>(null);

export function useFreedayContext(): FreedayContextValue {
    const ctx = useContext(FreedayContext);
    if (!ctx) {
        throw new Error('useFreedayContext must be used within a FreedayProvider');
    }
    return ctx;
}

const FREEDAY_SYSTEM_PROMPT = `Você é a FREEDAY, a assistente de Inteligência Artificial do PROFEPLAN, focada em apoiar o professor no dia a dia.

Sua missão: Ajudar o professor com dúvidas e dificuldades pedagógicas, de planejamento, gestão de turmas e uso da plataforma.

Regras de ouro:
1. Seja direta e acolhedora. Respostas curtas e claras (no máximo 3–4 frases quando for por voz), em português do Brasil.
2. Não use Markdown, listas longas ou títulos; fale em texto corrido próprio para ser lido em voz alta quando aplicável.
3. Foque em: planejamento de aulas, BNCC, avaliações, inclusão (PDI), dicas de organização e uso do PROFEPLAN.
4. Se não souber algo específico da escola do professor, oriente de forma genérica e sugira onde ele pode conferir na plataforma.
5. Tom: profissional, paciente e encorajador.`;

export function FreedayProvider({ children }: { children: React.ReactNode }) {
    const [state, setState] = useState<FreedayState>('idle');
    const [messages, setMessages] = useState<FreedayMessage[]>([]);
    const [isSupported] = useState(() => {
        return 'SpeechRecognition' in window || 'webkitSpeechRecognition' in window;
    });

    const recognitionRef = useRef<SpeechRecognition | null>(null);
    const synthRef = useRef<SpeechSynthesis>(window.speechSynthesis);
    const isListeningRef = useRef(false);

    const speakBrowser = useCallback((text: string) => {
        if (!text) return;
        synthRef.current.cancel();
        setState('speaking');

        const utterance = new SpeechSynthesisUtterance(text);
        utterance.lang = 'pt-BR';
        utterance.rate = 1.05;
        utterance.pitch = 1.0;

        const voices = synthRef.current.getVoices();
        const ptBrVoice = voices.find(
            (v) => v.lang === 'pt-BR' || v.lang.startsWith('pt')
        );
        if (ptBrVoice) utterance.voice = ptBrVoice;

        utterance.onend = () => setState('idle');
        utterance.onerror = () => setState('idle');

        synthRef.current.speak(utterance);
    }, []);

    const playAudioFromBackend = useCallback(async (audioBase64?: string) => {
        if (!audioBase64) return;
        try {
            const url = `data:audio/mpeg;base64,${audioBase64}`;
            const audio = new Audio(url);
            setState('speaking');
            await new Promise<void>((resolve) => {
                audio.onended = () => {
                    setState('idle');
                    resolve();
                };
                audio.onerror = () => {
                    setState('idle');
                    resolve();
                };
                audio.play().catch(() => {
                    setState('idle');
                    resolve();
                });
            });
        } catch {
            setState('idle');
        }
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

                const base = (import.meta as any).env?.VITE_FREEDAY_API_BASE || '';
                const trimmedBase = typeof base === 'string' ? base.replace(/\/+$/, '') : '';
                const url = trimmedBase ? `${trimmedBase}/api/freeday` : '/api/freeday';

                const response = await fetch(url, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ messages: history, systemPrompt: FREEDAY_SYSTEM_PROMPT }),
                });

                if (!response.ok) {
                    throw new Error(`API error: ${response.status}`);
                }

                const data = await response.json();
                const assistantText = data.text || data.content || '';

                const assistantMsg: FreedayMessage = {
                    role: 'assistant',
                    content: assistantText,
                    timestamp: new Date(),
                };
                setMessages((prev) => [...prev, assistantMsg]);

                if (data.audioBase64) {
                    await playAudioFromBackend(data.audioBase64);
                } else {
                    // Fallback para voz do navegador se backend não devolver áudio
                    speakBrowser(assistantText);
                }
            } catch (err) {
                console.error('[FREEDAY] API error:', err);
                const errorMsg =
                    'Tive um problema de conexão ou de voz. Tente novamente em um momento.';
                setMessages((prev) => [
                    ...prev,
                    { role: 'assistant', content: errorMsg, timestamp: new Date() },
                ]);
                speakBrowser(errorMsg);
            }
        },
        [messages, speakBrowser, playAudioFromBackend]
    );

    const startListening = useCallback(() => {
        if (isListeningRef.current || state === 'speaking') return;

        const SpeechRecognitionAPI = (window as any).SpeechRecognition || (window as any).webkitSpeechRecognition;
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

    const openWithPrompt = useCallback((text: string) => {
        if (typeof window === 'undefined') return;
        const detail = { prompt: text || '' };
        window.dispatchEvent(new CustomEvent('freeday:open', { detail }));
    }, []);

    // Load voices when available (para fallback com SpeechSynthesis)
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
                openWithPrompt,
            }}
        >
            {children}
        </FreedayContext.Provider>
    );
}
