/**
 * AiQueue — fila global de requisições de IA no cliente.
 *
 * Garante que apenas MAX_CONCURRENT chamadas ao backend de IA
 * aconteçam ao mesmo tempo nesta aba. Demais chamadas ficam na
 * fila e são despachadas automaticamente quando uma vaga abre.
 *
 * Também implementa retry com backoff exponencial em caso de 429
 * (rate-limit) retornado pelo servidor.
 */

const MAX_CONCURRENT = 1; // 1 geração por vez por aba
const MAX_RETRIES = 4; // tentativas em caso de 429
const BASE_DELAY_MS = 3000; // 3s → 6s → 12s → 24s

type WaitEntry = {
  resolve: () => void;
  reject: (e: Error) => void;
};

type QueueListener = (state: QueueState) => void;

export type QueueState = {
  running: number; // requisições em execução agora
  waiting: number; // requisições aguardando na fila
  position: number; // posição DESTA chamada (0 = executando)
};

class AiRequestQueue {
  private running = 0;
  private waitList: WaitEntry[] = [];
  private listeners = new Set<QueueListener>();

  // ─── observabilidade ────────────────────────────────────────────
  subscribe(fn: QueueListener): () => void {
    this.listeners.add(fn);
    return () => this.listeners.delete(fn);
  }

  private notify(extra?: { position: number }) {
    const state: QueueState = {
      running: this.running,
      waiting: this.waitList.length,
      position: extra?.position ?? 0,
    };
    this.listeners.forEach((fn) => fn(state));
  }

  // ─── estado público ─────────────────────────────────────────────
  get isBusy(): boolean {
    return this.running >= MAX_CONCURRENT;
  }

  // ─── execução com fila ──────────────────────────────────────────
  async run<T>(fn: () => Promise<T>, onQueued?: (position: number) => void): Promise<T> {
    // Se há slot livre, executa imediatamente
    if (this.running < MAX_CONCURRENT) {
      return this.execute(fn);
    }

    // Caso contrário, entra na fila de espera
    const position = this.waitList.length + 1;
    onQueued?.(position);
    this.notify({ position });

    await new Promise<void>((resolve, reject) => {
      this.waitList.push({ resolve, reject });
    });

    return this.execute(fn);
  }

  private async execute<T>(fn: () => Promise<T>): Promise<T> {
    this.running++;
    this.notify({ position: 0 });
    try {
      return await this.withRetry(fn);
    } finally {
      this.running--;
      const next = this.waitList.shift();
      if (next) next.resolve();
      this.notify({ position: 0 });
    }
  }

  // ─── retry com backoff exponencial ──────────────────────────────
  private async withRetry<T>(fn: () => Promise<T>, attempt = 0): Promise<T> {
    try {
      return await fn();
    } catch (err: any) {
      const is429 =
        err?.status === 429 || (typeof err?.message === 'string' && err.message.includes('429'));

      if (is429 && attempt < MAX_RETRIES) {
        const delay = BASE_DELAY_MS * Math.pow(2, attempt);
        console.warn(
          `[AiQueue] Rate-limit (429) — tentativa ${attempt + 1}/${MAX_RETRIES}. Aguardando ${delay / 1000}s...`
        );
        await new Promise((r) => setTimeout(r, delay));
        return this.withRetry(fn, attempt + 1);
      }
      throw err;
    }
  }
}

export const aiQueue = new AiRequestQueue();
