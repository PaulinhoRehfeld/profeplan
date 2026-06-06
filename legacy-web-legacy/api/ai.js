/**
 * api/ai.js — Vercel Serverless Function
 *
 * Proxy de IA que substitui o Azure OpenAI descontinuado.
 *
 * ANTES: O cliente legado chamava /api/ai → backend chamava Azure
 * AGORA: /api/ai → OpenAI direto (usando OPENAI_API_KEY das variáveis de ambiente Vercel)
 *
 * Compatível com o cliente proxy do bundle compilado:
 *   VS(n) → fetch('/api/ai', { method: 'POST', body: JSON.stringify(n) })
 *   Espera resposta: { text: string }
 *   Aceita input: { model, messages, temperature }
 */

import OpenAI from 'openai';

export const config = {
  runtime: 'edge', // Edge Runtime para menor latência
};

export default async function handler(req) {
  // CORS — permite chamadas do app Capacitor e do domínio profeplan
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  };

  // Preflight
  if (req.method === 'OPTIONS') {
    return new Response(null, { status: 204, headers: corsHeaders });
  }

  if (req.method !== 'POST') {
    return new Response(JSON.stringify({ error: 'Method not allowed' }), {
      status: 405,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }

  try {
    const body = await req.json();
    const { messages, temperature = 0.7 } = body;

    if (!messages || !Array.isArray(messages)) {
      return new Response(JSON.stringify({ error: 'Missing messages array' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      });
    }

    const apiKey = process.env.OPENAI_API_KEY;
    if (!apiKey) {
      console.error('[api/ai] ❌ OPENAI_API_KEY não configurada nas variáveis de ambiente Vercel');
      return new Response(
        JSON.stringify({ error: 'AI service not configured. Contact support.' }),
        { status: 503, headers: { ...corsHeaders, 'Content-Type': 'application/json' } },
      );
    }

    const openai = new OpenAI({ apiKey });

    // Usa o modelo configurado ou gpt-4o-mini como padrão seguro
    const model = process.env.OPENAI_MODEL || 'gpt-4o-mini';

    const completion = await openai.chat.completions.create({
      model,
      messages,
      temperature,
    });

    const text = completion.choices[0]?.message?.content ?? '';

    // Resposta no formato esperado pelo cliente proxy do bundle
    return new Response(JSON.stringify({ text }), {
      status: 200,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  } catch (err) {
    console.error('[api/ai] Erro:', err);

    const message = err instanceof Error ? err.message : 'Internal server error';
    const status = message.includes('401') ? 401 : 500;

    return new Response(JSON.stringify({ error: message }), {
      status,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    });
  }
}
