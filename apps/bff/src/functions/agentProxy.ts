/**
 * PROFEPLAN V5 — Agent Proxy (Azure Function)
 * S5-04: Endpoint BFF que expõe o OrchestratorAgent como API HTTP.
 *
 * Rota: POST /api/agentProxy
 *
 * Autentica via JWT do Supabase, recebe GeracaoRequest,
 * instancia o OrchestratorAgent com o AgentRegistry populado
 * e retorna GeracaoResponse.
 */

import { app, HttpRequest, HttpResponseInit, InvocationContext } from '@azure/functions';
import { verifyUserToken } from '../lib/auth.js';

/**
 * Endpoint agentProxy
 *
 * Body esperado (GeracaoRequest):
 * {
 *   "disciplina": "MATEMATICA",
 *   "nivel": "EF_6",
 *   "tipo": "PLANO_AULA",
 *   "professorId": "...",
 *   "turmaId": "...",
 *   "params": { "tema": "Frações" }
 * }
 */
export async function agentProxy(
  request: HttpRequest,
  context: InvocationContext,
): Promise<HttpResponseInit> {
  context.log('[agentProxy] Processando requisição de geração por agente V5.');

  // 1. Autenticação
  try {
    await verifyUserToken(request);
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Token inválido';
    context.warn('[agentProxy] Falha na autenticação:', message);
    return { status: 401, jsonBody: { sucesso: false, erro: `Unauthorized: ${message}` } };
  }

  // 2. Extrair corpo
  let body: Record<string, unknown>;
  try {
    body = (await request.json()) as Record<string, unknown>;
  } catch {
    return { status: 400, jsonBody: { sucesso: false, erro: 'Body JSON inválido.' } };
  }

  // 3. Validar campos obrigatórios
  const required = ['disciplina', 'nivel', 'tipo', 'professorId', 'turmaId'];
  for (const campo of required) {
    if (!body[campo]) {
      return {
        status: 400,
        jsonBody: { sucesso: false, erro: `Campo obrigatório ausente: "${campo}".` },
      };
    }
  }

  // 4. TODO: Instanciar OrchestratorAgent com AgentRegistry populado
  //    por enquanto retorna resposta mock indicando que o endpoint está ativo
  //    A integração real será feita quando o pacote @profeplan/agents for
  //    adicionado como dependência do BFF.

  context.log('[agentProxy] TODO: Integrar @profeplan/agents ao BFF Azure.', {
    disciplina: body.disciplina,
    nivel: body.nivel,
    tipo: body.tipo,
  });

  return {
    status: 200,
    jsonBody: {
      sucesso: true,
      conteudo: {
        mensagem: '[V5 Agent Proxy] Endpoint ativo. Integração com @profeplan/agents pendente.',
        disciplina: body.disciplina,
        nivel: body.nivel,
        tipo: body.tipo,
      },
      metadados: {
        agente: 'AgentProxy (stub)',
        disciplina: String(body.disciplina),
        nivel: String(body.nivel),
        tentativas: 1,
        timestamp: new Date().toISOString(),
      },
    },
  };
}

// Registrar a Azure Function
app.http('agentProxy', {
  methods: ['POST'],
  authLevel: 'anonymous',
  handler: agentProxy,
});
