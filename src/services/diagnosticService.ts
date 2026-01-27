
import { GoogleGenerativeAI } from "@google/generative-ai";
import { supabase } from "./supabaseClient";

interface DiagnosticResult {
    service: 'Gemini' | 'Supabase' | 'EnvVars';
    status: 'ok' | 'error' | 'warning';
    message: string;
    latency?: number;
}

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
        } catch (e: any) {
            results.push({ service: 'Supabase', status: 'error', message: `Exceção ao conectar: ${e.message}` });
        }
    }

    // 3. Connectivity Check: Gemini
    if (geminiKey) {
        const startGemini = performance.now();
        try {
            const genAI = new GoogleGenerativeAI(geminiKey);
            const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });
            const result = await model.generateContent("Ping");
            const response = result.response.text();
            const endGemini = performance.now();

            if (response) {
                results.push({ service: 'Gemini', status: 'ok', message: 'Conexão estabelecida com sucesso.', latency: endGemini - startGemini });
            } else {
                results.push({ service: 'Gemini', status: 'warning', message: 'Sem resposta de texto.', latency: endGemini - startGemini });
            }
        } catch (e: any) {
            results.push({ service: 'Gemini', status: 'error', message: `Erro de conexão: ${e.message}` });
        }
    }

    return results;
};
