const fs = require('fs');
const path = require('path');

// Pastas para IGNORAR (para não travar lendo bibliotecas)
const IGNORE_DIRS = ['node_modules', '.git', '.next', 'dist', 'build', '.vscode'];

function procurarErro(diretorio) {
    const arquivos = fs.readdirSync(diretorio);

    arquivos.forEach(arquivo => {
        const caminhoCompleto = path.join(diretorio, arquivo);
        const stat = fs.statSync(caminhoCompleto);

        // Se for pasta, entra nela (recursividade), a menos que seja ignorada
        if (stat.isDirectory()) {
            if (!IGNORE_DIRS.includes(arquivo)) {
                procurarErro(caminhoCompleto);
            }
        } 
        // Se for arquivo de código (.js, .jsx, .tsx)
        else if (arquivo.endsWith('.js') || arquivo.endsWith('.jsx') || arquivo.endsWith('.tsx')) {
            // Não verifica nossos próprios scripts de ferramentas
            if (arquivo === 'achar_erro.js' || arquivo.includes('gerar_banco') || arquivo.includes('enviar_para')) return;

            const conteudo = fs.readFileSync(caminhoCompleto, 'utf-8');
            
            // A REGEX QUE CAÇA O ERRO: procura style="algumacoisa"
            // Procura style= seguido de aspas duplas ou simples
            const regexErro = /style\s*=\s*["']([^"']*)["']/;
            
            const linhas = conteudo.split('\n');
            linhas.forEach((linha, index) => {
                if (regexErro.test(linha)) {
                    // Ignora se for tag HTML de verdade dentro de string
                    if (!linha.includes('return') && !linha.includes('<')) return; 

                    console.log(`\n🚨 ENCONTRADO!`);
                    console.log(`📂 Arquivo: ${caminhoCompleto}`);
                    console.log(`🔢 Linha: ${index + 1}`);
                    console.log(`❌ O código errado: ${linha.trim()}`);
                    console.log(`--------------------------------------------------`);
                }
            });
        }
    });
}

console.log("🔍 Iniciando varredura por 'style=\"...\"' no projeto...");
procurarErro(process.cwd());
console.log("🏁 Varredura finalizada.");