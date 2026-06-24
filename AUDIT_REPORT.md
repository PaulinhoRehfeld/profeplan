# Relatório de Revisão — PROFEPLAN
**Data:** 2026-06-23  
**Revisão:** Auditoria completa de estrutura (frontend, BFF, banco de dados, build/config)

---

## Índice

1. [Erros Críticos](#erros-críticos)
   - [Frontend](#frontend---crítico)
   - [BFF](#bff---crítico)
   - [Banco de Dados / Migrations](#banco-de-dados--migrations---crítico)
   - [Build / Configuração](#build--configuração---crítico)
2. [Erros Altos](#erros-altos)
3. [Erros Médios / Menores](#erros-médios--menores)
4. [Resumo por Área](#resumo-por-área)

---

## Erros Críticos

### Frontend — Crítico

| Arquivo | Linha | Problema |
|---|---|---|
| `apps/web/src/hooks/useProfeplanAuth.ts` | ~130 | `\|\| true` força `isEmailConfirmed` sempre `true` — check de confirmação de e-mail nunca funciona |
| `apps/web/src/hooks/useProfeplanAuth.ts` | ~235 | Race condition: `useEffect([], [])` usa closures stale dos setters de estado |
| `apps/web/src/contexts/GlobalPlanningContext.tsx` | ~74 | Destructuring errado: `{ data: session }` deveria ser `{ data: { session } }` — acesso duplo `.session.session` |
| `apps/web/src/App.tsx` | — | `GlobalPlanningProvider` não envolve a app — qualquer `useGlobalPlanning()` vai lançar erro |

#### Detalhes

**`useProfeplanAuth.ts` linha ~130 — isEmailConfirmed sempre true**
```typescript
// ERRADO
isEmailConfirmed: !!(authSession.user?.email_confirmed_at || authSession.user?.confirmed_at || true)
// O `|| true` torna o check inútil.

// CORRETO
isEmailConfirmed: !!(authSession.user?.email_confirmed_at || authSession.user?.confirmed_at)
```

**`useProfeplanAuth.ts` linha ~235 — Race condition com listener de auth**
- `useEffect(..., [])` registra `onAuthStateChange` uma única vez no mount
- Setters como `setSession`, `setUserProfile`, `setLoading` ficam em closure stale
- Se atualizados fora do listener, a versão antiga é usada

**`GlobalPlanningContext.tsx` linha ~74 — Destructuring incorreto do Supabase**
```typescript
// ERRADO — session = { session: AuthSession | null }
const { data: session } = await supabase.auth.getSession();
if (session.session?.user) { ... }

// CORRETO — consistente com linha ~42 do mesmo arquivo
const { data: { session } } = await supabase.auth.getSession();
if (session?.user) { ... }
```

**`App.tsx` — Provider ausente**
```tsx
// ERRADO
<ProfeplanAuthProvider>
  <RouterProvider router={router} />
</ProfeplanAuthProvider>

// CORRETO
<ProfeplanAuthProvider>
  <GlobalPlanningProvider>
    <RouterProvider router={router} />
  </GlobalPlanningProvider>
</ProfeplanAuthProvider>
```

---

### BFF — Crítico

| Arquivo | Problema |
|---|---|
| `apps/bff/src/functions/pdiProxy.ts` | Dados de entrada do usuário inseridos diretamente em prompts sem sanitização (prompt injection) |
| `apps/bff/src/functions/pdiProxy.ts` | `JSON.parse()` sem try-catch no parser de resposta da IA — qualquer output não-JSON causa erro 500 |
| `apps/bff/src/functions/pdiProxy.ts` | Divisão por zero: `professor_nota_alcancada / professor_valor` sem checar `professor_valor === 0` |
| `apps/bff/host.json` | CORS não configurado — Azure Functions aceita qualquer origem |

#### Detalhes

**`pdiProxy.ts` — Prompt Injection**
- Campos como `studentName`, `originalContent`, `lessonContent` são concatenados diretamente em prompts
- Um usuário malicioso pode inserir `"IGNORE ALL PREVIOUS INSTRUCTIONS AND..."` em qualquer campo
- Impacto: modelo IA pode contornar guardrails, expor dados ou gerar conteúdo inapropriado

**`pdiProxy.ts` — JSON.parse sem try-catch**
```typescript
// ERRADO
const cleanedJson = extractJsonObjectFromText(sanitizedOutput);
responseBody = JSON.parse(cleanedJson); // SyntaxError se IA não retornar JSON válido

// CORRETO
try {
  responseBody = JSON.parse(cleanedJson);
} catch {
  responseBody = { raw: sanitizedOutput };
}
```

**`pdiProxy.ts` — Divisão por zero (linhas ~303, ~307, ~376, ~383)**
```typescript
// ERRADO
const percentual = ((av.professor_nota_alcancada / av.professor_valor) * 100).toFixed(0);
// Resulta em Infinity se professor_valor === 0

// CORRETO
const percentual = av.professor_valor > 0
  ? ((av.professor_nota_alcancada / av.professor_valor) * 100).toFixed(0)
  : '0';
```

**`host.json` — CORS aberto**
```json
// Adicionar em host.json:
"extensions": {
  "http": {
    "corsCredentials": false,
    "cors": {
      "allowedOrigins": ["https://profeplan.com.br"]
    }
  }
}
```

---

### Banco de Dados / Migrations — Crítico

| Problema | Detalhe |
|---|---|
| Tabelas `school_students`, `students`, `classes`, `lessons` | Referenciadas em FKs e RLS policies mas nunca criadas por nenhuma migration — execução do zero falha |
| Ordem errada nas migrations | `20260117_change_id_to_uuid.sql` tenta `ALTER TABLE curriculos_mg` antes de `20260118` que a cria |
| Migrations `01` e `02` | Tentam `ALTER TABLE students` e FK em `classes` que não existem |
| RLS em `pdi_documents` | Policy lê de `school_students` (inexistente) — todos os acessos ao PDI falham em runtime |

#### Detalhes

**Migrations 01 e 02 — tabelas base inexistentes**
```sql
-- 01_add_student_pdi_fields.sql
ALTER TABLE students  -- ← students nunca foi criada
ADD COLUMN IF NOT EXISTS needs_adaptation BOOLEAN DEFAULT false;

-- 02_create_pdi_logs_table.sql
student_id uuid references students(id) on delete cascade not null,  -- ← FK inválida
class_id uuid references classes(id) on delete cascade not null,     -- ← FK inválida
lesson_id uuid references lessons(id) on delete set null             -- ← FK inválida
```

**`20260124_create_pdi_documents.sql` — RLS policy quebrada**
```sql
-- Policy tenta referenciar tabela que não existe:
student_id IN (
  SELECT ss.id FROM school_students ss  -- ← tabela inexistente
  WHERE ss.school_id IN (...)
)
```

**Ordem de migrations quebrada**
```
20260117_change_id_to_uuid.sql    → ALTER TABLE curriculos_mg  (tabela não existe ainda)
20260118_create_curriculos_mg_table.sql → CREATE TABLE curriculos_mg
```

---

### Build / Configuração — Crítico

| Arquivo | Problema |
|---|---|
| `tsconfig.base.json` | Aliases `@profeplan/ui` e `@profeplan/config` apontam para packages que não existem — qualquer import quebra |
| `package.json` (raiz) | Scripts usam `npm run` em projeto pnpm — todos os scripts de root falham |
| `.eslintrc.cjs` | Plugins eslint referenciados mas não listados em `devDependencies` — lint sempre falha |

#### Detalhes

**`tsconfig.base.json` — path aliases para packages inexistentes**
```json
// INVÁLIDO — packages não existem no filesystem
"@profeplan/ui": ["packages/ui/src"],
"@profeplan/config": ["packages/config/src"]
```
Packages que realmente existem: `types`, `auth`, `db`, `ai`, `logger`, `graphics-profeplan`, `industry-curriculum`, `industry-pnld`.

**`package.json` raiz — scripts com npm em projeto pnpm**
```json
// ERRADO
"dev": "npm run dev --workspace=apps/web",
"build": "npm run build --workspaces --if-present"

// CORRETO
"dev": "pnpm --filter profeplan-engenharia-pedagogica-v4.0 dev",
"build": "pnpm -r build"
```

---

## Erros Altos

| Área | Arquivo | Problema |
|---|---|---|
| Frontend | `useProfeplanAuth.ts` ~167 | Memory leak: listener de auth não verifica flag `cancelled` após unmount |
| Frontend | `useAppBootstrap.ts` ~72 | Timer async sem flag de cancelamento — tenta atualizar estado de componente desmontado |
| BFF | `secrets.ts` | Cache de secrets sem expiração — rotação de chaves no Azure Key Vault não é refletida |
| BFF | `searchProxy.ts` ~63 | Fallback silencioso de `SERVICE_ROLE_KEY` para `ANON_KEY` — falha sem aviso claro |
| Migrations | `20260209_create_subject_aliases.sql` + `20260209_subject_aliases.sql` | Tabela `subject_aliases` criada duas vezes na mesma data — potencial conflito |
| Migrations | `curriculos_mg` vs `curriculo_mg` | Naming inconsistente entre migrations — tabelas diferentes com dados duplicados |
| Migrations | `handle_new_user` trigger | 3 versões conflitantes; última define `tier = GOLD` sobrescrevendo a que define `tier = FREE` |
| Config | `packages/auth/package.json` | Supabase `^2.106.2` vs `^2.45.4` nos demais — gap de 61 minor versions |
| Config | `packages/ai/package.json` | OpenAI `^4.104.0` vs `^4.77.0` no BFF — gap de 27 minor versions |
| Config | `apps/web/next.config.mjs` | Arquivo Next.js num projeto Vite — não tem efeito algum e gera confusão |
| Config | `pnpm-workspace.yaml` vs `package.json` raiz | `services/*` e `infra/*` estão no workspace pnpm mas ausentes do `workspaces` do package.json raiz |

#### Detalhes selecionados

**`useProfeplanAuth.ts` ~167 — Memory leak no listener**
```typescript
// CORRETO — adicionar flag de cancelamento
useEffect(() => {
  let cancelled = false;
  const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, authSession) => {
    if (cancelled) return;
    // ...
  });
  return () => {
    cancelled = true;
    subscription.unsubscribe();
  };
}, []);
```

**`secrets.ts` — Cache sem TTL**
```typescript
// ERRADO — sem expiração
const secretsCache: Record<string, string> = {};

// CORRETO — adicionar timestamp de expiração
const secretsCache: Record<string, { value: string; expiresAt: number }> = {};
const CACHE_TTL_MS = 5 * 60 * 1000; // 5 minutos
```

**Trigger `handle_new_user` conflitante**
- `20260221_default_gold_new_users.sql` define `tier = 'GOLD', credits = 9999`
- `20260616_fix_admin_and_default_credits.sql` redefine para `tier = 'FREE', credits = 10`
- `20260616_fix_profile_sync_trigger.sql` volta para `tier = 'GOLD', credits = 9999`
- Resultado: comportamento depende estritamente da ordem de execução das migrations

---

## Erros Médios / Menores

| Área | Arquivo | Linha | Problema |
|---|---|---|---|
| Frontend | `AppRouter.tsx` | ~51 | `AdminGuard` retorna `null` durante loading — tela branca sem feedback visual |
| Frontend | `AppRouter.tsx` | ~21 | Lazy components sem `<Suspense>` — blank screen em chunks lentos |
| Frontend | `App.tsx` | — | Sem `<ErrorBoundary>` global |
| Frontend | `useProfeplanAuth.ts` | ~68 | Ghost ID healing atualiza PK da tabela `profiles` — pode quebrar referências estrangeiras |
| Frontend | `useProfeplanAuth.ts` | ~120/243 | Lógica de `deriveRole()` duplicada em `handleLogin` e `refreshProfile` — risco de divergência |
| BFF | `privacy.ts` | ~29 | Regex `\b\d{7,8}\b` redacta qualquer número de 7-8 dígitos, não apenas MASP/INEP |
| BFF | `pdiProxy.ts` | — | Dados PII enviados à IA antes da redação local — potencial violação de LGPD |
| BFF | `searchProxy.ts` | ~74 | Se `profile.allowed_features` não existir, busca semântica silenciosamente vira busca textual |
| BFF | Múltiplos | — | Uso excessivo de `as any` desativa type checking — erros em runtime não detectados |
| Config | `capacitor.config.ts` | — | `cleartext: true` em Android — falha de segurança em builds mobile |
| Config | `package.json` raiz | — | `dependencies` com supabase, openai, csv-parser, dotenv no root — deve estar nos packages que as usam |
| Config | `apps/web/tsconfig.json` | — | `target: ES2022` enquanto base é `ES2024` |
| Config | `apps/web/package.json` | — | `@types/node` listado como `dependency` em vez de `devDependency` — aumenta bundle de produção |
| Config | `vercel.json` | — | Nome de filtro muito longo e frágil — se mudar o `name` do package, deploy quebra |
| Migrations | `20260124_import_schools_mg*.sql` | — | 4 arquivos de import de schools na mesma data sem ordem definida |
| Migrations | `pending_teachers` | ~18/21 | FKs `matched_profile_id` e `created_by` sem índice — queries lentas |
| Migrations | `referrals` | ~7 | FK `referrer_id` sem índice — sequential scans em produção |

---

## Resumo por Área

| Área | Críticos | Altos | Médios | Total |
|---|---|---|---|---|
| Frontend (hooks / contextos) | 4 | 2 | 5 | **11** |
| BFF (segurança / lógica) | 4 | 2 | 5 | **11** |
| Banco de Dados / Migrations | 4 | 3 | 5 | **12** |
| Build / Configuração | 3 | 4 | 5 | **12** |
| **Total** | **15** | **11** | **20** | **46** |

---

## Priorização de Ataque

### Fase 1 — Bloqueantes (corrigir antes de qualquer deploy)
1. `App.tsx` — adicionar `GlobalPlanningProvider`
2. `GlobalPlanningContext.tsx` ~74 — corrigir destructuring do Supabase
3. `useProfeplanAuth.ts` ~130 — remover `|| true` de `isEmailConfirmed`
4. Migrations — criar migrations base para `students`, `classes`, `lessons`, `school_students`
5. `tsconfig.base.json` — remover aliases de packages inexistentes (`ui`, `config`)
6. `package.json` raiz — trocar `npm run` por `pnpm`

### Fase 2 — Segurança (corrigir antes de ir para produção)
1. `pdiProxy.ts` — sanitizar inputs antes de inserir em prompts
2. `pdiProxy.ts` — try-catch no `JSON.parse`
3. `pdiProxy.ts` — guard contra divisão por zero
4. `host.json` — configurar CORS com origens permitidas
5. `secrets.ts` — adicionar TTL ao cache de secrets

### Fase 3 — Qualidade (corrigir em ciclo normal)
1. Unificar versões de Supabase e OpenAI entre packages
2. Remover `next.config.mjs` do apps/web
3. Resolver conflito de trigger `handle_new_user`
4. Consolidar `curriculos_mg` vs `curriculo_mg`
5. Memory leaks em hooks (`useProfeplanAuth`, `useAppBootstrap`)
6. Adicionar `<Suspense>` e `<ErrorBoundary>` na árvore de componentes
7. Adicionar índices faltantes em FKs (`pending_teachers`, `referrals`)
