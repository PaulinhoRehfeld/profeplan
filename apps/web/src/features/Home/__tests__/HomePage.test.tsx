import React from 'react';
import { cleanup, fireEvent, render, screen } from '@testing-library/react';
import '@testing-library/jest-dom/vitest';
import { afterEach, describe, expect, it, vi } from 'vitest';
import { ToolMode, UserProfile, UserSession } from '../../../types';
import HomePage from '../HomePage';

afterEach(cleanup);

const session: UserSession = {
  id: 'teacher-1',
  email: 'professora@escola.edu.br',
  role: 'TEACHER',
  accessLevel: 'GOLD',
  isLoggedIn: true,
};

const teacherProfile: UserProfile = {
  id: 'teacher-1',
  email: session.email,
  role: 'teacher',
  school_id: 'school-1',
  school_name: 'Escola Horizonte',
  tier: 'GOLD',
  credits: 100,
  is_unlimited: false,
  is_admin: false,
  allowed_features: [],
  full_name: 'Marina Souza',
};

describe('HomePage', () => {
  it('renderiza a saudação, contexto e ações principais com nomes acessíveis', () => {
    render(<HomePage setActiveMode={vi.fn()} userProfile={teacherProfile} session={session} />);

    expect(screen.getByRole('heading', { name: 'Olá, Marina' })).toBeInTheDocument();
    expect(screen.getByText('Escola atual: Escola Horizonte')).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /Criar plano de aula/i })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /Planejamento trimestral/i })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /Criar avaliação/i })).toBeInTheDocument();
  });

  it.each([
    [/Criar plano de aula/i, ToolMode.PLANNING],
    [/Planejamento trimestral/i, ToolMode.QUARTERLY_PLANNING],
    [/Criar avaliação/i, ToolMode.ASSESSMENT],
    [/Assistente pedagógico/i, ToolMode.CHAT],
    [/Simulados ENEM e Saeb/i, ToolMode.SIMULATION],
    [/Apresentações e slides/i, ToolMode.PRESENTATIONS],
    [/Meus arquivos/i, ToolMode.FILES],
    [/Minhas turmas/i, ToolMode.CLASSES],
    [/Meus documentos/i, ToolMode.MY_DOCUMENTS],
  ])('preserva o callback da ação %s', (accessibleName, expectedMode) => {
    const setActiveMode = vi.fn();
    render(
      <HomePage setActiveMode={setActiveMode} userProfile={teacherProfile} session={session} />
    );

    fireEvent.click(screen.getByRole('button', { name: accessibleName }));
    expect(setActiveMode).toHaveBeenCalledWith(expectedMode);
  });

  it('aciona a inclusão por teclado', () => {
    const setActiveMode = vi.fn();
    render(
      <HomePage setActiveMode={setActiveMode} userProfile={teacherProfile} session={session} />
    );
    const button = screen.getByRole('button', { name: /Abrir PDI e DUA/i });

    button.focus();
    fireEvent.keyDown(button, { key: 'Enter', code: 'Enter' });
    fireEvent.click(button);
    expect(button).toHaveFocus();
    expect(setActiveMode).toHaveBeenCalledWith(ToolMode.INCLUSION);
  });

  it('preserva a regra de exibição da gestão escolar', () => {
    const { rerender } = render(
      <HomePage setActiveMode={vi.fn()} userProfile={teacherProfile} session={session} />
    );
    expect(screen.queryByRole('button', { name: /Gestão escolar/i })).not.toBeInTheDocument();

    rerender(
      <HomePage
        setActiveMode={vi.fn()}
        userProfile={{ ...teacherProfile, role: 'manager' }}
        session={session}
      />
    );
    expect(screen.getByRole('button', { name: /Gestão escolar/i })).toBeInTheDocument();
  });
});
