import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import {
  PDFJS_NATIVE_TEXT_EXTRACTOR_NAME,
  NativeTextExtractionError,
  PdfJsNativeTextExtractorAdapter,
  extractVerifiedNativeText,
} from '../src/index.ts';

const encoder = new TextEncoder();

function byteLength(value) {
  return encoder.encode(value).length;
}

function escapePdfString(value) {
  return value.replaceAll('\\', '\\\\').replaceAll('(', '\\(').replaceAll(')', '\\)');
}

function buildSyntheticPdf(pageTexts) {
  const objects = [];
  const pageObjectNumbers = pageTexts.map((_, index) => 4 + index * 2);

  objects[1] = '<< /Type /Catalog /Pages 2 0 R >>';
  objects[2] = `<< /Type /Pages /Kids [${pageObjectNumbers.map((number) => `${number} 0 R`).join(' ')}] /Count ${pageTexts.length} >>`;
  objects[3] = '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>';

  for (const [index, text] of pageTexts.entries()) {
    const pageObjectNumber = pageObjectNumbers[index];
    const contentObjectNumber = pageObjectNumber + 1;
    const stream = `BT\n/F1 14 Tf\n72 720 Td\n(${escapePdfString(text)}) Tj\nET`;

    objects[pageObjectNumber] =
      `<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] ` +
      `/Resources << /Font << /F1 3 0 R >> >> /Contents ${contentObjectNumber} 0 R >>`;
    objects[contentObjectNumber] = `<< /Length ${byteLength(stream)} >>\nstream\n${stream}\nendstream`;
  }

  let pdf = '%PDF-1.4\n% ProfePlan synthetic fixture\n';
  const offsets = [0];
  const maxObjectNumber = objects.length - 1;

  for (let objectNumber = 1; objectNumber <= maxObjectNumber; objectNumber += 1) {
    offsets[objectNumber] = byteLength(pdf);
    pdf += `${objectNumber} 0 obj\n${objects[objectNumber]}\nendobj\n`;
  }

  const xrefOffset = byteLength(pdf);
  pdf += `xref\n0 ${maxObjectNumber + 1}\n`;
  pdf += '0000000000 65535 f \n';
  for (let objectNumber = 1; objectNumber <= maxObjectNumber; objectNumber += 1) {
    pdf += `${String(offsets[objectNumber]).padStart(10, '0')} 00000 n \n`;
  }
  pdf += `trailer\n<< /Size ${maxObjectNumber + 1} /Root 1 0 R >>\n`;
  pdf += `startxref\n${xrefOffset}\n%%EOF\n`;

  return encoder.encode(pdf);
}

function verifiedArtifact(body) {
  return {
    artifact: {
      artifactId: 'artifact-pdfjs-synthetic',
      sha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      sizeBytes: body.byteLength,
    },
    mediaType: 'application/pdf',
    expiresAt: '2026-08-18T15:00:00.000Z',
    sha256: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
    body,
  };
}

test('PDF.js adapter extracts native text page by page from an in-memory synthetic PDF', async () => {
  const body = buildSyntheticPdf(['Primeira pagina sintetica', 'Segunda pagina sintetica']);
  const artifact = verifiedArtifact(body);
  const result = await extractVerifiedNativeText(new PdfJsNativeTextExtractorAdapter(), artifact);

  assert.equal(result.method.kind, 'native_text');
  assert.equal(result.method.name, PDFJS_NATIVE_TEXT_EXTRACTOR_NAME);
  assert.match(result.method.version, /^\d+\.\d+\.\d+/);
  assert.equal(result.pageCount, 2);
  assert.deepEqual(
    result.pages.map((page) => page.physicalPageNumber),
    [1, 2]
  );
  assert.match(result.pages[0].text, /Primeira pagina sintetica/);
  assert.match(result.pages[1].text, /Segunda pagina sintetica/);
  assert.equal(result.pages[0].elements[0].kind, 'text_block');
  assert.equal(result.pages[0].elements[0].logicalLocator, 'page:1/text:1');
});

test('PDF.js adapter does not mutate the governed artifact bytes', async () => {
  const body = buildSyntheticPdf(['Bytes sinteticos imutaveis']);
  const before = body.slice();
  await extractVerifiedNativeText(new PdfJsNativeTextExtractorAdapter(), verifiedArtifact(body));
  assert.deepEqual(body, before);
});

test('an all-empty synthetic PDF is classified by the shared boundary without OCR fallback', async () => {
  const body = buildSyntheticPdf(['', '   ']);

  await assert.rejects(
    extractVerifiedNativeText(new PdfJsNativeTextExtractorAdapter(), verifiedArtifact(body)),
    (error) => {
      assert.ok(error instanceof NativeTextExtractionError);
      assert.equal(error.code, 'native_text_unavailable');
      return true;
    }
  );
});

test('malformed synthetic PDF errors are normalized by the shared native-text boundary', async () => {
  const malformed = encoder.encode('%PDF-1.4\nsynthetic but malformed\n%%EOF');

  await assert.rejects(
    extractVerifiedNativeText(new PdfJsNativeTextExtractorAdapter(), verifiedArtifact(malformed)),
    (error) => {
      assert.ok(error instanceof NativeTextExtractionError);
      assert.equal(error.code, 'native_extractor_failed');
      return true;
    }
  );
});

test('PDF.js adapter remains free of OCR, hosted Storage and production surfaces', async () => {
  const source = await readFile(
    new URL('../src/extraction/pdfjs-native-text-extractor.adapter.ts', import.meta.url),
    'utf8'
  );
  const forbidden = [
    '@supabase',
    'SupabaseClient',
    'tesseract',
    'Textract',
    'GoogleDocumentAI',
    'signedUrl',
    'bucketName',
    'process.env',
    'fetch(',
    'http://',
    'https://',
  ];

  assert.equal(source.includes("pdfjs-dist/legacy/build/pdf.mjs"), true);
  for (const token of forbidden) {
    assert.equal(source.includes(token), false, `forbidden surface leaked into PDF.js adapter: ${token}`);
  }
});
