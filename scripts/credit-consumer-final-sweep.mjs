import { readFileSync, readdirSync, statSync } from 'node:fs';
import { join, relative } from 'node:path';

const root = process.cwd();
const read = (path) => readFileSync(join(root, path), 'utf8');

const failures = [];
const evidence = [];

const requireText = (path, needle, description) => {
  const text = read(path);
  if (!text.includes(needle)) {
    failures.push(`${description}: ${path} does not contain ${JSON.stringify(needle)}`);
    return;
  }
  evidence.push(`PASS ${description}`);
};

const requireRegex = (path, pattern, description) => {
  const text = read(path);
  if (!pattern.test(text)) {
    failures.push(`${description}: ${path} does not satisfy ${pattern}`);
    return;
  }
  evidence.push(`PASS ${description}`);
};

const walk = (dir) => {
  const absolute = join(root, dir);
  return readdirSync(absolute).flatMap((name) => {
    const full = join(absolute, name);
    const rel = relative(root, full).replaceAll('\\', '/');
    if (statSync(full).isDirectory()) return walk(rel);
    return [rel];
  });
};

// ---------------------------------------------------------------------------
// Consumer authority: generation/chat may still call the compatibility helper,
// but with the global flag ON the helper must neither block nor mutate credits.
// ---------------------------------------------------------------------------
requireRegex(
  'apps/web/src/services/credits/quota.ts',
  /checkUsageQuota[\s\S]*?isGovernedCreditConsumerEnabled\(\)[\s\S]*?return true/,
  'governed quota check bypasses profiles.credits'
);
requireRegex(
  'apps/web/src/services/credits/quota.ts',
  /incrementUserUsage[\s\S]*?isGovernedCreditConsumerEnabled\(\)[\s\S]*?return/,
  'governed usage increment is a no-op'
);

// A coordinated global consumer cutover must imply the already-proven governed
// TermPlan save/mirror path. The historical pilot flag remains valid by itself.
requireText(
  'apps/web/src/services/credits/creditPilotFlags.ts',
  "import { isGovernedCreditConsumerEnabled } from './creditConsumerFlags';",
  'TermPlan cutover imports global consumer gate'
);
requireText(
  'apps/web/src/services/credits/creditPilotFlags.ts',
  "import.meta.env[GOVERNED_TERM_PLAN_SAVE_FLAG] === 'true' || isGovernedCreditConsumerEnabled()",
  'global consumer gate implies governed TermPlan save'
);
requireText(
  'apps/web/src/services/databaseService.ts',
  "isGovernedTermPlanSavePilotEnabled() && type === 'trimestral' && folder === 'TermPlans'",
  'TermPlan generated_contents mirror uses the coordinated gate'
);
requireText(
  'apps/web/src/features/TermPlanning/TermPlanningService.ts',
  'isGovernedTermPlanSavePilotEnabled()',
  'TermPlan canonical save uses the coordinated gate'
);

// ---------------------------------------------------------------------------
// Positive producer authority: once producer convergence is ON, active runtime
// recovery/admin paths must not mint a new profiles.credits integer.
// ---------------------------------------------------------------------------
requireText(
  'api/auth/admin-create-user.ts',
  'if (governedProducers && credits !== undefined)',
  'admin create-user rejects supplied legacy initial credits'
);
requireText(
  'api/auth/admin-create-user.ts',
  "...(governedProducers ? {} : { credits: legacyCredits })",
  'admin create-user omits profiles.credits in governed mode'
);
requireText(
  'apps/web/src/components/Admin/components/CreateUserModal.tsx',
  "...(governedCreditProducers ? {} : { credits })",
  'admin create-user UI omits legacy credit field from governed request'
);
requireText(
  'apps/web/src/hooks/useProfeplanAuth.ts',
  "...(governedCreditProducers ? {} : { credits: isAdminEmail ? 9999 : 10 })",
  'auth emergency profile creation omits legacy credits in governed mode'
);
requireText(
  'apps/web/src/services/profile/profileRepository.ts',
  "...(governedCreditProducers ? {} : { credits: userIsAdmin ? 9999 : 10 })",
  'profile repository emergency creation omits legacy credits in governed mode'
);
requireText(
  'apps/web/src/services/admin/adminProfiles.ts',
  'p_credits: governed ? null : (updates.credits ?? null)',
  'generic admin profile editing cannot change credits in governed mode'
);
requireText(
  'apps/web/src/services/referrals/referrals.ts',
  'if (isGovernedCreditProducerEnabled())',
  'referral/phone positive producers are gated to governed RPCs'
);

// ---------------------------------------------------------------------------
// Balance reads: governed UX must derive current balance from the ledger RPC and
// must not silently fall back to profiles.credits if that projection fails.
// ---------------------------------------------------------------------------
requireText(
  'apps/web/src/services/credits/creditBalance.ts',
  "supabase.rpc('credit_get_my_balance')",
  'current-user balance is derived server-side from the ledger'
);
requireText(
  'apps/web/src/components/Sidebar.tsx',
  'getMyGovernedCreditBalance()',
  'Sidebar uses governed balance when consumer cutover is ON'
);
requireText(
  'apps/web/src/components/Sidebar.tsx',
  "'Saldo indisponível'",
  'Sidebar fails closed instead of displaying legacy balance on governed read failure'
);
requireText(
  'apps/web/src/features/Planning/components/PlanningCockpit.tsx',
  'const balance = await getMyGovernedCreditBalance();',
  'low-credit warning reads the governed balance'
);

// ---------------------------------------------------------------------------
// Broad regression sentry: a direct read-modify-write decrement is allowed only
// inside the legacy compatibility helper. This does not ban legacy fallback
// code; it bans a second independent debit authority in active runtime code.
// ---------------------------------------------------------------------------
const activeFiles = [
  ...walk('apps/web/src'),
  ...walk('api'),
].filter((path) => /\.(?:ts|tsx)$/.test(path) && !path.includes('/__tests__/'));

const decrementPattern = /credits\s*:\s*Math\.max\(0\s*,[^\n;]*credits[^\n;]*-\s*1\)/g;
const directDecrements = [];
for (const path of activeFiles) {
  const text = read(path);
  if (decrementPattern.test(text)) directDecrements.push(path);
  decrementPattern.lastIndex = 0;
}

const allowedDecrement = 'apps/web/src/services/credits/quota.ts';
if (directDecrements.length !== 1 || directDecrements[0] !== allowedDecrement) {
  failures.push(
    `direct legacy debit authority changed: expected only ${allowedDecrement}; found ${directDecrements.join(', ') || 'none'}`
  );
} else {
  evidence.push('PASS direct decrement authority remains isolated to quota.ts legacy path');
}

console.log('1.3C.4E credit authority final sweep');
for (const line of evidence) console.log(line);

if (failures.length > 0) {
  console.error('\nFAILED invariants:');
  for (const failure of failures) console.error(`- ${failure}`);
  process.exit(1);
}

console.log(`\nPASS ${evidence.length} governed cutover invariants`);
