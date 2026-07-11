import { describe, it, expect, vi, beforeEach } from 'vitest';
import { parseClassListFromText } from '../AiUtilityService';
import * as AiCore from '../AiCore';

// supabaseClient.ts lança erro no import se as env vars não estiverem definidas
// (CI não tem VITE_SUPABASE_URL/ANON_KEY configuradas para o step de testes) —
// AiCore real (via vi.importActual abaixo) importa sessionService, que importa
// o client. Mockado aqui para não depender de credenciais reais.
vi.mock('../../supabaseClient', () => ({
  supabase: { auth: { getSession: vi.fn().mockResolvedValue({ data: { session: null }, error: null }) } },
}));

// Mock do cliente de IA para não fazer chamadas reais
const mockChatCompletionsCreate = vi.fn();

vi.mock('../AiCore', async () => {
  const actual = await vi.importActual<typeof AiCore>('../AiCore');
  return {
    ...actual,
    getGenAIClient: () => ({
      chat: {
        completions: {
          create: mockChatCompletionsCreate,
        },
      },
    }),
  };
});

describe('parseClassListFromText', () => {
  beforeEach(() => {
    mockChatCompletionsCreate.mockReset();
  });

  it('deve extrair turma, disciplina e alunos diretamente do texto SIMADE (happy path)', async () => {
    const rawText = `
EE PROFESSOR ANTÔNIO LAGO - SRE DIAMANTINA
Turma: 1 EM REG 5 - 2024
Componente: SOCIOLOGIA

1 8319292 CARLOS EDUARDO MACEDO BARBOSA
2 7312345 ANA MARIA DE SOUZA
3 7011122 JOÃO DA SILVA
`;

    const result = await parseClassListFromText(rawText);

    // Não afirmamos o nome exato da turma aqui porque o parser pode
    // variar na extração do trecho após "Turma:"; focamos nos alunos.
    expect(result.subject.toUpperCase()).toContain('SOCIOLOGIA');
    expect(result.students).toHaveLength(3);

    const first = result.students[0] as any;
    expect(first.call_number).toBe(1);
    expect(first.student_code).toBe('8319292');
    expect(first.name).toBe('CARLOS EDUARDO MACEDO BARBOSA');

    expect(mockChatCompletionsCreate).not.toHaveBeenCalled();
  });

  it('deve lidar com linhas parciais, deixando student_code/call_number vazios quando não presentes', async () => {
    const rawText = `
Turma: 1 EM REG 5 - 2024
Disciplina: MATEMÁTICA

1 8319292 CARLOS COMPLETO
SEM CODIGO NOME APENAS
3 7011122 JOÃO COMPLETO
`;

    const result = await parseClassListFromText(rawText);

    expect(result.students).toHaveLength(2);

    const [first, second] = result.students as any[];
    expect(first.student_code).toBe('8319292');
    expect(first.call_number).toBe(1);

    expect(second.student_code).toBe('7011122');
    expect(second.call_number).toBe(3);
  });

  it('deve delegar à IA quando não encontrar nenhum aluno diretamente e normalizar resposta JSON', async () => {
    const rawText = `
RELATÓRIO QUALQUER SEM PADRÃO NUMÉRICO
NENHUMA LINHA COM "N CODIGO NOME"
`;

    mockChatCompletionsCreate.mockResolvedValueOnce({
      choices: [
        {
          message: {
            content: JSON.stringify({
              className: '1 EM REG 5',
              subject: 'HISTÓRIA',
              students: [
                '1 8319292 CARLOS COMPLETO',
                {
                  name: 'ANA MARIA',
                  student_code: '7312345',
                  call_number: 2,
                },
              ],
            }),
          },
        },
      ],
    });

    const result = await parseClassListFromText(rawText);

    expect(result.className).toBe('1 EM REG 5');
    // Normalizamos acentos tornando a asserção imune a variação da IA.
    expect(result.subject.normalize('NFD').replace(/[\u0300-\u036f]/g, '').toUpperCase()).toContain('HISTORIA');
    expect(result.students).toHaveLength(2);

    const [first, second] = result.students as any[];
    expect(first.call_number).toBe(1);
    expect(first.student_code).toBe('8319292');
    expect(first.name).toBe('CARLOS COMPLETO');

    expect(second.call_number).toBe(2);
    expect(second.student_code).toBe('7312345');
    expect(second.name).toBe('ANA MARIA');
  });

  it('deve lançar erro claro quando a IA retornar JSON inválido', async () => {
    const rawText = `
TEXTO SEM PADRÃO E COM FALHA DE IA
`;

    mockChatCompletionsCreate.mockResolvedValueOnce({
      choices: [
        {
          message: {
            content: 'resposta não-json qualquer',
          },
        },
      ],
    });

    await expect(parseClassListFromText(rawText)).rejects.toThrow(
      'Não foi possível processar a lista escolar. Verifique se o PDF contém nomes de alunos legíveis.',
    );
  });
});

