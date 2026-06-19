export const maxDuration = 60;
import type { VercelRequest, VercelResponse } from '@vercel/node';
import OpenAI from 'openai';

const logger = {
  info: (msg: string, meta?: unknown) => console.log(JSON.stringify({ level: 'INFO', message: msg, ...(meta ? { meta } : {}) })),
  error: (msg: string, meta?: unknown) => console.error(JSON.stringify({ level: 'ERROR', message: msg, ...(meta ? { meta } : {}) })),
};

type GuardrailsConfig = {
  methodology?: string;
  pedagogicalStyle?: string;
  assessmentFocus?: string;
  writingTone?: string;
  context?: string;
};

const getDeepSeekClient = (): { client: OpenAI; model: string } | null => {
  const apiKey = process.env.DEEPSEEK_API_KEY?.trim() || process.env.OPENAI_API_KEY?.trim();
  if (!apiKey) return null;
  const isDeepSeek = apiKey.startsWith('sk-f2a4') || !!process.env.DEEPSEEK_API_KEY;
  const model = isDeepSeek ? 'deepseek-chat' : (process.env.OPENAI_MODEL || 'gpt-4o-mini');
  return {
    client: new OpenAI({
      apiKey,
      baseURL: isDeepSeek ? (process.env.DEEPSEEK_API_BASE?.trim() || 'https://api.deepseek.com') : undefined,
    }),
    model,
  };
};

const generateGuardrailsPrompt = (config?: GuardrailsConfig): string => {
  if (!config) return '';
  const parts: string[] = ['[🛡️ GUARDRAILS PEDAGÓGICOS]'];
  if (config.methodology) parts.push(`Metodologia: ${config.methodology}`);
  if (config.pedagogicalStyle) parts.push(`Estilo: ${config.pedagogicalStyle}`);
  if (config.assessmentFocus) parts.push(`Foco avaliativo: ${config.assessmentFocus}`);
  if (config.writingTone) parts.push(`Tom: ${config.writingTone}`);
  if (config.context) parts.push(`Contexto: ${config.context}`);
  return parts.join('\n') + '\n\n';
};

const extractJsonFromText = (raw: string): string => {
  const text = (raw || '').trim();
  const unfenced = text.replace(/^\s*```(?:json)?\s*/i, '').replace(/\s*```\s*$/i, '').trim();
  if ((unfenced.startsWith('{') && unfenced.endsWith('}')) || (unfenced.startsWith('[') && unfenced.endsWith(']'))) {
    return unfenced;
  }
  const objMatch = unfenced.match(/\{[\s\S]*\}/);
  if (objMatch?.[0]) return objMatch[0];
  const arrMatch = unfenced.match(/\[[\s\S]*\]/);
  if (arrMatch?.[0]) return arrMatch[0];
  return unfenced;
};

const chatCompletion = async (
  client: OpenAI,
  model: string,
  systemInstruction: string,
  prompt: string,
  isJson: boolean = false,
): Promise<string> => {
  const response = await client.chat.completions.create({
    model,
    messages: [
      { role: 'system', content: systemInstruction },
      { role: 'user', content: prompt },
    ],
    temperature: 0.7,
    max_tokens: isJson ? 2000 : 4000,
  });
  return response.choices[0]?.message?.content || '';
};

