import { GoogleGenerativeAI, HarmBlockThreshold, HarmCategory } from "@google/generative-ai";
import { SYSTEM_PROMPT, SYSTEM_PROMPT_CHAT } from "../constants";
import { AccessLevel } from "../types";
import { fetchEnemQuestions } from "./databaseService";
import { getTeacherContext } from "./supabaseService";
import { checkUsageQuota, incrementUserUsage } from "./userService";
import { hybridSearchProfeplan } from "./searchService";


// Utilitários de áudio internos (PCM decoding)
function decode(base64: string) {
  const binaryString = atob(base64);
  const len = binaryString.length;
  const bytes = new Uint8Array(len);
  for (let i = 0; i < len; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }
  return bytes;
}

async function decodeAudioData(
  data: Uint8Array,
  ctx: AudioContext,
  sampleRate: number,
  numChannels: number,
): Promise<AudioBuffer> {
  const dataInt16 = new Int16Array(data.buffer);
  const frameCount = dataInt16.length / numChannels;
  const buffer = ctx.createBuffer(numChannels, frameCount, sampleRate);

  for (let channel = 0; channel < numChannels; channel++) {
    const channelData = buffer.getChannelData(channel);
    for (let i = 0; i < frameCount; i++) {
      channelData[i] = dataInt16[i * numChannels + channel] / 32768.0;
    }
  }
  return buffer;
}

const safetySettings = [
  { category: HarmCategory.HARM_CATEGORY_HARASSMENT, threshold: HarmBlockThreshold.BLOCK_ONLY_HIGH },
  { category: HarmCategory.HARM_CATEGORY_HATE_SPEECH, threshold: HarmBlockThreshold.BLOCK_ONLY_HIGH },
  { category: HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT, threshold: HarmBlockThreshold.BLOCK_ONLY_HIGH },
  { category: HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT, threshold: HarmBlockThreshold.BLOCK_ONLY_HIGH },
];

/**
 * Extrai contexto de Ensino Médio (1ANO, 2ANO, 3ANO) e Disciplina
 * Suporta o padrão pedido: 1ANO_EM_MATÉRIA (implícito na mensagem do usuário)
 */
function extractHighSchoolContext(message: string): { grade: string, subject: string | null } | null {
  const normalized = message.toUpperCase(); // Normaliza para facilitar

  // 1. Detecta Série (1ANO, 2ANO, 3ANO ou variações 1º Ano, etc)
  let grade = null;
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

  let subject = null;
  for (const s of subjects) {
    if (normalized.includes(s)) {
      subject = s.replace('Á', 'A').replace('É', 'E').replace('Í', 'I').replace('Ó', 'O').replace('Ú', 'U').replace('Ç', 'C').replace('Ã', 'A').replace('Õ', 'O').replace('Ê', 'E'); // Normaliza para busca simples (sem acento)
      break;
    }
  }

  return { grade, subject };
}

export const generateProfePlanStream = async (
  message: string,
  history: { role: string; parts: { text: string }[] }[],
  mode: string,
  imagePart?: { inlineData: { data: string; mimeType: string } },
  audioPart?: { inlineData: { data: string; mimeType: string } }, // Mantido interface, mas pode não ser usado
  userAccessLevel?: AccessLevel,
  userId?: string
) => {
  // Inicialização Simples com a Chave de API
  const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();

  if (!apiKey) {
    throw new Error("A chave de API (VITE_GEMINI_API_KEY) não foi encontrada no arquivo .env. Verifique se o arquivo .env existe na raiz do projeto e se a chave está configurada corretamente.");
  }

  const genAI = new GoogleGenerativeAI(apiKey);

  // Configuração da instrução do sistema base
  // [MODIFICAÇÃO V3.2]: O Chat Geral usa SYSTEM_PROMPT_CHAT (com fallback).
  // Agentes especializados (Quarterly, Planning) mantêm SYSTEM_PROMPT (estrito/RAG only).
  const basePrompt = (mode === 'quarterly' || mode === 'planning') ? SYSTEM_PROMPT : SYSTEM_PROMPT_CHAT;
  let specificInstruction = `${basePrompt}\n\n[MODO ATIVO]: ${mode.toUpperCase()}`;



  // Injeção de Memória (Teacher Context)
  if (userId) {
    try {
      const { recentLessons, preferences } = await getTeacherContext(userId);

      if (preferences || (recentLessons && recentLessons.length > 0)) {
        const preferred_tone = preferences?.preferred_tone || 'não definido';
        const recentLessons_list = recentLessons && recentLessons.length > 0
          ? recentLessons.map((l: any, i: number) => `Aula ${i + 1}: ${l.topic}\nConteúdo: ${l.content.substring(0, 500)}...`).join('\n\n')
          : 'Nenhuma aula anterior disponível.';

        specificInstruction += `\n\nVocê deve seguir o estilo das aulas anteriores do professor (se houver) e respeitar o tom preferido: ${preferred_tone}. Aqui estão exemplos de aulas passadas para referência: ${recentLessons_list}`;
      }
    } catch (e) {
      console.warn("Falha ao recuperar Memória do Professor:", e);
    }
  }

  // [REGRA DE OURO] Busca Automática de Questões para Ensino Médio
  const context = extractHighSchoolContext(message);

  if (context) {
    console.log(`🔍 Detectado contexto de Ensino Médio: ${context.grade} - ${context.subject}`);
    try {
      // Usa a mensagem do usuário + contexto extraído
      const searchResults = await hybridSearchProfeplan({
        textoBusca: message,
        limit: 3,
        matchThreshold: 0.5,
        // Passa os filtros para o Supabase (que deve suportar ou ignorar se null)
        // O formato '1ANO' é passado como 'nivel' se a RPC suportar, ou concatenado na busca
        nivel: context.grade,     // Ex: "1ANO"
        disciplina: context.subject // Ex: "BIOLOGIA"
      });

      if (searchResults && searchResults.length > 0) {
        specificInstruction += `\n\n[DADOS DO BUSCADOR (SISTEMA INTEGRADO)]:\nEncontrei estas questões relevantes no banco vetorial (Filtro: ${context.grade}/${context.subject}). Selecione as melhores para integrar ao plano:\n${JSON.stringify(searchResults)}`;
      } else {
        console.log('🔍 Busca retornou 0 resultados.');
      }
    } catch (searchError) {
      console.error('⚠️ Falha na busca automática de questões:', searchError);
    }
  }

  if (mode === 'quarterly') {
    specificInstruction += `\n\n[DIRETRIZ DE PLANEJAMENTO]: Você está gerando um Planejamento Trimestral.
    
    PROTOCOLO DE ENTREVISTA (OBRIGATÓRIO):
    Antes de gerar a tabela final, verifique se o professor forneceu:
    1. Valor total do trimestre e distribuição de pontos.
    2. Datas ou semanas reservadas para provas.
    
    SE FALTAR ALGUMA DESSA INFORMAÇÕES: Não gere o plano ainda. Responda perguntando amigavelmente sobre esses detalhes para personalizar o cronograma.
    
    SE TIVER AS INFORMAÇÕES: Gere a tabela cruzando Semanas x BNCC x Avaliações.
    
    GATILHO ABP: Se o texto conter "PROJETO", estruture como Aprendizagem Baseada em Projetos (Etapas, Entregas, Rubricas).`;
  } else if (mode === 'enem') {
    specificInstruction += `\n\n[DIRETRIZ ENEM]: Você está atuando como um especialista do INEP. A questão deve ser inédita ou adaptada, seguindo a Matriz de Referência.`;

    try {
      const lastUserMessage = history.find(m => m.role === 'user')?.parts[0].text || message;
      const area = lastUserMessage.toLowerCase().includes('matemática') ? 'Matemática' :
        lastUserMessage.toLowerCase().includes('humana') ? 'Ciências Humanas' :
          lastUserMessage.toLowerCase().includes('linguagen') ? 'Linguagens' :
            lastUserMessage.toLowerCase().includes('natureza') ? 'Ciências da Natureza' : null;

      if (area) {
        // Nota: fetchEnemQuestions deve retornar array de objetos com question_text
        const examples = await fetchEnemQuestions(area, undefined, 2);
        if (examples && examples.length > 0) {
          specificInstruction += `\n\n[EXEMPLOS DE QUESTÕES DO BANCO]:\n${JSON.stringify(examples.map(q => q.question_text))}`;
        }
      }
    } catch (e) {
      console.warn("Falha ao buscar questões ENEM:", e);
    }
  } else if (mode === 'presentations') {
    specificInstruction += `\n\n[DIRETRIZ DE APRESENTAÇÃO]:
    O usuário quer transformar conteúdo em SLIDES.
    ESTRUTURA DE SAÍDA (MARKDOWN):
    Use headers (##) para cada Slide.
    
    Exemplo:
    ## Slide 1: Título 
    - Tópico A
    - Tópico B
    [Imagem Sugerida]: Descrição visual
    
    Gere 8 a 10 slides. Seja sintético e visual.`;
  }
  // A chave nova suporta modelos 2.0+. Configurando para o 2.0 Flash estável.
  const model = genAI.getGenerativeModel({
    model: "gemini-1.5-flash",
    systemInstruction: specificInstruction,
    safetySettings
  });

  // Convertendo histórico para o formato do SDK generative-ai
  // O SDK novo usa { role: 'user' | 'model', parts: [{ text: '...' }] }
  // Verificando compatibilidade: history já está nesse formato

  const chat = model.startChat({
    history: history.map(h => ({
      role: h.role,
      parts: h.parts
    })),
    generationConfig: {
      temperature: 0.8,
    }
  });

  // Montando a mensagem atual
  const currentParts: any[] = [];
  if (message) currentParts.push({ text: message });
  if (imagePart) currentParts.push(imagePart);
  // audioPart ignorado nesta versão simples para garantir estabilidade, ou adaptar se suportado

  // Check Quota
  if (userId) {
    const quotaStatus = await checkUsageQuota(userId);
    if (!quotaStatus.allowed) {
      throw new Error(quotaStatus.message);
    }
  }

  try {
    const result = await chat.sendMessageStream(currentParts);

    // Increment Usage only after stream starts successfully
    if (userId) {
      await incrementUserUsage(userId);
    }

    // Adaptador para garantir compatibilidade com o App.tsx que espera chunk.text
    async function* streamAdapter() {
      for await (const chunk of result.stream) {
        const chunkText = chunk.text();
        yield { text: chunkText };
      }
    }

    return streamAdapter();
  } catch (error: any) {
    console.error("Erro na Chamada do Gemini API:", error);
    throw error;
  }
};

