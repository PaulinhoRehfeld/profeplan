import { app, HttpRequest, HttpResponseInit, InvocationContext } from '@azure/functions';
import { createClient } from '@supabase/supabase-js';
import { getSecret } from '../lib/secrets.js';

/**
 * Endpoint authProxy
 * Intercepta credenciais do frontend e repassa com segurança para o Supabase Auth.
 */
export async function authProxy(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
  context.log(`[authProxy] Processando requisição HTTP para a rota: "${request.url}"`);

  try {
    const body = (await request.json()) as any;
    if (!body || !body.action) {
      return {
        status: 400,
        jsonBody: { error: 'Missing parameter: action' },
      };
    }

    const { action, email, password, refreshToken, options } = body;

    // Obter credenciais do Supabase de forma segura
    const supabaseUrl = await getSecret('SUPABASE_URL');
    const supabaseAnonKey = await getSecret('SUPABASE_ANON_KEY');

    if (!supabaseUrl || !supabaseAnonKey) {
      return {
        status: 500,
        jsonBody: { error: 'Supabase integration keys are not properly configured' },
      };
    }

    // Criar cliente temporário do Supabase
    const supabase = createClient(supabaseUrl, supabaseAnonKey, {
      auth: {
        persistSession: false,
        autoRefreshToken: false,
      },
    });

    if (action === 'login') {
      if (!email || !password) {
        return {
          status: 400,
          jsonBody: { error: 'Email and password are required for login' },
        };
      }
      const { data, error } = await supabase.auth.signInWithPassword({ email, password });
      if (error) {
        return {
          status: error.status || 400,
          jsonBody: { error: error.message },
        };
      }
      return { status: 200, jsonBody: data };
    } 
    
    if (action === 'signup') {
      if (!email || !password) {
        return {
          status: 400,
          jsonBody: { error: 'Email and password are required for signup' },
        };
      }
      const { data, error } = await supabase.auth.signUp({
        email,
        password,
        options: options || {},
      });
      if (error) {
        return {
          status: error.status || 400,
          jsonBody: { error: error.message },
        };
      }
      return { status: 200, jsonBody: data };
    } 
    
    if (action === 'refresh') {
      if (!refreshToken) {
        return {
          status: 400,
          jsonBody: { error: 'refreshToken is required for token refresh' },
        };
      }
      const { data, error } = await supabase.auth.refreshSession({
        refresh_token: refreshToken,
      });
      if (error) {
        return {
          status: error.status || 400,
          jsonBody: { error: error.message },
        };
      }
      return { status: 200, jsonBody: data };
    }

    return {
      status: 400,
      jsonBody: { error: `Unsupported auth action: ${action}` },
    };
  } catch (error: any) {
    context.error('[authProxy] Erro não tratado no proxy de autenticação:', error);
    return {
      status: 500,
      jsonBody: { error: `Internal Server Error: ${error?.message || error}` },
    };
  }
}

app.http('authProxy', {
  methods: ['POST'],
  authLevel: 'anonymous',
  handler: authProxy,
});
