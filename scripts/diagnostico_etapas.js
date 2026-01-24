const fs = require('fs');
const path = require('path');

// Lê o arquivo JSON com as escolas
const escolasPath = path.join(__dirname, '..', '..', 'importador-escolas', 'banco_escolas_pronto.json');
const todasEscolas = JSON.parse(fs.readFileSync(escolasPath, 'utf8'));

console.log(`📊 Total de escolas no arquivo: ${todasEscolas.length}`);

// Vamos ver alguns exemplos para entender a estrutura
console.log(`\n🔍 Analisando primeiras 10 escolas...\n`);

for (let i = 0; i < Math.min(10, todasEscolas.length); i++) {
    const escola = todasEscolas[i];
    console.log(`${i + 1}. ${escola.nome}`);
    console.log(`   Etapas:`, escola.etapas_ensino);
    console.log('');
}

// Contar quantas escolas têm pelo menos uma etapa true
const comEtapas = todasEscolas.filter(e => {
    const etapas = e.etapas_ensino;
    return etapas.infantil || etapas.anos_iniciais || etapas.anos_finais || etapas.ensino_medio || etapas.eja;
});

console.log(`\n📊 Escolas com pelo menos uma etapa marcada: ${comEtapas.length} de ${todasEscolas.length}`);
console.log(`📊 Escolas SEM nenhuma etapa: ${todasEscolas.length - comEtapas.length}`);

// Se não houver etapas, vamos importar TODAS as escolas estaduais (assumindo que todas atendem médio)
if (comEtapas.length === 0) {
    console.log(`\n⚠️  ATENÇÃO: Dados de etapas não disponíveis no JSON!`);
    console.log(`📝 Solução: Importar TODAS as escolas (são todas estaduais de MG)`);
    console.log(`💡 Recomendação: Use o arquivo SQL completo (20260124_import_schools_mg.sql)`);
}
