import { AsyncLocalStorage } from 'async_hooks';
import * as fs from 'fs';
import * as path from 'path';

export interface LogContext {
  correlationId: string;
  userEmail?: string;
  organizationId?: string;
  [key: string]: unknown;
}

const storage = new AsyncLocalStorage<LogContext>();

// Helper to locate the monorepo workspace root
function getWorkspaceRoot(): string {
  let dir = process.cwd();
  // Traverse up to find workspace root indicator
  while (dir && dir !== path.parse(dir).root) {
    if (fs.existsSync(path.join(dir, 'pnpm-workspace.yaml'))) {
      return dir;
    }
    dir = path.dirname(dir);
  }
  return process.cwd();
}

const workspaceRoot = getWorkspaceRoot();
const logDir = path.join(workspaceRoot, 'logs');
const logFile = path.join(logDir, 'app.log');

// Ensures log directory exists and writes log entry
function writeLogToFile(entry: string) {
  try {
    if (!fs.existsSync(logDir)) {
      fs.mkdirSync(logDir, { recursive: true });
    }
    fs.appendFileSync(logFile, entry + '\n', 'utf8');
  } catch {
    // Fail silently to avoid breaking the application execution
  }
}

export function runWithContext<T>(context: LogContext, fn: () => T): T {
  return storage.run(context, fn);
}

export function updateLoggerContext(updates: Partial<LogContext>): void {
  const store = storage.getStore();
  if (store) {
    Object.assign(store, updates);
  }
}

export function getLoggerContext(): LogContext | undefined {
  return storage.getStore();
}

export const logger = {
  info(message: string, meta?: unknown): void {
    const context = storage.getStore();
    const entry = JSON.stringify({
      timestamp: new Date().toISOString(),
      level: 'INFO',
      correlationId: context?.correlationId,
      message,
      ...(meta ? { meta } : {}),
      ...(context ? { context } : {}),
    });
    console.log(entry);
    writeLogToFile(entry);
  },

  warn(message: string, meta?: unknown): void {
    const context = storage.getStore();
    const entry = JSON.stringify({
      timestamp: new Date().toISOString(),
      level: 'WARN',
      correlationId: context?.correlationId,
      message,
      ...(meta ? { meta } : {}),
      ...(context ? { context } : {}),
    });
    console.warn(entry);
    writeLogToFile(entry);
  },

  error(message: string | Error, meta?: unknown): void {
    const context = storage.getStore();
    const isError = message instanceof Error;
    const msg = isError ? message.message : message;
    const stack = isError ? message.stack : undefined;
    const entry = JSON.stringify({
      timestamp: new Date().toISOString(),
      level: 'ERROR',
      correlationId: context?.correlationId,
      message: msg,
      stack,
      ...(meta ? { meta } : {}),
      ...(context ? { context } : {}),
    });
    console.error(entry);
    writeLogToFile(entry);
  },

  audit(action: string, actor: string, details?: unknown): void {
    const context = storage.getStore();
    const entry = JSON.stringify({
      timestamp: new Date().toISOString(),
      level: 'AUDIT',
      correlationId: context?.correlationId,
      action,
      actor,
      details,
      ...(context ? { context } : {}),
    });
    console.log(entry);
    writeLogToFile(entry);
  },

  runWithContext,
  updateLoggerContext,
  getContext: getLoggerContext,
};
