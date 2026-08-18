import { OPS, getDocument, version as pdfjsVersion } from 'pdfjs-dist/legacy/build/pdf.mjs';
import type { NativeTextExtractedPage } from '../extraction/native-text-extractor.port.ts';
import type {
  DocumentInspectionRequest,
  DocumentInspectionResult,
  DocumentInspectorPort,
} from './document-inspector.port.ts';

export const PDFJS_DOCUMENT_INSPECTOR_NAME = 'pdfjs-dist' as const;

const IMAGE_PAINT_OPERATORS = new Set<number>([
  OPS.paintJpegXObject,
  OPS.paintImageXObject,
  OPS.paintInlineImageXObject,
]);

function normalizePageText(parts: readonly string[]): string {
  return parts
    .join('')
    .replace(/[ \t]+\n/g, '\n')
    .trimEnd();
}

function selectedPhysicalPages(
  totalPhysicalPages: number,
  request: DocumentInspectionRequest
): readonly number[] {
  if (!request.pageRanges) {
    return Array.from({ length: totalPhysicalPages }, (_, index) => index + 1);
  }

  const selected = new Set<number>();
  for (const range of request.pageRanges) {
    if (
      !Number.isInteger(range.startPhysicalPage) ||
      !Number.isInteger(range.endPhysicalPage) ||
      range.startPhysicalPage < 1 ||
      range.endPhysicalPage < range.startPhysicalPage
    ) {
      throw new Error('invalid document inspection page range');
    }

    if (range.startPhysicalPage > totalPhysicalPages) {
      throw new Error('document inspection page range starts outside document');
    }

    const clippedEnd = Math.min(range.endPhysicalPage, totalPhysicalPages);
    for (
      let physicalPageNumber = range.startPhysicalPage;
      physicalPageNumber <= clippedEnd;
      physicalPageNumber += 1
    ) {
      selected.add(physicalPageNumber);
    }
  }

  return [...selected].sort((left, right) => left - right);
}

async function readPage(
  document: Awaited<ReturnType<typeof getDocument>['promise']>,
  physicalPageNumber: number,
  printedPageLabel?: string
): Promise<NativeTextExtractedPage> {
  const page = await document.getPage(physicalPageNumber);
  try {
    const [content, operatorList] = await Promise.all([
      page.getTextContent(),
      page.getOperatorList(),
    ]);
    const textParts: string[] = [];
    const elements: NativeTextExtractedPage['elements'][number][] = [];
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

    let observedImageIndex = 0;
    for (const operator of operatorList.fnArray) {
      if (!IMAGE_PAINT_OPERATORS.has(operator)) {
        continue;
      }
      observedImageIndex += 1;
      elements.push({
        logicalLocator: `page:${physicalPageNumber}/image:${observedImageIndex}`,
        kind: 'image_marker',
      });
    }

    return {
      physicalPageNumber,
      ...(printedPageLabel ? { printedPageLabel } : {}),
      text: normalizePageText(textParts),
      elements,
    };
  } finally {
    page.cleanup();
  }
}

/**
 * PDF.js reconnaissance adapter. It reads page labels for the document but
 * extracts content only from explicitly requested page windows.
 */
export class PdfJsDocumentInspectorAdapter implements DocumentInspectorPort {
  async inspect(request: DocumentInspectionRequest): Promise<DocumentInspectionResult> {
    const loadingTask = getDocument({
      data: request.artifact.body.slice(),
      stopAtErrors: true,
      useSystemFonts: true,
    });

    try {
      const document = await loadingTask.promise;
      const printedLabels = await document.getPageLabels();
      const pageRefs = Array.from({ length: document.numPages }, (_, index) => {
        const printedPageLabel = printedLabels?.[index];
        return {
          physicalPageNumber: index + 1,
          ...(printedPageLabel ? { printedPageLabel } : {}),
        };
      });
      const selectedPages = selectedPhysicalPages(document.numPages, request);
      const pages: NativeTextExtractedPage[] = [];

      for (const physicalPageNumber of selectedPages) {
        pages.push(
          await readPage(document, physicalPageNumber, printedLabels?.[physicalPageNumber - 1])
        );
      }

      return {
        method: {
          kind: 'native_text',
          name: PDFJS_DOCUMENT_INSPECTOR_NAME,
          version: pdfjsVersion,
        },
        totalPhysicalPages: document.numPages,
        pageRefs,
        pages,
      };
    } finally {
      await loadingTask.destroy();
    }
  }
}