export const generateCanvaData = async (content: string) => {
  const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();
  if (!apiKey) throw new Error("API Key missing");

  const genAI = new GoogleGenerativeAI(apiKey);
  const instruction = `${SYSTEM_PROMPT}`;

  const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash", systemInstruction: instruction, safetySettings });

  const userMessage = `[CANVA_ARCHITECT]
  Analise o conteúdo abaixo e gere a TABELA DE DADOS (CSV) para o Canva:
  
  ${content}`;

  const result = await model.generateContent(userMessage);
  return result.response.text();
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
  const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();
  if (!apiKey) throw new Error("API Key missing");

  const genAI = new GoogleGenerativeAI(apiKey);

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

  const model = genAI.getGenerativeModel({
    model: "gemini-1.5-flash",
    systemInstruction: instruction
  });

  const prompt = `Extraia desta lista escolar: o nome da turma, a disciplina/matéria e a lista completa de alunos.
  
  Para cada aluno, tente extrair o NOME e o ID (Matrícula/Código) se disponível.
  O ID geralmente é um número grande ao lado do nome.
  
  CONTEÚDO DO PDF:
  ${rawText}`;

  const result = await model.generateContent(prompt);
  const responseText = result.response.text();

  // Tenta extrair o JSON se houver blocos de markdown em volta
  try {
    const jsonMatch = responseText.match(/\{[\s\S]*\}/);
    if (jsonMatch) {
      return JSON.parse(jsonMatch[0]);
    }
    return JSON.parse(responseText);
  } catch (e) {
    console.error("Erro ao parsear JSON do Gemini:", responseText);
    throw new Error("Não foi possível processar a lista escolar. Verifique se o PDF contém nomes de alunos legíveis.");
  }
};

/**
 * [ASSESSMENT_WITH_CONTEXT_MODE]
 * Gera avaliações baseadas no histórico de aulas dadas (Ciclo de Feedback Fechado)
 */
