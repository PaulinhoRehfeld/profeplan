import { HttpRequest } from '@azure/functions';
import jwt from 'jsonwebtoken';
import { getSecret } from './secrets.js';

export interface UserPayload {
  sub: string;
  email?: string;
  role?: string;
  [key: string]: any;
}

/**
 * Valida o cabeçalho Authorization contendo o token JWT do Supabase.
 * Executa a validação localmente decodificando e verificando a assinatura com a chave SUPABASE_JWT_SECRET.
 *
 * @param request A requisição HTTP do Azure Functions.
 * @returns O payload decodificado do usuário autenticado.
 */
export async function verifyUserToken(request: HttpRequest): Promise<UserPayload> {
  const authHeader = request.headers.get('authorization') || request.headers.get('Authorization');
  if (!authHeader) {
    throw new Error('Missing authorization header');
  }

  const parts = authHeader.split(' ');
  if (parts.length !== 2 || parts[0].toLowerCase() !== 'bearer') {
    throw new Error('Malformed authorization header. Expected format: Bearer <token>');
  }

  const token = parts[1].trim();
  if (!token) {
    throw new Error('Empty token provided');
  }

  const jwtSecret = await getSecret('SUPABASE_JWT_SECRET');
  if (!jwtSecret) {
    throw new Error('SUPABASE_JWT_SECRET is not configured on the server');
  }

  try {
    const decoded = jwt.verify(token, jwtSecret) as UserPayload;
    return decoded;
  } catch (error: any) {
    throw new Error(`Invalid or expired token: ${error?.message || error}`);
  }
}
