import React from 'react';
import { fireEvent, render, screen, waitFor } from '@testing-library/react';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';

const mocks = vi.hoisted(() => ({
  getSession: vi.fn(),
}));

vi.mock('../../../../services/supabaseClient', () => ({
  supabase: {
    auth: {
      getSession: mocks.getSession,
    },
  },
}));

import { CreateUserModal } from '../CreateUserModal';

const renderModal = () =>
  render(
    <CreateUserModal isOpen onClose={vi.fn()} onUserCreated={vi.fn()} allSchools={[]} cities={[]} />
  );

describe('CreateUserModal - governed initial credit authority', () => {
  beforeEach(() => {
    vi.resetAllMocks();
    mocks.getSession.mockResolvedValue({ data: { session: { access_token: 'admin-token' } } });
    vi.stubGlobal(
      'fetch',
      vi.fn().mockResolvedValue({
        ok: true,
        json: async () => ({ success: true, userId: 'new-user' }),
      })
    );
  });

  afterEach(() => {
    vi.unstubAllEnvs();
    vi.unstubAllGlobals();
  });

  it('omite credits e informa autoridade do ledger com produtores governados', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_PRODUCERS', 'true');
    const { container } = renderModal();

    const emailInput = container.querySelector('input[type="email"]') as HTMLInputElement;
    fireEvent.change(emailInput, { target: { value: 'novo@example.invalid' } });

    expect(screen.getByText(/Créditos iniciais são geridos pelo ledger/i)).toBeTruthy();
    expect(container.querySelector('input[type="number"]')).toBeNull();

    fireEvent.click(screen.getByRole('button', { name: 'Criar Usuário' }));

    await waitFor(() => expect(fetch).toHaveBeenCalledTimes(1));
    const request = vi.mocked(fetch).mock.calls[0][1] as RequestInit;
    const payload = JSON.parse(String(request.body)) as Record<string, unknown>;

    expect(payload.email).toBe('novo@example.invalid');
    expect(payload).not.toHaveProperty('credits');
  });

  it('preserva credits=10 no payload legado quando a flag está OFF', async () => {
    vi.stubEnv('VITE_GOVERNED_CREDIT_PRODUCERS', 'false');
    const { container } = renderModal();

    const emailInput = container.querySelector('input[type="email"]') as HTMLInputElement;
    fireEvent.change(emailInput, { target: { value: 'legado@example.invalid' } });

    expect(container.querySelector('input[type="number"]')).not.toBeNull();
    fireEvent.click(screen.getByRole('button', { name: 'Criar Usuário' }));

    await waitFor(() => expect(fetch).toHaveBeenCalledTimes(1));
    const request = vi.mocked(fetch).mock.calls[0][1] as RequestInit;
    const payload = JSON.parse(String(request.body)) as Record<string, unknown>;

    expect(payload.credits).toBe(10);
  });
});
