import type { SupabaseClient } from '@supabase/supabase-js';
import type { SupabaseRequesterContext } from '../src/index.ts';

type Equal<Left, Right> =
  (<Value>() => Value extends Left ? 1 : 2) extends <Value>() => Value extends Right ? 1 : 2
    ? true
    : false;
type Expect<Value extends true> = Value;

type ContextFields = Expect<Equal<keyof SupabaseRequesterContext, 'client' | 'requesterId'>>;
type ClientField = Expect<Equal<SupabaseRequesterContext['client'], SupabaseClient>>;

declare const context: SupabaseRequesterContext;

// @ts-expect-error requester identity is immutable for the lifetime of a request
context.requesterId = 'another-requester';
// @ts-expect-error the injected client cannot be replaced by an adapter
context.client = {} as SupabaseClient;
// @ts-expect-error credentials are not part of the infrastructure context contract
context.accessToken;

export type SupabaseRequesterContextContractAssertions = ContextFields | ClientField;
