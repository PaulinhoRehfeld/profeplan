import {
  STRUCTURAL_RECOGNITION_CONTRACT_VERSION,
  type CartographicNodeCandidate,
  type CartographicNodeKind,
  type CartographicPartScope,
  type CartographicRegionCandidate,
  type CartographyEvidenceRef,
  type IngestionSourceVersionRef,
  type PhysicalPageRange,
  type StructuralRecognitionSnapshot,
  type StructuralRecognitionWarning,
} from '@profeplan/types';
import type { VerifiedExtractionArtifactRead } from '../extraction/artifact-read.service.ts';
import type { NativeTextExtractedPage } from '../extraction/native-text-extractor.port.ts';
import type { DocumentInspectionResult, DocumentInspectorPort } from './document-inspector.port.ts';
import { deriveFilenameHints, type FilenameHintRule } from './filename-hints.service.ts';

export interface StructuralRecognitionVocabulary {
  readonly tableOfContentsHeadings: readonly string[];
  readonly workOrganizationHeadings: readonly string[];
  readonly teacherManualHeadings: readonly string[];
  readonly referencesHeadings: readonly string[];
  readonly introductionHeadings: readonly string[];
  readonly unitPrefixes: readonly string[];
  readonly chapterPrefixes: readonly string[];
}

export const DEFAULT_STRUCTURAL_RECOGNITION_VOCABULARY: StructuralRecognitionVocabulary = {
  tableOfContentsHeadings: ['sumario', 'indice'],
  workOrganizationHeadings: ['conheca seu livro', 'organizacao da obra', 'como usar este livro'],
  teacherManualHeadings: ['orientacoes ao professor', 'manual do professor'],
  referencesHeadings: ['referencias'],
  introductionHeadings: ['introducao'],
  unitPrefixes: ['unidade'],
  chapterPrefixes: ['capitulo'],
};

export interface StructuralRecognitionRequest {
  readonly snapshotId: string;
  readonly sourceVersion: IngestionSourceVersionRef;
  readonly artifact: VerifiedExtractionArtifactRead;
  readonly createdAt: string;
  readonly filename?: string;
  readonly filenameHintRules?: readonly FilenameHintRule[];
  readonly vocabulary?: StructuralRecognitionVocabulary;
}

export interface StructuralRecognitionResult {
  readonly snapshot: StructuralRecognitionSnapshot;
  readonly nextPartScope?: CartographicPartScope;
}

interface ParsedTocEntry {
  readonly title: string;
  readonly declaredPrintedPageLabel: string;
  readonly page: NativeTextExtractedPage;
}

interface NodeDraft {
  readonly nodeId: string;
  readonly kind: CartographicNodeKind;
  readonly rank: number;
  readonly observedTitle: string;
  readonly parentNodeId?: string;
  readonly declaredPrintedPageLabel: string;
  readonly startPhysicalPage?: number;
  readonly evidence: readonly CartographyEvidenceRef[];
  readonly confidence: number;
}

function normalizeSearchText(value: string): string {
  return value
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLocaleLowerCase('pt-BR')
    .replace(/\s+/g, ' ')
    .trim();
}

function textMatchesHeading(value: string, headings: readonly string[]): boolean {
  const normalized = normalizeSearchText(value);
  return headings.some((heading) => normalized === normalizeSearchText(heading));
}

function pageContainsHeading(page: NativeTextExtractedPage, headings: readonly string[]): boolean {
  return page.elements.some(
    (element) => element.text && textMatchesHeading(element.text, headings)
  );
}

function compactPageRanges(physicalPages: readonly number[]): readonly PhysicalPageRange[] {
  if (physicalPages.length === 0) {
    return [];
  }

  const sorted = [...new Set(physicalPages)].sort((left, right) => left - right);
  const ranges: PhysicalPageRange[] = [];
  let start = sorted[0];
  let end = sorted[0];

  for (const page of sorted.slice(1)) {
    if (page === end + 1) {
      end = page;
      continue;
    }
    ranges.push({ startPhysicalPage: start, endPhysicalPage: end });
    start = page;
    end = page;
  }
  ranges.push({ startPhysicalPage: start, endPhysicalPage: end });
  return ranges;
}

