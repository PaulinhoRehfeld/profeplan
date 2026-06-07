import { existsSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';

const packageRoot = dirname(fileURLToPath(import.meta.url));
const envPath = resolve(packageRoot, '../.env');

if (existsSync(envPath)) {
  process.loadEnvFile(envPath);
}

const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
  throw new Error('DATABASE_URL is required to initialize PrismaClient.');
}

const adapter = new PrismaPg({ connectionString });

declare global {
  // eslint-disable-next-line no-var
  var __profeplan_prisma__: PrismaClient | undefined;
}

const prisma = globalThis.__profeplan_prisma__ ?? new PrismaClient({ adapter });

if (process.env.NODE_ENV !== 'production') {
  globalThis.__profeplan_prisma__ = prisma;
}

export default prisma;
