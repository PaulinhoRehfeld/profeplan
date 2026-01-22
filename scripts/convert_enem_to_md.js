
import { createClient } from '@supabase/supabase-js';
import * as fs from 'fs';
import * as dotenv from 'dotenv';
import * as path from 'path';

dotenv.config();

const supabaseUrl = process.env.VITE_SUPABASE_URL;
const supabaseKey = process.env.VITE_SUPABASE_ANON_KEY;

if (!supabaseUrl || !supabaseKey) {
    console.error('Missing Supabase credentials');
    process.exit(1);
}

const supabase = createClient(supabaseUrl, supabaseKey);

const OUTPUT_FILE = './enem_questions_export.md';

async function convertEnemToMd() {
    console.log('Fetching questions from enem_questions...');

    let allData = [];
    const pageSize = 1000;
    let page = 0;
    let fetchMore = true;

    while (fetchMore) {
        const from = page * pageSize;
        const to = from + pageSize - 1;

        console.log(`Fetching records ${from} to ${to}...`);

        const { data, error } = await supabase
            .from('enem_questions')
            .select('*')
            .order('id', { ascending: true })
            .range(from, to);

        if (error) {
            console.error('Error fetching questions:', error);
            break;
        }

        if (data && data.length > 0) {
            allData = allData.concat(data);
            console.log(`Fetched ${data.length} records.`);
            if (data.length < pageSize) {
                fetchMore = false;
            } else {
                page++;
            }
        } else {
            fetchMore = false;
        }
    }

    if (allData.length === 0) {
        console.log('No questions found.');
        return;
    }

    console.log(`Found total ${allData.length} questions. Converting...`);

    let mdContent = '';

    for (const record of allData) {
        const meta = record.metadata;

        // Safety check for metadata structure
        if (!meta) {
            // Warning log lowered to debug or just count them if too many
            // console.warn(`Warning: Record ID ${record.id} has no metadata. Skipping.`);
            continue;
        }

        // Construct Markdown for this question
        mdContent += `# Synced Question ${record.id}\n`;
        if (meta.id_original) mdContent += `**ID Original:** ${meta.id_original}\n`;
        if (meta.year) mdContent += `**Ano:** ${meta.year}\n`;
        if (meta.discipline) mdContent += `**Disciplina:** ${meta.discipline}\n`;

        // Tags
        if (meta.tags && Array.isArray(meta.tags) && meta.tags.length > 0) {
            mdContent += `**Tags:** ${meta.tags.join(', ')}\n`;
        }
        if (meta.bncc && Array.isArray(meta.bncc) && meta.bncc.length > 0) {
            mdContent += `**BNCC:** ${meta.bncc.join(', ')}\n`;
        }

        mdContent += '\n---\n\n';

        // Context (Text base)
        if (meta.context) {
            mdContent += `${meta.context}\n\n`;
        }

        // Command (Enunciado)
        if (meta.alternativesIntroduction) {
            mdContent += `**${meta.alternativesIntroduction}**\n\n`;
        }

        // Alternatives
        if (meta.alternatives && Array.isArray(meta.alternatives)) {
            meta.alternatives.forEach((alt) => {
                const isCorrect = alt.isCorrect ? ' (Correta)' : '';
                if (typeof alt === 'object' && alt.letter && alt.text) {
                    mdContent += `${alt.letter}) ${alt.text}${isCorrect ? ' ✅' : ''}\n`;
                } else {
                    mdContent += `- ${JSON.stringify(alt)}\n`;
                }
            });
        }

        mdContent += '\n\n================================================================================\n\n';
    }

    fs.writeFileSync(OUTPUT_FILE, mdContent);
    console.log(`✅ Conversion complete! Saved to ${OUTPUT_FILE}`);
}

convertEnemToMd();
