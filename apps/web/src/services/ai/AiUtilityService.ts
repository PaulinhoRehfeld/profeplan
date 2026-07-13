import { SYSTEM_PROMPT } from '../../constants';
import { GENERATION_MODELS, getGenAIClient } from './AiCore';

/**
 * Extrai contexto de Ensino Médio (1ANO, 2ANO, 3ANO) e Disciplina
 * Suporta o padrão pedido: 1ANO_EM_MATÉRIA (implícito na mensagem do usuário)
 */
export function extractHighSchoolContext(
  message: string
): { grade: string; subject: string | null } | null {
  const normalized = message.toUpperCase(); // Normaliza para facilitar

  // 1. Detecta Série (1ANO, 2ANO, 3ANO ou variações 1º Ano, etc)
  let grade: string | null = null;
  if (
    normalized.includes('1ANO') ||
    normalized.includes('1º ANO') ||
    normalized.includes('1 ANO') ||
    normalized.includes('PRIMEIRO ANO')
  )
    grade = '1ANO';
  else if (
    normalized.includes('2ANO') ||
    normalized.includes('2º ANO') ||
    normalized.includes('2 ANO') ||
    normalized.includes('SEGUNDO ANO')
  )
    grade = '2ANO';
  else if (
    normalized.includes('3ANO') ||
    normalized.includes('3º ANO') ||
    normalized.includes('3 ANO') ||
    normalized.includes('TERCEIRO ANO')
  )
    grade = '3ANO';

  // Se não achou série mas tem menção explícita a Ensino Médio, podemos tentar inferir ou retornar null
  // O usuário pediu especificamente para interpretar arquivos "1ANO_EM_MATÉRIA", então o foco é quando TEM série.
  if (!grade) return null;

  // 2. Tenta extrair disciplina comum
  const subjects = [
    'MATEMATICA',
    'MATEMÁTICA',
    'PORTUGUES',
    'PORTUGUÊS',
    'HISTORIA',
    'HISTÓRIA',
    'GEOGRAFIA',
    'BIOLOGIA',
    'FISICA',
    'FÍSICA',
    'QUIMICA',
    'QUÍMICA',
    'FILOSOFIA',
    'SOCIOLOGIA',
    'INGLES',
    'INGLÊS',
    'ARTES',
    'EDUCACAO FISICA',
  ];

  let subject: string | null = null;
  for (const s of subjects) {
    if (normalized.includes(s)) {
      subject = s
        .replace('Á', 'A')
        .replace('É', 'E')
        .replace('Í', 'I')
        .replace('Ó', 'O')
        .replace('Ú', 'U')
        .replace('Ç', 'C')
        .replace('Ã', 'A')
        .replace('Õ', 'O')
        .replace('Ê', 'E'); // Normaliza para busca simples (sem acento)
      break;
    }
  }

  return { grade, subject };
}

export const generateCanvaData = async (content: string) => {
  const client = getGenAIClient();
  const instruction = `${SYSTEM_PROMPT}`;

  const messages = [
    {
      role: 'system' as const,
      content: instruction,
    },
    {
      role: 'user' as const,
      content: `[CANVA_ARCHITECT]
  Analise o conteúdo abaixo e gere a TABELA DE DADOS (CSV) para o Canva:
  
  ${content}`,
    },
  ];

  const completion = await client.chat.completions.create({
    model: GENERATION_MODELS[0],
    messages,
    temperature: 0.3,
  } as any);

  const contentResp = completion.choices[0]?.message?.content as any;
  const text =
    typeof contentResp === 'string'
      ? contentResp
      : ((contentResp as any[] | undefined)
          ?.map((c) => (typeof c === 'string' ? c : c.text || ''))
          .join('') ?? '');

  return text;
};

export const speakPedagogicalText = async (text: string) => {
  console.log('TTS solicitado para:', text);
};

/**
 * [CLASS_PARSER_MODE]
 * Extrai Nome da Turma, Disciplina e Lista de Alunos em formato JSON a partir do texto bruto do PDF.
 * Padrão otimizado para listas escolares do formato: "EE PROFESSOR ANTÔNIO LAGO - SRE DIAMANTINA"
 */
