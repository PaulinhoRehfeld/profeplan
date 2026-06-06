
import { supabase } from "./supabaseClient";

interface DiagnosticResult {
    service: 'Supabase' | 'EnvVars';
    status: 'ok' | 'error' | 'warning';
    message: string;
    latency?: number;
}

const getErrorMessage = (error: unknown): string =>
    error instanceof Error ? error.message : 'Unknown error';

export const runDiagnostics = async (): Promise<DiagnosticResult[]> => {
    const results: DiagnosticResult[] = [];

    // 1. Check Environment Variables
    const geminiKey = import.meta.env.VITE_GEMINI_API_KEY;
    const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
    const supabaseKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

    if (!geminiKey) {
        results.push({ service: 'EnvVars', status: 'error', message: 'VITE_GEMINI_API_KEY ausente. Verifique as variáveis de ambiente no Vercel.' });
    } else {
        results.push({ service: 'EnvVars', status: 'ok', message: `VITE_GEMINI_API_KEY presente (${geminiKey.length} chars).` });
    }

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

    return results;
};
