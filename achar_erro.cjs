const fs = require('fs');
const path = require('path');

// --- CONFIGURAÇÃO ---
const DIRETORIO_RAIZ = process.cwd();
const IGNORAR = ['node_modules', '.git', '.next', 'dist', 'build', '.vscode'];

function procurarErro(diretorio) {
    const itens = fs.readdirSync(diretorio);

    itens.forEach(item => {
        const caminhoCompleto = path.join(diretorio, item);
        const stat = fs.statSync(caminhoCompleto);

        // 1. Entra nas pastas (se não forem proibidas)
        if (stat.isDirectory()) {
            if (!IGNORAR.includes(item)) {
                procurarErro(caminhoCompleto);
            }
        } 
        // 2. Analisa arquivos de código e HTML
        else if (item.match(/\.(jsx|tsx|js|html)$/)) {
            
            if (item === 'achar_erro.cjs') return;

            const conteudo = fs.readFileSync(caminhoCompleto, 'utf-8');
            const linhas = conteudo.split('\n');

            linhas.forEach((linha, index) => {
                if (linha.length > 400) return; // Ignora linhas gigantes (código minificado)

                // --- OS DETETIVES ---
                
                // Caso 1: style="color: red" (O Clássico)
                const erroClassico = /style\s*=\s*["']/.test(linha);
                
                // Caso 2: style={'color: red'} (Com chaves e aspas - React odeia isso)
                const erroComChaves = /style\s*=\s*\{\s*["']/.test(linha);

                if (erroClassico || erroComChaves) {
                    
                    // Filtra falsos positivos (como declaração de variáveis)
                    if (linha.trim().startsWith('const ') || linha.trim().startsWith('let ')) return;
                    if (linha.includes('return') === false && linha.includes('<') === false) return; // Só avisa se tiver cara de HTML/JSX

                    console.log(`\n🚨 ACHEI ALGO SUSPEITO!`);
                    console.log(`📂 Arquivo: ${caminhoCompleto}`);
                    console.log(`🔢 Linha: ${index + 1}`);
                    console.log(`❌ Código: ${linha.trim()}`);
                    console.log(`--------------------------------------------------`);
                }
            });
        }
    });
}

console.log(`🔍 Iniciando varredura PROFUNDA em: ${DIRETORIO_RAIZ}`);
console.log("...Procurando style='...' e style={'...'} ...");
procurarErro(DIRETORIO_RAIZ);
console.log("🏁 Fim da busca.");