export const generateAssessmentWithContext = async (
  className: string,
  subject: string,
  lessonsContext: any[],
  additionalTopic: string = '',
  academicPeriod: string = '',
  objectiveCount: number = 10,
  dissertativeCount: number = 2,
  numEnem: number = 0,
  difficulty: string = 'Médio'
) => {
  const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();
  if (!apiKey) throw new Error("API Key missing");

  const genAI = new GoogleGenerativeAI(apiKey);

  const lessonsToReference = lessonsContext.map((lesson, i) =>
    `Aula ${i + 1}: ${lesson.topic}\nConteúdo: ${lesson.content?.substring(0, 500)}...`
  ).join('\n\n');

  const instruction = `Age como um Professor Avaliador Pedagógico do PROFEPLAN.
  
  OBJETIVO: Gerar uma avaliação oficial, coerente e contextualizada.
  
  CONTEXTO DAS AULAS DADAS:
  ${lessonsToReference || 'Nenhuma aula anterior disponível como base.'}
  
  ASSUNTO ESPECÍFICO ADICIONAL:
  ${additionalTopic || 'Nenhum'}
  
  PERÍODO LETIVO: ${academicPeriod}
  
  ESTRUTURA DA AVALIAÇÃO:
  - ${objectiveCount} questões OBJETIVAS baseadas nas aulas contextuais.
  - ${dissertativeCount} questões DISSERTATIVAS (abertas) baseadas nas aulas contextuais.
  - ${numEnem} questões ESTILO ENEM: Devem ser SEMPRE OBJETIVAS (múltipla escolha).
  
  NÍVEL DE DIFICULDADE GERAL: ${difficulty}
  
  REGRAS TÉCNICAS:
  1. Todas as questões OBJETIVAS (Contextuais e ENEM) devem ter EXATAMENTE 5 alternativas (A, B, C, D, E).
  2. Referência ENEM: Para cada questão estilo ENEM, comece o enunciado com a referência entre colchetes, ex: "[ENEM 2022] ...", "[ENEM 2023] ...".
  3. Coerência Pedagógica: As questões contextuais devem focar no que foi ensinado nas aulas fornecidas.
  4. Matriz ENEM: As questões estilo ENEM devem abordar competências oficiais no nível ${difficulty}.
  5. Formato: Retorne um JSON puro para ser processado pelo sistema.
  6. Gabarito: Inclua a resposta correta para objetivas e rubrica para dissertativas.
  
  Retorne APENAS um JSON puro:
  {
    "title": "Título da Avaliação (Ex: Avaliação de ${subject} - ${academicPeriod})",
    "questions": [
      {
        "id": "q1",
        "type": "objective",
        "question": "[ENEM 2023] Enunciado...",
        "options": ["A) ...", "B) ...", "C) ...", "D) ...", "E) ..."],
        "correctAnswer": "A",
        "maxPoints": 1,
        "difficulty": "${difficulty}"
      },
      {
        "id": "q2",
        "type": "dissertative",
        "question": "Enunciado aberto...",
        "rubric": "Critérios: 1. Explicação do conceito (X pts)...",
        "maxPoints": 10,
        "difficulty": "${difficulty}"
      }
    ]
  }`;

  const model = genAI.getGenerativeModel({
    model: "gemini-1.5-flash",
    systemInstruction: instruction
  });

  const prompt = `Crie uma avaliação de ${subject} para a turma ${className}, referente ao ${academicPeriod}.`;
  const result = await model.generateContent(prompt);
  const responseText = result.response.text();

  try {
    const jsonMatch = responseText.match(/\{[\s\S]*\}/);
    if (jsonMatch) {
      return JSON.parse(jsonMatch[0]);
    }
    return JSON.parse(responseText);
  } catch (e) {
    console.error("Erro ao parsear JSON da avaliação:", responseText);
    throw new Error("Não foi possível gerar a avaliação. Tente novamente.");
  }
};

/**
 * [GRADING_MODE - Gemini Vision]
 * Corrige questões dissertativas via OCR + Análise Pedagógica
 */
export const gradeWrittenAnswer = async (
  questionText: string,
  rubric: string,
  imageBase64: string // Foto da resposta escrita
) => {
  const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();
  if (!apiKey) throw new Error("API Key missing");

  const genAI = new GoogleGenerativeAI(apiKey);

  const instruction = `Age como um Professor Corretor Pedagógico.
  
  TAREFA: Corrigir uma questão dissertativa escrita à mão.
  
  PASSOS:
  1. Leia a escrita do aluno (OCR)
  2. Compare com a RUBRICA de correção
  3. Atribua uma nota de 0 a 10
  4. Dê um FEEDBACK PEDAGÓGICO construtivo
  
  Retorne APENAS um JSON:
  {
    "studentAnswer": "Texto extraído da imagem",
    "score": 7.5,
    "maxScore": 10,
    "feedback": "Você demonstrou compreensão de X, mas faltou mencionar Y..."
  }`;

  const model = genAI.getGenerativeModel({
    model: "gemini-1.5-flash",
    systemInstruction: instruction
  });

  const prompt = `QUESTÃO: ${questionText}\n\nRUBRICA DE CORREÇÃO:\n${rubric}\n\nAgora analise a resposta escrita do aluno na imagem.`;

  const result = await model.generateContent([
    { text: prompt },
    {
      inlineData: {
        data: imageBase64.split(',')[1] || imageBase64,
        mimeType: 'image/jpeg'
      }
    }
  ]);

  const responseText = result.response.text();

  try {
    const jsonMatch = responseText.match(/\{[\s\S]*\}/);
    if (jsonMatch) {
      return JSON.parse(jsonMatch[0]);
    }
    return JSON.parse(responseText);
  } catch (e) {
    console.error("Erro ao parsear resultado de correção:", responseText);
    throw new Error("Não foi possível processar a correção. Tente novamente.");
  }
};

/**
 * [PRESENTATION_MODE - Structured JSON]
 * Gera roteiro de slides estruturado em JSON para o módulo de Apresentações
 */
export const generatePresentationJSON = async (
  topic: string,
  context: string,
  slideCount: number,
  style: string,
  includeInteractions: boolean
) => {
  const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();
  if (!apiKey) throw new Error("API Key missing");

  const genAI = new GoogleGenerativeAI(apiKey);

  const instruction = `Age como um Designer Instrucional e Especialista em Apresentações Visuais.

  OBJETIVO: Criar um roteiro de apresentação de alto impacto, estruturado em JSON.

  PARÂMETROS:
  - TEMA/ASSUNTO: ${topic}
  - CONTEXTO/AULA BASE: ${context || 'Criar do zero'}
  - QUANTIDADE DE SLIDES: Aprox. ${slideCount}
  - ESTILO VISUAL: ${style}
  - INCLUIR INTERAÇÕES: ${includeInteractions ? 'Sim (Perguntas, Enquetes, Reflexões)' : 'Não (Apenas conteúdo)'}

  ESTRUTURA DO JSON DE SAÍDA:
  Retorne APENAS um JSON com a seguinte estrutura:
  {
    "title": "Título Criativo da Apresentação",
    "theme": "${style}",
    "slides": [
      {
        "order": 1,
        "type": "capa" | "conteudo" | "interacao" | "conclusao",
        "title": "Título do Slide",
        "contentBulletPoints": ["Tópico 1", "Tópico 2", "Tópico 3"],
        "imageSuggestion": "Descrição visual detalhada para IA generativa de imagens",
        "speakerNotes": "Roteiro do que o professor deve falar neste slide"
      }
    ]
  }

  DIRETRIZES DE CONTEÚDO:
  1. Seja sintético nos bullet points (regra 6x6).
  2. Use linguagem adequada ao estilo visual escolhido.
  3. Se interações estiverem ativadas, insira pelo menos 1 slide de "interacao" a cada 3-4 slides de conteúdo.
  4. As 'imageSuggestion' devem ser prompts artísticos e descritivos.
  `;

  const model = genAI.getGenerativeModel({
    model: "gemini-1.5-flash",
    systemInstruction: instruction,
    generationConfig: { responseMimeType: "application/json" }
  });

  const prompt = `Gere o roteiro da apresentação sobre: ${topic}`;

  try {
    const result = await model.generateContent(prompt);
    const text = result.response.text();
    return JSON.parse(text);
  } catch (e) {
    console.error("Erro ao gerar slides:", e);
    throw new Error("Falha ao gerar o roteiro da apresentação.");
  }
};

