# Visão geral do frontend

## Escopo e método

Auditoria estática realizada sobre o repositório em 16/07/2026. Foram inspecionados configuração, rotas, layouts, páginas, componentes, estilos e testes. Nenhum arquivo funcional foi alterado e nenhum comando de build, teste ou lint foi executado nesta etapa, para evitar artefatos fora desta pasta.

## Arquitetura encontrada

- Monorepo gerenciado por **pnpm 11.5.2**, com workspaces em `apps/*`, `packages/*`, `services/*` e `infra/*`.
- Aplicação ativa: `apps/web`, React 19 + TypeScript 5.8 + Vite 6.
- Entrada ativa: `apps/web/index.html` → `apps/web/src/index.tsx` → `App.tsx` → `router/AppRouter.tsx`.
- Rotas: React Router 7 para URLs públicas/protegidas; dentro de `/app`, a troca de funcionalidades ocorre por estado Zustand (`ToolMode`), sem URL própria.
- Estado: Context para autenticação e planejamento; Zustand para interface; hooks e serviços por domínio.
- Estilos: Tailwind CSS 4 via plugin Vite, CSS global em `src/index.css` e muitos utilitários locais.
- UI: não há biblioteca de componentes completa; os elementos são construídos com Tailwind. Ícones: `lucide-react`.
- Formulários: HTML controlado, React Hook Form e Zod em partes do sistema.
- PWA/mobile: `vite-plugin-pwa` e Capacitor 8.
- Testes: Vitest, Testing Library e jsdom.

Há uma árvore histórica Next.js em `apps/web/app/`, acompanhada de `next.config.mjs` marcado como não utilizado. Ela possui outro design system em `app/globals.css`, mas não participa do build Vite atual. Deve ser tratada como legado até confirmação por telemetria/deploy.

## Estrutura relevante

| Pasta | Papel |
|---|---|
| `apps/web/src/pages` | páginas públicas, setup e gestão escolar |
| `apps/web/src/features` | domínios de planejamento, PDI, avaliações, documentos e simulados |
| `apps/web/src/components` | componentes compartilhados e módulos antigos de alto nível |
| `apps/web/src/layouts` | guards, shell, cabeçalho e composição principal |
| `apps/web/src/router` | rotas React Router |
| `apps/web/src/services` | dados, IA, Supabase, exportação e regras de aplicação |
| `apps/web/src/hooks`, `contexts`, `stores` | estado e ciclo de vida |
| `apps/web/public` | PWA, logos e bases estáticas |
| `apps/web/app` | frontend Next.js histórico/não ativo |

## Shell e padrões atuais

- `RootLayout`: autenticação, seleção de escola, bootstrap, offline e atualização PWA.
- `MainLayout`: sidebar responsiva, cabeçalho, conteúdo e modais globais.
- `Sidebar`: navegação agrupada em início, planejamento, conteúdo e gestão; largura expandida/recolhida; drawer em mobile.
- Cabeçalho: versão do produto, modo ativo, escola, nome e avatar textual.
- Mobile: sidebar em drawer de 85vw, safe areas e campos com 16 px; não há barra inferior.
- Modais: implementações locais; alguns têm semântica ARIA, outros não mostram padrão uniforme de foco.
- Cards/tabelas/loadings/vazios/erros: existem, mas são implementados por funcionalidade, sem primitives compartilhadas.
- Toasts: `ToastContext`; também há mensagens inline e modais, produzindo feedback inconsistente.

## Tipografia, cores e tokens

`Inter` é declarada, mas `src/index.css` não a importa; depende de disponibilidade externa/sistema. O corpo usa 11 px no desktop e 14 px no mobile. Predominam Slate, Blue, Emerald e Amber do Tailwind. Há cores hexadecimais e gradientes locais, sobretudo na landing page. Os únicos tokens globais ativos são safe areas; os tokens completos de `app/globals.css` pertencem à árvore Next inativa.

## Comandos corretos

Pré-requisito: Node 22.x (o ambiente auditado usa Node 24 e gera aviso de engine).

```bash
pnpm install
pnpm run dev
pnpm run build
pnpm run test
pnpm run lint
pnpm run typecheck
```

No workspace web: `pnpm --filter profeplan-engenharia-pedagogica-v4.0 dev|build|test|lint|typecheck`. `lint` e `typecheck` executam hoje o mesmo `tsc --noEmit`; não existe lint ESLint efetivo no pacote web.

## Avaliação inicial

O frontend tem boa cobertura funcional, lazy loading e organização parcial por domínio, mas sofre com navegação híbrida, escala tipográfica pequena, linguagem visual excessivamente enfática, ausência de primitives e componentes muito grandes. A base permite evolução incremental sem trocar React, Vite, Tailwind ou Lucide.