function parseTocEntries(pages: readonly NativeTextExtractedPage[]): readonly ParsedTocEntry[] {
  const entries: ParsedTocEntry[] = [];
  const pattern = /^(.+?)\s*\.{2,}\s*([0-9ivxlcdm]+)\s*$/iu;

  for (const page of pages) {
    for (const element of page.elements) {
      if (!element.text) {
        continue;
      }
      const match = pattern.exec(element.text.trim());
      if (!match) {
        continue;
      }
      entries.push({
        title: match[1].trim(),
        declaredPrintedPageLabel: match[2].trim(),
        page,
      });
    }
  }

  return entries;
}

function nodeKindAndRank(
  title: string,
  vocabulary: StructuralRecognitionVocabulary
): { readonly kind: CartographicNodeKind; readonly rank: number } {
  const normalized = normalizeSearchText(title);
  if (vocabulary.introductionHeadings.some((heading) => normalized === normalizeSearchText(heading))) {
    return { kind: 'part', rank: 1 };
  }
  if (vocabulary.unitPrefixes.some((prefix) => normalized.startsWith(`${normalizeSearchText(prefix)} `))) {
    return { kind: 'unit', rank: 1 };
  }
  if (
    vocabulary.chapterPrefixes.some((prefix) =>
      normalized.startsWith(`${normalizeSearchText(prefix)} `)
    )
  ) {
    return { kind: 'chapter', rank: 2 };
  }
  return { kind: 'section', rank: 3 };
}

function pageRefEvidence(
  evidenceId: string,
  sourceKind: CartographyEvidenceRef['sourceKind'],
  page: NativeTextExtractedPage,
  logicalLocator?: string
): CartographyEvidenceRef {
  return {
    evidenceId,
    sourceKind,
    page: {
      physicalPageNumber: page.physicalPageNumber,
      ...(page.printedPageLabel ? { printedPageLabel: page.printedPageLabel } : {}),
    },
    ...(logicalLocator ? { logicalLocator } : {}),
  };
}

function tocNodeDrafts(
  entries: readonly ParsedTocEntry[],
  pageRefs: DocumentInspectionResult['pageRefs'],
  vocabulary: StructuralRecognitionVocabulary,
  teacherEntry: ParsedTocEntry | undefined
): readonly NodeDraft[] {
  const physicalByPrintedLabel = new Map(
    pageRefs
      .filter((page) => page.printedPageLabel)
      .map((page) => [page.printedPageLabel as string, page.physicalPageNumber])
  );

  const drafts: NodeDraft[] = [];
  let currentRootNodeId: string | undefined;
  let currentUnitNodeId: string | undefined;
  let currentChapterNodeId: string | undefined;

  for (const [index, entry] of entries.entries()) {
    if (entry === teacherEntry) {
      continue;
    }

    const { kind, rank } = nodeKindAndRank(entry.title, vocabulary);
    const nodeId = `cartographic-node:${drafts.length + 1}`;
    let parentNodeId: string | undefined;

    if (rank === 1) {
      currentRootNodeId = nodeId;
      currentUnitNodeId = kind === 'unit' ? nodeId : undefined;
      currentChapterNodeId = undefined;
    } else if (rank === 2) {
      parentNodeId = currentUnitNodeId ?? currentRootNodeId;
      currentChapterNodeId = nodeId;
    } else {
      parentNodeId = currentChapterNodeId ?? currentRootNodeId;
    }

    drafts.push({
      nodeId,
      kind,
      rank,
      observedTitle: entry.title,
      ...(parentNodeId ? { parentNodeId } : {}),
      declaredPrintedPageLabel: entry.declaredPrintedPageLabel,
      startPhysicalPage: physicalByPrintedLabel.get(entry.declaredPrintedPageLabel),
      evidence: [
        pageRefEvidence(
          `cartography-evidence:toc:${index + 1}`,
          'table_of_contents',
          entry.page
        ),
      ],
      confidence: 0.85,
    });
  }

  return drafts;
}

