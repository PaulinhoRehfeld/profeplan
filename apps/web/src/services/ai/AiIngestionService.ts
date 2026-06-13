import { createSimpleCompletion } from './AiCore';
import { GoogleGenerativeAI } from "@google/generative-ai";
import { supabase } from '../supabaseClient';

export interface DocumentMetadata {
    subject: string;
    year: string;
    workload: number | null;
    skills: string[];
    objects_of_knowledge: string[];
}

export interface IngestionResult {
    content_md: string;
    metadata: DocumentMetadata;
    extraction_score: number;
    curation_report: string;
}

/**
 * Obtém a chave de API do Gemini para vetorização
 */
export const getGeminiApiKey = (): string | undefined => {
    return (import.meta.env && import.meta.env.VITE_GEMINI_API_KEY?.trim()) || process.env.VITE_GEMINI_API_KEY?.trim();
};

/**
 * Gera o vetor (embedding) de 768 dimensões usando o modelo do Gemini
 */
export const generateChunkEmbedding = async (text: string): Promise<number[] | null> => {
    const apiKey = getGeminiApiKey();
    if (!apiKey) {
        console.warn("[AiIngestionService] API Key de Gemini ausente. Embedding não gerado.");
        return null;
    }
    try {
        const genAI = new GoogleGenerativeAI(apiKey);
        const model = genAI.getGenerativeModel({ model: "models/gemini-embedding-001" });
        const result = await model.embedContent(text);
        return result.embedding.values.slice(0, 768);
    } catch (error) {
        console.error("[AiIngestionService] Erro ao gerar embedding no Gemini:", error);
        return null;
    }
};

/**
 * Envia o texto extraído para a IA processar em Markdown estruturado, metadados e relatório de curadoria.
 */
export const parseAndAuditPdfText = async (rawText: string, category: string): Promise<IngestionResult> => {
    const prompt = `
Você é um parser e auditor pedagógico especializado em processamento de documentos educacionais (Planos de Curso, Livros, Materiais Didáticos).
Você receberá o texto bruto extraído de um arquivo PDF. Sua tarefa é processar e estruturar esse conteúdo em Markdown e extrair metadados e um relatório de curadoria.

A categoria do documento é: ${category === 'course_plan' ? 'Plano de Curso' : category === 'book' ? 'Livro' : 'Material Didático'}.

Texto bruto para processamento:
---
${rawText.substring(0, 80000)}  -- Limite seguro de caracteres
---

Sua resposta DEVE ser um objeto JSON válido (e APENAS o JSON, sem blocos de código markdown como \`\`\`json ou textos explicativos adicionais) com a seguinte estrutura:
{
  "content_md": "conteúdo completo formatado em markdown com cabeçalhos organizados, limpando problemas de OCR, tabelas corrompidas e caracteres inválidos",
  "metadata": {
    "subject": "Nome da disciplina (ex: História, Geografia)",
    "year": "Ano escolar associado (ex: 6º Ano, 1º Ano EM)",
    "workload": 80, // Carga horária total se disponível, senão null
    "skills": ["EF06HI01", "EF06HI02"], // Habilidades ou códigos curriculares
    "objects_of_knowledge": ["Tema 1", "Tema 2"] // Objetos de conhecimento
  },
  "extraction_score": 90, // Estimativa de 0 a 100 da fidelidade e integridade da extração
  "curation_report": "Relatório detalhado em Markdown apontando possíveis capítulos ausentes, erros de OCR ou de formatação."
}
`;

    try {
        const responseText = await createSimpleCompletion(prompt, "Você é uma API que responde estritamente em JSON válido.", 0.2);
        
        // Remove eventuais tags de markdown que o LLM possa incluir
        const cleanJsonText = responseText.replace(/```json/i, '').replace(/```/g, '').trim();
        const parsed: IngestionResult = JSON.parse(cleanJsonText);
        return parsed;
    } catch (error) {
        console.error("[AiIngestionService] Erro no parsing de texto com a IA:", error);
        // Fallback básico para não quebrar o fluxo
        return {
            content_md: `# Ingestão Automática\n\n${rawText.substring(0, 5000)}`,
            metadata: {
                subject: "Geral",
                year: "Geral",
                workload: null,
                skills: [],
                objects_of_knowledge: []
            },
            extraction_score: 50,
            curation_report: "Erro durante o processamento de curadoria por IA. Verifique o documento manualmente."
        };
    }
};

/**
 * Divide o texto do Markdown de forma lógica para buscas no RAG, preservando contexto de cabeçalhos.
 */
