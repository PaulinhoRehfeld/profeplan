# AGENTS.md

## Cursor Cloud specific instructions

### Product overview

Profeplan is an educational planning platform (React/Vite frontend) for Brazilian public school teachers. The primary development target is the web app at `apps/web`. Python packages under `packages/` are offline batch pipelines and do not need to run for frontend development. The `rlm/` directory is a separate, unrelated research library.

### Running the frontend

See `README.md` "Quick Start" for standard commands. Key points:

- **Dev server**: `npm run dev` from the repo root (proxies to `apps/web`). Runs on port 3000 with `host: 0.0.0.0`.
- **Lint**: `npm run lint` — runs `tsc --noEmit` in `apps/web`. Pre-existing type errors exist (e.g., Zod v4/v3 resolver incompatibility, missing type assertions on Supabase RPC responses). These are not regressions.
- **Tests**: `npm run test` — runs `vitest run` in `apps/web`.
- **Build**: `npm run build` — runs `vite build` in `apps/web`.

### Environment variables

The root `.env` file contains `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`, `VITE_GEMINI_API_KEY`, and `VITE_STRIPE_PUBLISHABLE_KEY`. Copy it to `apps/web/.env` so Vite picks it up (the vite config uses `loadEnv(mode, '.', '')`). Add Azure OpenAI placeholders if the app fails to initialize:

```
VITE_AZURE_OPENAI_ENDPOINT=https://placeholder.openai.azure.com/
VITE_AZURE_OPENAI_API_KEY=placeholder_key
VITE_AZURE_OPENAI_DEPLOYMENT=gpt-4
```

### Gotchas

- The `package-lock.json` was generated on Windows. On Linux, npm may skip platform-specific optional dependencies (`@rollup/rollup-linux-x64-gnu`, `@tailwindcss/oxide-linux-x64-gnu`, `lightningcss-linux-x64-gnu`). These are now listed in root `package.json` dependencies to ensure they install on Linux.
- The backend is Supabase Cloud (no local Supabase needed). Auth and data depend on the remote Supabase instance.
- `@google/generative-ai` is used extensively in AI service files; it was added to `apps/web/package.json` dependencies.

### RLM library (separate product in `rlm/`)

Uses `uv` for Python package management. See `rlm/AGENTS.md` for full development instructions. Not required for Profeplan frontend development.
