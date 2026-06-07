import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const workspaceRoot = resolve(dirname(fileURLToPath(import.meta.url)), '../..');

const nextConfig = {
  transpilePackages: ['@profeplan/auth', '@profeplan/db'],
  turbopack: {
    root: workspaceRoot,
  },
};

export default nextConfig;
