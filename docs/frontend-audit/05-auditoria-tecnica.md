# Auditoria técnica do frontend

## Indicadores estáticos

- 344 ocorrências de `<button>`, 212 controles de formulário, 184 labels e somente 34 ocorrências de ARIA/roles em `src`.
- 70 estilos inline, concentrados principalmente na landing e em visuais de impressão.
- 375 ocorrências de `any`; 582 chamadas `console.log/warn/error` em TS/TSX (incluem serviços e diagnóstico).
- Maiores componentes: `LandingPage` 1.641 linhas, `PlanningManager` 935, `PlanningCockpit` 908, `ClassManagement` 660, `PresentationCreator` 601 e `TermPlanningManager` 583.

As contagens são sinais para revisão, não provas automáticas de defeito.

## Achados

| Área/arquivo | Problema | Gravidade | Recomendação | Risco | Esforço |
|---|---|---|---|---|---|
| `PlanningManager.tsx` | estado, orquestração, IA e apresentação no mesmo componente | alta | extrair controller hooks e painéis por responsabilidade | alto | grande |
| `PlanningCockpit.tsx` | 908 linhas e muitas interações/modais | alta | decompor por fluxo e estado de máquina explícito | médio | grande |
| `LandingPage.tsx` | CSS embutido, dados e markup em 1.641 linhas | média | separar seções/dados e stylesheet scoped | baixo | médio |
| gestão/turmas/PDI | componentes de 300–660 linhas com dados e UI misturados | alta | containers + componentes puros + hooks de domínio | alto | grande |
| `FeatureRenderer.tsx` | condicional extensa e fallback genérico para modos | alta | registry tipado de features e rota por modo | médio | médio |
| `ToolMode` | modos órfãos/ambíguos | média | inventário com telemetria antes de remover | médio | pequeno |
| Tipos | 375 `any`, inclusive sessão e criação dinâmica | alta | contratos de sessão, perfis, lazy modules e responses | alto | grande |
| Logs | 582 consoles potenciais | alta | logger por ambiente, redaction e níveis | alto | médio |
| UI compartilhada | ausência de Button/Field/Dialog/Card/Table comuns | alta | primitives locais sobre Tailwind | baixo | médio |
| Acessibilidade | sem enforcement e cobertura parcial | alta | eslint jsx-a11y efetivo + testes Testing Library/axe | baixo | médio |
| Rotas | estado interno não navegável | alta | rotas filhas e lazy boundaries por feature | médio | grande |
| Loading/error | loaders duplicados; erros dispersos | média | AsyncState, ErrorNotice e error boundaries por domínio | médio | médio |
| CSS | dois sistemas (`src/index.css` e `app/globals.css`) | média | declarar Vite como fonte ativa; arquivar legado após validação | baixo | pequeno |
| Build | `build` usa `npx vite build` mesmo com Vite local | baixa | futuramente usar `vite build` para resolução determinística | baixo | pequeno |
| Lint | script `lint` é somente TypeScript | média | configurar ESLint já presente na raiz, sem trocar framework | baixo | médio |
| Performance | lazy loading bom, mas features agregam PDFs, DOCX, canvas e IA | média | manter lazy, medir bundles e importar exportadores sob demanda | médio | médio |
| Imagens/PWA | logos e vídeo grandes; múltiplas variantes | média | dimensões, formatos modernos, preload seletivo e auditoria de cache | médio | médio |
| Chaves de lista | não foi validado cada loop | média | regra React e revisão automatizada | baixo | pequeno |

## Pontos positivos

Há lazy loading em rotas e features, chunks manuais para dependências pesadas, ErrorBoundary global, schemas Zod, testes de serviços/componentes, separação parcial por domínio, Zustand seletivo e suporte PWA/Capacitor. A refatoração deve preservar essas escolhas.

## Limites desta etapa

Não foram executados profiler, Lighthouse, axe, build, testes ou lint. Desempenho em runtime, contraste renderizado, foco real, keys e comportamento em dispositivos precisam ser validados na Fase 0/6.
