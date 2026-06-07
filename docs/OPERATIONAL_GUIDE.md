# Guia Operacional de CI/CD: PROFEPLAN V2

Este documento descreve a infraestrutura de ambientes, segredos, procedimentos de deploy, rollback e diagnóstico operacional do **PROFEPLAN V2**.

---

## 🌐 1. Definição de Ambientes

O PROFEPLAN V2 opera com três ambientes isolados para garantir estabilidade e testes contínuos sem impactar usuários reais.

| Ambiente       | Host / URL                                           | Finalidade                                                      | Banco de Dados                                |
| :------------- | :--------------------------------------------------- | :-------------------------------------------------------------- | :-------------------------------------------- |
| **Local**      | `http://localhost:3000`                              | Desenvolvimento de features e correção de bugs.                 | Banco local ou container PostgreSQL de teste. |
| **Staging**    | _Preview da Vercel_ (ex: `staging.profeplan.com.br`) | Testes de aceitação (QA) e integração de novas funcionalidades. | Supabase Sandbox / Schema isolado de staging. |
| **Production** | `https://www.profeplan.com.br`                       | Versão pública e funcional utilizada pelos usuários.            | Supabase Production (Altamente protegido).    |

---

## 🔑 2. Gerenciamento de Secrets (Segredos)

Todas as chaves secretas e credenciais críticas devem ser adicionadas como variáveis de ambiente em seus respectivos ambientes (no GitHub Secrets e no console da Vercel).

### Lista de Secrets Requeridas

| Nome da Secret                  | Escopo          | Descrição                                                                 |
| :------------------------------ | :-------------- | :------------------------------------------------------------------------ |
| `DATABASE_URL`                  | GitHub / Vercel | String de conexão direta ou Pooler do PostgreSQL (Supabase).              |
| `NEXT_PUBLIC_SUPABASE_URL`      | Vercel          | URL pública do projeto Supabase para autenticação.                        |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Vercel          | Chave pública anônima do Supabase.                                        |
| `SUPABASE_SERVICE_ROLE_KEY`     | Vercel          | Chave privada administrativa para bypass de RLS (usada em seeds/scripts). |
| `OPENAI_API_KEY`                | Vercel / GitHub | Token de autorização para chamadas de IA.                                 |
| `OPENAI_MODEL`                  | Vercel          | Modelo a ser utilizado pela IA (`gpt-4o-mini`, etc.).                     |
| `VERCEL_TOKEN`                  | GitHub Secrets  | Token administrativo da Vercel para acionar deploy via CLI.               |
| `VERCEL_ORG_ID`                 | GitHub Secrets  | ID da organização Vercel associada ao projeto.                            |
| `VERCEL_PROJECT_ID`             | GitHub Secrets  | ID do projeto Vercel associado ao PROFEPLAN V2.                           |

---

## 🚀 3. Procedimentos de Deploy e Migração

### A. Deploy Automatizado via CI/CD

Toda modificação aprovada que for integrada aos branches principais aciona a pipeline:

1. **Branch `develop`**: Executa o workflow de CI (testes e build estático) e, caso passe, aciona o CD de **Staging** (roda migrações de banco staging e deploy preview na Vercel).
2. **Branch `main`**: Executa o workflow de CI e, caso passe, executa o CD de **Produção** (aplica migrações de banco produção e publica em produção na Vercel).

### B. Migrações Prisma

As migrações nunca são rodadas de forma interativa em produção.

- Na pipeline, o job de CD executa:
  ```bash
  pnpm --filter @profeplan/db prisma:deploy
  ```
  Este comando executa a aplicação exclusiva das migrações pendentes (`prisma migrate deploy`) sem risco de limpar dados (diferente de `migrate dev`).

---

## ⏪ 4. Procedimentos de Rollback (Reversão)

Em caso de bugs críticos detectados em produção, siga os procedimentos abaixo imediatamente.

### A. Reversão de Código (Frontend / API Next.js)

1. **Pelo Dashboard da Vercel**:
   - Acesse o projeto na Vercel.
   - Vá em **Deployments**.
   - Identifique o último deploy estável (anterior ao problemático).
   - Clique nos três pontos (`...`) e selecione **Promote to Production**.
   - Isso reverte a versão pública em segundos, sem necessidade de re-compilar código.
2. **Via Git/GitHub**:
   - Crie um pull request revertendo o commit causador do erro:
     ```bash
     git revert <commit_id>
     git push origin main
     ```
   - O GitHub Actions recompilará e fará o deploy automático da versão corrigida.

### B. Reversão de Banco de Dados (Migrations)

O Prisma não possui rollback automático nativo para migrações já aplicadas com `migrate deploy`. Se uma migração danosa foi executada:

1. **Mitigação rápida**: Suba um hotfix de código que contorne a tabela/campo problemático.
2. **Correção via SQL**: Execute scripts manuais de migração reversa (`ALTER TABLE ...`) via console do Supabase para restaurar a integridade dos dados se necessário.
3. **Mark Migration Resolve**: Caso a migração tenha falhado no meio do caminho e travado o banco, use o comando Prisma para marcar o estado como resolvido/revertido no histórico:
   ```bash
   npx prisma migrate resolve --rolled-back <migration_name>
   ```

---

## 🛠️ 5. Troubleshooting (Resolução de Problemas)

### 1. Falha de Heap Limit / Out of Memory no Build ou Dev Server

- **Problema**: O compilador do Next.js/Turbopack estoura o limite de memória do Node.
- **Solução**: Configure a variável de ambiente do Node para aumentar o limite padrão de heap em ambientes locais ou de pipeline:
  ```bash
  $env:NODE_OPTIONS="--max-old-space-size=4096"
  ```

### 2. A Pipeline de CD falhou no job `db-migrations`

- **Problema**: O Prisma não conseguiu conectar ao banco Supabase.
- **Causa**: IP bloqueado por firewalls ou string `DATABASE_URL` incorreta/expirada.
- **Solução**: Verifique se a string de conexão está usando a porta correta (`6543` para connection pooling ou `5432` direta) e confirme as credenciais no painel do Supabase.

### 3. Conflitos de Typescript no Build da Pipeline

- **Problema**: O build do Next.js falha acusando inconsistências de tipagem TypeScript.
- **Solução**: Rode localmente `pnpm typecheck` para identificar onde as definições estão dessincronizadas antes de enviar o commit.
