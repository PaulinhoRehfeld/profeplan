export const isGovernedCreditConsumerEnabled = (): boolean =>
  import.meta.env.VITE_GOVERNED_CREDIT_CONSUMERS === 'true';
