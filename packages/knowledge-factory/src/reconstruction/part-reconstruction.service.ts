import type {
  CartographicNodeCandidate,
  CartographicPartScope,
  PartReconstructionCandidateSnapshot,
  PartReconstructionElementCandidate,
  PartReconstructionElementKind,
  PartReconstructionEvidenceRef,
  PartReconstructionRelationCandidate,
  PartReconstructionWarning,
  StructuralRecognitionSnapshot,
} from '@profeplan/types';
import type { VerifiedExtractionArtifactRead } from '../extraction/artifact-read.service.ts';
import type { NativeTextExtractedPage } from '../extraction/native-text-extractor.port.ts';
import type { DocumentInspectorPort } from '../cartography/document-inspector.port.ts';

const PART_RECONSTRUCTION_VERSION: PartReconstructionCandidateSnapshot['contractVersion'] = '1.0.0';

export interface PartReconstructionVocabulary {
  readonly activityHeadingPrefixes: readonly string[];
  readonly captionPrefixes: readonly string[];
  readonly teacherGuidanceMarkers: readonly string[];
}

export const DEFAULT_PART_RECONSTRUCTION_VOCABULARY: PartReconstructionVocabulary = {
  activityHeadingPrefixes: ['atividade'],
  captionPrefixes: ['legenda:'],
  teacherGuidanceMarkers: ['orientacao', 'orientacoes'],
};

export interface PartReconstructionRequest {
  readonly snapshotId: string;
  readonly artifact: VerifiedExtractionArtifactRead;
  readonly recognition: StructuralRecognitionSnapshot;
  readonly partScope: CartographicPartScope;
  readonly createdAt: string;
  readonly vocabulary?: PartReconstructionVocabulary;
}

function normalize(value: string): string {
  return value
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLocaleLowerCase('pt-BR')
    .replace(/\s+/g, ' ')
    .trim();
}

function startsWithAny(value: string, prefixes: readonly string[]): boolean {
  const normalized = normalize(value);
  return prefixes.some((prefix) => normalized.startsWith(normalize(prefix)));
}

function pageRef(page: NativeTextExtractedPage) {
  return {
    physicalPageNumber: page.physicalPageNumber,
    ...(page.printedPageLabel ? { printedPageLabel: page.printedPageLabel } : {}),
  };
}

function observedEvidence(
  evidenceId: string,
  page: NativeTextExtractedPage,
  logicalLocator: string,
  kind: PartReconstructionEvidenceRef['kind'] = 'native_text',
  cartographicNodeId?: string
): PartReconstructionEvidenceRef {
  return {
    evidenceId,
    kind,
    page: pageRef(page),
    logicalLocator,
    ...(cartographicNodeId ? { cartographicNodeId } : {}),
  };
}

function nodeByExactTitle(
  nodes: readonly CartographicNodeCandidate[],
  text: string
): CartographicNodeCandidate | undefined {
  const normalized = normalize(text);
  return nodes.find((node) => normalize(node.observedTitle) === normalized);
}

function nodesInsideScope(
  recognition: StructuralRecognitionSnapshot,
  partScope: CartographicPartScope
): readonly CartographicNodeCandidate[] {
  return recognition.nodes.filter((node) => {
    const start = node.pageRange?.startPhysicalPage;
    return (
      start !== undefined &&
      start >= partScope.pageRange.startPhysicalPage &&
      start <= partScope.pageRange.endPhysicalPage
    );
  });
}

function teacherManualRange(recognition: StructuralRecognitionSnapshot) {
  return recognition.regions.find((region) => region.kind === 'teacher_manual')?.pageRange;
}

function headingKindForNode(
  node: CartographicNodeCandidate,
  vocabulary: PartReconstructionVocabulary
): PartReconstructionElementKind {
  if (startsWithAny(node.observedTitle, vocabulary.activityHeadingPrefixes)) {
    return 'activity_heading';
  }
  if (node.kind === 'chapter') {
    return 'chapter_heading';
  }
  return 'section_heading';
}

export class PartReconstructionService {
  private readonly inspector: DocumentInspectorPort;

  constructor(inspector: DocumentInspectorPort) {
    this.inspector = inspector;
  }

