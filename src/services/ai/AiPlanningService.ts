import { GoogleGenerativeAI } from "@google/generative-ai";
import { executeWithFallback, getGenAIClient } from "./AiCore";
import { checkUsageQuota, incrementUserUsage } from "../userService";
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
        reserves: any;
        userId?: string;
        level?: string;
        feedback?: string;
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
    const genAI = getGenAIClient();

    // Constrói o histórico no formato Gemini
    const chatHistory = history.map(msg => ({
        role: msg.role === 'user' ? 'user' : 'model',
        parts: [{ text: msg.content }]
    }));

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

    if (userId) await incrementUserUsage(userId);

    return response;
};
