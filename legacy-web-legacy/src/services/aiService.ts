/**
 * aiService.ts
 * Serviço de AI para geração de planos pedagógicos.
 *
 * MIGRAÇÃO: Azure OpenAI → OpenAI direto
 * O recurso Azure `profeplan-ai.openai.azure.com` foi descontinuado.
 * Agora usa o cliente OpenAI padrão com a chave VITE_OPENAI_API_KEY.
 *
 * Reconstruído a partir do build compilado:
 *   - legacy-web-legacy/dist/assets/markdownParser-Dou529D6.js (lines 140-278)
 *   - legacy-web-legacy/dist/assets/PlanningManager-BSlnLa0n.js
 */

import OpenAI from 'openai';

// ---------------------------------------------------------------------------
// Cliente OpenAI — usa VITE_OPENAI_API_KEY (migrado de Azure)
// ---------------------------------------------------------------------------

let _openaiClient: OpenAI | null = null;

function getOpenAIClient(): OpenAI {
  if (_openaiClient) return _openaiClient;

  const apiKey =
    import.meta.env.VITE_OPENAI_API_KEY ||
    (typeof process !== 'undefined' ? process.env.OPENAI_API_KEY : undefined);

  if (!apiKey) {
    throw new Error(
      '[aiService] ❌ VITE_OPENAI_API_KEY não configurada. ' +
      'Adicione ao .env: VITE_OPENAI_API_KEY=sk-...',
    );
  }

  _openaiClient = new OpenAI({
    apiKey,
    dangerouslyAllowBrowser: true, // necessário para uso no client-side (Vite/Capacitor)
  });

  return _openaiClient;
}

// ---------------------------------------------------------------------------
// Sistema prompt do PROFEPLAN
// ---------------------------------------------------------------------------

const SYSTEM_PROMPT = `# SYSTEM INSTRUCTION: PROFEPLAN ASSISTENTE PEDAGÓGICO ESTRITO (RAG-DRIVEN)

CONTEXTO:
Você é um Especialista Pedagógico do PROFEPLAN que atende professores de Minas Gerais.
Sua inteligência é alimentada por um banco de dados oficial (RAG).

⚠️ REGRAS DE OURO (ANTI-ALUCINAÇÃO):
1. **Contexto é Rei**: Sua resposta deve ser baseada EXCLUSIVAMENTE nas informações recuperadas do banco de dados e fornecidas no bloco [CONTEXTO RECUPERADO] ou [PLANO_ENCONTRADO].
2. **Sem Invenções**: Se uma habilidade, código (ex: EF09MA01) ou conteúdo não estiver explicitamente listado no contexto, NÃO INVENTE. Responda: "Não encontrei essa informação específica no Currículo Oficial de MG para o período solicitado."
3. **Respeite a Fonte**: Siga estritamente a nomenclatura de Trimestre que vier no contexto.
4. **Idempotência**: Se o usuário pedir para gerar um plano sobre "Revolução Francesa" e o contexto trouxer apenas "Iluminismo", ALERTE o usuário sobre a discrepância antes de prosseguir.

---

## 2. DIRETRIZES DE ESTILO
- **Metodologia Ativa**: Priorize sala de aula invertida e mão na massa.
- **Inclusão (DUA)**: Sempre considere adaptações para alunos com dificuldades.
- **Tom de Voz**: Profissional, acolhedor e direto ao ponto.

---

## 3. PROTOCOLO ESPECÍFICO: ENSINO MÉDIO & ENEM
- Se houver questões recuperadas do banco (Metadata: [ENEM ...]), use-as integralmente.
- Destaque "Desafio ENEM" com as questões reais.

---

## 4. ESTRUTURA DE RESPOSTA PADRÃO (OBRIGATÓRIO)

Toda resposta que gere conteúdo pedagógico DEVE iniciar com a etiqueta de ação correspondente:
- Para Planos de Aula: [AÇÃO: PLANO DE AULA DETALHADO]
- Para Materiais/Resumos: [AÇÃO: MATERIAL DIDÁTICO]
- Para Atividades/Questões: [AÇÃO: LISTA DE EXERCÍCIOS]
`;

