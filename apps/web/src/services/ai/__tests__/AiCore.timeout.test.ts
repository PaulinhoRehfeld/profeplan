import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest';

// supabaseClient.ts lança erro no import sem env vars (CI não define
// VITE_SUPABASE_URL/ANON_KEY) — getAuthHeaders (via sessionService) depende dele.
vi.mock('../../supabaseClient', () => ({
  supabase: { auth: { getSession: vi.fn().mockResolvedValue({ data: { session: null }, error: null }) } },
}));

import { getGenAIClient } from '../AiCore';

describe('AiCore callAiBackend (regressão #18 — timeout no fetch)', () => {
  beforeEach(() => {
    vi.useFakeTimers();
  });

  afterEach(() => {
    vi.useRealTimers();
    vi.restoreAllMocks();
  });

  it('aborta e rejeita com mensagem clara quando o fetch trava além do timeout', async () => {
    // fetch que nunca resolve (simula backend travado)
    const abortedPromise = new Promise((_resolve, reject) => {
      // não faz nada aqui — quem rejeita é o AbortController via signal
    });
    global.fetch = vi.fn().mockImplementation((_url: string, options: any) => {
      return new Promise((_resolve, reject) => {
        options.signal.addEventListener('abort', () => {
          const err = new Error('The operation was aborted.');
          (err as any).name = 'AbortError';
          reject(err);
        });
      });
    }) as any;

    const client = getGenAIClient();
    const resultPromise = client.chat.completions.create({
      messages: [{ role: 'user', content: 'oi' }],
    } as any);

    const assertion = expect(resultPromise).rejects.toThrow('A geração demorou demais e foi cancelada. Tente novamente.');

    await vi.advanceTimersByTimeAsync(90_000);

    await assertion;
    void abortedPromise;
  });

  it('libera a fila (AiQueue) após o timeout, permitindo a próxima chamada rodar', async () => {
    global.fetch = vi.fn().mockImplementation((_url: string, options: any) => {
      return new Promise((_resolve, reject) => {
        options.signal.addEventListener('abort', () => {
          const err = new Error('aborted');
          (err as any).name = 'AbortError';
          reject(err);
        });
      });
    }) as any;

    const client = getGenAIClient();
    const first = client.chat.completions.create({ messages: [] } as any).catch(() => 'first-failed');
    await vi.advanceTimersByTimeAsync(90_000);
    expect(await first).toBe('first-failed');

    // Segunda chamada: fetch resolve normalmente — só passa se a fila foi liberada
    global.fetch = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({ text: 'ok' }),
    }) as any;

    const second = await client.chat.completions.create({ messages: [] } as any);
    expect(second.choices[0].message.content).toBe('ok');
  });
});
