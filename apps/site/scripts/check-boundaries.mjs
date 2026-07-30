import { readFile } from 'node:fs/promises';

const source = await readFile(new URL('../src/main.tsx', import.meta.url), 'utf8');

const requiredLegalPaths = [
  '/politica-de-privacidade',
  '/termos-de-uso',
  '/politica-de-cookies',
  '/direitos-do-titular',
  '/dados-educacionais',
  '/cancelamento-e-reembolso',
  '/transparencia-em-ia',
  '/seguranca-e-lgpd',
];

const failures = [];

if (!source.includes("const APP_URL = 'https://app.profeplan.com.br'")) {
  failures.push('APP_URL deve continuar apontando para https://app.profeplan.com.br.');
}

for (const path of requiredLegalPaths) {
  if (!source.includes(path)) {
    failures.push(`Link legal obrigatório ausente: ${path}`);
  }
}

if (source.includes('apps/web') || source.includes('../web') || source.includes('../../web')) {
  failures.push('O site público não pode importar código de apps/web.');
}

if (failures.length > 0) {
  console.error(failures.join('\n'));
  process.exit(1);
}

console.log('Fronteiras do site e links legais verificados.');
