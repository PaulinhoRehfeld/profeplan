import type { ExtractionMethodRef, ExtractionObservedElementKind } from '@profeplan/types';
import type { VerifiedExtractionArtifactRead } from './artifact-read.service.ts';

export const NATIVE_TEXT_EXTRACTION_ERROR_CODES = [
  'unsupported_media_type',
  'native_text_unavailable',
  'invalid_extraction_output',
  'native_extractor_failed',
] as const;

export type NativeTextExtractionErrorCode = (typeof NATIVE_TEXT_EXTRACTION_ERROR_CODES)[number];

export class NativeTextExtractionError extends Error {
  readonly code: NativeTextExtractionErrorCode;

  constructor(code: NativeTextExtractionErrorCode, message: string) {
    super(message);
    this.name = 'NativeTextExtractionError';
    this.code = code;
  }
}

export interface NativeTextObservedElement {
  readonly logicalLocator: string;
  readonly kind: ExtractionObservedElementKind;
  readonly text?: string;
}

export interface NativeTextExtractedPage {
  readonly physicalPageNumber: number;
  readonly printedPageLabel?: string;
  readonly text: string;
  readonly elements: readonly NativeTextObservedElement[];
}

export interface NativeTextExtractionResult {
  readonly method: ExtractionMethodRef & { readonly kind: 'native_text' };
  readonly pages: readonly NativeTextExtractedPage[];
}

/**
 * Parser-neutral boundary for native PDF text extraction. A concrete parser is
 * an infrastructure detail and is not selected by this contract.
 */
export interface NativeTextExtractorPort {
  extract(artifact: VerifiedExtractionArtifactRead): Promise<NativeTextExtractionResult>;
}
