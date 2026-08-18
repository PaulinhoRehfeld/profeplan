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

function normalizePageSpec(page) {
  if (typeof page === 'string') {
    return page.trim().length === 0 ? [] : [{ text: page, x: 72, y: 720 }];
  }
  return page;
}

function buildSyntheticPdf(pageSpecs) {
  const pages = pageSpecs.map(normalizePageSpec);
  const objects = [];
  const pageObjectNumbers = pages.map((_, index) => 4 + index * 2);

  objects[1] = '<< /Type /Catalog /Pages 2 0 R >>';
  objects[2] = `<< /Type /Pages /Kids [${pageObjectNumbers.map((number) => `${number} 0 R`).join(' ')}] /Count ${pages.length} >>`;
  objects[3] = '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>';

  for (const [index, blocks] of pages.entries()) {
    const pageObjectNumber = pageObjectNumbers[index];
    const contentObjectNumber = pageObjectNumber + 1;
    const stream = blocks
      .map(
        ({ text, x, y }) => `BT\n/F1 14 Tf\n1 0 0 1 ${x} ${y} Tm\n(${escapePdfString(text)}) Tj\nET`
      )
      .join('\n');

    objects[pageObjectNumber] =
      `<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] ` +
      `/Resources << /Font << /F1 3 0 R >> >> /Contents ${contentObjectNumber} 0 R >>`;
    objects[contentObjectNumber] =
      `<< /Length ${byteLength(stream)} >>\nstream\n${stream}\nendstream`;
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

test('PDF.js adapter preserves physical pages, empty-page gaps and parser-observed block order', async () => {
  const body = buildSyntheticPdf([
    [
      { text: 'Titulo sintetico', x: 72, y: 740 },
      { text: 'Bloco esquerdo', x: 72, y: 680 },
      { text: 'Bloco direito', x: 320, y: 680 },
    ],
    [],
    [{ text: 'Retomada apos pagina vazia', x: 72, y: 720 }],
  ]);

  const result = await extractVerifiedNativeText(
    new PdfJsNativeTextExtractorAdapter(),
    verifiedArtifact(body)
  );

  assert.equal(result.pageCount, 3);
  assert.deepEqual(
    result.pages.map((page) => page.physicalPageNumber),
    [1, 2, 3]
  );
  assert.equal(result.pages[1].text, '');
  assert.deepEqual(result.pages[1].elements, []);
  assert.deepEqual(
    result.pages[0].elements.map((element) => element.logicalLocator),
    ['page:1/text:1', 'page:1/text:2', 'page:1/text:3']
  );
  assert.deepEqual(
    result.pages[0].elements.map((element) => element.text),
    ['Titulo sintetico', 'Bloco esquerdo', 'Bloco direito']
  );
  assert.match(result.pages[2].text, /Retomada apos pagina vazia/);
});

test('PDF.js adapter keeps escaped PDF text observable without changing the governed bytes', async () => {
  const body = buildSyntheticPdf(['Texto com \\ barra e (parenteses)']);
  const before = body.slice();
  const result = await extractVerifiedNativeText(
    new PdfJsNativeTextExtractorAdapter(),
    verifiedArtifact(body)
  );

  assert.match(result.pages[0].text, /Texto com \\ barra e \(parenteses\)/);
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

test('PDF.js implementation remains free of OCR, hosted Storage and production surfaces', async () => {
  const extractorSource = await readFile(
    new URL('../src/extraction/pdfjs-native-text-extractor.adapter.ts', import.meta.url),
    'utf8'
  );
  const inspectorSource = await readFile(
    new URL('../src/cartography/pdfjs-document-inspector.adapter.ts', import.meta.url),
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

  assert.equal(
    extractorSource.includes('../cartography/pdfjs-document-inspector.adapter.ts'),
    true
  );
  assert.equal(inspectorSource.includes('pdfjs-dist/legacy/build/pdf.mjs'), true);
  for (const [surface, source] of [
    ['C.3.3 extractor', extractorSource],
    ['PDF.js inspector', inspectorSource],
  ]) {
    for (const token of forbidden) {
      assert.equal(
        source.includes(token),
        false,
        `forbidden surface leaked into ${surface}: ${token}`
      );
    }
  }
});
