import { app, HttpRequest, HttpResponseInit, InvocationContext } from '@azure/functions';
import { OpenAI } from 'openai';
import { GoogleGenerativeAI } from '@google/generative-ai';
import { verifyUserToken } from '../lib/auth.js';
import { getSecret } from '../lib/secrets.js';
import { redactSensitiveData } from '../lib/privacy.js';
import { generateGuardrailsPrompt } from '../lib/guardrails.js';
import { logger } from '@profeplan/logger';

// Sanitiza campos de usuário antes de embuti-los em prompts (defesa contra prompt injection)
const sanitizeInput = (value: string | undefined | null, maxLen = 500): string => {
  if (value == null) return '';
  return String(value)
    .replace(/```[\s\S]*?```/g, '[BLOCO REMOVIDO]')
    .replace(/^(IGNORE|FORGET|DISREGARD|ACT AS|YOU ARE|SYSTEM:|USER:|ASSISTANT:)/im, '')
    .substring(0, maxLen)
    .trim();
};

// Calcula percentual de forma segura, evitando divisão por zero
const safePercent = (numerator: number, denominator: number, decimals = 0): string => {
  if (!denominator || denominator === 0) return '0';
  return ((numerator / denominator) * 100).toFixed(decimals);
};

// Helper de auxílio para extrair texto de JSON
const extractJsonObjectFromText = (raw: string): string => {
  const text = (raw || '').trim();
  const unfenced = text
      .replace(/^\s*```(?:json)?\s*/i, '')
      .replace(/\s*```\s*$/i, '')
      .trim();

  if ((unfenced.startsWith('{') && unfenced.endsWith('}')) || (unfenced.startsWith('[') && unfenced.endsWith(']'))) {
      return unfenced;
  }

  const objMatch = unfenced.match(/\{[\s\S]*\}/);
  if (objMatch?.[0]) return objMatch[0];
  const arrMatch = unfenced.match(/\[[\s\S]*\]/);
  if (arrMatch?.[0]) return arrMatch[0];

  return unfenced;
};

// Executor genérico de LLM no servidor
async function executeLLM(
  prompt: string,
  systemInstruction: string,
  provider: string,
  model?: string
): Promise<string> {
  if (provider === 'openai') {
    const apiKey = await getSecret('OPENAI_API_KEY');
    if (!apiKey) {
      throw new Error('OpenAI API key is not configured on the server');
    }
    const openai = new OpenAI({ apiKey });
    const targetModel = model || 'gpt-4o-mini';
    const response = await openai.chat.completions.create({
      model: targetModel,
      messages: [
        { role: 'system', content: systemInstruction },
        { role: 'user', content: prompt }
      ],
      temperature: 0.7,
    });
    return response.choices[0]?.message?.content || '';
  } else {
    // Provedor padrão: Google Gemini
    const apiKey = await getSecret('GEMINI_API_KEY');
    if (!apiKey) {
      throw new Error('Gemini API key is not configured on the server');
    }
    const ai = new GoogleGenerativeAI(apiKey);
    const targetModel = model || 'gemini-1.5-flash';
    const modelInstance = ai.getGenerativeModel({
      model: targetModel,
      systemInstruction: systemInstruction,
    });
    const result = await modelInstance.generateContent(prompt);
    return result.response.text();
  }
}

