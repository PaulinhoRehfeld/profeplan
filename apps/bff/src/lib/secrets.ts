import { DefaultAzureCredential } from '@azure/identity';
import { SecretClient } from '@azure/keyvault-secrets';

const CACHE_TTL_MS = 5 * 60 * 1000; // 5 minutos

interface CacheEntry {
  value: string;
  expiresAt: number;
}

const secretsCache: Record<string, CacheEntry> = {};

/**
 * Obtém um segredo de forma segura, priorizando o Azure Key Vault com cache em memória (TTL 5min).
 * Se o Key Vault não estiver configurado ou falhar, faz o fallback para process.env.
 *
 * @param name Nome da chave/segredo a ser recuperado.
 * @returns O valor do segredo ou undefined.
 */
export async function getSecret(name: string): Promise<string | undefined> {
  // 1. Verificar cache em memória (com expiração)
  const cached = secretsCache[name];
  if (cached !== undefined && Date.now() < cached.expiresAt) {
    return cached.value;
  }

  const kvUrl = process.env.AZURE_KEYVAULT_URL;

  // 2. Se a URL do Key Vault não estiver configurada, usa variáveis de ambiente diretamente
  if (!kvUrl || kvUrl.includes('placeholder') || kvUrl.trim() === '') {
    const localVal = process.env[name];
    if (localVal !== undefined) {
      secretsCache[name] = { value: localVal, expiresAt: Date.now() + CACHE_TTL_MS };
      return localVal;
    }
    return undefined;
  }

  // 3. Tenta obter do Azure Key Vault
  try {
    const credential = new DefaultAzureCredential();
    const client = new SecretClient(kvUrl, credential);

    const timeoutPromise = new Promise<never>((_, reject) =>
      setTimeout(() => reject(new Error('Azure Key Vault timeout')), 3000)
    );

    const secret = await Promise.race([client.getSecret(name), timeoutPromise]);

    if (secret && secret.value) {
      secretsCache[name] = { value: secret.value, expiresAt: Date.now() + CACHE_TTL_MS };
      return secret.value;
    }
  } catch (error: any) {
    console.warn(
      `⚠️ Erro ao buscar segredo "${name}" do Azure Key Vault: ${error?.message || error}. Usando fallback de process.env.`
    );
  }

  // 4. Fallback de segurança para process.env
  const fallbackVal = process.env[name];
  if (fallbackVal !== undefined) {
    secretsCache[name] = { value: fallbackVal, expiresAt: Date.now() + CACHE_TTL_MS };
    return fallbackVal;
  }

  return undefined;
}
