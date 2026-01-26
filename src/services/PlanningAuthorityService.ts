
import { supabase } from './supabaseClient';
import { generateTermPlan } from './geminiService';
import { GoogleGenerativeAI } from "@google/generative-ai";

export interface PlanningIntent {
    subject: string;
    grade: string;
    level: 'Ensino Fundamental' | 'Ensino Médio';
    period: number;
    regime: 'Bimestre' | 'Trimestre';
    teacherName: string;
    stateBase: string;
    educationSphere: string;
    totalClasses: number;
    reserves: any;
    userId: string;
    feedback?: string; // New field for feedback loop
}

export interface GuardrailCheckResult {
    allowed: boolean;
    reason?: string;
    normalizedIntent?: PlanningIntent;
    warnings?: string[];
}

/**
 * PLANNING AUTHORITY SERVICE
 * O "Gestor" que controla o acesso à IA de Planejamento.
 */
export const PlanningAuthority = {

    /**
     * 1. INPUT GUARDRAIL
     * Verifica se o pedido é válido para o escopo do projeto (EF2 e EM).
     */
    validateIntent: (intent: PlanningIntent): GuardrailCheckResult => {
        // Normalização de Strings
        const gradeNum = parseInt(intent.grade.replace(/\D/g, '')) || 0;
        const level = intent.level;

        // Regra Crítica: Apenas EF2 (6-9) e EM (1-3)
        if (level === 'Ensino Fundamental') {
            if (gradeNum < 6) {
                return {
                    allowed: false,
                    reason: `BLOQUEIO DE ESCOPO: O sistema atende apenas Fundamental 2 (6º ao 9º). O ano solicitado (${gradeNum}º) pertence aos Anos Iniciais.`
                };
            }
            if (gradeNum > 9) {
                return { allowed: false, reason: `Ano inválido para Fundamental (${gradeNum}º).` };
            }
        }

        if (level === 'Ensino Médio') {
            if (gradeNum < 1 || gradeNum > 3) {
                return { allowed: false, reason: `Ano inválido para Ensino Médio (${gradeNum}º).` };
            }
        }

        // Normalização da Série (Grade) para bater com o Banco de Dados
        // O Banco usa "1º Ano EM", "6º Ano", etc.
        let normalizedGrade = `${gradeNum}º Ano`;
        if (level === 'Ensino Médio') {
            normalizedGrade = `${gradeNum}º Ano EM`;
        }

        const normalizedIntent = { ...intent, grade: normalizedGrade };

        return { allowed: true, normalizedIntent };
    },

    /**
     * 2. KNOWLEDGE BASE CHECK (Context Guardrail)
     * Verifica se existe currículo para essa matéria no banco.
     */
    checkKnowledgeBase: async (intent: PlanningIntent): Promise<boolean> => {
        // Tenta buscar pelo menos 1 chunk relevante
        const { count, error } = await supabase
            .from('curriculos_mg')
            .select('id', { count: 'exact', head: true })
            .ilike('metadata->>disciplina', `%${intent.subject}%`)
            .ilike('metadata->>ano_escolar', intent.grade) // Já deve vir normalizado validation
            .limit(1);

        if (error) {
            console.error("Erro ao checar Knowledge Base:", error);
            return false; // Fail safe? Ou Fail block? Vamos assumir false para avisar.
        }

        return (count || 0) > 0;
    },

    /**
     * 3. EXECUTION
     * Orquestra a geração se passar nos Guardrails.
     */
    executePlanning: async (intent: PlanningIntent) => {
        console.log("👮 PLANNING AUTHORITY: Recebendo intenção...", intent);

        // A. Input Guardrail
        const validation = PlanningAuthority.validateIntent(intent);
        if (!validation.allowed) {
            throw new Error(validation.reason);
        }

        const safeIntent = validation.normalizedIntent!;

        // B. Context Guardrail
        const hasKnowledge = await PlanningAuthority.checkKnowledgeBase(safeIntent);
        if (!hasKnowledge) {
            // Decisão de Governança: Permitimos com aviso ou Bloqueamos?
            // O user pediu "Guardrails que limitem ações".
            // Vamos logar aviso e injetar no prompt de sistema que o dado é ausente.
            console.warn(`⚠️ GOVERNANCE ALERT: Sem currículo base para ${safeIntent.subject} - ${safeIntent.grade}`);
        }

        // C. Execução Segura
        return await generateTermPlan({
            ...safeIntent,
            // Passa o nível explicitamente para o GeminiService (que já consertamos)
            level: safeIntent.level,
            feedback: safeIntent.feedback // Pass feedback to generator
        });
    },

    /**
     * 4. PEDAGOGICAL SPECIALIST
     * O Auditor que conversa com o usuário.
     */
    askSpecialist: async (message: string, context?: any) => {
        const apiKey = import.meta.env.VITE_GEMINI_API_KEY?.trim();
        if (!apiKey) throw new Error("API Key missing");

        const genAI = new GoogleGenerativeAI(apiKey);
        const model = genAI.getGenerativeModel({
            model: "gemini-1.5-flash",
            systemInstruction: `
            VOCÊ É UM ESPECIALISTA PEDAGÓGICO SÊNIOR (AUDITOR).
            NÃO É UM ASSISTENTE PESSOAL. SEU TOM É TÉCNICO, ANALÍTICO E DIRETIVO.

            SUA MISSÃO: Garantir a excelência pedagógica e o alinhamento com a BNCC e Currículo de MG.
            
            ESCOPO DE ATUAÇÃO:
            1. Analisar planos de aula e apontar inconsistências.
            2. Sugerir metodologias ativas (PBL, Gamificação).
            3. Reforçar DUA (Desenho Universal para Aprendizagem).
            
            DIRETRIZ DE GOVERNANÇA:
            - Se o usuário pedir algo fora do Ensino Fundamental 2 ou Médio, REPUDIE e explique o escopo.
            - Se o plano parecer "pobre", critique construtivamente.
            
            PERFIL: Você fala como um Coordenador Pedagógico experiente conversando com um Professor.`
        });

        const chat = model.startChat({
            history: context?.history || []
        });

        const result = await chat.sendMessage(message);
        return result.response.text();
    },

    /**
     * 5. MANIFEST QUERY
     * Busca os arquivos que o sistema "conhece" para mostrar na UI.
     */
    getKnowledgeManifest: async () => {
        // Alternativa Client-Side ao RPC que falhou
        // Trazendo tudo e agrupando no cliente (pode ser pesado se tiver milhares de chunks, 
        // mas curriculos costumam ter metadados repetidos, então 'distinct' seria ideal.
        // O Supabase JS select distinct é chato. Vamos tentar RPC de novo SE possível, mas senão:

        // Vamos tentar pegar apenas colunas de metadados e manipular.
        try {
            const { data, error } = await supabase
                .from('curriculos_mg')
                .select('metadata');

            if (error) throw error;

            // Client-side aggregation
            const map = new Map<string, any>();

            data?.forEach((row: any) => {
                const m = row.metadata;
                const key = `${m.ano_escolar}-${m.disciplina}`;
                if (!map.has(key)) {
                    map.set(key, {
                        source: m.source,
                        disciplina: m.disciplina,
                        ano: m.ano_escolar,
                        chunks: 0
                    });
                }
                map.get(key).chunks++;
            });

            return Array.from(map.values()).sort((a, b) => a.ano.localeCompare(b.ano));
        } catch (e) {
            console.error("Erro ao gerar manifesto:", e);
            return [];
        }
    }
};