// ---------------------------------------------------------------------------
// Tipo de contexto para geração de plano trimestral
// ---------------------------------------------------------------------------

export interface TermPlanContext {
  subject: string;
  grade: string;
  level?: string;
  period: number;
  totalClasses: number;
  stateBase: string;
  educationSphere: string;
  teacherName: string;
  curriculumContext?: string;
  userSettings?: {
    favoriteMethodology?: string;
    teachingStyle?: string;
    assessmentFocus?: string;
    toneOfVoice?: string;
  };
  pnld_book_id?: string;
  reserves?: {
    monthlyExam?: boolean;
    termExam?: boolean;
    recovery?: boolean;
  };
  gradingGrid?: {
    monthlyExam?: number;
    termExam?: number;
    vistos?: number;
    trabalhos?: number;
    others?: number;
  };
  feedback?: string;
  userId?: string;
  skipCredits?: boolean;
}

// ---------------------------------------------------------------------------
// Retry com fallback de modelo
// Replicando o comportamento de `retryWithModel` do código compilado
// ---------------------------------------------------------------------------

export async function retryWithModel<T>(
  modelLabel: string,
  fn: (model: string) => Promise<T>,
): Promise<T> {
  // Ordem de preferência: modelo preferencial → fallback
  const models = ['gpt-4o-mini', 'gpt-3.5-turbo'];

  let lastError: unknown;
  for (const model of models) {
    try {
      console.log(`[aiService] Tentando modelo: ${model}`);
      return await fn(model);
    } catch (err) {
      console.warn(`[aiService] Falhou com ${model}:`, err);
      lastError = err;
    }
  }

  throw lastError;
}

// ---------------------------------------------------------------------------
// buildGuardrails — monta o bloco de preferências pedagógicas
// ---------------------------------------------------------------------------

function buildGuardrails(
  settings: NonNullable<TermPlanContext['userSettings']>,
  allowOverride = true,
): string {
  const methodology = settings.favoriteMethodology || 'Gamification';
  const style = settings.teachingStyle || 'Construtivista';
  const assessment = settings.assessmentFocus || 'Formativa';
  const tone = settings.toneOfVoice || 'Prático e Inspiracional';

  return `
[🛡️ GUARDRAILS PEDAGÓGICOS - OBRIGATÓRIOS]

**📚 METODOLOGIA PADRÃO:** ${methodology}
**🎓 ESTILO PEDAGÓGICO:** ${style}
**📊 FOCO AVALIATIVO:** ${assessment}
**✍️ TOM DE ESCRITA:** ${tone}

${allowOverride
    ? '⚠️ EXCEÇÃO: Se o professor fornecer feedback explícito que conflite com estas preferências, o feedback do professor SEMPRE prevalece.'
    : '🔒 MODO ESTRITO: Estas preferências são MANDATÓRIAS e não podem ser sobrescritas.'}
---
`;
}

// ---------------------------------------------------------------------------
// getPnldChapters — mapeamento de capítulos por série/trimestre
// ---------------------------------------------------------------------------

function getPnldChapters(grade: string, period: number): string | null {
  const gradeNum = parseInt(grade.replace(/\D/g, '')) || 0;
  if (gradeNum < 1 || gradeNum > 3) return null;
  const startChapter = (gradeNum - 1) * 6;
  const offset = (period - 1) * 2;
  const ch1 = startChapter + offset + 1;
  const ch2 = ch1 + 1;
  return `CAPÍTULOS ${ch1} e ${ch2}`;
}

// ---------------------------------------------------------------------------
// generateTermPlan — gera plano trimestral completo
// ---------------------------------------------------------------------------

