import { executeWithFallback, getGenAIClient } from "./AiCore";
import { checkUsageQuota, incrementUserUsage } from "../ProfileService";
import { searchCurriculum, getDeterministicCurriculum } from "../searchService"; // Import from searchService
import { SYSTEM_PROMPT } from "../../constants";
import { extractGuardrailsFromSettings, generateGuardrailsPrompt, AIGuardrailsConfig } from "./AiGuardrailsService";
import { UserSettings } from "../../types";

export interface GenerateTermPlanOptions {
    /** Quando true, pula check/deduction de créditos (usado pelo PlanningOrchestrator) */
    skipCredits?: boolean;
}

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
        gradingGrid?: {
            vistos?: number;
            trabalhos?: number;
            monthlyExam?: number;
            termExam?: number;
            others?: number;
        };
        userSettings?: UserSettings; // ✨ NOVO: Preferências do professor
    },
    opts?: GenerateTermPlanOptions
) => {
    const client = getGenAIClient();
    const skipCredits = opts?.skipCredits ?? false;

    // Check Quota (skip quando chamado via PlanningOrchestrator)
    if (!skipCredits && context.userId) {
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

        // --- DETERMINISTIC CURRICULUM RETRIEVAL (SEE/MG PRIORITIZATION) ---
        // If state is Minas Gerais and it's Chemistry, Biology or Physics, we try to get the full SEE curriculum first.
        if (context.stateBase?.includes('Minas Gerais') || context.stateBase === 'MG') {
            const seeCurriculum = await getDeterministicCurriculum(normalizedSubject, periodString, normalizedGrade);
            if (seeCurriculum) {
                console.log("📍 SEE MG OFFICIAL: Determinstic curriculum loaded.");
                curriculumContext = `[CURRÍCULO OFICIAL SEE/MG]:\n${seeCurriculum}`;
            }
        }

        if (!curriculumContext) {
            // Fallback to RAG if deterministic fails or is not MG
            const results = await searchCurriculum(
                `Planejamento e Habilidades de ${normalizedSubject} para ${normalizedGrade} no ${periodString}`,
                {
                    disciplina: normalizedSubject,
                    ano: normalizedGrade,
                    periodo: periodString
                },
                5
            ) as any[];

            if (results && results.length > 0) {
                curriculumContext = results.map((r) => {
                    const row = r as { metadata?: { ano_base?: number }; content?: string };
                    const year = row.metadata?.ano_base || 2025;
                    const sourceTag = year === 2025 ? " (Base curricular 2025)" : "";
                    return `${row.content || ''}${sourceTag}`;
                }).join('\n\n---\n\n');
                console.log(`✅ Encontrados ${results.length} trechos de currículo via RAG.`);
            }
        }

        // --- CÁLCULO DAS POSIÇÕES DAS PROVAS ---

    } catch (err) {
        console.error("Erro na busca RAG:", err);
    }

    // --- 🛡️ GUARDRAILS PEDAGÓGICOS (RLM-001: OBRIGATÓRIO) ---
    let guardrailsPrompt = "";
    if (context.userSettings) {
        const guardrailsConfig = extractGuardrailsFromSettings(context.userSettings);
        // Adiciona contexto do período aos guardrails
        guardrailsConfig.context = `${context.period}º Trimestre - ${context.subject} - ${context.grade}`;
        guardrailsPrompt = generateGuardrailsPrompt(guardrailsConfig, true); // true = permite override via feedback
        console.log('🛡️ Guardrails Aplicados:', guardrailsConfig);
    } else {
        console.warn('⚠️ UserSettings não fornecido. Guardrails não aplicados!');
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
    Sempre que possível, sugira atividades e leituras conectadas a este materialGuardrails.
        `;
    }

    // --- CÁLCULO DAS POSIÇÕES DAS PROVAS ---
    // Regra do Usuário: "Prova 1 deve ser aplicada na metade das aulas programadas (se 12 aulas, prova na aula 7)"
    // Matematicamente: Math.floor(total / 2) + 1. Para 12: 6 + 1 = 7. Para 10: 5 + 1 = 6.
    const reserves: Record<string, unknown> = context.reserves || {};
    const monthlyExamEnabled = reserves.monthlyExam === true;
    const termExamEnabled = reserves.termExam === true;
    const recoveryEnabled = reserves.recovery === true;

    const midpoint = Math.floor(context.totalClasses / 2) + 1;
    const penultimateClass = context.totalClasses - 1;
    const lastClass = context.totalClasses;

    // --- GRADE DE PONTOS ---
    const grading = context.gradingGrid || {};
    const prova01Points = grading.monthlyExam || 15;
    const prova02Points = grading.termExam || 15;
    const vistosPoints = grading.vistos || 0;
    const trabalhosPoints = grading.trabalhos || 0;
    const othersPoints = grading.others || 0;

    const totalPoints = prova01Points + prova02Points + vistosPoints + trabalhosPoints + othersPoints;

    // Extrai códigos de habilidades do currículo para listar explicitamente no prompt
    const extractedCodes = curriculumContext
        ? [...curriculumContext.matchAll(/\b(E[MF]\d{2}[A-Z]{2,5}\d{2,4}[A-Z0-9]*)\b/g)].map(m => m[1])
        : [];
    const uniqueCodes = [...new Set(extractedCodes)];
    const codesBlock = uniqueCodes.length > 0
        ? `\n[CÓDIGOS DE HABILIDADES IDENTIFICADOS NESTE PERÍODO]:\n${uniqueCodes.map(c => `• ${c}`).join('\n')}\n`
        : '';

    const prompt = `
    Atue como um Coordenador Pedagógico especialista em BNCC e currículos da Secretaria de Educação de Minas Gerais (SEE/MG).
    Gere um "MAPA DE PLANEJAMENTO DE AULA/2026" completo, rigoroso e FIEL ao currículo oficial abaixo.

    ${guardrailsPrompt}

    [DIRETRIZES CRÍTICAS DE GOVERNANÇA (RLM) — INVIOLÁVEIS]:
    1. CURRÍCULO É LEI: Cada aula DEVE trabalhar ao menos uma habilidade listada no bloco [CURRÍCULO OFICIAL SEE/MG] abaixo. Não invente habilidades.
    2. CODES OBRIGATÓRIOS: Use os códigos BNCC/SAEB extraídos (ex: EM13MAT101, EF09MA03) em cada aula na seção **BNCC:**.
    3. SEQUÊNCIA PEDAGÓGICA: Siga a ordem dos Objetos de Conhecimento e Unidades Temáticas exatamente como estão no currículo.
    4. ORIENTAÇÕES PEDAGÓGICAS: Incorpore as sugestões metodológicas oficiais (sala invertida, experimentos, discussões) nas descrições de aula.
    5. RIGOR NA AVALIAÇÃO: Prova 01 DEVE ser Aula ${midpoint}. Inegociável.
    6. GRADE DE PONTOS: Total DEVE somar ${totalPoints}.

    DADOS DO CONTEXTO:
    - Estado (Base Curricular): ${context.stateBase}
    - Esfera: ${context.educationSphere}
    - Professor: ${context.teacherName}
    - Componente: ${context.subject}
    - Nível de Ensino: ${context.level || 'Não especificado'}
    - Ano/Série: ${context.grade}
    - Período: ${context.period}º Trimestre
    - Total de Aulas: ${context.totalClasses}

    [CURRÍCULO OFICIAL SEE/MG — FONTE DA VERDADE (PRIORIDADE MÁXIMA)]:
    ${curriculumContext
        ? `${curriculumContext}\n${codesBlock}\n⚠️ TODO o conteúdo gerado DEVE ser derivado exclusivamente das habilidades e objetos de conhecimento acima.`
        : `⚠️ ATENÇÃO: Currículo oficial não encontrado no banco de dados para ${context.subject} / ${context.grade} / ${context.period}º Trimestre. Use a BNCC geral como fallback e ALERTE o professor no início do planejamento gerado.`
    }
    
    ${pnldInstruction}

    [GRADE DE AVALIAÇÃO OBRIGATÓRIA]:
    - PROVA 01: ${prova01Points} pontos (Agendada: Aula ${midpoint})
    - PROVA 02: ${prova02Points} pontos (Agendada: Aula ${penultimateClass})
    - VISTOS DE CADERNO: ${vistosPoints} pontos
    - TRABALHOS: ${trabalhosPoints} pontos
    - OUTROS: ${othersPoints} pontos
    - TOTAL DO TRIMESTRE: ${totalPoints} pontos

    [RESERVAS DE AULAS PARA AVALIAÇÕES]:
    ${monthlyExamEnabled ? `- Aula ${midpoint}: PROVA 01 (reserve esta aula exclusivamente para aplicação da prova)` : ''}
    ${termExamEnabled ? `- Aula ${penultimateClass}: PROVA 02 (reserve esta aula exclusivamente para aplicação da prova)` : ''}
    ${recoveryEnabled ? `- Aula ${lastClass}: RECUPERAÇÃO (reserve esta aula para recuperação de alunos)` : ''}

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

    ${monthlyExamEnabled ? `### Aula ${midpoint}: PROVA 01
    **Descrição:**
    Aplicação da primeira avaliação do trimestre (${prova01Points} pontos).
    **Conteúdo Abrangido:**
    Aulas 1 a ${midpoint - 1}
    ` : ''}

    ${termExamEnabled ? `### Aula ${penultimateClass}: PROVA 02
    **Descrição:**
    Aplicação da segunda avaliação do trimestre (${prova02Points} pontos).
    **Conteúdo Abrangido:**
    Aulas ${midpoint + 1} a ${penultimateClass - 1}
    ` : ''}

    ${recoveryEnabled ? `### Aula ${lastClass}: RECUPERAÇÃO
    **Descrição:**
    Atividades de recuperação e reforço para alunos que não atingiram os objetivos.
    ` : ''}

    ## 4. Avaliação

    A avaliação do ${context.period}º trimestre será composta por duas provas, com peso de ${prova01Points} pontos e ${prova02Points} pontos, respectivamente, totalizando ${totalPoints} pontos.

    **Critérios de Avaliação:**

    *   **PROVA 01 (${prova01Points} pontos):** ${monthlyExamEnabled ? `Será aplicada na Aula ${midpoint}, abrangendo os conteúdos das aulas 1 a ${midpoint - 1}, com ênfase na compreensão dos conceitos, capacidade de análise crítica e habilidade de argumentação.` : 'Não agendada neste planejamento.'}
    *   **PROVA 02 (${prova02Points} pontos):** ${termExamEnabled ? `Será aplicada na Aula ${penultimateClass}, abordando os conteúdos das aulas ${midpoint + 1} a ${penultimateClass - 1}.` : 'Não agendada neste planejamento.'}
    ${othersPoints > 0 ? `*   **OUTROS (${othersPoints} pontos):** Atividades complementares, trabalhos e participação.` : ''}

    **Instrumentos de Avaliação:**

    *   **Provas Escritas:** Questões dissertativas e objetivas que avaliarão a compreensão dos conceitos e a capacidade de aplicação do conhecimento.
    *   **Observação Contínua:** Avaliação da participação e do envolvimento dos alunos nas atividades em sala de aula, debates e discussões.
    *   **Trabalhos e Atividades:** (OPCIONAL - PODE SER USADO PARA RECUPERAÇÃO) Produção de textos, resenhas, apresentações e outras atividades que demonstrem a apropriação dos conteúdos e o desenvolvimento das habilidades.
  `;

    return executeWithFallback('TermPlan', async (modelName) => {
        const messages = [
            {
                role: "system" as const,
                content: SYSTEM_PROMPT,
            },
            {
                role: "user" as const,
                content: prompt,
            },
        ];

        const completion = await client.chat.completions.create({
            model: modelName,
            messages,
            temperature: 0.7,
        });

        const text = completion.choices[0]?.message?.content ?? "";

        // Increment Usage only on success (skip quando chamado via PlanningOrchestrator)
        if (!skipCredits && context.userId) {
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
    const client = getGenAIClient();

    const systemInstruction = `${SYSTEM_PROMPT} \n\n[CONTEXTO ATUAL]: ${context} `;

    const historyMessages = history.map((msg) => {
        const entry = msg as { role?: string; content?: string };
        const role = entry.role === "user" ? "user" : "assistant";
        return {
            role,
            content: entry.content || "",
        } as const;
    });

    const messages = [
        {
            role: "system" as const,
            content: systemInstruction,
        },
        ...historyMessages,
        {
            role: "user" as const,
            content: prompt,
        },
    ];

    // Check Quota
    if (userId) {
        const quota = await checkUsageQuota(userId);
        if (!quota.allowed) throw new Error(quota.message);
    }

    const completion = await client.chat.completions.create({
        model: "gpt-4o-mini", // será roteado pelo deployment configurado
        messages,
        temperature,
    } as any);

    const response =
        typeof completion.choices[0]?.message?.content === "string"
            ? completion.choices[0]?.message?.content
            : (completion.choices[0]?.message?.content as any[] | undefined)?.map((c) => (typeof c === "string" ? c : c.text || "")).join("") ?? "";

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