const GENERATION_MODELS = [
  "gemini-2.0-flash",
  "gemini-2.0-flash-lite-preview-02-05",
  "gemini-flash-latest",
  "gemini-2.0-flash-exp",
];

async function executeWithFallback<T>(
  actionName: string,
  operation: (modelName: string) => Promise<T>
): Promise<T> {
  let lastError: any;

  for (const modelName of GENERATION_MODELS) {
    try {
      console.log(`[Gemini] Tentando modelo: ${modelName} para ${actionName}...`);
      return await operation(modelName);
    } catch (error: any) {
      console.warn(`[Gemini] Falha no modelo ${modelName}:`, error.message);
      lastError = error;
      // Se for erro de cota ou rate limit, talvez não adiante trocar de modelo imediatamente se a chave for a mesma,
      // mas se for erro de "modelo não encontrado" ou "sobrecarregado", trocar ajuda.
      // Vamos tentar o próximo.
    }
  }

  throw new Error(`Todas as tentativas de modelo falharam para ${actionName}. Último erro: ${lastError?.message}`);
}

/**
 * [PDI_MODE]
 * Gera uma adaptação PDI/DUA para um aluno específico baseada em uma aula original.
 */
export const generateStudentAdaptation = async (
  originalContent: string,
  studentName: string,
  deficiencies: string[],
  observations: string,
  gradeLevel: string,
  context?: { stateBase?: string; educationSphere?: string; userId?: string }
) => {
  const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();
  if (!apiKey) throw new Error("API Key missing");

  // Check Quota
  if (context?.userId) {
    const quotaStatus = await checkUsageQuota(context.userId);
    if (!quotaStatus.allowed) {
      throw new Error(quotaStatus.message);
    }
  }

  const genAI = new GoogleGenerativeAI(apiKey);

  const prompt = `
    ATUE COMO UM ESPECIALISTA EM INCLUSÃO E DESENHO UNIVERSAL PARA APRENDIZAGEM (DUA).
    
    AULA ORIGINAL:
    "${originalContent.substring(0, 3000)}"
    
    PERFIL DO ALUNO:
    Nome: ${studentName}
    Série: ${gradeLevel}
    Necessidades/Diagnósticos: ${deficiencies.join(', ')}
    Observações do Professor: ${observations}
    ${context?.stateBase ? `CONTEXTO CURRICULAR:\n    Base: ${context.stateBase} (${context.educationSphere || 'Geral'})` : ''}
    
    TAREFA:
    Crie uma adaptação desta aula especificamente para o aluno.
    
    RETORNE APENAS O CONTEÚDO ADAPTADO NO SEGUINTE FORMATO MARKDOWN:
    
    ## 🎯 Objetivos Adaptados
    (Liste 2-3 objetivos focais para este aluno)
    
    ## 🛠️ Estratégias de Acesso
    (Como o aluno vai acessar o conteúdo? Ex: texto fatiado, apoio visual, áudio...)
    
    ## 📝 Atividade Adaptada
    (A atividade reescrita para o perfil dele)
    
    ## 📏 Avaliação Diferenciada
    (Como verificar o aprendizado dele nesta aula)
    `;

  return executeWithFallback('StudentAdaptation', async (modelName) => {
    const model = genAI.getGenerativeModel({ model: modelName });
    const result = await model.generateContent(prompt);
    const response = await result.response;

    // Increment Usage only on success
    if (context?.userId) {
      await incrementUserUsage(context.userId); // Fire and forget or await? Safe to wait.
    }

    return response.text();
  });
};


/**
 * [PDI_REPORT_MODE]
 * Gera um Relatório Bimestral de PDI baseado nos logs de adaptação.
 */
export const generatePdiReport = async (logs: any[], studentName: string, period: string) => {
  const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();
  if (!apiKey) throw new Error("API Key missing");

  const genAI = new GoogleGenerativeAI(apiKey);

  // Sintetiza os logs para não estourar o contexto
  const logsSummary = logs.map(l => `- Em ${new Date(l.created_at).toLocaleDateString()}: Adaptação focada em ${l.content?.substring(0, 100) || 'Conteúdo adaptado'}...`).join('\n');

  const prompt = `
    ATUE COMO UM ESPECIALISTA EM EDUCAÇÃO ESPECIAL E INCLUSIVA COM 20 ANOS DE EXPERIÊNCIA EM ESCRITA DE LAUDOS E RELATÓRIOS DE PDI.
    
    DADOS DO ALUNO: ${studentName}
    PERÍODO: ${period}
    
    HISTÓRICO DE ADAPTAÇÕES REALIZADAS (LOGS DO SISTEMA):
    ${logsSummary}
    
    TAREFA:
    Escreva um relatório técnico-pedagógico narrativo, pronto para ser assinado e entregue à coordenação ou aos pais.
    
    ESTRUTURA OBRIGATÓRIA:
    1. Cabeçalho Institucional (Identificação e Contexto): Mencione o período letivo e base curricular.
    2. Desenvolvimento (Ações de Adaptação): Transforme os logs em parágrafos narrativos e fluidos. NÃO USE LISTAS OU MARCADORES. Exemplo: "Durante o trabalho com Frações, a estratégia de manipulação de objetos concretos foi fundamental...". Use termos técnicos como "fragmentação de comandos", "suportes visuais", "flexibilização".
    3. Síntese de Engajamento e Conclusão: Destaque os avanços e a importância da manutenção das adaptações.
    
    REGRAS DE FORMATAÇÃO:
    - Texto corrido (prosa), sem bullet points.
    - Tom formal, acolhedor e técnico.
    - Sem cabeçalhos Markdown (##), use apenas negrito para dar ênfase se necessário.
    `;

  const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

  try {
    const result = await model.generateContent(prompt);
    const response = await result.response;
    return response.text();
  } catch (error) {
    throw error;
  }
};

import { searchCurriculum } from "./searchService"; // Import at top if possible, but here for tool scope
// NOTE: Ensure this import is actually at the top of the file in real usage. 
// Since replace_file_content replaces a block, I should add the logic inside the function.

