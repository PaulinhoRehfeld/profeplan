import React, { useState } from 'react';
import { cleanup, fireEvent, render, screen } from '@testing-library/react';
import '@testing-library/jest-dom/vitest';
import { afterEach, describe, expect, it, vi } from 'vitest';
import { Button, Dialog, Feedback, Field } from '..';

afterEach(cleanup);

describe('UI primitives', () => {
  it('desabilita o botão e informa o estado de carregamento', () => {
    render(
      <Button loading loadingLabel="Salvando planejamento">
        Salvar
      </Button>
    );

    const button = screen.getByRole('button', { name: /Salvando planejamento/i });
    expect(button).toBeDisabled();
    expect(button).toHaveAttribute('aria-busy', 'true');
  });

  it('mantém um botão desabilitado sem acionar seu callback', () => {
    const onClick = vi.fn();
    render(
      <Button disabled onClick={onClick}>
        Continuar
      </Button>
    );

    fireEvent.click(screen.getByRole('button', { name: 'Continuar' }));
    expect(onClick).not.toHaveBeenCalled();
  });

  it('associa label, descrição e erro ao campo', () => {
    render(
      <Field
        label="Nome da atividade"
        description="Use um nome fácil de reconhecer."
        error="Informe o nome da atividade."
      />
    );

    const input = screen.getByRole('textbox', { name: /Nome da atividade/i });
    expect(input).toHaveAttribute('aria-invalid', 'true');
    expect(input).toHaveAccessibleDescription(
      'Use um nome fácil de reconhecer. Informe o nome da atividade.'
    );
    expect(screen.getByRole('alert')).toHaveTextContent('Informe o nome da atividade.');
  });

  it('anuncia feedback de carregamento e erro', () => {
    const { rerender } = render(
      <Feedback
        variant="loading"
        title="Preparando seu conteúdo"
        description="Isso pode levar alguns instantes."
      />
    );
    expect(screen.getByRole('status')).toHaveTextContent('Preparando seu conteúdo');

    rerender(<Feedback variant="error" title="Não foi possível carregar" />);
    expect(screen.getByRole('alert')).toHaveTextContent('Não foi possível carregar');
  });

  it('fecha o diálogo com Escape e restaura o foco', () => {
    const DialogHarness = () => {
      const [open, setOpen] = useState(false);
      return (
        <>
          <button type="button" onClick={() => setOpen(true)}>
            Abrir ajuda
          </button>
          <Dialog open={open} title="Ajuda para planejar" onClose={() => setOpen(false)}>
            <p>Conteúdo do diálogo</p>
          </Dialog>
        </>
      );
    };

    render(<DialogHarness />);
    const trigger = screen.getByRole('button', { name: 'Abrir ajuda' });
    trigger.focus();
    fireEvent.click(trigger);
    expect(screen.getByRole('dialog', { name: 'Ajuda para planejar' })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: 'Fechar' })).toHaveFocus();

    fireEvent.keyDown(document, { key: 'Escape' });
    expect(screen.queryByRole('dialog')).not.toBeInTheDocument();
    expect(trigger).toHaveFocus();
  });
});
