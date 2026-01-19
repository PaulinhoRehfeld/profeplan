import { GoogleGenerativeAI, HarmBlockThreshold, HarmCategory } from "@google/generative-ai";
import { SYSTEM_PROMPT } from "../constants";
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
  let specificInstruction = `${SYSTEM_PROMPT}\n\n[MODO ATIVO]: ${mode.toUpperCase()}`;



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
    model: "gemini-2.0-flash",
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

  const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash", systemInstruction: instruction, safetySettings });

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
  2. IDENTIFICAÇÃO DE ALUNOS: Os nomes dos alunos geralmente aparecem em LETRAS MAIÚSCULAS e seguem sequências numéricas (ex: "1", "8974339", "JOÃO VÍTOR DE MACÉDO COELHO").
  3. LIMPEZA: Ignore códigos numéricos, strings de sistema como "Pág. 1 de 1", carimbos de data/hora, endereços de escola, e cabeçalhos de tabela ("Código", "Nome").
  4. PADRÃO DE NOMES: Extraia apenas o nome completo em maiúsculas. Exemplos válidos: "JOÃO VÍTOR DE MACÉDO COELHO", "MARCOS VINICIUS ALVES DE SOUSA".
  
  Retorna APENAS um JSON puro, sem markdown, no seguinte formato:
  { 
    "className": "Nome da Turma (ex: 1° EM REG 5)", 
    "subject": "Disciplina (ex: SOCIOLOGIA)", 
    "students": ["NOME COMPLETO DO ALUNO 1", "NOME COMPLETO DO ALUNO 2"] 
  }`;

  const model = genAI.getGenerativeModel({
    model: "gemini-2.0-flash",
    systemInstruction: instruction
  });

  const prompt = `Extraia desta lista escolar: o nome da turma, a disciplina/matéria e a lista completa de nomes de alunos.
  
  FOQUE em encontrar padrões de nomes em letras maiúsculas que seguem uma sequência numérica.
  Ignore rodapés, cabeçalhos administrativos e códigos de identificação.
  
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
    model: "gemini-2.0-flash",
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
    model: "gemini-2.0-flash",
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
    model: "gemini-2.0-flash",
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
    Crie uma adaptação desta aula especificamente para este aluno. Não simplifique o currículo a ponto de perder o objetivo, mas altere a FORMA de acesso e expressão.
    
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

  const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });

  try {
    const result = await model.generateContent(prompt);
    const response = await result.response;

    // Increment Usage
    if (context?.userId) {
      await incrementUserUsage(context.userId);
    }

    return response.text();
  } catch (error) {
    console.error("Erro ao gerar adaptação PDI:", error);
    throw error;
  }
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

  const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });

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
  const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });

  const prompt = `
    Atue como um Coordenador Pedagógico especialista em BNCC e currículos locais.
    Gere um "MAPA DE PLANEJAMENTO DE AULA/2026" completo e profissional.

    DADOS DO CONTEXTO:
    - Estado (Base Curricular): ${context.stateBase}
    - Esfera: ${context.educationSphere}
    - Professor: ${context.teacherName}
    - Componente: ${context.subject}
    - Nível de Ensino: ${context.level || 'Não especificado'} (CRUCIAL: Respeite este nível para escolha de códigos BNCC)
    - Ano/Série: ${context.grade} (Normalizado: ${context.grade.replace(/\D/g, '')}º Ano ${context.level === 'Ensino Médio' ? 'EM' : ''})
    - Período: ${context.period}º ${context.regime}
    - Total de Aulas Previstas: ${context.totalClasses}

    [DADOS DO CURRÍCULO OFICIAL (FONTE DE VERDADE)]:
    Abaixo estão os trechos do currículo oficial encontrados no banco de dados. USE ESTAS INFORMAÇÕES para preencher Habilidades, Objetivos e Conteúdos.
    SE O TEMA NÃO ESTIVER AQUI, USE SEU CONHECIMENTO GERAL, MAS DÊ PREFERÊNCIA ABSOLUTA AOS DADOS ABAIXO:
    
    ${curriculumContext ? curriculumContext : "Nenhum currículo específico encontrado. Use a BNCC geral adequada ao nível (EF para Fundamental, EM para Médio)."}
    ---------------------------------------------------

    ESTRUTURA OBRIGATÓRIA (Siga exatamente este formato):

    MAPA DE PLANEJAMENTO DE AULA/2026
    Planejamento de ${context.subject} - ${context.grade} (${context.level}) - ${context.period}º ${context.regime}
    Área de Conhecimento: [Inserir Área BNCC]
    Componente Curricular: ${context.subject}
    Ano: ${context.grade}
    Nível: ${context.level}
    Período: ${context.period}º ${context.regime} de 2026

    1. Objetivos Gerais:
    Professor: ${context.teacherName}
    • [Objetivo 1]
    • [Objetivo 2]
    • [Objetivo 3]

    2. Competências e Habilidades (de acordo com o Currículo de ${context.stateBase} e BNCC):
    Copie fielmente os códigos e descrições dos trechos acima, se disponíveis.
    • (CÓDIGO ALFANUMÉRICO): [Descrição da Habilidade]
    • (CÓDIGO ALFANUMÉRICO): [Descrição da Habilidade]

    3. Conteúdos a Serem Trabalhados:
    Extraia dos trechos de currículo acima.
    • [Conteúdo 1]
    • [Conteúdo 2]
    • [Conteúdo 3]
    • [Conteúdo 4]
    • [Conteúdo 5]

    4. Metodologia:
    • Aulas expositivas dialogadas...
    • [Metodologia ativa específica para a disciplina]
    • [Atividade prática sugerida]

    5. Recursos Didáticos:
    • Projetor multimídia...
    • [Recurso específico]
    • [Recurso específico]

    6. Cronograma das Aulas (Total: ${context.totalClasses} encontros):
    [MUITO IMPORTANTE: Mantenha ESTRITAMENTE o formato "Aula X: Tópico" para que o sistema possa agendar corretamente]
    • Aula 1: [Tópico Introdutório]
    • Aula 2: [Desenvolvimento]
    ...
    • Aula ${context.totalClasses - 2}: Revisão geral
    • Aula ${context.totalClasses - 1}: ${context.reserves.bimonthlyExam ? `Prova ${context.regime}` : 'Atividade Avaliativa'}
    • Aula ${context.totalClasses}: Recuperação e encerramento.

    7. Avaliação:
    • Diagnóstica: ...
    • Formativa: ...
    • Somativa: ...

    IMPORTANTE:
    - O cronograma deve listar AULA POR AULA (ou agrupamentos claros Aula X e Y).
    - Use "Aula X:" no início de cada linha do cronograma.
    - Adapte o conteúdo especificamente para a disciplina de ${context.subject} no ${context.grade}.
    - Cite códigos reais da BNCC ou do Currículo de ${context.stateBase} encontrados no contexto.
    `;

  try {
    const result = await model.generateContent(prompt);
    const response = await result.response;

    // Increment Usage
    if (context.userId) {
      await incrementUserUsage(context.userId);
    }

    return response.text();
  } catch (e) {
    console.error("Erro ao gerar planejamento:", e);
    throw e;
  }
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

  const systemInstruction = `${SYSTEM_PROMPT}\n\n[CONTEXTO ATUAL]: ${context}`;

  const model = genAI.getGenerativeModel({
    model: "gemini-2.0-flash",
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
