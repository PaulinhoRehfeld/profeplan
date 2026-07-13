import { supabase } from './supabaseClient';

/**
 * Obtém o token de acesso (JWT) da sessão atual do Supabase.
 *
 * @returns O token JWT ou null caso o usuário não esteja logado ou a sessão tenha expirado.
 */
export async function getSessionToken(): Promise<string | null> {
  try {
    const { data, error } = await supabase.auth.getSession();
    if (error || !data || !data.session) {
      return null;
    }
    return data.session.access_token;
  } catch (error) {
    console.error('[SessionService] Erro ao obter token da sessão:', error);
    return null;
  }
}

/**
 * Retorna os cabeçalhos de autenticação padronizados para requisições ao BFF ou outras APIs protegidas.
 * Se o usuário estiver autenticado, inclui o cabeçalho "Authorization: Bearer <token>".
 *
 * @returns Um objeto contendo os cabeçalhos de autenticação apropriados.
 */
export async function getAuthHeaders(): Promise<Record<string, string>> {
  const token = await getSessionToken();
  if (!token) {
    return {};
  }
  return {
    Authorization: `Bearer ${token}`,
  };
}
