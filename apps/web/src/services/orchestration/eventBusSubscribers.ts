/**
 * Assinantes do EventBus - memory, feedback, analytics.
 * Registrado no bootstrap da aplicação.
 */
import { eventBus } from './EventBus';
import { addMemory } from '../memoryService';
import type { PlanningGeneratedPayload } from './PlanningOrchestrator';

let subscribed = false;

export function registerEventBusSubscribers(): void {
  if (subscribed) return;
  subscribed = true;

  eventBus.subscribe<PlanningGeneratedPayload>('planning:generated', async (payload) => {
    try {
      const summary = `Planejamento: ${payload.subject} - ${payload.grade} - ${payload.period}º período`;
      await addMemory(payload.userId, summary, ['planning', 'term_plan']);
    } catch (err) {
      console.warn('[EventBus] addMemory failed:', err);
    }
  });
}
