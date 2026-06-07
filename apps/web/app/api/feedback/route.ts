import { logger } from '@profeplan/logger';
import * as fs from 'fs';
import * as path from 'path';
import { apiOk, ApiError, readJsonBody, withApiHandler } from '../_lib/http';
import { requireApiTenantContext } from '../_lib/tenant';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

function getWorkspaceRoot(): string {
  let dir = process.cwd();
  while (dir && dir !== path.parse(dir).root) {
    if (fs.existsSync(path.join(dir, 'pnpm-workspace.yaml'))) {
      return dir;
    }
    dir = path.dirname(dir);
  }
  return process.cwd();
}

function saveFeedback(feedbackEntry: {
  id: string;
  userEmail: string;
  userFullName: string;
  organizationName: string;
  rating: number;
  comment: string;
  createdAt: string;
}) {
  const workspaceRoot = getWorkspaceRoot();
  const logDir = path.join(workspaceRoot, 'logs');
  const feedbackFile = path.join(logDir, 'feedbacks.json');

  try {
    if (!fs.existsSync(logDir)) {
      fs.mkdirSync(logDir, { recursive: true });
    }

    let feedbacks = [];
    if (fs.existsSync(feedbackFile)) {
      const content = fs.readFileSync(feedbackFile, 'utf8');
      feedbacks = JSON.parse(content || '[]');
    }

    feedbacks.push(feedbackEntry);
    fs.writeFileSync(feedbackFile, JSON.stringify(feedbacks, null, 2), 'utf8');
  } catch (err) {
    logger.error('Failed to save feedback locally', err as Error);
  }
}

export const POST = withApiHandler(async (request: Request) => {
  const tenant = await requireApiTenantContext(request);
  const body = await readJsonBody(request);

  const rating = Number(body.rating);
  const comment = String(body.comment || '').trim();

  if (isNaN(rating) || rating < 1 || rating > 5) {
    throw new ApiError(
      400,
      'INVALID_RATING',
      'A nota de avaliação deve ser um número entre 1 e 5.'
    );
  }

  if (!comment) {
    throw new ApiError(400, 'COMMENT_REQUIRED', 'O comentário de feedback é obrigatório.');
  }

  const feedbackEntry = {
    id: crypto.randomUUID(),
    userEmail: tenant.user.email,
    userFullName: tenant.user.fullName,
    organizationName: tenant.organization.name,
    rating,
    comment,
    createdAt: new Date().toISOString(),
  };

  saveFeedback(feedbackEntry);

  logger.audit('FEEDBACK_SUBMISSION', tenant.user.email, {
    rating,
    comment,
  });

  return apiOk({ success: true, feedback: feedbackEntry });
});
