import type { FilenameHint, FilenameHintKind } from '@profeplan/types';

export interface FilenameHintRule {
  readonly token: string;
  readonly kind: FilenameHintKind;
  readonly interpretedValue: string;
  readonly confidence: number;
}

function tokenizeFilename(filename: string): readonly string[] {
  const basename = filename.replace(/^.*[\\/]/, '').replace(/\.[^.]+$/, '');
  return basename
    .split(/[\s_.()\-]+/u)
    .map((token) => token.trim())
    .filter(Boolean);
}

/**
 * Deterministic baseline for filename hints. Rules are injected because naming
 * conventions belong to a collection/provider context, not to universal domain
 * truth. Returned hints remain non-canonical by contract.
 */
export function deriveFilenameHints(
  filename: string | undefined,
  rules: readonly FilenameHintRule[]
): readonly FilenameHint[] {
  if (!filename?.trim()) {
    return [];
  }

  const tokens = tokenizeFilename(filename);
  const hints: FilenameHint[] = [];

  for (const [ruleIndex, rule] of rules.entries()) {
    const rawToken = tokens.find(
      (token) => token.localeCompare(rule.token, undefined, { sensitivity: 'accent' }) === 0
    );
    if (!rawToken) {
      continue;
    }

    hints.push({
      hintId: `filename-hint:${ruleIndex + 1}`,
      kind: rule.kind,
      rawToken,
      interpretedValue: rule.interpretedValue,
      confidence: rule.confidence,
    });
  }

  return hints;
}
