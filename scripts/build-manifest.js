
const fs = require('fs');
const path = require('path');

const publicDir = path.resolve(__dirname, '../public');
const kbDir = path.join(publicDir, 'knowledge_base');
const outputFile = path.join(publicDir, 'knowledge_manifest.json');

function getAllFiles(dirPath, arrayOfFiles) {
    const files = fs.readdirSync(dirPath);

    arrayOfFiles = arrayOfFiles || [];

    files.forEach(function (file) {
        if (fs.statSync(dirPath + "/" + file).isDirectory()) {
            arrayOfFiles = getAllFiles(dirPath + "/" + file, arrayOfFiles);
        } else {
            if (file.toLowerCase().endsWith('.pdf')) {
                arrayOfFiles.push(path.join(dirPath, "/", file));
            }
        }
    });

    return arrayOfFiles;
}

try {
    if (!fs.existsSync(kbDir)) {
        console.error("Knowledge Base directory not found:", kbDir);
        process.exit(1);
    }

    const allPdfs = getAllFiles(kbDir);
    const manifest = allPdfs.map(fullPath => {
        const relativePath = fullPath.replace(publicDir, '').replace(/\\/g, '/'); // Ensure web-friendly paths
        const fileName = path.basename(fullPath);

        // Simple categorization heuristic
        let category = 'Geral';
        if (relativePath.includes('MAPA MG')) category = 'Curriculo MG';
        if (relativePath.includes('ENEM')) category = 'Banco ENEM';
        if (relativePath.includes('Planos MG')) category = 'Plano de Curso';

        // Extract metadata from filename heuristic
        // Ex: EM_1ANO_1B_FILOSOFIA_ESTUDANTE.pdf
        const parts = fileName.replace('.pdf', '').split('_');
        let title = fileName;
        let discipline = null;

        // Advanced heuristic for MAPA naming convention
        if (parts.length >= 4) {
            title = parts.join(' ');
            // Try to find discipline in parts
            // This is rough but better than nothing
        }

        return {
            id: fileName, // simplistic ID
            title: title,
            category: category,
            path: relativePath,
            fileName: fileName
        };
    });

    fs.writeFileSync(outputFile, JSON.stringify(manifest, null, 2));
    console.log(`Manifest generated with ${manifest.length} documents at ${outputFile}`);

} catch (e) {
    console.error("Error generating manifest:", e);
    process.exit(1);
}
