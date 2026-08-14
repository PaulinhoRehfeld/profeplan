import type {
  ProductionOrderReadRepository,
  ProductionOrderRepository,
} from '@profeplan/knowledge-factory';
import type { SupabaseProductionOrderReadRepository } from '../src/index.ts';

type Equal<Left, Right> =
  (<Value>() => Value extends Left ? 1 : 2) extends <Value>() => Value extends Right ? 1 : 2
    ? true
    : false;
type Expect<Value extends true> = Value;

type ReadMethods = Expect<
  Equal<keyof SupabaseProductionOrderReadRepository, 'findById' | 'listEvents'>
>;

declare const adapter: SupabaseProductionOrderReadRepository;

const readRepository: ProductionOrderReadRepository = adapter;
// @ts-expect-error the read adapter intentionally exposes no command capabilities
const fullRepository: ProductionOrderRepository = adapter;

export type SupabaseProductionOrderReadRepositoryContractAssertions =
  | ReadMethods
  | typeof readRepository
  | typeof fullRepository;
