import { supabase } from '../supabaseClient';

export type GovernedCreditBalance = {
  user_id?: string;
  tier?: string;
  unlimited: boolean;
  total: number;
  free_trial?: number;
  purchased?: number;
  promotional_bonus?: number;
  admin_adjustment?: number;
  legacy_balance?: number;
  next_expiry?: string | null;
  as_of?: string;
};

const normalizeBalance = (value: unknown): GovernedCreditBalance => {
  if (!value || typeof value !== 'object') {
    throw new Error('Resposta inválida ao consultar saldo governado.');
  }

  const raw = value as Record<string, unknown>;
  const total = Number(raw.total);

  if (!Number.isFinite(total) || total < 0) {
    throw new Error('Saldo governado inválido.');
  }

  return {
    ...(raw as GovernedCreditBalance),
    total,
    unlimited: raw.unlimited === true,
  };
};

export const getMyGovernedCreditBalance = async (): Promise<GovernedCreditBalance> => {
  const { data, error } = await supabase.rpc('credit_get_my_balance');
  if (error) throw error;
  return normalizeBalance(data);
};
