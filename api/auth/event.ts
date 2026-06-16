import type { VercelRequest, VercelResponse } from '@vercel/node';
import { logger } from '@profeplan/logger';

export default async function handler(req: VercelRequest, res: VercelResponse) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method Not Allowed' });
  }

  try {
    const { event, email, success, error } = req.body || {};
    if (!event) {
      return res.status(400).json({ error: 'O parâmetro "event" é obrigatório.' });
    }

    const cleanEmail = String(email || '').trim();

    if (event === 'login') {
      if (success) {
        logger.audit('LOGIN_SUCCESS', cleanEmail || 'desconhecido', {
          success: true,
          platform: 'V4-Vite-App',
        });
      } else {
        logger.error(`[AUTH] Falha de login para ${cleanEmail || 'desconhecido'}: ${error || 'Erro desconhecido'}`);
      }
      return res.status(200).json({ success: true });
    }

    if (event === 'logout') {
      logger.audit('LOGOUT', cleanEmail || 'desconhecido', {
        platform: 'V4-Vite-App',
      });
      return res.status(200).json({ success: true });
    }

    return res.status(400).json({ error: 'Tipo de evento de autenticação inválido.' });
  } catch (err: unknown) {
    const message = err instanceof Error ? err.message : 'Erro interno';
    logger.error(`[API/AuthEvent] Erro ao registrar evento de autenticação: ${message}`, err);
    return res.status(500).json({ error: message });
  }
}
