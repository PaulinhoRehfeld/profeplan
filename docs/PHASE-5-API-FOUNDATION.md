# PHASE-5-API-FOUNDATION

Primeira camada oficial de APIs do PROFEPLAN V2, integrada com Auth,
Membership, Organization, Prisma e PostgreSQL Supabase.

## Objetivo

Implementar o primeiro recurso de negocio tenant-scoped: `TermPlan`.

Fluxo base:

```text
Supabase Auth
-> User local
-> Membership
-> Organization
-> TermPlan[]
```

## Estrutura de API

Base reutilizavel criada em `apps/web/app/api/_lib`:

- `http.ts`: resposta JSON padronizada, `ApiError`, tratamento central de erros,
  leitura segura de JSON e wrapper `withApiHandler`.
- `tenant.ts`: auth guard para APIs, aceitando sessao via cookie Supabase SSR ou
  `Authorization: Bearer <access_token>`, e resolvendo User, Membership e
  Organization.
- `validation.ts`: validacao manual do payload de criacao de `TermPlan`.

Formato de sucesso:

```json
{
  "data": {}
}
```

Formato de erro:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request body.",
    "details": {
      "issues": []
    }
  }
}
```

## Tenant resolution

O tenant atual e resolvido somente pelo usuario autenticado:

1. Validar usuario Supabase por cookie ou Bearer token.
2. Buscar `User` local por e-mail autenticado.
3. Buscar primeira `Membership` por `createdAt asc`.
4. Usar a `Organization` dessa membership como tenant atual.

`organizationId` e `ownerId` nunca sao aceitos do payload da rota. Esses campos
sao definidos exclusivamente pelo contexto autenticado.

## Modelo TermPlan

Contrato Phase 5:

```ts
type TermPlan = {
  id: string;
  organizationId: string;
  ownerId: string;
  title: string;
  year: number;
  term: number;
  status: 'DRAFT' | 'REVIEW' | 'PUBLISHED';
  createdAt: string;
  updatedAt: string;
};
```

Migration aplicada:

```text
packages/db/prisma/migrations/20260601100000_phase_5_term_plan_api/migration.sql
```

## Endpoints

### GET /api/planning/terms

Regras:

- Requer usuario autenticado.
- Requer User local com Membership.
- Retorna apenas `TermPlan` da Organization resolvida.
- Toda consulta Prisma filtra por `organizationId`.

Response 200:

```json
{
  "data": {
    "termPlans": [
      {
        "id": "term_plan_id",
        "organizationId": "organization_id",
        "ownerId": "user_id",
        "title": "1o Bimestre 2026",
        "year": 2026,
        "term": 1,
        "status": "DRAFT",
        "createdAt": "2026-06-01T00:00:00.000Z",
        "updatedAt": "2026-06-01T00:00:00.000Z"
      }
    ]
  }
}
```

### POST /api/planning/terms

Payload minimo:

```json
{
  "title": "1o Bimestre 2026",
  "year": 2026,
  "term": 1
}
```

Regras:

- Requer usuario autenticado.
- Requer User local com Membership.
- `ownerId` recebe o id do User local.
- `organizationId` recebe o id da Organization resolvida.
- `organizationId` e `ownerId` enviados no payload sao ignorados.

Response 201:

```json
{
  "data": {
    "termPlan": {
      "id": "term_plan_id",
      "organizationId": "organization_id",
      "ownerId": "user_id",
      "title": "1o Bimestre 2026",
      "year": 2026,
      "term": 1,
      "status": "DRAFT",
      "createdAt": "2026-06-01T00:00:00.000Z",
      "updatedAt": "2026-06-01T00:00:00.000Z"
    }
  }
}
```

## Validation

Campos obrigatorios:

- `title`: string nao vazia.
- `year`: inteiro.
- `term`: inteiro.

Exemplo de erro:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request body.",
    "details": {
      "issues": [
        {
          "field": "title",
          "message": "title is required."
        }
      ]
    }
  }
}
```

## Security notes

- `GET` usa `where: { organizationId: tenant.organization.id }`.
- `POST` usa `organizationId: tenant.organization.id`.
- `POST` usa `ownerId: tenant.user.id`.
- Nao existe leitura de tenant por URL ou payload.
- API retorna apenas campos selecionados de `TermPlan`.

## Evidencias

Executado em 2026-06-01:

```text
Prisma validate: OK
Prisma generate: OK
Prisma migrate deploy: OK
Next build: OK
Route map: /api/planning/terms dynamic
Auth guard sem sessao: HTTP/1.1 401 Unauthorized, code UNAUTHENTICATED
Prisma tenant isolation: scoped query returned 1, included Org A plan, excluded Org B plan
```

Tentativa de fluxo completo com usuario novo Supabase:

```text
Supabase Auth signUp: usuario criado
Supabase signInWithPassword: bloqueado por email_not_confirmed
```

Para executar o teste HTTP completo de `POST -> GET` com Auth real, e necessario
usar um usuario Supabase ja confirmado ou uma credencial/service role de teste
que permita criar usuario confirmado.
