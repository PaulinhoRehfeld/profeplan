export const maxDuration = 60;
import type { VercelRequest, VercelResponse } from '@vercel/node';
import { supabaseAdmin } from './_lib/supabaseAdmin';
import {
  DisciplinaNome,
  NivelEnsino,
  TipoGeracao,
  OrchestratorAgent,
  createPopulatedRegistry,
  type GeracaoRequest,
} from '@profeplan/agents';

const logger = {
  info: (msg: string, meta?: unknown) => console.log(JSON.stringify({ level: 'INFO', message: msg, ...(meta ? { meta } : {}) })),
  error: (msg: string, meta?: unknown) => console.error(JSON.stringify({ level: 'ERROR', message: msg, ...(meta ? { meta } : {}) })),
};

type Body = {
  disciplina?: string;
  nivel?: string;
  tipo?: string;
  turmaId?: string;
  params?: Record<string, unknown>;
};

const isValidEnumValue = <T extends Record<string, string>>(enumObj: T, value: string): value is T[keyof T] =>
  Object.values(enumObj).includes(value as T[keyof T]);

/**
 * Autentica o usuário via JWT do Supabase (Authorization: Bearer <token>).
 * Reaproveita `supabaseAdmin` (api/_lib/supabaseAdmin.ts) — mesmo client
 * service-role já usado por outras functions (searchProxy, auth/signup).
 * @returns o id do usuário autenticado, ou lança erro se o token for inválido.
 */
const authenticate = async (req: VercelRequest): Promise<string> => {
  const authHeader = req.headers.authorization || '';
  const [scheme, token] = authHeader.split(' ');
  if (scheme?.toLowerCase() !== 'bearer' || !token) {
    throw new Error('Authorization header ausente ou malformado. Esperado: "Bearer <token>".');
  }

  const { data, error } = await supabaseAdmin.auth.getUser(token);
  if (error || !data?.user?.id) {
    throw new Error(`Token inválido ou expirado: ${error?.message || 'usuário não encontrado'}`);
  }
  return data.user.id;
};

export default async function handler(req: VercelRequest, res: VercelResponse) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method Not Allowed' });
  }

  let professorId: string;
  try {
    professorId = await authenticate(req);
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : 'Falha na autenticação';
    logger.error(`[agentGenerate] ${message}`);
    return res.status(401).json({ error: message });
  }

  try {
    const body = (req.body || {}) as Body;
    const { disciplina, nivel, tipo, turmaId, params = {} } = body;

    if (!disciplina || !isValidEnumValue(DisciplinaNome, disciplina)) {
      return res.status(400).json({ error: `Campo "disciplina" inválido ou ausente. Valores aceitos: ${Object.values(DisciplinaNome).join(', ')}` });
    }
    if (!nivel || !isValidEnumValue(NivelEnsino, nivel)) {
      return res.status(400).json({ error: `Campo "nivel" inválido ou ausente. Valores aceitos: ${Object.values(NivelEnsino).join(', ')}` });
    }
    if (!tipo || !isValidEnumValue(TipoGeracao, tipo)) {
      return res.status(400).json({ error: `Campo "tipo" inválido ou ausente. Valores aceitos: ${Object.values(TipoGeracao).join(', ')}` });
    }
    if (!turmaId) {
      return res.status(400).json({ error: 'Campo "turmaId" é obrigatório.' });
    }

    const registry = createPopulatedRegistry();
    const orchestrator = new OrchestratorAgent(registry, { maxRetries: 2 });

    const request: GeracaoRequest = {
      disciplina,
      nivel,
      tipo,
      professorId, // do token — nunca confiar no valor enviado pelo cliente
      turmaId,
      params,
    };

    logger.info('[agentGenerate] Processando requisição', { disciplina, nivel, tipo, turmaId, professorId });

    const response = await orchestrator.processarRequisicao(request);

    if (!response.sucesso) {
      logger.error('[agentGenerate] Geração falhou', { erro: response.erro, metadados: response.metadados });
      return res.status(422).json(response);
    }

    logger.info('[agentGenerate] Geração concluída', { metadados: response.metadados });
    return res.status(200).json(response);
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Internal error';
    logger.error(`[agentGenerate] Erro inesperado: ${message}`, error);
    return res.status(500).json({ error: message });
  }
}