export const parseClassListFromText = async (rawText: string) => {
  const client = getGenAIClient();

  const normalizeText = (value: string) =>
    value
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .toUpperCase()
      .replace(/\s+/g, ' ')
      .trim();

  const lines = rawText
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter(Boolean);

  const classLine = lines.find((line) => normalizeText(line).includes('TURMA:'));
  const subjectLine = lines.find(
    (line) =>
      normalizeText(line).includes('COMPONENTE:') ||
      normalizeText(line).includes('DISCIPLINA:') ||
      normalizeText(line).includes('COMPONENTE CURRICULAR:')
  );

  const extractClassName = () => {
    if (!classLine) return null;
    const normalized = normalizeText(classLine);
    const match = normalized.match(
      /TURMA:\s*(?:TURNO:\s*)?(?:PROFESSOR:\s*)?(\d+)\s*-\s*(.+?)(?:\s*-\s*|\s+)(?:\(\d{4}\))?/i
    );
    if (match) return match[2].replace(/\s+/g, ' ').trim();
    const afterTurma = classLine.split('Turma:')[1];
    if (!afterTurma) return null;
    const cleaned = afterTurma
      .replace(/TURNO:.*$/i, '')
      .replace(/PROFESSOR:.*$/i, '')
      .trim();
    const parts = cleaned.split(' - ');
    return parts.length >= 2 ? parts[1].trim() : cleaned;
  };

  const extractSubject = () => {
    if (!subjectLine) return null;
    const cleaned = subjectLine.split(':').pop()?.trim();
    return cleaned ? cleaned.replace(/\s+/g, ' ').trim() : null;
  };

  const parsedStudentsFromText = lines
    .map((line) => {
      const match = line.match(/^(\d+)\s+(\d+)\s+(.+)$/);
      if (!match) return null;

      const call_number = parseInt(match[1], 10);
      const student_code = match[2];
      const name = match[3].trim();

      // Evita capturar linhas de cabeçalho/rodapé como aluno
      if (!name || /NOME\s+CAMPO\s+LIVRE|PAG\.|--\s*\d+\s+OF\s+\d+\s*--/i.test(name)) {
        return null;
      }

      return { name, student_code, call_number };
    })
    .filter(Boolean) as Array<{ name: string; student_code?: string; call_number?: number }>;

  // Se conseguimos extrair alunos diretamente do texto, não dependemos da IA para os alunos.
  if (parsedStudentsFromText.length > 0) {
    return {
      className: extractClassName() || 'Turma não identificada',
      subject: extractSubject() || 'Disciplina não identificada',
      students: parsedStudentsFromText,
    };
  }

  const instruction = `Age como um assistente administrativo escolar especializado em processar listas de chamada.
  
  INSTRUÇÕES DE EXTRAÇÃO:
  1. METADADOS DA TURMA:
     - Identifique palavras-chave como "Turma:", "Componente Curricular:", "Componente:", "Disciplina:" no topo do documento.
     - Extraia:
       - Nome da Turma (ex: "1º EM REG 5").
       - Disciplina (ex: "SOCIOLOGIA").
  2. IDENTIFICAÇÃO DE ALUNOS:
     - Procure pela tabela/lista com os alunos.
     - Para cada linha de aluno, extraia:
       - Número na chamada (sequencial da lista), quando existir.
       - Código/Matrícula do aluno (campo numérico típico do SIMADE), quando existir.
       - Nome completo do aluno.
       - Campo "Observações" ou texto equivalente, quando existir na mesma linha ou coluna.
  3. LIMPEZA:
     - Ignore cabeçalhos repetitivos, rodapés, numeração de página e textos que não representem alunos.
  4. FORMATO DE SAÍDA:
     - Retorne APENAS um JSON puro, sem markdown, no seguinte formato:
       {
         "className": "Nome da Turma (ex: 1° EM REG 5)",
         "subject": "Disciplina (ex: SOCIOLOGIA)",
         "students": [
           {
             "name": "NOME COMPLETO DO ALUNO 1",
             "student_code": "CÓDIGO OU MATRÍCULA DO ALUNO (string, opcional)",
             "call_number": 1,
             "observations": "Texto de observações/inclusão (opcional)"
           },
           {
             "name": "NOME COMPLETO DO ALUNO 2",
             "student_code": "1234567",
             "call_number": 2,
             "observations": ""
           }
         ]
       }
  5. IMPORTANTE:
     - SEMPRE retorne "students" como um array de objetos, mesmo que alguns campos fiquem vazios.
     - Não inclua comentários, texto fora do JSON ou blocos de markdown.`;

  const messages = [
    {
      role: 'system' as const,
      content: instruction,
    },
    {
      role: 'user' as const,
      content: `Extraia desta lista escolar: o nome da turma, a disciplina/matéria e a lista completa de alunos.
  
  Use como referência o padrão:
  "1 8319292 CARLOS EDUARDO MACEDO BARBOSA"
  onde:
  - o primeiro número é o número da chamada;
  - o segundo número é o código/matrícula do aluno;
  - o restante é o nome completo.
  
  Para a array "students", retorne objetos com name, student_code e call_number.
  
  CONTEÚDO DO PDF:
  ${rawText}`,
    },
  ];

  const completion = await client.chat.completions.create({
    model: GENERATION_MODELS[0],
    messages,
    temperature: 0.2,
  } as any);

  const contentResp = completion.choices[0]?.message?.content as any;
  const responseText =
    typeof contentResp === 'string'
      ? contentResp
      : ((contentResp as any[] | undefined)
          ?.map((c) => (typeof c === 'string' ? c : c.text || ''))
          .join('') ?? '');

  // Tenta extrair o JSON se houver blocos de markdown em volta
  try {
    const jsonMatch = responseText.match(/\{[\s\S]*\}/);
    const raw = jsonMatch ? jsonMatch[0] : responseText;
    const parsed = JSON.parse(raw);

    // Pós-processamento defensivo da lista de alunos:
    // - Se a IA retornou strings do tipo "1 8319292 NOME...",
    //   convertemos para objetos { call_number, student_code, name }.
    if (Array.isArray(parsed?.students)) {
      parsed.students = parsed.students.map((s: any) => {
        if (typeof s === 'object' && s !== null) {
          return s; // já está enriquecido
        }

        const line = String(s).trim();
        const match = line.match(/^(\d+)\s+(\d+)\s+(.+)$/);
        if (match) {
          const callNumber = parseInt(match[1], 10);
          const studentCode = match[2];
          const name = match[3].trim();
          return {
            name,
            student_code: studentCode,
            call_number: Number.isNaN(callNumber) ? undefined : callNumber,
          };
        }

        // fallback: só nome
        return {
          name: line,
        };
      });
    }

    return {
      className: parsed.className || extractClassName() || 'Turma não identificada',
      subject: parsed.subject || extractSubject() || 'Disciplina não identificada',
      students: Array.isArray(parsed.students) ? parsed.students : [],
    };
  } catch (e) {
    console.error('Erro ao parsear JSON da IA:', responseText);
    throw new Error(
      'Não foi possível processar a lista escolar. Verifique se o PDF contém nomes de alunos legíveis.'
    );
  }
};
