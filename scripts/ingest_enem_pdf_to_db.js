
import { GoogleGenerativeAI } from "@google/generative-ai";
import { createClient } from "@supabase/supabase-js";
import * as fs from 'fs';
import * as path from 'path';
import * as dotenv from 'dotenv';
import { fileURLToPath } from 'url';

dotenv.config();

// --- CONFIGURATION ---
const GEMINI_API_KEY = process.env.VITE_GEMINI_API_KEY;
const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
const SUPABASE_KEY = process.env.VITE_SUPABASE_ANON_KEY;

if (!GEMINI_API_KEY || !SUPABASE_URL || !SUPABASE_KEY) {
    console.error("❌ Erro: Credenciais (VITE_GEMINI_API_KEY, VITE_SUPABASE_URL, VITE_SUPABASE_ANON_KEY) faltando no .env");
    process.exit(1);
}

const INGEST_DIR = './ingest_data';
const MAX_RETRIES = 3;

// --- CLIENTS ---
const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);
// Use gemini-2.0-flash for OCR as requested/used previously
const modelOCR = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });
const modelEmbedding = genAI.getGenerativeModel({ model: "embedding-001" });
const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

// --- HELPER FUNCTIONS ---

function fileToGenerativePart(path, mimeType) {
    return {
        inlineData: {
            data: Buffer.from(fs.readFileSync(path)).toString("base64"),
            mimeType
        },
    };
}

async function generateEmbedding(text) {
    try {
        const result = await modelEmbedding.embedContent(text);
        return result.embedding.values;
    } catch (e) {
        console.error("❌ Erro gerando embedding:", e.message);
        return null;
    }
}

async function extractQuestionsFromPDF(filePath) {
    console.log(`🔍 Extraindo questões de: ${path.basename(filePath)}...`);

    // Simplification: treating all as PDF or Image based on extension
    const mimeType = filePath.endsWith('.pdf') ? 'application/pdf' : 'image/jpeg';
    const filePart = fileToGenerativePart(filePath, mimeType);

    const prompt = `
  ATUE COMO UM ESPECIALISTA EM ENGENHARIA DE PROMPTS E OCR.
  
  TAREFA:
  Analise este documento (prova do ENEM) e extraia TODAS as questões.
  
  PARA CADA QUESTÃO, RETORNE UM OBJETO JSON COM:
  - "question_number": Número da questão.
  - "year": Ano da prova (tente identificar no cabeçalho ou texto, senão use null).
  - "discipline": Disciplina provável (Matemática, Linguagens, Humanas, Natureza).
  - "context": Texto de apoio completo, poemas, tirinhas, etc.
  - "alternativesIntroduction": O enunciado/comando da questão.
  - "alternatives": Array de objetos { "letter": "A", "text": "...", "isCorrect": false }. (Marque isCorrect se houver gabarito visível, senão false).
  - "tags": Array de strings com tópicos (ex: "Geometria", "Semântica").
  - "bncc": Array de códigos BNCC se possível identificar.

  SAÍDA:
  Retorne APENAS um JSON válido contendo um array de questões.
  `;

    let attempts = 0;
    while (attempts < MAX_RETRIES) {
        try {
            const result = await modelOCR.generateContent([prompt, filePart]);
            const response = await result.response;
            const text = response.text();

            // Clean markdown
            const jsonStr = text.replace(/```json/g, '').replace(/```/g, '').trim();
            return JSON.parse(jsonStr);
        } catch (err) {
            console.warn(`⚠️ Tentativa ${attempts + 1} falhou: ${err.message}. Tentando novamente...`);
            attempts++;
            await new Promise(r => setTimeout(r, 2000));
        }
    }
    console.error(`❌ Falha ao processar ${path.basename(filePath)} após ${MAX_RETRIES} tentativas.`);
    return [];
}

async function ingestQuestions() {
    if (!fs.existsSync(INGEST_DIR)) {
        fs.mkdirSync(INGEST_DIR);
        console.log(`📁 Pasta '${INGEST_DIR}' criada. Coloque PDFs lá.`);
        return;
    }

    const files = fs.readdirSync(INGEST_DIR).filter(f => f.toLowerCase().endsWith('.pdf') || f.toLowerCase().endsWith('.jpg') || f.toLowerCase().endsWith('.png'));

    if (files.length === 0) {
        console.log(`⚠️ Nenhum arquivo encontrado em '${INGEST_DIR}'.`);
        return;
    }

    for (const file of files) {
        const filePath = path.join(INGEST_DIR, file);
        const questions = await extractQuestionsFromPDF(filePath);

        if (!questions || questions.length === 0) {
            console.log(`⚠️ Nenhuma questão extraída de ${file}.`);
            continue;
        }

        console.log(`🚀 Processando ${questions.length} questões de ${file}...`);

        for (const q of questions) {
            // Prepare content for embedding (Rich semantic representation)
            const embeddingText = `
            Disciplina: ${q.discipline || ''}
            Contexto: ${q.context || ''}
            Enunciado: ${q.alternativesIntroduction || ''}
            Alternativas: ${q.alternatives?.map(a => a.text).join(' ') || ''}
            Tags: ${q.tags?.join(', ') || ''}
            `.trim();

            const embedding = await generateEmbedding(embeddingText);

            if (!embedding) {
                console.error(`❌ Pular questão ${q.question_number} (falha no embedding).`);
                continue;
            }

            // Construct Metadata Object adhering to the schema seen in convert_enem_to_md.js
            const metadata = {
                id_original: q.question_number, // Mapping question number to id_original
                year: q.year || new Date().getFullYear(), // Default to current year if not found
                discipline: q.discipline,
                context: q.context,
                alternativesIntroduction: q.alternativesIntroduction,
                alternatives: q.alternatives,
                tags: q.tags,
                bncc: q.bncc
            };

            // Insert into Supabase
            // Note: We insert into 'enem_questions'. Assuming schema matches.
            // Using 'metadata' column for JSON and 'embedding' for vector.
            // We might also put a text representation in 'content' if the column exists and is used for FTS.

            const { error } = await supabase
                .from('enem_questions')
                .insert({
                    metadata: metadata,
                    embedding: embedding,
                    content: embeddingText // Storing text representation for potential backup/search
                });

            if (error) {
                console.error(`❌ Erro inserindo questão ${q.question_number}:`, error.message);
            } else {
                console.log(`✅ Questão ${q.question_number} inserida com sucesso!`);
            }
        }

        // Optional: Move processed file to a 'processed' folder?
        // For now, just logging.
        console.log(`🏁 Arquivo ${file} finalizado.`);
    }
}

ingestQuestions();
