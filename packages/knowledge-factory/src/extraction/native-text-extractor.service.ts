import type { ExtractionMethodRef } from '@profeplan/types';
import type { VerifiedExtractionArtifactRead } from './artifact-read.service.ts';
import {
  NativeTextExtractionError,
  type NativeTextExtractedPage,
  type NativeTextExtractionResult,
  type NativeTextExtractorPort,
} from './native-text-extractor.port.ts';

export interface VerifiedNativeTextExtraction {
  readonly artifactSha256: string;
  readonly method: ExtractionMethodRef & { readonly kind: 'native_text' };
  readonly pageCount: number;
  readonly pages: readonly NativeTextExtractedPage[];
}

function assertNativePdfArtifact(artifact: VerifiedExtractionArtifactRead): void {
  if (artifact.mediaType !== 'application/pdf') {
    throw new NativeTextExtractionError(
      'unsupported_media_type',
      'Native C.3.3 extraction currently accepts governed PDF artifacts only.'
    );
  }
}

function validatePage(page: NativeTextExtractedPage, expectedPageNumber: number): void {
  if (
    !Number.isSafeInteger(page.physicalPageNumber) ||
    page.physicalPageNumber !== expectedPageNumber
  ) {
    throw new NativeTextExtractionError(
      'invalid_extraction_output',
      'Native extraction pages must be complete, ordered and numbered from one.'
    );
  }

  if (typeof page.text !== 'string') {
    throw new NativeTextExtractionError(
      'invalid_extraction_output',
      'Native extraction page text must be represented explicitly as a string.'
    );
  }

  const locators = new Set<string>();
  for (const element of page.elements) {
    if (!element.logicalLocator.trim()) {
      throw new NativeTextExtractionError(
        'invalid_extraction_output',
        'Observed elements require a non-blank logical locator.'
      );
    }
    if (locators.has(element.logicalLocator)) {
      throw new NativeTextExtractionError(
        'invalid_extraction_output',
        'Observed element logical locators must be unique within a page.'
      );
    }
    locators.add(element.logicalLocator);
  }
}

export async function extractVerifiedNativeText(
  port: NativeTextExtractorPort,
  artifact: VerifiedExtractionArtifactRead
): Promise<VerifiedNativeTextExtraction> {
  assertNativePdfArtifact(artifact);

  let result: NativeTextExtractionResult;
  try {
    result = await port.extract(artifact);
  } catch (error) {
    if (error instanceof NativeTextExtractionError) {
      throw error;
    }
    throw new NativeTextExtractionError(
      'native_extractor_failed',
      'Native text extraction failed without a governed error classification.'
    );
  }

  if (
    result.method.kind !== 'native_text' ||
    !result.method.name.trim() ||
    !result.method.version.trim()
  ) {
    throw new NativeTextExtractionError(
      'invalid_extraction_output',
      'Native extraction method identity is incomplete or invalid.'
    );
  }

  if (result.pages.length === 0) {
    throw new NativeTextExtractionError(
      'native_text_unavailable',
      'Native extraction returned no observable pages.'
    );
  }

  for (const [index, page] of result.pages.entries()) {
    validatePage(page, index + 1);
  }

  const hasNativeText = result.pages.some((page) => page.text.trim().length > 0);
  if (!hasNativeText) {
    throw new NativeTextExtractionError(
      'native_text_unavailable',
      'The governed PDF exposes no usable native text and requires a later alternate-extraction decision.'
    );
  }

  return {
    artifactSha256: artifact.sha256,
    method: result.method,
    pageCount: result.pages.length,
    pages: result.pages.map((page) => ({
      ...page,
      elements: page.elements.map((element) => ({ ...element })),
    })),
  };
}
