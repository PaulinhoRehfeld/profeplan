import { getDocument, version as pdfjsVersion } from 'pdfjs-dist/legacy/build/pdf.mjs';
import type {
  NativeTextExtractionResult,
  NativeTextExtractorPort,
} from './native-text-extractor.port.ts';
import type { VerifiedExtractionArtifactRead } from './artifact-read.service.ts';

export const PDFJS_NATIVE_TEXT_EXTRACTOR_NAME = 'pdfjs-dist' as const;

function normalizePageText(parts: readonly string[]): string {
  return parts
    .join('')
    .replace(/[ \t]+\n/g, '\n')
    .trimEnd();
}

/**
 * Concrete C.3.3 native-text adapter for Mozilla PDF.js.
 *
 * The adapter accepts only bytes that already crossed the governed artifact-read
 * boundary. It does not perform OCR, Storage access, persistence, segmentation
 * or semantic interpretation.
 */
export class PdfJsNativeTextExtractorAdapter implements NativeTextExtractorPort {
  async extract(artifact: VerifiedExtractionArtifactRead): Promise<NativeTextExtractionResult> {
    const loadingTask = getDocument({
      data: artifact.body.slice(),
      stopAtErrors: true,
      useSystemFonts: true,
    });

    try {
      const document = await loadingTask.promise;
      const printedLabels = await document.getPageLabels();
      const pages: NativeTextExtractionResult['pages'][number][] = [];

      for (
        let physicalPageNumber = 1;
        physicalPageNumber <= document.numPages;
        physicalPageNumber += 1
      ) {
        const page = await document.getPage(physicalPageNumber);
        const content = await page.getTextContent();
        const textParts: string[] = [];
        const elements: NativeTextExtractionResult['pages'][number]['elements'][number][] = [];
        let observedTextIndex = 0;

        for (const item of content.items) {
          if (!('str' in item)) {
            continue;
          }

          textParts.push(item.str);
          textParts.push(item.hasEOL ? '\n' : ' ');

          if (item.str.trim().length > 0) {
            observedTextIndex += 1;
            elements.push({
              logicalLocator: `page:${physicalPageNumber}/text:${observedTextIndex}`,
              kind: 'text_block',
              text: item.str,
            });
          }
        }

        const printedPageLabel = printedLabels?.[physicalPageNumber - 1];
        pages.push({
          physicalPageNumber,
          ...(printedPageLabel ? { printedPageLabel } : {}),
          text: normalizePageText(textParts),
          elements,
        });
        page.cleanup();
      }

      return {
        method: {
          kind: 'native_text',
          name: PDFJS_NATIVE_TEXT_EXTRACTOR_NAME,
          version: pdfjsVersion,
        },
        pages,
      };
    } finally {
      await loadingTask.destroy();
    }
  }
}