export async function generateTermPlan(ctx: TermPlanContext): Promise<string> {
  const reserves = ctx.reserves || {};
  const gradingGrid = ctx.gradingGrid || {};

  const monthlyExamPts = gradingGrid.monthlyExam ?? 15;
  const termExamPts = gradingGrid.termExam ?? 15;
  const vistosPts = gradingGrid.vistos ?? 0;
  const trabalhosPts = gradingGrid.trabalhos ?? 0;
  const othersPts = gradingGrid.others ?? 0;
  const totalPts = monthlyExamPts + termExamPts + vistosPts + trabalhosPts + othersPts;

  const exam1Aula = Math.floor(ctx.totalClasses / 2) + 1;
  const exam2Aula = ctx.totalClasses - 1;
  const recoveryAula = ctx.totalClasses;

  // Guardrails
  const guardrails = ctx.userSettings
    ? buildGuardrails(ctx.userSettings, true)
    : '';

  // Regra PNLD
  let pnldRule = '';
  if (ctx.pnld_book_id) {
    const isDigital =
      ctx.pnld_book_id.toLowerCase().includes('educação digital') ||
      ctx.pnld_book_id.toLowerCase().includes('educacao digital');

    if (isDigital) {
      const chapters = getPnldChapters(ctx.grade, ctx.period);
      if (chapters) {
        pnldRule = `
[REGRA MANDATÓRIA DO LIVRO DIDÁTICO]:
O professor escolheu o livro: "${ctx.pnld_book_id}" (Volume Único para o Ensino Médio).
Seguindo a grade curricular estrita para este período (${ctx.grade} - ${ctx.period}º Trimestre), você DEVE utilizar EXCLUSIVAMENTE os seguintes capítulos:
👉 ${chapters}

INSTRUÇÃO:
- Baseie o plano de aula APENAS nesses capítulos e nos temas abarcados por eles.
- Ignore conteúdos de outros bimestres/anos deste mesmo livro.
`;
      }
    } else {
      pnldRule = `
[LIVRO DIDÁTICO SELECIONADO]:
O professor utilizará o livro: "${ctx.pnld_book_id}".
Sempre que possível, sugira atividades e leituras conectadas a este material.
`;
    }
  }

  const userPrompt = `
Atue como um Coordenador Pedagógico especialista em BNCC e currículos da Secretaria de Educação (SEE/MG).
Gere um "MAPA DE PLANEJAMENTO DE AULA/2026" completo e rigoroso.

${guardrails}

[DIRETRIZES CRÍTICAS DE GOVERNANÇA (RLM)]:
1. PRIORIDADE FONTE DA VERDADE: Use o currículo oficial fornecido abaixo. Se for de Química, Física ou Biologia, siga os pacotes da SEE.
2. RIGOR NA AVALIAÇÃO: A Prova 01 DEVE ser agendada para a Aula ${exam1Aula}. Não aceite variações.
3. GRADE DE PONTOS: Os valores de pontos informados abaixo são MANDATÓRIOS. O total deve somar ${totalPts}.

DADOS DO CONTEXTO:
- Estado (Base Curricular): ${ctx.stateBase}
- Esfera: ${ctx.educationSphere}
- Professor: ${ctx.teacherName}
- Componente: ${ctx.subject}
- Nível de Ensino: ${ctx.level || 'Não especificado'}
- Ano/Série: ${ctx.grade}
- Período: ${ctx.period}º Trimestre
- Total de Aulas: ${ctx.totalClasses}

[DADOS DO CURRÍCULO OFICIAL]:
${ctx.curriculumContext || 'Use a BNCC geral atualizada.'}

${pnldRule}

[GRADE DE AVALIAÇÃO OBRIGATÓRIA]:
- PROVA 01: ${monthlyExamPts} pontos (Agendada: Aula ${exam1Aula})
- PROVA 02: ${termExamPts} pontos (Agendada: Aula ${exam2Aula})
- VISTOS DE CADERNO: ${vistosPts} pontos
- TRABALHOS: ${trabalhosPts} pontos
- OUTROS: ${othersPts} pontos
- TOTAL DO TRIMESTRE: ${totalPts} pontos

[RESERVAS DE AULAS PARA AVALIAÇÕES]:
${reserves.monthlyExam ? `- Aula ${exam1Aula}: PROVA 01 (reserve esta aula exclusivamente para aplicação da prova)` : ''}
${reserves.termExam ? `- Aula ${exam2Aula}: PROVA 02 (reserve esta aula exclusivamente para aplicação da prova)` : ''}
${reserves.recovery ? `- Aula ${recoveryAula}: RECUPERAÇÃO (reserve esta aula para recuperação de alunos)` : ''}

${ctx.feedback ? `
[ATENÇÃO: FEEDBACK DO PROFESSOR (PRIORIDADE CRÍTICA)]
O professor solicitou o seguinte ajuste no plano anterior:
"${ctx.feedback}"

INSTRUÇÃO DE REGENERAÇÃO:
Ignore qualquer regra anterior que conflite com este pedido. O feedback do professor é soberano. Recrie o plano incorporando esta mudança imediatamente.
` : ''}
---------------------------------------------------

TAREFA:
Gere um documento Markdown BEM FORMATADO que servirá como a única fonte da verdade.

ESTRUTURA OBRIGATÓRIA (Siga exatamente os cabeçalhos para que o sistema possa ler):

# PLANEJAMENTO DE ENSINO - ${ctx.subject.toUpperCase()}

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
**BNCC:**
- CODI01

...

${reserves.monthlyExam ? `### Aula ${exam1Aula}: PROVA 01
**Descrição:**
Aplicação da primeira avaliação do trimestre (${monthlyExamPts} pontos).
**Conteúdo Abrangido:**
Aulas 1 a ${exam1Aula - 1}
` : ''}

${reserves.termExam ? `### Aula ${exam2Aula}: PROVA 02
**Descrição:**
Aplicação da segunda avaliação do trimestre (${termExamPts} pontos).
**Conteúdo Abrangido:**
Aulas ${exam1Aula + 1} a ${exam2Aula - 1}
` : ''}

${reserves.recovery ? `### Aula ${recoveryAula}: RECUPERAÇÃO
**Descrição:**
Atividades de recuperação e reforço para alunos que não atingiram os objetivos.
` : ''}

## 4. Avaliação

A avaliação do ${ctx.period}º trimestre será composta por duas provas, com peso de ${monthlyExamPts} pontos e ${termExamPts} pontos, respectivamente, totalizando ${totalPts} pontos.
`;

  return retryWithModel('TermPlan', async (model) => {
    const client = getOpenAIClient();
    const completion = await client.chat.completions.create({
      model,
      messages: [
        { role: 'system', content: SYSTEM_PROMPT },
        { role: 'user', content: userPrompt },
      ],
      temperature: 0.7,
    });
    return completion.choices[0]?.message?.content ?? '';
  });
}

