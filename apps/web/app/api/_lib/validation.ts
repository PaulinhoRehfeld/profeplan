import { ApiError } from './http';

export type CreateTermPlanInput = {
  title: string;
  year: number;
  term: number;
};

type ValidationIssue = {
  field: keyof CreateTermPlanInput;
  message: string;
};

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

export function validateCreateTermPlanInput(body: unknown): CreateTermPlanInput {
  if (!isRecord(body)) {
    throw new ApiError(400, 'VALIDATION_ERROR', 'Request body must be a JSON object.');
  }

  const issues: ValidationIssue[] = [];
  const { title, year, term } = body;
  const normalizedTitle = typeof title === 'string' ? title.trim() : '';

  if (normalizedTitle.length === 0) {
    issues.push({ field: 'title', message: 'title is required.' });
  }

  if (typeof year !== 'number' || !Number.isInteger(year)) {
    issues.push({ field: 'year', message: 'year is required and must be an integer.' });
  }

  if (typeof term !== 'number' || !Number.isInteger(term)) {
    issues.push({ field: 'term', message: 'term is required and must be an integer.' });
  }

  if (issues.length > 0) {
    throw new ApiError(400, 'VALIDATION_ERROR', 'Invalid request body.', { issues });
  }

  return {
    title: normalizedTitle,
    year: year as number,
    term: term as number,
  };
}
