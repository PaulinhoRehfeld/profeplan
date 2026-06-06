/**
 * EventBus - Pub/sub para side-effects (memory, feedback, analytics).
 * Fase 1 da refatoração (ARCHITECTURE-PROFEPLAN).
 *
 * Eventos: planning:generated | assessment:generated | pdi:adaptation:saved
 */
type Handler<T = unknown> = (payload: T) => void | Promise<void>;

const handlers = new Map<string, Set<Handler>>();

export interface EventBus {
  subscribe<T>(event: string, handler: Handler<T>): () => void;
  publish<T>(event: string, payload: T): void;
}

class EventBusImpl implements EventBus {
  subscribe<T>(event: string, handler: Handler<T>): () => void {
    if (!handlers.has(event)) {
      handlers.set(event, new Set());
    }
    handlers.get(event)!.add(handler as Handler);
    return () => handlers.get(event)?.delete(handler as Handler);
  }

  publish<T>(event: string, payload: T): void {
    const set = handlers.get(event);
    if (!set) return;
    set.forEach((h) => {
      try {
        const result = h(payload);
        if (result instanceof Promise) {
          result.catch((err) => console.error(`[EventBus] Handler error for ${event}:`, err));
        }
      } catch (err) {
        console.error(`[EventBus] Handler error for ${event}:`, err);
      }
    });
  }
}

export const eventBus: EventBus = new EventBusImpl();