  async reconstruct(
    request: PartReconstructionRequest
  ): Promise<PartReconstructionCandidateSnapshot> {
    const vocabulary = request.vocabulary ?? DEFAULT_PART_RECONSTRUCTION_VOCABULARY;
    const warnings: PartReconstructionWarning[] = [];
    const elements: PartReconstructionElementCandidate[] = [];
    const relations: PartReconstructionRelationCandidate[] = [];
    const scopedNodes = nodesInsideScope(request.recognition, request.partScope);
    const rootNode = request.partScope.rootNodeId
      ? request.recognition.nodes.find((node) => node.nodeId === request.partScope.rootNodeId)
      : undefined;

    const partInspection = await this.inspector.inspect({
      artifact: request.artifact,
      pageRanges: [request.partScope.pageRange],
    });

    let elementSequence = 0;
    let relationSequence = 0;
    let currentHeadingElementId: string | undefined;
    let currentActivityElementId: string | undefined;
    let partTitleElementId: string | undefined;
    const visualByPage = new Map<number, string[]>();
    const captionByPage = new Map<number, string[]>();

    const addElement = (
      kind: PartReconstructionElementKind,
      page: NativeTextExtractedPage,
      logicalLocator: string,
      text?: string,
      parentElementId?: string,
      cartographicNodeId?: string,
      confidence = 0.95
    ): PartReconstructionElementCandidate => {
      elementSequence += 1;
      const elementId = `part-element:${elementSequence}`;
      const element: PartReconstructionElementCandidate = {
        elementId,
        kind,
        page: pageRef(page),
        logicalLocator,
        ...(text ? { text } : {}),
        ...(parentElementId ? { parentElementId } : {}),
        evidence: [
          observedEvidence(
            `part-evidence:${elementSequence}`,
            page,
            logicalLocator,
            kind === 'visual_marker' ? 'observed_element' : 'native_text',
            cartographicNodeId
          ),
        ],
        confidence,
      };
      elements.push(element);
      return element;
    };

    const addRelation = (
      kind: PartReconstructionRelationCandidate['kind'],
      fromElementId: string,
      toElementId: string,
      evidence: readonly PartReconstructionEvidenceRef[],
      confidence = 0.95
    ) => {
      relationSequence += 1;
      relations.push({
        relationId: `part-relation:${relationSequence}`,
        kind,
        fromElementId,
        toElementId,
        evidence,
        confidence,
      });
    };

    for (const page of partInspection.pages) {
      for (const observed of page.elements) {
        if (observed.kind === 'image_marker') {
          const visual = addElement(
            'visual_marker',
            page,
            observed.logicalLocator,
            undefined,
            currentHeadingElementId ?? partTitleElementId,
            undefined,
            1
          );
          const pageVisuals = visualByPage.get(page.physicalPageNumber) ?? [];
          pageVisuals.push(visual.elementId);
          visualByPage.set(page.physicalPageNumber, pageVisuals);
          continue;
        }

        if (!observed.text?.trim()) {
          continue;
        }

        const matchingNode = nodeByExactTitle(scopedNodes, observed.text);
        if (matchingNode && matchingNode.nodeId === rootNode?.nodeId) {
          const partTitle = addElement(
            'part_title',
            page,
            observed.logicalLocator,
            observed.text,
            undefined,
            matchingNode.nodeId,
            0.99
          );
          partTitleElementId = partTitle.elementId;
          currentHeadingElementId = partTitle.elementId;
          currentActivityElementId = undefined;
          continue;
        }

        if (matchingNode) {
          const headingKind = headingKindForNode(matchingNode, vocabulary);
          const heading = addElement(
            headingKind,
            page,
            observed.logicalLocator,
            observed.text,
            partTitleElementId,
            matchingNode.nodeId,
            0.99
          );
          currentHeadingElementId = heading.elementId;
          currentActivityElementId =
            headingKind === 'activity_heading' ? heading.elementId : undefined;
          if (partTitleElementId) {
            addRelation('contains', partTitleElementId, heading.elementId, heading.evidence, 0.99);
          }
          continue;
        }

        if (startsWithAny(observed.text, vocabulary.captionPrefixes)) {
          const caption = addElement(
            'caption',
            page,
            observed.logicalLocator,
            observed.text,
            currentHeadingElementId ?? partTitleElementId,
            undefined,
            0.98
          );
          const pageCaptions = captionByPage.get(page.physicalPageNumber) ?? [];
          pageCaptions.push(caption.elementId);
          captionByPage.set(page.physicalPageNumber, pageCaptions);
          continue;
        }

        const body = addElement(
          currentActivityElementId ? 'activity_prompt' : 'body_text',
          page,
          observed.logicalLocator,
          observed.text,
          currentActivityElementId ?? currentHeadingElementId ?? partTitleElementId,
          undefined,
          0.94
        );
        const parent = currentActivityElementId ?? currentHeadingElementId ?? partTitleElementId;
        if (parent) {
          addRelation('contains', parent, body.elementId, body.evidence, 0.96);
        }
      }
    }

    for (const [physicalPageNumber, captions] of captionByPage) {
      const visuals = visualByPage.get(physicalPageNumber) ?? [];
      if (captions.length === 1 && visuals.length === 1) {
        const caption = elements.find((element) => element.elementId === captions[0]);
        if (caption) {
          addRelation('caption_for_visual', caption.elementId, visuals[0], caption.evidence, 0.96);
        }
      } else if (captions.length > 0 && visuals.length === 0) {
        warnings.push({
          warningId: `part-warning:caption-without-visual:${physicalPageNumber}`,
          code: 'caption_without_observed_visual',
          message: 'A caption was observed without a corresponding visual marker on the same page.',
          page: { physicalPageNumber },
        });
      }
    }

    const activityElements = elements.filter((element) => element.kind === 'activity_heading');
    const manualRange = teacherManualRange(request.recognition);
    if (activityElements.length > 0 && manualRange) {
      const manualInspection = await this.inspector.inspect({
        artifact: request.artifact,
        pageRanges: [manualRange],
      });

      for (const activity of activityElements) {
        const activityTitle = activity.text ?? '';
        let matchedGuidanceHeading: PartReconstructionElementCandidate | undefined;

        for (const page of manualInspection.pages) {
          for (const [index, observed] of page.elements.entries()) {
            if (!observed.text?.trim()) {
              continue;
            }
            const normalizedText = normalize(observed.text);
            const looksLikeGuidance =
              normalizedText.startsWith(normalize(activityTitle)) &&
              vocabulary.teacherGuidanceMarkers.some((marker) =>
                normalizedText.includes(normalize(marker))
              );
            if (!looksLikeGuidance) {
              continue;
            }

            matchedGuidanceHeading = addElement(
              'teacher_guidance_heading',
              page,
              observed.logicalLocator,
              observed.text,
              undefined,
              undefined,
              0.99
            );
            addRelation(
              'teacher_guidance_for_activity',
              matchedGuidanceHeading.elementId,
              activity.elementId,
              matchedGuidanceHeading.evidence,
              0.99
            );

            const following = page.elements
              .slice(index + 1)
              .find((candidate) => candidate.text?.trim());
            if (following?.text) {
              const guidanceText = addElement(
                'teacher_guidance_text',
                page,
                following.logicalLocator,
                following.text,
                matchedGuidanceHeading.elementId,
                undefined,
                0.96
              );
              addRelation(
                'contains',
                matchedGuidanceHeading.elementId,
                guidanceText.elementId,
                guidanceText.evidence,
                0.98
              );
            }
            break;
          }
          if (matchedGuidanceHeading) {
            break;
          }
        }

        if (!matchedGuidanceHeading) {
          warnings.push({
            warningId: `part-warning:teacher-guidance-not-found:${activity.elementId}`,
            code: 'teacher_guidance_not_found',
            message: `No teacher guidance was matched for activity "${activityTitle}".`,
            page: activity.page,
          });
        }
      }
    }

    if (!partTitleElementId) {
      warnings.push({
        warningId: 'part-warning:part-title-not-found',
        code: 'part_title_not_found',
        message: 'The scoped part title was not corroborated in the extracted body pages.',
      });
    }

    const inspectedPages = new Map<
      number,
      { physicalPageNumber: number; printedPageLabel?: string }
    >();
    for (const element of elements) {
      inspectedPages.set(element.page.physicalPageNumber, element.page);
    }

    return {
      contractVersion: PART_RECONSTRUCTION_VERSION,
      snapshotId: request.snapshotId,
      structuralRecognitionSnapshotId: request.recognition.snapshotId,
      sourceVersion: request.recognition.sourceVersion,
      artifactSha256: request.artifact.sha256,
      partScope: request.partScope,
      createdAt: request.createdAt,
      inspectedPages: [...inspectedPages.values()].sort(
        (left, right) => left.physicalPageNumber - right.physicalPageNumber
      ),
      elements,
      relations,
      warnings,
    };
  }
}
