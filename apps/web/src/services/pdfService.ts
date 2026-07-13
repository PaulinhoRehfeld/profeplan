import * as pdfjs from 'pdfjs-dist';

// Configuração do worker - usando a versão dinâmica do módulo importado
pdfjs.GlobalWorkerOptions.workerSrc = `https://esm.sh/pdfjs-dist@${pdfjs.version}/build/pdf.worker.min.mjs`;

/**
 * Extrai todo o texto bruto de um arquivo PDF carregado.
 */
export const extractTextFromPdf = async (file: File): Promise<string> => {
  const arrayBuffer = await file.arrayBuffer();
  const loadingTask = pdfjs.getDocument(arrayBuffer);
  const pdf = await loadingTask.promise;

  let fullText = '';

  type PdfTextItem = { str?: string };

  for (let i = 1; i <= pdf.numPages; i++) {
    const page = await pdf.getPage(i);
    const textContent = await page.getTextContent();
    const pageText = textContent.items.map((item) => (item as PdfTextItem).str || '').join(' ');

    fullText += pageText + '\n';
  }

  return fullText;
};
