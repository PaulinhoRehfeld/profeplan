import React from 'react';
import { cleanup, fireEvent, render, screen } from '@testing-library/react';
import '@testing-library/jest-dom/vitest';
import { afterEach, describe, expect, it, vi } from 'vitest';
import { MessageRole } from '../../../../types';
import { CleanChat } from '../CleanChat';

vi.mock('../../../../components/QuestionFinder/QuestionSearchWidget', () => ({
  QuestionSearchWidget: () => <div>Busca de questões</div>,
}));

afterEach(cleanup);

const baseProps = {
  messages: [],
  isThinking: false,
  input: '',
  setInput: vi.fn(),
  handleSendMessage: vi.fn(),
  handleClearChat: vi.fn(),
  messagesEndRef: { current: null },
};

describe('CleanChat', () => {
  it('oferece sugestões e preserva o callback de preenchimento', () => {
    const setInput = vi.fn();
    render(<CleanChat {...baseProps} setInput={setInput} />);

    fireEvent.click(screen.getByRole('button', { name: /Criar plano de aula/i }));
    expect(setInput).toHaveBeenCalledWith(expect.stringContaining('plano de aula completo'));
  });

  it('mantém o envio desabilitado sem conteúdo e informa seu nome', () => {
    render(<CleanChat {...baseProps} />);
    expect(screen.getByRole('button', { name: 'Enviar mensagem' })).toBeDisabled();
    expect(
      screen.getByRole('textbox', { name: 'Mensagem para o assistente pedagógico' })
    ).toBeInTheDocument();
  });

  it('preserva salvar, exportar e limpar uma resposta', () => {
    const onSave = vi.fn();
    const onExport = vi.fn();
    const handleClearChat = vi.fn();
    const content =
      'Um plano de aula detalhado com objetivos, metodologia, recursos e avaliação para a turma.';

    render(
      <CleanChat
        {...baseProps}
        messages={[
          { id: 'message-1', role: MessageRole.ASSISTANT, content, timestamp: new Date() },
        ]}
        onSave={onSave}
        onExport={onExport}
        handleClearChat={handleClearChat}
      />
    );

    fireEvent.click(screen.getByRole('button', { name: 'Salvar' }));
    fireEvent.click(screen.getByRole('button', { name: 'Baixar DOCX' }));
    fireEvent.click(screen.getByRole('button', { name: 'Limpar conversa' }));

    expect(onSave).toHaveBeenCalledWith(content);
    expect(onExport).toHaveBeenCalledWith(content);
    expect(handleClearChat).toHaveBeenCalledTimes(1);
  });

  it('anuncia o estado de geração', () => {
    render(<CleanChat {...baseProps} isThinking />);
    expect(screen.getByRole('status')).toHaveTextContent('Preparando uma resposta pedagógica');
  });
});
