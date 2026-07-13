import { createSimpleCompletion } from '../AiCore';
import type { IngestionResult } from '../AiIngestionService';

/**
 * Agente especializado em Planos de Curso do CRMG (Currículo Referência de Minas Gerais).
 *
 * Usa 2 passes independentes para evitar truncamento de JSON:
 *  - Pass 1: extrai metadados estruturados (output pequeno, nunca trunca)
 *  - Pass 2: formata o conteúdo em Markdown (string pura, sem wrapper JSON)
 */

export interface CurriculoMetadata {
  // Campos base (compatíveis com DocumentMetadata)
  subject: string;
  year: string;
  workload: number | null;
  skills: string[];
  objects_of_knowledge: string[];
  // Campos específicos CRMG
  trimestre?: string;
  unidades_tematicas?: string[];
  habilidades_crmg?: string[];
  competencias?: string[];
  objetos_conhecimento?: string[];
  orientacoes_pedagogicas?: string;
  perfil_saida_intermediario?: string;
}

interface CurriculoExtracted {
  disciplina: string;
  ano_escolar: string;
  trimestre: string;
  carga_horaria: number | null;
  unidades_tematicas: string[];
  habilidades_crmg: string[];
  competencias: string[];
  objetos_conhecimento: string[];
  orientacoes_pedagogicas: string;
  perfil_saida_intermediario: string;
  score: number;
}

// ── Pass 1: metadados estruturados ──────────────────────────────────────────

const METADATA_PROMPT = (rawText: string) =>
  `
Você é um extrator de metadados de Planos de Curso do CRMG (Currículo Referência de Minas Gerais).
Analise o texto bruto abaixo e extraia os campos estruturados.

INSTRUÇÕES IMPORTANTES:
- Retorne APENAS o JSON, sem blocos de código, sem explicações.
- Se um campo não for encontrado, use string vazia ou array vazio.
- habilidades_crmg são códigos como EM13CO13, EM13LP01, etc.
- Pode haver múltiplas habilidades e múltiplos objetos de conhecimento.
- orientacoes_pedagogicas: copie o texto completo desta seção.
- perfil_saida_intermediario: copie o texto completo desta seção.

Estrutura JSON esperada:
{
  "disciplina": "nome da disciplina (ex: Educação Digital, Matemática)",
  "ano_escolar": "ano escolar (ex: 2º ano EM, 1º ano EF)",
  "trimestre": "número do trimestre (ex: 2º Trimestre)",
  "carga_horaria": 40,
  "unidades_tematicas": ["Tecnologia, Trabalho e Produção de Conteúdo"],
  "habilidades_crmg": ["EM13CO13", "EM13CO14"],
  "competencias": ["Competência 4: Construir conhecimento usando técnicas e tecnologias computacionais..."],
  "objetos_conhecimento": ["Planilhas e fluxogramas", "Podcasts e vídeos educativos"],
  "orientacoes_pedagogicas": "texto completo das orientações pedagógicas",
  "perfil_saida_intermediario": "texto completo do perfil de saída",
  "score": 85
}

TEXTO DO DOCUMENTO (primeiros 15000 caracteres):
---
${rawText.substring(0, 15000)}
---
`.trim();

// ── Pass 2: conteúdo formatado em Markdown ──────────────────────────────────

const MARKDOWN_PROMPT = (rawText: string, meta: CurriculoExtracted) =>
  `
Você é um formatador pedagógico especializado em Planos de Curso.
Converta o texto bruto abaixo em Markdown estruturado e limpo.

CONTEXTO (já extraído):
- Disciplina: ${meta.disciplina}
- Ano: ${meta.ano_escolar}
- Trimestre: ${meta.trimestre}
- Habilidades: ${meta.habilidades_crmg.join(', ')}

REGRAS DE FORMATAÇÃO:
- Use # para o título principal (Disciplina + Ano + Trimestre)
- Use ## para cada seção: Unidades Temáticas, Habilidades CRMG, Competências, Objetos de Conhecimento, Orientações Pedagógicas, Perfil de Saída
- Preserve integralmente o conteúdo das Orientações Pedagógicas e do Perfil de Saída
- Habilidades CRMG em lista: - EM13CO13
- Converta tabelas em seções estruturadas
- Limpe artefatos de OCR (caracteres corrompidos, quebras estranhas)
- Retorne APENAS o Markdown, sem JSON, sem explicações adicionais

TEXTO BRUTO:
---
${rawText.substring(0, 40000)}
---
`.trim();