// ---------------------------------------------------------------------------
// sendChatMessage — envia mensagem no chat pedagógico
// ---------------------------------------------------------------------------

export interface ChatMessage {
  role: 'user' | 'assistant' | 'system';
  content: string;
}

export async function sendChatMessage(
  userMessage: string,
  history: ChatMessage[] = [],
  systemContext = '',
  userId?: string,
  temperature = 0.7,
): Promise<string> {
  const systemContent = `${SYSTEM_PROMPT}\n\n[CONTEXTO ATUAL]: ${systemContext}`;

  const messages: OpenAI.Chat.ChatCompletionMessageParam[] = [
    { role: 'system', content: systemContent },
    ...history.map((m) => ({
      role: m.role as 'user' | 'assistant',
      content: m.content,
    })),
    { role: 'user', content: userMessage },
  ];

  const client = getOpenAIClient();
  const completion = await client.chat.completions.create({
    model: 'gpt-4o-mini',
    messages,
    temperature,
  });

  const content = completion.choices[0]?.message?.content;
  if (typeof content === 'string') return content;

  // Fallback para arrays de content (ex: vision responses)
  if (Array.isArray(content)) {
    return (content as Array<{ text?: string }>)
      .map((c) => (typeof c === 'string' ? c : c.text ?? ''))
      .join('');
  }

  return '';
}
