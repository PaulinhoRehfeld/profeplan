// Gera prompts.generated.ts em cada packages/agents/src/disciplinas/<disciplina>/
// a partir dos .md reais em prompts/*.md. Motivo: depender de fs.readFileSync em
// runtime é frágil numa function serverless (bundling) — os prompts viram string
// TS, embutidos no bundle, sem I/O em produção.
//
// Rodar: node packages/agents/scripts/build-prompts.mjs
// Re-rodar sempre que algum .md de prompts/ for editado.

import { readdirSync, readFileSync, writeFileSync, statSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const disciplinasDir = join(__dirname, '..', 'src', 'disciplinas');

const escapeTemplateLiteral = (text) =>
  text.replace(/\\/g, '\\\\').replace(/`/g, '\\`').replace(/\$\{/g, '\\${');

let totalGerados = 0;

for (const entry of readdirSync(disciplinasDir)) {
  const disciplinaDir = join(disciplinasDir, entry);
  if (!statSync(disciplinaDir).isDirectory()) continue;

  const promptsDir = join(disciplinaDir, 'prompts');
  let mdFiles;
  try {
    mdFiles = readdirSync(promptsDir).filter((f) => f.endsWith('.md'));
  } catch {
    continue; // disciplina sem pasta prompts/ (ex: dummy)
  }
  if (!mdFiles.length) continue;

  const entries = mdFiles
    .sort()
    .map((filename) => {
      const content = readFileSync(join(promptsDir, filename), 'utf-8');
      return `  '${filename}': \`${escapeTemplateLiteral(content)}\`,`;
    })
    .join('\n');

  const output = `// ============================================================================
// GERADO AUTOMATICAMENTE por scripts/build-prompts.mjs — NÃO EDITAR À MÃO.
// Fonte: prompts/*.md nesta mesma pasta. Para atualizar, edite o .md e rode:
//   node packages/agents/scripts/build-prompts.mjs
// ============================================================================

export const PROMPTS: Record<string, string> = {
${entries}
};
`;

  writeFileSync(join(disciplinaDir, 'prompts.generated.ts'), output, 'utf-8');
  totalGerados += 1;
  console.log(`[build-prompts] ${entry}: ${mdFiles.length} prompt(s) -> prompts.generated.ts`);
}

console.log(`[build-prompts] Concluído: ${totalGerados} disciplina(s) processada(s).`);
