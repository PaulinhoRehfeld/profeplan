
import { GoogleGenerativeAI } from '@google/generative-ai';
import dotenv from 'dotenv';
import path from 'path';

// Manual prompt mock
const SYSTEM_PROMPT = `# SYSTEM INSTRUCTION: PROFEPLAN ASSISTENTE PEDAGÓGICO ESTRITO (RAG-DRIVEN)
ESTRUTURA DE RESPOSTA PADRÃO:
Detalhando Aula: [TEMA]
Base Curricular: ...
...`;

dotenv.config({ path: path.resolve(__dirname, '../.env') });
const apiKey = process.env.VITE_GEMINI_API_KEY || '';

async function testPrompt() {
    const genAI = new GoogleGenerativeAI(apiKey);
    const model = genAI.getGenerativeModel({ model: "gemini-2.0-flash" });

    const prompt = "Gere um plano de aula detalhado sobre Revolução Francesa para o 8º ano.";
    console.log(`Testing prompt with gemini-2.0-flash...`);

    const result = await model.generateContent(`${SYSTEM_PROMPT}\n\nUser: ${prompt}`);
    const response = await result.response;
    const text = response.text();

    console.log("--- AI RESPONSE START ---");
    console.log(text.substring(0, 500));
    console.log("--- AI RESPONSE END ---");

    const saveTriggers = [
        '[AÇÃO: PLANO DE AULA DETALHADO]',
        'PLANO DE AULA',
        '[AÇÃO: MATERIAL DIDÁTICO]',
        'ROTEIRO DE ESTUDO',
        '[AÇÃO: LISTA DE EXERCÍCIOS]',
        'QUESTÕES',
        'EXERCÍCIOS'
    ];

    const found = saveTriggers.filter(t => text.includes(t));
    console.log("\nDetected Save Triggers:", found);

    if (found.length === 0) {
        console.warn("⚠️ NO SAVE TRIGGERS FOUND! PlanningManager will NOT save this content.");
    } else {
        console.log("✅ Save trigger found. Logic should work if RLS is fine.");
    }
}

testPrompt();
