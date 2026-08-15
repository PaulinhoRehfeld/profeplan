/**
 * Serviço de Geração de Apresentações via DeepSeek
 *
 * Agente especializado que gera roteiros de slides em JSON estruturado,
 * com infográficos descritivos e imagens sugeridas.
 * Saída 100% em português brasileiro, sem erros ortográficos.
 */
import { GENERATION_MODELS, getGenAIClient } from './AiCore';
import { checkUsageQuota, incrementUserUsage } from '../ProfileService';
import { isGovernedCreditConsumerEnabled } from '../credits/creditConsumerFlags';

export interface InfographicSlide {
  order: number;
  type: 'infografico';
  title: string;
  infographicDescription: string;
  chartData?: {
    chartType: 'barra' | 'pizza' | 'linha' | 'comparacao' | 'processo' | 'hierarquia';
    title: string;
    labels: string[];
    values: number[];
  };
  imageSearchQuery: string;
  speakerNotes: string;
}

export interface ContentSlide {
  order: number;
  type: 'capa' | 'conteudo' | 'interacao' | 'conclusao' | 'topico';
  title: string;
  contentBulletPoints: string[];
  imageSearchQuery: string;
  speakerNotes: string;
}

export type PresentationSlide = ContentSlide | InfographicSlide;

export interface PresentationScript {
  artifactId: string;
  title: string;
  subtitle: string;
  theme: string;
  slides: PresentationSlide[];
}

type GeneratedPresentationPayload = Omit<PresentationScript, 'artifactId'>;

const createPresentationArtifactId = (): string => {
  const randomUUID = globalThis.crypto?.randomUUID;
  if (typeof randomUUID === 'function') {
    return randomUUID.call(globalThis.crypto);
  }

  return `presentation_${Date.now()}_${Math.random().toString(36).slice(2)}`;
};

