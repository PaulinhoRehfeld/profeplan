import type { ExtractionMethodRef, ExtractionPageRef, PhysicalPageRange } from '@profeplan/types';
import type { VerifiedExtractionArtifactRead } from '../extraction/artifact-read.service.ts';
import type { NativeTextExtractedPage } from '../extraction/native-text-extractor.port.ts';

export interface DocumentInspectionRequest {
  readonly artifact: VerifiedExtractionArtifactRead;
  /** Undefined means inspect every physical page. */
  readonly pageRanges?: readonly PhysicalPageRange[];
}

export interface DocumentInspectionResult {
  readonly method: ExtractionMethodRef & { readonly kind: 'native_text' };
  readonly totalPhysicalPages: number;
  /**
   * Cheap document-level page metadata. It does not mean that page text was
   * inspected. `pages` below contains only the requested content windows.
   */
  readonly pageRefs: readonly ExtractionPageRef[];
  readonly pages: readonly NativeTextExtractedPage[];
}

/**
 * Narrow read-only boundary for structural reconnaissance. Unlike the C.3.3
 * full extractor, callers may request only selected physical page windows.
 */
export interface DocumentInspectorPort {
  inspect(request: DocumentInspectionRequest): Promise<DocumentInspectionResult>;
}
