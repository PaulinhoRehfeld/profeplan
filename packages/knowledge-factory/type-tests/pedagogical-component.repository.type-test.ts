import type {
  AppendPedagogicalComponentVersionCommand,
  CreatePedagogicalComponentAggregateCommand,
  PedagogicalComponentWriteReceipt,
  PromotePedagogicalComponentVersionCommand,
  TransitionPedagogicalComponentVersionStatusCommand,
} from '@profeplan/types';
import type {
  PedagogicalComponentCommandRepository,
  PedagogicalComponentReadRepository,
  PedagogicalComponentRepository,
} from '../src/index.ts';

type Equal<Left, Right> =
  (<Value>() => Value extends Left ? 1 : 2) extends <Value>() => Value extends Right ? 1 : 2
    ? true
    : false;
type Expect<Value extends true> = Value;

type ReadMethods = Expect<
  Equal<
    keyof PedagogicalComponentReadRepository,
    'findById' | 'findVersion' | 'listEvidenceOrigins'
  >
>;
type CommandMethods = Expect<
  Equal<
    keyof PedagogicalComponentCommandRepository,
    | 'createComponentAggregate'
    | 'appendComponentVersion'
    | 'transitionComponentVersionStatus'
    | 'promoteComponentVersion'
  >
>;
type CombinedMethods = Expect<
  Equal<
    keyof PedagogicalComponentRepository,
    keyof PedagogicalComponentReadRepository | keyof PedagogicalComponentCommandRepository
  >
>;
type CreateMethod = Expect<
  Equal<
    PedagogicalComponentCommandRepository['createComponentAggregate'],
    (
      command: CreatePedagogicalComponentAggregateCommand
    ) => Promise<PedagogicalComponentWriteReceipt>
  >
>;
type AppendMethod = Expect<
  Equal<
    PedagogicalComponentCommandRepository['appendComponentVersion'],
    (command: AppendPedagogicalComponentVersionCommand) => Promise<PedagogicalComponentWriteReceipt>
  >
>;
type TransitionMethod = Expect<
  Equal<
    PedagogicalComponentCommandRepository['transitionComponentVersionStatus'],
    (
      command: TransitionPedagogicalComponentVersionStatusCommand
    ) => Promise<PedagogicalComponentWriteReceipt>
  >
>;
type PromoteMethod = Expect<
  Equal<
    PedagogicalComponentCommandRepository['promoteComponentVersion'],
    (
      command: PromotePedagogicalComponentVersionCommand
    ) => Promise<PedagogicalComponentWriteReceipt>
  >
>;

declare const createCommand: CreatePedagogicalComponentAggregateCommand;
declare const appendCommand: AppendPedagogicalComponentVersionCommand;
declare const transitionCommand: TransitionPedagogicalComponentVersionStatusCommand;
declare const promoteCommand: PromotePedagogicalComponentVersionCommand;
declare const receipt: PedagogicalComponentWriteReceipt;
declare const repository: PedagogicalComponentRepository;

// @ts-expect-error write commands are immutable after construction
createCommand.commandId = 'another-command';
// @ts-expect-error component snapshots are deeply immutable through the command contract
createCommand.component.title = 'mutated title';
// @ts-expect-error evidence snapshots are immutable through the command contract
appendCommand.evidenceOrigins.push(createCommand.evidenceOrigins[0]);
// @ts-expect-error evidence objects are immutable through the command contract
appendCommand.evidenceOrigins[0].sourceId = 'another-source';
// @ts-expect-error transition expectations cannot be rewritten by the adapter
transitionCommand.expectedStatus = transitionCommand.toStatus;
// @ts-expect-error compare-and-set expectations are immutable
promoteCommand.expectedCurrentVersionId = promoteCommand.targetVersionId;
// @ts-expect-error receipts are immutable provider-neutral results
receipt.replayed = true;
// @ts-expect-error incomplete generic writes were removed from contract 2.0.0
repository.saveComponent(createCommand.component);
// @ts-expect-error incomplete generic writes were removed from contract 2.0.0
repository.saveVersion(appendCommand.version);

export type PedagogicalComponentRepositoryContractAssertions =
  | ReadMethods
  | CommandMethods
  | CombinedMethods
  | CreateMethod
  | AppendMethod
  | TransitionMethod
  | PromoteMethod;
