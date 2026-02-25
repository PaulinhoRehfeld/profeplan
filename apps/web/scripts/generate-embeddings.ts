/**
 * GENERATE EMBEDDINGS SCRIPT
 * ===========================
 * 
 * Script para gerar embeddings para todas as questões ENEM/SAEB
 * Rodar em background (overnight): ~6 horas para 17k questões
 * 
 * USO:
 * npm run generate-embeddings
 */

import { createClient } from '@supabase/supabase-js';
import { GoogleGenerativeAI } from '@google/generative-ai';

// Configuração
const SUPABASE_URL = process.env.VITE_SUPABASE_URL || '';
const SUPABASE_ANON_KEY = process.env.VITE_SUPABASE_ANON_KEY || '';
const GEMINI_API_KEY = process.env.VITE_GEMINI_API_KEY || '';

const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);

const BATCH_SIZE = 50; // Processar 50 por vez
const RATE_LIMIT_MS = 1200; // 50/min = 1 a cada 1.2s

interface Stats {
    total: number;
    processed: number;
    success: number;
    failed: number;
    startTime: Date;
}

const stats: Stats = {
    total: 0,
    processed: 0,
    success: 0,
    failed: 0,
    startTime: new Date()
};

async function sleep(ms: number) {
    return new Promise(resolve => setTimeout(resolve, ms));
}

async function generateEmbedding(content: string): Promise<number[] | null> {
    try {
        const model = genAI.getGenerativeModel({ model: 'text-embedding-004' });
        const result = await model.embedContent(content);

        if (result.embedding && result.embedding.values) {
            return result.embedding.values;
        }

        return null;
    } catch (error) {
        console.error('❌ Embedding generation error:', error);
        return null;
    }
}

async function processQuestion(id: number, content: string): Promise<boolean> {
    try {
        // 1. Gerar embedding
        const embedding = await generateEmbedding(content);

        if (!embedding) {
            console.log(`⚠️  Question ${id}: Failed to generate embedding`);
            stats.failed++;
            return false;
        }

        // 2. Salvar no banco
        const { error } = await supabase
            .from('enem_questions')
            .update({ embedding })
            .eq('id', id);

        if (error) {
            console.error(`❌ Question ${id}: Database error:`, error); stats.failed++;
            return false;
        }

        stats.success++;
        console.log(`✅ Question ${id}: Embedded (${stats.processed}/${stats.total})`);
        return true;

    } catch (error) {
        console.error(`❌ Question ${id}: Exception:`, error);
        stats.failed++;
        return false;
    }
}

async function processBatch() {
    // 1. Buscar questões sem embedding
    const { data: questions, error } = await supabase
        .from('enem_questions')
        .select('id, content')
        .is('embedding', null)
        .limit(BATCH_SIZE);

    if (error) {
        console.error('❌ Failed to fetch questions:', error);
        return false;
    }

    if (!questions || questions.length === 0) {
        console.log('✅ No more questions to process!');
        return false;
    }

    console.log(`\n📦 Processing batch: ${questions.length} questions`);

    // 2. Processar cada questão
    for (const q of questions) {
        await processQuestion(q.id, q.content);
        stats.processed++;

        // Rate limiting
        await sleep(RATE_LIMIT_MS);

        // Progress update a cada 10
        if (stats.processed % 10 === 0) {
            printProgress();
        }
    }

    return true; // Continuar
}

function printProgress() {
    const elapsed = (new Date().getTime() - stats.startTime.getTime()) / 1000 / 60; // minutos
    const rate = stats.processed / elapsed;
    const remaining = stats.total - stats.processed;
    const eta = remaining / rate;

    console.log('\n' + '='.repeat(50));
    console.log(`📊 PROGRESSO:`);
    console.log(`   Processadas: ${stats.processed}/${stats.total} (${((stats.processed / stats.total) * 100).toFixed(1)}%)`);
    console.log(`   Sucesso: ${stats.success} | Falhas: ${stats.failed}`);
    console.log(`   Taxa: ${rate.toFixed(1)} questões/min`);
    console.log(`   ETA: ${eta.toFixed(0)} minutos (~${(eta / 60).toFixed(1)} horas)`);
    console.log('='.repeat(50) + '\n');
}

async function main() {
    console.log('🚀 GERADOR DE EMBEDDINGS - INICIANDO\n');

    // 1. Contar total
    const { count } = await supabase
        .from('enem_questions')
        .select('*', { count: 'exact', head: true })
        .is('embedding', null);

    stats.total = count || 0;

    console.log(`📊 Total de questões sem embedding: ${stats.total}`);
    console.log(`⏱️  Tempo estimado: ~${(stats.total / 50).toFixed(0)} minutos\n`);

    if (stats.total === 0) {
        console.log('✅ Todas as questões já têm embeddings!');
        return;
    }

    // 2. Confirmar
    console.log('⚠️  Este processo irá rodar por várias horas.');
    console.log('   Recomendado rodar overnight ou em background.\n');

    // 3. Processar em batches
    let hasMore = true;
    while (hasMore) {
        hasMore = await processBatch();
    }

    // 4. Resumo final
    console.log('\n' + '='.repeat(50));
    console.log('🎉 GERAÇÃO COMPLETA!');
    console.log('='.repeat(50));
    printProgress();
}

// Executar
main().catch(error => {
    console.error('❌ Fatal error:', error);
    process.exit(1);
});
