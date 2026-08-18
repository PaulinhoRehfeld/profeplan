import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import {
  NATIVE_TEXT_EXTRACTION_ERROR_CODES,
  NativeTextExtractionError,
  extractVerifiedNativeText,
} from '../src/index.ts';

const artifact = {
  artifact: {
    artifactId: 'artifact-synthetic-native-text',
    sha256: '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef',
    sizeBytes: 128,
  },
  mediaType: 'application/pdf',
  expiresAt: '2026-08-18T06:00:00.000Z',
  sha256: '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef',
  body: new TextEncoder().encode('%PDF-1.7 synthetic parser-neutral fixture'),
};

function extractor(overrides = {}) {
  return {
    async extract() {
      return {
        method: {
          kind: 'native_text',
          name: 'synthetic-native-text-extractor',
          version: '1.0.0',
        },
        pages: [
          {
            physicalPageNumber: 1,
            printedPageLabel: '1',
            text: 'Primeira página sintética.',
            elements: [
              {
                logicalLocator: 'page:1/block:1',
                kind: 'text_block',
                text: 'Primeira página sintética.',
              },
            ],
          },
          {
            physicalPageNumber: 2,
            text: 'Segunda página sintética.',
            elements: [],
          },
        ],
      };
    },
    ...overrides,
  };
}

async function expectExtractionError(promise, code) {
  await assert.rejects(promise, (error) => {
    assert.ok(error instanceof NativeTextExtractionError);
    assert.equal(error.code, code);
    return true;
  });
}

test('native text error vocabulary is closed and does not imply automatic OCR', () => {
  assert.deepEqual(NATIVE_TEXT_EXTRACTION_ERROR_CODES, [
    'unsupported_media_type',
    'native_text_unavailable',
    'invalid_extraction_output',
    'native_extractor_failed',
  ]);
});

test('synthetic native extraction preserves physical page order and observed elements', async () => {
  const result = await extractVerifiedNativeText(extractor(), artifact);

  assert.equal(result.artifactSha256, artifact.sha256);
  assert.equal(result.method.kind, 'native_text');
  assert.equal(result.pageCount, 2);
  assert.deepEqual(
    result.pages.map((page) => page.physicalPageNumber),
    [1, 2]
  );
  assert.equal(result.pages[0].printedPageLabel, '1');
  assert.equal(result.pages[0].elements[0].kind, 'text_block');
  assert.equal(result.pages[0].elements[0].logicalLocator, 'page:1/block:1');
});

test('verified result defensively copies page and element containers', async () => {
  const source = await extractor().extract(artifact);
  const result = await extractVerifiedNativeText(
    {
      async extract() {
        return source;
      },
    },
    artifact
  );

  assert.notEqual(result.pages, source.pages);
  assert.notEqual(result.pages[0], source.pages[0]);
  assert.notEqual(result.pages[0].elements, source.pages[0].elements);
  assert.notEqual(result.pages[0].elements[0], source.pages[0].elements[0]);
});

test('non-PDF artifacts fail before a parser is invoked', async () => {
  let calls = 0;
  await expectExtractionError(
    extractVerifiedNativeText(
      {
        async extract() {
          calls += 1;
          return extractor().extract();
        },
      },
      { ...artifact, mediaType: 'text/plain' }
    ),
    'unsupported_media_type'
  );
  assert.equal(calls, 0);
});

test('zero observable pages requires alternate-extraction decision', async () => {
  await expectExtractionError(
    extractVerifiedNativeText(
      extractor({
        async extract() {
          return {
            method: { kind: 'native_text', name: 'synthetic', version: '1.0.0' },
            pages: [],
          };
        },
      }),
      artifact
    ),
    'native_text_unavailable'
  );
});

test('all-empty pages require alternate-extraction decision without invoking OCR', async () => {
  await expectExtractionError(
    extractVerifiedNativeText(
      extractor({
        async extract() {
          return {
            method: { kind: 'native_text', name: 'synthetic', version: '1.0.0' },
            pages: [
              { physicalPageNumber: 1, text: '   ', elements: [] },
              { physicalPageNumber: 2, text: '', elements: [] },
            ],
          };
        },
      }),
      artifact
    ),
    'native_text_unavailable'
  );
});

test('page numbers must be complete, ordered and start at one', async () => {
  await expectExtractionError(
    extractVerifiedNativeText(
      extractor({
        async extract() {
          return {
            method: { kind: 'native_text', name: 'synthetic', version: '1.0.0' },
            pages: [{ physicalPageNumber: 2, text: 'out of order', elements: [] }],
          };
        },
      }),
      artifact
    ),
    'invalid_extraction_output'
  );
});

test('logical locators must be non-blank and unique within a page', async () => {
  await expectExtractionError(
    extractVerifiedNativeText(
      extractor({
        async extract() {
          return {
            method: { kind: 'native_text', name: 'synthetic', version: '1.0.0' },
            pages: [
              {
                physicalPageNumber: 1,
                text: 'synthetic',
                elements: [
                  { logicalLocator: 'page:1/block:1', kind: 'text_block', text: 'a' },
                  { logicalLocator: 'page:1/block:1', kind: 'text_block', text: 'b' },
                ],
              },
            ],
          };
        },
      }),
      artifact
    ),
    'invalid_extraction_output'
  );

  await expectExtractionError(
    extractVerifiedNativeText(
      extractor({
        async extract() {
          return {
            method: { kind: 'native_text', name: 'synthetic', version: '1.0.0' },
            pages: [
              {
                physicalPageNumber: 1,
                text: 'synthetic',
                elements: [{ logicalLocator: '   ', kind: 'text_block', text: 'a' }],
              },
            ],
          };
        },
      }),
      artifact
    ),
    'invalid_extraction_output'
  );
});

test('incomplete method identity fails closed', async () => {
  await expectExtractionError(
    extractVerifiedNativeText(
      extractor({
        async extract() {
          return {
            method: { kind: 'native_text', name: '', version: '1.0.0' },
            pages: [{ physicalPageNumber: 1, text: 'synthetic', elements: [] }],
          };
        },
      }),
      artifact
    ),
    'invalid_extraction_output'
  );
});

test('typed native failures are preserved and unknown parser errors are normalized', async () => {
  await expectExtractionError(
    extractVerifiedNativeText(
      extractor({
        async extract() {
          throw new NativeTextExtractionError(
            'native_text_unavailable',
            'synthetic native layer unavailable'
          );
        },
      }),
      artifact
    ),
    'native_text_unavailable'
  );

  await expectExtractionError(
    extractVerifiedNativeText(
      extractor({
        async extract() {
          throw new Error('parser-specific error must not escape the domain');
        },
      }),
      artifact
    ),
    'native_extractor_failed'
  );
});

test('shared native extraction boundary contains no parser, provider or OCR implementation', async () => {
  const sources = await Promise.all([
    readFile(new URL('../src/extraction/native-text-extractor.port.ts', import.meta.url), 'utf8'),
    readFile(new URL('../src/extraction/native-text-extractor.service.ts', import.meta.url), 'utf8'),
  ]);
  const forbidden = [
    '@supabase',
    'SupabaseClient',
    'pdfjs',
    'pdfplumber',
    'tesseract',
    'Textract',
    'GoogleDocumentAI',
    'signedUrl',
    'bucketName',
  ];

  for (const source of sources) {
    for (const token of forbidden) {
      assert.equal(source.includes(token), false, `implementation detail leaked: ${token}`);
    }
  }
});