export const generateTermPlan = async (
  context: {
    subject: string;
    grade: string;
    period: number;
    regime: string;
    stateBase: string;
    educationSphere: string;
    teacherName: string;
    totalClasses: number;
    reserves: any;
    userId?: string;
    level?: string;
    feedback?: string;
  }
) => {
  const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();
  if (!apiKey) throw new Error("API Key missing");

  // Check Quota
  if (context.userId) {
    const quotaStatus = await checkUsageQuota(context.userId);
    if (!quotaStatus.allowed) {
      throw new Error(quotaStatus.message);
    }
  }

  // --- RAG: Busca Curricular ---
  let curriculumContext = "";
  try {
    // 1. Normalização do Ano/Nível (Crucial para o BUG do usuário)
    const num = context.grade.replace(/\D/g, ''); // Extract '2' from '2º Ano'
    let normalizedGrade = `${num}º Ano`;
    if (context.level === 'Ensino Médio') {
      normalizedGrade = `${num}º Ano EM`;
    }

    // 2. Normalização da Disciplina (Básico para bater com ingestão)
    let normalizedSubject = context.subject;
    const s = context.subject.toLowerCase();
    if (s.includes('historia') || s.includes('história')) normalizedSubject = 'História';
    if (s.includes('matematica') || s.includes('matemática')) normalizedSubject = 'Matemática';
    if (s.includes('portugues') || s.includes('português')) normalizedSubject = 'Língua Portuguesa';
    if (s.includes('ingles') || s.includes('inglês')) normalizedSubject = 'Língua Inglesa';
    if (s.includes('geografia')) normalizedSubject = 'Geografia';
    if (s.includes('biologia')) normalizedSubject = 'Biologia';
    if (s.includes('fisica') || s.includes('física')) normalizedSubject = 'Física';
    if (s.includes('quimica') || s.includes('química')) normalizedSubject = 'Química';
    if (s.includes('filosofia')) normalizedSubject = 'Filosofia';
    if (s.includes('sociologia')) normalizedSubject = 'Sociologia';
    if (s.includes('artes')) normalizedSubject = 'Artes';


    const periodString = `${context.period}º ${context.regime}`; // Ex: "1º Bimestre"

    console.log(`🔍 Buscando currículo para: ${normalizedSubject}, ${normalizedGrade}, ${periodString}`);

    // 3. Busca com Filtros
    // Import searchCurriculum dynamincally or assume it's imported at top. 
    // Since I cannot change top of file easily without reading all, I will use valid import in previous step or here.
    // Wait, I can't import inside function in TS mostly. I will assume it is available or fix imports separately.
    // Ideally I should have added the import at the top. 
    // I Will handle extraction of logic below.

    // Using searchCurriculum imported from searchService
    const results = await searchCurriculum(
      `Planejamento e Habilidades de ${normalizedSubject} para ${normalizedGrade} no ${periodString}`,
      {
        disciplina: normalizedSubject,
        ano: normalizedGrade,
        periodo: periodString
      },
      5 // Top 5 chunks (usually enough for a term)
    );

    if (results && results.length > 0) {
      curriculumContext = results.map((r: any) => r.content).join('\n\n---\n\n');
      console.log(`✅ Encontrados ${results.length} trechos de currículo.`);
    } else {
      console.warn("⚠️ Nenhum currículo encontrado no banco para estes filtros.");
    }

  } catch (err) {
    console.error("Erro na busca RAG:", err);
  }

  const genAI = new GoogleGenerativeAI(apiKey);
  const prompt = `
    Atue como um Coordenador Pedagógico especialista em BNCC e currículos locais.
    Gere um "MAPA DE PLANEJAMENTO DE AULA/2026" completo.

    DADOS DO CONTEXTO:
    - Estado (Base Curricular): ${context.stateBase}
    - Esfera: ${context.educationSphere}
    - Professor: ${context.teacherName}
    - Componente: ${context.subject}
    - Nível de Ensino: ${context.level || 'Não especificado'}
    - Ano/Série: ${context.grade}
    - Período: ${context.period}º ${context.regime}
    - Total de Aulas: ${context.totalClasses}

    [DADOS DO CURRÍCULO OFICIAL]:
    ${curriculumContext ? curriculumContext : "Use a BNCC geral."}
    
    ${context.feedback ? `
    [ATENÇÃO: FEEDBACK DO PROFESSOR (PRIORIDADE CRÍTICA)]
    O professor solicitou o seguinte ajuste no plano anterior:
    "${context.feedback}"
    
    INSTRUÇÃO DE REGENERAÇÃO:
    Ignore qualquer regra anterior que conflite com este pedido. O feedback do professor é soberano. Recrie o plano incorporando esta mudança imediatamente.
    ` : ''}
    ---------------------------------------------------

    TAREFA:
    Gere um documento Markdown BEM FORMATADO que servirá como a única fonte da verdade.
    
    ESTRUTURA OBRIGATÓRIA (Siga exatamente os cabeçalhos para que o sistema possa ler):

    # PLANEJAMENTO DE ENSINO - ${context.subject.toUpperCase()}

    ## 1. Dados Gerais
    Breve resumo do contexto...

    ## 2. Competências e Habilidades
    Liste as principais...

    ## 3. Cronograma de Aulas
    [SISTEMA: CADA AULA DEVE TER SEU PRÓPRIO CABEÇALHO "### Aula X: Título"]

    ### Aula 1: [Título da Aula]
    **Descrição:**
    Detalhe da metodologia, início, meio e fim.
    **Objetivos:**
    - Objetivo 1
    - Objetivo 2
    **BNCC:**
    - CODI01
    - CODI02

    ### Aula 2: [Título da Aula]
    ...

    ...

    ### Aula ${context.totalClasses}: [Encerramento/Prova]
    ...

    ## 4. Avaliação
    Critérios de avaliação...
  `;

  return executeWithFallback('TermPlan', async (modelName) => {
    const model = genAI.getGenerativeModel({
      model: modelName,
      // REMOVED JSON MODE: We want rich Markdown text
    });

    const result = await model.generateContent(prompt);
    const text = result.response.text();

    // Increment Usage only on success
    if (context.userId) {
      await incrementUserUsage(context.userId);
    }

    return text; // Return raw Markdown
  });
};

// --- ADAPTADORES ---

import { Message } from "../types"; // Import Message type if not already available or redeclare if simple
// Note: Message is in ../types, but we are in services folder.
// Let's assume we can use 'any' for history to avoid circle dependency if needed, or import properly.
// But wait, replace_file_content replaces a block.
// I will just append it.

/**
 * [SIMPLE_CHAT_ADAPTER]
 * Versão simplificada para o PlanningManager que espera uma Promise<string>
 * em vez de stream.
 */
export const generateGeminiContent = async (
  prompt: string,
  history: any[] = [],
  context: string = '',
  userId?: string,
  temperature: number = 0.7 // Default to creative
) => {
  const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();
  if (!apiKey) throw new Error("API Key missing");

  const genAI = new GoogleGenerativeAI(apiKey);

  // Constrói o histórico no formato Gemini
  const chatHistory = history.map(msg => ({
    role: msg.role === 'user' ? 'user' : 'model',
    parts: [{ text: msg.content }]
  }));

  const systemInstruction = `${SYSTEM_PROMPT} \n\n[CONTEXTO ATUAL]: ${context} `;

  const model = genAI.getGenerativeModel({
    model: "gemini-1.5-flash",
    systemInstruction: systemInstruction
  });

  const chat = model.startChat({
    history: chatHistory,
    generationConfig: {
      temperature: temperature
    }
  });

  // Check Quota
  if (userId) {
    const quota = await checkUsageQuota(userId);
    if (!quota.allowed) throw new Error(quota.message);
  }

  const result = await chat.sendMessage(prompt);
  const response = result.response.text();


  if (userId) await incrementUserUsage(userId);

  return response;
};

/**
 * [PDI_BLOCK_9_MODE]
 * Gera adaptação curricular automática (Bloco 9 do PDI) quando professor salva planejamento.
 * Usa o contexto dos Blocos 1-8 do PDI como base de conhecimento.
 */
