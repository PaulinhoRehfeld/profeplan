/**
 * CHECK EMBEDDINGS STATUS
 * 
 * Script para verificar se embeddings existem no banco
 */

import { supabase } from '../../../services/supabaseClient';

async function checkEmbeddingsStatus() {
    console.log('🔍 Verificando status dos embeddings...\n');

    try {
        // 1. Total de questões
        const { count: total, error: countError } = await supabase
            .from('enem_questions')
            .select('*', { count: 'exact', head: true });

        if (countError) {
            console.error('❌ Erro ao contar questões:', countError);
            return;
        }

        console.log(`📊 Total de questões: ${total}`);

        // 2. Testar se coluna embedding existe
        const { data: sampleData, error: sampleError } = await supabase
            .from('enem_questions')
            .select('id, embedding')
            .limit(10);

        if (sampleError) {
            if (sampleError.message.includes('embedding')) {
                console.log('❌ Coluna "embedding" NÃO EXISTE no banco');
                console.log('\n📝 CENÁRIO: Precisa criar coluna primeiro\n');
                return {
                    scenario: 'NO_COLUMN',
                    total,
                    withEmbedding: 0
                };
            }
            console.error('❌ Erro ao buscar amostra:', sampleError);
            return;
        }

        // 3. Contar quantas têm embeddings
        const withEmbedding = sampleData.filter(q => q.embedding !== null).length;
        const sampleSize = sampleData.length;

        console.log(`\n📈 Amostra (${sampleSize} questões):`);
        console.log(`  ✅ Com embedding: ${withEmbedding}`);
        console.log(`  ❌ Sem embedding: ${sampleSize - withEmbedding}`);

        // 4. Determinar cenário
        let scenario = '';
        if (withEmbedding === sampleSize) {
            scenario = 'ALL_HAVE_EMBEDDINGS';
            console.log('\n✅ CENÁRIO A: Todas as questões TÊM embeddings!');
            console.log('   Ação: Apenas ativar Hybrid Search v2\n');
        } else if (withEmbedding > 0) {
            scenario = 'PARTIAL_EMBEDDINGS';
            console.log('\n⚠️  CENÁRIO B: Embeddings PARCIAIS');
            console.log('   Ação: Gerar embeddings faltantes\n');
        } else {
            scenario = 'NO_EMBEDDINGS';
            console.log('\n❌ CENÁRIO C: Nenhuma questão tem embeddings');
            console.log('   Ação: Gerar todos os embeddings (~6 horas)\n');
        }

        return {
            scenario,
            total,
            sampleSize,
            withEmbedding,
            withoutEmbedding: sampleSize - withEmbedding
        };

    } catch (error) {
        console.error('❌ Erro fatal:', error);
    }
}

// Executar
checkEmbeddingsStatus().then(result => {
    console.log('📋 Resultado:', result);
});

export { checkEmbeddingsStatus };
