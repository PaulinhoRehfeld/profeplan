
import { supabase } from "./supabaseClient";

interface DiagnosticResult {
    service: 'Supabase' | 'EnvVars' | 'GeminiAPI';
    status: 'ok' | 'error' | 'warning';
    message: string;
    latency?: number;
}

const getErrorMessage = (error: unknown): string =>
    error instanceof Error ? error.message : 'Unknown error';

export const runDiagnostics = async (): Promise<DiagnosticResult[]> => {
    const results: DiagnosticResult[] = [];

    // 1. Check Environment Variables
    const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
    const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

    if (!supabaseUrl || !supabaseKey) {
        results.push({ service: 'EnvVars', status: 'error', message: 'Variáveis Supabase ausentes. Verifique VITE_SUPABASE_URL e VITE_SUPABASE_ANON_KEY.' });
    } else {
        results.push({ service: 'EnvVars', status: 'ok', message: 'Variáveis Supabase presentes.' });
    }

    // 2. Connectivity Check: Supabase
    if (supabaseUrl && supabaseKey) {
        const startSupabase = performance.now();
        try {
            const { data, error } = await supabase.from('profiles').select('count', { count: 'exact', head: true }).limit(1);
            const endSupabase = performance.now();

            if (error) {
                results.push({ service: 'Supabase', status: 'error', message: `Erro de conexão: ${error.message}`, latency: endSupabase - startSupabase });
            } else {
                results.push({ service: 'Supabase', status: 'ok', message: 'Conexão estabelecida com sucesso.', latency: endSupabase - startSupabase });
            }
        } catch (e: unknown) {
            results.push({ service: 'Supabase', status: 'error', message: `Exceção ao conectar: ${getErrorMessage(e)}` });
        }
    }

    // 3. Connectivity Check: Backend Gemini API
    const startGemini = performance.now();
    try {
        const response = await fetch("/api/ai/embeddings", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({ text: "test" }),
        });
        const endGemini = performance.now();
        if (response.ok) {
            const data = await response.json();
            if (data.embedding && Array.isArray(data.embedding)) {
                results.push({
                    service: 'GeminiAPI',
                    status: 'ok',
                    message: `Backend Gemini API está operando corretamente. Embedding de teste gerado com sucesso.`,
                    latency: endGemini - startGemini
                });
            } else {
                results.push({
                    service: 'GeminiAPI',
                    status: 'error',
                    message: 'Backend Gemini API respondeu com sucesso, mas o formato do embedding é inválido.',
                    latency: endGemini - startGemini
                });
            }
        } else {
            const errBody = await response.json().catch(() => ({}));
            results.push({
                service: 'GeminiAPI',
                status: 'error',
                message: `Backend Gemini API retornou erro ${response.status}: ${errBody.error || response.statusText}`,
                latency: endGemini - startGemini
            });
        }
    } catch (e: unknown) {
        results.push({
            service: 'GeminiAPI',
            status: 'error',
            message: `Falha de conexão com a API de embeddings: ${getErrorMessage(e)}`
        });
    }

    return results;
};
