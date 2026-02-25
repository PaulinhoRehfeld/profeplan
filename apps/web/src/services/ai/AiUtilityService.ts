import { SYSTEM_PROMPT } from "../../constants";
import { GENERATION_MODELS, getGenAIClient } from "./AiCore";

/**
 * Extrai contexto de Ensino Médio (1ANO, 2ANO, 3ANO) e Disciplina
 * Suporta o padrão pedido: 1ANO_EM_MATÉRIA (implícito na mensagem do usuário)
 */
export function extractHighSchoolContext(message: string): { grade: string, subject: string | null } | null {
    const normalized = message.toUpperCase(); // Normaliza para facilitar

    // 1. Detecta Série (1ANO, 2ANO, 3ANO ou variações 1º Ano, etc)
    let grade: string | null = null;
    if (normalized.includes('1ANO') || normalized.includes('1º ANO') || normalized.includes('1 ANO') || normalized.includes('PRIMEIRO ANO')) grade = '1ANO';
    else if (normalized.includes('2ANO') || normalized.includes('2º ANO') || normalized.includes('2 ANO') || normalized.includes('SEGUNDO ANO')) grade = '2ANO';
    else if (normalized.includes('3ANO') || normalized.includes('3º ANO') || normalized.includes('3 ANO') || normalized.includes('TERCEIRO ANO')) grade = '3ANO';

    // Se não achou série mas tem menção explícita a Ensino Médio, podemos tentar inferir ou retornar null
    // O usuário pediu especificamente para interpretar arquivos "1ANO_EM_MATÉRIA", então o foco é quando TEM série.
    if (!grade) return null;

    // 2. Tenta extrair disciplina comum
    const subjects = [
        'MATEMATICA', 'MATEMÁTICA', 'PORTUGUES', 'PORTUGUÊS', 'HISTORIA', 'HISTÓRIA',
        'GEOGRAFIA', 'BIOLOGIA', 'FISICA', 'FÍSICA', 'QUIMICA', 'QUÍMICA',
        'FILOSOFIA', 'SOCIOLOGIA', 'INGLES', 'INGLÊS', 'ARTES', 'EDUCACAO FISICA'
    ];

    let subject: string | null = null;
    for (const s of subjects) {
        if (normalized.includes(s)) {
            subject = s.replace('Á', 'A').replace('É', 'E').replace('Í', 'I').replace('Ó', 'O').replace('Ú', 'U').replace('Ç', 'C').replace('Ã', 'A').replace('Õ', 'O').replace('Ê', 'E'); // Normaliza para busca simples (sem acento)
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
            role: "system" as const,
            content: instruction,
        },
        {
            role: "user" as const,
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
        typeof contentResp === "string"
            ? contentResp
            : (contentResp as any[] | undefined)?.map((c) => (typeof c === "string" ? c : c.text || "")).join("") ?? "";

    return text;
};

export const speakPedagogicalText = async (text: string) => {
    console.log("TTS solicitado para:", text);
};

/**
 * [CLASS_PARSER_MODE]
 * Extrai Nome da Turma, Disciplina e Lista de Alunos em formato JSON a partir do texto bruto do PDF.
 * Padrão otimizado para listas escolares do formato: "EE PROFESSOR ANTÔNIO LAGO - SRE DIAMANTINA"
 */
export const parseClassListFromText = async (rawText: string) => {
    const client = getGenAIClient();

    const instruction = `Age como um assistente administrativo escolar especializado em processar listas de chamada.
  
  INSTRUÇÕES DE EXTRAÇÃO:
  1. METADADOS: Identifique palavras-chave como "Turma:", "Componente Curricular:", "Componente:", "Disciplina:" no topo do documento.
  2. IDENTIFICAÇÃO DE ALUNOS: Procure por listas que contenham Nomes e Códigos/Matrículas.
  3. LIMPEZA: Ignore cabeçalhos repetitivos.
  4. PADRÃO: Extraia o Nome Completo e o ID (se houver, geralmente numérico).
  
  Retorna APENAS um JSON puro, sem markdown, no seguinte formato:
  { 
    "className": "Nome da Turma (ex: 1° EM REG 5)", 
    "subject": "Disciplina (ex: SOCIOLOGIA)", 
    "students": [
        { "name": "NOME DO ALUNO 1", "id": "12345" },
        { "name": "NOME DO ALUNO 2", "id": null }
    ]
  }`;

    const messages = [
        {
            role: "system" as const,
            content: instruction,
        },
        {
            role: "user" as const,
            content: `Extraia desta lista escolar: o nome da turma, a disciplina/matéria e a lista completa de alunos.
  
  Para cada aluno, tente extrair o NOME e o ID (Matrícula/Código) se disponível.
  O ID geralmente é um número grande ao lado do nome.
  
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
        typeof contentResp === "string"
            ? contentResp
            : (contentResp as any[] | undefined)?.map((c) => (typeof c === "string" ? c : c.text || "")).join("") ?? "";

    // Tenta extrair o JSON se houver blocos de markdown em volta
    try {
        const jsonMatch = responseText.match(/\{[\s\S]*\}/);
        if (jsonMatch) {
            return JSON.parse(jsonMatch[0]);
        }
        return JSON.parse(responseText);
    } catch (e) {
        console.error("Erro ao parsear JSON da IA:", responseText);
        throw new Error("Não foi possível processar a lista escolar. Verifique se o PDF contém nomes de alunos legíveis.");
    }
};

