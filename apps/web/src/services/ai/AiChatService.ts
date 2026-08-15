import { SYSTEM_PROMPT, SYSTEM_PROMPT_CHAT } from '../../constants';
import { AccessLevel, UserSettings } from '../../types';
import { fetchEnemQuestions } from '../databaseService';
import { getTeacherContext } from '../supabaseService';
import { checkUsageQuota, incrementUserUsage } from '../ProfileService';
import { hybridSearchProfeplan } from '../searchService';
import { isGovernedCreditConsumerEnabled } from '../credits/creditConsumerFlags';
import { GENERATION_MODELS, getGenAIClient } from './AiCore';
import { extractHighSchoolContext } from './AiUtilityService';
import { extractGuardrailsFromSettings, generateGuardrailsPrompt } from './AiGuardrailsService';

type LessonContext = {
  topic?: string;
  content?: string;
};

type ChatPart = { text: string } | { inlineData: { data: string; mimeType: string } };

type ChatMessage = {
  role: 'system' | 'user' | 'assistant';
  content: string;
};

const getErrorMessage = (error: unknown): string =>
  error instanceof Error ? error.message : 'Unknown error';

export const generateProfePlanStream = async (
  message: string,
  history: { role: string; parts: { text: string }[] }[],
  mode: string,
  imagePart?: { inlineData: { data: string; mimeType: string } },
  audioPart?: { inlineData: { data: string; mimeType: string } },
  userAccessLevel?: AccessLevel,
  userId?: string,
  userSettings?: UserSettings
) => {
  const client = getGenAIClient();
  const governedConsumers = isGovernedCreditConsumerEnabled();

  const basePrompt =
    mode === 'quarterly' || mode === 'planning' ? SYSTEM_PROMPT : SYSTEM_PROMPT_CHAT;
  let specificInstruction = `${basePrompt}\n\n[MODO ATIVO]: ${mode.toUpperCase()}`;

  if (userSettings) {
    const guardrailsConfig = extractGuardrailsFromSettings(userSettings);
    guardrailsConfig.context = `Chat - Modo ${mode}`;
    const guardrailsPrompt = generateGuardrailsPrompt(guardrailsConfig, true);
    specificInstruction += `\n\n${guardrailsPrompt}`;
  }

  if (userId) {
    try {
      const { recentLessons, preferences } = await getTeacherContext(userId);

      if (preferences || (recentLessons && recentLessons.length > 0)) {
        const preferred_tone = preferences?.preferred_tone || 'não definido';
        const recentLessons_list =
          recentLessons && recentLessons.length > 0
            ? (recentLessons as LessonContext[])
                .map(
                  (l, i: number) =>
                    `Aula ${i + 1}: ${l.topic}\nConteúdo: ${(l.content || '').substring(0, 500)}...`
                )
                .join('\n\n')
            : 'Nenhuma aula anterior disponível.';

        specificInstruction += `\n\nVocê deve seguir o estilo das aulas anteriores do professor (se houver) e respeitar o tom preferido: ${preferred_tone}. Aqui estão exemplos de aulas passadas para referência: ${recentLessons_list}`;
      }
    } catch (e) {
      console.warn('Falha ao recuperar Memória do Professor:', e);
    }
  }

  const context = extractHighSchoolContext(message);

  if (context) {
    console.log(`🔍 Detectado contexto de Ensino Médio: ${context.grade} - ${context.subject}`);
    try {
      const searchResults = await hybridSearchProfeplan({
        textoBusca: message,
        limit: 3,
        matchThreshold: 0.5,
        nivel: context.grade,
        disciplina: context.subject,
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
      const lastUserMessage = history.find((m) => m.role === 'user')?.parts[0].text || message;
      const area = lastUserMessage.toLowerCase().includes('matemática')
        ? 'Matemática'
        : lastUserMessage.toLowerCase().includes('humana')
          ? 'Ciências Humanas'
          : lastUserMessage.toLowerCase().includes('linguagen')
            ? 'Linguagens'
            : lastUserMessage.toLowerCase().includes('natureza')
              ? 'Ciências da Natureza'
              : null;

      if (area) {
        const examples = await fetchEnemQuestions(area, undefined, 2);
        if (examples && examples.length > 0) {
          specificInstruction += `\n\n[EXEMPLOS DE QUESTÕES DO BANCO]:\n${JSON.stringify(examples.map((q) => q.question_text))}`;
        }
      }
    } catch (e) {
      console.warn('Falha ao buscar questões ENEM:', e);
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

  const historyMessages: ChatMessage[] = history.map((h) => ({
    role: h.role === 'user' ? 'user' : 'assistant',
    content: (h.parts || []).map((p) => ('text' in p ? p.text : '')).join(' '),
  }));

  const userMessageContent = message || '';

  const messages: ChatMessage[] = [
    {
      role: 'system',
      content: specificInstruction,
    },
    ...historyMessages,
    {
      role: 'user',
      content: userMessageContent,
    },
  ];

  // 1.3A/1.3C.4A: general/planning chat generation is NON_BILLABLE after
  // governed consumer cutover. Flag OFF preserves the legacy quota behavior.
  if (userId && !governedConsumers) {
    const quotaStatus = await checkUsageQuota(userId);
    if (!quotaStatus.allowed) {
      throw new Error(quotaStatus.message);
    }
  }

  try {
    const modelName = GENERATION_MODELS[0];
    const stream = await client.chat.completions.create({
      model: modelName,
      messages,
      temperature: 0.8,
      stream: true,
    } as any);

    if (userId && !governedConsumers) {
      await incrementUserUsage(userId, 'chat');
    }

    async function* streamAdapter() {
      for await (const chunk of stream as unknown as AsyncIterable<any>) {
        const content = chunk.choices[0]?.delta?.content || '';
        if (content) {
          yield { text: content };
        }
      }
    }

    return streamAdapter();
  } catch (error: unknown) {
    console.error('Erro na Chamada da OpenAI:', error);
    throw new Error(getErrorMessage(error));
  }
};