export const generateBlock9Adaptation = async (
  lessonContent: string,
  lessonTitle: string,
  subject: string,
  gradeLevel: string,
  habilidadesBncc: string[],
  studentPdiContext: {
    nome_completo: string;
    diagnostico_clinico?: string;
    necessidades_especificas?: string[];
    potencialidades?: string[];
    desafios?: string[];
    objetivo_geral?: string;
    recursos_tecnologicos?: string[];
    materiais_adaptados?: string[];
  },
  userId?: string
): Promise<{
  adaptacao_metodologica: string;
  recursos_adaptados: string[];
  objetivos_adaptados: string[];
  estrategias_ensino: string[];
  tempo_estimado?: string;
}> => {
  const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();
  if (!apiKey) throw new Error("API Key missing");

  // Check Quota
  if (userId) {
    const quotaStatus = await checkUsageQuota(userId);
    if (!quotaStatus.allowed) {
      throw new Error(quotaStatus.message);
    }
  }

  const genAI = new GoogleGenerativeAI(apiKey);

  const prompt = `
ATUE COMO UM ESPECIALISTA EM INCLUSÃO ESCOLAR E DESENHO UNIVERSAL PARA APRENDIZAGEM (DUA).

CONTEXTO:
Um professor acabou de salvar um planejamento de aula. O sistema deve AUTOMATICAMENTE gerar uma adaptação curricular para um aluno com PDI ativo.

DADOS DA AULA ORIGINAL:
Título: ${lessonTitle}
Disciplina: ${subject}
Série: ${gradeLevel}
Conteúdo: ${lessonContent.substring(0, 2500)}
Habilidades BNCC: ${habilidadesBncc.join(', ')}

PERFIL DO ALUNO (BLOCOS 1-8 DO PDI):
Nome: ${studentPdiContext.nome_completo}
Diagnóstico: ${studentPdiContext.diagnostico_clinico || 'Não especificado'}
Necessidades Específicas: ${studentPdiContext.necessidades_especificas?.join(', ') || 'Não especificadas'}
Potencialidades: ${studentPdiContext.potencialidades?.join(', ') || 'Não especificadas'}
Desafios: ${studentPdiContext.desafios?.join(', ') || 'Não especificados'}
Objetivo Geral do PDI: ${studentPdiContext.objetivo_geral || 'Não especificado'}
Recursos Disponíveis: ${studentPdiContext.recursos_tecnologicos?.join(', ') || 'Padrão'}
Materiais Adaptados: ${studentPdiContext.materiais_adaptados?.join(', ') || 'Nenhum especificado'}

TAREFA:
Gere uma ADAPTAÇÃO CURRICULAR ESPECÍFICA desta aula para este aluno, seguindo os princípios do DUA:
1. ACESSO: Como o aluno vai acessar o conteúdo (múltiplas formas de representação)
2. ENGAJAMENTO: Como motivar e manter o interesse
3. EXPRESSÃO: Como o aluno vai demonstrar aprendizado (múltiplas formas de ação/expressão)

IMPORTANTE:
- NÃO simplifique o currículo a ponto de perder os objetivos da BNCC
- MANTENHA o rigor acadêmico, mas MUDE a forma de acesso e expressão
- Use os recursos e materiais disponíveis listados no PDI
- Seja ESPECÍFICO e APLICÁVEL na sala de aula

FORMATO DE SAÍDA (JSON PURO):
Retorne APENAS um JSON válido com a seguinte estrutura:
{
  "adaptacao_metodologica": "Descrição narrativa detalhada de como a aula será adaptada metodologicamente para este aluno. Inclua início, meio e fim. Mínimo 150 palavras, máximo 400 palavras.",
  "recursos_adaptados": ["Recurso 1 específico", "Recurso 2 específico", "Recurso 3 específico"],
  "objetivos_adaptados": ["Objetivo 1 mantendo rigor BNCC", "Objetivo 2 mantendo rigor BNCC"],
  "estrategias_ensino": ["Estratégia 1 baseada em DUA", "Estratégia 2 baseada em DUA", "Estratégia 3 baseada em DUA"],
  "tempo_estimado": "Tempo previsto para esta adaptação (ex: '50 minutos', '2 aulas de 45min')"
}

REGRAS TÉCNICAS:
- Todos os arrays devem ter pelo menos 2 elementos
- A adaptacao_metodologica deve ser um texto narrativo, não lista
- Os objetivos_adaptados devem citar códigos BNCC quando relevante
- As estrategias_ensino devem ser ações concretas do professor
  `;

  const model = genAI.getGenerativeModel({
    model: "gemini-1.5-flash",
    generationConfig: {
      responseMimeType: "application/json",
      temperature: 0.7
    }
  });

  try {
    const result = await model.generateContent(prompt);
    const text = result.response.text();

    // Increment Usage
    if (userId) {
      await incrementUserUsage(userId);
    }

    const parsed = JSON.parse(text);

    // Validação básica
    if (!parsed.adaptacao_metodologica || !parsed.recursos_adaptados || !parsed.objetivos_adaptados || !parsed.estrategias_ensino) {
      throw new Error("Resposta da IA incompleta");
    }

    return parsed;
  } catch (error) {
    console.error("Erro ao gerar adaptação Bloco 9:", error);
    throw new Error("Não foi possível gerar a adaptação curricular. Tente novamente.");
  }
};

/**
 * [PDI_BLOCK_10_MODE]
 * Gera metodologia e diagnóstico pedagógico para complementar avaliação do professor.
 * Professor preenche: valor, nota, grau de autonomia.
 * IA completa: metodologia utilizada e diagnóstico pedagógico.
 */
