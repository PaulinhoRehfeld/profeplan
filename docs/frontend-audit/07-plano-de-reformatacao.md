# Plano de reformatação

## Fase 0 — segurança e preparação

- **Arquivos:** configs e testes somente para leitura; documentação; snapshots futuros.
- **Objetivo:** baseline de build/test/typecheck, inventário visual em 320/375/768/1024/1440, contratos de auth/escola/plano.
- **Dependências:** Node 22, ambiente de teste sem dados reais.
- **Riscos:** escrever em produção ou confundir árvore Next histórica com app ativo.
- **Validação:** build, testes, typecheck, smoke de rotas e registro de telas.
- **Esforço:** médio. Branch já existente: `auditoria-redesign-frontend`.

## Fase 1 — fundação visual

- **Arquivos:** `src/index.css`, novos `src/components/ui/*`, documentação Storybook-like local/testes (sem nova dependência inicialmente).
- **Objetivo:** tokens, tipografia e Button/Field/Card/Dialog/Alert/AsyncState.
- **Resultado:** primitives acessíveis sem mudar regras.
- **Dependências:** aprovação de paleta e escala.
- **Riscos:** regressão por alterar fonte-base global; migrar por escopo, não por “big bang”.
- **Validação:** testes de componente, contraste e zoom 200%.
- **Esforço:** médio/grande.

## Fase 2 — estrutura principal

- **Arquivos:** `MainLayout.tsx`, `Sidebar.tsx`, `AppLayout.tsx`, `FeatureRenderer.tsx`, `useUIStore.ts`.
- **Objetivo:** shell legível, navegação previsível e mobile.
- **Resultado:** título contextual, menu simplificado, foco e estados consistentes.
- **Dependências:** primitives da Fase 1 e decisão de taxonomia.
- **Riscos:** permissões e modos condicionais; não alterar guards.
- **Validação:** matriz de perfis professor/gestor/admin e teclado.
- **Esforço:** grande.

## Fase 3 — tela-piloto Home

- **Arquivos:** `features/Home/HomePage.tsx` e componentes novos exclusivos/compartilhados.
- **Objetivo:** comprovar padrão em cards, ações, estados e responsividade.
- **Resultado:** início orientado a tarefas, recentes e continuidade.
- **Dependências:** Fases 1–2.
- **Riscos:** baixo; preservar `setActiveMode` e permissões.
- **Validação:** teste com 5–8 professores, métricas de descoberta e smoke.
- **Esforço:** médio.

## Fase 4 — fluxos principais

- **Arquivos:** `features/Planning/*`, `TermPlanning/*`, `Assessment/*`, `PDI/*`, `CleanChat.tsx`.
- **Objetivo:** reduzir carga, padronizar IA, formulários e revisão.
- **Resultado:** fluxos progressivos com salvamento/erro/loading claros.
- **Dependências:** piloto aprovado e contratos de dados congelados.
- **Riscos:** altos em PDI e geração; trabalhar atrás de feature flag visual.
- **Validação:** testes existentes, cenários E2E e comparação de payloads.
- **Esforço:** muito grande, dividido por domínio.

## Fase 5 — telas secundárias

- **Arquivos:** settings, perfil, documentos, turmas, gestão, assinatura e admin.
- **Objetivo:** consistência total sem tocar em pagamento, auth ou permissões.
- **Resultado:** páginas/modais alinhados ao sistema.
- **Dependências:** componentes maduros.
- **Riscos:** crítico em assinatura/admin; revisão especializada.
- **Validação:** matriz de papéis, sandbox Stripe e fixtures.
- **Esforço:** grande.

## Fase 6 — acessibilidade, desempenho e refinamento

- **Arquivos:** transversal, PWA e assets.
- **Objetivo:** WCAG 2.2 AA, teclado, leitores de tela, bundles e mobile.
- **Resultado:** axe sem violações críticas, foco completo, loading resiliente e metas de performance.
- **Dependências:** migrações concluídas.
- **Riscos:** falsos positivos e regressões de cache/PWA.
- **Validação:** Lighthouse/axe, NVDA/VoiceOver, reduced motion, rede lenta e dispositivos reais.
- **Esforço:** médio/grande.

## Ordem operacional

Cada PR deve ser pequeno, visualmente comparável, sem alterações em payloads/serviços. Executar typecheck, testes do domínio e smoke de perfis. Nunca misturar redesign com migração de dados, autenticação ou cobrança.
