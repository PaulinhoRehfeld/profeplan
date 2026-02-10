import { GoogleGenerativeAI } from "@google/generative-ai";
import { executeWithFallback, getGenAIClient } from "./AiCore";
import { checkUsageQuota, incrementUserUsage } from "../ProfileService";
import { searchCurriculum } from "../searchService"; // Import from searchService
import { SYSTEM_PROMPT } from "../../constants";

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
        reserves: Record<string, unknown>;
        userId?: string;
        level?: string;
        feedback?: string;
        pnld_book_id?: string;
    }
) => {
    const genAI = getGenAIClient();

    // Check Quota
    if (context.userId) {
        const quotaStatus = await checkUsageQuota(context.userId);
        if (!quotaStatus.allowed) {
            throw new Error(quotaStatus.message);
        }
    }

    // --- RAG: Busca Curricular + Normalização Escalável ---
    let curriculumContext = "";
    try {
        // 1. Normalização do Ano/Nível (Crucial para o BUG do usuário)
        const num = context.grade.replace(/\D/g, ''); // Extract '2' from '2º Ano'
        let normalizedGrade = `${num}º Ano`;
        if (context.level === 'Ensino Médio') {
            normalizedGrade = `${num}º Ano EM`;
        }

        // 2. Normalização da Disciplina via Tabela subject_aliases
        // ✅ NOVA ABORDAGEM: Usa serviço escalável ao invés de hardcode
        const { normalizeSubject } = await import('../SubjectNormalizationService');
        const normalizedSubject = await normalizeSubject(context.subject);

        const periodString = `${context.period}º Trimestre`;

        console.log(`🔍 Buscando currículo para: ${normalizedSubject}, ${normalizedGrade}, ${periodString}`);

        // 3. Busca com Filtros
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
            curriculumContext = results.map((r) => {
                const row = r as { metadata?: { ano_base?: number }; content?: string };
                const year = row.metadata?.ano_base || 2025;
                const sourceTag = year === 2025 ? " (Base curricular 2025)" : "";
                return `${row.content || ''}${sourceTag}`;
            }).join('\n\n---\n\n');
            console.log(`✅ Encontrados ${results.length} trechos de currículo.`);
        } else {
            console.warn("⚠️ Nenhum currículo encontrado no banco para estes filtros.");
        }

    } catch (err) {
        console.error("Erro na busca RAG:", err);
    }

    // --- REGRAS DE NEGÓCIO DO LIVRO PNLD (EDUCAÇÃO DIGITAL - FTD) ---
    // Regra: 18 capítulos / 3 anos = 6 caps por ano / 3 tri = 2 caps por trimestre
    let pnldInstruction = "";
    if (context.pnld_book_id && typeof context.pnld_book_id === 'string' &&
        (context.pnld_book_id.toLowerCase().includes('educação digital') || context.pnld_book_id.toLowerCase().includes('educacao digital'))) {

        const chapters = calculateDigitalEducationChapters(context.grade, context.period);
        if (chapters) {
            pnldInstruction = `
    [REGRA MANDATÓRIA DO LIVRO DIDÁTICO]:
    O professor escolheu o livro: "${context.pnld_book_id}" (Volume Único para o Ensino Médio).
    Seguindo a grade curricular estrita para este período (${context.grade} - ${context.period}º Trimestre), você DEVE utilizar EXCLUSIVAMENTE os seguintes capítulos:
    👉 ${chapters}
    
    INSTRUÇÃO:
    - Baseie o plano de aula APENAS nesses capítulos e nos temas abarcados por eles.
    - Ignore conteúdos de outros bimestres/anos deste mesmo livro.
    `;
            console.log(`📚 Regra PNLD Aplicada: ${chapters}`);
        }
    } else if (context.pnld_book_id) {
        // Regra Genérica para outros livros
        pnldInstruction = `
    [LIVRO DIDÁTICO SELECIONADO]:
    O professor utilizará o livro: "${context.pnld_book_id}".
    Sempre que possível, sugira atividades e leituras conectadas a este material.
        `;
    }

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
    - Período: ${context.period}º Trimestre
    - Regra de Pontuação: ${context.period === 3 ? '40 pontos totais no trimestre' : '30 pontos totais no trimestre'}
    - Avaliações: Prova 1 e Prova 2
    - Total de Aulas: ${context.totalClasses}

    [DADOS DO CURRÍCULO OFICIAL]:
    ${curriculumContext ? curriculumContext : "Use a BNCC geral."}
    
    ${pnldInstruction}

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
            await incrementUserUsage(context.userId, 'term_plan');
        }

        return text; // Return raw Markdown
    });
};

/**
 * [SIMPLE_CHAT_ADAPTER]
 * Versão simplificada para o PlanningManager que espera uma Promise<string>
 * em vez de stream.
 */
export const generateGeminiContent = async (
    prompt: string,
    history: unknown[] = [],
    context: string = '',
    userId?: string,
    temperature: number = 0.7 // Default to creative
) => {
    const genAI = getGenAIClient();

    // Constrói o histórico no formato Gemini
    const chatHistory = history.map((msg) => {
        const entry = msg as { role?: string; content?: string };
        return {
            role: entry.role === 'user' ? 'user' : 'model',
            parts: [{ text: entry.content || '' }]
        };
    });

    const systemInstruction = `${SYSTEM_PROMPT} \n\n[CONTEXTO ATUAL]: ${context} `;

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

    if (userId) await incrementUserUsage(userId, 'chat');

    return response;
};

/**
 * Calcula os capítulos do livro "Educação Digital" (FTD) volume único.
 * Regra: 18 Capítulos totais.
 * 1º Ano: Caps 1-6
 * 2º Ano: Caps 7-12
 * 3º Ano: Caps 13-18
 * Divididos igualmente por 3 trimestres (2 caps por tri).
 */
function calculateDigitalEducationChapters(gradeStr: string, period: number): string | null {
    // Extrai o número do ano (1º, 2º, 3º)
    const gradeNum = parseInt(gradeStr.replace(/\D/g, '')) || 0;

    // Validação básica (apenas EM 1-3)
    if (gradeNum < 1 || gradeNum > 3) return null;

    // Lógica Matemática
    // Offset de Ano: (Ano - 1) * 6
    // Offset de Período: (Período - 1) * 2
    // Start Chapter = OffsetAno + OffsetPeriodo + 1

    const yearOffset = (gradeNum - 1) * 6;
    const periodOffset = (period - 1) * 2;

    const startCap = yearOffset + periodOffset + 1;
    const endCap = startCap + 1;

    return `CAPÍTULOS ${startCap} e ${endCap}`;
}