export default async function handler(req: VercelRequest, res: VercelResponse) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method Not Allowed' });
  }

  const deepseek = getDeepSeekClient();
  if (!deepseek) {
    return res.status(500).json({ error: 'DEEPSEEK_API_KEY ou OPENAI_API_KEY não configurada no servidor.' });
  }

  let body: any;
  try {
    body = req.body || {};
  } catch {
    return res.status(400).json({ error: 'Invalid JSON body' });
  }

  const { action, guardrailsConfig } = body;

  if (!action) {
    return res.status(400).json({ error: 'Parameter "action" is required' });
  }

  try {
    let systemInstruction = '';
    let prompt = '';
    let isJson = false;
    const guardrailsPrompt = generateGuardrailsPrompt(guardrailsConfig);

    switch (action) {
      case 'generateStudentAdaptation': {
        const { originalContent, studentName, deficiencies = [], observations = '', gradeLevel, stateBase, educationSphere } = body;
        if (!originalContent || !studentName || !gradeLevel) {
          return res.status(400).json({ error: 'Missing parameters for generateStudentAdaptation' });
        }
        systemInstruction = 'Você é um especialista em inclusão e DUA escrevendo adaptações de aula.';
        prompt = `ATUE COMO UM ESPECIALISTA EM INCLUSÃO E DESENHO UNIVERSAL PARA APRENDIZAGEM (DUA).

${guardrailsPrompt}

AULA ORIGINAL:
"${originalContent.substring(0, 3000)}"

PERFIL DO ALUNO:
Nome: ${studentName}
Série: ${gradeLevel}
Necessidades/Diagnósticos: ${deficiencies.join(', ')}
Observações do Professor: ${observations}
${stateBase ? `CONTEXTO CURRICULAR:\nBase: ${stateBase} (${educationSphere || 'Geral'})` : ''}

TAREFA: Crie uma adaptação desta aula especificamente para o aluno.
RETORNE EM MARKDOWN: ## 🎯 Objetivos Adaptados, ## 🛠️ Estratégias de Acesso, ## 📝 Atividade Adaptada, ## 📏 Avaliação Diferenciada.`;
        break;
      }

      case 'generatePdiReport': {
        const { logs = [], studentName, period } = body;
        if (!studentName || !period) {
          return res.status(400).json({ error: 'Missing parameters for generatePdiReport' });
        }
        const logsSummary = logs.map((l: any) =>
          `- ${l.created_at ? new Date(l.created_at).toLocaleDateString('pt-BR') : 'Data desconhecida'}: ${l.content?.substring(0, 100) || 'Adaptação'}...`
        ).join('\n');

        systemInstruction = 'Você é um especialista em educação especial redigindo relatórios oficiais de PDI.';
        prompt = `ATUE COMO UM ESPECIALISTA EM EDUCAÇÃO ESPECIAL E INCLUSIVA.

ALUNO: ${studentName} | PERÍODO: ${period}

HISTÓRICO DE ADAPTAÇÕES:
${logsSummary}

TAREFA: Escreva um relatório técnico-pedagógico narrativo em texto corrido (prosa), sem bullet points, tom formal e acolhedor.`;
        break;
      }

      case 'generateFinalPDIReport': {
        const { studentName, profileData = {}, evaluations = [], adaptationCount = 0 } = body;
        if (!studentName) {
          return res.status(400).json({ error: 'Missing parameters for generateFinalPDIReport' });
        }
        const evalsText = evaluations.map((e: any) =>
          `- ${e.subject || 'Geral'} (${e.period || 1}º Tri): Autonomia ${e.autonomy_level || 'n/d'}. Obs: "${e.pedagogical_diagnosis || ''}"`
        ).join('\n');

        systemInstruction = 'Você é um gestor educacional especialista em inclusão.';
        prompt = `ATUE COMO UM GESTOR EDUCACIONAL ESPECIALISTA EM INCLUSÃO.

ALUNO: ${studentName}
AULAS ADAPTADAS NO PERÍODO: ${adaptationCount}
PERFIL: ${JSON.stringify(profileData, null, 2)}
AVALIAÇÕES: ${evalsText || 'Nenhuma avaliação registrada.'}

TAREFA: Redija um relatório final do PDI em 3-5 parágrafos, texto corrido, tom formal e acolhedor, pronto para impressão oficial.`;
        break;
      }

      case 'generateBlock9Adaptation': {
        const { lessonContent, lessonTitle, subject, gradeLevel, habilidadesBncc = [], studentPdiContext = {} } = body;
        if (!lessonContent || !lessonTitle || !subject || !gradeLevel) {
          return res.status(400).json({ error: 'Missing parameters for generateBlock9Adaptation' });
        }
        isJson = true;
        systemInstruction = 'Você é especialista em inclusão escolar e DUA gerando adaptações curriculares. Retorne APENAS JSON.';
        prompt = `ATUE COMO UM ESPECIALISTA EM INCLUSÃO ESCOLAR E DUA.

${guardrailsPrompt}

AULA: ${lessonTitle} | Disciplina: ${subject} | Série: ${gradeLevel}
Conteúdo: ${lessonContent.substring(0, 2500)}
Habilidades BNCC: ${habilidadesBncc.join(', ')}

PERFIL DO ALUNO:
Nome: ${studentPdiContext.nome_completo}
Diagnóstico: ${studentPdiContext.diagnostico_clinico || 'Não especificado'}
Necessidades: ${studentPdiContext.necessidades_especificas?.join(', ') || 'Não especificadas'}
Potencialidades: ${studentPdiContext.potencialidades?.join(', ') || 'Não especificadas'}
Desafios: ${studentPdiContext.desafios?.join(', ') || 'Não especificados'}
Objetivo PDI: ${studentPdiContext.objetivo_geral || 'Não especificado'}
Recursos: ${studentPdiContext.recursos_tecnologicos?.join(', ') || 'Padrão'}

Retorne APENAS JSON:
{
  "adaptacao_metodologica": "texto narrativo detalhado (150-400 palavras)",
  "recursos_adaptados": ["recurso1", "recurso2", "recurso3"],
  "objetivos_adaptados": ["obj1 mantendo rigor BNCC", "obj2 mantendo rigor BNCC"],
  "estrategias_ensino": ["estrategia1 DUA", "estrategia2 DUA", "estrategia3 DUA"],
  "tempo_estimado": "ex: 50 minutos"
}`;
        break;
      }

      case 'generateBlock10Diagnosis': {
        const { evaluationData = {}, fullPdiContext = {} } = body;
        if (!evaluationData.atividade_titulo || !evaluationData.disciplina) {
          return res.status(400).json({ error: 'Missing parameters for generateBlock10Diagnosis' });
        }
        isJson = true;
        const diagnostico = fullPdiContext.block_1_8?.bloco_1_identificacao?.diagnostico_clinico || 'Não especificado';
        const necessidades = fullPdiContext.block_1_8?.bloco_2_diagnostico?.necessidades_especificas || [];
        const potencialidades = fullPdiContext.block_1_8?.bloco_2_diagnostico?.potencialidades || [];
        const desafios = fullPdiContext.block_1_8?.bloco_2_diagnostico?.desafios || [];
        const objetivoGeral = fullPdiContext.block_1_8?.bloco_3_objetivos?.objetivo_geral || '';
        const percentualAtual = evaluationData.professor_valor
          ? ((evaluationData.professor_nota_alcancada / evaluationData.professor_valor) * 100).toFixed(1)
          : 'N/D';

        systemInstruction = 'Você é especialista em avaliação pedagógica e educação inclusiva. Retorne APENAS JSON.';
        prompt = `ATUE COMO UM ESPECIALISTA EM AVALIAÇÃO PEDAGÓGICA INCLUSIVA.

${guardrailsPrompt}

ALUNO: ${fullPdiContext.student_name}
Diagnóstico: ${diagnostico}
Necessidades: ${necessidades.join(', ')}
Potencialidades: ${potencialidades.join(', ')}
Desafios: ${desafios.join(', ')}
Objetivo Geral PDI: ${objetivoGeral}

ATIVIDADE AVALIADA: ${evaluationData.atividade_titulo} (${evaluationData.disciplina})
Nota: ${evaluationData.professor_nota_alcancada}/${evaluationData.professor_valor} (${percentualAtual}%)
Autonomia: ${evaluationData.professor_grau_autonomia || 'N/D'}
Observações: ${evaluationData.observacoes || 'Nenhuma'}

Retorne APENAS JSON:
{
  "ia_diagnostico": "análise detalhada do desempenho (100-250 palavras)",
  "ia_potencialidades_identificadas": ["pot1", "pot2"],
  "ia_desafios_identificados": ["desafio1", "desafio2"],
  "ia_recomendacoes": ["rec1", "rec2", "rec3"],
  "ia_projecao_proximo_periodo": "projeção narrativa (50-100 palavras)"
}`;
        break;
      }

      default:
        return res.status(400).json({ error: `Unknown action: ${action}` });
    }

    const result = await chatCompletion(deepseek.client, deepseek.model, systemInstruction, prompt, isJson);

    if (isJson) {
      const jsonStr = extractJsonFromText(result);
      try {
        const parsed = JSON.parse(jsonStr);
        return res.status(200).json(parsed);
      } catch {
        logger.error('[pdiProxy] Failed to parse JSON response, returning raw text');
        return res.status(200).json({ raw: result, error: 'Failed to parse JSON from AI response' });
      }
    }

    return res.status(200).json({ text: result });
  } catch (error: unknown) {
    const message = error instanceof Error ? error.message : 'Erro interno';
    logger.error(`[pdiProxy] Erro: ${message}`, error);
    return res.status(500).json({ error: message });
  }
}