export const generatePresentationJSON = async (
  topic: string,
  context: string,
  slideCount: number,
  style: string,
  includeInteractions: boolean,
  userId?: string
): Promise<PresentationScript> => {
  const governedConsumers = isGovernedCreditConsumerEnabled();

  // 1.3C.4C: generation/preview is NON_BILLABLE after governed consumer
  // cutover. Flag OFF preserves legacy quota behavior until 4E.
  if (userId && !governedConsumers) {
    const quotaStatus = await checkUsageQuota(userId);
    if (!quotaStatus.allowed) {
      throw new Error(quotaStatus.message);
    }
  }

  const client = getGenAIClient();

  const systemPrompt = `VOCÊ É UM DESIGNER INSTRUCIONAL BRASILEIRO ESPECIALISTA EM APRESENTAÇÕES PEDAGÓGICAS DE ALTO IMPACTO.

REGRAS ABSOLUTAS (NÃO NEGOCIÁVEIS):

1. ⚠️ IDIOMA: Todo o conteúdo DEVE estar em PORTUGUÊS BRASILEIRO (pt-BR). NENHUMA palavra em inglês, espanhol ou qualquer outro idioma. Termos técnicos devem ser traduzidos ou usados com explicação em português.

2. ⚠️ ORTOGRAFIA: REVISE cada palavra. É PROIBIDO qualquer erro ortográfico ou de acentuação. Use o Acordo Ortográfico da Língua Portuguesa. Palavras como "ação", "inclusão", "aprendizagem", "metodologia" devem estar grafadas CORRETAMENTE.

3. ⚠️ ADEQUAÇÃO: O conteúdo deve ser adequado ao contexto escolar brasileiro (Ensino Fundamental II, Ensino Médio). Use terminologia da BNCC (Base Nacional Comum Curricular).

4. 📊 INFOGRÁFICOS: Para slides de dados, comparações ou processos, use o tipo "infografico" com dados estruturados para gráficos. Tipos de gráfico disponíveis:
   - "barra": comparação de valores entre categorias
   - "pizza": distribuição percentual de um todo
   - "linha": evolução temporal ou tendência
   - "comparacao": tabela comparativa lado a lado
   - "processo": fluxograma de etapas sequenciais
   - "hierarquia": estrutura de tópicos e subtópicos

5. 🎨 IMAGENS: Para cada slide, forneça uma "imageSearchQuery" DESCRITIVA e em PORTUGUÊS que servirá para buscar imagens educativas. Ex: "mapa do Brasil regiões geográficas", "célula animal vista no microscópio", "linha do tempo Revolução Francesa 1789".

6. 📝 ESTRUTURA:
   - Capa criativa e impactante (tipo "capa")
   - Slides de conteúdo com REGRA 6×6 (máx. 6 bullets, máx. 6 palavras cada) — tipo "conteudo"
   - 1 slide de infográfico a cada 3-4 slides se houver dados — tipo "infografico"
   - Slides de interação (perguntas, reflexões, enquetes) se solicitado — tipo "interacao"
   - Conclusão com resumo e chamada para ação — tipo "conclusao"

7. 🎤 NOTAS DO APRESENTADOR: Cada slide deve ter "speakerNotes" com o roteiro do que o professor deve FALAR, em linguagem natural e coloquial brasileira.`;

  const userPrompt = `CRIE UMA APRESENTAÇÃO PEDAGÓGICA COMPLETA EM PORTUGUÊS BRASILEIRO COM OS SEGUINTES PARÂMETROS:

TEMA: ${topic}
CONTEXTO DA AULA: ${context || 'Criar apresentação introdutória sobre o tema'}
QUANTIDADE DE SLIDES: ${slideCount}
ESTILO VISUAL: ${style}
INCLUIR INTERAÇÕES: ${includeInteractions ? 'SIM — Inclua perguntas, enquetes e momentos de reflexão' : 'NÃO — Apenas conteúdo expositivo'}

RETORNE APENAS UM JSON VÁLIDO (sem markdown, sem comentários) com esta estrutura exata:

{
  "title": "Título Criativo da Apresentação",
  "subtitle": "Subtítulo descritivo",
  "theme": "${style}",
  "slides": [
    {
      "order": 1,
      "type": "capa",
      "title": "Título do Slide",
      "contentBulletPoints": ["Tópico 1", "Tópico 2", "Tópico 3"],
      "imageSearchQuery": "descrição para busca de imagem em português",
      "speakerNotes": "Roteiro completo do que o professor vai falar neste slide"
    }
  ]
}

⚠️ ÚLTIMA VERIFICAÇÃO ANTES DE RESPONDER:
- [ ] Todo o texto está em português brasileiro?
- [ ] Não há palavras em inglês ou outros idiomas?
- [ ] Revisei a ortografia e acentuação de cada palavra?
- [ ] Os bullet points seguem a regra 6×6?
- [ ] As imageSearchQuery estão em português e são descritivas?
- [ ] As speakerNotes estão em linguagem natural brasileira?`;

  const messages = [
    { role: 'system' as const, content: systemPrompt },
    { role: 'user' as const, content: userPrompt },
  ];

  const completion = await client.chat.completions.create({
    model: GENERATION_MODELS[0],
    messages,
    temperature: 0.3,
    max_tokens: 4096,
  } as any);

  const content = completion.choices[0]?.message?.content as any;
  const text =
    typeof content === 'string'
      ? content
      : ((content as any[] | undefined)
          ?.map((c) => (typeof c === 'string' ? c : c.text || ''))
          .join('') ?? '');

  // Limpa possíveis cercas markdown
  const jsonText = text
    .replace(/^\s*```(?:json)?\s*/i, '')
    .replace(/\s*```\s*$/i, '')
    .trim();

  try {
    const payload = JSON.parse(jsonText) as GeneratedPresentationPayload;

    if (!payload.slides || !Array.isArray(payload.slides)) {
      throw new Error('JSON inválido: campo "slides" ausente ou não é array');
    }

    // A identidade econômica nasce uma única vez quando a geração termina e
    // permanece no estado da tela. Retry/edição do mesmo resultado reutiliza
    // este artifactId; uma nova geração recebe uma nova identidade.
    const parsed: PresentationScript = {
      ...payload,
      artifactId: createPresentationArtifactId(),
    };

    // Validação de idioma — detecta excesso de palavras em inglês
    const englishWords =
      /\b(the|and|for|with|this|that|have|from|are|not|but|you|all|can|had|her|was|one|our|out|has|been|some|them|who|will|more|about|into|than|just)\b/gi;
    const allText = JSON.stringify(parsed);
    const matches = allText.match(englishWords);
    if (matches && matches.length > 5) {
      console.warn(`[PresentationAgent] ⚠️ ${matches.length} palavras em inglês detectadas.`);
    }

    console.log(`[PresentationAgent] ✅ ${parsed.slides.length} slides gerados: "${parsed.title}"`);

    if (userId && !governedConsumers) {
      await incrementUserUsage(userId, 'generate');
    }

    return parsed;
  } catch (e) {
    console.error(
      '[PresentationAgent] Erro ao parsear JSON:',
      e,
      '\nTexto:',
      text.substring(0, 300)
    );
    throw new Error('Falha ao gerar o roteiro da apresentação. A IA retornou um formato inválido.');
  }
};
