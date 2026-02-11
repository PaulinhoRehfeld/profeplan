import { GoogleGenerativeAI } from "@google/generative-ai";
import * as fs from 'fs';
import * as path from 'path';
import * as dotenv from 'dotenv';
import { fileURLToPath } from 'url';

// --- CONFIGURATION ---
dotenv.config(); // Carrega .env da raiz se rodar da raiz

const API_KEY = process.env.VITE_GEMINI_API_KEY;
if (!API_KEY) {
    console.error("❌ ERRO: VITE_GEMINI_API_KEY não encontrada no .env");
    process.exit(1);
}

const INGEST_DIR = './ingest_data'; // Pasta onde colocaremos os PDFs/Imagens
const OUTPUT_FILE = './ingested_questions.json';

// --- GEMINI SETUP ---
const genAI = new GoogleGenerativeAI(API_KEY);
const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });

// --- HELPER FUNCTIONS ---

function fileToGenerativePart(path, mimeType) {
    return {
        inlineData: {
            data: Buffer.from(fs.readFileSync(path)).toString("base64"),
            mimeType
        },
    };
}

async function processFile(filePath) {
    console.log(`🔍 Processando: ${path.basename(filePath)}...`);

    const mimeType = filePath.endsWith('.pdf') ? 'application/pdf' : 'image/jpeg'; // Simplificação
    const imagePart = fileToGenerativePart(filePath, mimeType);

    const prompt = `
  ATUE COMO UM ESPECIALISTA EM INGESTÃO DE DADOS EDUCACIONAIS (OCR INTELIGENTE).

  TAREFA:
  Analise este documento (prova do ENEM ou Simulado) e extraia TODAS as questões encontradas.

  PARA CADA QUESTÃO, RETORNE UM OBJETO JSON COM:
  - "question_number": O número da questão na prova.
  - "intro_text": O texto de apoio, poemas, tirinhas (descrição) ou contexto ANTES do enunciado.
  - "question_text": O enunciado principal da questão (o comando).
  - "alternatives": Um objeto com as chaves A, B, C, D, E e seus textos.
  - "taxonomy": Tente inferir a Área (Linguagens, Humanas, Natureza, Matemática) e o Tópico (ex: "Gramática", "Geopolítica").

  SAÍDA ESPERADA:
  Retorne APENAS um JSON válido contendo um array de questões.
  Exemplo:
  [
    {
      "question_number": 1,
      "intro_text": "...",
      "question_text": "...",
      "alternatives": { "A": "...", "B": "..." },
      "taxonomy": { "area": "...", "topic": "..." }
    }
  ]
  `;

    try {
        const result = await model.generateContent([prompt, imagePart]);
        const response = await result.response;
        const text = response.text();

        // Limpeza básica de Markdown ```json ... ```
        const jsonStr = text.replace(/```json/g, '').replace(/```/g, '').trim();
        return JSON.parse(jsonStr);
    } catch (err) {
        console.error(`❌ Erro ao processar ${path.basename(filePath)}:`, err.message);
        return [];
    }
}

// --- MAIN EXECUTION ---

async function main() {
    if (!fs.existsSync(INGEST_DIR)) {
        fs.mkdirSync(INGEST_DIR);
        console.log(`📁 Pasta '${INGEST_DIR}' criada. Coloque seus PDFs/Imagens lá e rode novamente.`);
        return;
    }

    const files = fs.readdirSync(INGEST_DIR).filter(f => f.endsWith('.pdf') || f.endsWith('.jpg') || f.endsWith('.png'));

    if (files.length === 0) {
        console.log(`⚠️ Nenhum arquivo encontrado em '${INGEST_DIR}'. Adicione arquivos para processar.`);
        return;
    }

    let allQuestions = [];

    for (const file of files) {
        const questions = await processFile(path.join(INGEST_DIR, file));
        if (questions && questions.length > 0) {
            allQuestions = allQuestions.concat(questions);
        }
    }

    fs.writeFileSync(OUTPUT_FILE, JSON.stringify(allQuestions, null, 2));
    console.log(`✅ Sucesso! ${allQuestions.length} questões extraídas e salvas em '${OUTPUT_FILE}'.`);
}

main();