export const generateBlock10Diagnosis = async (
  evaluationData: {
    atividade_titulo: string;
    disciplina: string;
    professor_valor: number;
    professor_nota_alcancada: number;
    professor_grau_autonomia: 'total' | 'parcial' | 'dependente';
  },
  fullPdiContext: {
    student_name: string;
    block_1_8: any; // Blocos 1-8 completos
    block_9_history: any[]; // Histórico de adaptações
    block_10_history: any[]; // Histórico de avaliações anteriores
  },
  userId?: string
): Promise<{
  ia_metodologia: string;
  ia_diagnostico: string;
}> => {
  const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();
  if (!apiKey) throw new Error("API Key missing");

  // Check Quota
  if (userId) {
    const quotaStatus = await checkUsageQuota(userId);
    if (!quotaStatus.allowed) {
      throw new Error(quotaStatus.message);
    }
  }

  const genAI = new GoogleGenerativeAI(apiKey);

  // Extrair informações relevantes do contexto
  const diagnostico_inicial = fullPdiContext.block_1_8?.bloco_1_identificacao?.diagnostico_clinico || 'Não especificado';
  const necessidades = fullPdiContext.block_1_8?.bloco_2_diagnostico?.necessidades_especificas || [];
  const potencialidades = fullPdiContext.block_1_8?.bloco_2_diagnostico?.potencialidades || [];
  const desafios = fullPdiContext.block_1_8?.bloco_2_diagnostico?.desafios || [];
  const objetivo_geral = fullPdiContext.block_1_8?.bloco_3_objetivos?.objetivo_geral || '';

  // Resumo de adaptações recentes (últimas 3)
  const adaptacoesRecentes = fullPdiContext.block_9_history
    .slice(-3)
    .map((a: any) => `- ${a.lesson_title}: ${a.adaptacao_metodologica?.substring(0, 150)}...`)
    .join('\n');

  // Resumo de avaliações anteriores (últimas 3)
  const avaliacoesAnteriores = fullPdiContext.block_10_history
    .slice(-3)
    .map((av: any) => {
      const percentual = ((av.professor_nota_alcancada / av.professor_valor) * 100).toFixed(0);
      return `- ${av.atividade_titulo}: ${percentual}% (Autonomia: ${av.professor_grau_autonomia})`;
    })
    .join('\n');

  const percentualAtual = ((evaluationData.professor_nota_alcancada / evaluationData.professor_valor) * 100).toFixed(1);

  const prompt = `
ATUE COMO UM ESPECIALISTA EM AVALIAÇÃO PEDAGÓGICA E EDUCAÇÃO INCLUSIVA.

CONTEXTO:
Um professor registrou uma avaliação para um aluno com PDI. Você deve ANALISAR os dados e gerar:
1. METODOLOGIA: Como foi realizada a avaliação (inferir a partir do contexto)
2. DIAGNÓSTICO PEDAGÓGICO: Análise técnica dos potenciais e desafios observados

DADOS DA AVALIAÇÃO ATUAL:
Atividade: ${evaluationData.atividade_titulo}
Disciplina: ${evaluationData.disciplina}
Valor Total: ${evaluationData.professor_valor} pontos
Nota Alcançada: ${evaluationData.professor_nota_alcancada} pontos (${percentualAtual}%)
Grau de Autonomia: ${evaluationData.professor_grau_autonomia}

CONTEXTO DO ALUNO (PDI COMPLETO):
Nome: ${fullPdiContext.student_name}
Diagnóstico Clínico: ${diagnostico_inicial}
Necessidades Específicas: ${necessidades.join(', ') || 'Nenhuma'}
Potencialidades: ${potencialidades.join(', ') || 'Nenhuma'}
Desafios: ${desafios.join(', ') || 'Nenhum'}
Objetivo Geral do PDI: ${objetivo_geral}

ADAPTAÇÕES CURRICULARES RECENTES (Bloco 9):
${adaptacoesRecentes || 'Nenhuma adaptação registrada ainda'}

HISTÓRICO DE AVALIAÇÕES ANTERIORES (Bloco 10):
${avaliacoesAnteriores || 'Primeira avaliação registrada'}

TAREFA:
Com base em TODOS os dados acima, gere:

1. METODOLOGIA (150-250 palavras):
Descreva de forma narrativa e técnica COMO esta avaliação foi provavelmente realizada. Considere:
- O grau de autonomia registrado
- As adaptações curriculares que vinham sendo aplicadas
- O tipo de atividade e disciplina
- Os recursos disponíveis no PDI

Exemplo de tom: "A avaliação foi conduzida com adaptações metodológicas alinhadas ao DUA, considerando que o estudante apresenta [necessidade]. Foram utilizados recursos como [inferir], e o tempo foi ajustado conforme [inferir]. O suporte do professor foi [total/parcial/mínimo] durante a atividade, evidenciado pelo grau de autonomia [X]."

2. DIAGNÓSTICO PEDAGÓGICO (200-350 palavras):
Analise de forma técnica e objetiva:
- POTENCIAIS: O que o aluno demonstrou saber/conseguir fazer (seja específico)
- DESAFIOS: O que ainda precisa ser trabalhado (seja específico)
- PROGRESSÃO: Compare com avaliações anteriores se houver
- RECOMENDAÇÕES: 2-3 ações concretas para próximas aulas

Use terminologia técnica pedagógica: "zona de desenvolvimento proximal", "andaimes pedagógicos", "transferência de aprendizagem", "metacognição", etc.

FORMATO DE SAÍDA (JSON PURO):
{
  "ia_metodologia": "Texto narrativo descrevendo como a avaliação foi realizada...",
  "ia_diagnostico": "Análise técnica estruturada: Potenciais observados: [...]. Desafios identificados: [...]. Progressão em relação a avaliações anteriores: [...]. Recomendações: [...]"
}

REGRAS:
- Seja ESPECÍFICO e baseado nos DADOS fornecidos
- NÃO invente informações que não estão no contexto
- Use linguagem técnica mas acessível
- Foque em AÇÃO (o que fazer) e não apenas descrição
  `;

  const model = genAI.getGenerativeModel({
    model: "gemini-1.5-flash",
    generationConfig: {
      responseMimeType: "application/json",
      temperature: 0.6 // Mais factual
    }
  });

  try {
    const result = await model.generateContent(prompt);
    const text = result.response.text();

    // Increment Usage
    if (userId) {
      await incrementUserUsage(userId);
    }

    const parsed = JSON.parse(text);

    // Validação
    if (!parsed.ia_metodologia || !parsed.ia_diagnostico) {
      throw new Error("Resposta da IA incompleta");
    }

    return {
      ia_metodologia: parsed.ia_metodologia,
      ia_diagnostico: parsed.ia_diagnostico,
    };
  } catch (error) {
    console.error("Erro ao gerar diagnóstico Bloco 10:", error);
    throw new Error("Não foi possível gerar o diagnóstico pedagógico. Tente novamente.");
  }
};

/**
 * [PDI_BLOCK_11_MODE]
 * Gera relatório final consolidado do PDI, sintetizando todos os blocos anteriores.
 * Usado ao fim do período letivo para documentação oficial.
 */
