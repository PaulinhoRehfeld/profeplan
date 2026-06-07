import { prisma } from '@profeplan/db';
import { apiOk, ApiError, withApiHandler } from '../_lib/http';

export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';

export const GET = withApiHandler(async () => {
  try {
    // Perform a quick raw query to verify database connection
    await prisma.$queryRaw`SELECT 1`;

    return apiOk({
      status: 'healthy',
      timestamp: new Date().toISOString(),
      services: {
        database: 'up',
      },
    });
  } catch (error) {
    throw new ApiError(503, 'SERVICE_UNAVAILABLE', 'Database connection failed', {
      error: (error as Error).message,
    });
  }
});
