import type { EntityId } from '@profeplan/types';
import type { SupabaseClient } from '@supabase/supabase-js';

export interface SupabaseRequesterContext {
  readonly client: SupabaseClient;
  readonly requesterId: EntityId;
}
