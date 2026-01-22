
import { GoogleGenerativeAI } from '@google/generative-ai';
import { createClient } from '@supabase/supabase-js';
import * as dotenv from 'dotenv';
dotenv.config();

const googleAI = new GoogleGenerativeAI(process.env.VITE_GEMINI_API_KEY || '');
const supabase = createClient(process.env.VITE_SUPABASE_URL, process.env.VITE_SUPABASE_ANON_KEY);

const AREA_MAP = {
    'Humanas': ['História', 'Geografia', 'Filosofia', 'Sociologia', 'Ciências Humanas'],
    'Natureza': ['Física', 'Química', 'Biologia', 'Ciências da Natureza'],
    'Linguagens': ['Português', 'Literatura', 'Inglês', 'Espanhol', 'Artes', 'Educação Física', 'Linguagens'],
    'Matemática': ['Matemática']
};

async function testSearch() {
    const query = "SOCIEDADE LIQUIDA";
    const areas = ["Humanas"];

    console.log(`Testing search for "${query}" with areas: ${areas}`);

    // 1. Embedding
    const model = googleAI.getGenerativeModel({ model: "text-embedding-004" });
    const result = await model.embedContent(query);
    const embedding = result.embedding.values;

    // 2. Search
    const { data: vectorQuestions, error } = await supabase.rpc('match_questions', {
        query_embedding: embedding,
        match_threshold: 0.35,
        match_count: 5
    });

    if (error) {
        console.error("RPC Error:", error);
        return;
    }

    console.log(`RPC returned ${vectorQuestions.length} results.`);

    if (vectorQuestions.length > 0) {
        console.log("Sample metadata:", JSON.stringify(vectorQuestions[0].metadata, null, 2));
    }

    // 3. Filter Logic (UPDATED TO MATCH FIX)
    const targetDisciplines = areas.flatMap(area => AREA_MAP[area] || []);
    console.log("Target Disciplines:", targetDisciplines);

    const finalQuestions = vectorQuestions.filter(q => {
        // Check both possible keys
        const qDisc = q.metadata?.discipline || q.metadata?.disciplina || '';
        console.log(`Checking question disc: '${qDisc}'`);

        // Improved normalization
        const normalize = (s) => s.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "").replace(/[^a-z0-9]/g, "");

        const normalizedDisc = normalize(qDisc);

        const isMatch = targetDisciplines.some(td => {
            const normalizedTd = normalize(td);
            return normalizedDisc.includes(normalizedTd) || normalizedTd.includes(normalizedDisc);
        });

        console.log(`  Normalized disc: '${normalizedDisc}' vs Target '${normalize(targetDisciplines[0])}' -> Match: ${isMatch}`);
        return isMatch;
    });

    console.log(`Filtered results: ${finalQuestions.length}`);
}

testSearch();