// ── Funções exportadas ───────────────────────────────────────────────────────

async function extractMetadata(rawText: string): Promise<CurriculoExtracted> {
  const response = await createSimpleCompletion(
    METADATA_PROMPT(rawText),
    'Você é uma API de extração de dados pedagógicos. Responda APENAS com JSON válido.',
    0.1
  );

  const clean = response
    .replace(/```json/gi, '')
    .replace(/```/g, '')
    .trim();
  return JSON.parse(clean) as CurriculoExtracted;
}

async function formatMarkdown(rawText: string, meta: CurriculoExtracted): Promise<string> {
  return createSimpleCompletion(
    MARKDOWN_PROMPT(rawText, meta),
    'Você é um formatador de documentos pedagógicos. Retorne apenas Markdown limpo.',
    0.2
  );
}

export async function parseCurriculo(rawText: string): Promise<IngestionResult> {
  // Pass 1 — metadados estruturados (output pequeno, JSON nunca trunca)
  let meta: CurriculoExtracted;
  try {
    meta = await extractMetadata(rawText);
  } catch (err) {
    console.error('[CurriculoAgent] Falha no Pass 1 (metadados):', err);
    // Fallback mínimo para não travar o fluxo
    meta = {
      disciplina: 'Geral',
      ano_escolar: 'Geral',
      trimestre: '',
      carga_horaria: null,
      unidades_tematicas: [],
      habilidades_crmg: [],
      competencias: [],
      objetos_conhecimento: [],
      orientacoes_pedagogicas: '',
      perfil_saida_intermediario: '',
      score: 30,
    };
  }

  // Pass 2 — markdown (string pura; truncamento parcial não quebra o fluxo)
  let content_md: string;
  try {
    content_md = await formatMarkdown(rawText, meta);
  } catch (err) {
    console.error('[CurriculoAgent] Falha no Pass 2 (markdown):', err);
    content_md = `# ${meta.disciplina} — ${meta.ano_escolar} — ${meta.trimestre}\n\n${rawText.substring(0, 8000)}`;
  }

  // Monta CurriculoMetadata compatível com DocumentMetadata
  const metadata: CurriculoMetadata = {
    // Campos base
    subject: meta.disciplina,
    year: meta.ano_escolar,
    workload: meta.carga_horaria,
    skills: meta.habilidades_crmg,
    objects_of_knowledge: meta.objetos_conhecimento,
    // Campos CRMG específicos
    trimestre: meta.trimestre,
    unidades_tematicas: meta.unidades_tematicas,
    habilidades_crmg: meta.habilidades_crmg,
    competencias: meta.competencias,
    objetos_conhecimento: meta.objetos_conhecimento,
    orientacoes_pedagogicas: meta.orientacoes_pedagogicas,
    perfil_saida_intermediario: meta.perfil_saida_intermediario,
  };

  return {
    content_md,
    metadata: metadata as any,
    extraction_score: meta.score,
    curation_report: buildCurationReport(meta),
  };
}

function buildCurationReport(meta: CurriculoExtracted): string {
  const items: string[] = [];

  if (!meta.disciplina || meta.disciplina === 'Geral') items.push('⚠️ Disciplina não identificada');
  if (!meta.trimestre) items.push('⚠️ Trimestre não identificado');
  if (meta.habilidades_crmg.length === 0) items.push('⚠️ Nenhuma habilidade CRMG extraída');
  if (meta.objetos_conhecimento.length === 0) items.push('⚠️ Objetos de conhecimento ausentes');
  if (!meta.orientacoes_pedagogicas) items.push('⚠️ Orientações Pedagógicas não encontradas');
  if (!meta.perfil_saida_intermediario) items.push('⚠️ Perfil de Saída não encontrado');

  if (items.length === 0) {
    return `✅ Extração completa. Disciplina: ${meta.disciplina} | ${meta.ano_escolar} | ${meta.trimestre} | ${meta.habilidades_crmg.length} habilidade(s) CRMG identificada(s).`;
  }

  return `## Relatório de Curadoria — CurriculoAgent\n\n${items.join('\n')}\n\nScore de confiança: ${meta.score}%`;
}
