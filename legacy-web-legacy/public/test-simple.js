// TESTE SIMPLIFICADO - Cole linha por linha no console

// 1. Teste direto Supabase (linha por linha)
import('./src/services/supabaseClient').then(async ({ supabase }) => {
    const result = await supabase.from('enem_questions').select('id, metadata', { count: 'exact' }).limit(5);
    console.log('Total:', result.count);
    console.log('Primeiras 5:', result.data);
    console.log('Erro:', result.error);
});
