/**
 * DEBUG SCRIPT - Database Diagnostic
 * 
 * Execute no console do navegador para diagnosticar problemas de busca
 */

async function diagnosticDatabase() {
    console.log('🔍 DIAGNOSTIC - SimulationFactory Database');
    console.log('='.repeat(50));

    try {
        // 1. Importar serviços
        const { simulationDB, questionBank } = await import('./src/features/SimulationFactory');

        // 2. Health check
        console.log('\n1️⃣ HEALTH CHECK:');
        const health = await simulationDB.healthCheck();
        console.log('Status:', health);

        // 3. Contagem total
        console.log('\n2️⃣ TOTAL COUNT:');
        const total = await simulationDB.getTotalCount();
        console.log('Total de questões:', total);

        // 4. Teste de busca simples
        console.log('\n3️⃣ TEST SEARCH (texto direto):');
        console.log('Buscando: "Brasil"...');
        const searchResult = await simulationDB.searchByText('Brasil', 10);
        console.log('Resultados encontrados:', searchResult.length);
        if (searchResult.length > 0) {
            console.log('Exemplo:', {
                id: searchResult[0].id,
                hasContent: !!searchResult[0].content,
                hasMetadata: !!searchResult[0].metadata,
                discipline: searchResult[0].metadata?.discipline
            });
        }

        // 5. Teste via QuestionBank
        console.log('\n4️⃣ TEST via QuestionBankService:');
        console.log('Buscando: "Brasil"...');
        const qbResult = await questionBank.search({ query: 'Brasil', limit: 10 });
        console.log('Resultados encontrados:', qbResult.questions.length);
        console.log('Cache usado:', qbResult.fromCache);

        // 6. Teste direto Supabase
        console.log('\n5️⃣ TEST DIRETO Supabase:');
        const { supabase } = await import('./src/services/supabaseClient');
        const { data, error } = await supabase
            .from('enem_questions')
            .select('id, metadata')
            .limit(5);

        if (error) {
            console.error('❌ Erro Supabase:', error);
        } else {
            console.log('✅ Supabase OK. Primeiras 5 questões:', data?.map(q => ({
                id: q.id,
                discipline: q.metadata?.discipline
            })));
        }

        // 7. Resumo
        console.log('\n' + '='.repeat(50));
        console.log('RESUMO:');
        console.log('- Total questões:', total);
        console.log('- Busca direta funciona:', searchResult.length > 0 ? '✅' : '❌');
        console.log('- QuestionBank funciona:', qbResult.questions.length > 0 ? '✅' : '❌');
        console.log('- Supabase acessível:', !error ? '✅' : '❌');

        return {
            total,
            directSearch: searchResult.length,
            questionBankSearch: qbResult.questions.length,
            supabaseOk: !error
        };

    } catch (err) {
        console.error('❌ ERRO NO DIAGNÓSTICO:', err);
        throw err;
    }
}

// Executar automaticamente
diagnosticDatabase().then(result => {
    console.log('\n✅ Diagnóstico completo!', result);
}).catch(err => {
    console.error('\n❌ Diagnóstico falhou!', err);
});
