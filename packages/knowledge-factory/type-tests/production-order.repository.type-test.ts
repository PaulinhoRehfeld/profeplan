import type {
  CreateProductionOrderCommand,
  PedagogicalProductionOrder,
  ProductionOrderWriteReceipt,
  TransitionProductionOrderCommand,
} from '@profeplan/types';
import type {
  ProductionOrderReadRepository,
  ProductionOrderRepository,
  ProductionOrderRequestRepository,
  ProductionOrderTransitionRepository,
} from '../src/index.ts';

type Equal<Left, Right> =
  (<Value>() => Value extends Left ? 1 : 2) extends <Value>() => Value extends Right ? 1 : 2
    ? true
    : false;
type Expect<Value extends true> = Value;

type ReadMethods = Expect<Equal<keyof ProductionOrderReadRepository, 'findById' | 'listEvents'>>;
type RequestMethods = Expect<
  Equal<keyof ProductionOrderRequestRepository, 'createProductionOrder'>
>;
type TransitionMethods = Expect<
  Equal<keyof ProductionOrderTransitionRepository, 'transitionProductionOrder'>
>;
type CombinedMethods = Expect<
  Equal<
    keyof ProductionOrderRepository,
    | keyof ProductionOrderReadRepository
    | keyof ProductionOrderRequestRepository
    | keyof ProductionOrderTransitionRepository
  >
>;
type CreateMethod = Expect<
  Equal<
    ProductionOrderRequestRepository['createProductionOrder'],
    (command: CreateProductionOrderCommand) => Promise<ProductionOrderWriteReceipt>
  >
>;
type TransitionMethod = Expect<
  Equal<
    ProductionOrderTransitionRepository['transitionProductionOrder'],
    (command: TransitionProductionOrderCommand) => Promise<ProductionOrderWriteReceipt>
  >
>;
type CreateOrderFields = Expect<
  Equal<
    keyof CreateProductionOrderCommand['order'],
    Exclude<keyof PedagogicalProductionOrder, 'requesterId' | 'status' | 'createdAt' | 'updatedAt'>
  >
>;
type CreateCommandFields = Expect<
  Equal<
    keyof CreateProductionOrderCommand,
    'commandId' | 'order' | 'eventId' | 'eventVersion' | 'occurredAt'
  >
>;
type TransitionCommandFields = Expect<
  Equal<
    keyof TransitionProductionOrderCommand,
    | 'commandId'
    | 'requesterId'
    | 'oppId'
    | 'expectedStatus'
    | 'expectedUpdatedAt'
    | 'toStatus'
    | 'eventId'
    | 'eventVersion'
    | 'reason'
    | 'occurredAt'
  >
>;
type ReceiptFields = Expect<
  Equal<
    keyof ProductionOrderWriteReceipt,
    'commandId' | 'operation' | 'oppId' | 'eventId' | 'status' | 'replayed' | 'committedAt'
  >
>;
type CombinedAssignsToRead = Expect<
  ProductionOrderRepository extends ProductionOrderReadRepository ? true : false
>;
type CombinedAssignsToRequest = Expect<
  ProductionOrderRepository extends ProductionOrderRequestRepository ? true : false
>;
type CombinedAssignsToTransition = Expect<
  ProductionOrderRepository extends ProductionOrderTransitionRepository ? true : false
>;

declare const createCommand: CreateProductionOrderCommand;
declare const transitionCommand: TransitionProductionOrderCommand;
declare const receipt: ProductionOrderWriteReceipt;
declare const repository: ProductionOrderRepository;

// @ts-expect-error write commands are immutable after construction
createCommand.commandId = 'another-command';
// @ts-expect-error the create snapshot is immutable
createCommand.order.theme = 'mutated theme';
// @ts-expect-error requester identity is derived by the REQUESTER boundary
createCommand.order.requesterId;
// @ts-expect-error initial status is derived by the create RPC
createCommand.order.status;
// @ts-expect-error create timestamps are derived by the persistence boundary
createCommand.order.createdAt;
// @ts-expect-error optimistic concurrency expectations are immutable
transitionCommand.expectedUpdatedAt = transitionCommand.occurredAt;
// @ts-expect-error receipts are immutable provider-neutral results
receipt.replayed = true;
// @ts-expect-error generic aggregate writes were removed from contract 3.0.0
repository.save(createCommand.order);
// @ts-expect-error standalone event appends were removed from contract 3.0.0
repository.appendEvent({});

export type ProductionOrderRepositoryContractAssertions =
  | ReadMethods
  | RequestMethods
  | TransitionMethods
  | CombinedMethods
  | CreateMethod
  | TransitionMethod
  | CreateOrderFields
  | CreateCommandFields
  | TransitionCommandFields
  | ReceiptFields
  | CombinedAssignsToRead
  | CombinedAssignsToRequest
  | CombinedAssignsToTransition;
