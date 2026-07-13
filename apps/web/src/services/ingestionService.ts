import { supabase } from './supabaseClient';

/**
 * Interface representing a parsed document chunk
 */
export interface IngestedDocument {
  content: string;
  metadata: {
    source: string;
    disciplina?: string;
    ano_escolar?: string;
    periodo?: string;
    unidade_tematica?: string;
  };
}

/**
 * Simple Markdown Header Splitter (Heuristic)
 * Splits based on # headers to preserve hierarchy.
 */
const splitMarkdownByHeaders = (text: string, source: string): IngestedDocument[] => {
  const lines = text.split('\n');
  const docs: IngestedDocument[] = [];

  let currentDisciplina = 'Geral';
  // 1. Tenta extrair o Ano do nome do arquivo (Ex: "7ano_GEOGRAFIA.md" -> "7º Ano")
  let currentAno = 'Geral';
  const anoMatch = source.match(/(\d+)\s*ano/i);
  if (anoMatch) {
    currentAno = `${anoMatch[1]}º Ano`;
  }

  let currentPeriodo = 'Geral';
  let currentUnidade = '';

  let currentBuffer: string[] = [];

  const flushBuffer = () => {
    if (currentBuffer.length > 0) {
      const content = currentBuffer.join('\n').trim();
      if (content) {
        // Enrich content with context
        // INCLUINDO AS PÁGINAS NO TEXTO DO CONTEXTO PARA O LLM VER
        const richContent = `Contexto: ${currentDisciplina} | ${currentAno} | ${currentPeriodo} (Páginas incluídas se disponíveis). Unidade: ${currentUnidade}. Conteúdo: ${content}`;

        docs.push({
          content: richContent,
          metadata: {
            source,
            disciplina: currentDisciplina,
            ano_escolar: currentAno,
            periodo: currentPeriodo, // Agora contém "1º BIMESTRE (págs 96-97)"
            unidade_tematica: currentUnidade,
          },
        });
      }
      currentBuffer = [];
    }
  };

  for (const line of lines) {
    if (line.startsWith('# ')) {
      flushBuffer();
      currentDisciplina = line.replace('# ', '').trim();
    } else if (line.startsWith('## ')) {
      // CORRECTION: H2 is Period/Bimester in standard MG files (contains page numbers)
      flushBuffer();
      currentPeriodo = line.replace('## ', '').trim();
    } else if (line.startsWith('### ')) {
      // H3 usually is "Habilidades" or "Unidade Temática" depending on file
      // We keep it as Unidade or just part of content context implicitly?
      // Let's treat H3 as the start of a broad section (Unidade)
      flushBuffer();
      currentUnidade = line.replace('### ', '').trim();
    } else if (line.startsWith('#### ')) {
      // Deeper level
      flushBuffer();
      // Append to unit or keep separate? Let's just update unit
      currentUnidade = line.replace('#### ', '').trim();
    } else {
      currentBuffer.push(line);
    }
  }
  flushBuffer(); // Final flush

  return docs;
};

/**
 * Main Ingestion Function
 * Reads files, chunks them, generates embeddings, and uploads to Supabase.
 */
export const ingestFiles = async (
  files: File[],
  onProgress: (current: number, total: number, message: string) => void
) => {
  // Fluxo original usava embeddings Gemini; este serviço de ingestão
  // não é crítico para o uso diário do app em produção. Para simplificar
  // o build e a infraestrutura, a vetorização foi desativada aqui.

  let totalChunks = 0;
  let processedChunks = 0;

  try {
    // 1. Read and Parse Files
    let allDocs: IngestedDocument[] = [];

    for (let i = 0; i < files.length; i++) {
      const file = files[i];
      onProgress(0, files.length, `Lendo arquivo ${i + 1}/${files.length}: ${file.name}`);

      const text = await file.text();
      const fileDocs = splitMarkdownByHeaders(text, file.name);
      allDocs = [...allDocs, ...fileDocs];
    }

    totalChunks = allDocs.length;
    onProgress(
      0,
      totalChunks,
      `Pré-processamento concluído. Vetorização desativada neste ambiente – apenas pré-visualização dos chunks.`
    );

    // Inserir conteúdo bruto sem embeddings (ou pular inserção, conforme necessidade futura).
    // Aqui optamos por não escrever nada no banco em produção até que
    // uma nova estratégia de embeddings (ex.: Azure OpenAI) seja definida.

    onProgress(totalChunks, totalChunks, 'Ingestão concluída (sem embeddings).');
    return true;
  } catch (error: unknown) {
    console.error('Ingestion failed:', error);
    throw error;
  }
};

/**
 * Clears existing entries for specific files to avoid duplicates
 */
export const clearExistingSource = async (filenames: string[]) => {
  // This assumes metadata->>'source' exists
  // Deleting one by one or using 'in' is risky with JSONB in some Supabase versions without proper gin index,
  // but works for small batches.
  for (const filename of filenames) {
    await supabase.from('curriculos_mg').delete().filter('metadata->>source', 'eq', filename);
  }
};
