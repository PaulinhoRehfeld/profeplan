import { PdfJsDocumentInspectorAdapter } from '../cartography/pdfjs-document-inspector.adapter.ts';
import type {
  NativeTextExtractionResult,
  NativeTextExtractorPort,
} from './native-text-extractor.port.ts';
import type { VerifiedExtractionArtifactRead } from './artifact-read.service.ts';

export const PDFJS_NATIVE_TEXT_EXTRACTOR_NAME = 'pdfjs-dist' as const;

/**
 * Concrete C.3.3 native-text adapter for Mozilla PDF.js.
 *
 * Full extraction remains the C.3.3 behavior. The shared PDF.js inspector now
 * owns page reading so structural reconnaissance can reuse the same parser while
 * requesting only selected page windows.
 */
export class PdfJsNativeTextExtractorAdapter implements NativeTextExtractorPort {
  private readonly inspector = new PdfJsDocumentInspectorAdapter();

  async extract(artifact: VerifiedExtractionArtifactRead): Promise<NativeTextExtractionResult> {
    const inspection = await this.inspector.inspect({ artifact });
    return {
      method: inspection.method,
      pages: inspection.pages,
    };
  }
}
