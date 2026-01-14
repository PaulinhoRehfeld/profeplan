import { GoogleGenerativeAI } from "@google/generative-ai";
import { createClient } from '@supabase/supabase-js';
import * as fs from 'fs';
import * as dotenv from 'dotenv';
import * as path from 'path';

// --- CONFIGURATION ---
dotenv.config();

const SUPABASE_URL = process.env.VITE_SUPABASE_URL;
const SUPABASE_KEY = process.env.VITE_SUPABASE_ANON_KEY; // Using Anon Key for client-side like usage, or Service Role for admin bypass
const GEMINI_KEY = process.env.VITE_GEMINI_API_KEY;

if (!SUPABASE_URL || !SUPABASE_KEY || !GEMINI_KEY) {
    console.error("❌ ERRO: Credenciais ausentes no .env");
    console.error("Necessário: VITE_SUPABASE_URL, VITE_SUPABASE_ANON_KEY, VITE_GEMINI_API_KEY");
    process.exit(1);
}

const INPUT_FILE = './ingested_questions.json';

// --- CLIENTS ---
const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);
const genAI = new GoogleGenerativeAI(GEMINI_KEY);
const model = genAI.getGenerativeModel({ model: "text-embedding-004" });

// --- MAIN ---
async function main() {
    if (!fs.existsSync(INPUT_FILE)) {
        console.error(`❌ Arquivo '${INPUT_FILE}' não encontrado. Execute 'node scripts/ingest_enem.js' primeiro.`);
        return;
    }

    const rawData = fs.readFileSync(INPUT_FILE, 'utf-8');
    const questions = JSON.parse(rawData);

    console.log(`🚀 Iniciando upload de ${questions.length} questões com embeddings...`);

    let successCount = 0;
    let failCount = 0;

    for (let i = 0; i < questions.length; i++) {
        const q = questions[i];
        console.log(`[${i + 1}/${questions.length}] Processando Questão ${q.question_number || 'Sem N.'}...`);

        try {
            // 1. Generate Text for Embedding
            // We combine context + question + taxonomy to make a rich semantic vector
            const textToEmbed = `
            Área: ${q.taxonomy?.area || ''} Tópico: ${q.taxonomy?.topic || ''}
            Texto de Apoio: ${q.intro_text || ''}
            Enunciado: ${q.question_text}
            `.trim();

            // 2. Get Embedding
            const result = await model.embedContent(textToEmbed);
            const embedding = result.embedding;

            // 3. Prepare DB Object
            const dbPayload = {
                question_number: q.question_number,
                intro_text: q.intro_text,
                question_text: q.question_text,
                alternatives: q.alternatives,   // JSONB
                area: q.taxonomy?.area,
                component: q.taxonomy?.topic,   // Mapping generic 'topic' to 'component' or 'specific_topic'
                specific_topic: q.taxonomy?.topic,
                embedding: embedding.values
            };

            // 4. Insert into Supabase
            const { error } = await supabase
                .from('enem_questions')
                .insert([dbPayload]);

            if (error) {
                console.error(`   ❌ Erro Supabase: ${error.message}`);
                failCount++;
            } else {
                console.log(`   ✅ Salvo!`);
                successCount++;
            }

            // Rate Limiting Safety (optional, mostly for free tier)
            await new Promise(r => setTimeout(r, 500));

        } catch (err) {
            console.error(`   ❌ Erro Geral: ${err.message}`);
            failCount++;
        }
    }

    console.log(`\n🎉 Finalizado!`);
    console.log(`Sucessos: ${successCount}`);
    console.log(`Falhas: ${failCount}`);
}

main();