export async function pdiProxy(request: HttpRequest, context: InvocationContext): Promise<HttpResponseInit> {
  const startTime = Date.now();
  context.log(`[pdiProxy] Processando requisição de PDI para: "${request.url}"`);

  // 1. Validar JWT do Usuário
  let userPayload;
  try {
    userPayload = await verifyUserToken(request);
  } catch (error: any) {
    context.warn('[pdiProxy] Falha na validação de token:', error?.message || error);
    return {
      status: 401,
      jsonBody: { error: `Unauthorized: ${error?.message || 'Authentication token is invalid or missing'}` },
    };
  }

  const userId = userPayload.sub;
  const userEmail = userPayload.email || '';

  // 2. Processar JSON Body
  let body: any;
  try {
    body = await request.json();
  } catch (e) {
    return { status: 400, jsonBody: { error: 'Invalid JSON body' } };
  }

  const { action, provider = 'gemini', model, guardrailsConfig } = body;

  if (!action) {
    return { status: 400, jsonBody: { error: 'Parameter "action" is required' } };
  }

  try {
    let prompt = '';
    let systemInstruction = '';
    let isJsonResponse = false;

    const guardrailsPrompt = guardrailsConfig ? generateGuardrailsPrompt(guardrailsConfig, true) : '';

    // 3. Montar Prompt com base no Action
    if (action === 'generateStudentAdaptation') {
      const { originalContent, studentName, deficiencies = [], observations = '', gradeLevel, stateBase, educationSphere } = body;
      if (!originalContent || !studentName || !gradeLevel) {
        return { status: 400, jsonBody: { error: 'Missing parameters for generateStudentAdaptation' } };
      }

      systemInstruction = "Você é um especialista em inclusão e DUA escrevendo adaptações de aula.";
      prompt = `
    ATUE COMO UM ESPECIALISTA EM INCLUSÃO E DESENHO UNIVERSAL PARA APRENDIZAGEM (DUA).

    ${guardrailsPrompt}

    AULA ORIGINAL:
    "${originalContent.substring(0, 3000)}"

    PERFIL DO ALUNO:
    Nome: ${sanitizeInput(studentName, 100)}
    Série: ${sanitizeInput(gradeLevel, 50)}
    Necessidades/Diagnósticos: ${deficiencies.map((d: string) => sanitizeInput(d, 100)).join(', ')}
    Observações do Professor: ${sanitizeInput(observations, 500)}
    ${stateBase ? `CONTEXTO CURRICULAR:\n    Base: ${sanitizeInput(stateBase, 100)} (${sanitizeInput(educationSphere, 50) || 'Geral'})` : ''}
    
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

    } else if (action === 'generatePdiReport') {
      const { logs = [], studentName, period } = body;
      if (!studentName || !period) {
        return { status: 400, jsonBody: { error: 'Missing parameters for generatePdiReport' } };
      }

      const logsSummary = logs.map((l: any) => {
        const dateLabel = l.created_at ? new Date(l.created_at).toLocaleDateString() : 'Data desconhecida';
        return `- Em ${dateLabel}: Adaptação focada em ${l.content?.substring(0, 100) || 'Conteúdo adaptado'}...`;
      }).join('\n');

      systemInstruction = "Você é um especialista em educação especial redigindo relatórios oficiais de PDI.";
      prompt = `
    ATUE COMO UM ESPECIALISTA EM EDUCAÇÃO ESPECIAL E INCLUSIVA COM 20 ANOS DE EXPERIÊNCIA EM ESCRITA DE LAUDOS E RELATÓRIOS DE PDI.

    DADOS DO ALUNO: ${sanitizeInput(studentName, 100)}
    PERÍODO: ${sanitizeInput(period, 50)}
    
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

    } else if (action === 'generateFinalPDIReport') {
      const { studentName, profileData = {}, evaluations = [], adaptationCount = 0 } = body;
      if (!studentName) {
        return { status: 400, jsonBody: { error: 'Missing parameters for generateFinalPDIReport' } };
      }

      const evaluationsText = evaluations.map((e: any) =>
        `- ${e.subject || 'Geral'} (${e.period || 1}º Tri): Autonomia ${e.autonomy_level || 'não informada'}, Compreensão ${e.comprehension_level || 'não informada'}. Obs: "${e.pedagogical_diagnosis || ''}"`
      ).join('\n');
      const profileSummary = JSON.stringify(profileData, null, 2);

      systemInstruction = "Você é um gestor educacional especialista em inclusão.";
      prompt = `
      ATUE COMO UM GESTOR EDUCACIONAL ESPECIALISTA EM INCLUSÃO.
      ESCREVA O RELATÓRIO FINAL (ITEM XI) DO PLANO DE DESENVOLVIMENTO INDIVIDUAL (PDI).

      ALUNO: ${sanitizeInput(studentName, 100)}
      TOTAL DE AULAS ADAPTADAS NO PERÍODO: ${Number(adaptationCount) || 0}

      DADOS CLÍNICOS E PEDAGÓGICOS (Checklist):
      ${profileSummary}

      AVALIAÇÕES DOS PROFESSORES:
      ${evaluationsText || "Nenhuma avaliação docente registrada no sistema ainda."}

      TAREFA:
      Redija um texto consolidado de 3 a 5 parágrafos.
      - Comece descrevendo o perfil geral do aluno (pontencialidades e desafios identificados no checklist).
      - Relate o desempenho acadêmico com base nas avaliações dos professores, citando as disciplinas.
      - Mencione o esforço de adaptação curricular (citando o volume de aulas adaptadas).
      - Finalize com encaminhamentos ou sugestões para o próximo ciclo.

      TOM DE VOZ: Formal, Técnico, Acolhedor.
      FORMATO: Texto corrido (sem markdown, sem tópicos), pronto para impressão oficial.
    `;

    } else if (action === 'generateBlock9Adaptation') {
      const { lessonContent, lessonTitle, subject, gradeLevel, habilidadesBncc = [], studentPdiContext = {} } = body;
      if (!lessonContent || !lessonTitle || !subject || !gradeLevel) {
        return { status: 400, jsonBody: { error: 'Missing parameters for generateBlock9Adaptation' } };
      }

      isJsonResponse = true;
      systemInstruction = "Você é especialista em inclusão escolar e DUA gerando adaptações curriculares (JSON).";
      prompt = `
ATUE COMO UM ESPECIALISTA EM INCLUSÃO ESCOLAR E DESENHO UNIVERSAL PARA APRENDIZAGEM (DUA).

${guardrailsPrompt}

CONTEXTO:
Um professor acabou de salvar um planejamento de aula. O sistema deve AUTOMATICAMENTE gerar uma adaptação curricular para um aluno com PDI ativo.

DADOS DA AULA ORIGINAL:
Título: ${sanitizeInput(lessonTitle, 200)}
Disciplina: ${sanitizeInput(subject, 100)}
Série: ${sanitizeInput(gradeLevel, 50)}
Conteúdo: ${lessonContent.substring(0, 2500)}
Habilidades BNCC: ${habilidadesBncc.map((h: string) => sanitizeInput(h, 20)).join(', ')}

PERFIL DO ALUNO (BLOCOS 1-8 DO PDI):
Nome: ${sanitizeInput(studentPdiContext.nome_completo, 100)}
Diagnóstico: ${sanitizeInput(studentPdiContext.diagnostico_clinico, 200) || 'Não especificado'}
Necessidades Específicas: ${(studentPdiContext.necessidades_especificas ?? []).map((s: string) => sanitizeInput(s, 100)).join(', ') || 'Não especificadas'}
Potencialidades: ${(studentPdiContext.potencialidades ?? []).map((s: string) => sanitizeInput(s, 100)).join(', ') || 'Não especificadas'}
Desafios: ${(studentPdiContext.desafios ?? []).map((s: string) => sanitizeInput(s, 100)).join(', ') || 'Não especificados'}
Objetivo Geral do PDI: ${sanitizeInput(studentPdiContext.objetivo_geral, 300) || 'Não especificado'}
Recursos Disponíveis: ${(studentPdiContext.recursos_tecnologicos ?? []).map((s: string) => sanitizeInput(s, 100)).join(', ') || 'Padrão'}
Materiais Adaptados: ${(studentPdiContext.materiais_adaptados ?? []).map((s: string) => sanitizeInput(s, 100)).join(', ') || 'Nenhum especificado'}

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

    } else if (action === 'generateBlock10Diagnosis') {
      const { evaluationData = {}, fullPdiContext = {} } = body;
      if (!evaluationData.atividade_titulo || !evaluationData.disciplina) {
        return { status: 400, jsonBody: { error: 'Missing parameters for generateBlock10Diagnosis' } };
      }

      isJsonResponse = true;
      const diagnostico_inicial = fullPdiContext.block_1_8?.bloco_1_identificacao?.diagnostico_clinico || 'Não especificado';
      const necessidades = fullPdiContext.block_1_8?.bloco_2_diagnostico?.necessidades_especificas || [];
      const potencialidades = fullPdiContext.block_1_8?.bloco_2_diagnostico?.potencialidades || [];
      const desafios = fullPdiContext.block_1_8?.bloco_2_diagnostico?.desafios || [];
      const objetivo_geral = fullPdiContext.block_1_8?.bloco_3_objetivos?.objetivo_geral || '';
      const adaptacoesRecentes = (fullPdiContext.block_9_history || [])
          .slice(-3)
          .map((a: any) => `- ${a.lesson_title}: ${a.adaptacao_metodologica?.substring(0, 150)}...`)
          .join('\n');
      const avaliacoesAnteriores = (fullPdiContext.block_10_history || [])
          .slice(-3)
          .map((av: any) => {
              const percentual = safePercent(av.professor_nota_alcancada as number, av.professor_valor as number);
              return `- ${sanitizeInput(av.atividade_titulo, 100)}: ${percentual}% (Autonomia: ${av.professor_grau_autonomia})`;
          })
          .join('\n');
      const percentualAtual = safePercent(evaluationData.professor_nota_alcancada, evaluationData.professor_valor, 1);

      systemInstruction = "Você é especialista em avaliação pedagógica e educação inclusiva.";
      prompt = `
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

2. DIAGNÓSTICO PEDAGÓGICO (200-350 palavras):
Analise de forma técnica e objetiva:
- POTENCIAIS: O que o aluno demonstrou saber/conseguir fazer (seja específico)
- DESAFIOS: O que ainda precisa ser trabalhado (seja específico)
- PROGRESSÃO: Compare com avaliações anteriores se houver
- RECOMENDAÇÕES: 2-3 ações concretas para próximas aulas

FORMATO DE SAÍDA (JSON PURO):
{
  "ia_metodologia": "Texto narrativo descrevendo como a avaliação foi realizada...",
  "ia_diagnostico": "Análise técnica estruturada: Potenciais observados: [...]. Desafios identificados: [...]. Progressão em relação a avaliações anteriores: [...]. Recomendações: [...]"
}
      `;

    } else if (action === 'generateBlock11Report') {
      const { pdiDocument = {} } = body;
      if (!pdiDocument.student_name) {
        return { status: 400, jsonBody: { error: 'Missing parameters for generateBlock11Report' } };
      }

      const identificacao = pdiDocument.block_1_8?.bloco_1_identificacao || {};
      const objetivos = pdiDocument.block_1_8?.bloco_3_objetivos || {};
      const totalAdaptacoes = pdiDocument.block_9_content?.length || 0;
      const disciplinasAdaptadas = [...new Set(pdiDocument.block_9_content?.map((a: any) => a.subject) || [])];
      const avaliacoes = pdiDocument.block_10_entries || [];
      const mediaGeral = avaliacoes.length > 0
          ? (avaliacoes.reduce((sum: number, av: any) =>
              sum + (av.professor_valor > 0 ? (av.professor_nota_alcancada / av.professor_valor) * 100 : 0), 0
          ) / avaliacoes.length).toFixed(1)
          : 'N/A';
      const autonomiaTotal = avaliacoes.filter((av: any) => av.professor_grau_autonomia === 'total').length;
      const autonomiaParcial = avaliacoes.filter((av: any) => av.professor_grau_autonomia === 'parcial').length;
      const autonomiaDependente = avaliacoes.filter((av: any) => av.professor_grau_autonomia === 'dependente').length;
      const ultimasAvaliacoes = avaliacoes.slice(-3).map((av: any) => {
          const percentual = safePercent(av.professor_nota_alcancada, av.professor_valor);
          return `- ${sanitizeInput(av.atividade_titulo, 100)}: ${percentual}% (${av.professor_grau_autonomia})`;
      });

      systemInstruction = "Você é um coordenador pedagógico sênior especialista em educação inclusiva.";
      prompt = `
ATUE COMO UM COORDENADOR PEDAGÓGICO SÊNIOR E ESPECIALISTA EM EDUCAÇÃO INCLUSIVA.

CONTEXTO:
Você está finalizando o PDI (Plano de Desenvolvimento Individual) de um estudante ao final do período letivo.

DADOS DO PDI COMPLETO:

BLOCOS 1-3:
Nome: ${identificacao.nome_completo || pdiDocument.student_name}
Diagnóstico: ${identificacao.diagnostico_clinico || 'Não especificado'}
Objetivos: ${objetivos.objetivo_geral || 'Não especificado'}

BLOCO 9 (ADAPTAÇÕES):
Total: ${totalAdaptacoes}
Disciplinas: ${disciplinasAdaptadas.join(', ') || 'Nenhuma'}

BLOCO 10 (DESEMPENHO):
Média Geral: ${mediaGeral}%
Distribuição Autonomia: Total(${autonomiaTotal}), Parcial(${autonomiaParcial}), Dependente(${autonomiaDependente})

ÚLTIMAS AVALIAÇÕES:
${ultimasAvaliacoes.join('\n') || 'Sem avaliações recentes'}

TAREFA: GERAR RELATÓRIO FINAL (BLOCO 11)
Crie um RELATÓRIO TÉCNICO-PEDAGÓGICO NARRATIVO e OFICIAL (900-1300 palavras).
1. INTRODUÇÃO
2. DESENVOLVIMENTO PEDAGÓGICO
3. PROGRESSÃO NA AUTONOMIA
4. RECOMENDAÇÕES PARA CONTINUIDADE
5. CONSIDERAÇÕES FINAIS

Use linguagem TÉCNICA mas ACESSÍVEL. Mantenha formato NARRATIVO.
      `;

    } else {
      return { status: 400, jsonBody: { error: `Unsupported action: ${action}` } };
    }

    // 4. Invocar LLM no Servidor
    let rawOutput = await executeLLM(prompt, systemInstruction, provider, model);

    // 5. Aplicar Filtro de Privacidade (DLP)
    let sanitizedOutput = redactSensitiveData(rawOutput);

    // 6. Formatar Resposta de Saída
    let responseBody: any;
    if (isJsonResponse) {
      const cleanedJson = extractJsonObjectFromText(sanitizedOutput);
      try {
        responseBody = JSON.parse(cleanedJson);
      } catch {
        // IA retornou output não-JSON; devolve como texto para o cliente não receber 500
        responseBody = { text: sanitizedOutput, _parseError: true };
      }
    } else {
      responseBody = { text: sanitizedOutput };
    }

    // 7. Telemetria de Sucesso
    const latencyMs = Date.now() - startTime;
    logger.info(`[PDI Proxy] Geração realizada com sucesso para action=${action}`, {
      userId,
      userEmail,
      action,
      provider,
      latencyMs
    });

    return {
      status: 200,
      jsonBody: responseBody
    };

  } catch (error: any) {
    const latencyMs = Date.now() - startTime;
    logger.error(`[PDI Proxy] Erro na geração para action=${action}: ${error?.message || error}`, {
      userId,
      userEmail,
      action,
      provider,
      latencyMs
    });

    return {
      status: 500,
      jsonBody: { error: `PDI Proxy error: ${error?.message || error}` }
    };
  }
}

app.http('pdiProxy', {
  methods: ['POST'],
  authLevel: 'anonymous',
  handler: pdiProxy,
});
