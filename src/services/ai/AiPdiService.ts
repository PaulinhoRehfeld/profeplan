import { checkUsageQuota, incrementUserUsage } from "../userService";
import { executeWithFallback, getGenAIClient } from "./AiCore";
import { GoogleGenerativeAI } from "@google/generative-ai";

type PdiLogEntry = {
    created_at?: string;
    content?: string;
};

type PdiEvaluationEntry = {
    subject?: string;
    period?: number;
    autonomy_level?: string;
    comprehension_level?: string;
    pedagogical_diagnosis?: string;
};

type PdiBlock9Entry = {
    lesson_title?: string;
    adaptacao_metodologica?: string;
};

type PdiBlock10Entry = {
    atividade_titulo?: string;
    professor_valor?: number;
    professor_nota_alcancada?: number;
    professor_grau_autonomia?: string;
};

type FullPdiContext = {
    student_name: string;
    content_data?: Record<string, unknown>;
    block_1_8?: Record<string, unknown>;
    block_9_history?: PdiBlock9Entry[];
    block_10_history?: PdiBlock10Entry[];
};

type PdiBlock11Document = {
    student_name: string;
    period: string;
    school_name?: string;
    content_data?: Record<string, unknown>;
    block_1_8?: Record<string, unknown>;
    block_9_content?: Array<PdiBlock9Entry & { subject?: string }>;
    block_10_entries?: PdiBlock10Entry[];
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
    // Check Quota
    if (context?.userId) {
        const quotaStatus = await checkUsageQuota(context.userId);
        if (!quotaStatus.allowed) {
            throw new Error(quotaStatus.message);
        }
    }

    const genAI = getGenAIClient();

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
            await incrementUserUsage(context.userId, 'generate'); // Fire and forget or await? Safe to wait.
        }

        return response.text();
    });
};


/**
 * [PDI_REPORT_MODE]
 * Gera um Relatório Bimestral de PDI baseado nos logs de adaptação.
 */
