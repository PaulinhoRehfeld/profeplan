export async function withRetry<T>(
  fn: () => Promise<T>,
  options: { retries?: number; delayMs?: number } = {}
): Promise<T> {
  const { retries = 2, delayMs = 500 } = options;

  let attempt = 0;
  // eslint-disable-next-line no-constant-condition
  while (true) {
    try {
      return await fn();
    } catch (err: any) {
      if (attempt >= retries) {
        throw err;
      }

      const status = err?.status || err?.statusCode || err?.code;
      const isNetworkish = typeof status === 'number' ? status >= 500 && status < 600 : true;

      if (!isNetworkish) {
        throw err;
      }

      attempt += 1;
      await new Promise((res) => setTimeout(res, delayMs));
    }
  }
}
