import type { DomainEvent } from './events.ts';
import type { DomainReason } from './reasons.ts';

export interface DomainDecision<T = undefined> {
  allowed: boolean;
  value?: T;
  reasons: readonly DomainReason[];
  events: readonly DomainEvent[];
}

export function allow<T>(value: T, events: readonly DomainEvent[] = []): DomainDecision<T> {
  return { allowed: true, value, reasons: [], events };
}

export function deny<T = undefined>(
  reasons: readonly DomainReason[],
  events: readonly DomainEvent[] = []
): DomainDecision<T> {
  return { allowed: false, reasons, events };
}