function finalizeNodes(
  drafts: readonly NodeDraft[],
  totalPhysicalPages: number,
  bodyPages: ReadonlyMap<number, NativeTextExtractedPage>
): readonly CartographicNodeCandidate[] {
  return drafts.map((draft, index) => {
    const nextBoundary = drafts
      .slice(index + 1)
      .find(
        (candidate) =>
          candidate.rank <= draft.rank && candidate.startPhysicalPage !== undefined
      );
    const endPhysicalPage = draft.startPhysicalPage
      ? (nextBoundary?.startPhysicalPage ?? totalPhysicalPages + 1) - 1
      : undefined;
    const bodyPage = draft.startPhysicalPage
      ? bodyPages.get(draft.startPhysicalPage)
      : undefined;
    const bodyHeadingMatched =
      bodyPage !== undefined &&
      bodyPage.elements.some(
        (element) =>
          element.text &&
          normalizeSearchText(element.text) === normalizeSearchText(draft.observedTitle)
      );
    const bodyEvidence = bodyHeadingMatched
      ? [
          pageRefEvidence(
            `cartography-evidence:body:${index + 1}`,
            'page_text',
            bodyPage as NativeTextExtractedPage
          ),
        ]
      : [];

    return {
      nodeId: draft.nodeId,
      kind: draft.kind,
      observedTitle: draft.observedTitle,
      ...(draft.parentNodeId ? { parentNodeId: draft.parentNodeId } : {}),
      ...(draft.startPhysicalPage && endPhysicalPage
        ? {
            pageRange: {
              startPhysicalPage: draft.startPhysicalPage,
              endPhysicalPage,
            },
          }
        : {}),
      declaredPrintedPageLabel: draft.declaredPrintedPageLabel,
      evidence: [...draft.evidence, ...bodyEvidence],
      confidence: bodyHeadingMatched ? 0.97 : draft.confidence,
      state: 'candidate' as const,
    };
  });
}

function firstMatchingPage(
  pages: Iterable<NativeTextExtractedPage>,
  headings: readonly string[]
): NativeTextExtractedPage | undefined {
  for (const page of pages) {
    if (pageContainsHeading(page, headings)) {
      return page;
    }
  }
  return undefined;
}

export class StructuralRecognitionService {
  constructor(private readonly inspector: DocumentInspectorPort) {}

