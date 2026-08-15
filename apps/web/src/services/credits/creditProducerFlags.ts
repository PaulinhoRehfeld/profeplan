export const isGovernedCreditProducerEnabled = (): boolean =>
  import.meta.env.VITE_GOVERNED_CREDIT_PRODUCERS === 'true';
