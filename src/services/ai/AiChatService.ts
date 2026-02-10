import { SYSTEM_PROMPT, SYSTEM_PROMPT_CHAT } from "../../constants";
import { AccessLevel } from "../../types";
import { fetchEnemQuestions } from "../databaseService";
import { getTeacherContext } from "../supabaseService";
import { checkUsageQuota, incrementUserUsage } from "../userService";
import { hybridSearchProfeplan } from "../searchService";
import { getGenAIClient, safetySettings } from "./AiCore";
import { extractHighSchoolContext } from "./AiUtilityService";

type LessonContext = {
    topic?: string;
    content?: string;
};

type ChatPart =
    | { text: string }
    | { inlineData: { data: string; mimeType: string } };

const getErrorMessage = (error: unknown): string =>
    error instanceof Error ? error.message : 'Unknown error';

export const generateProfePlanStream = async (
    message: string,
    history: { role: string; parts: { text: string }[] }[],
    mode: string,
    imagePart?: { inlineData: { data: string; mimeType: string } },
    audioPart?: { inlineData: { data: string; mimeType: string } }, // Mantido interface, mas pode não ser usado
    userAccessLevel?: AccessLevel,
    userId?: string
) => {
    const genAI = getGenAIClient();

    // Configuração da instrução do sistema base
    // [MODIFICAÇÃO V3.2]: O Chat Geral usa SYSTEM_PROMPT_CHAT (com fallback).
    // Agentes especializados (Quarterly, Planning) mantêm SYSTEM_PROMPT (estrito/RAG only).
    const basePrompt = (mode === 'quarterly' || mode === 'planning') ? SYSTEM_PROMPT : SYSTEM_PROMPT_CHAT;
    let specificInstruction = `${basePrompt}\n\n[MODO ATIVO]: ${mode.toUpperCase()}`;



    // Injeção de Memória (Teacher Context)
    if (userId) {
        try {
            const { recentLessons, preferences } = await getTeacherContext(userId);

            if (preferences || (recentLessons && recentLessons.length > 0)) {
                const preferred_tone = preferences?.preferred_tone || 'não definido';
                const recentLessons_list = recentLessons && recentLessons.length > 0
                    ? (recentLessons as LessonContext[]).map((l, i: number) => `Aula ${i + 1}: ${l.topic}\nConteúdo: ${(l.content || '').substring(0, 500)}...`).join('\n\n')
                    : 'Nenhuma aula anterior disponível.';

                specificInstruction += `\n\nVocê deve seguir o estilo das aulas anteriores do professor (se houver) e respeitar o tom preferido: ${preferred_tone}. Aqui estão exemplos de aulas passadas para referência: ${recentLessons_list}`;
            }
        } catch (e) {
            console.warn("Falha ao recuperar Memória do Professor:", e);
        }
    }

    // [REGRA DE OURO] Busca Automática de Questões para Ensino Médio
    const context = extractHighSchoolContext(message);

    if (context) {
        console.log(`🔍 Detectado contexto de Ensino Médio: ${context.grade} - ${context.subject}`);
        try {
            // Usa a mensagem do usuário + contexto extraído
            const searchResults = await hybridSearchProfeplan({
                textoBusca: message,
                limit: 3,
                matchThreshold: 0.5,
                // Passa os filtros para o Supabase (que deve suportar ou ignorar se null)
                // O formato '1ANO' é passado como 'nivel' se a RPC suportar, ou concatenado na busca
                nivel: context.grade,     // Ex: "1ANO"
                disciplina: context.subject // Ex: "BIOLOGIA"
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
            const lastUserMessage = history.find(m => m.role === 'user')?.parts[0].text || message;
            const area = lastUserMessage.toLowerCase().includes('matemática') ? 'Matemática' :
                lastUserMessage.toLowerCase().includes('humana') ? 'Ciências Humanas' :
                    lastUserMessage.toLowerCase().includes('linguagen') ? 'Linguagens' :
                        lastUserMessage.toLowerCase().includes('natureza') ? 'Ciências da Natureza' : null;

            if (area) {
                // Nota: fetchEnemQuestions deve retornar array de objetos com question_text
                const examples = await fetchEnemQuestions(area, undefined, 2);
                if (examples && examples.length > 0) {
                    specificInstruction += `\n\n[EXEMPLOS DE QUESTÕES DO BANCO]:\n${JSON.stringify(examples.map(q => q.question_text))}`;
                }
            }
        } catch (e) {
            console.warn("Falha ao buscar questões ENEM:", e);
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
    // A chave nova suporta modelos 2.0+. Configurando para o 2.0 Flash estável.
    const model = genAI.getGenerativeModel({
        model: "gemini-2.0-flash",
        systemInstruction: specificInstruction,
        safetySettings
    });

    // Convertendo histórico para o formato do SDK generative-ai
    // O SDK novo usa { role: 'user' | 'model', parts: [{ text: '...' }] }
    // Verificando compatibilidade: history já está nesse formato

    const chat = model.startChat({
        history: history.map(h => ({
            role: h.role,
            parts: h.parts
        })),
        generationConfig: {
            temperature: 0.8,
        }
    });

    // Montando a mensagem atual
    const currentParts: ChatPart[] = [];
    if (message) currentParts.push({ text: message });
    if (imagePart) currentParts.push(imagePart);
    // audioPart ignorado nesta versão simples para garantir estabilidade, ou adaptar se suportado

    // Check Quota
    if (userId) {
        const quotaStatus = await checkUsageQuota(userId);
        if (!quotaStatus.allowed) {
            throw new Error(quotaStatus.message);
        }
    }

    try {
        const result = await chat.sendMessageStream(currentParts);

        // Increment Usage only after stream starts successfully
        if (userId) {
            await incrementUserUsage(userId, 'chat');
        }

        // Adaptador para garantir compatibilidade com o App.tsx que espera chunk.text
        async function* streamAdapter() {
            for await (const chunk of result.stream) {
                const chunkText = chunk.text();
                yield { text: chunkText };
            }
        }

        return streamAdapter();
    } catch (error: unknown) {
        console.error("Erro na Chamada do Gemini API:", error);
        throw new Error(getErrorMessage(error));
    }
};
