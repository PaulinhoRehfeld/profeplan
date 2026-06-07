import { logger } from '@profeplan/logger';
import { apiOk, ApiError, readJsonBody, withApiHandler } from '../../_lib/http';
import { requireApiTenantContext } from '../../_lib/tenant';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

export const POST = withApiHandler(async (request: Request) => {
  const body = await readJsonBody(request);
  const { event } = body;

  if (event === 'login') {
    // Verify user is authenticated to get their tenant details
    const tenant = await requireApiTenantContext(request);
    logger.audit('LOGIN', tenant.user.email, {
      success: true,
      userId: tenant.user.id,
      organizationId: tenant.organization.id,
    });
    return apiOk({ success: true });
  } else if (event === 'logout') {
    // Try to get user identity before logging them out
    try {
      const tenant = await requireApiTenantContext(request);
      logger.audit('LOGOUT', tenant.user.email, {
        success: true,
        userId: tenant.user.id,
        organizationId: tenant.organization.id,
      });
    } catch {
      // Fallback if token is already expired/cleared
      logger.audit('LOGOUT', 'unknown', {
        success: true,
        details: 'Session context could not be retrieved during logout',
      });
    }
    return apiOk({ success: true });
  }

  throw new ApiError(400, 'INVALID_EVENT', 'Invalid auth event type');
});
