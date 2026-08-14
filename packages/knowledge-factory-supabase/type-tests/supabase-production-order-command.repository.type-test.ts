import type {
  ProductionOrderRepository,
  ProductionOrderRequestRepository,
  ProductionOrderTransitionRepository,
} from '@profeplan/knowledge-factory';
import type {
  SupabaseProductionOrderRequestRepository,
  SupabaseProductionOrderTransitionRepository,
} from '../src/index.ts';

type Equal<Left, Right> =
  (<Value>() => Value extends Left ? 1 : 2) extends <Value>() => Value extends Right ? 1 : 2
    ? true
    : false;
type Expect<Value extends true> = Value;

type RequestMethods = Expect<
  Equal<keyof SupabaseProductionOrderRequestRepository, 'createProductionOrder'>
>;
type TransitionMethods = Expect<
  Equal<keyof SupabaseProductionOrderTransitionRepository, 'transitionProductionOrder'>
>;

declare const requestAdapter: SupabaseProductionOrderRequestRepository;
declare const transitionAdapter: SupabaseProductionOrderTransitionRepository;

const requestRepository: ProductionOrderRequestRepository = requestAdapter;
const transitionRepository: ProductionOrderTransitionRepository = transitionAdapter;
// @ts-expect-error the REQUESTER adapter intentionally exposes no read or transition capabilities
const fullRepositoryFromRequester: ProductionOrderRepository = requestAdapter;
// @ts-expect-error the SYSTEM adapter intentionally exposes no read or request capabilities
const fullRepositoryFromSystem: ProductionOrderRepository = transitionAdapter;

export type SupabaseProductionOrderCommandRepositoryContractAssertions =
  | RequestMethods
  | TransitionMethods
  | typeof requestRepository
  | typeof transitionRepository
  | typeof fullRepositoryFromRequester
  | typeof fullRepositoryFromSystem;