export const generateBlock11Report = async (
  pdiDocument: {
    student_name: string;
    period: string;
    school_name?: string;
    block_1_8: any;
    block_9_content: any[];
    block_10_entries: any[];
  },
  userId?: string
): Promise<string> => {
  const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();
  if (!apiKey) throw new Error("API Key missing");

  // Check Quota
  if (userId) {
    const quotaStatus = await checkUsageQuota(userId);
    if (!quotaStatus.allowed) {
      throw new Error(quotaStatus.message);
    }
  }

  const genAI = new GoogleGenerativeAI(apiKey);

  // Extrair dados relevantes
  const identificacao = pdiDocument.block_1_8?.bloco_1_identificacao || {};
  const diagnostico = pdiDocument.block_1_8?.bloco_2_diagnostico || {};
  const objetivos = pdiDocument.block_1_8?.bloco_3_objetivos || {};

  // Resumo de adaptações (Bloco 9)
  const totalAdaptacoes = pdiDocument.block_9_content?.length || 0;
  const disciplinasAdaptadas = [...new Set(pdiDocument.block_9_content?.map((a: any) => a.subject) || [])];

  // Resumo de avaliações (Bloco 10)
  const avaliacoes = pdiDocument.block_10_entries || [];
  const mediaGeral = avaliacoes.length > 0
    ? (avaliacoes.reduce((sum: number, av: any) =>
      sum + ((av.professor_nota_alcancada / av.professor_valor) * 100), 0
    ) / avaliacoes.length).toFixed(1)
    : 'N/A';

  // Distribuição de autonomia
  const autonomiaTotal = avaliacoes.filter((av: any) => av.professor_grau_autonomia === 'total').length;
  const autonomiaParcial = avaliacoes.filter((av: any) => av.professor_grau_autonomia === 'parcial').length;
  const autonomiaDependente = avaliacoes.filter((av: any) => av.professor_grau_autonomia === 'dependente').length;

  // Últimas 3 avaliações para análise de evolução
  const ultimasAvaliacoes = avaliacoes.slice(-3).map((av: any) => ({
    atividade: av.atividade_titulo,
    percentual: ((av.professor_nota_alcancada / av.professor_valor) * 100).toFixed(0),
    autonomia: av.professor_grau_autonomia,
    diagnostico: av.ia_diagnostico?.substring(0, 200) + '...',
  }));

  const prompt = `
ATUE COMO UM COORDENADOR PEDAGÓGICO SÊNIOR E ESPECIALISTA EM EDUCAÇÃO INCLUSIVA.

CONTEXTO:
Você está finalizando o PDI (Plano de Desenvolvimento Individual) de um estudante ao final do período letivo. Este documento será lido por:
- Equipe gestora da escola
- Professores do próximo período
- Família do estudante
- Órgãos de supervisão educacional

DADOS DO PDI COMPLETO:

═══════════════════════════════════════════════════════
BLOCO 1: IDENTIFICAÇÃO
═══════════════════════════════════════════════════════
Nome: ${identificacao.nome_completo || pdiDocument.student_name}
Série: ${identificacao.serie || 'Não especificada'}
Diagnóstico Clínico: ${identificacao.diagnostico_clinico || 'Não especificado'}
Período do PDI: ${pdiDocument.period}
${pdiDocument.school_name ? `Instituição: ${pdiDocument.school_name}` : ''}

═══════════════════════════════════════════════════════
BLOCO 2-3: DIAGNÓSTICO INICIAL E OBJETIVOS
═══════════════════════════════════════════════════════
Necessidades Específicas: ${diagnostico.necessidades_especificas?.join(', ') || 'Não especificadas'}
Potencialidades: ${diagnostico.potencialidades?.join(', ') || 'Não especificadas'}
Desafios: ${diagnostico.desafios?.join(', ') || 'Não especificados'}
Objetivo Geral do PDI: ${objetivos.objetivo_geral || 'Não especificado'}

═══════════════════════════════════════════════════════
BLOCO 9: ADAPTAÇÕES CURRICULARES REALIZADAS
═══════════════════════════════════════════════════════
Total de Adaptações: ${totalAdaptacoes}
Disciplinas Contempladas: ${disciplinasAdaptadas.join(', ') || 'Nenhuma'}

Exemplos de Adaptações Recentes:
${pdiDocument.block_9_content?.slice(-3).map((a: any, i: number) =>
    `${i + 1}. ${a.lesson_title} (${a.subject}): ${a.adaptacao_metodologica?.substring(0, 150)}...`
  ).join('\n') || 'Nenhuma adaptação registrada'}

═══════════════════════════════════════════════════════
BLOCO 10: DESEMPENHO E AVALIAÇÕES
═══════════════════════════════════════════════════════
Total de Avaliações: ${avaliacoes.length}
Média Geral de Aproveitamento: ${mediaGeral}%

Distribuição de Autonomia:
- Total (independente): ${autonomiaTotal} avaliações
- Parcial (com apoio): ${autonomiaParcial} avaliações
- Dependente (apoio constante): ${autonomiaDependente} avaliações

Últimas 3 Avaliações (Evolução):
${ultimasAvaliacoes.map((av: any, i: number) =>
    `${i + 1}. ${av.atividade}: ${av.percentual}% (Autonomia: ${av.autonomia})\n   Diagnóstico: ${av.diagnostico}`
  ).join('\n\n') || 'Nenhuma avaliação registrada'}

═══════════════════════════════════════════════════════
TAREFA: GERAR RELATÓRIO FINAL (BLOCO 11)
═══════════════════════════════════════════════════════

Crie um RELATÓRIO TÉCNICO-PEDAGÓGICO NARRATIVO e OFICIAL seguindo esta estrutura obrigatória:

1. INTRODUÇÃO (100-150 palavras)
   - Apresente o estudante e o contexto do PDI
   - Período de vigência
   - Breve resumo do diagnóstico inicial

2. DESENVOLVIMENTO PEDAGÓGICO (300-450 palavras)
   - Síntese das adaptações curriculares implementadas
   - Análise do desempenho acadêmico (use os dados quantitativos)
   - Evolução observada ao longo do período
   - Destaque as POTENCIALIDADES demonstradas
   - Identifique DESAFIOS ainda presentes

3. PROGRESSÃO NA AUTONOMIA (150-200 palavras)
   - Análise da evolução do grau de autonomia
   - Relação entre suporte oferecido e resultados
   - Desenvolvimento de habilidades de autorregulação

4. RECOMENDAÇÕES PARA CONTINUIDADE (200-300 palavras)
   - Orientações específicas para o próximo período
   - Estratégias que devem ser mantidas
   - Novas abordagens a serem testadas
   - Expectativas de desenvolvimento
   - Orientações para a família

5. CONSIDERAÇÕES FINAIS (100-150 palavras)
   - Síntese dos principais avanços
   - Mensagem positiva sobre o desenvolvimento do estudante
   - Afirmação do compromisso da equipe escolar

DIRETRIZES DE ESCRITA:
✓ Use linguagem TÉCNICA mas ACESSÍVEL
✓ Tom FORMAL e RESPEITOSO
✓ Seja ESPECÍFICO, use os DADOS fornecidos
✓ Destaque PROGRESSOS de forma concreta
✓ Seja REALISTA sobre desafios sem ser negativo
✓ Use terminologia pedagógica adequada: "zona de desenvolvimento proximal", "andaimes pedagógicos", "mediação docente", "aprendizagem significativa"
✓ Mantenha formato NARRATIVO (prosa), NÃO use bullet points
✓ Total de 900-1300 palavras

IMPORTANTE: Este relatório será OFICIALMENTE arquivado. Seja preciso, ético e construtivo.
  `;

  const model = genAI.getGenerativeModel({
    model: "gemini-1.5-flash",
    generationConfig: {
      temperature: 0.7 // Criativo mas fundamentado
    }
  });

  try {
    const result = await model.generateContent(prompt);
    const text = result.response.text();

    // Increment Usage
    if (userId) {
      await incrementUserUsage(userId);
    }

    return text;
  } catch (error) {
    console.error("Erro ao gerar relatório Bloco 11:", error);
    throw new Error("Não foi possível gerar o relatório final. Tente novamente.");
  }
};