  async recognize(request: StructuralRecognitionRequest): Promise<StructuralRecognitionResult> {
    const vocabulary = request.vocabulary ?? DEFAULT_STRUCTURAL_RECOGNITION_VOCABULARY;
    const observedPages = new Map<number, NativeTextExtractedPage>();
    let inspection = await this.inspector.inspect({
      artifact: request.artifact,
      pageRanges: [{ startPhysicalPage: 1, endPhysicalPage: 8 }],
    });
    for (const page of inspection.pages) {
      observedPages.set(page.physicalPageNumber, page);
    }

    let tocPage = firstMatchingPage(observedPages.values(), vocabulary.tableOfContentsHeadings);
    let inspectedThrough = Math.min(8, inspection.totalPhysicalPages);
    while (!tocPage && inspectedThrough < Math.min(20, inspection.totalPhysicalPages)) {
      const nextEnd = Math.min(inspectedThrough + 4, 20, inspection.totalPhysicalPages);
      inspection = await this.inspector.inspect({
        artifact: request.artifact,
        pageRanges: [
          {
            startPhysicalPage: inspectedThrough + 1,
            endPhysicalPage: nextEnd,
          },
        ],
      });
      for (const page of inspection.pages) {
        observedPages.set(page.physicalPageNumber, page);
      }
      inspectedThrough = nextEnd;
      tocPage = firstMatchingPage(observedPages.values(), vocabulary.tableOfContentsHeadings);
    }

    const tailStart = Math.max(1, inspection.totalPhysicalPages - 2);
    const tailInspection = await this.inspector.inspect({
      artifact: request.artifact,
      pageRanges: [
        {
          startPhysicalPage: tailStart,
          endPhysicalPage: inspection.totalPhysicalPages,
        },
      ],
    });
    for (const page of tailInspection.pages) {
      observedPages.set(page.physicalPageNumber, page);
    }

    const warnings: StructuralRecognitionWarning[] = [];
    const regions: CartographicRegionCandidate[] = [];
    const workOrganizationPage = firstMatchingPage(
      observedPages.values(),
      vocabulary.workOrganizationHeadings
    );
    if (workOrganizationPage) {
      regions.push({
        regionId: 'cartographic-region:work-organization',
        kind: 'work_organization',
        pageRange: {
          startPhysicalPage: workOrganizationPage.physicalPageNumber,
          endPhysicalPage: workOrganizationPage.physicalPageNumber,
        },
        evidence: [
          pageRefEvidence(
            'cartography-evidence:work-organization',
            'work_organization',
            workOrganizationPage
          ),
        ],
        confidence: 0.98,
      });
    } else {
      warnings.push({
        warningId: 'cartography-warning:work-organization-not-found',
        code: 'work_organization_not_found',
        message: 'No work-organization heading was observed in the inspected preliminary pages.',
      });
    }

    let entries: readonly ParsedTocEntry[] = [];
    if (tocPage) {
      const tocWindow = [...observedPages.values()].filter(
        (page) =>
          page.physicalPageNumber >= tocPage.physicalPageNumber &&
          page.physicalPageNumber <= tocPage.physicalPageNumber + 1
      );
      entries = parseTocEntries(tocWindow);
      regions.push({
        regionId: 'cartographic-region:table-of-contents',
        kind: 'table_of_contents',
        pageRange: {
          startPhysicalPage: tocPage.physicalPageNumber,
          endPhysicalPage: Math.min(
            tocPage.physicalPageNumber + (entries.length > 0 ? 0 : 1),
            inspection.totalPhysicalPages
          ),
        },
        evidence: [
          pageRefEvidence('cartography-evidence:toc-heading', 'table_of_contents', tocPage),
        ],
        confidence: entries.length > 0 ? 0.99 : 0.8,
      });
    } else {
      warnings.push({
        warningId: 'cartography-warning:toc-not-found',
        code: 'table_of_contents_not_found',
        message: 'No table-of-contents heading was observed within the preliminary inspection limit.',
      });
    }

    const teacherEntry = entries.find((entry) =>
      vocabulary.teacherManualHeadings.some((heading) =>
        normalizeSearchText(entry.title).includes(normalizeSearchText(heading))
      )
    );
    const referenceEntry = entries.find((entry) =>
      vocabulary.referencesHeadings.some((heading) =>
        normalizeSearchText(entry.title).includes(normalizeSearchText(heading))
      )
    );

    const drafts = tocNodeDrafts(entries, inspection.pageRefs, vocabulary, teacherEntry);
    const rootStarts = drafts
      .filter((draft) => draft.rank === 1 && draft.startPhysicalPage)
      .map((draft) => draft.startPhysicalPage as number);
    if (rootStarts.length > 0) {
      const bodyInspection = await this.inspector.inspect({
        artifact: request.artifact,
        pageRanges: rootStarts.map((physicalPageNumber) => ({
          startPhysicalPage: physicalPageNumber,
          endPhysicalPage: physicalPageNumber,
        })),
      });
      for (const page of bodyInspection.pages) {
        observedPages.set(page.physicalPageNumber, page);
      }
    }

    const nodes = finalizeNodes(drafts, inspection.totalPhysicalPages, observedPages);
    const introNode = nodes.find(
      (node) =>
        node.kind === 'part' &&
        vocabulary.introductionHeadings.some(
          (heading) => normalizeSearchText(node.observedTitle) === normalizeSearchText(heading)
        )
    );

    const physicalByPrintedLabel = new Map(
      inspection.pageRefs
        .filter((page) => page.printedPageLabel)
        .map((page) => [page.printedPageLabel as string, page.physicalPageNumber])
    );
    const teacherStart = teacherEntry
      ? physicalByPrintedLabel.get(teacherEntry.declaredPrintedPageLabel)
      : undefined;
    const referenceStart = referenceEntry
      ? physicalByPrintedLabel.get(referenceEntry.declaredPrintedPageLabel)
      : undefined;
    const observedTeacherPage = firstMatchingPage(
      observedPages.values(),
      vocabulary.teacherManualHeadings
    );
    const effectiveTeacherStart = teacherStart ?? observedTeacherPage?.physicalPageNumber;
    if (effectiveTeacherStart) {
      regions.push({
        regionId: 'cartographic-region:teacher-manual',
        kind: 'teacher_manual',
        pageRange: {
          startPhysicalPage: effectiveTeacherStart,
          endPhysicalPage: (referenceStart ?? inspection.totalPhysicalPages + 1) - 1,
        },
        evidence: observedTeacherPage
          ? [
              pageRefEvidence(
                'cartography-evidence:teacher-manual',
                'page_text',
                observedTeacherPage
              ),
            ]
          : tocPage
            ? [
                pageRefEvidence(
                  'cartography-evidence:teacher-manual-toc',
                  'table_of_contents',
                  tocPage
                ),
              ]
            : [],
        confidence: observedTeacherPage ? 0.98 : 0.82,
      });
    }

    if (referenceStart) {
      regions.push({
        regionId: 'cartographic-region:references',
        kind: 'references',
        pageRange: {
          startPhysicalPage: referenceStart,
          endPhysicalPage: inspection.totalPhysicalPages,
        },
        evidence: tocPage
          ? [
              pageRefEvidence(
                'cartography-evidence:references-toc',
                'table_of_contents',
                tocPage
              ),
            ]
          : [],
        confidence: 0.85,
      });
    }

    if (introNode?.pageRange) {
      regions.push({
        regionId: 'cartographic-region:main-content',
        kind: 'main_content',
        pageRange: {
          startPhysicalPage: introNode.pageRange.startPhysicalPage,
          endPhysicalPage: (effectiveTeacherStart ?? inspection.totalPhysicalPages + 1) - 1,
        },
        evidence: introNode.evidence,
        confidence: introNode.confidence,
      });
    } else {
      warnings.push({
        warningId: 'cartography-warning:introduction-not-delimited',
        code: 'introduction_not_delimited',
        message: 'The preliminary map did not delimit an Introduction part.',
      });
    }

    const snapshot: StructuralRecognitionSnapshot = {
      contractVersion: STRUCTURAL_RECOGNITION_CONTRACT_VERSION,
      snapshotId: request.snapshotId,
      sourceVersion: request.sourceVersion,
      artifactSha256: request.artifact.sha256,
      createdAt: request.createdAt,
      totalPhysicalPages: inspection.totalPhysicalPages,
      inspectedPageRanges: compactPageRanges([...observedPages.keys()]),
      filenameHints: deriveFilenameHints(request.filename, request.filenameHintRules ?? []),
      metadataObservations: [],
      regions,
      nodes,
      warnings,
    };

    return {
      snapshot,
      ...(introNode?.pageRange
        ? {
            nextPartScope: {
              scopeId: 'cartographic-scope:introduction',
              snapshotId: request.snapshotId,
              rootNodeId: introNode.nodeId,
              pageRange: introNode.pageRange,
              reason: 'table_of_contents_boundary',
              confidence: introNode.confidence,
            },
          }
        : {}),
    };
  }
}