export const chunkMarkdownContent = (markdown: string, maxCharacters: number = 800): string[] => {
    const lines = markdown.split('\n');
    const chunks: string[] = [];
    
    let activeH1 = '';
    let activeH2 = '';
    let activeH3 = '';
    let currentBuffer: string[] = [];
    let currentLength = 0;

    const flush = () => {
        if (currentBuffer.length > 0) {
            const contextHeader = [activeH1, activeH2, activeH3].filter(Boolean).join(' > ');
            const content = currentBuffer.join('\n').trim();
            if (content) {
                const chunkText = contextHeader ? `[Contexto: ${contextHeader}]\n${content}` : content;
                chunks.push(chunkText);
            }
            currentBuffer = [];
            currentLength = 0;
        }
    };

    for (const line of lines) {
        const trimmed = line.trim();
        
        // Detecta cabeçalhos e limpa o buffer antes de atualizar o cabeçalho ativo
        if (trimmed.startsWith('# ')) {
            flush();
            activeH1 = trimmed.replace('# ', '');
            activeH2 = '';
            activeH3 = '';
        } else if (trimmed.startsWith('## ')) {
            flush();
            activeH2 = trimmed.replace('## ', '');
            activeH3 = '';
        } else if (trimmed.startsWith('### ')) {
            flush();
            activeH3 = trimmed.replace('### ', '');
        }

        currentBuffer.push(line);
        currentLength += line.length + 1;

        if (currentLength >= maxCharacters) {
            flush();
        }
    }

    flush();
    return chunks;
};

/**
 * Cria uma nova versão ou o documento inicial no banco de dados.
 */
export const savePendingDocument = async (
    userId: string,
    title: string,
    filename: string,
    category: 'course_plan' | 'book' | 'didactic_material',
    parsedResult: IngestionResult
) => {
    try {
        // 1. Resolve a versão
        const { count, error: countError } = await supabase
            .from('teacher_documents')
            .select('*', { count: 'exact', head: true })
            .eq('user_id', userId)
            .eq('filename', filename);

        if (countError) throw countError;
        const nextVersion = (count || 0) + 1;

        // 2. Salva o registro em status 'pending'
        const { data, error } = await supabase
            .from('teacher_documents')
            .insert({
                user_id: userId,
                category,
                title: nextVersion > 1 ? `${title} (V${nextVersion})` : title,
                filename,
                version: nextVersion,
                content_md: parsedResult.content_md,
                metadata: parsedResult.metadata,
                extraction_score: parsedResult.extraction_score,
                curation_report: parsedResult.curation_report,
                status: 'pending'
            })
            .select()
            .single();

        if (error) throw error;
        return data;
    } catch (e) {
        console.error("[AiIngestionService] Erro ao salvar documento pendente:", e);
        throw e;
    }
};

/**
 * Homologa o documento, rodando o chunking e salvando os embeddings no banco
 */
export const approveDocumentAndIngest = async (
    documentId: string,
    userId: string,
    onProgress?: (msg: string) => void
) => {
    try {
        if (onProgress) onProgress("Recuperando documento...");
        
        // 1. Busca o documento
        const { data: doc, error: fetchError } = await supabase
            .from('teacher_documents')
            .select('*')
            .eq('id', documentId)
            .single();

        if (fetchError || !doc) throw fetchError || new Error("Documento não encontrado");

        if (onProgress) onProgress("Dividindo conteúdo em blocos...");
        const chunks = chunkMarkdownContent(doc.content_md || '');

        if (onProgress) onProgress(`Gerando embeddings para ${chunks.length} blocos...`);
        
        // 2. Cria cada chunk e salva
        for (let i = 0; i < chunks.length; i++) {
            const chunkText = chunks[i];
            const embedding = await generateChunkEmbedding(chunkText);

            if (onProgress) {
                onProgress(`Ingerindo bloco ${i + 1}/${chunks.length}...`);
            }

            const { error: insertChunkError } = await supabase
                .from('teacher_document_chunks')
                .insert({
                    document_id: documentId,
                    user_id: userId,
                    content: chunkText,
                    embedding: embedding
                });

            if (insertChunkError) throw insertChunkError;
        }

        // 3. Atualiza o status do documento para 'approved'
        if (onProgress) onProgress("Homologando documento...");
        const { error: updateError } = await supabase
            .from('teacher_documents')
            .update({ status: 'approved' })
            .eq('id', documentId);

        if (updateError) throw updateError;

        // 4. Criação automática de Agente customizado se for Plano de Curso
        if (doc.category === 'course_plan') {
            if (onProgress) onProgress("Configurando Agente de Disciplina...");
            const subject = doc.metadata?.subject || 'Geral';
            const year = doc.metadata?.year || 'Geral';
            const agentName = `Agente de ${subject} - ${year}`;
            
            const systemPrompt = `Você é o Agente Especializado em ${subject} para o ${year} do professor. Você DEVE seguir prioritariamente o Plano de Curso oficial homologado anexado a você. Se o professor fizer perguntas sobre temas fora do plano de curso oficial, use a regra de desvio pedagógico.`;

            // Verifica se já existe agente cadastrado para evitar duplicados
            const { data: existingAgent } = await supabase
                .from('teacher_agents')
                .select('id')
                .eq('user_id', userId)
                .eq('subject', subject)
                .eq('grade', year)
                .maybeSingle();

            if (existingAgent) {
                await supabase
                    .from('teacher_agents')
                    .update({
                        document_id: documentId,
                        system_prompt: systemPrompt
                    })
                    .eq('id', existingAgent.id);
            } else {
                await supabase
                    .from('teacher_agents')
                    .insert({
                        user_id: userId,
                        name: agentName,
                        subject,
                        grade: year,
                        document_id: documentId,
                        system_prompt: systemPrompt
                    });
            }
        }

        return true;
    } catch (e) {
        console.error("[AiIngestionService] Erro na homologação do documento:", e);
        throw e;
    }
};