export const generatePdiReport = async (logs: PdiLogEntry[], studentName: string, period: string) => {
    const genAI = getGenAIClient();

    // Sintetiza os logs para não estourar o contexto
    const logsSummary = logs.map(l => {
        const dateLabel = l.created_at ? new Date(l.created_at).toLocaleDateString() : 'Data desconhecida';
        return `- Em ${dateLabel}: Adaptação focada em ${l.content?.substring(0, 100) || 'Conteúdo adaptado'}...`;
    }).join('\n');

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

/**
 * [PDI_CONSOLIDATOR_MODE]
 * Gera o Relatório Final (Item XI) consolidando Perfil + Avaliações.
 */
export const generateFinalPDIReport = async (data: {
    studentName: string;
    profileData: Record<string, unknown>;
    evaluations: PdiEvaluationEntry[];
    adaptationCount: number;
}) => {
    const genAI = getGenAIClient();

    // Formata Avaliações Docentes
    const evaluationsText = data.evaluations.map(e =>
        `- ${e.subject} (${e.period}º Tri): Autonomia ${e.autonomy_level}, Compreensão ${e.comprehension_level}. Obs: "${e.pedagogical_diagnosis}"`
    ).join('\n');

    // Formata Perfil (Resumo dos Checkboxes marcados como APRESENTA ou NAO_APRESENTA)
    // Simplificando o JSON para o prompt
    const profileSummary = JSON.stringify(data.profileData, null, 2);

    const prompt = `
      ATUE COMO UM GESTOR EDUCACIONAL ESPECIALISTA EM INCLUSÃO.
      ESCREVA O RELATÓRIO FINAL (ITEM XI) DO PLANO DE DESENVOLVIMENTO INDIVIDUAL (PDI).

      ALUNO: ${data.studentName}
      TOTAL DE AULAS ADAPTADAS NO PERÍODO: ${data.adaptationCount}

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

    const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });
    const result = await model.generateContent(prompt);
    return result.response.text();
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
    const genAI = getGenAIClient();

    if (userId) {
        const quotaStatus = await checkUsageQuota(userId);
        if (!quotaStatus.allowed) {
            throw new Error(quotaStatus.message);
        }
    }

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
        model: "gemini-2.0-flash",
        generationConfig: {
            responseMimeType: "application/json",
            temperature: 0.7
        }
    });

    try {
        const result = await model.generateContent(prompt);
        const text = result.response.text();

        if (userId) {
            await incrementUserUsage(userId, 'generate');
        }

        const parsed = JSON.parse(text);

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
    fullPdiContext: FullPdiContext,
    userId?: string
): Promise<{
    ia_metodologia: string;
    ia_diagnostico: string;
}> => {
    const genAI = getGenAIClient();

    if (userId) {
        const quotaStatus = await checkUsageQuota(userId);
        if (!quotaStatus.allowed) {
            throw new Error(quotaStatus.message);
        }
    }

    const diagnostico_inicial = fullPdiContext.block_1_8?.bloco_1_identificacao?.diagnostico_clinico || 'Não especificado';
    const necessidades = fullPdiContext.block_1_8?.bloco_2_diagnostico?.necessidades_especificas || [];
    const potencialidades = fullPdiContext.block_1_8?.bloco_2_diagnostico?.potencialidades || [];
    const desafios = fullPdiContext.block_1_8?.bloco_2_diagnostico?.desafios || [];
    const objetivo_geral = fullPdiContext.block_1_8?.bloco_3_objetivos?.objetivo_geral || '';

    const adaptacoesRecentes = (fullPdiContext.block_9_history || [])
        .slice(-3)
        .map((a) => `- ${a.lesson_title}: ${a.adaptacao_metodologica?.substring(0, 150)}...`)
        .join('\n');

    const avaliacoesAnteriores = (fullPdiContext.block_10_history || [])
        .slice(-3)
        .map((av) => {
            const percentual = ((av.professor_nota_alcancada as number) / (av.professor_valor as number) * 100).toFixed(0);
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

    const model = genAI.getGenerativeModel({
        model: "gemini-2.0-flash",
        generationConfig: {
            responseMimeType: "application/json",
            temperature: 0.6
        }
    });

    try {
        const result = await model.generateContent(prompt);
        const text = result.response.text();

        if (userId) {
            await incrementUserUsage(userId, 'generate');
        }

        const parsed = JSON.parse(text);

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
    pdiDocument: PdiBlock11Document,
    userId?: string
): Promise<string> => {
    const genAI = getGenAIClient();

    if (userId) {
        const quotaStatus = await checkUsageQuota(userId);
        if (!quotaStatus.allowed) {
            throw new Error(quotaStatus.message);
        }
    }

    const identificacao = pdiDocument.block_1_8?.bloco_1_identificacao || {};
    const diagnostico = pdiDocument.block_1_8?.bloco_2_diagnostico || {};
    const objetivos = pdiDocument.block_1_8?.bloco_3_objetivos || {};

    const totalAdaptacoes = pdiDocument.block_9_content?.length || 0;
    const disciplinasAdaptadas = [...new Set(pdiDocument.block_9_content?.map((a) => a.subject) || [])];

    const avaliacoes = pdiDocument.block_10_entries || [];
    const mediaGeral = avaliacoes.length > 0
        ? (avaliacoes.reduce((sum: number, av) =>
            sum + ((av.professor_nota_alcancada as number) / (av.professor_valor as number)) * 100, 0
        ) / avaliacoes.length).toFixed(1)
        : 'N/A';

    const autonomiaTotal = avaliacoes.filter((av) => av.professor_grau_autonomia === 'total').length;
    const autonomiaParcial = avaliacoes.filter((av) => av.professor_grau_autonomia === 'parcial').length;
    const autonomiaDependente = avaliacoes.filter((av) => av.professor_grau_autonomia === 'dependente').length;

    const ultimasAvaliacoes = avaliacoes.slice(-3).map((av) => ({
        atividade: av.atividade_titulo,
        percentual: ((av.professor_nota_alcancada / av.professor_valor) * 100).toFixed(0),
        autonomia: av.professor_grau_autonomia,
        diagnostico: av.ia_diagnostico?.substring(0, 200) + '...',
    }));

    const prompt = `
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

TAREFA: GERAR RELATÓRIO FINAL (BLOCO 11)
Crie um RELATÓRIO TÉCNICO-PEDAGÓGICO NARRATIVO e OFICIAL (900-1300 palavras).
1. INTRODUÇÃO
2. DESENVOLVIMENTO PEDAGÓGICO
3. PROGRESSÃO NA AUTONOMIA
4. RECOMENDAÇÕES PARA CONTINUIDADE
5. CONSIDERAÇÕES FINAIS

Use linguagem TÉCNICA mas ACESSÍVEL. Mantenha formato NARRATIVO.
  `;

    const model = genAI.getGenerativeModel({
        model: "gemini-2.0-flash",
        generationConfig: {
            temperature: 0.7
        }
    });

    try {
        const result = await model.generateContent(prompt);
        const text = result.response.text();

        if (userId) {
            await incrementUserUsage(userId, 'generate');
        }

        return text;
    } catch (error) {
        console.error("Erro ao gerar relatório Bloco 11:", error);
        throw new Error("Não foi possível gerar o relatório final. Tente novamente.");
    }
};
