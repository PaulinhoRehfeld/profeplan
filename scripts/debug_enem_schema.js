const { createClient } = require('@supabase/supabase-js');
require('dotenv').config();

const supabase = createClient(
    process.env.VITE_SUPABASE_URL,
    process.env.VITE_SUPABASE_ANON_KEY
);

async function debugSchema() {
    console.log('🔍 Debugging enem_questions table schema and data...\n');

    // 1. Count total rows
    const { count, error: countErr } = await supabase
        .from('enem_questions')
        .select('*', { count: 'exact', head: true });

    if (countErr) {
        console.error('❌ Error counting rows:', countErr);
    } else {
        console.log(`📊 Total rows in enem_questions: ${count}\n`);
    }

    if (count === 0) {
        console.log('⚠️ Table is empty!');
        return;
    }

    // 2. Get first row to examine structure
    const { data: sample, error: sampleErr } = await supabase
        .from('enem_questions')
        .select('*')
        .limit(1);

    if (sampleErr) {
        console.error('❌ Error fetching sample:', sampleErr);
        return;
    }

    if (sample && sample.length > 0) {
        const row = sample[0];
        console.log('📋 Sample row structure:');
        console.log('Columns:', Object.keys(row));
        console.log('\n📄 Sample row data:');
        console.log(JSON.stringify(row, null, 2));

        // Check specific fields
        console.log('\n🔎 Field analysis:');
        console.log('- Has content field?', 'content' in row);
        console.log('- Has metadata field?', 'metadata' in row);
        console.log('- Has intro_text field?', 'intro_text' in row);
        console.log('- Has question_text field?', 'question_text' in row);

        if (row.metadata) {
            console.log('\n📦 Metadata structure:');
            console.log('Metadata keys:', Object.keys(row.metadata));
            console.log('Metadata sample:', JSON.stringify(row.metadata, null, 2).substring(0, 500));
        }

        if (row.content) {
            console.log('\n📝 Content field (first 200 chars):');
            console.log(row.content.substring(0, 200));
        }
    }

    // 3. Test text search
    console.log('\n\n🔍 Testing text search with "Brasil"...');
    
    const { data: searchResults, error: searchErr } = await supabase
        .from('enem_questions')
        .select('*')
        .or(`content.ilike.%Brasil%,metadata->>context.ilike.%Brasil%,metadata->>discipline.ilike.%Brasil%`)
        .limit(5);

    if (searchErr) {
        console.error('❌ Search error:', searchErr);
    } else {
        console.log(`✅ Found ${searchResults?.length || 0} results`);
        if (searchResults && searchResults.length > 0) {
            console.log('First result ID:', searchResults[0].id);
        }
    }
}

debugSchema().catch(console.error);
