import React from 'react';
import { fireEvent, render, screen, waitFor } from '@testing-library/react';
import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest';
import type { UserProfile } from '../../../../types';

const mocks = vi.hoisted(() => ({
  addUserCredits: vi.fn(),
}));

vi.mock('../../../../services/ProfileService', () => ({
  addUserCredits: mocks.addUserCredits,
}));

import { AddCreditsModal } from '../AddCreditsModal';

describe('AddCreditsModal - governed admin adjustment idempotency', () => {
  const user = {
    id: 'user-1',
    email: 'teacher@example.invalid',
    credits: 10,
    tier: 'SILVER',
    is_unlimited: false,
  } as UserProfile;

  beforeEach(() => {
    vi.resetAllMocks();
    vi.stubEnv('VITE_GOVERNED_CREDIT_PRODUCERS', 'true');
    vi.spyOn(window, 'alert').mockImplementation(() => undefined);
  });

  afterEach(() => {
    vi.unstubAllEnvs();
    vi.restoreAllMocks();
  });

  it('reutiliza o mesmo operation id após erro de transporte e retry exato', async () => {
    mocks.addUserCredits
      .mockResolvedValueOnce({ error: { message: 'timeout' } })
      .mockResolvedValueOnce({ data: { success: true }, error: null });

    render(<AddCreditsModal isOpen user={user} onClose={vi.fn()} onCreditsAdded={vi.fn()} />);

    fireEvent.click(screen.getByRole('button', { name: 'Confirmar' }));
    await waitFor(() => expect(mocks.addUserCredits).toHaveBeenCalledTimes(1));

    const firstOperationId = mocks.addUserCredits.mock.calls[0][2] as string;
    expect(firstOperationId).toMatch(/^admin-adjustment-ui-v1:/);

    await waitFor(() => expect(screen.getByRole('button', { name: 'Confirmar' })).toBeTruthy());
    fireEvent.click(screen.getByRole('button', { name: 'Confirmar' }));
    await waitFor(() => expect(mocks.addUserCredits).toHaveBeenCalledTimes(2));

    expect(mocks.addUserCredits.mock.calls[1][2]).toBe(firstOperationId);
  });
});
