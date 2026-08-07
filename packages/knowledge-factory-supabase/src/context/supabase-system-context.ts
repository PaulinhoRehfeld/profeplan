import type { SupabaseClient } from "@supabase/supabase-js";

export interface SupabaseSystemContext {
  readonly client: SupabaseClient;
  readonly correlationId?: string;
}
