import React from 'react';
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { render, screen, waitFor, fireEvent } from '@testing-library/react';
import ImportProcess from '../ImportProcess';

const mockParseClassListFromText = vi.fn();

vi.mock('../../../services/ai/AiUtilityService', () => ({
  parseClassListFromText: (...args: any[]) => mockParseClassListFromText(...args),
}));

const mockExtractTextFromPdf = vi.fn();

vi.mock('../../../services/pdfService', () => ({
  extractTextFromPdf: (...args: any[]) => mockExtractTextFromPdf(...args),
}));

const createPdfFile = (name = 'lista.pdf') =>
  new File(['dummy'], name, { type: 'application/pdf' });

describe('ImportProcess', () => {
  beforeEach(() => {
    mockParseClassListFromText.mockReset();
    mockExtractTextFromPdf.mockReset();
  });

  it('mostra estados de carregamento e pré-visualização com contagem correta de alunos (happy path)', async () => {
    const file = createPdfFile();
    const onCancel = vi.fn();
    const onComplete = vi.fn().mockResolvedValue(undefined);

    mockExtractTextFromPdf.mockResolvedValueOnce('RAW_TEXT');
    mockParseClassListFromText.mockResolvedValueOnce({
      className: '1 EM REG 5',
      subject: 'SOCIOLOGIA',
      students: [
        { name: 'ALUNO 1', student_code: '111', call_number: 1 },
        { name: 'ALUNO 2', student_code: '222', call_number: 2 },
      ],
    });

    render(<ImportProcess file={file} onCancel={onCancel} onComplete={onComplete} />);

    expect(
      screen.getByText(/Lendo PDF da Lista/i),
    ).toBeInTheDocument();

    await waitFor(() =>
      expect(
        screen.getByText(/Turma Encontrada!/i),
      ).toBeInTheDocument(),
    );

    expect(
      screen.getByText(/Encontramos 2 alunos/i),
    ).toBeInTheDocument();

    fireEvent.click(
      screen.getByRole('button', { name: /Confirmar e Salvar/i }),
    );

    await waitFor(() => expect(onComplete).toHaveBeenCalledTimes(1));

    const payload = onComplete.mock.calls[0][0];
    expect(payload.students).toHaveLength(2);
    expect(payload.students[0].student_code).toBe('111');
    expect(payload.students[0].call_number).toBe(1);
  });

  it('mostra erro amigável quando o arquivo não é PDF', async () => {
    const file = new File(['dummy'], 'lista.txt', { type: 'text/plain' });
    const onCancel = vi.fn();
    const onComplete = vi.fn();

    render(<ImportProcess file={file} onCancel={onCancel} onComplete={onComplete} />);

    await waitFor(() =>
      expect(
        screen.getByText(/Por favor, selecione um arquivo PDF./i),
      ).toBeInTheDocument(),
    );
  });

  it('propaga erro de parsing e exibe mensagem ao usuário', async () => {
    const file = createPdfFile();
    const onCancel = vi.fn();
    const onComplete = vi.fn();

    mockExtractTextFromPdf.mockResolvedValueOnce('RAW_TEXT');
    mockParseClassListFromText.mockRejectedValueOnce(
      new Error('Não foi possível processar a lista escolar. Verifique se o PDF contém nomes de alunos legíveis.'),
    );

    render(<ImportProcess file={file} onCancel={onCancel} onComplete={onComplete} />);

    await waitFor(() =>
      expect(
        screen.getByText(/Não foi possível processar a lista escolar. Verifique se o PDF contém nomes de alunos legíveis./i),
      ).toBeInTheDocument(),
    );
  });
});

